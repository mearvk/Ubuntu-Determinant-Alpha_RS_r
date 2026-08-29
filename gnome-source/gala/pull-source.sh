#!/usr/bin/env bash
set -euo pipefail

# Ubuntu Determinant — Gala source acquisition
#
# Gala is the compositor/window manager used by elementary OS. It is not a
# GNOME core project, so this source boundary is kept separate from Mutter
# and GNOME Shell.
#
# Usage:
#   ./pull-source.sh [destination]
#
# Environment:
#   GALA_SOURCE_URL   Public upstream Git repository.
#   GALA_SOURCE_REF   Branch/tag/commit to acquire.
#   GALA_CLONE_DEPTH  Shallow clone depth (default: 1).

ROOT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
DESTINATION="${1:-${ROOT_DIR}/upstream/gala}"
SOURCE_URL="${GALA_SOURCE_URL:-https://github.com/elementary/gala.git}"
REF="${GALA_SOURCE_REF:-master}"
DEPTH="${GALA_CLONE_DEPTH:-1}"

command -v git >/dev/null 2>&1 || { echo "ERROR: git is required." >&2; exit 1; }

if ! [[ "$DEPTH" =~ ^[1-9][0-9]*$ ]]; then
  echo "ERROR: GALA_CLONE_DEPTH must be a positive integer." >&2
  exit 2
fi

if [ -e "$DESTINATION" ]; then
  echo "ERROR: destination already exists: $DESTINATION" >&2
  echo "Remove it first or choose another destination." >&2
  exit 1
fi

mkdir -p "$(dirname -- "$DESTINATION")"

# Gala is public source. Disable configured Git credential helpers by default
# so an unavailable public endpoint cannot unexpectedly prompt for credentials.
git -c credential.helper= clone \
  --depth "$DEPTH" \
  --branch "$REF" \
  --single-branch \
  "$SOURCE_URL" \
  "$DESTINATION"

if [ ! -d "$DESTINATION/.git" ]; then
  echo "ERROR: clone completed without a Git repository." >&2
  exit 1
fi

COMMIT="$(git -C "$DESTINATION" rev-parse HEAD)"
printf '%s\n' "$COMMIT" > "$DESTINATION/.source-commit"

cat > "$DESTINATION/SOURCE-INFO.txt" <<EOF
Project: Gala
Source URL: ${SOURCE_URL}
Requested ref: ${REF}
Commit: ${COMMIT}

This directory contains pristine upstream source. Determinant modifications
must be maintained outside this source tree as patches/offsets.
EOF

printf '=== Gala source acquired ===\n'
printf '  Source: %s\n' "$SOURCE_URL"
printf '  Ref: %s\n' "$REF"
printf '  Commit: %s\n' "$COMMIT"
printf '  Destination: %s\n' "$DESTINATION"
