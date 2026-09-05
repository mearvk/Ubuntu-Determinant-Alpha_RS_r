# MERGE — Master Definitions

**Project:** Ubuntu Determinant
**Edition:** Ubuntu White Edition
**Project attention:** Max Rupplin — MEARVK LLC — 2026
**Status:** Master definitions document for *merge* terms (open for definition)

---

## 1. Purpose

This is the master reference for **merge** terminology as used in this
repository. It defines the terms, operations, and conventions the project
attaches to `git merge`, pull-request merges, and related integration work, so
usage stays clear and consistent.

Terms are defined in §3. Where a term is Git's own standard term, the definition
notes that and points to the authoritative Git documentation rather than
redefining it; where the project attaches a specific meaning or convention, that
is stated explicitly.

Companion document: [`REBASE.md`](REBASE.md) (rebase terminology). Related
vendored notes live under `tools/git/` (`REBASE_MERGE_METADOC.md`).

## 2. Scope

- **Applies to:** merge operations on this repository — fast-forward and
  three-way merges, merge commits, PR merges (as used across PRs #39+), conflict
  resolution, and the ff-only sync flow (see `tools/git/git-workflow.sh`).
- **Does not (re)define:** Git internals beyond what the project needs; consult
  official Git documentation for authoritative behavior.

## 3. Definitions

> This section is intentionally open. Add terms below, one subsection each, in
> the form shown by the template. Keep definitions clear, correct, and
> continuable; mark project-specific meaning distinctly from Git-standard meaning.

<!-- Template — copy per term:
### <Term>

**Kind:** Git-standard | Project-specific
**Definition:** <one or two sentences.>
**Notes / usage:** <how this project uses it, cautions, examples.>
**See also:** <related terms / files>
-->

### Merge

**Kind:** Project-specific (see also the Git-standard meaning noted below)

**Definition (project).** A *merge* shall be about **chapter and concordance**.
It shall be about a **devout** and a **chapel**. This shall be of a **student**
of a **following** of a **Law**. This serves **Law** and **prevariance**.

**Constituent terms.**
- **Chapter** — a bounded division of a work; a coherent unit brought together.
- **Concordance** — an ordered agreement/alignment across the text; the bringing
  of parts into accord (and an index of where terms concur).
- **Devout** — the disposition of earnest, faithful commitment held by the one
  who merges.
- **Chapel** — the place/setting of the devout act; the small sanctified space
  in which the joining is made.
- **Student** — one under formation; a learner within a tradition.
- **Following** — the tradition/lineage followed; adherence to a body of practice.
- **Law** — the governing rule the merge serves and answers to.
- **Prevariance** — *(project-coined term, recorded as given)* the quality this
  merge additionally serves alongside Law. **Note:** "prevariance" is not a
  standard English word; it is preserved verbatim as the author's term. It is
  *not* here treated as "prevarication" (evasion/falsehood); its meaning within
  this project is to be fixed by the author. Left open pending that fixing.

**The graph (careful reading).** A merge joins *chapter* and *concordance*,
performed by a *devout* in a *chapel*, who is a *student* of a *following* of a
*Law*, and the whole serves *Law* and *prevariance*:

```text
                 ┌───────────┐        ┌──────────────┐
                 │  CHAPTER   │◄──────►│ CONCORDANCE  │
                 │ (a unit)   │ accord │ (agreement)  │
                 └─────┬──────┘        └──────┬───────┘
                       └────────┬─────────────┘
                                │ joined in the act of
                                ▼
                        ┌───────────────┐   set in    ┌──────────┐
                        │     MERGE      │◄────────────│  CHAPEL  │
                        │ (the joining)  │  (place)    │ (setting)│
                        └───────┬───────┘             └────┬─────┘
                                ▲ performed by             │ where the
                                │                          ▼  devout acts
                        ┌───────┴────────┐          ┌──────────────┐
                        │     DEVOUT      │──────────│   (faithful  │
                        │ (faithful doer) │  is a    │  commitment) │
                        └───────┬────────┘          └──────────────┘
                                │ who is a
                                ▼
                        ┌───────────────┐   of a    ┌───────────────┐
                        │    STUDENT     │──────────►│   FOLLOWING    │
                        │ (in formation) │           │  (tradition)   │
                        └───────────────┘           └───────┬───────┘
                                                            │ of a
                                                            ▼
                                                     ┌────────────┐
                                                     │    LAW      │
                                                     └─────┬──────┘
                                                           │ the whole SERVES
                                          ┌────────────────┴───────────────┐
                                          ▼                                 ▼
                                   ┌────────────┐                   ┌──────────────┐
                                   │    LAW      │                   │ PREVARIANCE  │
                                   │ (governing) │                   │ (author term)│
                                   └────────────┘                   └──────────────┘
```

Read as a single relation:

```text
MERGE  ⇐  JOIN( CHAPTER , CONCORDANCE )  BY  DEVOUT@CHAPEL
          WHERE  DEVOUT = STUDENT( FOLLOWING( LAW ) )
          SERVES  { LAW , PREVARIANCE }
```

- Nodes = the constituent terms above.
- `accord` = chapter and concordance brought into agreement.
- `joined in the act of` / `performed by` / `set in` = the merge, its doer, its place.
- `who is a` / `of a` = the doer's formation (student → following → Law).
- `SERVES` = the twin ends the whole merge answers to (Law and prevariance).

**Notes / usage.** This is the project's meaning of the word within this
repository's documents — a *conceptual/authorship* definition, distinct from the
mechanical Git operation. The term **prevariance** is recorded verbatim as the
author's; its precise project meaning is left open for the author to fix.

**Git-standard meaning (for contrast, not overridden here).** In Git,
`git merge` joins two histories: a fast-forward advances the branch pointer when
possible, otherwise a three-way merge creates a merge commit with two parents.
This is the mechanism behind the PR merges used across this repository. The
project definition above concerns the *character and service* of a merge, not the
plumbing.

**See also:** REBASE.md; `tools/git/REBASE_MERGE_METADOC.md`; `tools/git/git-workflow.sh`

## 4. Conventions (to be defined)

_Project conventions for when/how merge is used (e.g. merge vs. rebase policy,
PR merge method, base branch) will be recorded here._

---

*Master definitions document. Terms are added and maintained here.
Max Rupplin — MEARVK LLC — 2026.*
