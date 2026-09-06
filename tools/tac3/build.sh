#!/usr/bin/env bash
# Build tac3ctl — the userspace TAC3 diagnostic — from the portable C++ engine.
# Mirrors tools/size/build.sh: prefer the repo's own GCC if present, else cc/c++.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SRCDIR="$ROOT/tools/tac3"
OUT="$SRCDIR/tac3ctl"

CXX="${MEARVK_GXX:-}"
if [[ -z "$CXX" ]]; then
  for candidate in \
    "$ROOT/tools/gcc/build/gcc/xg++" \
    "$ROOT/tools/gcc/build/gcc/g++" \
    "$ROOT/tools/gcc/gcc-16.2.0/build/gcc/xg++" \
    "$ROOT/tools/gcc/gcc-16.2.0/build/gcc/g++"; do
    if [[ -x "$candidate" ]]; then CXX="$candidate"; break; fi
  done
fi
if [[ -z "$CXX" ]]; then CXX="${CXX:-c++}"; fi

CXXFLAGS=(-std=c++17 -Wall -Wextra -O2 -I"$SRCDIR")
"$CXX" "${CXXFLAGS[@]}" -o "$OUT" "$SRCDIR/tac3ctl.cpp" "$SRCDIR/tac3.cpp"
printf 'built %s with %s\n' "$OUT" "$CXX"
