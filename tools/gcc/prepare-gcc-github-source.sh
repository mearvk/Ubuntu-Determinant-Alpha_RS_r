#!/bin/sh
# Scan the GCC source already pulled into this MEARVK checkout.
# This script does not clone GCC, contact gcc-mirror, or push anything.
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

The GCC source is assumed to have already been pulled into this MEARVK
repository. The script scans what is present locally and prepares a clean
source-only copy if requested.

  --refresh   fast-forward this existing MEARVK checkout from origin
  --prepare   create tools/gcc/gcc-github-latest-import from the local GCC tree

Environment:
  MAX_BLOB_MB   large-file review threshold (default: 90)

No GCC upstream repository is contacted. No push is performed.
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

case "$ORIGIN_CLEAN" in
    "$MEARVK_URL"|git@github.com:mearvk/Ubuntu.Determinant.Beta.Restricted.git)
        ;;
    *)
        echo "error: this checkout is not $MEARVK_REPO" >&2
        echo "origin=$ORIGIN_CLEAN" >&2
        exit 1
        ;;
esac

if [ "$REFRESH" -eq 1 ]; then
    echo "Refreshing existing MEARVK checkout only."
    BRANCH=$(git -C "$REPO_ROOT" symbolic-ref --short -q HEAD || echo main)
    git -C "$REPO_ROOT" fetch --prune origin
    git -C "$REPO_ROOT" pull --ff-only origin "$BRANCH"
fi

# Locate the GCC source already present in this checkout. Prefer the actual
# extracted source tree; otherwise accept the previously prepared tree.
if [ -f "$SCRIPT_DIR/gcc-16.2.0/configure" ]; then
    SOURCE_PATH="$SCRIPT_DIR/gcc-16.2.0"
elif [ -f "$SCRIPT_DIR/gcc-github-latest/configure" ]; then
    SOURCE_PATH="$SCRIPT_DIR/gcc-github-latest"
elif [ -f "$SCRIPT_DIR/gcc-github-latest-import/configure" ]; then
    SOURCE_PATH="$SCRIPT_DIR/gcc-github-latest-import"
else
    echo "error: GCC source was not found under $SCRIPT_DIR" >&2
    echo "Expected gcc-16.2.0/, gcc-github-latest/, or gcc-github-latest-import/." >&2
    echo "The source must already have been pulled into this MEARVK checkout." >&2
    exit 1
fi

SOURCE_NAME=$(basename "$SOURCE_PATH")
SOURCE_FILES=$(find "$SOURCE_PATH" -type f -not -path '*/.git/*' | wc -l | tr -d ' ')
SOURCE_DIRS=$(find "$SOURCE_PATH" -type d -not -path '*/.git/*' | wc -l | tr -d ' ')
SOURCE_BYTES=$(du -sk "$SOURCE_PATH" | awk '{print $1 * 1024}')

MAX_BYTES=$((MAX_BLOB_MB * 1024 * 1024))
LARGE_LIST=$(mktemp)
trap 'rm -f "$LARGE_LIST"' EXIT

# Inspect the files that would be committed from tools/gcc. This deliberately
# measures the working tree, not an unrelated GCC upstream history.
git -C "$REPO_ROOT" ls-files -z "$SCRIPT_DIR" 2>/dev/null |
while IFS= read -r -d '' path; do
    [ -f "$REPO_ROOT/$path" ] || continue
    SIZE=$(wc -c < "$REPO_ROOT/$path" | tr -d ' ')
    if [ "$SIZE" -ge "$MAX_BYTES" ]; then
        printf '%s\t%s\n' "$SIZE" "$path"
    fi
done > "$LARGE_LIST" || true

# Include untracked GCC source files in the scan. This is important because
# the user has already pulled the source and may not have staged it yet.
find "$SOURCE_PATH" -type f -not -path '*/.git/*' -print0 |
while IFS= read -r -d '' file; do
    SIZE=$(wc -c < "$file" | tr -d ' ')
    if [ "$SIZE" -ge "$MAX_BYTES" ]; then
        case "$file" in
            "$REPO_ROOT"/*) REL=${file#"$REPO_ROOT"/} ;;
            *) REL=$file ;;
        esac
        if ! grep -Fq "	$REL" "$LARGE_LIST" 2>/dev/null; then
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

TRACKED_COUNT=$(git -C "$REPO_ROOT" ls-files "$SCRIPT_DIR" | wc -l | tr -d ' ')
STATUS=$(git -C "$REPO_ROOT" status --short -- "$SCRIPT_DIR")

# Detect GitHub's 100 MiB per-file hard rejection boundary conservatively.
OVER_GITHUB_LIMIT=0
if [ "$LARGE_COUNT" -gt 0 ]; then
    while IFS="	" read -r bytes path; do
        [ "$bytes" -ge $((100 * 1024 * 1024)) ] && OVER_GITHUB_LIMIT=$((OVER_GITHUB_LIMIT + 1))
    done < "$LARGE_LIST"
fi

{
    echo "MEARVK GCC source readiness report"
    echo "=================================="
    echo "repository=$MEARVK_REPO"
    echo "origin=$ORIGIN_CLEAN"
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
    echo "review_required=$([ "$LARGE_COUNT" -gt 0 ] && echo yes || echo no)"
    echo "lfs_review=$([ "$OVER_GITHUB_LIMIT" -gt 0 ] && echo yes || echo no)"
} > "$REPORT"

cat "$REPORT"

if [ "$PREPARE" -eq 1 ]; then
    rm -rf "$IMPORT_DIR"
    mkdir -p "$IMPORT_DIR"
    tar -C "$SOURCE_PATH" --exclude='.git' -cf - . |
        tar -xf - -C "$IMPORT_DIR"
    echo
    echo "Prepared source-only copy: $IMPORT_DIR"
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
