# Native `alter-comment` method

`alter-comment` is an integer-addressed commit-message alteration operation. It
changes only the human-readable message of the most recent commits, addressed by
an integer count:

```
git alter-comment X "Commit Message"
```

`X` is a positive integer naming the **last X commits** on the current branch
whose messages are to be altered. It supplements Git without inventing history:
it alters messages only, and Git's resulting rewritten graph remains
authoritative.

## Integer addressing

`X` selects how many of the most recent commits are addressed, walking a
deterministic linear history from the tip:

| Command | Addresses |
|---|---|
| `git alter-comment 1 "msg"` | the tip commit only |
| `git alter-comment 2 "msg"` | the last 2 commits |
| `git alter-comment 3 "msg"` | the last 3 commits |
| `git alter-comment X "msg"` | the last `X` commits |

`X` must be at least `1` and must not exceed the number of commits actually
reachable on the selected linear history. Asking to alter more commits than
exist is an explicit planning error, **not** a silent clamp. `X == 0` is invalid
because there is nothing to alter.

The scope is derived from `X`:

| Scope | Condition | Effect |
|---|---|---|
| `TIP` | `X == 1` | reword the tip (effect of `git commit --amend` of the message) |
| `RANGE` | `X > 1` | reword each of the last `X` commits along a linear history |

## What changes and what does not

`alter-comment` alters **only the commit message**. It does not:

- change any tree, blob, or file content;
- add, remove, or reorder commits;
- change the Git author or committer identity, or the author/committer dates;
- select descendants across a merge DAG — the addressed range must be a
  deterministic linear history.

## Why new object IDs appear

A commit message is part of the commit object that Git hashes, so rewriting a
message necessarily produces **new commit objects with new object IDs** for each
addressed commit and every descendant. This is ordinary Git message-edit history
rewriting — the same effect as an interactive-rebase reword, or
`git commit --amend` for the tip. The native policy layer records provenance and
enforces the bounded, non-destructive contract around that rewrite; it does not
change the fact that Git's rewritten graph is authoritative.

The number of commit objects rewritten equals the number of addressed commits
(`X`), and that count is computed with integer-overflow rejection rather than
wrapping, consistent with the rest of the native method.

## Provenance

Each alter-comment execution preserves and records, at minimum:

- the requested count `X` and the reachable commit count;
- the tip object id before and after the alteration;
- the addressed range's parent object;
- Git author, committer, author/committer date, and operation timestamp;
- the prior operation when chained;
- `TIER-1`/`TIER-2`/`PRIORI-INTEGRATION` relevance markers.

A non-empty replacement message is required; an empty or absent message is
rejected rather than blanked or invented. Missing optional metadata is recorded
as absent, never fabricated.

## Native implementation contract

The policy is represented in native source — `git/alter-comment.h` with C and
C++ companions `git/alter-comment.c` and `git/alter-comment.cpp` — rather than a
shell wrapper. The current change establishes the constants, the request/record
structure, scope resolution (`git_alter_comment_plan_scope`), range and message
validation (`git_alter_comment_request_validate`), and the overflow-checked
rewrite-count arithmetic (`git_alter_comment_plan_rewrites`).

The eventual implementation should:

1. leave ordinary `git commit` / `git rebase` behavior unchanged unless the
   integer alter-comment form is deliberately recognized by the command parser;
2. resolve `X` against the reachable linear history and refuse an out-of-range
   count rather than clamping;
3. require a non-empty replacement message;
4. rewrite only the messages of the addressed commits, preserving trees,
   authorship, and dates;
5. record the resulting new object IDs and preserve provenance across the
   rewrite;
6. treat the recorded plan as advisory metadata that never manufactures,
   removes, or reorders commits.

The integer/scope semantics are therefore **presumed now in the source
architecture**, while the final builtin integration (connecting the integer
parser to the reword machinery in `builtin/commit.c` / the rebase path) remains a
subsequent, deliberate step.
