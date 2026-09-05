# Native `premount` inventory method

`premount` is a read-only pre-operation inventory. Before work is actually
staged or committed, it enumerates the files newly introduced by a pending
`add`, a pending `commit`, or both, and assembles a deterministic per-file
record intended for a **printable table**.

It supplements Git and never alters index state, history, or transport. The
rows it produces are advisory planning metadata, consistent with the
`TIER-1`/`TIER-2` and `PRIORI-INTEGRATION` relevance markers in
`GIT_OPERATIONS.logic`.

## Sources

`premount` can account for either pending operation, or their union:

| Source | Candidates considered |
|---|---|
| `add` | files that a pending `git add` would introduce (worktree) |
| `commit` | files already staged for a pending `git commit` (index) |
| `both` | the deterministic union of the two candidate sets |

A path present in both sets is reported **once**, with a combined source
marker, so the table never double-counts a file.

## Table columns

Each row carries the following columns, in order:

| Column | Meaning |
|---|---|
| `timestamp` | operation/inspection timestamp |
| `author` | Git author identity |
| `size` | object-byte estimate for the file |
| `suffix` | filename suffix, including the leading dot |
| `operating system` | recording host OS identifier |
| `learning grade` | advisory pedagogical grade (`ungraded`..`graduate`) |
| `CS prerequisites` | prerequisite Computer Science topics, if declared |
| `graded authorships` | graded authorship attribution |
| `college references` | course/college reference citations |

`path` is used as the deterministic row key. Missing optional metadata is
recorded as absent rather than invented.

### Learning grade

The learning grade is a **pedagogical relevance marker**, loosely aligned to
course levels:

| Grade | Level |
|---|---|
| `ungraded` | not classified |
| `introductory` | CS100-level, first exposure |
| `foundational` | CS200-level, core competency |
| `intermediate` | CS300-level, applied competency |
| `advanced` | CS400-level, specialization |
| `graduate` | CS500+-level, research competency |

The grade is never inferred from identity, appearance, credentials, or other
personal characteristics, and it grants no repository, execution, security, or
authorization privilege. It exists only to annotate the printable table.

## Size accounting

`size` is an on-disk object-byte estimate per file, not a prediction of
wire-format pack size. The running total is accumulated with overflow
rejection rather than wrapping, consistent with the overflow rule used
elsewhere in the native method. `premount` never weakens the native 200 MiB
push ceiling; the push guard remains authoritative.

## Native implementation contract

This policy is represented in native source — `git/premount.h` with C and C++
companions `git/premount.c` and `git/premount.cpp` — rather than a shell
wrapper. The current change establishes the source, row structure, validation,
and overflow-checked size accounting.

The eventual implementation should:

1. leave ordinary `add`/`commit` behavior unchanged; `premount` only inspects;
2. enumerate candidates deterministically in Git pathname order;
3. merge the `add` and `commit` candidate sets without double-counting shared paths;
4. account for actual Git object sizes rather than trusting working-tree length alone;
5. preserve author, timestamp, and parent-object provenance on each row;
6. record missing optional metadata as absent, never invented;
7. treat the emitted table as advisory metadata that never bypasses the 200 MiB push guard.

The shell surface exposes the inventory through
`git-workflow.sh premount [repo] [--add|--commit|--both]`, which prints the
table for the selected source. The native structures remain the contract that
a later `builtin` integration can adopt.
