# DEFINITIONS

**Project:** Ubuntu Determinant
**Edition:** Ubuntu White Edition
**Project attention:** Max Rupplin — MEARVK LLC — 2026
**Status:** Glossary for the vendored-source documentation set

---

## 1. Purpose

This glossary defines terms used across the documentation authored for the
vendored Git source and its governing records:

- [`tools/git/FOUNDING.md`](tools/git/FOUNDING.md) — founding note for the source.
- [`MODIFICATIONS.md`](MODIFICATIONS.md) — record of deviations from upstream.
- [`HEADINGS.md`](HEADINGS.md) — attribution standard for new code.
- [`tools/git/EXPLANATIONS.md`](tools/git/EXPLANATIONS.md) — the Git command set.

It defines terms that carry a specific meaning in this repository so the working
experience stays clear and continuable. Where a term is Git's own or industry
standard, the definition notes that and does not redefine it.

Terms are grouped by topic; within each group they are alphabetical.

## 2. Documentation artifacts

**DEFINITIONS (this document).** The glossary of terms used by the vendored-source
documentation set.

**EXPLANATIONS.** The reference that documents the Git command (method) set:
every command with its invocation, importance rating, classification, and
purpose. See [`tools/git/EXPLANATIONS.md`](tools/git/EXPLANATIONS.md).

**FOUNDING note.** A document that founds the repository's relationship to a
vendored third-party source tree: what is vendored, its provenance, what is and
is not modified, its license, and how to re-acquire it. See
[`tools/git/FOUNDING.md`](tools/git/FOUNDING.md).

**HEADINGS.** The standard establishing that new code authored for this
repository is the work of *Max Rupplin — MEARVK LLC — 2026*, with the per-file
heading forms to apply. See [`HEADINGS.md`](HEADINGS.md).

**MODIFICATIONS record.** The repository-wide record of how each vendored source
tree differs from its upstream original, under the headings Additions,
Omissions, and Alterations. See [`MODIFICATIONS.md`](MODIFICATIONS.md).

## 3. Vendoring, provenance, and source management

**Acquisition.** The command and method by which a vendored tree was obtained
(for the Git source: `git clone --depth 1` via `tools/git/pull-source.sh`).

**Additions.** In the modification record, repository-local files placed
alongside upstream source (for example `commit.sh` and `.source-commit`). They
are project files, not upstream ones.

**Alterations.** In the modification record, edits made to upstream source files
themselves. "None" means the upstream files are byte-faithful to the recorded
snapshot commit.

**Faithful (byte-faithful).** Identical to the upstream source at the recorded
snapshot commit, with no content edits. The Git source under `tools/git/git/` is
faithful except for the documented Additions and Omissions.

**Flattened source snapshot.** A copy of upstream source at one point in time,
stored as ordinary files without upstream Git history, submodule gitlinks, or a
live `.git` database. It is a snapshot for local use, not a fork or a mirror.

**Fork.** A copy of a project intended to diverge from and evolve independently
of its upstream. The vendored Git source is explicitly **not** a fork.

**Gitlink.** A Git index entry that records a submodule as a single commit
reference rather than as files. A gitlink with no populated submodule content is
a *dangling* reference; the modification record omits such references
deliberately.

**Mirror.** A copy that tracks upstream's live history and refs. The vendored Git
source is **not** a mirror; it is a single snapshot.

**Omissions.** In the modification record, upstream files intentionally left out
of the snapshot (for the Git source: `.gitmodules` and the unpopulated
`sha1collisiondetection` submodule).

**Provenance.** The recorded origin of vendored source: the upstream repository,
release marker, and exact snapshot commit, stored authoritatively in
[`tools/git/git/.source-commit`](tools/git/git/.source-commit).

**Release marker.** The upstream version label a snapshot corresponds to (for the
current Git source, `v2.55.GIT`). Paired with the snapshot commit for precision.

**Re-verify.** To confirm a vendored tree still corresponds to a known upstream
state by comparing it against the recorded provenance.

**Snapshot commit.** The exact upstream commit hash a snapshot was taken from
(currently `c73e85354c275c9d409b26445089bc16940fc527`). The authoritative
pointer to "which upstream state this is."

**Vendored source.** Third-party source code copied into this repository for
local build and source-management use, kept distinct from application source and
governed by a founding note and the modification record.

## 4. Attribution and authorship

**Attribution boundary.** The explicit statement that this repository does **not**
claim authorship of vendored third-party software; upstream copyright and license
notices inside the source tree remain authoritative.

**Attribution line.** The canonical single line identifying new project work:
`Max Rupplin — MEARVK LLC — 2026`. Defined in [`HEADINGS.md`](HEADINGS.md).

**New (project-authored) code.** Files created for this repository as part of
Ubuntu Determinant, which carry the project heading. Distinct from vendored
upstream files, whose original notices are never overwritten or re-attributed.

**Re-attribution.** Reassigning authorship of existing work. Upstream authorship
is never re-attributed to the project.

## 5. Project framing terms used by these documents

These are the wider repository's own terms, defined here only as used by the
vendored-source documentation. The authoritative definitions live in the project
root [`README.md`](README.md).

**Continuable / continuance.** The property that work can be reproduced,
re-verified, advanced, and maintained by a future maintainer without guesswork.
A stated aim of the founding note and this glossary.

**Infrastructure, not application source.** Repository policy classifying the
Git tooling and vendored source as reusable build/tooling infrastructure that
stays independent of GNOME, MATE, Ubuntu White Edition, and individual upstream
projects, so it can be reused by the ISO build system.

**Software art.** The project's framing for the craft embodied in the source it
depends on; the founding note aims to give that work a clean, durable home.

**Ubuntu Determinant / Ubuntu White Edition.** The project and edition names that
appear in every document header. Used here as identifiers; see the project
`README.md` for their full meaning.

## 6. Git command-classification terms

Git classifies its own commands in `tools/git/git/command-list.txt`. These
definitions summarize that classification as used by
[`tools/git/EXPLANATIONS.md`](tools/git/EXPLANATIONS.md); Git's documentation is
authoritative.

**Ancillary command.** A user-facing command that is not part of the everyday
core — configuration, inspection, or maintenance. Git splits these into
*ancillary interrogators* (read/report) and *ancillary manipulators* (change
state). Example: `git config`, `git fsck`.

**Classification.** Git's own category for a command, taken from
`command-list.txt`. Used in EXPLANATIONS as a principled, non-arbitrary basis for
the importance rating.

**Command (method).** An invocable Git operation — the `git <verb>` surface a
user or script calls. In EXPLANATIONS, "method set" means this command surface,
not Git's internal C functions.

**Foreign SCM interface.** A command that bridges Git with another
source-control system (for example `git svn`, `git p4`, `git cvsimport`).

**Importance rating (1–10).** The EXPLANATIONS score, where 10 is most important;
derived from Git's classification and typical usage frequency, not a judgment of
engineering quality. See EXPLANATIONS Section 3 for the full scale.

**Interrogator.** A command that reads and reports repository state without
changing it.

**Main porcelain.** Git's term for the high-level, user-facing commands that make
up the everyday working experience (for example `git add`, `git commit`,
`git log`). Contrasted with plumbing.

**Manipulator.** A command that changes repository state.

**NAME line.** The one-line purpose of a command, taken verbatim from the `NAME`
section of its upstream manual page in `tools/git/git/Documentation/`. Used as
the "Purpose" column in EXPLANATIONS.

**Plumbing.** Git's term for low-level building-block commands used by scripts,
tools, and porcelain internals (for example `git cat-file`, `git rev-parse`).
Split into *plumbing interrogators* and *plumbing manipulators*.

**Porcelain.** The user-facing command layer built on top of plumbing. Git's
standard term for its high-level commands.

**Pure helper.** An internal scriptlet or helper not normally invoked directly by
users (for example `git sh-setup`, `git mailsplit`).

**Synchronization command / helper.** Transport-layer commands that move objects
between repositories, usually invoked indirectly by fetch/push (for example
`git upload-pack`, `git receive-pack`, `git daemon`).

## 7. Continuance

When new documents or vendored trees are added, extend this glossary with any
term that carries a repository-specific meaning, keeping each group alphabetical.
This document is authored for this repository under the attribution defined in
[`HEADINGS.md`](HEADINGS.md).
