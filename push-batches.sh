#!/bin/bash
#
# push-batches.sh — Stream files into ≤200MB batches: stage → commit → push each before starting next
# Repository: https://github.com/mearvk/Ubuntu.Determinant.Alpha.Restricted
#
# Strategy: Scan files incrementally. As soon as 200 MB is accumulated, immediately
# stage, commit, and push that batch. Then continue scanning for the next batch.
# No full upfront file list is built — uploads start as fast as possible.
#

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$REPO_DIR"

MAX_BATCH_BYTES=$((200 * 1024 * 1024))  # 200 MB
BRANCH="$(git branch --show-current)"
LOG_FILE="$REPO_DIR/.git/push-batches.log"

echo "=== push-batches.sh ==="
echo "Repository: $REPO_DIR"
echo "Branch:     $BRANCH"
echo "Max batch:  200 MB"
echo "Strategy:   Stream → stage → commit → push (immediate per batch)"
echo "Event log:  $LOG_FILE"
echo ""

# --- Event logging ---
log_event() {
    local level="$1" msg="$2"
    local ts
    ts="$(date '+%Y-%m-%d %H:%M:%S')"
    printf '[%s] %-7s %s\n' "$ts" "$level" "$msg" >> "$LOG_FILE"
}

# --- Timer-based heartbeat for long operations ---
HEARTBEAT_PID=""
HEARTBEAT_COUNTER=""

start_heartbeat() {
    local interval=${1:-10} label=${2:-"Working"} counter_file=${3:-""}
    HEARTBEAT_COUNTER="$counter_file"
    (
        local elapsed=0
        while true; do
            sleep "$interval"
            elapsed=$((elapsed + interval))
            local mins=$((elapsed / 60))
            local secs=$((elapsed % 60))
            local count_info=""
            if [[ -n "$counter_file" && -f "$counter_file" ]]; then
                local cnt
                cnt=$(cat "$counter_file" 2>/dev/null || echo "0")
                count_info=" — ${cnt}"
            fi
            printf '\r  ⏱  %s — elapsed %dm %02ds%s\033[K' "$label" "$mins" "$secs" "$count_info" >&2
            log_event "TIMER" "$label — ${elapsed}s elapsed${count_info}"
        done
    ) &
    HEARTBEAT_PID=$!
    disown "$HEARTBEAT_PID" 2>/dev/null
}

stop_heartbeat() {
    if [[ -n "$HEARTBEAT_PID" ]]; then
        kill "$HEARTBEAT_PID" 2>/dev/null || true
        wait "$HEARTBEAT_PID" 2>/dev/null || true
        HEARTBEAT_PID=""
        printf '\r\033[K' >&2
    fi
    if [[ -n "$HEARTBEAT_COUNTER" ]]; then
        rm -f "$HEARTBEAT_COUNTER"
        HEARTBEAT_COUNTER=""
    fi
}

trap 'stop_heartbeat' EXIT

# --- Progress bar function ---
draw_progress() {
    local current=$1 total=$2 label=${3:-""}
    local width=50
    local pct=0
    if (( total > 0 )); then
        pct=$(( current * 100 / total ))
    fi
    local filled=$(( pct * width / 100 ))
    local empty=$(( width - filled ))
    local bar=""
    local i
    for (( i=0; i<filled; i++ )); do bar+="█"; done
    for (( i=0; i<empty; i++ )); do bar+="░"; done
    printf '\r  %s [%s] %3d%% (%d/%d)\033[K' "$label" "$bar" "$pct" "$current" "$total"
}

# --- Timed command wrapper ---
run_timed() {
    local label="$1"; shift
    local start_ts end_ts duration

    log_event "START" "$label"
    start_ts=$(date +%s)
    start_heartbeat 10 "$label"

    "$@"
    local rc=$?

    stop_heartbeat
    end_ts=$(date +%s)
    duration=$((end_ts - start_ts))
    local mins=$((duration / 60)) secs=$((duration % 60))

    if (( rc == 0 )); then
        log_event "DONE" "$label — completed in ${mins}m ${secs}s"
        echo "  ✓ $label (${mins}m ${secs}s)"
    else
        log_event "ERROR" "$label — FAILED (exit $rc) after ${mins}m ${secs}s"
        echo "  ✗ $label FAILED (exit $rc, ${mins}m ${secs}s)"
    fi
    return $rc
}

# --- Initialize log ---
echo "" >> "$LOG_FILE"
log_event "======" "=========================================="
log_event "RUN" "push-batches.sh started (streaming mode)"
log_event "INFO" "Repository: $REPO_DIR"
log_event "INFO" "Branch: $BRANCH"

# --- Ensure remote uses PAT authentication ---
current_remote="$(git remote get-url origin 2>/dev/null || true)"
if [[ -z "$current_remote" ]]; then
    read -rsp "Enter your GitHub PAT: " PAT
    echo ""
    git remote add origin "https://${PAT}@github.com/mearvk/Ubuntu.Determinant.Alpha.Restricted.git"
elif [[ "$current_remote" != *"@github.com"* ]]; then
    read -rsp "Enter your GitHub PAT: " PAT
    echo ""
    git remote set-url origin "https://${PAT}@github.com/mearvk/Ubuntu.Determinant.Alpha.Restricted.git"
fi

echo "Remote: $(git remote get-url origin | sed 's|https://[^@]*@|https://***@|')"
echo ""

# --- Check if there's anything to commit ---
# First check: are files already staged from a previous interrupted run?
staged_count=$(git diff --cached --name-only | wc -l)

if (( staged_count > 0 )); then
    echo "Found $staged_count files ALREADY STAGED in the index (from previous run)."
    echo "Skipping scan — committing and pushing staged files directly."
    echo ""
    log_event "INFO" "Found $staged_count pre-staged files — direct commit+push"

    # Estimate total size
    echo "  Estimating size (sampling)..."
    staged_size=$(git diff --cached --numstat | awk '{s += $1 + $2} END {printf "%.1f", s/1024}' 2>/dev/null || echo "unknown")

    echo "  Total staged: $staged_count files"
    echo ""
    echo "  Strategy: commit all → push (git pack compression should handle it)"
    echo ""

    run_timed "git commit ($staged_count files)" \
        git commit -m "Full upload: $staged_count files [$(date +%Y-%m-%d\ %H:%M:%S)]" --quiet

    echo ""
    echo "  Pushing to origin/$BRANCH (this may take a while for large repos)..."
    echo "  If push fails due to size, re-run and it will try chunked push."
    echo ""

    run_timed "git push to origin/$BRANCH" \
        git push -u origin "$BRANCH"

    log_event "RUN" "push-batches.sh completed — direct push of $staged_count pre-staged files"
    echo ""
    echo "=== Done. All $staged_count pre-staged files committed and pushed. ==="
    echo "Event log: $LOG_FILE"
    exit 0
fi

if [ -z "$(git ls-files --others --exclude-standard)" ] && git diff --quiet HEAD 2>/dev/null; then
    echo "Nothing to commit. Working tree clean."
    log_event "INFO" "Nothing to commit"
    exit 0
fi

# --- Streaming batch processor ---
# Accumulate files until 200 MB, then immediately stage+commit+push.
# No full upfront scan — first batch starts uploading ASAP.

batch_num=0
batch_size=0
batch_files=0
total_scanned=0
total_size=0
BATCH_FILE=$(mktemp /tmp/push-batch-current.XXXXXX)
COUNTER_FILE=$(mktemp /tmp/push-scan-counter.XXXXXX)
echo "0 files scanned, 0 MB accumulated" > "$COUNTER_FILE"

trap 'stop_heartbeat; rm -f "$BATCH_FILE" "$COUNTER_FILE" 2>/dev/null' EXIT

echo "Streaming files — batches upload as soon as 200 MB is reached..."
echo ""
log_event "INFO" "Starting streaming scan+push"

start_heartbeat 10 "Scanning & accumulating" "$COUNTER_FILE"

flush_batch() {
    # Stage, commit, push the current batch
    local count=$batch_files
    local batch_mb
    batch_mb=$(awk "BEGIN {printf \"%.1f\", $batch_size / 1048576}")

    if [[ $count -eq 0 ]]; then return; fi

    batch_num=$((batch_num + 1))
    stop_heartbeat

    echo ""
    echo "--- Batch $batch_num: $count files, $batch_mb MB ---"
    log_event "BATCH" "Batch $batch_num: $count files, $batch_mb MB"

    # Stage with progress bar
    echo "  Staging..."
    log_event "START" "git add — batch $batch_num ($count files)"
    local add_start staged chunk_file
    add_start=$(date +%s)
    staged=0
    chunk_file=$(mktemp /tmp/push-chunk.XXXXXX)

    while IFS= read -r filepath; do
        echo "$filepath" >> "$chunk_file"
        staged=$((staged + 1))
        if (( staged % 500 == 0 )); then
            git add --pathspec-from-file="$chunk_file" 2>/dev/null
            > "$chunk_file"
            draw_progress "$staged" "$count" "Staging"
        fi
    done < "$BATCH_FILE"

    if [ -s "$chunk_file" ]; then
        git add --pathspec-from-file="$chunk_file" 2>/dev/null
    fi
    rm -f "$chunk_file"
    draw_progress "$count" "$count" "Staging"
    echo ""

    local add_end
    add_end=$(date +%s)
    log_event "DONE" "git add — batch $batch_num in $(( add_end - add_start ))s"
    echo "  ✓ Staged ($(( add_end - add_start ))s)"

    # Commit
    run_timed "git commit — batch $batch_num" \
        git commit -m "Batch $batch_num: $count files ($batch_mb MB) [$(date +%Y-%m-%d\ %H:%M:%S)]" --quiet

    # Push
    run_timed "git push — batch $batch_num" \
        git push -u origin "$BRANCH"

    log_event "DONE" "Batch $batch_num uploaded"
    echo ""

    # Reset for next batch
    batch_size=0
    batch_files=0
    > "$BATCH_FILE"

    # Resume heartbeat for continued scanning
    echo "$total_scanned files scanned, next batch accumulating" > "$COUNTER_FILE"
    start_heartbeat 10 "Scanning & accumulating" "$COUNTER_FILE"
}

# --- Main streaming loop ---
while IFS= read -r line; do
    f="${line:3}"
    total_scanned=$((total_scanned + 1))

    if [ -e "$f" ]; then
        fsize=$(stat --printf="%s" "$f")
    else
        fsize=0
    fi
    total_size=$((total_size + fsize))

    # Add file to current batch
    echo "$f" >> "$BATCH_FILE"
    batch_size=$((batch_size + fsize))
    batch_files=$((batch_files + 1))

    # Update heartbeat counter every 1000 files
    if (( total_scanned % 1000 == 0 )); then
        local_mb=$(awk "BEGIN {printf \"%.0f\", $batch_size / 1048576}")
        echo "${total_scanned} files scanned, batch: ${batch_files} files (${local_mb} MB / 200 MB)" > "$COUNTER_FILE"
    fi

    # Batch full? Flush immediately.
    if (( batch_size >= MAX_BATCH_BYTES )); then
        flush_batch
    fi

done < <(git status --porcelain)

# Flush any remaining files in the last partial batch
stop_heartbeat
if (( batch_files > 0 )); then
    flush_batch
fi
stop_heartbeat

# --- Summary ---
total_mb=$(awk "BEGIN {printf \"%.1f\", $total_size / 1048576}")
echo "=== Done. $batch_num batch(es) committed and pushed. ==="
echo "    Total: $total_scanned files, $total_mb MB"
echo "    Event log: $LOG_FILE"

log_event "RUN" "push-batches.sh completed — $batch_num batches, $total_scanned files, $total_mb MB"
