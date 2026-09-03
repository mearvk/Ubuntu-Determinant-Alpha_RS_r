#!/usr/bin/env bash
set -euo pipefail

# Ubuntu Determinant — guarded Git push helper.
#
# Usage:
#   ./push-safe.sh <remote> <refspec> [additional git push arguments...]
#
# Policy:
#   A push effort is rejected when the estimated new object payload exceeds
#   200 MiB. The check is performed before git push is invoked.
#
# Environment:
#   GIT_PUSH_MAX_BYTES   Override the byte limit (default: 209715200).

MAX_BYTES="${GIT_PUSH_MAX_BYTES:-209715200}"

if [ "$#" -lt 2 ]; then
  echo "Usage: $0 <remote> <refspec> [additional git push arguments...]" >&2
  exit 2
fi

if ! command -v git >/dev/null 2>&1; then
  echo "ERROR: git is required." >&2
  exit 1
fi

if ! [[ "$MAX_BYTES" =~ ^[1-9][0-9]*$ ]]; then
  echo "ERROR: GIT_PUSH_MAX_BYTES must be a positive integer." >&2
  exit 2
fi

REMOTE="$1"
REFSPEC="$2"
shift 2

if ! git rev-parse --git-dir >/dev/null 2>&1; then
  echo "ERROR: current directory is not a Git repository." >&2
  exit 1
fi

# Require the refspec's local source to resolve before estimating the push.
LOCAL_REF="${REFSPEC%%:*}"
if [ -z "$LOCAL_REF" ]; then
  LOCAL_REF="HEAD"
fi
if ! git rev-parse --verify --quiet "$LOCAL_REF^{commit}" >/dev/null; then
  echo "ERROR: local ref does not resolve to a commit: $LOCAL_REF" >&2
  exit 1
fi

# Ask Git to enumerate objects reachable from the local source but absent from
# the remote's advertised refs. This is the payload that a normal push would
# need to transfer, subject to server-side negotiation/delta compression.
TMP_PACK="$(mktemp)"
trap 'rm -f "$TMP_PACK"' EXIT

if ! git rev-list --objects "$LOCAL_REF" --not --remotes="$REMOTE" >"$TMP_PACK"; then
  echo "ERROR: unable to determine objects that would be pushed." >&2
  exit 1
fi

OBJECT_COUNT="$(wc -l < "$TMP_PACK" | tr -d '[:space:]')"

# Sum the on-disk object sizes. This is a conservative local estimate, not an
# exact wire-size prediction: Git may delta-compress objects during transport.
TOTAL_BYTES=0
while IFS= read -r OBJECT_LINE; do
  OBJECT_ID="${OBJECT_LINE%% *}"
  [ -n "$OBJECT_ID" ] || continue
  SIZE="$(git cat-file -s "$OBJECT_ID")"
  TOTAL_BYTES=$((TOTAL_BYTES + SIZE))
done < "$TMP_PACK"

printf '=== Guarded Git push ===\n'
printf 'Remote: %s\n' "$REMOTE"
printf 'Refspec: %s\n' "$REFSPEC"
printf 'Objects to transfer (estimated): %s\n' "$OBJECT_COUNT"
printf 'Payload estimate: %s bytes\n' "$TOTAL_BYTES"
printf 'Push limit: %s bytes (200 MiB default)\n' "$MAX_BYTES"

if [ "$TOTAL_BYTES" -gt "$MAX_BYTES" ]; then
  echo "ERROR: push rejected; estimated payload exceeds the 200 MiB safety limit." >&2
  echo "No git push was attempted." >&2
  exit 1
fi

printf 'Payload check: PASS\n'
printf 'Invoking git push...\n'
git push "$REMOTE" "$REFSPEC" "$@"
printf 'Result: PUSH COMPLETED\n'
