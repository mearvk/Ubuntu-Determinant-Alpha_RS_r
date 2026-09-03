# REVISION

## Repository Operation Model Revision

**Revision date:** 2026-09-02

This revision documents the expanded native Git operation model for the Ubuntu Determinant repository. The model preserves Git's original semantics while adding a persistent, repository-local record of file relevance, provenance, prior integrations, operation relationships, and future-facing scheduling metadata.

## 1. Operations Covered

The model applies consistently to:

- `add`
- `commit`
- `push`
- `merge`
- `rebase`

Each operation retains its ordinary Git responsibility. The additional policy layer records the reasoning and provenance around the operation rather than replacing Git's object database or commit graph.

## 2. File Relevance

Operations distinguish more than a simple changed/not-changed state.

### Tier 1 — Direct relevance

Files and objects directly required to perform the operation.

### Tier 2 — Material relevance

Files and objects materially related to the operation even when they are not directly required by the immediate command.

### PRIORI-INTEGRATION

Material that has already been integrated, staged, referenced, or deliberately established as input for a subsequent operation. A priori integration is recorded as provenance; it does not grant permission to absorb unrelated material automatically.

### UPLOAD

Material actually introduced into the repository by the operation. The record distinguishes intended or relevant material from material that was actually written.

The relevance model is deterministic and is intended to support later inspection of why a file participated in an operation.

## 3. Repository Provenance

The repository continues to preserve Git's native provenance, including where available:

- author
- committer
- author date
- commit timestamp
- parent commit(s)
- commit object ID
- tree/object relationships
- operation identity
- source and destination references

The logic layer supplements these markers; it does not replace them.

## 4. Add

The native add policy foundation uses deterministic breadth-first/pathname ordering and 100 MiB logical blocks. Files are not split merely to satisfy a block boundary.

Two 100 MiB add blocks correspond to the 200 MiB transport planning boundary. Actual Git object accounting remains authoritative over any presumed block calculation.

The add operation therefore records both the relevance of files selected for staging and their relationship to prior integrations.

## 5. Commit

The integer commit method uses 50 MiB logical units:

- `commit 1` = 50 MiB
- `commit 2` = 100 MiB
- `commit 3` = 150 MiB
- `commit 4` = 200 MiB
- `commit 5` = five ordered 50 MiB units, logically 250 MiB

For requests larger than four units, the plan is represented as ordered commit parts so that transport operations can remain within the 200 MiB push planning boundary. Files are selected deterministically and are not split solely to satisfy a logical boundary.

The integer method is an explicit extension; ordinary Git commit behavior remains authoritative when the extension is not invoked.

## 6. Push

The repository uses a native transport-side planning ceiling of 200 MiB. The guard is based on conservative Git object/on-disk accounting rather than an invented estimate of wire-pack size.

The operation model records which files/objects are relevant, which were previously integrated, and which objects are actually included in the push. A manifest or `.logic` record can explain the planned relationship, but cannot override the actual transport guard.

For multi-part commit plans, four 50 MiB logical units form the principal 200 MiB push group, with subsequent units handled as later transactions when the actual object graph permits.

## 7. Merge

`merge` retains its original Git meaning: integrate source history into the current repository while preserving the graph and conflict semantics.

The expanded model adds a future-facing **posit**:

- what was integrated
- what prior state it superseded
- what future base/message is intended
- the priority assigned to the integration
- the relevant human/process context
- the relationship to prior operations

Merge metadata is represented by a UTF-8 `.metadoc` and is associated with the operation in the repository.

Priority is advisory only. It cannot override authorization, graph correctness, object integrity, or conflict resolution.

Human/process descriptors such as competence, consideration, and proper responsibility may be recorded. Appearance is descriptive only and is never an eligibility, authorization, competence, or access criterion. Sensitive identifiers remain references or `PRESUMED/UNSET` rather than fabricated values.

## 8. Rebase

`rebase` retains its ordinary Git history-rewriting semantics. In the expanded project vocabulary it additionally represents reseating work according to a known schedule and continuing relative to an established County, Worker, and Set Schedule context where those references exist.

Its `.metadoc` records the schedule-relative relationship and preserves the associated operation provenance.

A rebase is never silently inferred merely because metadata suggests one. The condition is recorded so that a later explicit rebase can be performed with a traceable basis.

## 9. Merge-to-Rebase Notation

The project records an explicit relationship between repeated merge events and a possible later rebase.

**Two or more explicitly associated merge events** establish a `REBASE-QUALIFIED` signal in the metadata model. This means the merge chain has supplied enough repeated integration context to identify a possible schedule-relative reseating operation.

It does **not** automatically execute a rebase or rewrite history.

The notation is therefore:

```text
MERGE #1
  -> integration context

MERGE #2
  -> same associated rebase context

MERGE-COUNT >= 2
  -> REBASE-QUALIFIED: true
  -> explicit rebase may subsequently be requested
```

The association must be explicit; unrelated merges are not counted merely because they occurred in the same repository.

## 10. Persistent `.logic` Layer

The repository now assumes a persistent `.logic` record as the common notational layer for these operations.

The `.logic` layer tracks:

```text
OPERATION
OPERATION-ID
DATE
TIMESTAMP
AUTHOR
COMMITTER
PARENT-COMMIT
OBJECT-ID
CURRENT-BASE
SOURCE
DESTINATION
TIER-1-RELEVANCE
TIER-2-RELEVANCE
PRIORI-INTEGRATION
UPLOAD
PRIOR-OPERATION
FUTURE-BASE
PRIORITY
MERGE-COUNT
REBASE-THRESHOLD
REBASE-QUALIFIED
STATUS
```

Fields are intentionally descriptive and provenance-oriented. Git's actual object graph remains the source of truth for repository state.

## 11. `.metadoc` Layer

`.metadoc` remains the plain-text semantic record used where an operation needs richer scheduling or contextual notation, particularly merge and rebase.

The repository's merge metadoc already defines a future-base message, priority, current base, merge source, provenance references, merge count, and rebase qualification threshold. fileciteturn34file0

The native merge implementation validates the existence of its principal base/source/future-message/parent fields and derives rebase qualification from the recorded merge count. fileciteturn33file0

## 12. Native Source Architecture

The policy is implemented as native source rather than shell wrappers. The repository contains C and C++ companions for the add, commit, and rebase policy layers, together with the merge C implementation and the common operation-logic layer.

The separate native-policy build entry point compiles the policy companions without replacing the upstream Git command implementations. The build architecture is deliberately incremental so that policy can be validated before being wired into the ordinary `builtin/*.c` command paths.

## 13. Design Principle

The resulting system is intentionally two-layered:

```text
                 Git native state
                       |
        +--------------+--------------+
        |                             |
   object/graph                  author/time
   correctness                   provenance
        |                             |
        +--------------+--------------+
                       |
                 .logic record
                       |
          relevance + integration
          + operation relationships
                       |
                 .metadoc record
                       |
       scheduling + future posit + notation
```

The additional intelligence explains and records repository activity; it does not become an alternate object database.

## 14. Revision Status

This document records the current architectural revision. The policy foundations are present, but full command-path integration into `builtin/add.c`, `builtin/commit.c`, `builtin/merge.c`, and `builtin/rebase.c` remains a distinct implementation step. Until such integration is completed and tested, ordinary Git command behavior remains unchanged except for policy components already explicitly wired into native paths.
