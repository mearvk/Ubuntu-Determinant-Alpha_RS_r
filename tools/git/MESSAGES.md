# Native `messages` method

`messages` is a single, reviewable definition of the human-facing text the
Edition Git emits on **stdout** and **stderr**, and of the **concerns** those
messages describe — memory bloat, disk-space exhaustion, missing files, and the
like. It supplements Git and changes no behaviour: it only governs how output is
worded and which stream it is written to.

Until now every user-facing string lived inline in the command surface
(`git-workflow.sh`) as an ad-hoc `echo "ERROR: ..." >&2`. That made the wording
inconsistent and impossible to review as a whole. This method centralizes the
text and its classification into three coordinated pieces:

| Piece | File | Role |
|---|---|---|
| Native contract | `git/messages.h` | Enums (stream, severity, concern, message id), the default catalog, and validity/lookup prototypes. C- and C++-clean. |
| Companions | `git/messages.c`, `git/messages.cpp` | The compiled default catalog, catalog validation, and lookup. |
| Config document | `git/messages.config.example` | The seed/override document (recommended location `.gitmessages` at the repo root). |

The command surface reads the config as a **reference and input**: it resolves
`$REPO/.gitmessages` (per-repository), else the shipped
`git/messages.config.example`, and uses the wording found there; anything not
overridden keeps the compiled default.

## Streams and severities

`stdout` carries **results and progress**; `stderr` carries **diagnostics**.
Severity is a small, conventional ladder:

| Severity | Meaning | Default stream |
|---|---|---|
| `info` | ordinary result | stdout |
| `note` | benign observation worth seeing | stderr |
| `warning` | weigh this; the operation still proceeds | stderr |
| `error` | the operation cannot proceed as asked and stops | stderr |
| `fatal` | unrecoverable; the process cannot safely continue | stderr |

## Concerns

A **concern** is the underlying condition; a **message** is how it is phrased.
The defined concern classes are:

- **Resource** — `memory-bloat`, `disk-space`, `size-ceiling`,
  `arithmetic-overflow`.
- **Integrity** — `missing-file`, `corruption`, `provenance-gap`.
- **Precondition** — `permission`, `precondition`, `network-loss`.
- **none** — ordinary success/progress.

Each concern has a settled one-line definition and a default severity/stream in
`git/messages.config.example`. `memory-bloat` and `disk-space` are advisory
resource concerns; `size-ceiling` reuses the existing 200 MiB transaction
budget; `arithmetic-overflow` mirrors the reject-don't-wrap rule shared by the
other native modules.

## The config document

UTF-8, line-oriented `KEY: value`, `#` comments, case-insensitive keys, opened
by `[CONCERN <name>]` and `[MESSAGE <id>]` section headers — the same
conventions as `GIT_OPERATIONS.logic` and `git/propath.config.example`. A
message block accepts `TEXT` (required), and optional `STREAM`, `SEVERITY`, and
`CONCERN`:

```
MESSAGES-VERSION: 1

[MESSAGE not-a-repo]
CONCERN: precondition
TEXT: This folder is not under version control yet. Run 'git init' to begin.
```

Message ids match `enum git_msg_id` in `git/messages.h`. The full set is:
`git-required`, `not-a-repo`, `tree-not-clean`, `detached-head`,
`nothing-staged`, `message-required`, `pathspec-required`, `bad-argument`,
`unknown-command`, `size-ceiling`, `memory-bloat`, `disk-space`,
`missing-file`, `corruption`, `overflow`, `permission`, `no-digest-tool`,
`resume-interrupted`, `resume-halted`, `resume-complete`.

## Safety

This method is **advisory presentation only**. A config may re-word, re-stream,
or localize output — it can never change an operation's behaviour. Specifically:

- an `error` or `fatal` message may **not** be routed to `stdout`; such an
  override is rejected so a diagnostic can never be hidden (verified in both the
  native `git_msg_catalog_validate` and the shell loader);
- a stale, missing, or altered config falls back to the compiled defaults in
  `git/messages.h` rather than failing the operation or inventing a permissive
  result;
- nothing here turns an error into a success, suppresses a safety refusal,
  changes a failing exit status, or authorizes a destructive action.

## Tree-wide print listener

The shell surface (`git-workflow.sh`) reads the catalog for its own guard
messages. To bring the **compiled `git` binary** under the same catalog, a
tree-wide print listener interposes every stdout/stderr print primitive so
each write reaches the catalog before it is emitted.

| File | Role |
|---|---|
| `git/gitmsg-listen.h` | Force-included header. Redefines the C output primitives (`printf`, `fprintf`, `vfprintf`, `printf`, `vprintf`, `fputs`, `puts`, `fputc`/`putc`, `putchar`, `fwrite`) as macros that capture `__FILE__` / `__func__` / `__LINE__` and the target stream and forward to the shims. |
| `git/gitmsg-listen.c` | The shims. Each renders the caller's text, resolves it against the catalog + `[MAP]` rules, and either emits the catalogued message on its stream or writes the original bytes through unchanged. |

How a write flows:

1. A call site anywhere in the tree calls, say, `fprintf(stderr, "...")`.
2. The macro forwards it to `gitmsg_fprintf(file, func, line, stderr, ...)`.
3. The shim renders the text, then `gitmsg_resolve()` checks the `[MAP]` rules
   (matching on file / function / text substrings) against the loaded catalog.
4. On a match, the catalogued message is emitted on its configured stream; with
   no match, the original bytes pass through **verbatim**.

This is how "when we get an output to print, we take the call site, then decide
the real message" is realized for the binary. Applied via the build's
force-include (`-include gitmsg-listen.h`), so all translation units get the
listener with no per-file edits.

Design guarantees:

- **Pass-through by default.** The shipped `[MAP]` is empty, so merely enabling
  the listener changes no output; Git's data output (`git log` / `diff` /
  `cat-file` / the pack protocol) is only altered where a rule explicitly maps
  it.
- **No hidden diagnostics.** A rule that resolves to an `error`/`fatal` message
  is never allowed to route it to stdout; the match is refused and the original
  bytes pass through.
- **Self-exclusion.** `gitmsg-listen.c` defines `GITMSG_LISTEN_IMPL`, which
  disables the macros in its own translation unit so the shims call the real
  libc functions.
- **Opt-in build.** The known-good `git` target is unchanged; the listener is a
  separate `git-listen` target (see below).

Scope note: only stdout/stderr **print** primitives are interposed. Trace and
log-file sinks are deferred by design.

## Loading `.gitmessages` at runtime

The compiled binary reads its config through a native loader
(`git/gitmsg-config.{h,c}`), so no shell is involved:

- **Where it looks:** `$GIT_MESSAGES_CONFIG` if set, else `./.gitmessages`,
  else the compiled defaults.
- **What it applies:** `[MESSAGE <id>]` blocks overlay `TEXT` / `STREAM` /
  `SEVERITY` onto the default catalog; `[MAP]` lines become the rule table the
  listener consults.
- **Safety:** the overlaid catalog is re-validated with
  `git_msg_catalog_validate()`. If an override is unsafe (an error/fatal routed
  to stdout, or an emptied message), the loader **discards the overrides and
  restores the compiled defaults**, records that it did so, and still returns a
  usable result. A missing or unreadable file is not an error — it just yields
  the defaults.

`git.c` calls `gitmsg_listen_init(".")` once at startup, so the catalog and map
are ready before any command runs.

## Structured diagnostics (`die` / `error` / `warning`)

Beyond raw prints, Git funnels its structured diagnostics through pluggable
routines in `usage.c`. `git/gitmsg-diag.c` installs replacements via
`set_die_routine` / `set_error_routine` / `set_warn_routine` (from
`gitmsg_diag_install()`, also called once in `git.c`). Each renders the text Git
was about to print, offers it to the catalog's `[MAP]` rules, and:

- emits the catalogued wording on stderr when a rule matches, otherwise
- delegates to Git's original routine so the wording, prefix, and `trace2`
  behaviour are preserved exactly.

The `die` route keeps `die()`'s contract (no return, `exit(128)`). Because these
routines are installed unconditionally, structured diagnostics resolve through
the catalog in **every** build — even the plain `git` target without the
tree-wide print interposition.

## Inspecting the catalog and config

`gitmsg` is a small, self-contained inspector that reuses the same loader, so
what it reports is exactly what the binary applies:

```sh
gitmsg path        # which config file is in effect
gitmsg validate    # load + validate; warns if unsafe overrides were dropped
gitmsg list        # the resolved message catalog (id, stream, severity, text)
gitmsg rules       # the resolved [MAP] rules
gitmsg --config <file> <cmd>   # inspect a specific file
```

The same is reachable through the workflow wrapper, which prefers the native
`gitmsg` and otherwise falls back to its own built-in wordings:

```sh
git-workflow.sh messages [repo] [path|validate|list|rules]
```

A ready-to-copy starting point ships as `tools/git/gitmessages.example` — copy
it to a repository root as `.gitmessages` and adjust.

## Building

The companions are registered in `build/Makefile` (C and C++ sources, plus
`messages.h`, `gitmsg-listen.h`, and `gitmsg-config.h` in the header check) and
build with the rest of the native policy:

```sh
make -C build          # compile + archive (includes messages, gitmsg-listen)
make -C build check    # verifies the header set is present
```

The full binary with the listener force-included tree-wide builds from the
opt-in target (the default `git` target stays byte-for-byte as validated):

```sh
make -f build/git-full.mk git          # ordinary Edition git (catalog + diag hook)
make -f build/git-full.mk git-listen   # + tree-wide raw-print interposition
make -f build/git-full.mk gitmsg       # the standalone gitmsg inspector
make -f build/git-full.mk print-listen-flags
```

Note the split: the plain `git` build already links the catalog, the
`.gitmessages` loader, and the diagnostic hook, so structured diagnostics
resolve through the catalog. The `git-listen` build additionally force-includes
the listener so raw `printf`/`fprintf` output is interposed too.
