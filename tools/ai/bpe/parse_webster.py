#!/usr/bin/env python3
"""
parse_webster.py — convert Webster's 1913 (public domain) plain-text entries into
the local dictionary JSON format that define_new_tokens.py consumes.

Input format (one entry per line), as distributed in the GCIDE / Webster 1913
public-domain text:

    Headword (part-of-speech) Definition text...

Examples:
    Abandon (v. t.) To cast or drive out; to banish; to expel; to reject.
    Aback (adv.) Toward the back or rear; backward.
    A () The first letter of the English ... alphabets.

Rules:
* The headword is the text before the first "(".  Multi-word headwords
  (e.g. "Aaron's rod", "A B C") are preserved.
* The parenthetical is the part of speech (may be empty as "()").
* Everything after the ")" is the definition.
* Multiple senses of the same headword are merged; the first sense becomes the
  primary "definition" and the rest are kept under "senses".
* Output: {"word": {"definition": "...", "pos": "...", "senses": [...]}, ...}
  keyed by the lower-cased headword — matching define_new_tokens.py's lookup.

Pure standard library. No network.
"""

from __future__ import annotations

import argparse
import json
import re
import sys

ENTRY_RE = re.compile(r"^\s*(?P<head>.+?)\s*\((?P<pos>[^)]*)\)\s*(?P<defn>.*)$")


def parse_lines(lines, entries=None, order=None):
    if entries is None:
        entries = {}
    if order is None:
        order = []
    for raw in lines:
        line = raw.rstrip("\n")
        if not line.strip():
            continue
        m = ENTRY_RE.match(line)
        if not m:
            continue
        head = m.group("head").strip().strip('"')
        pos = m.group("pos").strip()
        defn = m.group("defn").strip().strip('"').strip()
        if not head:
            continue
        key = head.lower()
        sense = {"pos": pos, "definition": defn}
        if key not in entries:
            entries[key] = {
                "word": head,
                "pos": pos,
                "definition": defn,
                "senses": [sense],
            }
            order.append(key)
        else:
            entries[key]["senses"].append(sense)
            # keep the first non-empty definition as primary
            if not entries[key]["definition"] and defn:
                entries[key]["definition"] = defn
    return entries, order


def main() -> int:
    ap = argparse.ArgumentParser(
        description="Convert Webster's 1913 text entries to dictionary JSON.")
    ap.add_argument("--in", dest="infiles", required=True, nargs="+",
                    help="One or more input text/CSV files of Webster 1913 entries.")
    ap.add_argument("--out", default="tools/ai/bpe/data/webster1913.json")
    ap.add_argument("--compact", action="store_true",
                    help="Write compact {word: definition} form instead of rich objects.")
    args = ap.parse_args()

    entries, order = {}, []
    for path in args.infiles:
        with open(path, "r", encoding="utf-8", errors="replace") as f:
            parse_lines(f, entries, order)

    import os
    os.makedirs(os.path.dirname(args.out) or ".", exist_ok=True)

    if args.compact:
        out = {entries[k]["word"]: entries[k]["definition"] for k in order}
    else:
        out = {entries[k]["word"]: {
            "pos": entries[k]["pos"],
            "definition": entries[k]["definition"],
            "senses": entries[k]["senses"],
        } for k in order}

    with open(args.out, "w", encoding="utf-8") as f:
        json.dump(out, f, ensure_ascii=False, indent=1)

    total_senses = sum(len(entries[k]["senses"]) for k in order)
    print(f"Parsed {len(order)} headwords ({total_senses} senses) -> {args.out}",
          file=sys.stderr)
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
