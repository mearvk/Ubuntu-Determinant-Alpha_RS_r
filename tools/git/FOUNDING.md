# FOUNDING — Vendored Git Source

**Project:** Ubuntu Determinant
**Edition:** Ubuntu White Edition
**Project attention:** Max Rupplin — MEARVK LLC — 2026
**Status:** Founding note for a vendored third-party source tree

---

## 1. Purpose

This document founds the repository's relationship to the **Git** version-control
source vendored under [`tools/git/git/`](git/). It exists so that the working
experience around this source stays **clean, honest, and continuable**: clean in
that the source is a faithful, unmodified upstream snapshot; honest in that the
repository claims no upstream authorship; and continuable in that any future
maintainer can re-derive, re-verify, and re-sync the tree without guesswork.

The aim is a durable home for the software craft this project depends on — the
continuance of the work, not a fork of it.

## 2. What is vendored

The directory [`tools/git/git/`](git/) holds a source snapshot of the official
Git project.

```text
Upstream:        https://github.com/git/git
Release marker:  v2.55.GIT
Snapshot commit: c73e85354c275c9d409b26445089bc16940fc527
Acquisition:     git clone --depth 1  (see tools/git/pull-source.sh)
```

The exact upstream commit is recorded for provenance in
[`git/.source-commit`](git/.source-commit). That file is the authoritative
record of which upstream state this snapshot corresponds to.

## 3. What this is, and what it is not

This is a **flattened source snapshot**, acquired for local build and
source-management work in the Ubuntu Determinant environment. It is deliberately
**not** a fork, and it is **not** an upstream mirror with live history.

Two intentional differences from a raw upstream checkout are recorded here so
they never read as accidents:

- The repository-local helper [`git/commit.sh`](git/commit.sh) is **preserved**.
  It is project tooling, not upstream Git, and it batches source additions under
  a size budget for this repository's storage workflow.
- Upstream `.gitmodules` and the unpopulated `sha1collisiondetection` submodule
  are **omitted**. In a flattened snapshot a dangling submodule reference would
  be misleading; the SHA-1 collision-detection sources that Git actually builds
  against remain present under `git/sha1dc/`.

## 4. Attribution and authorship boundary

> **Attribution boundary:** This repository does **not** claim authorship of
> Git. Git is substantial third-party software with a large contributor
> community spanning decades. The copyright and license notices inside the
> source tree remain authoritative.

Git was originally created by **Linus Torvalds** in 2005 and has since been
maintained by a broad community, with **Junio C Hamano** as the long-standing
maintainer. This note records that lineage as context, not as a merged or
re-attributed claim, and it deliberately invents no biographical, evaluative, or
economic detail about individual contributors.

## 5. License

Git is distributed under the **GNU General Public License, version 2**. The
authoritative license text ships with the snapshot at [`git/COPYING`](git/COPYING),
alongside the LGPL text upstream includes for the portions covered by it. Nothing
in this founding note modifies, narrows, or extends those terms. Use of the
vendored source is governed by the upstream license, not by this document.

## 6. Continuance — re-acquiring and re-verifying the source

The working experience should remain reproducible by any future maintainer. To
re-acquire the upstream source cleanly, use the repository's generic helper:

```sh
./tools/git/pull-source.sh https://github.com/git/git.git /path/to/source
```

To confirm that the vendored tree still corresponds to a known upstream state,
compare against the recorded provenance:

```sh
cat tools/git/git/.source-commit
```

When advancing to a newer upstream release, update the snapshot, refresh
`git/.source-commit` with the new upstream commit, and update the release marker
and commit fields in Section 2 of this note so the record stays truthful.

## 7. Repository policy

This vendored source is **infrastructure, not application source**. It should
remain independent of GNOME, MATE, Ubuntu White Edition, and individual upstream
projects so it can be reused by the ISO build system, mirroring the policy stated
in [`tools/git/README.md`](README.md).

Local build output must not be written into the source directory; follow Git's
own guidance and build from a separate directory so the snapshot stays pristine
and re-verifiable.
