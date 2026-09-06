# git-full.mk — captured flag set for building the Ubuntu Determinant Edition
# git binary from the vendored tree in ../git.
#
# This fragment records the flags that are known to build the full `git`
# binary in the restricted build/CI sandbox, so nobody has to rediscover them.
# It is consumed two ways:
#
#   1. tools/git/build-edition-git.sh includes it to export GIT_FULL_FLAGS.
#   2. You can pass the same flags to Git's own Makefile by hand:
#        make -C ../git $(cat this list) git
#
# It does NOT replace Git's Makefile; it only names the option set.
#
# ---------------------------------------------------------------------------
# Why each flag is set (all are stock upstream Git Makefile knobs):
#
#   NO_EXPAT=1     - libexpat headers are absent in the sandbox; only
#                    git-http-push needs them. Safe to disable.
#   NO_LIBPCRE=1   - libpcre2 headers are absent; only `grep -P` needs them.
#   NO_GETTEXT=1   - build without message translation (no runtime i18n data).
#   NO_TCLTK=1     - skip the Tcl/Tk GUI (git-gui / gitk); not needed for CLI.
#   NO_PYTHON=1    - skip optional Python bits (e.g. git-p4).
#
# The core object set (libgit.a), all builtins, and the native policy modules
# — including resume-budget.o (LIB_OBJS) and the registered `temperature`
# command — build and link with exactly this set.
# ---------------------------------------------------------------------------

# The flag set, as a single make variable other makefiles/scripts can reuse.
GIT_FULL_FLAGS := \
	NO_EXPAT=1 \
	NO_LIBPCRE=1 \
	NO_GETTEXT=1 \
	NO_TCLTK=1 \
	NO_PYTHON=1

# ---------------------------------------------------------------------------
# Build prerequisite: `cmp` and `diff` (GNU diffutils) must be on PATH.
# Git's build scripts (GIT-VERSION-GEN and several GEN steps) invoke `cmp`.
# The restricted sandbox may not ship diffutils and has no network to install
# it; build-edition-git.sh provisions tiny perl-based shims in that case.
# ---------------------------------------------------------------------------
GIT_FULL_REQUIRED_TOOLS := cmp diff

# Convenience passthrough targets when this file is used as a makefile:
#   make -f git-full.mk git    # build the binary with the captured flags
#   make -f git-full.mk clean
GIT_SRC ?= ../git

.PHONY: git clean print-flags

git:
	$(MAKE) -C $(GIT_SRC) $(GIT_FULL_FLAGS) git

clean:
	$(MAKE) -C $(GIT_SRC) $(GIT_FULL_FLAGS) clean

print-flags:
	@echo $(GIT_FULL_FLAGS)
