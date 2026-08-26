# xgcc-2

**Author:** Max Rupplin - MEARVK LLC 2026

Generation 2 introduces the `.xobj` flow. It packages the validated source into an inspectable XGCC artifact without pretending that the artifact is a native executable.

```sh
./xgcc-2 program.c
./xgcc-2 program.c program.xobj
```

The `.xobj` boundary can later be extended with IR, dependency hashes, target information, and capability requirements.
