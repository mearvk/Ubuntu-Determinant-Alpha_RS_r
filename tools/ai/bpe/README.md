# BPE vocabulary-growth toolkit (`tools/ai/bpe/`)

A self-contained, **byte-level Byte-Pair-Encoding (BPE)** pipeline for building an
initial vocabulary-growth model on top of the existing language/reasoning stack.
BPE is the aggressive, merge-based scheme used by GPT-2 and the modern LLaMA-3
tokenizer (`ggml-vocab-llama-bpe.gguf`, 128,256 tokens).

Everything here is **pure Python standard library**. The sandbox/build network is
integrations-only (PyPI and model hubs are blocked), so the toolkit deliberately
avoids `tokenizers`, `sentencepiece`, and any external download. It runs anywhere
Python 3 runs, offline.

> Read `tools/ai/VOCABULARY_GROWTH.md` first. A larger vocabulary shortens
> sequences and improves coverage, but **does not** by itself raise a pre-trained
> model's reasoning ceiling. To be *usable*, a new vocabulary requires model
> (re)training — this toolkit produces the vocabulary/merges and a definitions
> manifest; it does not train weights.

## Scripts

| Script | Purpose |
| --- | --- |
| `extract_seed_vocab.py` | Read the token list from a vendored `*.gguf` (default: the 128K LLaMA-BPE vocab) into a plain seed list. This is "what we already have." |
| `train_bpe.py` | Train byte-level BPE on a corpus up to a target vocab size. Emits `vocab.json`, `merges.txt`, and `new_tokens.json` — the tokens that are **NEW** relative to the seed. |
| `define_new_tokens.py` | Look up definitions for the **new whole-word** tokens using a **local** dictionary source. Never invents meanings: unmatched words are marked `needs_definition`. |
| `grow_seed.py` | Iteratively **grow the seed toward improvement**: train on a corpus, fold the round's new tokens back into the seed, repeat until the corpus yields nothing new (convergence). Writes a grown seed and a `growth_report.json` trajectory. |

## Growing the seed "toward improvement"

`grow_seed.py` treats vocabulary growth as accumulation. Each round trains BPE on
the corpus, adds the newly discovered tokens to the seed, and repeats; the seed
strictly grows and the count of still-new tokens falls to zero at convergence.
The trajectory is recorded so improvement is measured, not asserted.

```sh
# from tools/ai/bpe/
python3 grow_seed.py \
  --corpus   out/corpus_llamacpp.txt \
  --seed-in  out/seed_vocab.txt \
  --seed-out out/seed_grown.txt \
  --rounds 4 --per-round-target 500 --min-pair-freq 3 \
  --report   out/growth_report.json
```

Example run against the vendored llama.cpp docs corpus:
`round 1: found 97 new, seed 128256 -> 128353 (+97); round 2: 0 new -> converged`.

### On "pull new words from known good sources"
External sources cannot be fetched here: the sandbox network is
integrations-only, so `huggingface.co`, PyPI, and web dictionary APIs are all
blocked, and there is no system word list (`/usr/share/dict/` is empty). The
**known, good source used is local and in-tree**: the vendored llama.cpp
documentation and source under `tools/ai/llama.cpp/` form a real, relevant
technical corpus. New words are mined from it; definitions are attached only from
a local `--dict` file, and any word without an entry is reported
`needs_definition` rather than given a fabricated meaning.

## The two requirements this implements

1. **"Don't pull words we already have."** `train_bpe.py --seed-vocab` loads the
   existing tokens and records a merge as *new* only if the resulting token is not
   already in that seed. Verified: training the sample corpus against the real
   128K LLaMA seed drops new tokens from 417 to 113 — the already-known tokens are
   suppressed.

2. **"Get definitions for the new words as needed."** `define_new_tokens.py`
   defines only the genuinely new whole-word tokens, and only from a known, local
   source. Words with no entry are flagged `needs_definition` rather than given a
   fabricated gloss.

## End-to-end example

```sh
# from the repo root

# 1. Extract the seed vocabulary we already ship (128,256 LLaMA-BPE tokens).
python3 tools/ai/bpe/extract_seed_vocab.py \
  --gguf tools/ai/llama.cpp/models/ggml-vocab-llama-bpe.gguf \
  --out  tools/ai/bpe/out/seed_vocab.txt

# 2. Train BPE on your corpus; only tokens NOT already in the seed are "new".
python3 tools/ai/bpe/train_bpe.py \
  --corpus            tools/ai/bpe/samples/corpus.txt \
  --seed-vocab        tools/ai/bpe/out/seed_vocab.txt \
  --target-vocab-size 2000 \
  --min-pair-freq     1 \
  --out-dir           tools/ai/bpe/out

# 3. Define the new whole-word tokens from a LOCAL dictionary source.
python3 tools/ai/bpe/define_new_tokens.py \
  --new-tokens  tools/ai/bpe/out/new_tokens.json \
  --dict        tools/ai/bpe/samples/dictionary.json \
  --source-name "samples/dictionary.json" \
  --out         tools/ai/bpe/out/definitions.json
```

Outputs land in `tools/ai/bpe/out/` (git-ignored; regenerate any time):

* `vocab.json` — `{token: id}` for the full trained vocabulary.
* `merges.txt` — ordered BPE merge rules.
* `new_tokens.json` — tokens new relative to the seed.
* `definitions.json` — per-new-word manifest: `defined` / `needs_definition` / `subword`.

## The "known, good source of vocabulary content"

The full **Webster's 1913 dictionary** (public domain) ships in `data/`:

* `data/webster1913_A.txt` — the A-section (starter slice, `Headword (pos) definition` text).
* `data/dictionary-csv/B.csv` … `Z.csv` — the B–Z sections, sourced from
  [karthikramx/snippable-dictionary](https://github.com/karthikramx/snippable-dictionary/tree/main/Dictionary-in-csv)
  (same `Headword (pos) definition` format, 14 MB total, each file well under
  the 50 MB limit).

`parse_webster.py` converts all of these (it accepts multiple `--in` files) into
one combined dictionary JSON the pipeline consumes:

```sh
python3 tools/ai/bpe/parse_webster.py \
  --in  tools/ai/bpe/data/webster1913_A.txt tools/ai/bpe/data/dictionary-csv/[B-Z].csv \
  --out tools/ai/bpe/data/webster1913.json
```

This yields **104,052 headwords / 164,648 senses** covering A–Z. The generated
`webster1913.json` is ~32 MB and is **git-ignored** (it is derivable from the raw
sources above); regenerate it with the command shown before running
`define_new_tokens.py --dict tools/ai/bpe/data/webster1913.json`.

Verified full-dictionary run: spot checks resolve real definitions across the
whole alphabet — e.g. *beautiful, courage, dragon, elephant, justice, ocean,
science, universe, zebra* — and the earlier A-section run defined 114 new tokens
(Abandon, Achieve, Avarice, …). Words absent from the source are still flagged
`needs_definition`; no meanings are fabricated.

Because external dictionary APIs are unreachable here, the definition source is a
**local file** supplied via `--dict` (Webster's above, or your own). Supported
formats:

* JSON object `{ "word": "definition", ... }`
* JSON object `{ "word": {"definition": "...", "pos": "..."}, ... }`
* JSONL: one `{"word": ..., "definition": ...}` per line
* `word<TAB>definition` or `word,definition` per line

`samples/dictionary.json` is a tiny illustrative source. For a real run, point
`--dict` at a full local dictionary export (e.g. a WordNet-derived JSON) — matching
is case-insensitive, and any new word absent from the source is reported as
`needs_definition` so gaps are explicit rather than fabricated.

## Sample data

* `samples/corpus.txt` — a small demonstration corpus.
* `samples/dictionary.json` — a small demonstration dictionary.

Replace both with your own corpus and dictionary for a real growth run.
