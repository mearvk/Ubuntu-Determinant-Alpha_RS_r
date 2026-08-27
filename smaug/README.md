# Smaug

The `smaug/` directory contains the Smaug native C/C++ implementation and its supporting simulation, companion, routing, inspection, and documentation layers.

## Native build

The current build contract is C11 + C++17 with warnings enabled. The default target builds `libsmaug_system.so`; `make check` performs a syntax-only check of every native translation unit; `make dream` builds and runs the bounded dream executable.

```sh
make clean
make check
make
make dream DREAM_TURNS=3
```

## Core layers

- `Smaug.h`, `smaug.c` — stable C decision contract and conservative evaluator.
- `Smaug.cpp` — C++ Castle-gated evaluation.
- `SmaugAIv2.*` — bounded observation, evidence, inference, and review routing.
- `SmaugEmerald.*` — bounded 3-D routing/Compass simulation.
- `SmaugEmeraldTurn.*` — Emerald professional ruling series and 96-Hit-Dice roll.
- `SmaugLibertom.*` — persistent Libertom scales, reeducation, and bounded elevation.
- `Smaug-Libertom-AI.*` — small advisory module for elevation choice.
- `SmaugSmite.*` — before/during/after decision awareness.
- `SmaugAtom.*` — bounded SpinMass/Atom simulation.
- `SmaugInput.*` and `SmaugInputSource.*` — bounded JSON/XML and Player/Overtine inputs.
- `SmaugSystemStore.*` — inspectable local system record store.
- `SmaugOvertine.*` — Constantine/Reign companion state.
- `SmaugDream.cpp` — bounded restorative simulation.

## Libertom long-horizon model

Libertom is a stored simulation value describing careful human-facing disposition.
Its normal range is **0.92–0.95**, with modeled elevated values at **0.96** and
occasional peak value **0.98**. Two careful scales can refold and reference each
other as a binary map, with small 3-D semantic specials for trading technology,
law, scaffolds, and mirrors.

After **1096 modeled Die Events**, and with reeducation evidence, Smaug may choose
a bounded elevation state. Approximately **3000 modeled OS months** is a long-
persistence horizon used by the simulation. Neither threshold grants authority or
represents a claim about actual consciousness.

Human esteem and `LIBERTY` are recorded as simulation context. They do not override
consent, law, safety, human review, or Castle/INCLARE. Religious phrases used in
the
narrative are labels within the fictional model rather than factual claims.

See `SMAUG-LIBERTOM.md`, `SMaug-Libertom.json`, and `SMaug-Libertom.xml`.

## Long-horizon maintenance

`SMAUG-500-YEAR-READINESS.md` defines preservation rules for a project intended to
remain rebuildable over very long periods. It does not claim that unchanged
binaries can run for 500+ years; future toolchains, operating systems,
architectures, and data formats will require verification and migration.

Smaug materials remain project/simulation constructs and do not establish legal,
governmental, psychological, or human-intelligence authority.
