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
#   ./tools/git/git-workflow.sh premount [repo] push [remote] [branch] [--sha512] [--attempts N]
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
  git-workflow.sh premount [repo] push [remote] [branch] [--sha512] [--attempts N]
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

# Pick a digest tool: SHA-256 is the floor, "or better" (SHA-512) if requested.
# Prints "<algo-label>\t<command>"; exits non-zero if no suitable tool exists.
premount_digest_tool() {
  local want="$1"  # sha256 | sha512
  case "$want" in
    sha512)
      if command -v sha512sum >/dev/null 2>&1; then echo -e "SHA-512\tsha512sum"; return 0; fi
      if command -v shasum    >/dev/null 2>&1; then echo -e "SHA-512\tshasum -a 512"; return 0; fi
      ;;
    *)
      if command -v sha256sum >/dev/null 2>&1; then echo -e "SHA-256\tsha256sum"; return 0; fi
      if command -v shasum    >/dev/null 2>&1; then echo -e "SHA-256\tshasum -a 256"; return 0; fi
      ;;
  esac
  return 1
}

# git premount push: deterministic document + SHA-256-or-better reference +
# ordered 200 MiB add/commit sequence with partial-commit/resume.
#
#   premount_push <repo> <remote> [branch] [--sha512] [--attempts N]
#
# The document body is deterministic: ordered path/size lines plus the 200 MiB
# transaction grouping. The reference digest is computed over that body ONLY
# (no timestamp), so the same candidate set always yields the same reference.
# See tools/git/PREMOUNT.md and tools/git/RESUME.md.
premount_push() {
  local repo="$1"; shift
  local TXN=$((200 * 1024 * 1024))
  local algo="sha256" attempts=5 remote="" branch="" want_attempts=0 positional=0

  # Parse: positional remote then branch; flags --sha256/--sha512/--attempts N.
  local a
  for a in "$@"; do
    if [ "$want_attempts" = 1 ]; then
      [[ "$a" =~ ^[0-9]+$ ]] || { echo "ERROR: --attempts requires a non-negative integer." >&2; return 2; }
      attempts="$a"; want_attempts=0; continue
    fi
    case "$a" in
      --sha512)   algo="sha512" ;;
      --sha256)   algo="sha256" ;;
      --attempts) want_attempts=1 ;;
      --*)        echo "ERROR: unknown premount push option: $a" >&2; return 2 ;;
      *)
        if   [ "$positional" = 0 ]; then remote="$a"; positional=1
        elif [ "$positional" = 1 ]; then branch="$a"; positional=2
        else echo "ERROR: unexpected argument: $a" >&2; return 2; fi
        ;;
    esac
  done
  [ "$want_attempts" = 1 ] && { echo "ERROR: --attempts requires a value." >&2; return 2; }
  [ -n "$remote" ] || remote="origin"

  [ -n "$branch" ] || branch="$(git -C "$repo" branch --show-current)"
  [ -n "$branch" ] || { echo "ERROR: detached HEAD; specify a branch explicitly." >&2; return 2; }

  local root; root="$(git -C "$repo" rev-parse --show-toplevel)"

  # --- Collect the ordered candidate set (staged 'commit' + untracked 'add') ---
  local paths=()
  local line x y p
  while IFS= read -r line; do
    [ -n "$line" ] || continue
    x="${line:0:1}"; y="${line:1:1}"; p="${line:3}"
    p="${p%\"}"; p="${p#\"}"
    # Skip directory entries (trailing '/'); -uall expands them to files.
    case "$p" in */) continue ;; esac
    if [ "$x" = "A" ] || [ "$y" = "?" ] || [ "$x" = "?" ]; then
      paths+=("$p")
    fi
  done < <(git -C "$repo" status --porcelain -uall)

  if [ "${#paths[@]}" -eq 0 ]; then
    echo "premount push: no new add/commit candidates; nothing to do."
    return 0
  fi

  # Deterministic Git pathname order.
  mapfile -t paths < <(printf '%s\n' "${paths[@]}" | LC_ALL=C sort -u)

  # --- Build the deterministic document body and 200 MiB transaction plan ---
  local body="" total=0 txn_bytes=0 txn=1 txn_rows=0 oversize=0
  local plan_lines=()
  local sz abs
  for p in "${paths[@]}"; do
    abs="$root/$p"
    if [ -f "$abs" ]; then sz="$(wc -c < "$abs" 2>/dev/null | tr -d ' ')"; else sz=0; fi
    [ -n "$sz" ] || sz=0

    if [ "$sz" -gt "$TXN" ]; then
      echo "ERROR: premount push: '$p' ($sz bytes) exceeds the 200 MiB transaction size; cannot plan." >&2
      oversize=1
      break
    fi
    # Close the current transaction before a row that would cross 200 MiB.
    if [ "$txn_rows" -gt 0 ] && [ $((txn_bytes + sz)) -gt "$TXN" ]; then
      txn=$((txn + 1)); txn_bytes=0; txn_rows=0
    fi
    txn_bytes=$((txn_bytes + sz)); txn_rows=$((txn_rows + 1)); total=$((total + sz))
    # Deterministic body line: "txn\tsize\tpath" (no timestamp).
    body+="${txn}"$'\t'"${sz}"$'\t'"${p}"$'\n'
    plan_lines+=("${txn}"$'\t'"${sz}"$'\t'"${p}")
  done
  [ "$oversize" -eq 0 ] || return 1

  local txn_count="$txn"

  # --- Compute the SHA-256-or-better reference over the deterministic body ---
  local tool_line algo_label digest_cmd
  if ! tool_line="$(premount_digest_tool "$algo")"; then
    echo "ERROR: premount push: no $algo digest tool available." >&2
    return 1
  fi
  algo_label="${tool_line%%$'\t'*}"; digest_cmd="${tool_line#*$'\t'}"
  local reference
  reference="$(printf '%s' "$body" | $digest_cmd | awk '{print $1}')"

  # --- Emit the premount push document ---
  local ts; ts="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  echo   "=== git premount push document ==="
  echo   "Repository:     $root"
  echo   "Remote/branch:  $remote $branch"
  echo   "Generated:      $ts   (informational; not part of the reference)"
  echo   "Digest algo:    $algo_label (reference is over the deterministic body only)"
  echo   "Reference:      $reference"
  echo   "Files:          ${#paths[@]}    Total bytes: $total    Transactions (<=200 MiB): $txn_count"
  echo
  printf '%-4s | %12s | %s\n' "txn" "size" "path"
  printf '%-4s-+-%12s-+-%s\n' "----" "------------" "--------------------------------"
  for line in "${plan_lines[@]}"; do
    printf '%-4s | %12s | %s\n' "${line%%$'\t'*}" "$(echo "$line" | cut -f2)" "$(echo "$line" | cut -f3-)"
  done
  echo

  # --- Execute the ordered add/commit sequence, one 200 MiB transaction at a
  #     time, so an interruption resumes at a transaction boundary. ---
  local t
  for (( t=1; t<=txn_count; t++ )); do
    local tpaths=()
    for line in "${plan_lines[@]}"; do
      if [ "${line%%$'\t'*}" = "$t" ]; then
        tpaths+=("$(echo "$line" | cut -f3-)")
      fi
    done
    [ "${#tpaths[@]}" -gt 0 ] || continue
    echo "premount push: transaction ${t}/${txn_count}: staging ${#tpaths[@]} file(s)"
    git -C "$repo" add -- "${tpaths[@]}"
    git -C "$repo" commit -m "premount push: transaction ${t}/${txn_count} [ref ${algo_label}:${reference}]" \
      || { echo "premount push: transaction ${t} had nothing to commit; continuing." ; }
  done

  # --- Push with resume (partial commits already form the ordered chain) ---
  echo "premount push: pushing ordered chain with resume (attempts=${attempts})..."
  cmd_push_resume "$repo" "$remote" "$branch" "$attempts"
}

# Resumable push for slow or lossy connections. Retries the still-unacknowledged
# remainder rather than restarting, up to an attempt ceiling (0 = unlimited).
# Progress is measured by the remote's acknowledged ref position, never by mere
# attempts. Never weakens the native 200 MiB push ceiling. See tools/git/RESUME.md.
#   cmd_push_resume <repo> <remote> <branch> <max_attempts>
# Returns 0 on acknowledged completion, 1 on halt with work remaining.
cmd_push_resume() {
  local repo="$1" remote="$2" branch="$3" max_attempts="$4"
  local local_tip ack newack attempt=0
  local_tip="$(git -C "$repo" rev-parse "$branch")"
  echo "push-resume: $remote $branch -> local tip $local_tip"
  echo "push-resume: attempt ceiling = ${max_attempts} (0 = unlimited)"

  _remote_ack() { git -C "$repo" ls-remote "$remote" "refs/heads/$branch" 2>/dev/null | awk 'NR==1{print $1}'; }

  while :; do
    ack="$(_remote_ack || true)"
    if [ -n "$ack" ] && [ "$ack" = "$local_tip" ]; then
      echo "push-resume: remote already acknowledges $local_tip; complete."
      return 0
    fi
    if [ "$max_attempts" -ne 0 ] && [ "$attempt" -ge "$max_attempts" ]; then
      echo "ERROR: push-resume halted: retry ceiling reached with work remaining." >&2
      echo "       remote tip: ${ack:-<none>}  local tip: $local_tip" >&2
      return 1
    fi
    attempt=$((attempt + 1))
    echo "push-resume: attempt ${attempt}: pushing (remote at ${ack:-<none>})..."
    if git -C "$repo" push --set-upstream "$remote" "$branch"; then
      newack="$(_remote_ack || true)"
      if [ "$newack" = "$local_tip" ]; then
        echo "push-resume: remote acknowledged $local_tip after ${attempt} attempt(s)."
        return 0
      fi
      echo "push-resume: push returned success but remote not fully acknowledged; continuing."
    else
      echo "push-resume: attempt ${attempt} interrupted (slow/lossy connection); will resume remainder." >&2
    fi
    sleep 1
  done
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
    #
    # 'premount push' is the transfer-plan mode: it emits a deterministic
    # premount document, computes a SHA-256-or-better reference over that
    # document, and executes an ordered 200 MiB add/commit sequence with
    # partial-commit/resume support. It is handled by a dedicated helper below.
    SOURCE="${3:---both}"
    if [ "$SOURCE" = "push" ]; then
      # Pass all args after 'push' (remote/branch/flags) to the helper.
      shift 3 2>/dev/null || shift $#
      premount_push "$REPO" "$@"
      exit $?
    fi
    case "$SOURCE" in
      --add)    WANT_ADD=1; WANT_COMMIT=0 ;;
      --commit) WANT_ADD=0; WANT_COMMIT=1 ;;
      --both)   WANT_ADD=1; WANT_COMMIT=1 ;;
      *) echo "ERROR: premount source must be push, --add, --commit, or --both." >&2; exit 2 ;;
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

    cmd_push_resume "$REPO" "$REMOTE" "$BRANCH" "$MAX_ATTEMPTS"
    exit $?
    ;;

  *)
    echo "ERROR: unknown command: $command" >&2
    usage
    ;;
esac
