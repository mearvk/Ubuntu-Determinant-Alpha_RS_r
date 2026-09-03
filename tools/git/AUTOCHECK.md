# Native `autocheck` policy

`autocheck` is the systems-level preflight operation for synchronizing a local Git worktree with its remote and then preparing local work for the existing add/commit/merge/rebase/push policies.

## Standard sequence

1. Inspect the local worktree, index, current branch, and configured remote.
2. Pull remote changes before committing local work.
3. Preserve the original Git provenance: author, committer, dates, timestamps, parent objects, and relevant paths.
4. If remote and local histories conflict, select a deterministic resolution policy.
5. If the codebase is less than three months old, prefer **merge** when the graph permits it.
6. If the codebase is three months old or older, prefer **rebase** when the graph and repository policy permit it.
7. Do not guess through unresolved conflicts. `HALT` is the correct outcome when automatic resolution would be unsafe or ambiguous.
8. Add local changes using the established 100 MiB add blocks and deterministic pathname policy.
9. Commit local changes using the established 50 MiB logical commit units.
10. Prepare the resulting commits for push using the established 200 MiB conservative transport budget, in appropriate transactions.

## Conflict rule

The three-month rule is a **default selection heuristic**, not permission to overwrite source. A merge is preferred for an active codebase younger than 92 days; otherwise rebase is preferred. Existing merge/rebase metadata and explicit repository policy take precedence.

Automatic conflict resolution is limited to cases where Git can establish a safe result. Text conflicts, tree conflicts, index conflicts, or ambiguous history must remain visible and cause `autocheck` to halt rather than invent a resolution.

## Local changes

`autocheck` commits local changes after synchronization. It must not discard unstaged or staged work merely to make the pull succeed. The ordinary Git index remains authoritative for what is staged.

The add policy is breadth-first with deterministic Git pathname tie-breaking and 100 MiB logical blocks; individual files are not split. The commit policy uses 50 MiB logical units. Push remains bounded by the native 200 MiB conservative object-accounting rule.

## Operation logic

Each autocheck execution records its decision and provenance in the repository's `.logic` model, including:

- pull/synchronization state;
- local and remote base commits;
- conflict count and selected merge/rebase policy;
- relevant files and `TIER-1`/`TIER-2` markers;
- `PRIORI-INTEGRATION` inputs;
- add blocks and commit units selected;
- resulting commit object IDs;
- author, committer, date, and timestamp;
- the intended push transactions.

`autocheck` does not silently push. It prepares the resulting graph for the established push-size policy; an explicit push operation remains responsible for transport.

## Native implementation

`autocheck.h`, `autocheck.c`, and `autocheck.cpp` provide the native policy contract and C/C++ companions. They are intentionally separate from Git's ordinary builtin command paths until command registration and integration are completed and tested.
