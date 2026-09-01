#!/usr/bin/env python3
"""
train_bpe.py — a self-contained, byte-level Byte-Pair-Encoding (BPE) trainer for
the initial vocabulary-growth model of the language/reasoning stack under
tools/ai/.

Design goals
------------
* Pure Python standard library only. The sandbox/build network is
  integrations-only (PyPI and model hubs are blocked), so this must run with no
  third-party dependencies for anyone who clones the repo.
* Byte-level BPE (the aggressive, merge-based scheme used by GPT-2 / LLaMA-BPE):
  it starts from raw bytes and greedily merges the most frequent adjacent pair,
  so it can represent *any* input and does not need a fixed word list.
* "Do not re-learn what we already have." A seed vocabulary (the tokens we
  already ship, e.g. from ggml-vocab-llama-bpe.gguf) is loaded first; training
  only records merges/tokens that are genuinely NEW relative to that seed.

This produces a vocabulary + merge table. It does NOT train model weights — see
tools/ai/llama.cpp/VOCABULARY_GROWTH.md for why a new vocabulary requires model training
to be usable, and why enlarging vocabulary alone does not raise the reasoning
ceiling.
"""

from __future__ import annotations

import argparse
import collections
import json
import os
import sys
import time
from typing import Dict, List, Tuple


# ---------------------------------------------------------------------------
# Corpus loading
# ---------------------------------------------------------------------------
def read_corpus(path: str) -> str:
    with open(path, "r", encoding="utf-8", errors="replace") as f:
        return f.read()


# Reserved boundary symbol for "this chunk started a new word" (GPT-2/LLaMA
# style). Kept OUTSIDE the byte encoding so it survives as a real marker and so
# BPE never merges across word/line boundaries.
WORD_BOUNDARY = "Ġ"


def pre_tokenize(text: str) -> List[str]:
    """
    Split text into per-word chunks before byte-level BPE.

    Splitting on ANY whitespace (spaces, tabs, newlines) prevents BPE from
    merging across word or line boundaries. Every chunk carries a leading
    WORD_BOUNDARY marker so whole-word tokens are recognizable later. Punctuation
    stays attached to its word chunk; BPE separates it via merges as frequencies
    dictate.
    """
    chunks: List[str] = []
    for raw in text.split():  # splits on any run of whitespace, drops empties
        chunks.append(WORD_BOUNDARY + raw)
    return chunks


# ---------------------------------------------------------------------------
# Seed vocabulary ("what we already have")
# ---------------------------------------------------------------------------
def load_seed_vocab(path: str | None) -> set:
    """
    Load the set of token strings we already ship, so training does not re-emit
    them. Accepts either:
      * a plain text file, one token per line, or
      * a JSON file that is a list of tokens, or a dict {token: id}.
    Returns an empty set if path is None or missing.
    """
    if not path:
        return set()
    if not os.path.exists(path):
        print(f"[seed] warning: seed vocab not found at {path}; proceeding with empty seed",
              file=sys.stderr)
        return set()
    with open(path, "r", encoding="utf-8", errors="replace") as f:
        head = f.read(1)
        f.seek(0)
        if head in "[{":
            data = json.load(f)
            if isinstance(data, dict):
                return set(data.keys())
            return set(map(str, data))
        return {line.rstrip("\n") for line in f if line.strip() != ""}


# ---------------------------------------------------------------------------
# BPE training
# ---------------------------------------------------------------------------
def initial_word_freqs(chunks: List[str]) -> "collections.Counter[Tuple[str, ...]]":
    """
    Represent each pre-token as a tuple of byte-symbols. Byte-level: encode to
    UTF-8, then map each byte to a stable printable symbol so merges are on bytes.
    """
    freqs: "collections.Counter[Tuple[str, ...]]" = collections.Counter()
    for chunk in chunks:
        # Keep the leading WORD_BOUNDARY as its own symbol; byte-encode the rest.
        if chunk.startswith(WORD_BOUNDARY):
            body = chunk[len(WORD_BOUNDARY):]
            symbols = (WORD_BOUNDARY,) + tuple(_byte_symbol(b) for b in body.encode("utf-8"))
        else:
            symbols = tuple(_byte_symbol(b) for b in chunk.encode("utf-8"))
        if symbols:
            freqs[symbols] += 1
    return freqs


def _byte_symbol(b: int) -> str:
    """Map a byte (0..255) to a single stable unicode symbol (GPT-2 style)."""
    # Printable ASCII stays as-is; other bytes map into a private high range.
    if 33 <= b <= 126:
        return chr(b)
    return chr(0x100 + b)


def count_pairs(word_freqs) -> "collections.Counter[Tuple[str, str]]":
    pairs: "collections.Counter[Tuple[str, str]]" = collections.Counter()
    for word, freq in word_freqs.items():
        for a, bsym in zip(word, word[1:]):
            pairs[(a, bsym)] += freq
    return pairs


def merge_pair(word_freqs, pair: Tuple[str, str]):
    a, b = pair
    merged = a + b
    new_freqs: "collections.Counter[Tuple[str, ...]]" = collections.Counter()
    for word, freq in word_freqs.items():
        out: List[str] = []
        i = 0
        while i < len(word):
            if i < len(word) - 1 and word[i] == a and word[i + 1] == b:
                out.append(merged)
                i += 2
            else:
                out.append(word[i])
                i += 1
        new_freqs[tuple(out)] += freq
    return new_freqs


def train(
    corpus_path: str,
    target_vocab_size: int,
    seed_vocab: set,
    min_pair_freq: int = 2,
    verbose: bool = True,
):
    text = read_corpus(corpus_path)
    chunks = pre_tokenize(text)
    word_freqs = initial_word_freqs(chunks)

    # Base vocabulary = all single byte-symbols seen.
    base_symbols = set()
    for word in word_freqs:
        base_symbols.update(word)

    vocab = set(base_symbols)
    merges: List[Tuple[str, str]] = []
    new_tokens: List[str] = []  # tokens produced that are NOT in the seed

    start = time.time()
    # Each merge adds at most one new token; loop until we reach the target or run
    # out of useful pairs.
    while len(vocab) < target_vocab_size:
        pairs = count_pairs(word_freqs)
        if not pairs:
            break
        (best_pair, best_freq) = max(pairs.items(), key=lambda kv: (kv[1], kv[0]))
        if best_freq < min_pair_freq:
            if verbose:
                print(f"[train] stopping: best pair freq {best_freq} < min {min_pair_freq}",
                      file=sys.stderr)
            break
        word_freqs = merge_pair(word_freqs, best_pair)
        merged_token = best_pair[0] + best_pair[1]
        merges.append(best_pair)
        vocab.add(merged_token)
        # Record as NEW only if we did not already ship this token.
        if merged_token not in seed_vocab:
            new_tokens.append(merged_token)

    if verbose:
        print(f"[train] done: {len(merges)} merges, "
              f"{len(vocab)} total tokens, "
              f"{len(new_tokens)} new (not in seed of {len(seed_vocab)}), "
              f"{time.time() - start:.2f}s", file=sys.stderr)

    return {
        "base_symbols": sorted(base_symbols),
        "merges": merges,
        "vocab": sorted(vocab),
        "new_tokens": new_tokens,
    }


def human_token(tok: str) -> str:
    """
    Render a byte-symbol token back to a human-readable form: the leading
    WORD_BOUNDARY marker becomes a space, and high-range byte symbols are
    decoded back to their original bytes/characters where possible.
    """
    out_bytes = bytearray()
    text = ""
    for ch in tok:
        if ch == WORD_BOUNDARY:
            # flush any pending bytes, then emit a space
            text += out_bytes.decode("utf-8", "replace"); out_bytes = bytearray()
            text += " "
        elif 33 <= ord(ch) <= 126:
            out_bytes.append(ord(ch))
        elif 0x100 <= ord(ch) <= 0x1FF:
            out_bytes.append(ord(ch) - 0x100)
        else:
            text += out_bytes.decode("utf-8", "replace"); out_bytes = bytearray()
            text += ch
    text += out_bytes.decode("utf-8", "replace")
    return text


def main() -> int:
    ap = argparse.ArgumentParser(description="Byte-level BPE trainer (stdlib only).")
    ap.add_argument("--corpus", required=True, help="Path to a UTF-8 text corpus.")
    ap.add_argument("--target-vocab-size", type=int, default=40000,
                    help="Stop when total vocabulary reaches this size.")
    ap.add_argument("--seed-vocab", default=None,
                    help="File of tokens we already have (txt or json); NEW tokens "
                         "are those not present here.")
    ap.add_argument("--min-pair-freq", type=int, default=2,
                    help="Do not merge pairs rarer than this.")
    ap.add_argument("--out-dir", default="tools/ai/bpe/out",
                    help="Directory for vocab.json, merges.txt, new_tokens.json.")
    args = ap.parse_args()

    seed = load_seed_vocab(args.seed_vocab)
    result = train(
        corpus_path=args.corpus,
        target_vocab_size=args.target_vocab_size,
        seed_vocab=seed,
        min_pair_freq=args.min_pair_freq,
    )

    os.makedirs(args.out_dir, exist_ok=True)

    vocab_map = {tok: i for i, tok in enumerate(result["vocab"])}
    with open(os.path.join(args.out_dir, "vocab.json"), "w", encoding="utf-8") as f:
        json.dump(vocab_map, f, ensure_ascii=False, indent=0)

    with open(os.path.join(args.out_dir, "merges.txt"), "w", encoding="utf-8") as f:
        f.write("#version: bpe-stdlib-1\n")
        for a, b in result["merges"]:
            f.write(f"{a} {b}\n")

    new_records = [{"token": t, "readable": human_token(t)} for t in result["new_tokens"]]
    with open(os.path.join(args.out_dir, "new_tokens.json"), "w", encoding="utf-8") as f:
        json.dump(new_records, f, ensure_ascii=False, indent=2)

    print(f"Wrote {len(vocab_map)} tokens, {len(result['merges'])} merges, "
          f"{len(new_records)} NEW tokens to {args.out_dir}/")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
