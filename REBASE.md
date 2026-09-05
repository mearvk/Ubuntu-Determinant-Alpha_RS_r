# REBASE — Master Definitions

**Project:** Ubuntu Determinant
**Edition:** Ubuntu White Edition
**Project attention:** Max Rupplin — MEARVK LLC — 2026
**Status:** Master definitions document for *rebase* terms (open for definition)

---

## 1. Purpose

This is the master reference for **rebase** terminology as used in this
repository. It defines the terms, operations, and conventions the project
attaches to `git rebase` and related history-rewriting work, so usage stays
clear and consistent.

Terms are defined in §3. Where a term is Git's own standard term, the definition
notes that and points to the authoritative Git documentation rather than
redefining it; where the project attaches a specific meaning or convention, that
is stated explicitly.

Companion document: [`MERGE.md`](MERGE.md) (merge terminology). Related vendored
notes live under `tools/git/` (`REBASE_METADOC.md`, `REBASE_MERGE_METADOC.md`).

## 2. Scope

- **Applies to:** rebase operations on this repository's branches — interactive
  rebase, message rewording, squashing/fixup, and the force-with-lease push flow
  that follows history rewrites (see `scripts/science-commit-reword.sh`).
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

### Rebase

**Kind:** Project-specific (see also the Git-standard meaning noted below)

**Definition (project).** *Rebase* shall mean that a **major contributor** has
**touched the domain**, and that the act carries that contributor's **will** —
their **experience** and **expertise**. In this project sense, to rebase is not a
mere mechanical replay of commits: it is the deliberate act by which a recognised
major contributor applies their judgement over a domain, and their will
(experience + expertise) becomes bound into the resulting history.

**Constituent terms.**
- **Major contributor** — a contributor of recognised standing over the domain,
  whose involvement is significant rather than incidental.
- **Touched (the) domain** — has directly worked within / acted upon the subject
  area (the "domain").
- **Will** — the contributor's deliberate intent, here defined as the union of
  **experience** and **expertise**.
- **Experience** — accumulated, demonstrated practice over time.
- **Expertise** — depth of skill and authoritative knowledge in the domain.

**The graph (careful reading).** Rebase = a major contributor whose will
(experience + expertise) has touched the domain, yielding the rebased result:

```text
                          ┌─────────────────────────────┐
                          │        MAJOR CONTRIBUTOR      │
                          │      (recognised standing)     │
                          └───────────────┬───────────────┘
                                          │ possesses
                                          ▼
                                 ┌──────────────────┐
                                 │       WILL       │
                                 │  = the union of  │
                                 └───┬──────────┬───┘
                          composed of │          │ composed of
                                      ▼          ▼
                            ┌────────────┐  ┌────────────┐
                            │ EXPERIENCE │  │ EXPERTISE  │
                            │ (practice  │  │ (depth of  │
                            │  over time)│  │  skill)    │
                            └──────┬─────┘  └─────┬──────┘
                                   └──────┬───────┘
                                          │ applied — "touches"
                                          ▼
                                   ┌──────────────┐
                                   │    DOMAIN     │
                                   │ (subject area)│
                                   └──────┬───────┘
                                          │ the touching yields
                                          ▼
                                 ┌───────────────────┐
                                 │   REBASE (result)  │
                                 │  domain touched by │
                                 │  contributor's will│
                                 └───────────────────┘
```

Read as a single relation:

```text
REBASE  ⇐  MAJOR_CONTRIBUTOR . WILL( EXPERIENCE ∧ EXPERTISE )  →  TOUCHES( DOMAIN )
```

- Nodes = the constituent terms above.
- `possesses` / `composed of` = definitional (what the thing *is*).
- `applied — "touches"` = the act (the contributor's will acting on the domain).
- `yields` = the outcome edge producing the rebased result.

**Notes / usage.** This is the project's meaning of the word within this
repository's documents. It is a *conceptual/authorship* definition, distinct from
the mechanical Git operation.

**Git-standard meaning (for contrast, not overridden here).** In Git,
`git rebase` reapplies commits from one base onto another, producing new commits
(new SHAs) — the operation used by `scripts/science-commit-reword.sh`. The
project definition above concerns *who and what* stands behind such an act
(a major contributor's will over the domain), not the plumbing.

**See also:** MERGE.md; `tools/git/REBASE_METADOC.md`; `scripts/science-commit-reword.sh`

## 4. Conventions (to be defined)

_Project conventions for when/how rebase is used (e.g. reword policy, force-push
rules, backup refs) will be recorded here._

---

*Master definitions document. Terms are added and maintained here.
Max Rupplin — MEARVK LLC — 2026.*
