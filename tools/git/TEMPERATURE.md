# Native `temperature` AI module

`temperature` is a read-only advisory AI module. It scans the repository for
projects (subtrees) that were started and may since have been left alone, and
reports which ones could still be **improved** or **recandled** (revived).

The metaphor is thermal. A project with recent activity is **warm**; one that
has gone quiet is **cold**. A cold project that is nonetheless important and
improvable is the strongest recandle candidate — the cooled-down work most
worth relighting.

The module is advisory only: it never stages, commits, pushes, or rewrites
anything, and its scores never gate any Git operation. Scores are deterministic
given the same inputs and are explicitly **not** derived from author identity,
appearance, credentials, or IQ — only from observable project signals.

## Thermal bands

Each scanned project is placed in a band by how long it has been idle:

| Band | Idle age | Meaning |
|---|---:|---|
| `hot` | ≤ 14 days | actively worked |
| `warm` | ≤ 60 days | recently touched |
| `cool` | ≤ 180 days | idle a while |
| `cold` | > 180 days | long idle; likely abandoned |

## The three learner strips

Every project is summarized by three labeled 0..100 gauges ("strips"):

| Strip | Name | What it shows |
|---|---|---|
| 1 | **quality & intention** | how good and how deliberate the project looks — structure, docs, tests, coherent intent |
| 2 | **relative importance** | how much the project matters relative to the rest of the repository |
| 3 | **total achievable value** | the value unlockable by fully improving it |

Strip 3 is a *derived* relationship, not an independent input. It is the
improvement **headroom over current quality**, scaled by importance:

```
achievable_value = (100 - quality_intention) * relative_importance / 100
```

So a project that is already excellent (quality ≈ 100) has almost no achievable
value left to unlock, while an important project of low quality has a lot. This
is the module's headline idea: **total value = total improvement measured over
total quality.**

## Recandle candidates

A project is flagged for recandling when all of the following hold:

- it has gone **cold or cool** (idle), and
- **relative importance ≥ 40**, and
- **achievable value ≥ 40**.

That combination identifies idle work that is both important and has real room
to grow — the projects most worth relighting.

## Repository totals

Across the scanned set, `temperature` reports the **total achievable value**
against the **total current quality**. This expresses, at the repository level,
how much total improvement is unlocked relative to how much quality already
exists. Both sums reject integer overflow rather than wrapping.

## Native implementation

The policy lives in native source — `git/temperature.h` with C and C++
companions `git/temperature.c` and `git/temperature.cpp`. It establishes the
0..100 strip scale, the band constants and mapping, the strip-3 derivation, the
recandle predicate, `git_temperature_assess()` (assess one project), and
`git_temperature_totals()` (aggregate value/quality/recandle counts, overflow
checked).

The shell surface exposes the scan through:

```
git-workflow.sh temperature [repo] [--recandle] [--min-idle DAYS]
```

which walks the repository's project subtrees, derives each project's idle age
and signals from Git history, prints the three strips per project (with the
thermal band and a recandle marker), and closes with the repository totals.
`--recandle` limits the listing to recandle candidates; `--min-idle DAYS`
restricts the scan to projects idle at least that long. The strip inputs the
shell derives (quality/intention and importance) are heuristic, observable
signals; the native structures remain the contract a later builtin can adopt.
