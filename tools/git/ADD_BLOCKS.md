# Native `git add` block planning

## Presumed method

The Ubuntu Determinant Git method now reserves a native planning model for `add` in which staged work is considered in deterministic **100 MiB blocks**.

The intended traversal is breadth-first and alphabetical by Git pathname (`a` through `z`, with the complete pathname used for deterministic ordering). The planner considers the index/worktree candidates as a set, walks that set in pathname order, and accumulates object-byte estimates until the next path would cross the 100 MiB boundary.

A path is an indivisible planning unit. The presumed method does **not** split a file merely because it crosses a block boundary. An individual object larger than 100 MiB must therefore be reported as an oversize item for the eventual native implementation rather than silently fragmented.

## Relationship to commit and push

The existing commit planning method uses 50 MiB units. The add planner uses 100 MiB units, so a normal 200 MiB push budget corresponds to **two add blocks**:

| Operation | Presumed unit |
|---|---:|
| `add` block | 100 MiB |
| `add` blocks per 200 MiB push budget | 2 |
| `commit` unit | 50 MiB |
| 200 MiB push budget | 4 × 50 MiB |

These are planning boundaries, not claims about Git's wire-format pack size. The eventual push guard remains authoritative and must recalculate actual reachable object usage before permitting a push.

## Native implementation contract

This policy is deliberately represented in C source (`git/add-budget.h`) rather than a shell wrapper. The current change establishes the constants, data structure, and boundary primitive so that `builtin/add.c` can subsequently adopt the policy without changing ordinary Git behavior prematurely.

The eventual implementation should:

1. preserve ordinary `git add` behavior unless the new intelligent mode is explicitly selected;
2. enumerate candidates deterministically;
3. order paths breadth-first using Git's pathname ordering;
4. accumulate actual Git object accounting rather than trusting working-tree file length alone;
5. close a block before adding the next path when that path would cross 100 MiB;
6. record block membership so later commit/push planning can reason about the same units;
7. treat the recorded plan as advisory metadata, never as authority capable of bypassing the 200 MiB push guard.

The integer/block semantics are therefore **presumed now in the source architecture**, while the final `builtin/add.c` behavior remains a subsequent integration step.
