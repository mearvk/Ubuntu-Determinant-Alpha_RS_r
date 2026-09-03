#!/usr/bin/env bash
set -euo pipefail

# Ubuntu Determinant — verify a Git source directory against its recorded commit.
#
# Usage:
#   ./verify-source.sh <source-directory> [expected-ref]
#
# The directory must contain a .git repository and, when present, a .source-commit
# file produced by pull-source.sh. Verification is intentionally read-only.

if [ "$#" -lt 1 ] || [ "$#" -gt 2 ]; then
  echo "Usage: $0 <source-directory> [expected-ref]" >&2
  exit 2
fi

SOURCE="$1"
EXPECTED_REF="${2:-}"

if ! command -v git >/dev/null 2>&1; then
  echo "ERROR: git is required." >&2
  exit 1
fi

if [ ! -d "$SOURCE/.git" ]; then
  echo "ERROR: not a Git repository: $SOURCE" >&2
  exit 1
fi

if ! HEAD="$(git -C "$SOURCE" rev-parse HEAD 2>/dev/null)"; then
  echo "ERROR: unable to resolve repository HEAD." >&2
  exit 1
fi

RECORDED=""
if [ -f "$SOURCE/.source-commit" ]; then
  RECORDED="$(tr -d '[:space:]' < "$SOURCE/.source-commit")"
fi

printf '=== Git source verification ===\n'
printf 'Source: %s\n' "$SOURCE"
printf 'HEAD: %s\n' "$HEAD"

if [ -n "$RECORDED" ]; then
  printf 'Recorded commit: %s\n' "$RECORDED"
  if [ "$HEAD" != "$RECORDED" ]; then
    echo "ERROR: HEAD does not match .source-commit." >&2
    exit 1
  fi
else
  echo "WARNING: no .source-commit file found; commit provenance cannot be verified." >&2
fi

if [ -n "$EXPECTED_REF" ]; then
  if ! git -C "$SOURCE" show-ref --verify --quiet "refs/remotes/origin/$EXPECTED_REF" && \
     ! git -C "$SOURCE" show-ref --verify --quiet "refs/heads/$EXPECTED_REF"; then
    echo "ERROR: expected ref not present locally: $EXPECTED_REF" >&2
    exit 1
  fi
  printf 'Expected ref: %s\n' "$EXPECTED_REF"
fi

if ! git -C "$SOURCE" diff --quiet --ignore-submodules --; then
  echo "ERROR: tracked working-tree modifications detected." >&2
  git -C "$SOURCE" status --short >&2
  exit 1
fi

if [ -n "$(git -C "$SOURCE" ls-files --others --exclude-standard)" ]; then
  echo "ERROR: untracked files detected." >&2
  git -C "$SOURCE" status --short >&2
  exit 1
fi

printf 'Working tree: clean\n'
printf 'Result: VERIFIED\n'
