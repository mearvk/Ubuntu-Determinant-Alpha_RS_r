# VOCABULARY_GROWTH.md — the initial vocabulary-growth reference for the language/reasoning model

This document records the vocabulary sets **already vendored** in
`tools/ai/llama.cpp/models/` and lays out, honestly, what "growing the
vocabulary" of a language/reasoning model does and does not mean. It is the
factual companion to §8 of `tools/ai/llama.cpp/DESCRIPTIVE.md` and §7 of
`tools/ai/DISPERSIONS.md`.

Every number below was read directly from the GGUF headers in the repository
(`tokenizer.ggml.tokens` array length and `tokenizer.ggml.model`), not estimated.

---

## 1. Why nothing was pulled from outside

Two hard constraints govern this:

1. **The build/sandbox network is integrations-only.** External hosts such as
   `huggingface.co` are unreachable (they return `403 CONNECT tunnel failed`).
   Only the GitHub integration is available. So a tokenizer cannot be fetched
   from an external model hub here.

2. **The larger vocabulary sets are already vendored.** The richest tokenizer in
   common use — Gemma's ~262K-token vocabulary — is already present, along with a
   full ladder of smaller ones. There was nothing warranted to pull: the "larger
   vocabulary set for initial growth" already exists in-tree, and all files are
   comfortably under the 50 MB GitHub file limit (largest is ~15.8 MB).

---

## 2. The vocabulary-growth ladder already in the repo

Sorted from smallest to largest vocabulary. These are **tokenizer/vocabulary
fixtures** (GGUF files carrying only the tokenizer, used for tokenizer tests),
not full models.

| Vocabulary (tokens) | Tokenizer model | File size | File |
| ---: | :--- | ---: | :--- |
| 30,522 | bert | 0.63 MB | `ggml-vocab-bert-bge.gguf` |
| 32,000 | llama (SPM) | 0.72 MB | `ggml-vocab-llama-spm.gguf` |
| 32,064 | llama | 0.73 MB | `ggml-vocab-phi-3.gguf` |
| 32,256 | gpt2 | 1.16 MB | `ggml-vocab-deepseek-coder.gguf` |
| 49,152 | gpt2 | 1.72 MB | `ggml-vocab-starcoder.gguf` |
| 49,216 | gpt2 | 1.72 MB | `ggml-vocab-refact.gguf` |
| 50,257 | gpt2 | 1.77 MB | `ggml-vocab-gpt-2.gguf` |
| 50,432 | gpt2 | 1.77 MB | `ggml-vocab-gpt-neox.gguf` |
| 50,432 | gpt2 | 1.77 MB | `ggml-vocab-mpt.gguf` |
| 64,000 | llama | 1.34 MB | `ggml-vocab-baichuan.gguf` |
| 65,024 | gpt2 | 2.29 MB | `ggml-vocab-falcon.gguf` |
| 100,008 | gpt2 | 4.83 MB | `ggml-vocab-aquila.gguf` |
| 102,400 | gpt2 | 3.97 MB | `ggml-vocab-deepseek-llm.gguf` |
| 128,256 | gpt2 | 7.82 MB | `ggml-vocab-llama-bpe.gguf` |
| 151,936 | gpt2 | 5.93 MB | `ggml-vocab-qwen2.gguf` |
| 151,936 | gpt2 | 5.93 MB | `ggml-vocab-qwen35.gguf` |
| 250,048 | t5 | 6.82 MB | `ggml-vocab-nomic-bert-moe.gguf` |
| 256,000 | gpt2 | 10.87 MB | `ggml-vocab-command-r.gguf` |
| **262,144** | **gemma4** | **15.78 MB** | **`ggml-vocab-gemma-4.gguf`** |

**Growth range available in-tree: ~30.5K → ~262K tokens** — an ~8.6× span. The
LLaMA lineage itself is represented at both ends of its own history: the 32K
SentencePiece vocabulary (`llama-spm`) and the 128K BPE vocabulary
(`llama-bpe`).

### Recommended baseline for an "initial growth" reference
- **LLaMA-native, modern:** `ggml-vocab-llama-bpe.gguf` — 128,256 tokens.
- **Largest available (observe with a richer vocabulary):**
  `ggml-vocab-gemma-4.gguf` — 262,144 tokens.

---

## 3. What "growing the vocabulary" actually entails (the honest part)

A vocabulary/tokenizer is only the lookup table between text and integer token
IDs. It is **not** where reasoning lives. The reasoning is in the trained
weights, and those weights are *indexed by* the vocabulary:

- The input **embedding matrix** has shape `[n_vocab, n_embd]` — one learned row
  per token.
- The output projection maps the final hidden state to one logit per token.

Consequences that must be stated plainly:

1. **You cannot simply attach a larger vocabulary to an existing model and get a
   smarter model.** If the token↔ID mapping changes, the existing embedding rows
   no longer correspond to the right tokens, and output is garbage. This inference
   engine (`llama.cpp`) does not — and cannot — retrofit a new vocabulary onto
   pre-trained weights.

2. **Real vocabulary growth is a training-time operation**, in this order:
   1. Train a new tokenizer (BPE/Unigram/SentencePiece) on a target corpus to the
      desired vocabulary size.
   2. Produce a new vocabulary/model GGUF for it.
   3. Train (or at minimum re-initialize and train) the embedding and output
      layers — in practice, train the model — so the weights are consistent with
      the new token set.
   None of steps 1–3 are inference; they require training compute that is not part
   of this engine or this sandbox.

3. **Effect on reasoning is bounded, not a lever.** A richer vocabulary shortens
   sequences (each token carries more meaning), improves coverage of code, math
   symbols, and non-Latin scripts, and reduces tokenization artifacts. It grows
   the embedding/output parameter count linearly in `n_vocab`, and it can *worsen*
   rare-token quality by spreading training signal thinner. The useful vocabulary
   size **scales with model size**. It improves *how meaning is packed*, not the
   reasoning ceiling, which is set by depth, width, training data, and alignment.

---

## 4. How to inspect these vocabularies

The token counts in §2 come from the GGUF `tokenizer.ggml.tokens` array. To
tokenize sample text against any of these vocabularies using the engine's own
test harness (after a build):

```sh
# from tools/ai/llama.cpp
./build/bin/llama-tokenize --vocab-only \
  -m models/ggml-vocab-gemma-4.gguf \
  -p "the quick brown fox"
```

There are also paired `*.gguf.inp` / `*.gguf.out` fixtures for some vocabularies
(e.g. `ggml-vocab-bert-bge.gguf.inp/.out`) that record expected tokenizations.

---

## 5. Summary

- The requested "larger vocabulary set for initial growth" is **already in the
  repository**; the largest is Gemma at 262,144 tokens (15.78 MB). Nothing needed
  to be pulled — and external pulls are blocked by the sandbox network anyway.
- The complete in-tree ladder spans ~30.5K → ~262K tokens.
- Attaching a larger vocabulary does **not** grow a pre-trained model's
  intelligence; genuine growth is a train-a-tokenizer → new-GGUF → retrain-weights
  pipeline, which is a training task, not an inference task.
- For an initial-growth *reference baseline*, use `ggml-vocab-llama-bpe.gguf`
  (128K, LLaMA-native) or, for the richest available, `ggml-vocab-gemma-4.gguf`
  (262K).
