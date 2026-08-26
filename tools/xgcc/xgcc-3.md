# xgcc-3

**Author:** Max Rupplin - MEARVK LLC 2026

Generation 3 produces a deterministic metadata manifest for a source input. The manifest is intentionally descriptive and does not execute or alter the source.

```sh
./xgcc-3 program.c
./xgcc-3 program.c program.xgcc.json
```

Future revisions can add cryptographic hashes, dependency identities, target ABI, compiler flags, and reproducible-build attestations.
