#!/usr/bin/env python3
"""
extract_seed_vocab.py — read the token list out of a vendored *.gguf vocabulary
file and write it as a plain seed-vocab list (one token per line).

This gives train_bpe.py the set of tokens "we already have" so it will not
re-emit them as NEW. Default target is the modern LLaMA-3 BPE vocabulary
(128,256 tokens) shipped under tools/ai/llama.cpp/models/ggml-vocab-llama-bpe.gguf.

Pure standard library: a minimal GGUF metadata reader that pulls the
`tokenizer.ggml.tokens` string array.
"""

from __future__ import annotations

import argparse
import struct
import sys


def read_gguf_tokens(path: str):
    with open(path, "rb") as f:
        data = f.read()
    if data[:4] != b"GGUF":
        raise ValueError("not a GGUF file")
    off = 4
    _ver = struct.unpack_from("<I", data, off)[0]; off += 4
    _n_tensors = struct.unpack_from("<Q", data, off)[0]; off += 8
    n_kv = struct.unpack_from("<Q", data, off)[0]; off += 8

    def rd_str(o):
        ln = struct.unpack_from("<Q", data, o)[0]; o += 8
        return data[o:o + ln].decode("utf-8", "replace"), o + ln

    scalar_fmt = {0: "<B", 1: "<b", 2: "<H", 3: "<h", 4: "<I", 5: "<i",
                  6: "<f", 7: "<?", 10: "<Q", 11: "<q", 12: "<d"}
    tokens = None
    for _ in range(n_kv):
        key, off = rd_str(off)
        vtype = struct.unpack_from("<I", data, off)[0]; off += 4
        if vtype == 8:  # string
            _, off = rd_str(off)
        elif vtype == 9:  # array
            atype = struct.unpack_from("<I", data, off)[0]; off += 4
            n = struct.unpack_from("<Q", data, off)[0]; off += 8
            if atype == 8:
                arr = []
                for _i in range(n):
                    s, off = rd_str(off)
                    arr.append(s)
                if key == "tokenizer.ggml.tokens":
                    tokens = arr
            else:
                esz = {0: 1, 1: 1, 2: 2, 3: 2, 4: 4, 5: 4, 6: 4,
                       7: 1, 10: 8, 11: 8, 12: 8}[atype]
                off += esz * n
        else:
            off += struct.calcsize(scalar_fmt[vtype])
    if tokens is None:
        raise ValueError("no tokenizer.ggml.tokens array found in GGUF")
    return tokens


def main() -> int:
    ap = argparse.ArgumentParser(description="Extract seed vocab tokens from a GGUF.")
    ap.add_argument(
        "--gguf",
        default="tools/ai/llama.cpp/models/ggml-vocab-llama-bpe.gguf",
        help="GGUF vocabulary file to read the seed tokens from.")
    ap.add_argument("--out", default="tools/ai/bpe/out/seed_vocab.txt")
    args = ap.parse_args()

    tokens = read_gguf_tokens(args.gguf)
    import os
    os.makedirs(os.path.dirname(args.out) or ".", exist_ok=True)
    with open(args.out, "w", encoding="utf-8") as f:
        for t in tokens:
            f.write(t.replace("\n", "\\n") + "\n")
    print(f"Extracted {len(tokens)} seed tokens from {args.gguf} -> {args.out}",
          file=sys.stderr)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
