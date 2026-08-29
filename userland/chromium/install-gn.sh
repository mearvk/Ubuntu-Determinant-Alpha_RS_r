#!/usr/bin/env bash
# Install/fetch the Chromium GN toolchain for local builds.
# GN is obtained from Chromium's official depot_tools workflow.
set -euo pipefail

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
DEPOT_TOOLS=${DEPOT_TOOLS:-"$SCRIPT_DIR/depot_tools"}

fail() { printf 'ERROR: %s\n' "$*" >&2; exit 1; }

command -v git >/dev/null 2>&1 || fail "git is required to acquire depot_tools"

if [ ! -d "$DEPOT_TOOLS/.git" ]; then
    if [ -e "$DEPOT_TOOLS" ]; then
        fail "DEPOT_TOOLS exists but is not a git checkout: $DEPOT_TOOLS"
    fi
    git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git "$DEPOT_TOOLS"
fi

case ":$PATH:" in
    *":$DEPOT_TOOLS:"*) ;;
    *) PATH="$DEPOT_TOOLS:$PATH"; export PATH ;;
esac

if command -v gn >/dev/null 2>&1; then
    printf 'GN: %s\n' "$(command -v gn)"
    gn --version 2>/dev/null || true
else
    printf '%s\n' "ERROR: depot_tools was acquired, but gn is not currently available."
    printf '%s\n' "Run the Chromium source hooks, or ensure depot_tools has completed its tool download."
    exit 1
fi

if command -v autoninja >/dev/null 2>&1; then
    printf 'autoninja: %s\n' "$(command -v autoninja)"
fi
