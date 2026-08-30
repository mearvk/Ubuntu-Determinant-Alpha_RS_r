#!/bin/sh
set -eu
cd "$(dirname "$0")/.."

core_version=$(sed -n 's/^#define XMC_VERSION[[:space:]]*"\([^"]*\)".*/\1/p' xmc.c | head -n 1)
public_version=$(sed -n 's/^#define XMC_VERSION[[:space:]]*"\([^"]*\)".*/\1/p' xmc-version.h | head -n 1)

[ -n "$core_version" ] || { echo "test_version: core version not found" >&2; exit 1; }
[ -n "$public_version" ] || { echo "test_version: public version not found" >&2; exit 1; }
[ "$core_version" = "$public_version" ] || {
    echo "test_version: version mismatch: core=$core_version public=$public_version" >&2
    exit 1
}

if [ -x ./xmc ]; then
    reported=$(./xmc --version | sed -n 's/^xmc //p')
    [ "$reported" = "$public_version" ] || {
        echo "test_version: executable reports $reported, expected $public_version" >&2
        exit 1
    }
fi

echo "test_version: PASS ($public_version)"
