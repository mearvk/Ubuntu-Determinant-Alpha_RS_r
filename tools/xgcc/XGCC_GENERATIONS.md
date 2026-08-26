# XGCC Generations

**Author:** Max Rupplin - MEARVK LLC 2026

This document defines the initial future-generation compile-roll for XGCC. These generations are intentionally conservative: they add inspection, an `.xobj` flow, and reproducible metadata without replacing XGCC's existing execution environment.

## xgcc-1 — Preflight

`xgcc-1 source.c` performs a bounded source read, identifies C/C++, checks basic delimiter balance, and reports whether the source is suitable for the next stage. It does not execute the source.

## xgcc-2 — XOBJ

`xgcc-2 source.c [output.xobj]` creates an XGCC `.xobj` source-package artifact. The first format is deliberately simple and inspectable. It is a transport/package boundary, not a claim that the source has already been converted to native machine code.

## xgcc-3 — Manifest

`xgcc-3 source.c [manifest.json]` records deterministic build metadata for the source input. The initial implementation records the format, author, source name, size, and the fact that execution was not performed.

## Future generations

Later generations can add dependency graphs, a common intermediate representation, static analysis, deterministic caching, native backends, JIT compilation, and stronger provenance. Those capabilities should be added only after their functional contracts are reviewed.

## Relationship to GCC

XGCC remains an execution-oriented environment. GCC remains an optional conventional native compiler backend. XGCC generation tools must not silently substitute GCC execution for XGCC execution.
