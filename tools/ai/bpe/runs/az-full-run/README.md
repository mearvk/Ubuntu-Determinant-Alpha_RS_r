# BPE run snapshot: az-full-run

A committed snapshot of one full end-to-end run of the BPE vocabulary-growth
pipeline against the complete A–Z Webster's 1913 dictionary. See the top-level
[`VOCABULARY.md`](../../../../VOCABULARY.md) for the formatted results and the
table of defined words.

## Files
- `definitions.json` — per-new-token classification (`defined` / `needs_definition` / `subword`) with Webster's 1913 definitions.
- `new_tokens.json` — the 579 tokens learned beyond the 128K LLaMA-3 seed.
- `merges.txt` — the BPE merge rules learned in this run.
- `growth_report.json` — the seed-growth trajectory (128,256 → 128,315).

## How it was produced
```sh
# regenerate the A–Z dictionary
python3 tools/ai/bpe/parse_webster.py \
  --in  tools/ai/bpe/data/webster1913_A.txt tools/ai/bpe/data/dictionary-csv/[B-Z].csv \
  --out tools/ai/bpe/data/webster1913.json

# extract the LLaMA-3 seed
python3 tools/ai/bpe/extract_seed_vocab.py \
  --gguf tools/ai/llama.cpp/models/ggml-vocab-llama-bpe.gguf \
  --out  tools/ai/bpe/out/seed_vocab.txt

# train BPE on a balanced A–Z corpus (~25k words)
python3 tools/ai/bpe/train_bpe.py \
  --corpus tools/ai/bpe/out/corpus_az_run.txt \
  --seed-vocab tools/ai/bpe/out/seed_vocab.txt \
  --target-vocab-size 3000 --min-pair-freq 3 \
  --out-dir tools/ai/bpe/out

# define the new tokens from the full A–Z dictionary
python3 tools/ai/bpe/define_new_tokens.py \
  --new-tokens tools/ai/bpe/out/new_tokens.json \
  --dict tools/ai/bpe/data/webster1913.json \
  --out tools/ai/bpe/out/definitions.json

# grow the seed
python3 tools/ai/bpe/grow_seed.py \
  --corpus out/corpus_az_run.txt --seed-in out/seed_vocab.txt \
  --seed-out out/seed_grown.txt --report out/growth_report.json
```

Live artifacts under `tools/ai/bpe/out/` are git-ignored; this directory is a
retained snapshot of the above run.
