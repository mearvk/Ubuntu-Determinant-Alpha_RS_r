#!/usr/bin/env bash
set -euo pipefail
PREFIX="${PREFIX:-/usr/local/bin}"
CC="${CC:-cc}"
CXX="${CXX:-c++}"
mkdir -p "$PREFIX"
"$CC"  -O2 -Wall -Wextra -Werror -std=c11   -c muntutils_fs.c    -o muntutils_fs.o
"$CXX" -O2 -Wall -Wextra -Werror -std=c++17 -c muntutils_trim.cpp -o muntutils_trim.o
"$CXX" -O2 -Wall -Wextra -Werror -std=c++17 -c main.cpp          -o main.o
"$CXX" -O2 -Wall -Wextra -Werror -std=c++17 -o muntutils muntutils_fs.o muntutils_trim.o main.o
install -m 0755 muntutils "$PREFIX/muntutils"
echo "muntutils installed to $PREFIX/muntutils"
