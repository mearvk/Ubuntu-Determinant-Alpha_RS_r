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

## `premount push`: reference + ordered 200 MiB add/commit sequence

`premount push` turns the read-only inventory into a **transfer plan**. It
produces a deterministic premount *document*, computes a cryptographic
*reference* for that document, and then transfers the ordered candidate set as
an ordered add/commit sequence bounded by the native 200 MiB transaction size,
with partial-commit/resume support.

```
git-workflow.sh premount [repo] push [remote] [branch] [--sha512] [--attempts N]
```

### The document and its reference

The document body is **deterministic**: one line per ordered candidate file, as
`transaction<TAB>size<TAB>path`, in Git pathname order, grouped into 200 MiB
transactions. The reference is a digest computed **over that body only** —
never over volatile fields such as the wall-clock timestamp — so the same
candidate set always yields the same reference. This is what makes the output
*consistent* and what a resumed run can check against.

| Aspect | Policy |
|---|---|
| Digest floor | **SHA-256** (64 hex chars) |
| "Or better" | **SHA-512** via `--sha512` (128 hex chars) |
| Reference scope | deterministic document body (paths, sizes, txn grouping) |
| Excluded from reference | timestamp and any host-specific presentation |

The native contract mirrors this: `git_premount_digest_algo`
(`SHA256`/`SHA512`), `git_premount_digest_hexlen()`, and
`git_premount_digest_label()` in `premount.h`, with the plan validated by
`git_premount_push_plan_finalize()`. Per `SHA256.md`, the reference proves
byte-level integrity only; it is not authenticity or authorization.

### Ordered 200 MiB transactions

The ordered candidate set is partitioned into transactions of at most
**200 MiB** (`GIT_PREMOUNT_PUSH_TXN_BYTES`). A file is never split; a single
object larger than 200 MiB is an explicit oversize planning error, not a silent
fragmentation. The partitioning is implemented deterministically by
`git_premount_push_partition()` and mirrored in the shell.

| Boundary | Value |
|---|---:|
| transaction size | 200 MiB |
| relation to add block | 2 × 100 MiB |
| relation to commit unit | 4 × 50 MiB |

### Partial commits and resume

Each transaction is committed in order, forming an ordered chain. The push is
then driven by the resume policy (`RESUME.md`): an interrupted transfer resumes
from the last remote-acknowledged commit rather than restarting, up to
`--attempts N` (default 5; `0` = unlimited by policy). Because each commit sits
on a 200 MiB transaction boundary, a lossy interruption never leaves a
partially transferred transaction — only fully acknowledged commits advance the
remote. The 200 MiB object guard re-runs on every attempt, so `premount push`
never weakens the ceiling.
