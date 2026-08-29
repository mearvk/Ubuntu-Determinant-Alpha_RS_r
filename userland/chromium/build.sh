#!/usr/bin/env bash
# Chromium White Edition top-level build entry point.
# Delegates the HTTP 3.0 / White Edition build contract to the module script.
set -euo pipefail
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
exec "${SCRIPT_DIR}/http-3.0/build-white-edition.sh" "$@"
