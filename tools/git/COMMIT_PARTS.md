# Native Commit-Part Method

This document establishes the initial contract for the integer commit method being added to the vendored Git implementation.

## Contract

An integer-only commit request is intended to mean an ordered logical commit set measured in **50 MiB units**:

| Command | Logical target |
|---|---:|
| `git commit 1` | 50 MiB |
| `git commit 2` | 100 MiB |
| `git commit 3` | 150 MiB |
| `git commit 4` | 200 MiB |
| `git commit 5` | 250 MiB |

The initial native policy constants live in `git/commit-budget.h`.

## Ordering

The planner will select the index's candidate paths in deterministic Git pathname order (lexicographic/a-z ordering). A file is not split merely to make a 50 MiB boundary. Part boundaries are planning boundaries between files.

The planner must account for Git object sizes rather than treating working-tree file length as the final transport cost. A single object that cannot fit a 50 MiB unit is an explicit planning failure, not a silent truncation or arbitrary split.

## Commit structure

The intended implementation is a linear sequence of actual commits when more than one unit is requested:

`parent -> part 1 -> part 2 -> ... -> part N`

Each part records enough metadata to identify its ordinal position, parent, selected paths, and measured object budget. The final commit represents the complete requested set.

Normal `git commit` behavior remains unchanged unless the integer-only form is deliberately recognized by the command parser.

## Push relationship

The existing native push ceiling remains **200 MiB (4 × 50 MiB)**. A logical commit set larger than 200 MiB must therefore be transferable as multiple ordered push transactions rather than by weakening the ceiling.

For example, a five-unit plan is 250 MiB logically. The intended transport progression is:

1. parts 1-4: up to 200 MiB;
2. part 5: the remaining 50 MiB.

The commit-part record is advisory planning metadata. The push guard must still recompute the actual Git object graph and enforce the hard 200 MiB ceiling. A stale or altered plan must never bypass the transport policy.

## Implementation status

This is the **start of the native method**, not the completed command integration. The next implementation step is to connect the integer parser to `builtin/commit.c`, enumerate and order index paths, construct the part commits, and persist the part manifest used by the push planner.
