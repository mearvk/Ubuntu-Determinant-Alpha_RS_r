#!/usr/bin/env bash
set -euo pipefail
PREFIX="${PREFIX:-/usr/local/bin}"
CC="${CC:-cc}"
mkdir -p "$PREFIX"
"$CC" -O2 -Wall -Wextra -Werror -std=c11 -o limit limit.c
install -m 0755 limit "$PREFIX/limit"
echo "limit installed to $PREFIX/limit"
