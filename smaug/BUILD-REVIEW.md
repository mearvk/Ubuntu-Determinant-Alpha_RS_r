# Smaug / smaug Native Build Review

## Review target

The C implementation (`smaug.c`) and C++ implementation (`Smaug.cpp`) share the
public `SmaugDecision` contract in `Smaug.h`. The C implementation provides the
core conservative evaluator; the C++ layer adds the Castle precondition gate.

## Native compilation contract

- C: C11, warnings enabled, position-independent object support.
- C++: C++17, warnings enabled, position-independent object support.
- Shared-library link target: `libsmaug_system.so`.
- `make check` performs syntax-only compilation of all listed translation units.
- The default build has no mandatory MySQL dependency.

## Result

The source review found no language-level error in the inspected C/C++ entry
points. The Makefile provides the authoritative compile check. A repository API
review cannot itself execute the local compiler, so this document does not claim
that a host compiler has run successfully.

Run from `smaug/`:

```sh
make clean
make check
make
```

A successful `make check` is the required source-level gate before treating the
native Smaug and smaug pair as runnable on a particular host.

## Runtime boundary

Smaug's confidence scale is an engineering value, not an IQ measurement. The
native decision API remains conservative: risk and cause flags can prevent an
allow decision, and C++ Castle preconditions can further deny a transition.
