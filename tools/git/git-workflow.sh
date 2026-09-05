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
#   ./tools/git/git-workflow.sh premount [repo] [--add|--commit|--both]

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
  git-workflow.sh premount [repo] [--add|--commit|--both]
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

  premount)
    # Read-only pre-operation inventory of files newly introduced by a
    # pending add, a pending commit, or both. Prints a deterministic table.
    # Never stages, commits, or pushes. See tools/git/PREMOUNT.md.
    SOURCE="${3:---both}"
    case "$SOURCE" in
      --add)    WANT_ADD=1; WANT_COMMIT=0 ;;
      --commit) WANT_ADD=0; WANT_COMMIT=1 ;;
      --both)   WANT_ADD=1; WANT_COMMIT=1 ;;
      *) echo "ERROR: premount source must be --add, --commit, or --both." >&2; exit 2 ;;
    esac

    ROOT="$(git -C "$REPO" rev-parse --show-toplevel)"
    OS_ID="$(uname -s -r 2>/dev/null || echo unknown)"

    # Collect candidate paths deterministically, without double-counting.
    # add     = new files in the worktree not yet tracked/staged (?? or  A via intent)
    # commit  = new files staged for the next commit (A in the index)
    # We deduplicate by pathname; a path present in both is marked "both".
    declare -A SRC_OF=()
    ORDER=()

    add_candidate() {
      local path="$1" src="$2"
      if [ -z "${SRC_OF[$path]:-}" ]; then
        SRC_OF["$path"]="$src"
        ORDER+=("$path")
      elif [ "${SRC_OF[$path]}" != "$src" ]; then
        SRC_OF["$path"]="both"
      fi
    }

    # git status --porcelain: XY <path>. X=index status, Y=worktree status.
    while IFS= read -r line; do
      [ -n "$line" ] || continue
      x="${line:0:1}"; y="${line:1:1}"; p="${line:3}"
      # Strip surrounding quotes git adds for unusual paths.
      p="${p%\"}"; p="${p#\"}"
      if [ "$WANT_COMMIT" = 1 ] && [ "$x" = "A" ]; then
        add_candidate "$p" "commit"
      fi
      if [ "$WANT_ADD" = 1 ] && { [ "$y" = "?" ] || [ "$x" = "?" ]; }; then
        add_candidate "$p" "add"
      fi
    done < <(git -C "$REPO" status --porcelain)

    # Sort candidate paths in deterministic Git pathname order.
    if [ "${#ORDER[@]}" -gt 0 ]; then
      mapfile -t ORDER < <(printf '%s\n' "${ORDER[@]}" | LC_ALL=C sort)
    fi

    TS="$(date -u +%Y-%m-%dT%H:%M:%SZ)"

    printf '=== git premount inventory (%s) ===\n' "$SOURCE"
    printf 'Repository: %s\n' "$ROOT"
    printf 'Generated:  %s\n\n' "$TS"

    fmt='%-32s | %-20s | %-24s | %10s | %-8s | %-24s | %-13s | %-20s | %-18s | %-22s\n'
    # shellcheck disable=SC2059
    printf "$fmt" \
      "path" "timestamp" "author" "size" "suffix" "operating system" \
      "learning grade" "cs prerequisites" "graded authorships" "college references"
    # shellcheck disable=SC2059
    printf "$fmt" \
      "--------------------------------" "--------------------" \
      "------------------------" "----------" "--------" \
      "------------------------" "-------------" "--------------------" \
      "------------------" "----------------------"

    TOTAL=0
    for p in "${ORDER[@]:-}"; do
      [ -n "$p" ] || continue
      abs="$ROOT/$p"

      # size: object-byte estimate ~ on-disk file length.
      if [ -f "$abs" ]; then
        size="$(wc -c < "$abs" 2>/dev/null | tr -d ' ')"
      else
        size=0
      fi
      [ -n "$size" ] || size=0
      TOTAL=$((TOTAL + size))

      # suffix: trailing .ext of the basename, else "(none)".
      base="${p##*/}"
      if [ "$base" = "${base%.*}" ]; then suffix="(none)"; else suffix=".${base##*.}"; fi

      # author: last known Git author for the path, else the configured identity.
      author="$(git -C "$REPO" log -1 --format='%an' -- "$p" 2>/dev/null || true)"
      [ -n "$author" ] || author="$(git -C "$REPO" config user.name 2>/dev/null || echo '(unset)')"

      # Advisory pedagogical metadata is not invented: absent unless declared.
      grade="ungraded"
      cs_prereq="(none declared)"
      graded_auth="(none declared)"
      college_ref="(none declared)"

      # shellcheck disable=SC2059
      printf "$fmt" \
        "$p" "$TS" "$author" "$size" "$suffix" "$OS_ID" \
        "$grade" "$cs_prereq" "$graded_auth" "$college_ref"
    done

    printf '\nFiles: %d    Total object bytes: %d\n' "${#ORDER[@]}" "$TOTAL"
    printf 'Note: premount is read-only; it stages/commits/pushes nothing.\n'
    ;;

  *)
    echo "ERROR: unknown command: $command" >&2
    usage
    ;;
esac
