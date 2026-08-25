# MEARVK GCC Output Metadata

## Purpose

This directory carries an additive metadata integration for the GCC 16.2.0 source snapshot. It is intended to give C and C++ builds a stable, machine-readable description of the build identity without replacing GCC's upstream provenance or licensing.

## Metadata schema

The current schema is `1` and uses a conservative newline-delimited record:

```text
MEARVK-META
schema=1
compiler=gcc
compiler_version=16.2.0
language=c-or-c++
edition=...
version=...
company=...
creation_date=...
fiduciary=...
authority=...
source=...
```

Fields describing an organization, fiduciary relationship, authority, or edition are not invented by the compiler. They are supplied by the build environment or explicit integration configuration.

## Source components

- `gcc/mearvk-metadata.h` — C ABI for the metadata emitter.
- `gcc/mearvk-metadata.cc` — C++ implementation shared by the compiler integration.
- `gcc/mearvk-metadata-plugin.cc` — GCC plugin reference implementation for C/C++ build testing.
- `gcc/mearvk-metadata-test.c` — C smoke input.
- `gcc/mearvk-metadata-test.cc` — C++ smoke input.

The implementation deliberately validates metadata values against control characters before writing records.

## Output direction

The long-term native output is a dedicated executable/object metadata section named `.note.mearvk.metadata` on formats that support an appropriate note/section representation. The current plugin is the safe test-stage implementation: it emits a deterministic sidecar record when `MEARVK_METADATA_OUTPUT` is supplied. This permits validation before changing every GCC target's assembler/linker emission path.

## C and C++

Both C and C++ are covered by the same metadata schema. The smoke tests are intentionally small so a locally built GCC can verify the integration independently of the GCC source tree's much larger test suite.

## Provenance and licensing

GCC's upstream copyright, contributor notices, `MAINTAINERS`, `COPYING`, `COPYING3`, `COPYING.LIB`, and `COPYING.RUNTIME` remain authoritative. MEARVK's metadata code is an additive repository integration and does not claim ownership of GCC or its upstream contributors.
