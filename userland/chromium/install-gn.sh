#!/usr/bin/env bash
# Install/bootstrap Chromium's GN toolchain from official depot_tools.
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

export PATH="$DEPOT_TOOLS:$PATH"

# depot_tools bootstraps its managed Python/toolchain on first use. Running
# gclient once is the supported initialization path and is idempotent.
if [ ! -f "$DEPOT_TOOLS/python3_bin_reldir.txt" ]; then
    if command -v gclient >/dev/null 2>&1; then
        (cd "$DEPOT_TOOLS" && gclient --version >/dev/null)
    else
        fail "gclient is missing from depot_tools: $DEPOT_TOOLS"
    fi
fi

# gclient initialization can create the marker lazily; refresh the PATH and
# verify the actual tools before returning control to build.sh.
if [ ! -f "$DEPOT_TOOLS/python3_bin_reldir.txt" ]; then
    printf '%s\n' "depot_tools bootstrap marker not present yet; attempting ensure_bootstrap"
    if [ -x "$DEPOT_TOOLS/ensure_bootstrap" ]; then
        "$DEPOT_TOOLS/ensure_bootstrap"
    fi
fi

[ -f "$DEPOT_TOOLS/python3_bin_reldir.txt" ] || fail "depot_tools did not initialize python3_bin_reldir.txt"
command -v gn >/dev/null 2>&1 || fail "GN is unavailable after depot_tools initialization"
command -v autoninja >/dev/null 2>&1 || fail "autoninja is unavailable after depot_tools initialization"

printf 'depot_tools: %s\n' "$DEPOT_TOOLS"
printf 'GN: %s\n' "$(command -v gn)"
printf 'autoninja: %s\n' "$(command -v autoninja)"
