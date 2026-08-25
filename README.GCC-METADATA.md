# GCC Metadata Integration — README Addition

The repository's GCC 16.2.0 source snapshot now carries an additive MEARVK metadata integration for C and C++ build testing.

The integration defines a versioned `MEARVK-META` record containing compiler identity and explicitly supplied edition, version, company, creation-date, fiduciary, authority, and source fields. It is designed for inspection by `limit`, XMC, and ASYSMA tooling.

The current source components are under `tools/gcc/gcc-16.2.0/gcc/`:

- `mearvk-metadata.h`
- `mearvk-metadata.cc`
- `mearvk-metadata-plugin.cc`
- `mearvk-metadata-test.c`
- `mearvk-metadata-test.cc`

The target native representation is `.note.mearvk.metadata` for supported object/executable formats. The plugin-stage implementation deliberately emits a sidecar record first, allowing a locally built GCC to validate the schema before target-specific assembler/linker emission is enabled universally.

GCC upstream attribution and licensing remain authoritative. MEARVK integration metadata is not a replacement for GCC's copyright, contributor, maintainer, or license records.

See `tools/gcc/gcc-16.2.0/MEARVK-METADATA.md` and `markdown/GCC-METADATA-1-2-3-4-2026-08-25.mmd` for the implementation and 1-2-3-4 record.
