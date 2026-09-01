#!/usr/bin/env bash
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DIR="$ROOT/tools/muntutils"
OUT="$DIR/muntutils"

# Derived C compiler search (MEARVK_GCC override, then repository candidates,
# then system gcc fallback).
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

# Derived C++ compiler search (MEARVK_GXX override, then repository candidates,
# then system g++ fallback).
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
if [[ -z "$CXX" ]]; then CXX="${CXX:-g++}"; fi

CFLAGS=(-std=c11 -Wall -Wextra -Werror -O2)
CXXFLAGS=(-std=c++17 -Wall -Wextra -Werror -O2)

meta_for() {
  # $1 = source path relative to repository root
  printf '%s\n' \
    -fme-metadata \
    -fme-metadata-edition=Ubuntu.Determinant.Beta.Restricted \
    -fme-metadata-version=1.00 \
    -fme-metadata-company=MEARVK \
    "-fme-metadata-source=$1"
}

C_OBJ="$DIR/muntutils_fs.o"
CXX_OBJ_TRIM="$DIR/muntutils_trim.o"
CXX_OBJ_MAIN="$DIR/main.o"

if "$CC" --help=common 2>/dev/null | grep -q -- '-fme-metadata'; then
  mapfile -t META_FS   < <(meta_for tools/muntutils/muntutils_fs.c)
  mapfile -t META_TRIM < <(meta_for tools/muntutils/muntutils_trim.cpp)
  mapfile -t META_MAIN < <(meta_for tools/muntutils/main.cpp)
  "$CC"  "${CFLAGS[@]}"   "${META_FS[@]}"   -c "$DIR/muntutils_fs.c"   -o "$C_OBJ"
  "$CXX" "${CXXFLAGS[@]}" "${META_TRIM[@]}" -c "$DIR/muntutils_trim.cpp" -o "$CXX_OBJ_TRIM"
  "$CXX" "${CXXFLAGS[@]}" "${META_MAIN[@]}" -c "$DIR/main.cpp"          -o "$CXX_OBJ_MAIN"
else
  echo "warning: selected compiler does not advertise -fme-metadata; building without metadata emission" >&2
  "$CC"  "${CFLAGS[@]}"   -c "$DIR/muntutils_fs.c"   -o "$C_OBJ"
  "$CXX" "${CXXFLAGS[@]}" -c "$DIR/muntutils_trim.cpp" -o "$CXX_OBJ_TRIM"
  "$CXX" "${CXXFLAGS[@]}" -c "$DIR/main.cpp"          -o "$CXX_OBJ_MAIN"
fi

# Link with the C++ compiler so the C and C++ objects combine into one binary.
"$CXX" "${CXXFLAGS[@]}" -o "$OUT" "$C_OBJ" "$CXX_OBJ_TRIM" "$CXX_OBJ_MAIN"

printf 'built %s with %s/%s\n' "$OUT" "$CC" "$CXX"
