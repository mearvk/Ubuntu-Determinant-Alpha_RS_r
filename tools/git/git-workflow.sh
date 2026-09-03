#!/usr/bin/env bash
set -euo pipefail

# Ubuntu Determinant — safe Git workflow helper.
#
# This wrapper provides a small, non-destructive command surface around Git for
# repository maintenance. It intentionally refuses destructive operations such
# as reset --hard and force pushes.
#
# Usage:
#   ./tools/git/git-workflow.sh status [repo]
#   ./tools/git/git-workflow.sh verify [repo]
#   ./tools/git/git-workflow.sh log [repo] [count]
#   ./tools/git/git-workflow.sh branches [repo]
#   ./tools/git/git-workflow.sh fetch [repo] [remote]
#   ./tools/git/git-workflow.sh sync [repo] [remote] [branch]
#   ./tools/git/git-workflow.sh stage [repo] [pathspec...]
#   ./tools/git/git-workflow.sh commit [repo] <message>
#   ./tools/git/git-workflow.sh push [repo] [remote] [branch]

usage() {
  cat >&2 <<'EOF'
Usage:
  git-workflow.sh status [repo]
  git-workflow.sh verify [repo]
  git-workflow.sh log [repo] [count]
  git-workflow.sh branches [repo]
  git-workflow.sh fetch [repo] [remote]
  git-workflow.sh sync [repo] [remote] [branch]
  git-workflow.sh stage [repo] [pathspec...]
  git-workflow.sh commit [repo] <message>
  git-workflow.sh push [repo] [remote] [branch]
EOF
  exit 2
}

REPO="${2:-.}"

require_git() {
  command -v git >/dev/null 2>&1 || {
    echo "ERROR: git is required." >&2
    exit 1
  }
}

require_repo() {
  git -C "$REPO" rev-parse --git-dir >/dev/null 2>&1 || {
    echo "ERROR: not a Git repository: $REPO" >&2
    exit 1
  }
}

require_clean_before_sync() {
  if [ -n "$(git -C "$REPO" status --porcelain)" ]; then
    echo "ERROR: working tree is not clean; refusing to sync." >&2
    git -C "$REPO" status --short >&2
    exit 1
  fi
}

command="${1:-}"
[ -n "$command" ] || usage
require_git
require_repo

case "$command" in
  status)
    git -C "$REPO" status --short --branch
    ;;

  verify)
    echo "=== Git repository verification ==="
    echo "Repository: $REPO"
    echo "Root: $(git -C "$REPO" rev-parse --show-toplevel)"
    echo "Branch: $(git -C "$REPO" symbolic-ref --quiet --short HEAD || echo DETACHED)"
    echo "HEAD: $(git -C "$REPO" rev-parse HEAD)"
    echo "Object database: $(git -C "$REPO" count-objects -v | awk '/^count /{print $2}') loose objects"
    git -C "$REPO" fsck --no-progress --connectivity-only
    echo "=== Verification successful ==="
    ;;

  log)
    COUNT="${3:-20}"
    [[ "$COUNT" =~ ^[1-9][0-9]*$ ]] || { echo "ERROR: count must be a positive integer." >&2; exit 2; }
    git -C "$REPO" log --oneline --decorate --graph -n "$COUNT"
    ;;

  branches)
    git -C "$REPO" branch --all --verbose --no-abbrev
    ;;

  fetch)
    REMOTE="${3:-origin}"
    git -C "$REPO" fetch --prune "$REMOTE"
    ;;

  sync)
    REMOTE="${3:-origin}"
    BRANCH="${4:-$(git -C "$REPO" branch --show-current)}"
    [ -n "$BRANCH" ] || { echo "ERROR: detached HEAD; specify a branch explicitly." >&2; exit 2; }
    require_clean_before_sync
    git -C "$REPO" fetch --prune "$REMOTE"
    git -C "$REPO" merge --ff-only "$REMOTE/$BRANCH"
    ;;

  stage)
    shift 2
    [ "$#" -gt 0 ] || { echo "ERROR: stage requires at least one pathspec." >&2; exit 2; }
    git -C "$REPO" add -- "$@"
    git -C "$REPO" status --short
    ;;

  commit)
    MESSAGE="${3:-}"
    [ -n "$MESSAGE" ] || { echo "ERROR: commit requires a message." >&2; exit 2; }
    git -C "$REPO" diff --cached --quiet && {
      echo "ERROR: no staged changes to commit." >&2
      exit 1
    }
    git -C "$REPO" commit -m "$MESSAGE"
    ;;

  push)
    REMOTE="${3:-origin}"
    BRANCH="${4:-$(git -C "$REPO" branch --show-current)}"
    [ -n "$BRANCH" ] || { echo "ERROR: detached HEAD; specify a branch explicitly." >&2; exit 2; }
    git -C "$REPO" push --set-upstream "$REMOTE" "$BRANCH"
    ;;

  *)
    echo "ERROR: unknown command: $command" >&2
    usage
    ;;
esac
