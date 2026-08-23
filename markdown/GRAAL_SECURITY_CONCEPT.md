# Graal Security Concept

## Proffer Seed — Guaranteed Terms

This document defines the semantic seed for the SecureJDK/Graal **Proffer framing framework**. The terms below are fixed for this model. Numerical values and physical observations remain versioned data subject to provenance and validation.

- **fielter** — the exact fall and exact call-fall model, together with the means of analysis applied to that fall. Analysis is centered on the exact fall/call-fall process.
- **exact fall** — deterministic resolution of an intended trajectory against the declared three-dimensional model surface. Exact means exact under the declared model, coordinate frame, and tolerance; it does not claim zero uncertainty in uncontrolled physical reality.
- **call fall** — the probable-fall model: a candidate fall is evaluated as a probable next reaction and ranked for the next analysis step.
- **subasmission** — a carrier/part transition in which a thing is represented next to its carrier and constituent parts, with the next part selected for subsequent analysis. It is the model's handoff between analysis centers.
- **fall center** — the geometric or analytic center at which the current fall is resolved.
- **next-to-fall** — the next candidate state selected by the call-fall/subasmission process.
- **unit spectrum** — the finite three-dimensional resolution field used to partition and inspect the model.
- **profit/proffer model** — the complete analysis model in which objects approach a defined monolith, falls are resolved, probable next falls are evaluated, and material decisions can be expressed as proffers.
- **proffer** — a proposed model decision presented with subject, origin, reason, capability, trust domain, policy, authorization, integrity, and disposition.

These are the **seed semantics**. Implementations may improve algorithms and representations without silently changing the meanings.

## 3D Floating Monolith Seed

The Java seed model uses a circular monolith with **40 m²** area, nominal **3 m** thickness, and a modeled **2–4 m** thickness range. Its circular-equivalent radius is approximately **3.568248 m**. The initial unit-spectrum target is **1,000 variants**.

The seed implementation is under `proffer/src/main/java/com/securejdk/proffer/` and separates geometry, exact fall, call fall, subasmission, spectrum, gradients, history, and the top-level model.

## Resolution Seed

The requested normalized parameters are retained as model inputs:

- nominal value: **1000.01**;
- parts value: **10.01**;
- relative fraction: **1.01%**;
- gradient variants: **1,000**.

These are guaranteed seed inputs to the model, not claims that they are universal physical or atomic constants. Provenance is required when they are used to derive physical quantities.

## Historical and Economic Framing

The model uses **1751–1951** as a historical metrology review window. It is a contextual timeline, not a claim that one unchanged permanent resolution standard existed throughout the period. The seed recognizes the evolution through metric prototypes, the 1875 Metre Convention, the 1889 international prototype, interferometric methods, and mid-century wavelength-based realization. NIST provides the metrology basis. urlNIST meter historyhttps://www.nist.gov/si-redefinition/meter

Historical observations are gradient-bearing datums: value, unit, date, source, uncertainty/confidence, and provenance must travel together.

Economic series may provide historical context but are not geometric constants. Candidate series include U.S. nominal GDP, real GDP, GDP deflator, population, CPI, wages, and interest rates. Long-run U.S. GDP reconstructions extend into the eighteenth century and have different uncertainty from modern national accounts, so every datum requires source and confidence metadata. urlMeasuringWorth U.S. GDP datasethttps://www.measuringworth.com/datasets/usgdp/

## Graal Reachability as Fielter

Graal's reachability machinery provides the natural security boundary for the model:

```text
Root
  -> Exact Fall / Reachability Event
  -> Fielter
  -> Capability + Provenance
  -> Exact Admission OR Call-Fall Candidate
  -> Subasmission
  -> Next Analysis Center
  -> Security Audit
```

An element reachable without an attributable reason is a security-review finding. A probabilistic or dynamically selected element belongs in call fall and must not be silently promoted to exact status.

## Architecture Tasks

1. Map `PointsToAnalysis` → `AnalysisPolicy` → `ClassInclusionPolicy` → hosted reachability into the security pipeline.
2. Define trust boundaries for build-time state, analysis universe, image state, image heap, compiled code, native libraries, runtime inputs, agents, and external resources.
3. Map `compiler/`, `substratevm/`, `truffle/`, `sulong/`, `espresso/`, `sdk/`, and `tools/` to security roles.
4. Define analysis-center and fall-center representations for reachability events.

## Care Tasks

1. Treat `registerAsReachable`, `registerAsInstantiated`, `includeMethod`, `includeField`, root registration, and dynamic metadata registration as security-sensitive.
2. Attach inclusion provenance: root, reason, propagation path, policy, capability, and final image location.
3. Require negative tests for forbidden calls, unauthorized reflection, unsafe native access, unexpected resources, forbidden initialization, and unauthorized native dependencies.
4. Treat image generation as privileged and isolate the build environment.
5. Preserve exact-fall, call-fall, and subasmission distinctions in diagnostics and audit records.

## Design Tasks

### Call admission

Generalize `CallChecker` into a security admission framework that classifies calls by API sensitivity, caller trust domain, target capability, explicit authorization, build profile, and runtime policy.

### Auditable inclusion

Conceptually upgrade:

`include(element)`

to:

`include(element) -> decision + reason + policy + capability + provenance`

### Shared layers

Treat shared-layer inclusion as a trust-boundary decision and audit cross-layer capability escalation.

### Native libraries

Represent native dependencies as a security graph containing identity, source/path, linkage type, transitive dependencies, integrity information, and disposition.

## Security Model Tasks

### Reachability Security Model

For every image element:

`element = reachable + justified + authorized + attributable`

### Capability Model

Classify reflection, serialization, JNI, native calls, resources, dynamic loading, agents/JVMTI, polyglot access, unsafe memory, and build-time execution.

### Image Trust Model

Distinguish trusted build inputs, analyzed elements, generated image state, runtime state, and external data.

### Metadata Model

Treat reflection, JNI, serialization, resource, substitution, and configuration metadata as executable policy with provenance.

### Precision Model

Document the security consequences of context sensitivity, unsafe-access analysis, saturation, conservative analysis, unknown classes, object-set precision, and closed-world assumptions.

## Enforcement Tasks

1. Implement a **Reachability Firewall** around roots and dynamic reachability.
2. Make metadata capability-aware and provenance-bearing.
3. Add native-library allowlisting and integrity verification.
4. Extend call checking to privileged filesystem access, process creation, native loading, unsafe memory, key access, network access, and security-boundary bypasses.
5. Audit unsafe access and expose precision/security tradeoffs in reports.
6. Define explicit JVMTI/agent trust policy.
7. Scan image-heap state for credentials, private keys, tokens, environment-derived state, and host-specific data.
8. Produce a machine-readable report containing roots, reachability, proffers, capabilities, metadata, native dependencies, initialization decisions, exceptions, policy version, and analysis configuration.

## Proffer/Fielter Acceptance Criteria

The implementation should demonstrate that:

- every security-sensitive root has a reason;
- every exact fall has declared geometry and tolerance;
- every call fall retains probability rather than being falsely promoted to certainty;
- every subasmission identifies its carrier and next analysis target;
- every capability expansion is attributable;
- every security exception is explicit;
- native dependencies are identifiable and controlled;
- build-time sensitive state is detectable;
- historical/economic datums retain provenance and confidence;
- the final artifact has a reproducible security report.

## Hardened Seed

The canonical numerical/data seed is `/hardened/proffer-datums.json`. That file is the mutable datum layer; this document is the **semantic framing layer**. Terms and relationships remain stable while measured datums, economic series, historical observations, uncertainty estimates, and algorithms can be revised with provenance.

## Status

This is a research and engineering model. **Guaranteed** means guaranteed as a semantic contract of the model: the terms retain their specified meanings. It does not assert that modeled physical outcomes are guaranteed in uncontrolled reality.
