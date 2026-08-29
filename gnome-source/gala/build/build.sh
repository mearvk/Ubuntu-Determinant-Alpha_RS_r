#!/usr/bin/env bash
set -euo pipefail
# Local Gala build entry point. Gala is retained as an optional module and is
# never substituted for Mutter in the standard GNOME desktop build.
exec "$(cd "$(dirname "$0")/../.." && pwd)/build-module.sh" gala "$@"
