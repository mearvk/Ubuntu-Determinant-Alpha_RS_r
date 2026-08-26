#!/usr/bin/env bash
#
# commit-gcc-in-batches.sh
#
# Safely import tools/gcc/gcc-16.2.0 into:
#
#   https://github.com/mearvk/Ubuntu.Determinant.Beta.Restricted.git
#
# in approximately 200 MiB batches.
#
# Authentication:
#   GitHub PAT is requested interactively for fetch/push.
#
# Safety:
#   - Never contacts gcc-mirror/gcc.
#   - Never uses the existing origin for Beta operations.
#   - Never force-pushes.
#   - Never recommits files already contained in HEAD.
#   - Preserves an existing local GCC commit if its push failed.
#   - Fetches Beta before comparing commit ancestry.
#   - Stops on genuinely divergent histories.
#

set -Eeuo pipefail

###############################################################################
# Configuration
###############################################################################

BATCH_MB="${BATCH_MB:-200}"
FILE_LIMIT_MB="${FILE_LIMIT_MB:-95}"

SOURCE_REL="tools/gcc/gcc-16.2.0"

BETA_REPO="mearvk/Ubuntu.Determinant.Beta.Restricted"
BETA_URL="https://github.com/mearvk/Ubuntu.Determinant.Beta.Restricted.git"

REMOTE_BRANCH="${REMOTE_BRANCH:-main}"

COMMIT_PREFIX="Import GCC 16.2.0 batch"

BETA_REF="refs/remotes/mearvk-beta/$REMOTE_BRANCH"

###############################################################################
# Paths
###############################################################################

SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd -- "$SCRIPT_DIR/../.." && pwd)"
SOURCE_DIR="$REPO_ROOT/$SOURCE_REL"

BATCH_BYTES=$((BATCH_MB * 1024 * 1024))
FILE_LIMIT_BYTES=$((FILE_LIMIT_MB * 1024 * 1024))

###############################################################################
# Runtime
###############################################################################

DRY_RUN=0
ONE=0

TMP_FILES=()

cleanup() {
    local f
    for f in "${TMP_FILES[@]:-}"; do
        [[ -z "$f" ]] || rm -f -- "$f"
    done
}

trap cleanup EXIT

###############################################################################
# Usage
###############################################################################

usage() {
    cat <<EOF
Usage:
  $0 [--dry-run] [--one]

Options:
  --dry-run
      Display the next operation without modifying Git.

  --one
      Process one successful GCC batch and stop.

Environment:
  BATCH_MB=${BATCH_MB}
  FILE_LIMIT_MB=${FILE_LIMIT_MB}

Repository:
  $BETA_REPO

Source:
  $SOURCE_REL
EOF
}

###############################################################################
# Arguments
###############################################################################

for arg in "$@"; do
    case "$arg" in
        --dry-run)
            DRY_RUN=1
            ;;

        --one)
            ONE=1
            ;;

        -h|--help)
            usage
            exit 0
            ;;

        *)
            echo "error: unknown option: $arg" >&2
            usage >&2
            exit 2
            ;;
    esac
done

###############################################################################
# Validation
###############################################################################

command -v git >/dev/null 2>&1 || {
    echo "error: git is required." >&2
    exit 1
}

[[ -d "$REPO_ROOT/.git" ]] || {
    echo "error: not a Git repository:" >&2
    echo "  $REPO_ROOT" >&2
    exit 1
}

[[ -d "$SOURCE_DIR" ]] || {
    echo "error: GCC source directory does not exist:" >&2
    echo "  $SOURCE_DIR" >&2
    exit 1
}

BRANCH="$(
    git -C "$REPO_ROOT" symbolic-ref --short -q HEAD || true
)"

if [[ -z "$BRANCH" ]]; then
    echo "error: detached HEAD." >&2
    exit 1
fi

###############################################################################
# Existing origin is informational only.
###############################################################################

ORIGIN="$(
    git -C "$REPO_ROOT" remote get-url origin 2>/dev/null || true
)"

ORIGIN_CLEAN="$(
    printf '%s' "$ORIGIN" |
    sed -E 's#https://[^@/]+@#https://#'
)"

if [[ "$ORIGIN_CLEAN" != "$BETA_URL" &&
      "$ORIGIN_CLEAN" != "git@github.com:mearvk/Ubuntu.Determinant.Beta.Restricted.git" ]]
then
    echo
    echo "warning: origin is not the Beta repository:"
    echo
    echo "$ORIGIN_CLEAN"
    echo
    echo "Beta will be accessed explicitly:"
    echo "$BETA_URL"
fi

###############################################################################
# PAT authentication
###############################################################################

GITHUB_USER=""
GITHUB_PAT=""

get_credentials() {

    if [[ -n "$GITHUB_USER" && -n "$GITHUB_PAT" ]]; then
        return 0
    fi

    echo
    echo "GitHub authentication required."
    echo "Repository:"
    echo "  $BETA_REPO"
    echo

    read -r -p "GitHub username: " GITHUB_USER

    if [[ -z "$GITHUB_USER" ]]; then
        echo "error: GitHub username cannot be empty." >&2
        return 1
    fi

    printf "GitHub PAT (input hidden): "
    read -r -s GITHUB_PAT
    printf '\n'

    if [[ -z "$GITHUB_PAT" ]]; then
        echo "error: GitHub PAT cannot be empty." >&2
        GITHUB_USER=""
        return 1
    fi
}

###############################################################################
# Authenticated Git operation
###############################################################################

git_authenticated() {

    local askpass
    local result

    get_credentials || return 1

    askpass="$(mktemp)"
    TMP_FILES+=("$askpass")

    chmod 700 "$askpass"

    cat > "$askpass" <<'EOF'
#!/usr/bin/env bash

case "${1:-}" in
    *Username*)
        printf '%s\n' "${GCC_GITHUB_USER}"
        ;;

    *Password*)
        printf '%s\n' "${GCC_GITHUB_PAT}"
        ;;

    *)
        printf '\n'
        ;;
esac
EOF

    set +e

    GCC_GITHUB_USER="$GITHUB_USER" \
    GCC_GITHUB_PAT="$GITHUB_PAT" \
    GIT_ASKPASS="$askpass" \
    GIT_TERMINAL_PROMPT=0 \
    git "$@"

    result=$?

    set -e

    rm -f -- "$askpass"

    return "$result"
}

###############################################################################
# Fetch Beta
###############################################################################

fetch_beta() {

    echo
    echo "Fetching Beta repository history..."

    #
    # The fetched branch is deliberately stored under a private local ref.
    # This prevents the stale Alpha origin from affecting the operation.
    #

    git_authenticated \
        fetch \
        --no-tags \
        "$BETA_URL" \
        "+refs/heads/$REMOTE_BRANCH:$BETA_REF"

    echo
    echo "Beta fetched successfully."

    git -C "$REPO_ROOT" rev-parse "$BETA_REF"
}

###############################################################################
# Remote/local ancestry
###############################################################################

BETA_HEAD=""
LOCAL_HEAD=""

refresh_heads() {

    BETA_HEAD="$(
        git -C "$REPO_ROOT" rev-parse "$BETA_REF"
    )"

    LOCAL_HEAD="$(
        git -C "$REPO_ROOT" rev-parse HEAD
    )"
}

###############################################################################
# Push local history if necessary
###############################################################################

push_local_history() {

    refresh_heads

    echo
    echo "Beta HEAD:"
    echo "  $BETA_HEAD"

    echo "Local HEAD:"
    echo "  $LOCAL_HEAD"

    if [[ "$LOCAL_HEAD" == "$BETA_HEAD" ]]; then
        return 0
    fi

    #
    # Local is ahead of Beta.
    #

    if git -C "$REPO_ROOT" merge-base \
        --is-ancestor "$BETA_HEAD" "$LOCAL_HEAD"
    then

        echo
        echo "Local history is ahead of Beta."
        echo "Existing local commits will be pushed."
        echo "No GCC files will be recommitted."

        if [[ "$DRY_RUN" -eq 1 ]]; then
            echo
            echo "DRY-RUN: push existing local history."
            return 10
        fi

        echo
        echo "Pushing existing local history..."

        git_authenticated \
            push \
            "$BETA_URL" \
            "$BRANCH:$REMOTE_BRANCH"

        echo
        echo "Existing local history pushed."

        fetch_beta
        refresh_heads

        if [[ "$LOCAL_HEAD" != "$BETA_HEAD" ]]; then
            echo "error: push completed but Beta verification failed." >&2
            exit 5
        fi

        return 0
    fi

    #
    # Beta is ahead of local.
    #

    if git -C "$REPO_ROOT" merge-base \
        --is-ancestor "$LOCAL_HEAD" "$BETA_HEAD"
    then

        echo
        echo "Beta contains commits not currently in local HEAD."

        if [[ "$DRY_RUN" -eq 1 ]]; then
            echo
            echo "DRY-RUN: local checkout would need to fast-forward."
            return 11
        fi

        echo
        echo "Fast-forwarding local checkout to Beta..."

        git -C "$REPO_ROOT" merge --ff-only "$BETA_REF"

        refresh_heads

        return 0
    fi

    #
    # Genuine divergence.
    #

    echo
    echo "error: local and Beta histories have diverged." >&2
    echo >&2
    echo "Beta HEAD:" >&2
    echo "  $BETA_HEAD" >&2
    echo >&2
    echo "Local HEAD:" >&2
    echo "  $LOCAL_HEAD" >&2
    echo >&2
    echo "No merge and no force push will be attempted automatically." >&2
    echo >&2
    echo "Resolve the repository history manually before continuing." >&2

    exit 20
}

###############################################################################
# Fetch Beta before ANY SHA comparison.
###############################################################################

if [[ "$DRY_RUN" -eq 0 ]]; then
    fetch_beta
else
    echo
    echo "DRY-RUN:"
    echo "Beta would be fetched before history comparison."
fi

if [[ "$DRY_RUN" -eq 0 ]]; then

    push_local_history

else

    echo
    echo "DRY-RUN: remote/local ancestry comparison deferred."

fi

###############################################################################
# Check unrelated staged changes.
###############################################################################

STAGED="$(
    git -C "$REPO_ROOT" diff --cached --name-only
)"

if [[ -n "$STAGED" ]]; then

    OUTSIDE="$(
        printf '%s\n' "$STAGED" |
        awk -v p="$SOURCE_REL/" '
            index($0,p) != 1 { print }
        '
    )"

    if [[ -n "$OUTSIDE" ]]; then

        echo
        echo "error: unrelated staged files exist:" >&2
        printf '%s\n' "$OUTSIDE" >&2
        exit 1
    fi
fi

###############################################################################
# If GCC files are already staged, preserve that batch.
###############################################################################

mapfile -t STAGED_GCC < <(
    git -C "$REPO_ROOT" diff --cached --name-only -- "$SOURCE_REL"
)

if [[ "${#STAGED_GCC[@]}" -eq 0 ]]; then

    ###########################################################################
    # Build next ~200 MiB batch.
    ###########################################################################

    BATCH_FILE="$(mktemp)"
    TMP_FILES+=("$BATCH_FILE")

    TOTAL_BYTES=0
    FILE_COUNT=0

    mapfile -d '' -t CANDIDATES < <(
        {
            git -C "$REPO_ROOT" diff \
                --name-only \
                -z \
                -- "$SOURCE_REL"

            git -C "$REPO_ROOT" ls-files \
                --others \
                --exclude-standard \
                -z \
                -- "$SOURCE_REL"
        } |
        sort -zu
    )

    for path in "${CANDIDATES[@]}"; do

        [[ -f "$REPO_ROOT/$path" ]] || continue

        size="$(
            wc -c < "$REPO_ROOT/$path" |
            tr -d ' '
        )"

        if (( size >= FILE_LIMIT_BYTES )); then

            echo
            echo "error: individual file exceeds ${FILE_LIMIT_MB} MiB:"
            echo "  $path"
            echo "  $size bytes"
            echo
            echo "Git LFS or another repository strategy is required."
            exit 3
        fi

        if (( FILE_COUNT > 0 &&
              TOTAL_BYTES + size > BATCH_BYTES ))
        then
            continue
        fi

        printf '%s\0' "$path" >> "$BATCH_FILE"

        TOTAL_BYTES=$((TOTAL_BYTES + size))
        FILE_COUNT=$((FILE_COUNT + 1))
    done

    ###########################################################################
    # Nothing left.
    ###########################################################################

    if (( FILE_COUNT == 0 )); then

        if [[ "$DRY_RUN" -eq 1 ]]; then
            echo
            echo "STATUS=DRY_RUN_NO_NEW_GCC_FILES"
            exit 0
        fi

        fetch_beta
        refresh_heads

        if [[ "$LOCAL_HEAD" == "$BETA_HEAD" ]]; then

            echo
            echo "No uncommitted GCC files remain."
            echo "Beta and local HEAD are synchronized:"
            echo "  $LOCAL_HEAD"
            echo
            echo "STATUS=COMPLETE"

            exit 0
        fi

        #
        # There are no uncommitted files but history isn't synchronized.
        # push_local_history should normally have handled this.
        #

        echo
        echo "error: no uncommitted GCC files remain, but local and Beta"
        echo "histories are not synchronized." >&2

        exit 4
    fi

    ###########################################################################
    # Dry run.
    ###########################################################################

    if [[ "$DRY_RUN" -eq 1 ]]; then

        echo
        echo "NEXT GCC BATCH"
        echo "=============="
        echo "files=$FILE_COUNT"
        echo "bytes=$TOTAL_BYTES"
        echo "target=$BATCH_BYTES"
        echo

        while IFS= read -r -d '' path; do

            size="$(
                wc -c < "$REPO_ROOT/$path" |
                tr -d ' '
            )"

            printf '%12d  %s\n' "$size" "$path"

        done < "$BATCH_FILE"

        echo
        echo "STATUS=DRY_RUN"

        exit 0
    fi

    ###########################################################################
    # Stage exactly this batch.
    ###########################################################################

    while IFS= read -r -d '' path; do
        git -C "$REPO_ROOT" add -- "$path"
    done < "$BATCH_FILE"

    rm -f -- "$BATCH_FILE"

    mapfile -t STAGED_GCC < <(
        git -C "$REPO_ROOT" diff --cached --name-only -- "$SOURCE_REL"
    )

    FILE_COUNT="${#STAGED_GCC[@]}"

    if (( FILE_COUNT == 0 )); then
        echo "error: no files staged." >&2
        exit 1
    fi

    TOTAL_BYTES=0

    for path in "${STAGED_GCC[@]}"; do

        [[ -f "$REPO_ROOT/$path" ]] || continue

        size="$(
            wc -c < "$REPO_ROOT/$path" |
            tr -d ' '
        )"

        TOTAL_BYTES=$((TOTAL_BYTES + size))
    done

else

    FILE_COUNT="${#STAGED_GCC[@]}"
    TOTAL_BYTES=0

    for path in "${STAGED_GCC[@]}"; do

        [[ -f "$REPO_ROOT/$path" ]] || continue

        size="$(
            wc -c < "$REPO_ROOT/$path" |
            tr -d ' '
        )"

        TOTAL_BYTES=$((TOTAL_BYTES + size))
    done
fi

###############################################################################
# Commit
###############################################################################

COMMIT_MESSAGE="$(
    printf '%s: %s (%d files, %d bytes)' \
        "$COMMIT_PREFIX" \
        "$(date '+%Y-%m-%d %H:%M:%S')" \
        "$FILE_COUNT" \
        "$TOTAL_BYTES"
)"

echo
echo "Creating GCC batch commit:"
echo "  files: $FILE_COUNT"
echo "  bytes: $TOTAL_BYTES"
echo

git -C "$REPO_ROOT" commit -m "$COMMIT_MESSAGE"

NEW_HEAD="$(
    git -C "$REPO_ROOT" rev-parse HEAD
)"

echo
echo "Commit successful:"
echo "  $NEW_HEAD"

###############################################################################
# Push newly-created commit.
###############################################################################

if [[ "$DRY_RUN" -eq 1 ]]; then
    echo
    echo "STATUS=DRY_RUN"
    exit 0
fi

fetch_beta
refresh_heads

if [[ "$LOCAL_HEAD" == "$BETA_HEAD" ]]; then

    echo
    echo "New commit is already on Beta:"
    echo "  $NEW_HEAD"

else

    if ! git -C "$REPO_ROOT" merge-base \
        --is-ancestor "$BETA_HEAD" "$LOCAL_HEAD"
    then

        echo
        echo "error: Beta diverged after the commit was created." >&2
        echo "No force push will be attempted." >&2
        exit 20
    fi

    echo
    echo "Pushing GCC batch to Beta..."

    if ! git_authenticated \
        push \
        "$BETA_URL" \
        "$BRANCH:$REMOTE_BRANCH"
    then

        echo
        echo "Push failed."
        echo
        echo "The commit remains safely local:"
        echo "  $NEW_HEAD"
        echo
        echo "Run this script again after correcting authentication."
        echo "It will push this existing commit rather than recommitting it."

        exit 4
    fi

    ###########################################################################
    # Verify the push.
    ###########################################################################

    fetch_beta
    refresh_heads

    if [[ "$LOCAL_HEAD" != "$BETA_HEAD" ]]; then

        echo
        echo "error: push returned but Beta verification failed." >&2
        echo "local=$LOCAL_HEAD" >&2
        echo "beta=$BETA_HEAD" >&2

        exit 5
    fi
fi

echo
echo "Verified on Beta:"
echo "  $NEW_HEAD"

echo
echo "STATUS=BATCH_PUSHED"

###############################################################################
# Stop after one batch if requested.
###############################################################################

if [[ "$ONE" -eq 1 ]]; then

    echo
    echo "Stopped after one successful batch (--one)."
    exit 0
fi

###############################################################################
# Continue.
#
# Files in the successful commit are now in HEAD, so they no longer appear
# as uncommitted candidates and cannot be selected again.
###############################################################################

exec "$0"
