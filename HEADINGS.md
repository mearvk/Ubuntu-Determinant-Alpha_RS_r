# HEADINGS

**Project:** Ubuntu Determinant
**Edition:** Ubuntu White Edition
**Project attention:** Max Rupplin — MEARVK LLC — 2026
**Status:** Attribution and file-heading standard for new code

---

## 1. Purpose

This document establishes the attribution standard for **new code authored for
this repository**. New source files created by the project are the work of:

> **Max Rupplin — MEARVK LLC — 2026**

The standard exists so authorship is clear, consistent, and continuable across
the repository's own software art, without ever overwriting or re-attributing
third-party upstream work.

## 2. Scope

- **Applies to** new files authored for this repository: project source,
  scripts, tooling, and documentation created as part of Ubuntu Determinant.
- **Does not apply to** vendored third-party source (for example, the Git tree
  under `tools/git/git/` or the GCC tree under `tools/gcc/`). Upstream files keep
  their own headers, copyright notices, and licenses unchanged. Deviations from
  upstream are recorded in [`MODIFICATIONS.md`](MODIFICATIONS.md), and vendored
  provenance is recorded in each tree's founding note.

When in doubt, a file is third-party if it originated upstream and project-new if
it was authored here.

## 3. Canonical attribution line

New files use this single-line attribution:

```text
Max Rupplin — MEARVK LLC — 2026
```

## 4. Heading forms by file type

Apply the comment style native to each file type. The wording is identical; only
the comment syntax changes.

**C / C++ / Java / Rust / other C-style (`.c`, `.h`, `.cc`, `.java`, `.rs`)**

```c
/*
 * Ubuntu Determinant — Ubuntu White Edition
 * Max Rupplin — MEARVK LLC — 2026
 */
```

**Shell / scripts / config with `#` comments (`.sh`, `.py`, `Makefile`, `.yml`)**

```sh
# Ubuntu Determinant — Ubuntu White Edition
# Max Rupplin — MEARVK LLC — 2026
```

For shell scripts, the heading follows the shebang line:

```sh
#!/usr/bin/env bash
# Ubuntu Determinant — Ubuntu White Edition
# Max Rupplin — MEARVK LLC — 2026
```

**Markdown / documentation (`.md`)**

Documentation uses the project header block already established across the
repository:

```markdown
**Project:** Ubuntu Determinant
**Edition:** Ubuntu White Edition
**Project attention:** Max Rupplin — MEARVK LLC — 2026
```

## 5. Rules

1. Do not add project headings to vendored upstream files. Their notices are
   authoritative and remain in place.
2. Do not remove or rewrite upstream copyright or license notices.
3. Keep the attribution line exactly as written in Section 3 so it stays
   greppable across the tree.
4. New files created under this repository should carry the appropriate heading
   from Section 4 at creation time.

## 6. Continuance

This standard is meant to endure. When authorship details or the working year
change for future work, update Section 1 and Section 3 so the record stays
truthful, and apply the current heading to files authored from that point
forward. Files already carrying a prior year's heading are left as authored;
this document is not a license to rewrite history.
