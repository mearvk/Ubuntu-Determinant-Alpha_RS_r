# xgcc-1

**Author:** Max Rupplin - MEARVK LLC 2026

Generation 1 is the XGCC preflight binary. It reads source without executing it and performs bounded input validation, language classification, and basic delimiter-balance checking.

```sh
./xgcc-1 program.c
```

A nonzero result indicates that the preflight contract was not satisfied.
