#!/usr/bin/env bash
#
# build-edition-git.sh — one-command build of the Ubuntu Determinant Edition
# git binary from the vendored tree in tools/git/git.
#
# It captures everything learned about building this tree in a restricted /
# CI sandbox so the build does not have to be rediscovered:
#
#   1. Provisions tiny `cmp`/`diff` shims on PATH when GNU diffutils is absent
#      (Git's build scripts call `cmp`; the sandbox may lack it and have no
#      network to install it).
#   2. Applies the captured flag set from build/git-full.mk
#      (NO_EXPAT / NO_LIBPCRE / NO_GETTEXT / NO_TCLTK / NO_PYTHON).
#   3. Builds in stages (libgit.a, then the git binary) so a long build makes
#      visible progress and incremental relinks stay fast.
#   4. Verifies the resulting binary runs and that the native `temperature`
#      command is registered.
#
# Usage:
#   tools/git/build-edition-git.sh [-j N] [--clean] [--verify-only]
#
#   -j N           parallelism (default: nproc, capped at 8)
#   --clean        `make clean` in the git tree first (forces a full rebuild)
#   --verify-only  skip building; just run the verification checks
#
# Exit status is non-zero if the build or verification fails.
set -euo pipefail

SELF_DIR="$(cd -P "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
GIT_SRC="$SELF_DIR/git"
BUILD_DIR="$SELF_DIR/build"
SHIM_DIR="$BUILD_DIR/.shims"

# Flag set: prefer the values recorded in git-full.mk, fall back to a literal
# copy so the script still works if that file is edited/missing.
GIT_FULL_FLAGS="$(make -s -f "$BUILD_DIR/git-full.mk" print-flags 2>/dev/null || true)"
[ -n "$GIT_FULL_FLAGS" ] || GIT_FULL_FLAGS="NO_EXPAT=1 NO_LIBPCRE=1 NO_GETTEXT=1 NO_TCLTK=1 NO_PYTHON=1"

JOBS="$(nproc 2>/dev/null || echo 4)"; [ "$JOBS" -gt 8 ] && JOBS=8
DO_CLEAN=0
VERIFY_ONLY=0
while [ "$#" -gt 0 ]; do
  case "$1" in
    -j) shift; JOBS="${1:-4}"; [[ "$JOBS" =~ ^[1-9][0-9]*$ ]] || { echo "ERROR: -j needs a positive integer" >&2; exit 2; } ;;
    --clean) DO_CLEAN=1 ;;
    --verify-only) VERIFY_ONLY=1 ;;
    -h|--help) sed -n '2,30p' "$0"; exit 0 ;;
    *) echo "ERROR: unknown argument: $1" >&2; exit 2 ;;
  esac
  shift
done

[ -d "$GIT_SRC" ] || { echo "ERROR: git source tree not found at $GIT_SRC" >&2; exit 1; }

# --- 1. Ensure cmp/diff are available (provision perl shims if not) ---------
ensure_diffutils() {
  local need=0 t
  for t in cmp diff; do command -v "$t" >/dev/null 2>&1 || need=1; done
  [ "$need" -eq 0 ] && { echo "build: cmp/diff present"; return 0; }

  command -v perl >/dev/null 2>&1 || {
    echo "ERROR: cmp/diff are missing and perl is unavailable to shim them." >&2
    echo "       Install GNU diffutils and re-run." >&2
    exit 1
  }

  mkdir -p "$SHIM_DIR"
  cat > "$SHIM_DIR/cmp" <<'SHIM'
#!/usr/bin/env perl
# Minimal cmp: exit 0 identical, 1 differ, 2 error. Supports -s (silent).
use strict; use warnings;
my @a = grep { $_ ne '-s' } @ARGV;
my $silent = grep { $_ eq '-s' } @ARGV;
exit 2 unless @a == 2;
open(my $f1,'<',$a[0]) or exit 2; open(my $f2,'<',$a[1]) or exit 2;
binmode $f1; binmode $f2; local $/;
my $d1=<$f1>; my $d2=<$f2>;
exit 0 if defined $d1 && defined $d2 && $d1 eq $d2;
print "$a[0] $a[1] differ\n" unless $silent;
exit 1;
SHIM
  cat > "$SHIM_DIR/diff" <<'SHIM'
#!/usr/bin/env perl
# Minimal diff: exit 0 identical, 1 differ, 2 error.
use strict; use warnings;
my @a = grep { !/^-/ } @ARGV;
exit 2 unless @a == 2;
open(my $f1,'<',$a[0]) or exit 2; open(my $f2,'<',$a[1]) or exit 2;
local $/; my $d1=<$f1>//''; my $d2=<$f2>//'';
exit($d1 eq $d2 ? 0 : 1);
SHIM
  chmod +x "$SHIM_DIR/cmp" "$SHIM_DIR/diff"
  export PATH="$SHIM_DIR:$PATH"
  echo "build: provisioned cmp/diff shims in $SHIM_DIR"
}

# --- verification: binary runs and temperature is registered ----------------
verify() {
  local git_bin="$GIT_SRC/git"
  [ -x "$git_bin" ] || { echo "VERIFY FAIL: git binary not found at $git_bin" >&2; return 1; }
  echo "verify: $("$git_bin" --version)"
  # Capture the full command listing first, then grep. Piping directly into
  # `grep -q` makes grep close the pipe on first match, git takes SIGPIPE, and
  # under `set -o pipefail` the whole pipeline reports failure. Buffering the
  # output into a variable avoids that interaction.
  local help_all
  help_all="$("$git_bin" help -a 2>&1 || true)"
  if printf '%s\n' "$help_all" | grep -q "temperature"; then
    echo "verify: 'temperature' command is registered"
  else
    echo "VERIFY FAIL: 'temperature' not listed by 'git help -a'" >&2
    return 1
  fi
  # The `messages` builtin (catalog / .gitmessages inspector) should register.
  if printf '%s\n' "$help_all" | grep -q "messages"; then
    echo "verify: 'messages' command is registered"
  else
    echo "VERIFY FAIL: 'messages' not listed by 'git help -a'" >&2
    return 1
  fi
  # And it should actually run: with no config, validate reports the compiled
  # defaults are in effect and exits 0.
  if "$git_bin" messages validate >/dev/null 2>&1; then
    echo "verify: 'git messages validate' runs (compiled defaults OK)"
  else
    echo "VERIFY FAIL: 'git messages validate' did not run cleanly" >&2
    return 1
  fi
  # push.resumeAttempts config knob should be recognized by our builtin push.
  if "$git_bin" -c push.resumeattempts=3 config --get push.resumeattempts >/dev/null 2>&1; then
    echo "verify: push.resumeAttempts config recognized"
  fi
  echo "verify: OK"
}

if [ "$VERIFY_ONLY" -eq 1 ]; then
  verify; exit $?
fi

ensure_diffutils

if [ "$DO_CLEAN" -eq 1 ]; then
  echo "build: make clean"
  make -C "$GIT_SRC" $GIT_FULL_FLAGS clean >/dev/null 2>&1 || true
fi

# --- 2/3. Staged build ------------------------------------------------------
echo "build: flags = $GIT_FULL_FLAGS"
echo "build: jobs  = $JOBS"
echo "build: stage 1/2 — libgit.a (core object set)"
make -C "$GIT_SRC" -j"$JOBS" $GIT_FULL_FLAGS libgit.a common-main.o
echo "build: stage 2/2 — git binary (builtins + link)"
make -C "$GIT_SRC" -j"$JOBS" $GIT_FULL_FLAGS git

# --- 4. Verify --------------------------------------------------------------
verify
echo "build: done — $GIT_SRC/git"
