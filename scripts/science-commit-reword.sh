#!/usr/bin/env bash
#
# science-commit-reword.sh
#
# Reword every commit on the current branch authored within the last <DAYS> days
# to the message:  "Science Commit 7."
#
# Mechanism (exactly as requested):
#   git rebase --exec 'git commit --amend -m "Science Commit 7." --no-edit' <base>
#   git push --force-with-lease origin <branch>
#
# WARNING — THIS REWRITES HISTORY.
#   * Every reworded commit (and every commit after it) gets a NEW SHA.
#   * It force-pushes the branch. Existing SHAs, PR references, and anyone else's
#     clones will diverge. Coordinate with collaborators first.
#   * Run it on a real local clone (this needs a working tree; it cannot run
#     through the GitHub API).
#
# Usage:
#   ./science-commit-reword.sh <days>              # dry run (shows what it would do)
#   ./science-commit-reword.sh <days> --apply      # actually rewrite + push
#
# Options / env:
#   MESSAGE="..."     override the commit message (default: "Science Commit 7.")
#   REMOTE=origin     remote to push to (default: origin)
#   BRANCH=<name>     branch to operate on (default: current branch)
#   INCLUDE_MERGES=1  also reword merge commits (default: 0 = keep merges as-is
#                     via --rebase-merges; rewording merges is usually unwanted)

set -euo pipefail

MESSAGE="${MESSAGE:-Science Commit 7.}"
REMOTE="${REMOTE:-origin}"
INCLUDE_MERGES="${INCLUDE_MERGES:-0}"

die() { echo "ERROR: $*" >&2; exit 1; }

# ---- args ----
DAYS="${1:-}"
APPLY="${2:-}"
[ -n "$DAYS" ] || die "usage: $0 <days> [--apply]"
[[ "$DAYS" =~ ^[1-9][0-9]*$ ]] || die "<days> must be a positive integer (got: '$DAYS')"

# ---- preconditions ----
command -v git >/dev/null 2>&1 || die "git is required."
git rev-parse --is-inside-work-tree >/dev/null 2>&1 || die "not inside a git working tree (clone the repo and run from inside it)."

BRANCH="${BRANCH:-$(git symbolic-ref --quiet --short HEAD)}" || true
[ -n "${BRANCH:-}" ] || die "detached HEAD; set BRANCH=<name> explicitly."

# refuse to run on a dirty tree — rebase would fail or lose work
if [ -n "$(git status --porcelain)" ]; then
  die "working tree is not clean; commit or stash changes first."
fi

SINCE_ISO="$(git log -1 --format=%cI 2>/dev/null >/dev/null && date -u -d "$DAYS days ago" +%Y-%m-%dT%H:%M:%S 2>/dev/null || true)"
# Portable "N days ago" (GNU date vs BSD/macOS date)
if date -u -d "$DAYS days ago" >/dev/null 2>&1; then
  CUTOFF="$(date -u -d "$DAYS days ago" +%Y-%m-%dT%H:%M:%S)"
else
  CUTOFF="$(date -u -v-"${DAYS}"d +%Y-%m-%dT%H:%M:%S)"
fi

echo "=== science-commit-reword ==="
echo "Branch        : $BRANCH"
echo "Remote        : $REMOTE"
echo "Window        : last $DAYS day(s)  (commits after $CUTOFF UTC)"
echo "New message   : $MESSAGE"
echo

# ---- find the base: the newest commit OLDER than the cutoff ----
# All commits strictly after $CUTOFF are in-window and will be reworded.
BASE="$(git log --first-parent --before="$CUTOFF" -1 --format=%H "$BRANCH" 2>/dev/null || true)"

# Collect the in-window commits (for reporting), newest first.
mapfile -t INWINDOW < <(git log --since="$CUTOFF" --format='%h %cI %s' "$BRANCH")

if [ "${#INWINDOW[@]}" -eq 0 ]; then
  echo "No commits on '$BRANCH' within the last $DAYS day(s). Nothing to do."
  exit 0
fi

echo "Commits to reword (${#INWINDOW[@]}):"
printf '  %s\n' "${INWINDOW[@]}"
echo

if [ -z "$BASE" ]; then
  echo "NOTE: every commit on the branch is within the window."
  echo "      This will rewrite from the ROOT commit (rebase --root)."
  REBASE_BASE=(--root)
else
  echo "Rebase base (unchanged, just before window): $BASE"
  REBASE_BASE=("$BASE")
fi

# The amend exec. --no-edit keeps author/date; -m sets the new message.
# --allow-empty so the reword also works for empty commits (real commits are
# unaffected by this flag).
AMEND_CMD="git commit --amend -m \"$MESSAGE\" --no-edit --allow-empty"

REBASE_FLAGS=()
# --empty=keep so any pre-existing empty commits are preserved during rebase
# rather than silently dropped.
REBASE_FLAGS+=(--empty=keep)
if [ "$INCLUDE_MERGES" = "1" ]; then
  REBASE_FLAGS+=(--rebase-merges)
fi

echo
if [ "$APPLY" != "--apply" ]; then
  cat <<EOF
DRY RUN — nothing changed. To actually rewrite history and push, re-run with --apply:

  $0 $DAYS --apply

The apply step will run:
  git rebase ${REBASE_FLAGS[*]} ${REBASE_BASE[*]} \\
      --exec '$AMEND_CMD'
  git push --force-with-lease $REMOTE $BRANCH
EOF
  exit 0
fi

# ---- APPLY ----
# Safety backup ref so you can restore if something looks wrong:
BACKUP="refs/backups/pre-science-reword/$BRANCH/$(date -u +%Y%m%dT%H%M%SZ)"
git update-ref "$BACKUP" "$BRANCH"
echo "Backup of current tip saved at: $BACKUP"
echo "  (restore with:  git update-ref refs/heads/$BRANCH $BACKUP  &&  git reset --hard $BRANCH )"
echo

echo ">> Rewriting messages via rebase --exec ..."
# Disable the interactive editor so --amend/rebase never blocks on a prompt.
GIT_SEQUENCE_EDITOR=true GIT_EDITOR=true \
  git rebase "${REBASE_FLAGS[@]}" "${REBASE_BASE[@]}" \
    --exec "$AMEND_CMD"

echo
echo ">> Pushing with --force-with-lease (safe force: aborts if remote moved) ..."
git push --force-with-lease "$REMOTE" "$BRANCH"

echo
echo "Done. All commits on '$BRANCH' from the last $DAYS day(s) now read: \"$MESSAGE\""
echo "If anything is wrong, restore with:"
echo "  git reset --hard $BACKUP && git push --force-with-lease $REMOTE $BRANCH"
