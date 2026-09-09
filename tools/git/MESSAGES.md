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

## Building

The companions are registered in `build/Makefile` (C and C++ sources, plus
`messages.h` and `gitmsg-listen.h` in the header check) and build with the rest
of the native policy:

```sh
make -C build          # compile + archive (includes messages, gitmsg-listen)
make -C build check    # verifies the header set is present
```

The full binary with the listener force-included tree-wide builds from the
opt-in target (the default `git` target stays byte-for-byte as validated):

```sh
make -f build/git-full.mk git          # ordinary Edition git (no listener)
make -f build/git-full.mk git-listen   # + tree-wide print listener
make -f build/git-full.mk print-listen-flags
```
