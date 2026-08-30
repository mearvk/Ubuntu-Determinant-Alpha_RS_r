# MODIFICATIONS

**Project:** Ubuntu Determinant
**Edition:** Ubuntu White Edition
**Project attention:** Max Rupplin — MEARVK LLC — 2026
**Status:** Repository-wide record of modifications to vendored third-party source

---

## 1. Purpose

This document records how the repository's vendored third-party source trees
differ from their upstream originals. It exists so the working experience stays
**honest and continuable**: every deviation from an upstream snapshot is written
down here rather than discovered later by inspection.

Two boundaries govern this record:

- **Upstream source is not silently altered.** Where a vendored tree is meant to
  be a faithful snapshot, that intent is stated and any exception is listed
  explicitly below.
- **New work is attributed to this project**, per [`HEADINGS.md`](HEADINGS.md).
  Third-party upstream authorship is never re-attributed.

## 2. How to read this record

Each vendored tree lists its modifications under three headings:

- **Additions** — repository-local files placed alongside upstream source.
- **Omissions** — upstream files intentionally left out of the snapshot.
- **Alterations** — edits to upstream source files themselves. "None" means the
  upstream files are byte-faithful to the recorded snapshot commit.

## 3. Vendored Git source — `tools/git/git/`

Founding note and provenance: [`tools/git/FOUNDING.md`](tools/git/FOUNDING.md).

```text
Upstream:        https://github.com/git/git
Release marker:  v2.55.GIT
Snapshot commit: c73e85354c275c9d409b26445089bc16940fc527
```

**Additions**

| Path | Origin | Purpose |
|---|---|---|
| `tools/git/git/commit.sh` | Ubuntu Determinant | Repository-local helper that batches source additions under a size budget for this repository's storage workflow. Not upstream Git. |
| `tools/git/git/.source-commit` | Ubuntu Determinant | Records the exact upstream commit this snapshot corresponds to, for provenance and re-verification. |

**Omissions**

| Path | Reason |
|---|---|
| `.gitmodules` | This is a flattened source snapshot, not a live checkout; a submodule reference with no populated gitlink would be misleading. |
| `sha1collisiondetection/` (submodule) | Left unpopulated. The SHA-1 collision-detection sources Git actually builds against remain present under `tools/git/git/sha1dc/`. |

**Alterations**

None. The upstream source files are faithful to snapshot commit
`c73e85354c275c9d409b26445089bc16940fc527`.

## 4. Adding to this record

When a vendored tree is introduced, updated, or changed:

1. Add or update its section here with Additions, Omissions, and Alterations.
2. If upstream source files are ever altered, record each altered path and the
   reason, and preserve the upstream license and copyright notices in place.
3. Keep the recorded snapshot commit and release marker truthful when advancing
   to a newer upstream release, mirroring the tree's founding note.

New files authored for this repository carry the attribution defined in
[`HEADINGS.md`](HEADINGS.md).
