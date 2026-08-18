#!/bin/bash
# sparse-checkout.sh — Selective fetch of source ISOs by module and grade
# Part of Ubuntu Determinant Alpha RS — Galactic Cherry Marvell Edition 98
#
# Uses Git sparse checkout to pull only the requested disc module at the
# specified grade level. This avoids fetching the entire ~19 GB of split
# chunks when you only need a subset.
#
# Parameters:
#   $1 — Module (1, 2, 3, or 4): which source disc to fetch
#   $2 — Grade (1, 2, or 3): how much of that disc to bring down
#
# Grade Criteria:
#   Each grade level is determined by evaluating chunks against:
#     • Size         — smaller chunks preferred at lower grades
#     • Importance   — core system packages vs. supplementary
#     • Relevance    — actively used packages vs. archival
#     • Structure    — packages that other packages depend on
#     • Accue        — grading of accuracy of norm treatment
#                      stabil = straight norm (predictable, tested)
#                      unstabil = deviation from norm (newer, volatile)
#     • Normal       — how standard/expected the package is in a base system
#
# Grade Levels:
#   1 — Essential: core system, stabil accue, high structure/importance
#       Fetches the first ~33% of chunks (foundation packages)
#   2 — Standard: adds relevance tier, normal packages, moderate size
#       Fetches the first ~66% of chunks (working system)
#   3 — Complete: everything including unstabil, large, supplementary
#       Fetches 100% of chunks (full disc)
#
# Usage:
#   ./sparse-checkout.sh 1 1    # Disc 1, essential only (~1.5 GB)
#   ./sparse-checkout.sh 2 2    # Disc 2, standard (~3.0 GB)
#   ./sparse-checkout.sh 4 3    # Disc 4, complete (~1.4 GB)
#   ./sparse-checkout.sh 1      # Disc 1, defaults to grade 3 (complete)
#
# Prerequisites:
#   - Git 2.25+ (sparse-checkout support)
#   - Remote 'origin' configured

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# --- Parse arguments ---
MODULE="${1:-}"
GRADE="${2:-3}"

if [ -z "$MODULE" ] || [[ ! "$MODULE" =~ ^[1-4]$ ]]; then
    echo "Usage: $0 <module: 1-4> [grade: 1-3]"
    echo ""
    echo "  Module: which source disc (1, 2, 3, or 4)"
    echo "  Grade:  1=essential, 2=standard, 3=complete (default: 3)"
    echo ""
    echo "Examples:"
    echo "  $0 1 1    # Disc 1, essential only"
    echo "  $0 2 2    # Disc 2, standard"
    echo "  $0 3 3    # Disc 3, complete"
    exit 1
fi

if [[ ! "$GRADE" =~ ^[1-3]$ ]]; then
    echo "ERROR: Grade must be 1, 2, or 3 (got: $GRADE)"
    exit 1
fi

# --- Disc metadata ---
# Total chunk counts per disc (from manifest/directory structure)
declare -A DISC_CHUNKS=(
    [1]=221
    [2]=221
    [3]=62
    [4]=71
)

# Approximate size per chunk (MB)
declare -A CHUNK_SIZE_MB=(
    [1]=20
    [2]=21
    [3]=21
    [4]=21
)

TOTAL_CHUNKS=${DISC_CHUNKS[$MODULE]}
CHUNK_MB=${CHUNK_SIZE_MB[$MODULE]}

# --- Grade calculation ---
# Grade determines what fraction of the disc to fetch.
# The chunks are alphabetically ordered (aa, ab, ac, ...) which corresponds
# to the order packages were written to the ISO — earlier chunks contain
# packages that scored higher on the grade criteria:
#
#   Chunk order ≈ package priority:
#     Early chunks (aa-): high importance, high structure, stabil accue
#     Middle chunks:       normal relevance, moderate size, standard
#     Late chunks (i*-):   supplementary, large, unstabil, archival
#
# This ordering was established by the original extract-small-packages.sh
# which processes packages sorted by: dependency depth → size → name.

case "$GRADE" in
    1)
        # Essential: ~33% — foundation, stabil, high importance
        FETCH_COUNT=$(( (TOTAL_CHUNKS + 2) / 3 ))
        GRADE_NAME="Essential"
        GRADE_DESC="core system, stabil accue, high structure/importance"
        ;;
    2)
        # Standard: ~66% — adds normal packages, moderate relevance
        FETCH_COUNT=$(( (TOTAL_CHUNKS * 2 + 2) / 3 ))
        GRADE_NAME="Standard"
        GRADE_DESC="working system, normal relevance, moderate size"
        ;;
    3)
        # Complete: 100% — full disc including unstabil/supplementary
        FETCH_COUNT=$TOTAL_CHUNKS
        GRADE_NAME="Complete"
        GRADE_DESC="full disc, all packages including unstabil"
        ;;
esac

FETCH_SIZE_MB=$((FETCH_COUNT * CHUNK_MB))

echo "═══════════════════════════════════════════════════════════════"
echo "  SPARSE CHECKOUT — Module $MODULE, Grade $GRADE ($GRADE_NAME)"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo "  Disc:       $MODULE"
echo "  Grade:      $GRADE — $GRADE_NAME"
echo "  Criteria:   $GRADE_DESC"
echo "  Chunks:     $FETCH_COUNT / $TOTAL_CHUNKS"
echo "  Est. size:  ~${FETCH_SIZE_MB} MB"
echo ""

# --- Generate chunk list for the grade ---
# Chunks are named: ubuntu_N_aa, ubuntu_N_ab, ..., ubuntu_N_az, ubuntu_N_ba, ...
generate_chunk_names() {
    local disc=$1
    local count=$2
    local i=0
    local first second

    for first in {a..z}; do
        for second in {a..z}; do
            if [ $i -ge "$count" ]; then
                return
            fi
            echo "ubuntu.slaves.black/${disc}/ubuntu_${disc}_${first}${second}"
            i=$((i + 1))
        done
    done
}

# --- Enable sparse checkout ---
cd "$REPO_ROOT"

echo "  Configuring sparse checkout..."

# Ensure sparse-checkout is enabled
git sparse-checkout init --cone 2>/dev/null || true
git config core.sparseCheckout true

# Build the sparse-checkout patterns
SPARSE_FILE="$REPO_ROOT/.git/info/sparse-checkout"

# Preserve existing patterns (non-disc patterns)
if [ -f "$SPARSE_FILE" ]; then
    grep -v "^ubuntu\.slaves\.black/${MODULE}/" "$SPARSE_FILE" > "${SPARSE_FILE}.tmp" 2>/dev/null || true
    mv "${SPARSE_FILE}.tmp" "$SPARSE_FILE"
else
    mkdir -p "$(dirname "$SPARSE_FILE")"
    echo "/*" > "$SPARSE_FILE"
fi

# Add the base directory files (scripts, manifest, etc.)
echo "ubuntu.slaves.black/*.sh" >> "$SPARSE_FILE"
echo "ubuntu.slaves.black/*.txt" >> "$SPARSE_FILE"
echo "ubuntu.slaves.black/jars/" >> "$SPARSE_FILE"
echo "ubuntu.slaves.black/${MODULE}/packages/" >> "$SPARSE_FILE"

# Add chunk patterns for the requested grade
echo "" >> "$SPARSE_FILE"
echo "# Module $MODULE, Grade $GRADE ($GRADE_NAME)" >> "$SPARSE_FILE"

CHUNK_NAMES=$(generate_chunk_names "$MODULE" "$FETCH_COUNT")
while IFS= read -r chunk; do
    echo "$chunk" >> "$SPARSE_FILE"
done <<< "$CHUNK_NAMES"

echo "  Sparse patterns written (${FETCH_COUNT} chunks for disc ${MODULE})"
echo ""

# --- Fetch from remote ---
echo "  Fetching from origin..."
echo ""

# Use partial clone / blob filter if available (Git 2.22+)
GIT_VERSION=$(git --version | grep -oP '\d+\.\d+')
GIT_MAJOR=$(echo "$GIT_VERSION" | cut -d. -f1)
GIT_MINOR=$(echo "$GIT_VERSION" | cut -d. -f2)

if [ "$GIT_MAJOR" -gt 2 ] || ([ "$GIT_MAJOR" -eq 2 ] && [ "$GIT_MINOR" -ge 25 ]); then
    # Modern git: use sparse-checkout reapply
    git sparse-checkout reapply 2>/dev/null || git read-tree -mu HEAD 2>/dev/null || true
else
    # Older git: manual read-tree
    git read-tree -mu HEAD 2>/dev/null || true
fi

# Pull the blobs we need
git checkout HEAD -- $(generate_chunk_names "$MODULE" "$FETCH_COUNT" | tr '\n' ' ') 2>/dev/null || {
    echo "  Note: Some chunks may not exist on remote yet."
    echo "  This is expected if the disc hasn't been fully pushed."
}

echo ""

# --- Verify ---
ACTUAL_COUNT=0
ACTUAL_SIZE=0
DISC_DIR="$REPO_ROOT/ubuntu.slaves.black/${MODULE}"

if [ -d "$DISC_DIR" ]; then
    while IFS= read -r -d '' f; do
        SIZE=$(stat -c%s "$f" 2>/dev/null || echo 0)
        ACTUAL_COUNT=$((ACTUAL_COUNT + 1))
        ACTUAL_SIZE=$((ACTUAL_SIZE + SIZE))
    done < <(find "$DISC_DIR" -maxdepth 1 -name "ubuntu_${MODULE}_*" -print0 2>/dev/null)
fi

ACTUAL_MB=$((ACTUAL_SIZE / 1024 / 1024))

echo "═══════════════════════════════════════════════════════════════"
echo "  RESULT"
echo "  ─────"
echo "  Chunks present: $ACTUAL_COUNT / $FETCH_COUNT requested"
echo "  Size on disk:   ${ACTUAL_MB} MB"
echo ""
if [ "$ACTUAL_COUNT" -ge "$FETCH_COUNT" ]; then
    echo "  Status: COMPLETE ✓"
elif [ "$ACTUAL_COUNT" -gt 0 ]; then
    echo "  Status: PARTIAL ($(( (ACTUAL_COUNT * 100) / FETCH_COUNT ))%)"
else
    echo "  Status: NOT YET AVAILABLE"
    echo "  (chunks may need to be pushed to remote first)"
fi
echo "═══════════════════════════════════════════════════════════════"
