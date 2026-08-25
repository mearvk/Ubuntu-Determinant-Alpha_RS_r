#!/bin/sh
# Fetch the latest GCC GitHub source, inspect it for repository push readiness,
# and optionally prepare it for copying into tools/gcc/gcc-github-latest.
set -eu

UPSTREAM_URL="https://github.com/gcc-mirror/gcc.git"
SOURCE_DIR="gcc-github-latest"
REPORT="gcc-github-latest-readiness.txt"
REMOTE_NAME="gcc-upstream"
MAX_BLOB_MB="${MAX_BLOB_MB:-90}"

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
cd "$SCRIPT_DIR"

usage() {
    cat <<EOF
Usage: $0 [--refresh] [--prepare]

  --refresh   fetch/update the latest upstream GCC GitHub branch
  --prepare   create/update a local readiness copy under $SOURCE_DIR

Environment:
  MAX_BLOB_MB   warn/fail threshold for individual Git blobs (default: 90)

The script does not push anything to GitHub.
EOF
}

REFRESH=0
PREPARE=0
for arg in "$@"; do
    case "$arg" in
        --refresh) REFRESH=1 ;;
        --prepare) PREPARE=1 ;;
        -h|--help) usage; exit 0 ;;
        *) echo "error: unknown argument: $arg" >&2; usage >&2; exit 2 ;;
    esac
done

if ! command -v git >/dev/null 2>&1; then
    echo "error: git is required" >&2
    exit 1
fi

if [ ! -d "$SOURCE_DIR/.git" ]; then
    echo "Cloning upstream GCC from $UPSTREAM_URL"
    git clone --filter=blob:none --no-checkout "$UPSTREAM_URL" "$SOURCE_DIR"
else
    echo "Using existing GCC checkout: $SOURCE_DIR"
fi

cd "$SOURCE_DIR"
if ! git remote get-url "$REMOTE_NAME" >/dev/null 2>&1; then
    git remote add "$REMOTE_NAME" "$UPSTREAM_URL"
fi
if [ "$REFRESH" -eq 1 ] || [ -z "$(git rev-parse --verify HEAD 2>/dev/null || true)" ]; then
    git fetch --prune "$REMOTE_NAME"
    DEFAULT_BRANCH=$(git remote show "$REMOTE_NAME" | sed -n 's/^  HEAD branch: //p' | head -n 1)
    [ -n "$DEFAULT_BRANCH" ] || DEFAULT_BRANCH="master"
    git checkout -B gcc-latest "$REMOTE_NAME/$DEFAULT_BRANCH"
fi

COMMIT=$(git rev-parse HEAD)
BRANCH=$(git symbolic-ref --short -q HEAD || echo detached)
UPSTREAM=$(git remote get-url "$REMOTE_NAME")

# Work from the Git tree itself, so the scan does not depend on the host's
# filesystem timestamp conventions and does not require checkout of blobs.
FILE_COUNT=$(git ls-tree -r --name-only HEAD | wc -l | tr -d ' ')
BLOB_COUNT=$(git rev-list --objects HEAD | wc -l | tr -d ' ')
MAX_BYTES=$((MAX_BLOB_MB * 1024 * 1024))
LARGE_LIST=$(mktemp)
trap 'rm -f "$LARGE_LIST"' EXIT

# Report blobs larger than the configured GitHub-safe review threshold.
# This does not claim a GitHub policy limit; it is an intentional pre-push
# warning threshold below GitHub's hard single-object rejection limit.
git rev-list --objects HEAD | while read -r object path; do
    [ -n "$object" ] || continue
    SIZE=$(git cat-file -s "$object")
    if [ "$SIZE" -ge "$MAX_BYTES" ]; then
        printf '%s\t%s\t%s\n' "$SIZE" "$object" "$path"
    fi
done | sort -nr > "$LARGE_LIST"

LARGE_COUNT=$(wc -l < "$LARGE_LIST" | tr -d ' ')
LFS_PRESENT=0
if git lfs version >/dev/null 2>&1; then
    LFS_PRESENT=1
fi

{
    echo "GCC GitHub source readiness report"
    echo "=================================="
    echo "upstream=$UPSTREAM"
    echo "branch=$BRANCH"
    echo "commit=$COMMIT"
    echo "files=$FILE_COUNT"
    echo "objects=$BLOB_COUNT"
    echo "large_blobs_over_${MAX_BLOB_MB}MiB=$LARGE_COUNT"
    echo "git_lfs_available=$LFS_PRESENT"
    echo
    echo "Large blob candidates"
    echo "---------------------"
    if [ "$LARGE_COUNT" -eq 0 ]; then
        echo "none"
    else
        cat "$LARGE_LIST"
    fi
    echo
    echo "Readiness rules"
    echo "---------------"
    echo "1. Review upstream license/provenance before importing."
    echo "2. Do not push .git metadata from the upstream checkout."
    echo "3. Review large blobs individually before adding them to the destination repository."
    echo "4. Git LFS is optional; use it only when the destination repository policy permits it."
    echo "5. This script never performs a destination push."
} > "$SCRIPT_DIR/$REPORT"

cat "$SCRIPT_DIR/$REPORT"

if [ "$PREPARE" -eq 1 ]; then
    cd "$SCRIPT_DIR"
    DEST="gcc-github-latest-import"
    rm -rf "$DEST"
    mkdir "$DEST"
    (cd "$SOURCE_DIR" && git archive --format=tar HEAD) | tar -xf - -C "$DEST"
    printf '\nPrepared source copy: %s/%s\n' "$SCRIPT_DIR" "$DEST"
    printf 'The copy contains source files only; the upstream .git directory is excluded.\n'
fi

if [ "$LARGE_COUNT" -gt 0 ]; then
    echo "\nSTATUS=REVIEW_REQUIRED"
    exit 3
fi

echo "\nSTATUS=READY_FOR_MANUAL_REVIEW"
