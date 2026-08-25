#!/bin/sh
# Scan the GCC source already pulled into the local MEARVK checkout.
# This script never clones GCC, never contacts gcc-mirror, and never pushes.
set -eu

MEARVK_REPO="mearvk/Ubuntu.Determinant.Beta.Restricted"
MEARVK_URL="https://github.com/mearvk/Ubuntu.Determinant.Beta.Restricted.git"
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)
REPORT="$SCRIPT_DIR/gcc-github-latest-readiness.txt"
IMPORT_DIR="$SCRIPT_DIR/gcc-github-latest-import"
MAX_BLOB_MB="${MAX_BLOB_MB:-90}"

usage() {
    cat <<EOF
Usage: $0 [--refresh] [--prepare]

The GCC source is assumed to have already been pulled into this local
MEARVK checkout. The script scans the local source and can prepare a clean
source-only copy.

  --refresh   fetch/fast-forward from the Beta repository explicitly
  --prepare   create tools/gcc/gcc-github-latest-import from the local GCC tree

Environment:
  MAX_BLOB_MB   large-file review threshold (default: 90)

Safety:
  - No GCC upstream repository is contacted.
  - The existing origin URL is never used for --refresh.
  - --refresh explicitly fetches Beta from MEARVK_URL.
  - No push is performed.
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

command -v git >/dev/null 2>&1 || {
    echo "error: git is required" >&2
    exit 1
}

[ -d "$REPO_ROOT/.git" ] || {
    echo "error: not a Git checkout: $REPO_ROOT" >&2
    exit 1
}

ORIGIN=$(git -C "$REPO_ROOT" remote get-url origin 2>/dev/null || true)
ORIGIN_CLEAN=$(printf '%s' "$ORIGIN" | sed -E 's#https://[^@/]+@#https://#')

# The checkout can have an old/mispointed origin. Do not reject the local
# master clone merely because origin says Alpha. For --refresh, Beta is used
# explicitly below, so we cannot accidentally refresh from Alpha.
if [ "$ORIGIN_CLEAN" != "$MEARVK_URL" ] &&
   [ "$ORIGIN_CLEAN" != "git@github.com:mearvk/Ubuntu.Determinant.Beta.Restricted.git" ]; then
    echo "warning: local origin is not the Beta repository:" >&2
    echo "  $ORIGIN_CLEAN" >&2
    echo "warning: local files will still be scanned." >&2
    echo "warning: --refresh will explicitly fetch Beta, not this origin." >&2
fi

if [ "$REFRESH" -eq 1 ]; then
    echo "Refreshing from Beta explicitly: $MEARVK_URL"

    BRANCH=$(git -C "$REPO_ROOT" symbolic-ref --short -q HEAD || echo main)

    # Fetch Beta directly without changing the user's origin configuration.
    # This avoids accidentally pulling Alpha when origin is still configured
    # to point there.
    git -C "$REPO_ROOT" fetch --prune "$MEARVK_URL" "$BRANCH"

    git -C "$REPO_ROOT" merge --ff-only FETCH_HEAD
fi

# Locate GCC source already present locally.
if [ -f "$SCRIPT_DIR/gcc-16.2.0/configure" ]; then
    SOURCE_PATH="$SCRIPT_DIR/gcc-16.2.0"
elif [ -f "$SCRIPT_DIR/gcc-github-latest/configure" ]; then
    SOURCE_PATH="$SCRIPT_DIR/gcc-github-latest"
elif [ -f "$SCRIPT_DIR/gcc-github-latest-import/configure" ]; then
    SOURCE_PATH="$SCRIPT_DIR/gcc-github-latest-import"
else
    echo "error: GCC source was not found under $SCRIPT_DIR" >&2
    echo "Expected gcc-16.2.0/, gcc-github-latest/, or gcc-github-latest-import/." >&2
    echo "The GCC source must already have been pulled into this MEARVK checkout." >&2
    exit 1
fi

SOURCE_NAME=$(basename "$SOURCE_PATH")
SOURCE_FILES=$(find "$SOURCE_PATH" -type f -not -path '*/.git/*' | wc -l | tr -d ' ')
SOURCE_DIRS=$(find "$SOURCE_PATH" -type d -not -path '*/.git/*' | wc -l | tr -d ' ')
SOURCE_BYTES=$(du -sk "$SOURCE_PATH" | awk '{print $1 * 1024}')

MAX_BYTES=$((MAX_BLOB_MB * 1024 * 1024))
LARGE_LIST=$(mktemp)
trap 'rm -f "$LARGE_LIST"' EXIT

# Scan tracked files under tools/gcc.
git -C "$REPO_ROOT" ls-files -z "tools/gcc" |
while IFS= read -r -d '' path; do
    [ -f "$REPO_ROOT/$path" ] || continue
    SIZE=$(wc -c < "$REPO_ROOT/$path" | tr -d ' ')
    if [ "$SIZE" -ge "$MAX_BYTES" ]; then
        printf '%s\t%s\n' "$SIZE" "$path"
    fi
done > "$LARGE_LIST" || true

# Also scan untracked GCC files because the source may not yet be staged.
find "$SOURCE_PATH" -type f -not -path '*/.git/*' -print0 |
while IFS= read -r -d '' file; do
    SIZE=$(wc -c < "$file" | tr -d ' ')
    if [ "$SIZE" -ge "$MAX_BYTES" ]; then
        case "$file" in
            "$REPO_ROOT"/*) REL=${file#"$REPO_ROOT"/} ;;
            *) REL=$file ;;
        esac
        if ! grep -Fq "$(printf '\t%s' "$REL")" "$LARGE_LIST" 2>/dev/null; then
            printf '%s\t%s\n' "$SIZE" "$REL"
        fi
    fi
done >> "$LARGE_LIST"

sort -nr "$LARGE_LIST" -o "$LARGE_LIST"
LARGE_COUNT=$(wc -l < "$LARGE_LIST" | tr -d ' ')

LFS_PRESENT=0
if git lfs version >/dev/null 2>&1; then
    LFS_PRESENT=1
fi

TRACKED_COUNT=$(git -C "$REPO_ROOT" ls-files "tools/gcc" | wc -l | tr -d ' ')
STATUS=$(git -C "$REPO_ROOT" status --short -- "tools/gcc")

OVER_GITHUB_LIMIT=0
if [ "$LARGE_COUNT" -gt 0 ]; then
    while IFS="$(printf '\t')" read -r bytes path; do
        if [ "$bytes" -ge $((100 * 1024 * 1024)) ]; then
            OVER_GITHUB_LIMIT=$((OVER_GITHUB_LIMIT + 1))
        fi
    done < "$LARGE_LIST"
fi

{
    echo "MEARVK GCC source readiness report"
    echo "=================================="
    echo "repository=$MEARVK_REPO"
    echo "configured_origin=$ORIGIN_CLEAN"
    echo "refresh_source=$MEARVK_URL"
    echo "source=$SOURCE_PATH"
    echo "source_name=$SOURCE_NAME"
    echo "source_files=$SOURCE_FILES"
    echo "source_directories=$SOURCE_DIRS"
    echo "source_bytes=$SOURCE_BYTES"
    echo "tracked_tools_gcc_files=$TRACKED_COUNT"
    echo "git_lfs_available=$LFS_PRESENT"
    echo "large_files_over_${MAX_BLOB_MB}MiB=$LARGE_COUNT"
    echo "files_at_or_over_100MiB=$OVER_GITHUB_LIMIT"
    echo
    echo "working_tree_status_begin"
    printf '%s\n' "$STATUS"
    echo "working_tree_status_end"
    echo
    echo "large_file_candidates_begin"
    if [ "$LARGE_COUNT" -eq 0 ]; then
        echo "none"
    else
        cat "$LARGE_LIST"
    fi
    echo "large_file_candidates_end"
    echo
    echo "readiness"
    echo "---------"
    echo "provenance=MEARVK repository"
    echo "external_gcc_pull=disabled"
    echo "destination_push=disabled"
    if [ "$LARGE_COUNT" -gt 0 ]; then
        echo "review_required=yes"
    else
        echo "review_required=no"
    fi
    if [ "$OVER_GITHUB_LIMIT" -gt 0 ]; then
        echo "lfs_review=yes"
    else
        echo "lfs_review=no"
    fi
} > "$REPORT"

cat "$REPORT"

if [ "$PREPARE" -eq 1 ]; then
    rm -rf "$IMPORT_DIR"
    mkdir -p "$IMPORT_DIR"
    tar -C "$SOURCE_PATH" --exclude='.git' -cf - . |
        tar -xf - -C "$IMPORT_DIR"
    echo
    echo "Prepared source-only copy: $IMPORT_DIR"
    echo "No .git metadata is included."
fi

if [ "$OVER_GITHUB_LIMIT" -gt 0 ]; then
    echo
    echo "STATUS=REVIEW_REQUIRED_GITHUB_FILE_LIMIT"
    exit 3
fi

if [ "$LARGE_COUNT" -gt 0 ]; then
    echo
    echo "STATUS=REVIEW_REQUIRED_LARGE_FILES"
    exit 3
fi

echo
echo "STATUS=READY_FOR_MANUAL_REVIEW_AND_PUSH"
