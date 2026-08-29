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

# depot_tools expects its managed Python bootstrap marker to exist before
# gn.py can resolve the managed GN binary. gclient is invoked once to trigger
# the supported bootstrap path; repeated invocations are harmless.
if [ ! -f "$DEPOT_TOOLS/python3_bin_reldir.txt" ]; then
    command -v gclient >/dev/null 2>&1 || fail "gclient is missing from depot_tools"
    (cd "$DEPOT_TOOLS" && gclient --version >/dev/null)
fi

# Force depot_tools to refresh its managed tools when available.
if [ -x "$DEPOT_TOOLS/update_depot_tools" ]; then
    (cd "$DEPOT_TOOLS" && ./update_depot_tools)
fi

[ -f "$DEPOT_TOOLS/python3_bin_reldir.txt" ] || fail "depot_tools bootstrap did not create python3_bin_reldir.txt"

# depot_tools' gn entry is a resolver wrapper. Do not mistake the wrapper for
# the underlying managed GN binary; locate both entries and print them.
GN_LIST=$(which -a gn 2>/dev/null || true)
GN_COUNT=$(printf '%s\n' "$GN_LIST" | sed '/^$/d' | wc -l | tr -d ' ')
printf 'GN candidates (%s):\n%s\n' "$GN_COUNT" "$GN_LIST"

command -v gn >/dev/null 2>&1 || fail "GN resolver is unavailable after depot_tools bootstrap"
command -v autoninja >/dev/null 2>&1 || fail "autoninja is unavailable after depot_tools bootstrap"

# Ask the resolver to resolve its managed binary now, rather than waiting for
# the build step to fail.
if ! gn --version >/dev/null 2>&1; then
    fail "GN resolver exists but its managed GN binary is not resolvable. Run depot_tools bootstrap/update manually and rerun this script."
fi

printf 'depot_tools: %s\n' "$DEPOT_TOOLS"
printf 'GN: %s\n' "$(command -v gn)"
printf 'autoninja: %s\n' "$(command -v autoninja)"
printf 'GN version: '
gn --version || true
