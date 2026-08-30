#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
SRC="$ROOT/tools/size/size.c"
OUT="$ROOT/tools/size/size"
CC="${MEARVK_GCC:-}"
if [[ -z "$CC" ]]; then
  for candidate in \
    "$ROOT/tools/gcc/build/gcc/xgcc" \
    "$ROOT/tools/gcc/build/gcc/gcc" \
    "$ROOT/tools/gcc/gcc-16.2.0/build/gcc/xgcc" \
    "$ROOT/tools/gcc/gcc-16.2.0/build/gcc/gcc"; do
    if [[ -x "$candidate" ]]; then CC="$candidate"; break; fi
done
fi
if [[ -z "$CC" ]]; then CC="${CC:-gcc}"; fi
CFLAGS=(-std=c11 -Wall -Wextra -Werror -O2)
META=( -fme-metadata -fme-metadata-edition=Ubuntu.Determinant.Beta.Restricted -fme-metadata-version=1.01 -fme-metadata-company=MEARVK -fme-metadata-source=tools/size/size.c )
if "$CC" --help=common 2>/dev/null | grep -q -- '-fme-metadata'; then
  "$CC" "${CFLAGS[@]}" "${META[@]}" -o "$OUT" "$SRC"
else
  echo "warning: selected compiler does not advertise -fme-metadata; building without metadata emission" >&2
  "$CC" "${CFLAGS[@]}" -o "$OUT" "$SRC"
fi
printf 'built %s with %s\n' "$OUT" "$CC"
