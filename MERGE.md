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

**Kind:** Git-standard
**Definition:** _TBD — to be defined._
**Notes / usage:** _TBD._
**See also:** REBASE.md

## 4. Conventions (to be defined)

_Project conventions for when/how merge is used (e.g. merge vs. rebase policy,
PR merge method, base branch) will be recorded here._

---

*Master definitions document. Terms are added and maintained here.
Max Rupplin — MEARVK LLC — 2026.*
