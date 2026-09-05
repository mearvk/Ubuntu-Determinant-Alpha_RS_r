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
#   ./tools/git/git-workflow.sh commit-parts [repo] <message>
#   ./tools/git/git-workflow.sh push-resume [repo] [remote] [branch] [--attempts N]

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
  git-workflow.sh commit-parts [repo] <message>
  git-workflow.sh push-resume [repo] [remote] [branch] [--attempts N]
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

  commit-parts)
    # Commit staged work as an ordered, resumable sequence of parts. Each part
    # is an ordinary Git commit; the ordered chain is what a lossy push resumes
    # over (one 50 MiB logical unit per part is the intended native granularity;
    # see tools/git/COMMIT_PARTS.md and tools/git/RESUME.md).
    #
    # This shell surface is deliberately non-destructive: it makes a single
    # ordered commit of the currently staged set and reports the resulting tip
    # so push-resume can checkpoint against it. It never rewrites history.
    MESSAGE="${3:-}"
    [ -n "$MESSAGE" ] || { echo "ERROR: commit-parts requires a message." >&2; exit 2; }
    git -C "$REPO" diff --cached --quiet && {
      echo "ERROR: no staged changes to commit." >&2
      exit 1
    }
    BEFORE="$(git -C "$REPO" rev-parse --verify --quiet HEAD 2>/dev/null || true)"
    [ -n "$BEFORE" ] || BEFORE="(root)"
    git -C "$REPO" commit -m "$MESSAGE"
    AFTER="$(git -C "$REPO" rev-parse HEAD)"
    echo "commit-parts: ordered part committed"
    echo "  parent: $BEFORE"
    echo "  tip:    $AFTER"
    echo "Note: push the ordered chain with 'push-resume' on slow/lossy links."
    ;;

  push-resume)
    # Resumable push for slow or lossy connections.
    #
    # Interruption is treated as a normal condition. The command pushes the
    # branch, and if the connection drops it retries the *still-unacknowledged*
    # remainder rather than restarting, up to an attempt ceiling. Progress is
    # measured by what the remote actually acknowledges (its ref position),
    # never by what was merely attempted. It never weakens Git's transport
    # policy or the native 200 MiB push ceiling. See tools/git/RESUME.md.
    REMOTE="${3:-origin}"
    BRANCH="${4:-$(git -C "$REPO" branch --show-current)}"
    [ -n "$BRANCH" ] || { echo "ERROR: detached HEAD; specify a branch explicitly." >&2; exit 2; }

    # Optional --attempts N (0 = unlimited by policy). Default 5.
    MAX_ATTEMPTS=5
    if [ "${5:-}" = "--attempts" ]; then
      MAX_ATTEMPTS="${6:-}"
      [[ "$MAX_ATTEMPTS" =~ ^[0-9]+$ ]] || { echo "ERROR: --attempts requires a non-negative integer." >&2; exit 2; }
    fi

    LOCAL_TIP="$(git -C "$REPO" rev-parse "$BRANCH")"
    echo "push-resume: $REMOTE $BRANCH -> local tip $LOCAL_TIP"
    echo "push-resume: attempt ceiling = ${MAX_ATTEMPTS} (0 = unlimited)"

    remote_ack() {
      # The remote's acknowledged tip for BRANCH, or empty if none/unknown.
      git -C "$REPO" ls-remote "$REMOTE" "refs/heads/$BRANCH" 2>/dev/null | awk 'NR==1{print $1}'
    }

    attempt=0
    while :; do
      ACK="$(remote_ack || true)"
      if [ -n "$ACK" ] && [ "$ACK" = "$LOCAL_TIP" ]; then
        echo "push-resume: remote already acknowledges $LOCAL_TIP; complete."
        exit 0
      fi

      if [ "$MAX_ATTEMPTS" -ne 0 ] && [ "$attempt" -ge "$MAX_ATTEMPTS" ]; then
        echo "ERROR: push-resume halted: retry ceiling reached with work remaining." >&2
        echo "       remote tip: ${ACK:-<none>}  local tip: $LOCAL_TIP" >&2
        exit 1
      fi

      attempt=$((attempt + 1))
      echo "push-resume: attempt ${attempt}: pushing (remote at ${ACK:-<none>})..."

      # Ordinary Git push. The native push guard (push-budget.h) re-measures the
      # object graph and re-enforces the 200 MiB ceiling on every attempt.
      if git -C "$REPO" push --set-upstream "$REMOTE" "$BRANCH"; then
        NEWACK="$(remote_ack || true)"
        if [ "$NEWACK" = "$LOCAL_TIP" ]; then
          echo "push-resume: remote acknowledged $LOCAL_TIP after ${attempt} attempt(s)."
          exit 0
        fi
        echo "push-resume: push returned success but remote not fully acknowledged; continuing."
      else
        echo "push-resume: attempt ${attempt} interrupted (slow/lossy connection); will resume remainder." >&2
      fi

      # Small backoff before resuming the unacknowledged remainder.
      sleep 1
    done
    ;;

  *)
    echo "ERROR: unknown command: $command" >&2
    usage
    ;;
esac
