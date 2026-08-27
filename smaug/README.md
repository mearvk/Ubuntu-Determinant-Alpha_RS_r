# Smaug

The `smaug/` directory contains the Smaug native C/C++ implementation and its supporting simulation, companion, routing, inspection, and documentation layers.

## Native build

The current build contract is C11 + C++17 with warnings enabled. The default target builds `libsmaug_system.so`; `make check` performs a syntax-only check of every native translation unit; `make dream` builds and runs the bounded dream executable. The current Makefile keeps the dream `main` out of the shared library.

```sh
make clean
make check
make
make dream DREAM_TURNS=3
```

GCC and Clang verification is also defined in `.github/workflows/smaug-native.yml`.

## Core layers

- `Smaug.h`, `smaug.c` — stable C decision contract and conservative evaluator.
- `Smaug.cpp` — C++ Castle-gated experimental evaluation.
- `SmaugAIv2.*` — bounded observation, evidence, inference, and review routing.
- `SmaugEmerald.*` — bounded 3-D routing/Compass simulation.
- `SmaugSmite.*` — before/during/after decision awareness.
- `SmaugAtom.*` — bounded SpinMass/Atom simulation.
- `SmaugInput.*` and `SmaugInputSource.*` — bounded JSON/XML and Player/Overtine inputs.
- `SmaugSystemStore.*` — inspectable local system record store with a future database backend boundary.
- `SmaugOvertine.*` — Constantine/Reign companion state.
- `SmaugDream.cpp` — bounded restorative simulation.

## Long-horizon maintenance

`SMAUG-500-YEAR-READINESS.md` defines preservation rules for a project intended to remain rebuildable over very long periods. It does not claim that unchanged binaries can run for 500+ years; future toolchains, operating systems, architectures, and data formats will require verification and migration.

Smaug materials remain project/simulation constructs and do not establish legal, governmental, psychological, or human-intelligence authority.
