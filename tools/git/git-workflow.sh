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
#   ./tools/git/git-workflow.sh temperature [repo] [--recandle] [--min-idle DAYS]

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
  git-workflow.sh temperature [repo] [--recandle] [--min-idle DAYS]
  git-workflow.sh messages [repo] [path|validate|list|rules]
EOF
  exit 2
}

REPO="${2:-.}"

# -----------------------------------------------------------------------------
# Message & concern catalog (see MESSAGES.md, git/messages.config.example).
#
# The human-facing text this wrapper emits is defined in a config document
# rather than hardcoded, and consulted here as a reference/input. Resolution:
#   1. $REPO/.gitmessages         (per-repository override), else
#   2. <script dir>/git/messages.config.example  (the shipped defaults).
# A missing, stale, or altered config falls back to the compiled-in defaults
# below. Per the config's own RULE, this only re-words/re-streams output; it
# never changes behaviour, and a diagnostic (error/fatal) is never routed to
# stdout — such an override is ignored in favour of the safe default.
# -----------------------------------------------------------------------------

WF_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Compiled-in default wordings, keyed by message id. Kept byte-identical to the
# native default catalog in git/messages.c / git/messages.cpp.
declare -A WF_MSG_TEXT=(
  [git-required]="Git is required but was not found on PATH. Please install Git and try again."
  [not-a-repo]="The target path is not a Git repository. Choose a repository or initialize one first."
  [tree-not-clean]="The working tree has uncommitted changes. This operation was declined to protect them; commit or stash first."
  [detached-head]="HEAD is detached, so no branch can be inferred. Please name the branch explicitly."
  [nothing-staged]="There are no staged changes to commit. Stage the intended paths and try again."
  [message-required]="A commit message is required. Please provide one."
  [pathspec-required]="At least one pathspec is required for this operation."
  [bad-argument]="An argument was not understood. Please review the usage and try again."
  [unknown-command]="That command is not recognized. See the usage for the available commands."
  [size-ceiling]="A single item exceeds the 200 MiB transaction ceiling and cannot be split, so the plan cannot proceed. Please reduce the item or adjust the plan."
  [memory-bloat]="Memory use has grown beyond the advisory budget for this operation. Consider working in smaller batches."
  [disk-space]="There is not enough free disk space to complete this operation safely. Please free space and try again."
  [missing-file]="An expected file or object could not be found. Please confirm the path and repository state."
  [corruption]="An integrity check failed, which suggests a damaged file or object. No changes were made; please run a repository check before continuing."
  [overflow]="A size or count calculation would overflow and was rejected rather than allowed to wrap. Please reduce the scope of the request."
  [permission]="Permission was denied for this action. Please check file and remote permissions and try again."
  [no-digest-tool]="No suitable checksum tool (SHA-256 or SHA-512) is available, so an integrity reference cannot be computed."
  [resume-interrupted]="The connection was interrupted; the remaining work will resume from the last acknowledged point."
  [resume-halted]="The retry limit was reached with work still remaining, so the effort was halted rather than looping. Please retry when the connection is stable."
  [resume-complete]="The remote has acknowledged all work; the transfer is complete."
)

# Default stream per message id: stderr for diagnostics, stdout for results.
declare -A WF_MSG_STREAM=(
  [resume-complete]="stdout"
)

# Locate the active config document, if any.
wf_msg_config_path() {
  if [ -f "$REPO/.gitmessages" ]; then
    printf '%s\n' "$REPO/.gitmessages"
  elif [ -f "$WF_SCRIPT_DIR/git/messages.config.example" ]; then
    printf '%s\n' "$WF_SCRIPT_DIR/git/messages.config.example"
  fi
}

# Load TEXT/STREAM overrides from the config's [MESSAGE <id>] blocks. Any
# override that would route an error/fatal message to stdout is ignored so a
# config can never hide a diagnostic; missing keys keep the compiled default.
wf_msg_load_config() {
  local cfg id="" key val sev="" stream=""
  cfg="$(wf_msg_config_path)" || return 0
  [ -n "$cfg" ] && [ -r "$cfg" ] || return 0

  # Commit a pending block's overrides, honouring the stdout-safety rule.
  _wf_commit() {
    [ -n "$id" ] || return 0
    if [ -n "${WF_MSG_TEXT[$id]+x}" ]; then
      [ -n "$stream" ] && case "$sev" in
        error|fatal) [ "$stream" = stdout ] && stream="" ;;  # refuse to hide
      esac
      [ -n "$stream" ] && WF_MSG_STREAM[$id]="$stream"
    fi
    id=""; sev=""; stream=""
  }

  while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in
      \#*|"") continue ;;
      \[MESSAGE\ *\])
        _wf_commit
        id="${line#\[MESSAGE }"; id="${id%\]}"
        id="$(printf '%s' "$id" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')"
        [ -n "${WF_MSG_TEXT[$id]+x}" ] || id=""   # unknown id: ignore block
        ;;
      \[*\]) _wf_commit ;;                          # any other section ends it
      *:*)
        [ -n "$id" ] || continue
        key="$(printf '%s' "${line%%:*}" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')"
        val="${line#*:}"; val="${val# }"
        case "$key" in
          text)   [ -n "$val" ] && WF_MSG_TEXT[$id]="$val" ;;
          stream) stream="$(printf '%s' "$val" | tr -d '[:space:]')" ;;
          severity) sev="$(printf '%s' "$val" | tr '[:upper:]' '[:lower:]' | tr -d '[:space:]')" ;;
        esac
        ;;
    esac
  done < "$cfg"
  _wf_commit
  unset -f _wf_commit
}

wf_msg_load_config

# Emit the configured message for an id on its configured stream.
wf_msg() {
  local id="$1"; local text="${WF_MSG_TEXT[$id]:-$id}"
  if [ "${WF_MSG_STREAM[$id]:-stderr}" = stdout ]; then
    printf '%s\n' "$text"
  else
    printf '%s\n' "$text" >&2
  fi
}

require_git() {
  command -v git >/dev/null 2>&1 || {
    wf_msg git-required
    exit 1
  }
}

require_repo() {
  git -C "$REPO" rev-parse --git-dir >/dev/null 2>&1 || {
    wf_msg not-a-repo
    exit 1
  }
}

require_clean_before_sync() {
  if [ -n "$(git -C "$REPO" status --porcelain)" ]; then
    wf_msg tree-not-clean
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
  [ -n "$branch" ] || { wf_msg detached-head; return 2; }

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
      wf_msg size-ceiling; echo "       item: '$p' ($sz bytes)" >&2
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
    wf_msg no-digest-tool; echo "       requested: $algo" >&2
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
      wf_msg resume-halted
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
      echo "push-resume: attempt ${attempt}:" >&2; wf_msg resume-interrupted
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
    [ -n "$BRANCH" ] || { wf_msg detached-head; exit 2; }
    require_clean_before_sync
    git -C "$REPO" fetch --prune "$REMOTE"
    git -C "$REPO" merge --ff-only "$REMOTE/$BRANCH"
    ;;

  stage)
    shift 2
    [ "$#" -gt 0 ] || { wf_msg pathspec-required; exit 2; }
    git -C "$REPO" add -- "$@"
    git -C "$REPO" status --short
    ;;

  commit)
    MESSAGE="${3:-}"
    [ -n "$MESSAGE" ] || { wf_msg message-required; exit 2; }
    git -C "$REPO" diff --cached --quiet && {
      wf_msg nothing-staged
      exit 1
    }
    git -C "$REPO" commit -m "$MESSAGE"
    ;;

  push)
    REMOTE="${3:-origin}"
    BRANCH="${4:-$(git -C "$REPO" branch --show-current)}"
    [ -n "$BRANCH" ] || { wf_msg detached-head; exit 2; }
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
    [ -n "$MESSAGE" ] || { wf_msg message-required; exit 2; }
    git -C "$REPO" diff --cached --quiet && {
      wf_msg nothing-staged
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
    [ -n "$BRANCH" ] || { wf_msg detached-head; exit 2; }

    # Optional --attempts N (0 = unlimited by policy). Default 5.
    MAX_ATTEMPTS=5
    if [ "${5:-}" = "--attempts" ]; then
      MAX_ATTEMPTS="${6:-}"
      [[ "$MAX_ATTEMPTS" =~ ^[0-9]+$ ]] || { echo "ERROR: --attempts requires a non-negative integer." >&2; exit 2; }
    fi

    cmd_push_resume "$REPO" "$REMOTE" "$BRANCH" "$MAX_ATTEMPTS"
    exit $?
    ;;

  temperature)
    # Read-only advisory AI scan. Walks the repository's top-level project
    # subtrees, derives each project's idle age and heuristic signals from Git
    # history, prints the three learner strips (quality/intention, relative
    # importance, total achievable value) with a thermal band and recandle
    # marker, and closes with repository totals. Never stages/commits/pushes.
    # Mirrors git/temperature.h. See tools/git/TEMPERATURE.md.
    ONLY_RECANDLE=0
    MIN_IDLE=0
    shift 2 2>/dev/null || shift $#
    while [ "$#" -gt 0 ]; do
      case "$1" in
        --recandle) ONLY_RECANDLE=1 ;;
        --min-idle) shift; MIN_IDLE="${1:-}"; [[ "$MIN_IDLE" =~ ^[0-9]+$ ]] || { echo "ERROR: --min-idle requires a non-negative integer." >&2; exit 2; } ;;
        *) echo "ERROR: unknown temperature option: $1" >&2; exit 2 ;;
      esac
      shift
    done

    ROOT="$(git -C "$REPO" rev-parse --show-toplevel)"
    NOW="$(date -u +%s)"

    # Strip scale + band boundaries (mirror git/temperature.h).
    SCALE=100
    HOT=14; WARM=60; COOL=180
    RC_MIN_IMP=40; RC_MIN_VAL=40

    band_for_days() {
      local d="$1"
      if   [ "$d" -le "$HOT"  ]; then echo hot
      elif [ "$d" -le "$WARM" ]; then echo warm
      elif [ "$d" -le "$COOL" ]; then echo cool
      else echo cold; fi
    }

    # Enumerate top-level project subtrees (directories), skipping VCS/meta.
    projects=()
    while IFS= read -r d; do
      base="${d##*/}"
      case "$base" in .git|.|..) continue ;; esac
      projects+=("$base")
    done < <(find "$ROOT" -mindepth 1 -maxdepth 1 -type d 2>/dev/null | LC_ALL=C sort)

    if [ "${#projects[@]}" -eq 0 ]; then
      echo "temperature: no project subtrees found under $ROOT"
      exit 0
    fi

    ts="$(date -u +%Y-%m-%dT%H:%M:%SZ)"
    echo "=== git temperature (advisory scan) ==="
    echo "Repository: $ROOT"
    echo "Generated:  $ts"
    [ "$ONLY_RECANDLE" = 1 ] && echo "Filter:     recandle candidates only"
    [ "$MIN_IDLE" -gt 0 ] && echo "Filter:     idle >= ${MIN_IDLE} day(s)"
    echo

    fmt='%-24s | %-5s | %7s | %-9s | %-10s | %-11s | %-9s\n'
    # shellcheck disable=SC2059
    printf "$fmt" "project" "band" "idle(d)" "quality" "importance" "value" "recandle"
    # shellcheck disable=SC2059
    printf "$fmt" "------------------------" "-----" "-------" "---------" "----------" "-----------" "---------"

    # First pass: gather raw file/commit counts to compute relative importance.
    declare -A F_COUNT=() C_COUNT=() IDLE=()
    max_weight=1
    for p in "${projects[@]}"; do
      fc="$(git -C "$REPO" ls-files -- "$p" 2>/dev/null | wc -l | tr -d ' ')"
      [ -n "$fc" ] || fc=0
      # Untracked projects: count files on disk instead.
      if [ "$fc" -eq 0 ]; then
        fc="$(find "$ROOT/$p" -type f 2>/dev/null | wc -l | tr -d ' ')"
        [ -n "$fc" ] || fc=0
      fi
      cc="$(git -C "$REPO" rev-list --count HEAD -- "$p" 2>/dev/null || echo 0)"
      [ -n "$cc" ] || cc=0
      # Idle days from last commit touching the path; fall back to mtime.
      last_epoch="$(git -C "$REPO" log -1 --format=%ct -- "$p" 2>/dev/null || true)"
      if [ -z "$last_epoch" ]; then
        last_epoch="$(find "$ROOT/$p" -type f -printf '%T@\n' 2>/dev/null | sort -nr | head -1 | cut -d. -f1)"
      fi
      [ -n "$last_epoch" ] || last_epoch="$NOW"
      idle=$(( (NOW - last_epoch) / 86400 ))
      [ "$idle" -lt 0 ] && idle=0
      F_COUNT["$p"]=$fc; C_COUNT["$p"]=$cc; IDLE["$p"]=$idle
      # Importance weight combines size and history depth.
      w=$(( fc + cc ))
      [ "$w" -gt "$max_weight" ] && max_weight=$w
    done

    total_value=0; total_quality=0; recandle_count=0; listed=0
    for p in "${projects[@]}"; do
      fc=${F_COUNT["$p"]}; cc=${C_COUNT["$p"]}; idle=${IDLE["$p"]}
      band="$(band_for_days "$idle")"

      # --- Strip 1: quality & intention (heuristic, observable signals) ---
      # Scaffolding contributes "intention" but is capped below 100 so a
      # project always retains some improvement headroom. Staleness then
      # discounts realized quality: a project left cold has, by definition,
      # unrealized potential, which is what makes it worth recandling.
      q=0
      { [ -e "$ROOT/$p/README.md" ] || [ -n "$(find "$ROOT/$p" -maxdepth 1 -iname 'README*' 2>/dev/null)" ]; } && q=$((q+18))
      { [ -e "$ROOT/$p/Makefile" ] || [ -e "$ROOT/$p/makefile" ] || [ -e "$ROOT/$p/CMakeLists.txt" ]; } && q=$((q+14))
      [ -n "$(find "$ROOT/$p" -maxdepth 2 -type d \( -iname 'test' -o -iname 'tests' -o -iname 't' \) 2>/dev/null)" ] && q=$((q+16))
      [ -n "$(find "$ROOT/$p" -maxdepth 1 -iname '*.md' 2>/dev/null)" ] && q=$((q+8))
      # Coherent size (some files but not empty) and some history.
      [ "$fc" -ge 3 ] && q=$((q+8))
      [ "$cc" -ge 2 ] && q=$((q+6))
      # Cap scaffolding-based quality at 70: full quality is never inferred
      # from structure alone, leaving deliberate headroom.
      [ "$q" -gt 70 ] && q=70
      # Staleness discount: cold/cool projects lose realized quality, raising
      # their achievable value (headroom) and surfacing recandle candidates.
      case "$band" in
        cold) q=$(( q * 60 / 100 )) ;;   # -40%
        cool) q=$(( q * 80 / 100 )) ;;   # -20%
      esac
      [ "$q" -lt 0 ] && q=0
      [ "$q" -gt "$SCALE" ] && q=$SCALE

      # --- Strip 2: relative importance (size+history vs repo max) ---
      w=$(( fc + cc ))
      imp=$(( w * SCALE / max_weight ))
      [ "$imp" -gt "$SCALE" ] && imp=$SCALE

      # --- Strip 3: achievable value = (100 - quality) * importance / 100 ---
      if [ "$q" -ge "$SCALE" ]; then val=0; else val=$(( (SCALE - q) * imp / SCALE )); fi

      # Recandle: cold/cool + important + improvable.
      recandle="no"
      if { [ "$band" = "cold" ] || [ "$band" = "cool" ]; } \
         && [ "$imp" -ge "$RC_MIN_IMP" ] && [ "$val" -ge "$RC_MIN_VAL" ]; then
        recandle="yes"; recandle_count=$((recandle_count+1))
      fi

      total_value=$((total_value + val))
      total_quality=$((total_quality + q))

      # Apply filters for the listing (totals still cover all projects).
      [ "$idle" -ge "$MIN_IDLE" ] || continue
      [ "$ONLY_RECANDLE" = 1 ] && [ "$recandle" != "yes" ] && continue

      listed=$((listed+1))
      # shellcheck disable=SC2059
      printf "$fmt" "$p" "$band" "$idle" "$q" "$imp" "$val" "$recandle"
    done

    echo
    echo "--- learner strips (repository totals) ---"
    echo "Projects scanned:        ${#projects[@]}   (listed: ${listed})"
    echo "Recandle candidates:     ${recandle_count}"
    echo "Total current quality:   ${total_quality}"
    echo "Total achievable value:  ${total_value}   (improvement unlockable over current quality)"
    echo
    echo "Note: temperature is advisory and read-only; it stages/commits/pushes nothing."
    echo "      Scores use observable project signals only, never identity or credentials."
    ;;

  messages)
    # Inspect the message catalog and .gitmessages config. Prefers the native
    # `gitmsg` inspector (built alongside the Edition git; identical to what the
    # binary applies); falls back to this wrapper's own catalog when it is not
    # present. See tools/git/MESSAGES.md.
    #
    #   git-workflow.sh messages [repo] [path|validate|list|rules]
    sub="${3:-list}"
    GITMSG_BIN=""
    for cand in "$WF_SCRIPT_DIR/git/gitmsg" "$WF_SCRIPT_DIR/build/.native-policy/gitmsg" gitmsg; do
      if command -v "$cand" >/dev/null 2>&1 || [ -x "$cand" ]; then GITMSG_BIN="$cand"; break; fi
    done
    if [ -n "$GITMSG_BIN" ]; then
      cfg="$(wf_msg_config_path)"
      if [ -n "$cfg" ]; then
        exec "$GITMSG_BIN" --config "$cfg" "$sub"
      else
        exec "$GITMSG_BIN" "$sub"
      fi
    fi
    # Fallback: report using the shell catalog this wrapper already loaded.
    case "$sub" in
      path)
        cfg="$(wf_msg_config_path)"
        [ -n "$cfg" ] && echo "$cfg" || echo "(no .gitmessages found; using built-in wordings)"
        ;;
      validate)
        echo "Native 'gitmsg' inspector not built; the shell wrapper's built-in wordings are in effect."
        echo "Build it with: make -f build/git-full.mk git-listen  (or see MESSAGES.md)."
        ;;
      list)
        for id in "${!WF_MSG_TEXT[@]}"; do
          printf "%-20s %-7s %s\n" "$id" "${WF_MSG_STREAM[$id]:-stderr}" "${WF_MSG_TEXT[$id]}"
        done | sort
        ;;
      rules)
        echo "MAP rules are applied by the native binary; the shell wrapper does not evaluate them."
        ;;
      *)
        echo "usage: git-workflow.sh messages [repo] [path|validate|list|rules]" >&2
        exit 2
        ;;
    esac
    ;;

  *)
    wf_msg unknown-command; echo "       command: $command" >&2
    usage
    ;;
esac
