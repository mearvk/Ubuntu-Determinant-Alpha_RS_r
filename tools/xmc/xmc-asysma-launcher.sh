#!/bin/sh
# Launch one localized .asysma package through the XMC runtime adapter.
# The package itself is not treated as an ELF/PE/Mach-O executable.
set -eu

if [ "$#" -ne 1 ]; then
    echo "usage: xmc-asysma-launcher.sh PACKAGE.asysma" >&2
    exit 2
fi

PACKAGE=$1
if [ ! -f "$PACKAGE" ]; then
    echo "xmc-asysma-launcher: package not found: $PACKAGE" >&2
    exit 2
fi

XMC_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
RUNTIME=${XMC_ASYSMA_RUNTIME:-$XMC_DIR/asysma-run}

if [ ! -x "$RUNTIME" ]; then
    echo "xmc-asysma-launcher: ASYSMA runtime adapter is not installed: $RUNTIME" >&2
    echo "xmc-asysma-launcher: packaging alone does not make .asysma an OS-native executable" >&2
    exit 1
fi

exec "$RUNTIME" "$PACKAGE"
