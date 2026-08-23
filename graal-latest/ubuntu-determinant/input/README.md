# Input Lip-Curl / .81 Descriptor

This directory defines a project-level input-quality descriptor for the Graal integration. It is deliberately an integration contract rather than a modification of Graal's mathematical compiler semantics.

## Purpose

An input source may carry a measurable *surface of concern*: structure, kind, boundary behavior, and a visual/geometric proxy for curvature. The descriptor lets the front end preserve that information before optimization or lowering.

The project names the fields:

- **overall** — normalized aggregate quality/concern score in `[0,1]`.
- **kind** — declared input class or source kind.
- **fash** — boundary/edge character of the input surface. This is the project's term for the "brit of the lip" of the input: how sharply or softly the represented boundary changes.
- **curl-color** — a normalized proxy for three-dimensional torque/curvature encoded by the input's surface/color field. A 4D interpretation is treated as an approximation derived from the measured 3D representation, never as an exact fourth spatial dimension.

## .81 delimiter

`0.81` is the project's **input concern delimiter**. It is a threshold, not a unit and not a claim about a physical constant.

- `< 0.81`: ordinary input-quality path.
- `>= 0.81`: elevated concern path; retain the descriptor and require the downstream stage to acknowledge it.

The delimiter must be compared against the normalized `overall` value using an exact numeric representation. Do not silently round values before comparison.

For example, `0.809999` is below the delimiter and `0.810000` is at the delimiter.

## Tone and cause

The descriptor may carry a `tone` value as metadata about the measured input surface. `tone` is descriptive, not a semantic instruction to the compiler. `cause` records why the descriptor was assigned when evidence is available.

No descriptor may change Java language semantics, memory safety, authorization, or compiler correctness merely because its score crosses the delimiter.

## Processing directive

The intended processing sequence is:

`observe -> normalize -> classify -> preserve descriptor -> compare .81 -> compile normally or mark elevated concern -> record evidence`

This gives the SecureJDK/Wine/Ubuntu Grand layers a common vocabulary without coupling platform policy to Graal optimization decisions.
