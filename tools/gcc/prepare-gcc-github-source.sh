#!/bin/sh
# Pull the GCC source already mirrored in the MEARVK repository, inspect it
# for Git/Git LFS push readiness, and optionally prepare a clean source copy.
# This script NEVER pulls from or pushes to gcc-mirror/gcc.
set -eu

MEARVK_URL="https://github.com/mearvk/Ubuntu.Determinant.Beta.Restricted.git"
MEARVK_PATH="tools/gcc"
SOURCE_DIR="gcc-github-latest"
IMPORT_DIR="gcc-github-latest-import"
REPORT="gcc-github-latest-readiness.txt"
MAX_BLOB_MB="${MAX_BLOB_MB:-90}"

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)
cd "$REPO_ROOT"

usage() {
    cat <<EOF
Usage: $0 [--refresh] [--prepare]

Pull/scan the GCC source already present in the MEARVK repository.

  --refresh   fetch the MEARVK repository and refresh the local source view
  --prepare   create a source-only import copy under tools/gcc/$IMPORT_DIR

Environment:
  MAX_BLOB_MB   review threshold for one Git blob (default: 90)

Safety:
  This script pulls only from:
    $MEARVK_URL
  It never pulls from gcc-mirror/gcc and never pushes anything.
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

# Verify that the caller is operating on the intended repository.
if [ ! -d "$REPO_ROOT/.git" ]; then
    echo "error: repository root not found: $REPO_ROOT" >&2
    exit 1
fi

ORIGIN=$(git -C "$REPO_ROOT" remote get-url origin 2>/dev/null || true)
if [ -n "$ORIGIN" ]; then
    case "$ORIGIN" in
        "$MEARVK_URL"|git@github.com:mearvk/Ubuntu.Determinant.Beta.Restricted.git) ;;
        *)
            echo "error: repository origin is not the expected MEARVK repository:" >&2
            echo "  $ORIGIN" >&2
            echo "expected: $MEARVK_URL" >&2
            exit 1
            ;;
    esac
fi

if [ "$REFRESH" -eq 1 ]; then
    echo "Refreshing the MEARVK repository only: $MEARVK_URL"
    git -C "$REPO_ROOT" fetch --prune origin
    BRANCH=$(git -C "$REPO_ROOT" symbolic-ref --short -q HEAD || echo main)
    git -C "$REPO_ROOT" pull --ff-only origin "$BRANCH"
fi

# The expected GCC source may be an extracted release tree, a Git checkout,
# or a source import already committed under tools/gcc. Find the first useful
# GCC source root without contacting an external GCC repository.
if [ -d "$SCRIPT_DIR/gcc-16.2.0/.git" ] || [ -f "$SCRIPT_DIR/gcc-16.2.0/configure" ]; then
    SOURCE_DIR="gcc-16.2.0"
elif [ -d "$SCRIPT_DIR/gcc-github-latest/.git" ]; then
    SOURCE_DIR="gcc-github-latest"
elif [ -f "$SCRIPT_DIR/gcc-github-latest/configure" ]; then
    SOURCE_DIR="gcc-github-latest"
else
    echo "error: no GCC source tree found under $SCRIPT_DIR" >&2
    echo "Expected gcc-16.2.0/ or gcc-github-latest/." >&2
    echo "Pull/commit the GCC source into this MEARVK repository first." >&2
    exit 1
fi

SOURCE_PATH="$SCRIPT_DIR/$SOURCE_DIR"

# If the source itself is a Git checkout, inspect its current tree. Otherwise
# inspect every file that Git sees in the MEARVK repository under tools/gcc.
if [ -d "$SOURCE_PATH/.git" ]; then
    SOURCE_COMMIT=$(git -C "$SOURCE_PATH" rev-parse HEAD 2>/dev/null || echo unknown)
    SOURCE_BRANCH=$(git -C "$SOURCE_PATH" symbolic-ref --short -q HEAD 2>/dev/null || echo detached)
    SOURCE_FILES=$(git -C "$SOURCE_PATH" ls-files | wc -l | tr -d ' ')
    SOURCE_BLOBS=$(git -C "$SOURCE_PATH" rev-list --objects HEAD | wc -l | tr -d ' ')
    SCAN_ROOT="$SOURCE_PATH"
else
    SOURCE_COMMIT="repository-import"
    SOURCE_BRANCH="main"
    SOURCE_FILES=$(find "$SOURCE_PATH" -type f -not -path '*/.git/*' | wc -l | tr -d ' ')
    SOURCE_BLOBS="not-applicable"
    SCAN_ROOT="$SOURCE_PATH"
fi

MAX_BYTES=$((MAX_BLOB_MB * 1024 * 1024))
LARGE_LIST=$(mktemp)
trap 'rm -f "$LARGE_LIST"' EXIT

# Scan Git blobs when the source has its own Git history; otherwise scan the
# MEARVK repository's tracked files. The latter is the relevant pre-push view.
if [ -d "$SOURCE_PATH/.git" ]; then
    git -C "$SOURCE_PATH" rev-list --objects HEAD |
    while read -r object path; do
        [ -n "$object" ] || continue
        SIZE=$(git -C "$SOURCE_PATH" cat-file -s "$object")
        if [ "$SIZE" -ge "$MAX_BYTES" ]; then
            printf '%s\t%s\t%s\n' "$SIZE" "$object" "$path"
        fi
    done | sort -nr > "$LARGE_LIST"
else
    git -C "$REPO_ROOT" ls-files -z "$MEARVK_PATH" |
    while IFS= read -r -d '' path; do
        SIZE=$(wc -c < "$REPO_ROOT/$path" | tr -d ' ')
        if [ "$SIZE" -ge "$MAX_BYTES" ]; then
            printf '%s\t%s\n' "$SIZE" "$path"
        fi
    done > "$LARGE_LIST"
fi

LARGE_COUNT=$(wc -l < "$LARGE_LIST" | tr -d ' ')
LFS_PRESENT=0
if git lfs version >/dev/null 2>&1; then
    LFS_PRESENT=1
fi

TRACKED_GCC_COUNT=$(git -C "$REPO_ROOT" ls-files "$MEARVK_PATH" | wc -l | tr -d ' ')
WORKTREE_STATUS=$(git -C "$REPO_ROOT" status --short -- "$MEARVK_PATH")

{
    echo "MEARVK GCC source readiness report"
    echo "=================================="
    echo "repository=$MEARVK_URL"
    echo "repository_root=$REPO_ROOT"
    echo "source=$SOURCE_PATH"
    echo "source_commit=$SOURCE_COMMIT"
    echo "source_branch=$SOURCE_BRANCH"
    echo "source_files=$SOURCE_FILES"
    echo "source_objects=$SOURCE_BLOBS"
    echo "me ar vk tracked tools/gcc files=$TRACKED_GCC_COUNT" | tr -d ' ' || true
    echo "large_files_or_blobs_over_${MAX_BLOB_MB}MiB=$LARGE_COUNT"
    echo "git_lfs_available=$LFS_PRESENT"
    echo "working_tree_status_begin"
    printf '%s\n' "$WORKTREE_STATUS"
    echo "working_tree_status_end"
    echo
    echo "Large file/blob candidates"
    echo "--------------------------"
    if [ "$LARGE_COUNT" -eq 0 ]; then
        echo "none"
    else
        cat "$LARGE_LIST"
    fi
    echo
    echo "Readiness rules"
    echo "---------------"
    echo "1. Source provenance is the MEARVK repository, not gcc-mirror/gcc."
    echo "2. No external GCC remote is contacted by this script."
    echo "3. Review every large file/blob before committing the GCC source."
    echo "4. Git LFS is optional and must match the destination repository policy."
    echo "5. Do not commit upstream .git metadata into the MEARVK source tree."
    echo "6. This script never performs a push."
} > "$SCRIPT_DIR/$REPORT"

cat "$SCRIPT_DIR/$REPORT"

if [ "$PREPARE" -eq 1 ]; then
    rm -rf "$SCRIPT_DIR/$IMPORT_DIR"
    mkdir -p "$SCRIPT_DIR/$IMPORT_DIR"

    if [ -d "$SOURCE_PATH/.git" ]; then
        git -C "$SOURCE_PATH" archive --format=tar HEAD |
            tar -xf - -C "$SCRIPT_DIR/$IMPORT_DIR"
    else
        # Copy the source while explicitly excluding any nested Git metadata.
        tar -C "$SOURCE_PATH" \
            --exclude='.git' \
            -cf - . |
            tar -xf - -C "$SCRIPT_DIR/$IMPORT_DIR"
    fi

    printf '\nPrepared source-only import: %s\n' "$SCRIPT_DIR/$IMPORT_DIR"
    printf 'No upstream .git metadata is included.\n'
fi

if [ "$LARGE_COUNT" -gt 0 ]; then
    echo
    echo "STATUS=REVIEW_REQUIRED"
    exit 3
fi

echo
echo "STATUS=READY_FOR_MANUAL_REVIEW"
