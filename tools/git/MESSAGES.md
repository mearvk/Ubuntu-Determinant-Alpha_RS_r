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

## Building

The companions are registered in `build/Makefile` (C and C++ sources, plus
`messages.h` in the header check) and build with the rest of the native policy:

```sh
make -C build          # compile + archive (now includes messages)
make -C build check    # verifies messages.h is present
```
