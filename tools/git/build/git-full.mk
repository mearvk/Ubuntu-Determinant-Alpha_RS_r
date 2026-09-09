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

# ---------------------------------------------------------------------------
# Message catalog + diagnostic hook (always linked).
#
# git.c installs the message system at startup (gitmsg_listen_init +
# gitmsg_diag_install), and the `messages` builtin uses the loader, so the
# catalog object set must link into every build. Those objects are listed
# directly in Git's own Makefile LIB_OBJS (alongside resume-budget.o):
#
#   messages.o        the compiled default catalog + validate/lookup;
#   gitmsg-config.o   the .gitmessages loader ([MESSAGE] overrides + [MAP]);
#   gitmsg-listen.o   the listener state, catalog init, and resolve helpers;
#   gitmsg-diag.o     the die/error/warning routine hook.
#
# so no LIB_OBJS override is needed here. The plain `git` target therefore
# already has the diagnostic hook, .gitmessages loading, and `git messages`;
# only the raw-print interposition below is opt-in.
# ---------------------------------------------------------------------------

# ---------------------------------------------------------------------------
# Tree-wide print listener (opt-in force-include).
#
# On top of the always-linked objects, the `git-listen` target force-includes
# gitmsg-listen.h into every translation unit so the raw print primitives
# (printf/fprintf/fputs/...) are interposed too, carrying their call site to the
# catalog. This is kept separate so the print-interposition surface is an
# explicit opt-in; the listener's own TU defines GITMSG_LISTEN_IMPL, so the
# force-include is inert there and it calls the real libc functions.
#
#   GITMSG_LISTEN_FLAGS injects, into the compile of every translation unit,
#     -DGITMSG_LISTEN            enable the macros in gitmsg-listen.h, and
#     -include gitmsg-listen.h   force-include it after the system headers.
#
# Build it with:   make -f git-full.mk git-listen
# ---------------------------------------------------------------------------
GITMSG_LISTEN_FLAGS := -DGITMSG_LISTEN -include gitmsg-listen.h

.PHONY: git clean print-flags git-listen print-listen-flags gitmsg

# Ordinary Edition git: catalog, diagnostic hook, and `git messages` are linked
# in via the tree Makefile's LIB_OBJS; raw prints are NOT interposed.
git:
	$(MAKE) -C $(GIT_SRC) $(GIT_FULL_FLAGS) git

# Same as `git`, plus the tree-wide print interposition force-include.
git-listen:
	$(MAKE) -C $(GIT_SRC) $(GIT_FULL_FLAGS) \
		CFLAGS="$$CFLAGS $(GITMSG_LISTEN_FLAGS)" \
		git

# ---------------------------------------------------------------------------
# gitmsg — the friendly inspector for the catalog and .gitmessages config.
# Self-contained: links only the loader + catalog, no git objects. Reports
# exactly what the binary would apply (path / validate / list / rules).
#
#   make -f git-full.mk gitmsg     # builds ../git/gitmsg
# ---------------------------------------------------------------------------
GITMSG_CLI_CC  ?= cc
GITMSG_CLI_SRC := $(GIT_SRC)/gitmsg-cli.c $(GIT_SRC)/gitmsg-config.c $(GIT_SRC)/messages.c

gitmsg:
	$(GITMSG_CLI_CC) -O2 -I$(GIT_SRC) $(GITMSG_CLI_SRC) -o $(GIT_SRC)/gitmsg
	@echo "Built $(GIT_SRC)/gitmsg — try: $(GIT_SRC)/gitmsg list"

clean:
	$(MAKE) -C $(GIT_SRC) $(GIT_FULL_FLAGS) clean
	$(RM) $(GIT_SRC)/gitmsg

print-flags:
	@echo $(GIT_FULL_FLAGS)

print-listen-flags:
	@echo $(GITMSG_LISTEN_FLAGS)
