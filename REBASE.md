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

**Kind:** Git-standard
**Definition:** _TBD — to be defined._
**Notes / usage:** _TBD._
**See also:** MERGE.md

## 4. Conventions (to be defined)

_Project conventions for when/how rebase is used (e.g. reword policy, force-push
rules, backup refs) will be recorded here._

---

*Master definitions document. Terms are added and maintained here.
Max Rupplin — MEARVK LLC — 2026.*
