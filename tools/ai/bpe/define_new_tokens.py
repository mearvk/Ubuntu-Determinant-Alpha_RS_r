#!/usr/bin/env python3
"""
define_new_tokens.py — attach definitions to the NEW whole-word tokens produced
by train_bpe.py, using a KNOWN, LOCAL, good source of vocabulary content.

Why local-only?
---------------
The sandbox/build network is integrations-only: external dictionary APIs and
model hubs are blocked. So this tool reads a dictionary from a LOCAL file that
the operator (or CI) supplies. It never invents meanings: a token with no entry
in the supplied source is emitted with status "needs_definition" rather than a
fabricated gloss.

"Don't pull words we already have"
----------------------------------
Input is new_tokens.json (the tokens train_bpe.py flagged as NOT already in the
seed vocabulary). We only look up definitions for those, so we never re-fetch or
re-define words the vocabulary already contained.

Supported dictionary source formats (--dict)
---------------------------------------------
* JSON object:  {"word": "definition", ...}
* JSON object:  {"word": {"definition": "...", "pos": "...", ...}, ...}
* JSONL:        one {"word": ..., "definition": ...} object per line
* TSV/CSV-ish:  "word<TAB>definition" per line

Output
------
definitions.json: a manifest with one record per NEW whole-word token:
  { token, readable, word, status, source, definition }
plus a summary of coverage.
"""

from __future__ import annotations

import argparse
import json
import os
import sys
from typing import Dict, Optional


def load_dictionary(path: Optional[str]) -> Dict[str, str]:
    """Load a local dictionary into {normalized_word: definition}."""
    if not path:
        return {}
    if not os.path.exists(path):
        print(f"[dict] warning: dictionary not found at {path}; "
              f"all new words will be status=needs_definition", file=sys.stderr)
        return {}

    with open(path, "r", encoding="utf-8", errors="replace") as f:
        text = f.read()

    stripped = text.lstrip()
    result: Dict[str, str] = {}

    # Try a single JSON document first.
    if stripped[:1] in "[{":
        try:
            data = json.loads(text)
            if isinstance(data, dict):
                for w, v in data.items():
                    result[_norm(w)] = _extract_def(v)
                return result
            if isinstance(data, list):
                for entry in data:
                    if isinstance(entry, dict) and "word" in entry:
                        result[_norm(entry["word"])] = _extract_def(entry)
                return result
        except json.JSONDecodeError:
            pass  # fall through to line-based parsing

    # Line-based: JSONL, or word<TAB>definition, or word,definition.
    for line in text.splitlines():
        line = line.rstrip("\n")
        if not line.strip():
            continue
        s = line.lstrip()
        if s[:1] == "{":
            try:
                entry = json.loads(s)
                if isinstance(entry, dict) and "word" in entry:
                    result[_norm(entry["word"])] = _extract_def(entry)
                    continue
            except json.JSONDecodeError:
                pass
        if "\t" in line:
            w, _, d = line.partition("\t")
        elif "," in line:
            w, _, d = line.partition(",")
        else:
            continue
        result[_norm(w)] = d.strip()
    return result


def _extract_def(v) -> str:
    if isinstance(v, str):
        return v.strip()
    if isinstance(v, dict):
        for key in ("definition", "def", "meaning", "gloss", "sense"):
            if key in v and isinstance(v[key], str):
                return v[key].strip()
        # WordNet-ish: list of senses
        if "senses" in v and isinstance(v["senses"], list) and v["senses"]:
            first = v["senses"][0]
            if isinstance(first, str):
                return first.strip()
            if isinstance(first, dict):
                return _extract_def(first)
    return ""


def _norm(word: str) -> str:
    return str(word).strip().lower()


def token_to_word(record: dict) -> Optional[str]:
    """
    Turn a BPE token into a candidate dictionary headword.

    We only define WHOLE-WORD tokens: those that began with the space marker 'Ġ'
    (a new word boundary) and contain only letters after it. Sub-word fragments
    (no leading boundary, or containing byte artifacts) are not dictionary words
    and are skipped as 'subword'.
    """
    readable = record.get("readable", "")
    tok = record.get("token", "")
    had_boundary = tok.startswith("Ġ") or readable.startswith(" ")
    word = readable.strip()
    if not had_boundary:
        return None
    if not word.isalpha():
        return None
    if len(word) < 2:
        return None
    return word


def main() -> int:
    ap = argparse.ArgumentParser(
        description="Attach local-dictionary definitions to NEW BPE word tokens.")
    ap.add_argument("--new-tokens", required=True,
                    help="new_tokens.json produced by train_bpe.py")
    ap.add_argument("--dict", default=None,
                    help="Local dictionary source (json/jsonl/tsv/csv). "
                         "If omitted, all words are marked needs_definition.")
    ap.add_argument("--source-name", default="local-dictionary",
                    help="Label recorded as the definition source.")
    ap.add_argument("--out", default="tools/ai/bpe/out/definitions.json")
    args = ap.parse_args()

    with open(args.new_tokens, "r", encoding="utf-8") as f:
        new_tokens = json.load(f)

    dictionary = load_dictionary(args.dict)

    records = []
    defined = subword = missing = 0
    for rec in new_tokens:
        word = token_to_word(rec)
        if word is None:
            subword += 1
            records.append({
                "token": rec.get("token", ""),
                "readable": rec.get("readable", ""),
                "word": None,
                "status": "subword",
                "source": None,
                "definition": None,
            })
            continue
        definition = dictionary.get(_norm(word))
        if definition:
            defined += 1
            status, source = "defined", args.source_name
        else:
            missing += 1
            status, source, definition = "needs_definition", None, None
        records.append({
            "token": rec.get("token", ""),
            "readable": rec.get("readable", ""),
            "word": word,
            "status": status,
            "source": source,
            "definition": definition,
        })

    os.makedirs(os.path.dirname(args.out) or ".", exist_ok=True)
    manifest = {
        "summary": {
            "total_new_tokens": len(new_tokens),
            "whole_words": defined + missing,
            "defined": defined,
            "needs_definition": missing,
            "subword_fragments": subword,
            "dictionary_source": args.source_name if dictionary else None,
            "dictionary_entries": len(dictionary),
        },
        "records": records,
    }
    with open(args.out, "w", encoding="utf-8") as f:
        json.dump(manifest, f, ensure_ascii=False, indent=2)

    s = manifest["summary"]
    print(f"New tokens: {s['total_new_tokens']} | whole-words: {s['whole_words']} "
          f"(defined {s['defined']}, needs_definition {s['needs_definition']}) | "
          f"subword fragments: {s['subword_fragments']}")
    print(f"Wrote {args.out}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
