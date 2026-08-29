#!/usr/bin/env bash
# Chromium White Edition top-level build entry point.
# Ensures the Chromium GN toolchain is available, then delegates to the
# HTTP 3.0 / White Edition build contract.
set -euo pipefail

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

if ! command -v gn >/dev/null 2>&1; then
    "${SCRIPT_DIR}/install-gn.sh"
fi

# install-gn.sh runs in a child shell, so make its depot_tools location
# available to the delegated build explicitly.
export DEPOT_TOOLS="${DEPOT_TOOLS:-${SCRIPT_DIR}/depot_tools}"
export PATH="${DEPOT_TOOLS}:${PATH}"

exec "${SCRIPT_DIR}/http-3.0/build-white-edition.sh" "$@"
