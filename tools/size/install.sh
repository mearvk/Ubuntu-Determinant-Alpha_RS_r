#!/usr/bin/env bash
set -euo pipefail
PREFIX="${PREFIX:-/usr/local/bin}"
CC="${CC:-cc}"
mkdir -p "$PREFIX"
"$CC" -O2 -Wall -Wextra -Werror -std=c11 -o size size.c
install -m 0755 size "$PREFIX/size"
echo "size installed to $PREFIX/size"
