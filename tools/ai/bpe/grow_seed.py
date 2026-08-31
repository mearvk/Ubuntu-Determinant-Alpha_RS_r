#!/usr/bin/env python3
"""
grow_seed.py — iteratively grow the BPE seed vocabulary "toward improvement".

Idea
----
Vocabulary growth is an accumulation process. Starting from the seed we already
have (e.g. the 128K LLaMA-BPE tokens), we run BPE training over a corpus, take
the NEW tokens it discovers, fold them back into the seed, and repeat. Each round
raises the seed size and lowers the count of still-new tokens, until the corpus
stops yielding fresh tokens (convergence) or a round budget is reached.

This is the "increase the seed toward improvement" loop: the seed strictly grows,
and the toolkit reports the trajectory so improvement is measurable rather than
asserted.

Pure standard library. No network. The corpus is a KNOWN, LOCAL source supplied
by the caller (for this repo, the vendored llama.cpp technical docs/source are a
legitimate in-tree corpus).

It shells out to nothing: it imports train_bpe directly.
"""

from __future__ import annotations

import argparse
import json
import os
import sys

import train_bpe as bpe  # same directory


def load_seed_set(path: str) -> set:
    return bpe.load_seed_vocab(path)


def write_seed(path: str, tokens) -> None:
    os.makedirs(os.path.dirname(path) or ".", exist_ok=True)
    with open(path, "w", encoding="utf-8") as f:
        for t in tokens:
            f.write(t.replace("\n", "\\n") + "\n")


def main() -> int:
    ap = argparse.ArgumentParser(description="Iteratively grow the BPE seed vocabulary.")
    ap.add_argument("--corpus", required=True, help="Local corpus file (concatenated text).")
    ap.add_argument("--seed-in", required=True, help="Starting seed vocab (txt/json).")
    ap.add_argument("--seed-out", default="tools/ai/bpe/out/seed_grown.txt",
                    help="Where to write the grown seed.")
    ap.add_argument("--rounds", type=int, default=5, help="Max growth rounds.")
    ap.add_argument("--per-round-target", type=int, default=2000,
                    help="target_vocab_size passed to each training round "
                         "(relative to that round's base symbols).")
    ap.add_argument("--min-pair-freq", type=int, default=2)
    ap.add_argument("--report", default="tools/ai/bpe/out/growth_report.json")
    args = ap.parse_args()

    seed = load_seed_set(args.seed_in)
    start_size = len(seed)
    text = bpe.read_corpus(args.corpus)
    chunks = bpe.pre_tokenize(text)

    trajectory = []
    print(f"[grow] start seed size: {start_size}", file=sys.stderr)

    for rnd in range(1, args.rounds + 1):
        word_freqs = bpe.initial_word_freqs(chunks)
        base_symbols = set()
        for w in word_freqs:
            base_symbols.update(w)
        vocab = set(base_symbols)
        target = len(base_symbols) + args.per_round_target
        new_tokens = []

        while len(vocab) < target:
            pairs = bpe.count_pairs(word_freqs)
            if not pairs:
                break
            best_pair, best_freq = max(pairs.items(), key=lambda kv: (kv[1], kv[0]))
            if best_freq < args.min_pair_freq:
                break
            word_freqs = bpe.merge_pair(word_freqs, best_pair)
            merged = best_pair[0] + best_pair[1]
            vocab.add(merged)
            if merged not in seed:
                new_tokens.append(merged)

        # Fold the round's new tokens into the seed (growth).
        before = len(seed)
        seed.update(new_tokens)
        after = len(seed)
        added = after - before
        trajectory.append({
            "round": rnd,
            "seed_before": before,
            "new_tokens_found": len(new_tokens),
            "seed_after": after,
            "net_added": added,
        })
        print(f"[grow] round {rnd}: found {len(new_tokens)} new, "
              f"seed {before} -> {after} (+{added})", file=sys.stderr)
        if added == 0:
            print(f"[grow] converged at round {rnd} (no net new tokens)", file=sys.stderr)
            break

    write_seed(args.seed_out, sorted(seed))
    report = {
        "corpus": args.corpus,
        "seed_in": args.seed_in,
        "seed_out": args.seed_out,
        "start_seed_size": start_size,
        "final_seed_size": len(seed),
        "total_added": len(seed) - start_size,
        "rounds_run": len(trajectory),
        "trajectory": trajectory,
    }
    os.makedirs(os.path.dirname(args.report) or ".", exist_ok=True)
    with open(args.report, "w", encoding="utf-8") as f:
        json.dump(report, f, ensure_ascii=False, indent=2)

    print(f"[grow] done: seed {start_size} -> {len(seed)} "
          f"(+{len(seed) - start_size}) over {len(trajectory)} rounds", file=sys.stderr)
    print(f"[grow] grown seed: {args.seed_out}")
    print(f"[grow] report:     {args.report}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
