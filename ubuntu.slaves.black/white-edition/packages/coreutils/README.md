# White Edition — `coreutils`

**Status:** W1 — Clean integration

`coreutils` supplies fundamental userland utilities. White Edition should preserve their established command-line contracts and concentrate on reproducibility, diagnostics, packaging, and integration.

## Objectives

- Preserve GNU/coreutils command semantics and scripting compatibility.
- Keep utilities predictable across clean and configured environments.
- Record locale, filesystem, and environment assumptions that materially affect behavior.
- Prefer upstream-tested behavior over local reimplementation.
- Keep any native C changes narrowly scoped and independently testable.

## Native implementation

Coreutils is primarily C. Any White Edition `.c` patch must identify the exact behavior being corrected or improved, include a regression test, and avoid gratuitous API or command-line changes.

## Evidence

- upstream test suite;
- clean-environment smoke tests;
- representative filesystem tests;
- permission/error-path tests;
- locale-sensitive behavior review;
- package upgrade compatibility test.

## Economy

Record installed footprint, process startup cost, and any measurable change in runtime behavior. Fundamental utilities should remain lightweight and dependable.

**Stewardship:** Max Rupplin — MEARVK LLC
