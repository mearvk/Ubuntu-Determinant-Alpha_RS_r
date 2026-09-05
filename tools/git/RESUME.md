# Native resumable commit/push method

Slow or lossy connections are a normal operating condition, not an exception.
A push effort that fits the native **200 MiB** ceiling can still be cut off
part way through transfer. The `resume` policy layers a deterministic
**checkpoint/resume** model over the ordered 50 MiB commit units so an
interrupted effort continues from the last acknowledged unit instead of
restarting from zero.

It supplements, and never weakens, the two authoritative policies:

| Policy | Source | Boundary |
|---|---|---:|
| commit units | `git/commit-budget.h` | 50 MiB per unit |
| push ceiling | `git/push-budget.h` | 200 MiB (4 units) per transaction |
| resume layer | `git/resume-budget.h` | checkpoint over the ordered units |

## Model

An effort is the ordered set of 50 MiB commit units produced by the commit-part
planner. It is transferred as one or more push transactions of at most four
units (200 MiB). A **checkpoint** records how many leading units the remote has
**acknowledged** — never how many were merely attempted.

| Field | Meaning |
|---|---|
| `total_units` | ordered 50 MiB units in the effort |
| `acked_units` | leading units confirmed present on the remote |
| `attempt` | 1-based attempt counter |
| `max_attempts` | retry ceiling (0 = unlimited by policy) |
| `effort_id` | stable id correlating attempts |
| `last_acked_tip` | last unit tip the remote acknowledged |
| `state` | `pending` / `partial` / `complete` / `halt` |

## Attempt lifecycle

1. **Begin** an attempt: the plan asks for the remaining units capped at the
   200 MiB transaction size, starting at the first unacknowledged unit.
2. **Transfer** happens through ordinary Git push; the native push guard
   re-measures the real reachable object graph and re-enforces the 200 MiB
   ceiling for *this* attempt.
3. **Record the outcome**: the remote acknowledges some number of units. On a
   lossy link this may be fewer than requested, including zero.
   - The acknowledged count may only move forward; regression is rejected.
   - If all units are acknowledged, the effort is `complete`.
   - If units remain and retries remain, the effort is `partial` and the next
     attempt resumes at the first unacknowledged unit.
   - If units remain but retries are exhausted, the effort **halts** rather
     than looping.

Because each resumed attempt restarts at an ordered unit boundary and Git
transfers whole objects, an interrupted transfer never leaves a partially
written object on the remote: only fully acknowledged units advance the
checkpoint.

## Safety rules

- The checkpoint is **advisory transport bookkeeping**. It can never authorize
  an oversized transfer, and a stale or altered checkpoint never bypasses the
  200 MiB guard or ordinary Git negotiation.
- Interruption is treated as normal. The policy retries the remaining units; it
  does **not** weaken the 200 MiB ceiling to make a transfer fit.
- Counters reject integer overflow rather than wrapping, consistent with the
  rest of the native method.
- Provenance (author, committer, date, timestamp, parent object, and the effort
  correlation id) is preserved across attempts.

## Native implementation contract

The policy lives in native source — `git/resume-budget.h` with C and C++
companions `git/resume-budget.c` and `git/resume-budget.cpp` — rather than a
shell wrapper. The current change establishes the checkpoint structure, the
attempt lifecycle (`init` / `begin_attempt` / `record_outcome`), the resume
arithmetic, and overflow/regression rejection.

The eventual implementation should:

1. leave ordinary `git commit` and `git push` behavior unchanged unless the
   resumable form is deliberately selected;
2. derive units from the existing commit-part planner and transactions from the
   existing 200 MiB push budget;
3. advance the checkpoint only on remote acknowledgement;
4. resume at the first unacknowledged unit after a lossy interruption;
5. re-run the authoritative push guard on every attempt;
6. halt — never loop — when retries are exhausted with work remaining;
7. treat the checkpoint as advisory metadata that never bypasses the transport
   ceiling.

The shell surface exposes the behavior through
`git-workflow.sh push-resume [repo] [remote] [branch] [--attempts N]`, which
retries the still-unacknowledged remainder of a push across a lossy connection
without weakening the native ceiling.
