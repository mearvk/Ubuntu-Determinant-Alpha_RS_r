#!/usr/bin/env bash
set -euo pipefail

# Ubuntu Determinant — generic public Git source acquisition helper.
#
# Usage:
#   ./pull-source.sh <repository-url> <destination> [ref]
#
# Environment:
#   GIT_SOURCE_REF              branch/tag/commit when positional ref is omitted
#   GIT_CLONE_DEPTH             shallow clone depth (default: 1)
#   GIT_ALLOW_CREDENTIAL_HELPER 1 to permit configured Git credential helpers

if [ "$#" -lt 2 ] || [ "$#" -gt 3 ]; then
  echo "Usage: $0 <repository-url> <destination> [ref]" >&2
  exit 2
fi

REPOSITORY_URL="$1"
DESTINATION="$2"
REF="${3:-${GIT_SOURCE_REF:-}}"
DEPTH="${GIT_CLONE_DEPTH:-1}"
ALLOW_CREDENTIAL_HELPER="${GIT_ALLOW_CREDENTIAL_HELPER:-0}"

if ! command -v git >/dev/null 2>&1; then
  echo "ERROR: git is required." >&2
  exit 1
fi

if ! [[ "$DEPTH" =~ ^[1-9][0-9]*$ ]]; then
  echo "ERROR: GIT_CLONE_DEPTH must be a positive integer." >&2
  exit 2
fi

if [ -e "$DESTINATION" ]; then
  echo "ERROR: destination already exists: $DESTINATION" >&2
  exit 1
fi

mkdir -p "$(dirname -- "$DESTINATION")"

GIT_ARGS=(git)
if [ "$ALLOW_CREDENTIAL_HELPER" != "1" ]; then
  # Public source acquisition must never unexpectedly prompt for credentials.
  GIT_ARGS+=( -c credential.helper= )
fi

GIT_ARGS+=(clone --depth "$DEPTH" --single-branch)
if [ -n "$REF" ]; then
  GIT_ARGS+=(--branch "$REF")
fi
GIT_ARGS+=("$REPOSITORY_URL" "$DESTINATION")

printf '=== Git source acquisition ===\n'
printf 'Repository: %s\n' "$REPOSITORY_URL"
printf 'Destination: %s\n' "$DESTINATION"
if [ -n "$REF" ]; then
  printf 'Ref: %s\n' "$REF"
else
  printf 'Ref: repository default branch\n'
fi

"${GIT_ARGS[@]}"

# Verify that Git actually produced a repository before reporting success.
if [ ! -d "$DESTINATION/.git" ]; then
  echo "ERROR: clone completed without a Git repository at destination." >&2
  exit 1
fi

COMMIT="$(git -C "$DESTINATION" rev-parse HEAD)"
printf 'Commit: %s\n' "$COMMIT"
printf '%s\n' "$COMMIT" > "$DESTINATION/.source-commit"

printf '=== Source acquired successfully ===\n'
