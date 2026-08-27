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

## Preservation contract

1. Keep source in portable C11/C++17 where practical.
2. Keep public interfaces documented and versioned before external stabilization.
3. Keep externally supplied dimensions, records, strands, coils, and turns bounded.
4. Keep storage behind a replaceable Store interface so MySQL or another database can be substituted later.
5. Keep JSON/XML ingestion defensive and replaceable.
6. Preserve compiler-warning gates and build instructions.
7. Test across compiler families and supported operating systems.
8. Treat generated binaries as rebuildable artifacts, never as the only copy of the program.
9. Record migration notes whenever a data format, ABI, compiler, operating-system, or database dependency changes.
10. Preserve old formats long enough to provide explicit conversion paths.

## Compatibility horizon

The durable 500-year artifact is the **source + specifications + tests + documented build environment + migration history**. A 2026 executable, shared object, operating-system ABI, or database connector should not be assumed to remain executable centuries later.

## Verification sequence

```sh
make clean
make check
make
make dream DREAM_TURNS=3
```

Then inspect the resulting field/evidence output and record the compiler, platform, and build date. Failures are review events, not silent success.

## Authority

Smaug's companion, habit, Emerald, Smite, Atom, Overtine, and storage layers are advisory simulation components. Castle/INCLARE remains the authority boundary. Uncertainty can request review; historical patterns, capability scores, and fictional IQ terminology do not independently grant authority.
