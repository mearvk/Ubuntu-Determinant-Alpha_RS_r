#!/bin/sh
# Commit and push an already-present gcc-16.2.0 source tree in bounded batches.
#
# IMPORTANT:
#   GitHub rejects individual normal Git blobs >= 100 MiB. Therefore the
#   default batch target is ~200 MiB TOTAL, while each individual file is
#   checked against a conservative 95 MiB ceiling.
#
# The script is restart-safe:
#   - already committed files are not recommitted;
#   - after a successful commit, a failed push leaves that commit intact;
#   - the next run pushes the existing local commit before creating another;
#   - only files still absent from HEAD are selected for a new batch.
#
# This script does NOT use git add -A and does NOT overwrite existing work.
set -eu

BATCH_MB="${BATCH_MB:-200}"
FILE_LIMIT_MB="${FILE_LIMIT_MB:-95}"
SOURCE_REL="gcc-16.2.0"
COMMIT_PREFIX="Import GCC 16.2.0 batch"
REMOTE_NAME="${REMOTE_NAME:-origin}"
REMOTE_URL="https://github.com/mearvk/Ubuntu.Determinant.Beta.Restricted.git"

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
REPO_ROOT=$(CDPATH= cd -- "$SCRIPT_DIR/../.." && pwd)
SOURCE_DIR="$SCRIPT_DIR/$SOURCE_REL"

BATCH_BYTES=$((BATCH_MB * 1024 * 1024))
FILE_LIMIT_BYTES=$((FILE_LIMIT_MB * 1024 * 1024))

usage() {
    cat <<EOF
Usage: $0 [--dry-run] [--one]

Commit and push the existing tools/gcc/$SOURCE_REL source tree in batches.

  --dry-run   show the next batch without changing Git
  --one       perform exactly one commit/push batch, then stop

Environment:
  BATCH_MB       target total batch size (default: 200)
  FILE_LIMIT_MB  maximum normal Git file size (default: 95)
  REMOTE_NAME    Git remote used for push (default: origin)

Safety:
  - No GCC upstream repository is contacted.
  - No force push is performed.
  - Previously committed files are never recommitted.
  - A successful commit is never recreated merely because its push failed.
  - A file >= FILE_LIMIT_MB is reported and the run stops before staging it.
EOF
}

DRY_RUN=0
ONE=0

for arg in "$@"; do
    case "$arg" in
        --dry-run) DRY_RUN=1 ;;
        --one) ONE=1 ;;
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

[ -d "$SOURCE_DIR" ] || {
    echo "error: GCC source directory not found:" >&2
    echo "  $SOURCE_DIR" >&2
    exit 1
}

# Never accidentally operate on an unrelated remote. Existing credentials in
# the remote URL are stripped before comparison; they are never printed.
ORIGIN=$(git -C "$REPO_ROOT" remote get-url "$REMOTE_NAME" 2>/dev/null || true)
ORIGIN_CLEAN=$(printf '%s' "$ORIGIN" | sed -E 's#https://[^@/]+@#https://#')

case "$ORIGIN_CLEAN" in
    "$REMOTE_URL"|git@github.com:mearvk/Ubuntu.Determinant.Beta.Restricted.git)
        ;;
    *)
        echo "warning: $REMOTE_NAME is not the Beta repository:" >&2
        echo "  $ORIGIN_CLEAN" >&2
        echo "The push will be directed explicitly to Beta." >&2
        ;;
esac

BRANCH=$(git -C "$REPO_ROOT" symbolic-ref --short -q HEAD || true)

[ -n "$BRANCH" ] || {
    echo "error: detached HEAD; checkout the intended branch first." >&2
    exit 1
}

# Do not mix unrelated user changes into GCC commits.
NON_GCC_STATUS=$(git -C "$REPO_ROOT" status --porcelain -- . ':!tools/gcc/gcc-16.2.0')
if [ -n "$NON_GCC_STATUS" ]; then
    echo "warning: unrelated working-tree changes exist outside gcc-16.2.0." >&2
    echo "They will not be staged by this script." >&2
fi

# If a previous run successfully committed but failed to push, the local
# branch is ahead of the remote. Push that commit first. This is the key to
# making retries idempotent.
REMOTE_REF=""
if git -C "$REPO_ROOT" ls-remote --heads "$REMOTE_URL" "$BRANCH" >/tmp/gcc-batch-remote.$$ 2>/dev/null; then
    REMOTE_REF=$(awk '{print $1}' /tmp/gcc-batch-remote.$$ | head -n 1)
fi
rm -f /tmp/gcc-batch-remote.$$

LOCAL_HEAD=$(git -C "$REPO_ROOT" rev-parse HEAD)

if [ -n "$REMOTE_REF" ] &&
   [ "$LOCAL_HEAD" != "$REMOTE_REF" ] &&
   git -C "$REPO_ROOT" merge-base --is-ancestor "$REMOTE_REF" "$LOCAL_HEAD" 2>/dev/null
then
    echo "Local branch is ahead of Beta; pushing the existing commit first."

    if [ "$DRY_RUN" -eq 0 ]; then
        git -C "$REPO_ROOT" push "$REMOTE_URL" "$BRANCH:$BRANCH"
        echo "Existing commit pushed successfully."
    else
        echo "DRY-RUN: would push existing local commits to Beta."
        exit 0
    fi
fi

# A non-GCC staged change is dangerous because git commit would include it.
STAGED_NON_GCC=$(git -C "$REPO_ROOT" diff --cached --name-only -- . ':!tools/gcc/gcc-16.2.0')
if [ -n "$STAGED_NON_GCC" ]; then
    echo "error: unrelated staged changes exist." >&2
    echo "Unstage them before running this script:" >&2
    printf '%s\n' "$STAGED_NON_GCC" >&2
    exit 1
fi

# If GCC changes are already staged, don't throw them away. They may be the
# incomplete batch from an interrupted run. Otherwise construct a new batch.
STAGED_GCC=$(git -C "$REPO_ROOT" diff --cached --name-only -- "tools/gcc/$SOURCE_REL")

if [ -n "$STAGED_GCC" ]; then
    echo "Existing staged GCC batch detected; preserving it."
else
    BATCH_LIST=$(mktemp)
    trap 'rm -f "$BATCH_LIST"' EXIT

    TOTAL=0
    COUNT=0
    OVERSIZE=0

    # HEAD-relative untracked/modified files only. Files already in HEAD are
    # excluded, so a successful previous batch can never be selected again.
    git -C "$REPO_ROOT" status --porcelain=v1 --untracked-files=all -- "tools/gcc/$SOURCE_REL" |
    while IFS= read -r line; do
        [ -n "$line" ] || continue

        # Porcelain paths are quoted when necessary. GCC source filenames are
        # overwhelmingly ordinary paths, but use the final field as the path.
        PATHNAME=${line#?? }
        PATHNAME=${PATHNAME#"}"}
        PATHNAME=${PATHNAME%"}"}

        [ -f "$REPO_ROOT/$PATHNAME" ] || continue

        SIZE=$(wc -c < "$REPO_ROOT/$PATHNAME" | tr -d ' ')

        if [ "$SIZE" -ge "$FILE_LIMIT_BYTES" ]; then
            printf 'OVERSIZE\t%s\t%s\n' "$SIZE" "$PATHNAME" >> "$BATCH_LIST"
            continue
        fi

        if [ $((TOTAL + SIZE)) -gt "$BATCH_BYTES" ] && [ "$COUNT" -gt 0 ]; then
            continue
        fi

        printf 'FILE\t%s\t%s\n' "$SIZE" "$PATHNAME" >> "$BATCH_LIST"
        TOTAL=$((TOTAL + SIZE))
        COUNT=$((COUNT + 1))
    done

    if grep -q '^OVERSIZE' "$BATCH_LIST" 2>/dev/null; then
        echo "error: at least one GCC file exceeds the configured $FILE_LIMIT_MB MiB limit." >&2
        echo "Such a file should be handled through an appropriate Git LFS/repository policy." >&2
        grep '^OVERSIZE' "$BATCH_LIST" >&2
        exit 3
    fi

    if [ "$COUNT" -eq 0 ]; then
        rm -f "$BATCH_LIST"
        trap - EXIT
        echo "No uncommitted GCC files remain under $SOURCE_REL."
        echo "STATUS=COMPLETE_OR_ALREADY_COMMITTED"
        exit 0
    fi

    echo "Next GCC batch: $COUNT files, $TOTAL bytes"

    if [ "$DRY_RUN" -eq 1 ]; then
        awk -F '\t' '$1 == "FILE" {printf "%12d  %s\n", $2, $3}' "$BATCH_LIST"
        rm -f "$BATCH_LIST"
        trap - EXIT
        echo "STATUS=DRY_RUN"
        exit 0
    fi

    # Stage exactly this batch.
    awk -F '\t' '$1 == "FILE" {print $3}' "$BATCH_LIST" |
    while IFS= read -r path; do
        git -C "$REPO_ROOT" add -- "$path"
    done

    rm -f "$BATCH_LIST"
    trap - EXIT
fi

STAGED_COUNT=$(git -C "$REPO_ROOT" diff --cached --name-only -- "tools/gcc/$SOURCE_REL" | wc -l | tr -d ' ')

if [ "$STAGED_COUNT" -eq 0 ]; then
    echo "error: no GCC files staged." >&2
    exit 1
fi

STAGED_BYTES=0
while IFS= read -r path; do
    [ -f "$REPO_ROOT/$path" ] || continue
    SIZE=$(wc -c < "$REPO_ROOT/$path" | tr -d ' ')
    STAGED_BYTES=$((STAGED_BYTES + SIZE))
done <<EOF
$(git -C "$REPO_ROOT" diff --cached --name-only -- "tools/gcc/$SOURCE_REL")
EOF

COMMIT_MESSAGE="$COMMIT_PREFIX: $(date '+%Y-%m-%d %H:%M:%S') ($STAGED_COUNT files, $STAGED_BYTES bytes)"

echo "Committing: $STAGED_COUNT GCC files / $STAGED_BYTES bytes"
echo "$COMMIT_MESSAGE"

git -C "$REPO_ROOT" commit -m "$COMMIT_MESSAGE"

NEW_HEAD=$(git -C "$REPO_ROOT" rev-parse HEAD)
echo "Committed: $NEW_HEAD"

echo "Pushing this successful commit to Beta..."
git -C "$REPO_ROOT" push "$REMOTE_URL" "$BRANCH:$BRANCH"

echo "Push successful: $NEW_HEAD"

echo "STATUS=BATCH_PUSHED"

if [ "$ONE" -eq 1 ]; then
    echo "Stopped after one successful batch (--one)."
    exit 0
fi

# Continue by recursively invoking ourselves. Because the successful commit
# is now in HEAD, those files are no longer candidates. If the next batch
# fails, the already-pushed commit remains untouched and rerunning this script
# resumes at the next uncommitted files.
exec "$0"
