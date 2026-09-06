#:!/usr/bin/env bash
#
# github-push.sh
#
# Run from the repository root:
#     ./github-push.sh
#
# Features:
#   - Assumes current directory (.) is the Git repository.
#   - Detects already-staged files at startup.
#   - Shows files before and after git add.
#   - Shows commit details.
#   - Prompts for GitHub username and PAT.
#   - Prevents Git authentication prompts from hanging.
#   - Places time limits on potentially blocking Git operations.
#   - Captures stderr for debugging.
#   - Displays stderr immediately when an operation fails or times out.
#   - Checks for files at/above GitHub's 100 MiB limit.
#

set -uo pipefail

export GIT_PAGER=cat
export PAGER=cat
export LESS=
export GIT_TERMINAL_PROMPT=0
REPO_DIR="."
REMOTE_NAME="origin"
BRANCH="main"

# ------------------------------------------------------------
# TIMEOUT CONFIGURATION
# ------------------------------------------------------------
#
# Default timeout for Git network operations.
# Increase with:
#
#     GIT_TIMEOUT=300 ./github-push.sh
#
# Five minutes is normally more than sufficient.
#

GIT_TIMEOUT="${GIT_TIMEOUT:-300}"

# Local Git operations generally should not take this long.
LOCAL_GIT_TIMEOUT="${LOCAL_GIT_TIMEOUT:-60}"

DEBUG_LOG="${DEBUG_LOG:-/tmp/github-push-debug.log}"

# ------------------------------------------------------------
# INITIAL OUTPUT
# ------------------------------------------------------------

echo
echo "============================================================"
echo " GitHub Push Utility"
echo "============================================================"
echo
echo "Repository directory : $(pwd)"
echo "Remote               : ${REMOTE_NAME}"
echo "Branch               : ${BRANCH}"
echo "Network timeout      : ${GIT_TIMEOUT} seconds"
echo "Local Git timeout    : ${LOCAL_GIT_TIMEOUT} seconds"
echo "Debug log            : ${DEBUG_LOG}"
echo

# ------------------------------------------------------------
# CHECK REQUIRED COMMANDS
# ------------------------------------------------------------

for COMMAND in git timeout find stat; do
    if ! command -v "$COMMAND" >/dev/null 2>&1; then
        echo "ERROR: Required command not found: ${COMMAND}" >&2
        exit 1
    fi
done

# ------------------------------------------------------------
# CREATE / CLEAR DEBUG LOG
# ------------------------------------------------------------

: > "$DEBUG_LOG"

if [[ ! -w "$DEBUG_LOG" ]]; then
    echo "ERROR: Cannot write debug log:"
    echo "       ${DEBUG_LOG}"
    exit 1
fi

# ------------------------------------------------------------
# GIT COMMAND WRAPPER
# ------------------------------------------------------------
#
# Usage:
#
#     run_git_local git status
#     run_git_network git push origin main
#
# stderr is captured to DEBUG_LOG.
#
# Return code 124 indicates timeout.
#

run_git_local() {

    local START
    local END
    local ELAPSED
    local RC

    START="$(date +%s)"

    echo "DEBUG: Starting local Git command:"
    printf '       '
    printf '%q ' "$@"
    echo
    echo

    timeout \
        --signal=TERM \
        --kill-after=10 \
        "${LOCAL_GIT_TIMEOUT}s" \
        "$@" \
        2>>"$DEBUG_LOG"

    RC=$?

    END="$(date +%s)"
    ELAPSED=$((END - START))

    if [[ "$RC" -eq 124 || "$RC" -eq 137 ]]; then
        echo
        echo "============================================================"
        echo " GIT COMMAND TIMED OUT"
        echo "============================================================"
        echo
        echo "Command exceeded ${LOCAL_GIT_TIMEOUT} seconds."
        echo
        echo "Command:"
        printf '  %q ' "$@"
        echo
        echo
        echo "Captured stderr:"
        cat "$DEBUG_LOG" >&2
        echo
        echo "Debug log:"
        echo "  ${DEBUG_LOG}"
        return 124
    fi

    if [[ "$RC" -ne 0 ]]; then
        echo
        echo "============================================================"
        echo " GIT COMMAND FAILED"
        echo "============================================================"
        echo
        echo "Exit code : ${RC}"
        echo "Elapsed   : ${ELAPSED} seconds"
        echo
        echo "Command:"
        printf '  %q ' "$@"
        echo
        echo
        echo "Captured stderr:"
        cat "$DEBUG_LOG" >&2
        echo
        echo "Debug log:"
        echo "  ${DEBUG_LOG}"
        return "$RC"
    fi

    echo "DEBUG: Git command completed in ${ELAPSED} seconds."
    echo

    return 0
}


run_git_network() {

    local START
    local END
    local ELAPSED
    local RC

    START="$(date +%s)"

    echo "DEBUG: Starting network Git command:"
    printf '       '
    printf '%q ' "$@"
    echo
    echo

    timeout \
        --signal=TERM \
        --kill-after=15 \
        "${GIT_TIMEOUT}s" \
        env \
            GIT_TERMINAL_PROMPT=0 \
            GIT_ASKPASS=/bin/false \
            "$@" \
            2>>"$DEBUG_LOG"

    RC=$?

    END="$(date +%s)"
    ELAPSED=$((END - START))

    if [[ "$RC" -eq 124 || "$RC" -eq 137 ]]; then
        echo
        echo "============================================================"
        echo " NETWORK GIT COMMAND TIMED OUT"
        echo "============================================================"
        echo
        echo "Command exceeded ${GIT_TIMEOUT} seconds."
        echo
        echo "Command:"
        printf '  %q ' "$@"
        echo
        echo
        echo "Captured stderr:"
        cat "$DEBUG_LOG" >&2
        echo
        echo "Debug log:"
        echo "  ${DEBUG_LOG}"
        return 124
    fi

    if [[ "$RC" -ne 0 ]]; then
        echo
        echo "============================================================"
        echo " NETWORK GIT COMMAND FAILED"
        echo "============================================================"
        echo
        echo "Exit code : ${RC}"
        echo "Elapsed   : ${ELAPSED} seconds"
        echo
        echo "Command:"
        printf '  %q ' "$@"
        echo
        echo
        echo "Captured stderr:"
        cat "$DEBUG_LOG" >&2
        echo
        echo "Debug log:"
        echo "  ${DEBUG_LOG}"
        return "$RC"
    fi

    echo "DEBUG: Network Git command completed in ${ELAPSED} seconds."
    echo

    return 0
}

# ------------------------------------------------------------
# VERIFY GIT REPOSITORY
# ------------------------------------------------------------

if ! git -C "$REPO_DIR" rev-parse --is-inside-work-tree \
    >/dev/null 2>>"$DEBUG_LOG"; then

    echo "ERROR: Current directory is not a Git repository."
    echo
    echo "Git stderr:"
    cat "$DEBUG_LOG" >&2
    exit 1
fi

# ------------------------------------------------------------
# CHECK FOR ALREADY-STAGED FILES FIRST
# ------------------------------------------------------------

echo "============================================================"
echo " CHECKING FOR ALREADY-ADDED FILES"
echo "============================================================"
echo

STAGED_FILES="$(
    git -C "$REPO_DIR" diff --cached --name-status \
        2>>"$DEBUG_LOG"
)"

if [[ -n "$STAGED_FILES" ]]; then

    echo "The following files are ALREADY STAGED:"
    echo
    printf '%s\n' "$STAGED_FILES"
    echo

    echo "------------------------------------------------------------"
    echo "Already-Staged Statistics"
    echo "------------------------------------------------------------"

    git -C "$REPO_DIR" diff --cached --stat \
        2>>"$DEBUG_LOG"

    echo

    echo "These files are already in the staging area."
    echo "They will not be unnecessarily removed or re-created."
    echo

    read -r -p \
        "Continue and inspect additional unstaged changes? [Y/n]: " \
        CONTINUE_STAGED

    if [[ "$CONTINUE_STAGED" =~ ^[Nn]$ ]]; then
        echo
        echo "Stopping before modifying the staging area."
        exit 0
    fi

else

    echo "No files are currently staged."
    echo

fi

# ------------------------------------------------------------
# CURRENT STATUS
# ------------------------------------------------------------

echo "============================================================"
echo " CURRENT WORKING TREE"
echo "============================================================"
echo

git -C "$REPO_DIR" status --short 2>>"$DEBUG_LOG"

STATUS_RC=$?

if [[ "$STATUS_RC" -ne 0 ]]; then
    echo
    echo "ERROR: Unable to obtain Git status."
    cat "$DEBUG_LOG" >&2
    exit "$STATUS_RC"
fi

echo

# ------------------------------------------------------------
# UNTRACKED FILES
# ------------------------------------------------------------

echo "------------------------------------------------------------"
echo "Untracked Files"
echo "------------------------------------------------------------"

UNTRACKED_FILES="$(
    git -C "$REPO_DIR" ls-files --others --exclude-standard \
        2>>"$DEBUG_LOG"
)"

if [[ -n "$UNTRACKED_FILES" ]]; then
    printf '%s\n' "$UNTRACKED_FILES"
else
    echo "None."
fi

echo

# ------------------------------------------------------------
# UNSTAGED MODIFICATIONS
# ------------------------------------------------------------

echo "------------------------------------------------------------"
echo "Modified / Deleted Unstaged Files"
echo "------------------------------------------------------------"

UNSTAGED_FILES="$(
    git -C "$REPO_DIR" diff --name-status \
        2>>"$DEBUG_LOG"
)"

if [[ -n "$UNSTAGED_FILES" ]]; then
    printf '%s\n' "$UNSTAGED_FILES"
else
    echo "None."
fi

echo

# ------------------------------------------------------------
# ADD ONLY WHEN NECESSARY
# ------------------------------------------------------------

if [[ -n "$UNTRACKED_FILES" || -n "$UNSTAGED_FILES" ]]; then

    echo "============================================================"
    echo " FILES REQUIRING git add"
    echo "============================================================"
    echo

    if [[ -n "$UNTRACKED_FILES" ]]; then
        echo "[UNTRACKED]"
        printf '%s\n' "$UNTRACKED_FILES"
        echo
    fi

    if [[ -n "$UNSTAGED_FILES" ]]; then
        echo "[MODIFIED / DELETED]"
        printf '%s\n' "$UNSTAGED_FILES"
        echo
    fi

    read -r -p \
        "Run 'git add .' for these changes? [y/N]: " \
        ADD_CONFIRM

    if [[ "$ADD_CONFIRM" =~ ^[Yy]$ ]]; then

        echo
        echo "Running:"
        echo "  git add ."
        echo

        if ! run_git_local git -C "$REPO_DIR" add .; then
            echo
            echo "ERROR: git add failed."
            exit 1
        fi

        echo "git add . completed."
        echo

    else

        echo
        echo "git add cancelled."
        echo "Existing staged files remain staged."
        echo
    fi

else

    echo "============================================================"
    echo " NO ADDITIONAL FILES REQUIRE git add"
    echo "============================================================"
    echo

fi

# ------------------------------------------------------------
# FINAL STAGING AREA
# ------------------------------------------------------------

echo "============================================================"
echo " FINAL STAGING AREA"
echo "============================================================"
echo

FINAL_STAGED="$(
    git -C "$REPO_DIR" diff --cached --name-status \
        2>>"$DEBUG_LOG"
)"

if [[ -n "$FINAL_STAGED" ]]; then

    printf '%s\n' "$FINAL_STAGED"

    echo

    git -C "$REPO_DIR" diff --cached --stat \
        2>>"$DEBUG_LOG"

    echo

else

    echo "No files are staged for commit."
    echo
    exit 0
fi

# ------------------------------------------------------------
# LARGE FILE CHECK
# ------------------------------------------------------------

echo "============================================================"
echo " LARGE FILE CHECK"
echo "============================================================"
echo

MAX_BYTES=$((100 * 1024 * 1024))
LARGE_FILES_FOUND=0

while IFS= read -r -d '' FILE; do

    if [[ -f "$FILE" ]]; then

        SIZE="$(
            stat -c '%s' "$FILE" 2>/dev/null ||
            stat -f '%z' "$FILE" 2>/dev/null
        )"

        if [[ -n "$SIZE" ]] && (( SIZE >= MAX_BYTES )); then

            echo "ERROR: File is at or above 100 MiB:"
            echo "       $FILE"
            echo "       Size: $SIZE bytes"

            LARGE_FILES_FOUND=1
        fi
    fi

done < <(
    find "$REPO_DIR" \
        -type f \
        -not -path './.git/*' \
        -print0
)

if (( LARGE_FILES_FOUND == 0 )); then
    echo "No files at or above 100 MiB were found."
fi

echo

if (( LARGE_FILES_FOUND != 0 )); then
    echo "Push aborted."
    exit 1
fi

# ------------------------------------------------------------
# COMMIT MESSAGE
# ------------------------------------------------------------

echo "============================================================"
echo " COMMIT"
echo "============================================================"
echo

DEFAULT_MESSAGE="Update repository"

read -r -p \
    "Commit message [${DEFAULT_MESSAGE}]: " \
    COMMIT_MESSAGE

if [[ -z "$COMMIT_MESSAGE" ]]; then
    COMMIT_MESSAGE="$DEFAULT_MESSAGE"
fi

echo
echo "Commit message:"
echo "  ${COMMIT_MESSAGE}"
echo

read -r -p "Create this commit? [y/N]: " COMMIT_CONFIRM

if [[ ! "$COMMIT_CONFIRM" =~ ^[Yy]$ ]]; then
    echo
    echo "Commit cancelled."
    exit 0
fi

echo
echo "Running:"
echo "  git commit -m \"$COMMIT_MESSAGE\""
echo

if ! run_git_local \
    git -C "$REPO_DIR" commit -m "$COMMIT_MESSAGE"; then

    echo
    echo "ERROR: Commit failed."
    exit 1
fi

# ------------------------------------------------------------
# DISPLAY COMMIT
# ------------------------------------------------------------

echo
echo "============================================================"
echo " NEW COMMIT"
echo "============================================================"
echo

git -C "$REPO_DIR" log -1 --pretty=fuller 2>>"$DEBUG_LOG"

echo

git -C "$REPO_DIR" show \
    --stat \
    --oneline \
    --summary \
    HEAD \
    2>>"$DEBUG_LOG"

echo

# ------------------------------------------------------------
# GITHUB AUTHENTICATION
# ------------------------------------------------------------

echo "============================================================"
echo " GITHUB AUTHENTICATION"
echo "============================================================"
echo
echo "For HTTPS GitHub authentication:"
echo
echo "  Username = GitHub username"
echo "  Password = GitHub Personal Access Token (PAT)"
echo
echo "A normal GitHub account password is not accepted for"
echo "Git HTTPS authentication."
echo

read -r -p "GitHub username: " GITHUB_USERNAME

if [[ -z "$GITHUB_USERNAME" ]]; then
    echo "ERROR: GitHub username cannot be empty."
    exit 1
fi

read -r -s -p "GitHub password / PAT: " GITHUB_TOKEN
echo

if [[ -z "$GITHUB_TOKEN" ]]; then
    echo "ERROR: Password/PAT cannot be empty."
    exit 1
fi

echo

# ------------------------------------------------------------
# CONFIGURE TEMPORARY CREDENTIAL CACHE
# ------------------------------------------------------------

echo "------------------------------------------------------------"
echo "Configuring Temporary Git Credentials"
echo "------------------------------------------------------------"

git -C "$REPO_DIR" config --local credential.helper \
    "cache --timeout=3600" \
    2>>"$DEBUG_LOG"

if [[ $? -ne 0 ]]; then
    echo "ERROR: Could not configure Git credential cache."
    cat "$DEBUG_LOG" >&2
    unset GITHUB_TOKEN
    exit 1
fi

printf \
    'protocol=https\nhost=github.com\nusername=%s\npassword=%s\n\n' \
    "$GITHUB_USERNAME" \
    "$GITHUB_TOKEN" |
    git -C "$REPO_DIR" credential approve \
    2>>"$DEBUG_LOG"

CREDENTIAL_RC=$?

unset GITHUB_TOKEN

if [[ "$CREDENTIAL_RC" -ne 0 ]]; then
    echo
    echo "ERROR: Git credential setup failed."
    cat "$DEBUG_LOG" >&2
    exit 1
fi

echo "Credentials cached temporarily."
echo

# ------------------------------------------------------------
# FINAL PUSH INFORMATION
# ------------------------------------------------------------

echo "============================================================"
echo " PUSH SUMMARY"
echo "============================================================"
echo

echo "Repository:"
git -C "$REPO_DIR" remote get-url "$REMOTE_NAME"

echo
echo "Branch:"
echo "  ${BRANCH}"

echo
echo "Commit:"
echo "  $(git -C "$REPO_DIR" rev-parse --short HEAD)"

echo
echo "Author:"
echo "  $(git -C "$REPO_DIR" log -1 --format='%an <%ae>')"

echo
echo "Message:"
echo "  $(git -C "$REPO_DIR" log -1 --format='%s')"

echo
echo "Files in commit:"
git -C "$REPO_DIR" diff-tree \
    --no-commit-id \
    --name-status \
    -r HEAD \
    2>>"$DEBUG_LOG"

echo

# ------------------------------------------------------------
# PUSH CONFIRMATION
# ------------------------------------------------------------

read -r -p \
    "Push this commit to ${REMOTE_NAME}/${BRANCH}? [y/N]: " \
    PUSH_CONFIRM

if [[ ! "$PUSH_CONFIRM" =~ ^[Yy]$ ]]; then
    echo
    echo "Push cancelled."
    exit 0
fi

# ------------------------------------------------------------
# PUSH
# ------------------------------------------------------------

echo
echo "============================================================"
echo " PUSHING"
echo "============================================================"
echo

echo "Running:"
echo "  git push ${REMOTE_NAME} ${BRANCH}"
echo
echo "Timeout:"
echo "  ${GIT_TIMEOUT} seconds"
echo

if ! run_git_network \
    git -C "$REPO_DIR" push "$REMOTE_NAME" "$BRANCH"; then

    echo
    echo "============================================================"
    echo " PUSH FAILED OR TIMED OUT"
    echo "============================================================"
    echo
    echo "The Git operation did not complete successfully."
    echo
    echo "Full debugging information:"
    echo
    cat "$DEBUG_LOG" >&2
    echo
    echo "Debug log preserved at:"
    echo "  ${DEBUG_LOG}"
    exit 1
fi

# ------------------------------------------------------------
# COMPLETE
# ------------------------------------------------------------

echo
echo "============================================================"
echo " PUSH COMPLETE"
echo "============================================================"
echo

echo "Repository:"
git -C "$REPO_DIR" remote get-url "$REMOTE_NAME"

echo
echo "Branch:"
echo "  ${BRANCH}"

echo
echo "Commit:"
echo "  $(git -C "$REPO_DIR" rev-parse --short HEAD)"

echo
echo "Final status:"
git -C "$REPO_DIR" status --short

echo
echo "Debug log:"
echo "  ${DEBUG_LOG}"

echo
echo "Done."
