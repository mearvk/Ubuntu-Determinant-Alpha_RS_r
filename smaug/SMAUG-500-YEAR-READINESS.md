# Smaug Long-Horizon Readiness

## Scope

The Smaug native layer is intended to be maintainable for a very long-lived project. **No software can honestly be guaranteed to run unchanged for 500+ years.** This document defines engineering properties that make the code easier to preserve, rebuild, inspect, and migrate.

## Current quality baseline

- C11 and C++17 language contracts are explicit in the Makefile.
- The native library has no mandatory MySQL runtime dependency.
- JSON/XML input is bounded before processing.
- Emerald neuron allocation is bounded at 1,048,576 neurons.
- Atom effect levels saturate rather than wrapping.
- Evidence identifiers use a specified FNV-1a 64-bit algorithm rather than implementation-defined `std::hash` behavior.
- Dream execution is a separate executable and does not place a `main` symbol in the shared library.
- `make check` is the compile-only gate; `make` builds the shared library; `make dream` exercises the bounded dream executable.

## Preservation rules

1. Keep public C structures fixed-width where possible.
2. Keep C++ interfaces explicitly versioned when they become externally stable.
3. Avoid undocumented compiler extensions in the core model.
4. Keep generated binaries out of source control unless a release artifact is deliberately archived.
5. Preserve build instructions with the source.
6. Test with more than one compiler family when available.
7. Treat stored records as migrations, not immutable assumptions about future operating systems.
8. Never interpret fictional capability numbers as human intelligence claims.

## Verification

From `smaug/`:

```sh
make clean
make check
make
make dream DREAM_TURNS=3
```

The repository integration provides the commands; a successful result must be verified by an actual CI runner or host compiler. GitHub source inspection alone cannot establish a successful native build.
