#!/bin/bash
# build-timed.sh — Timed build of modules, kernel, and ISO
#
# Runs each build phase with timing so you can gauge compile duration.
# Use --dry-run to see what would run without executing.
# Use --phase=<name> to run only one phase.
#
# Phases: modules, kernel, tools, x11, rootfs, iso, all
#
# Prerequisites (install if missing):
#   sudo apt install gcc make flex bison libelf-dev bc libssl-dev \
#     meson ninja-build pkg-config fakeroot cpio gzip \
#     xorriso squashfs-tools grub-pc-bin grub-efi-amd64-bin mtools
#
# Copyright (C) 2026 MEARVK LLC

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"
KERNEL_DIR="$PROJECT_DIR/kernels/linux-5.15.204/linux-5.15.204"
NPROC=$(nproc)
LOG_FILE="$PROJECT_DIR/build/build-timing.log"

DRY_RUN=0
PHASE="all"

# Parse arguments
for arg in "$@"; do
    case "$arg" in
        --dry-run)  DRY_RUN=1 ;;
        --phase=*)  PHASE="${arg#--phase=}" ;;
        --help|-h)
            echo "Usage: $0 [--dry-run] [--phase=modules|kernel|tools|x11|rootfs|iso|all]"
            echo ""
            echo "Phases:"
            echo "  modules  - Kernel modules only (custom extensions)"
            echo "  kernel   - Full kernel compile (vmlinuz + modules)"
            echo "  tools    - Userspace tools (sudo_gate, chat, nnet, etc.)"
            echo "  x11      - X.Org server and libraries"
            echo "  rootfs   - Assemble root filesystem"
            echo "  iso      - Generate bootable ISO"
            echo "  all      - All phases in order"
            echo ""
            echo "Options:"
            echo "  --dry-run  Show commands without executing"
            echo ""
            echo "Timing results saved to: build/build-timing.log"
            exit 0
            ;;
        *)
            echo "Unknown argument: $arg (try --help)"
            exit 1
            ;;
    esac
done

mkdir -p "$PROJECT_DIR/build"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# Timing array
declare -A TIMES

phase_header() {
    echo ""
    echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  PHASE: $1${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}"
    echo ""
}

run_timed() {
    local name="$1"
    shift
    local cmd="$*"

    phase_header "$name"

    if [ "$DRY_RUN" -eq 1 ]; then
        echo -e "${YELLOW}[DRY RUN]${NC} $cmd"
        TIMES["$name"]="(dry run)"
        return
    fi

    echo -e "${GREEN}[RUN]${NC} $cmd"
    echo ""

    local start=$(date +%s)
    eval "$cmd"
    local rc=$?
    local end=$(date +%s)
    local elapsed=$((end - start))

    local mins=$((elapsed / 60))
    local secs=$((elapsed % 60))

    if [ $rc -ne 0 ]; then
        echo -e "${RED}[FAILED]${NC} $name — exit code $rc after ${mins}m ${secs}s"
        TIMES["$name"]="FAILED (${mins}m ${secs}s)"
        return $rc
    fi

    echo ""
    echo -e "${GREEN}[DONE]${NC} $name — ${mins}m ${secs}s"
    TIMES["$name"]="${mins}m ${secs}s"
}

# ==============================================================================
# Phase: Kernel modules only (just the custom .ko files)
# ==============================================================================
do_modules() {
    run_timed "Kernel Modules (custom extensions)" \
        "make -C '$KERNEL_DIR' modules -j$NPROC"
}

# ==============================================================================
# Phase: Full kernel build (vmlinuz + all modules)
# ==============================================================================
do_kernel() {
    run_timed "Kernel (full build: vmlinuz + modules)" \
        "make -C '$KERNEL_DIR' -j$NPROC"
}

# ==============================================================================
# Phase: Userspace tools
# ==============================================================================
do_tools() {
    run_timed "Tools (sudo_gate, chat, nnet, negamane)" \
        "make -C '$PROJECT_DIR' tools"
}

# ==============================================================================
# Phase: X11
# ==============================================================================
do_x11() {
    run_timed "X11 (X.Org Server + libraries)" \
        "make -C '$PROJECT_DIR' x11"
}

# ==============================================================================
# Phase: Root filesystem assembly
# ==============================================================================
do_rootfs() {
    run_timed "Root Filesystem Assembly" \
        "make -C '$PROJECT_DIR' rootfs-full"
}

# ==============================================================================
# Phase: ISO generation
# ==============================================================================
do_iso() {
    run_timed "ISO Generation (bootable image)" \
        "make -C '$PROJECT_DIR' iso"
}

# ==============================================================================
# Summary
# ==============================================================================
print_summary() {
    echo ""
    echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}"
    echo -e "${CYAN}  BUILD TIMING SUMMARY${NC}"
    echo -e "${CYAN}  $(date '+%Y-%m-%d %H:%M:%S')${NC}"
    echo -e "${CYAN}  CPUs: $NPROC cores${NC}"
    echo -e "${CYAN}══════════════════════════════════════════════════════════════${NC}"
    echo ""

    printf "  %-45s %s\n" "Phase" "Duration"
    printf "  %-45s %s\n" "-----" "--------"
    for phase in "Kernel Modules (custom extensions)" \
                 "Kernel (full build: vmlinuz + modules)" \
                 "Tools (sudo_gate, chat, nnet, negamane)" \
                 "X11 (X.Org Server + libraries)" \
                 "Root Filesystem Assembly" \
                 "ISO Generation (bootable image)"; do
        if [ -n "${TIMES[$phase]+x}" ]; then
            printf "  %-45s %s\n" "$phase" "${TIMES[$phase]}"
        fi
    done

    echo ""

    # Save to log
    {
        echo "=== Build Timing Log ==="
        echo "Date: $(date '+%Y-%m-%d %H:%M:%S')"
        echo "CPUs: $NPROC"
        echo "Phase: $PHASE"
        echo ""
        for phase in "${!TIMES[@]}"; do
            echo "  $phase: ${TIMES[$phase]}"
        done
    } > "$LOG_FILE"

    echo -e "  Log saved to: ${GREEN}$LOG_FILE${NC}"
    echo ""
}

# ==============================================================================
# Main
# ==============================================================================

TOTAL_START=$(date +%s)

echo -e "${CYAN}╔══════════════════════════════════════════════════════════════╗${NC}"
echo -e "${CYAN}║  Galactic Cherry Marvell Edition 98 — Timed Build          ║${NC}"
echo -e "${CYAN}║  Kernel: 5.15.204 | CPUs: $NPROC cores                          ║${NC}"
echo -e "${CYAN}║  Phase: $PHASE                                             ║${NC}"
echo -e "${CYAN}╚══════════════════════════════════════════════════════════════╝${NC}"

case "$PHASE" in
    modules)
        do_modules
        ;;
    kernel)
        do_kernel
        ;;
    tools)
        do_tools
        ;;
    x11)
        do_x11
        ;;
    rootfs)
        do_rootfs
        ;;
    iso)
        do_iso
        ;;
    all)
        do_kernel
        do_tools
        do_x11
        do_rootfs
        do_iso
        ;;
    *)
        echo "Unknown phase: $PHASE"
        echo "Valid: modules, kernel, tools, x11, rootfs, iso, all"
        exit 1
        ;;
esac

TOTAL_END=$(date +%s)
TOTAL_ELAPSED=$((TOTAL_END - TOTAL_START))
TOTAL_MINS=$((TOTAL_ELAPSED / 60))
TOTAL_SECS=$((TOTAL_ELAPSED % 60))

TIMES["TOTAL"]="${TOTAL_MINS}m ${TOTAL_SECS}s"

print_summary

echo -e "  ${GREEN}TOTAL: ${TOTAL_MINS}m ${TOTAL_SECS}s${NC}"
echo ""
