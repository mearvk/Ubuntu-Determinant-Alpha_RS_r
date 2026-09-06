#!/usr/bin/env bash
# Install tac3ctl (userspace TAC3 diagnostic). Mirrors tools/size/install.sh.
set -euo pipefail
PREFIX="${PREFIX:-/usr/local/bin}"
CXX="${CXX:-c++}"
HERE="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$PREFIX"
"$CXX" -O2 -Wall -Wextra -std=c++17 -I"$HERE" -o "$HERE/tac3ctl" \
  "$HERE/tac3ctl.cpp" "$HERE/tac3.cpp"
install -m 0755 "$HERE/tac3ctl" "$PREFIX/tac3ctl"
echo "tac3ctl installed to $PREFIX/tac3ctl"
