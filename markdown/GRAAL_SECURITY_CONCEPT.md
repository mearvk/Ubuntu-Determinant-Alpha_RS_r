# Graal Security Concept

## Purpose

This document turns the security review of the Graal source tree in `graal-latest` into an engineering task specification for SecureJDK. It is intentionally source-grounded: the objective is not to claim that Graal already implements SecureJDK security controls, but to identify where the existing architecture can be extended with explicit security policy, provenance, integrity, and audit controls.

The central proposition is:

> **SecureJDK integrity should become a policy surrounding Graal reachability.**
>
> Graal determines what can become part of an executable. SecureJDK should additionally determine why it is permitted, what capability it introduces, which trust boundary it crossed, who or what authorized it, and how the decision can be audited.

## Source-grounded architectural observations

The repository's Graal source already provides several strong foundations:

- `PointsToAnalysis` and the related reachability machinery construct a whole-program analysis universe and propagate reachability to a fixed point.
- `AnalysisPolicy` controls important precision/security tradeoffs including context sensitivity, unsafe access handling, saturation, and conservative analysis behavior.
- `ClassInclusionPolicy` separates inclusion decisions from inclusion mechanics and handles types, methods, fields, shared layers, accessibility, and native methods.
- `NativeImagePointsToAnalysis` provides a `CallChecker` admission hook, metadata initialization, field handling, shared-layer processing, and root-method validation.
- `NativeImageReachabilityAnalysisEngine` connects hosted reachability processing with metadata and field handling.
- `UserLimitationsChecker` establishes a hard-limit mechanism for reachable types.
- Native-library processing builds dependency information and handles static-library relationships and cycles.
- The Native Image agent/JVMTI machinery demonstrates that instrumentation is itself a security-relevant capability.
- The source tree separates major trust domains including `compiler`, `substratevm`, `truffle`, `sulong`, `espresso`, `sdk`, `tools`, and related components.

These mechanisms should be treated as architectural attachment points for SecureJDK rather than replaced indiscriminately.

---

# 1. Architecture Tasks

### A1 — Formalize the security pipeline

Map the existing pipeline:

`root registration -> reachability -> type/method/field inclusion -> metadata -> image heap/code -> native dependencies -> runtime`

into an explicit security pipeline with policy checkpoints at each expansion boundary.

**Deliverable:** an architecture diagram and implementation map identifying every security decision point.

### A2 — Define trust boundaries

Explicitly separate:

1. build-time trusted state,
2. analysis universe,
3. generated image state,
4. image heap,
5. compiled code,
6. native libraries,
7. runtime inputs,
8. agents/instrumentation,
9. externally supplied resources/configuration.

**Deliverable:** a trust-boundary specification identifying allowed information flow between each domain.

### A3 — Map component boundaries

Review the security role of `compiler/`, `substratevm/`, `truffle/`, `sulong/`, `espresso/`, `sdk/`, `tools/`, `wasm/`, and related components.

**Deliverable:** component-by-component security classification: trusted infrastructure, policy enforcement, capability provider, input processor, or runtime boundary.

---

# 2. Care Tasks

### C1 — Treat root registration as security-sensitive

Audit every operation equivalent to:

- `registerAsReachable`
- `registerAsInstantiated`
- `includeMethod`
- `includeField`
- root-method registration
- dynamic metadata registration

Each expansion must have an attributable reason.

**Deliverable:** a root-expansion inventory and security classification.

### C2 — Add inclusion provenance

Every security-sensitive inclusion should record:

- originating root,
- immediate reason,
- propagation path where practical,
- policy that permitted it,
- capability introduced,
- final image location.

**Deliverable:** machine-readable reachability provenance.

### C3 — Negative testing

Security tests must verify rejection as well as successful image construction.

**Deliverable:** negative tests for forbidden calls, unauthorized reflection, unsafe native access, unexpected resources, forbidden initialization state, and unauthorized native dependencies.

### C4 — Clean build discipline

Treat image generation as a privileged operation. Define reproducible, isolated build requirements and prevent uncontrolled host state from entering the image.

**Deliverable:** SecureJDK build-integrity checklist and CI enforcement.

---

# 3. Design Tasks

### D1 — Generalize `CallChecker` into a security admission framework

The existing call-checking architecture is a natural prototype for a broader policy system.

The security framework should be able to classify and reject call edges based on:

- API sensitivity,
- caller trust domain,
- target capability,
- annotation/explicit authorization,
- build profile,
- runtime policy.

**Deliverable:** `SecureCallPolicy` or equivalent design with explicit policy decisions and diagnostics.

### D2 — Make `ClassInclusionPolicy` auditable

Extend the conceptual role of inclusion policy so that inclusion is not merely boolean. A security-aware decision should expose a reason and policy provenance.

Conceptually:

`include(element) -> decision + reason + policy + capability + provenance`

**Deliverable:** design for an auditable inclusion-decision object.

### D3 — Secure shared-layer boundaries

Shared-layer inclusion must be treated as a trust-boundary decision. Verify that public/accessibility heuristics cannot unintentionally create capability escalation across layers.

**Deliverable:** shared-layer security policy and tests for cross-layer access.

### D4 — Secure native-library processing

Native-library dependency construction should become a security graph containing:

- library identity,
- source/path,
- static vs dynamic linkage,
- transitive dependencies,
- integrity information,
- allowed/denied status.

**Deliverable:** native dependency security report and allowlist mechanism.

---

# 4. Security Model Tasks

### M1 — Reachability Security Model

Define reachability as both a correctness property and an attack-surface boundary.

For every image element:

`element = reachable + justified + authorized + attributable`

An element that is reachable but lacks justification should be treated as a security-review finding.

### M2 — Capability Model

Classify capabilities including:

- ordinary Java execution,
- reflection,
- serialization,
- JNI,
- native calls,
- file/resource access,
- network-facing resources,
- dynamic class loading,
- agents/JVMTI,
- polyglot access,
- unsafe memory operations,
- build-time execution.

**Deliverable:** capability taxonomy with security levels and authorization requirements.

### M3 — Image Trust Model

Define and enforce the distinction between:

- trusted build inputs,
- analyzed program elements,
- generated image state,
- runtime state,
- externally supplied data.

No assumption should be made that build-time state is harmless merely because it is embedded before runtime.

### M4 — Build-time state injection model

Audit build-time initialization for:

- credentials,
- cryptographic material,
- environment variables,
- filesystem-derived values,
- host identity,
- network-derived state,
- timestamps and nondeterministic state,
- other sensitive constants.

**Deliverable:** build-time state scanner and policy for permitted initialization.

### M5 — Metadata security model

Treat reflection configuration, JNI metadata, resources, serialization metadata, substitutions, and related configuration as executable security policy rather than passive data.

**Deliverable:** metadata provenance, authorization, validation, and audit requirements.

### M6 — Precision/security tradeoff model

Document the security consequences of:

- context sensitivity,
- unsafe-access analysis,
- saturation,
- conservative analysis,
- unknown classes,
- object-set precision,
- closed-world assumptions.

A less precise analysis can produce a larger or more conservative security surface; that tradeoff must be visible in the security report.

---

# 5. Security Enforcement Tasks

### S1 — Reachability Firewall

Create a policy boundary around root creation and dynamic reachability expansion.

The firewall should be able to:

- allow,
- deny,
- require explicit authorization,
- record an exception,
- emit an audit event.

### S2 — Capability-aware metadata admission

Reflection, JNI, serialization, resource, substitution, and related registrations should carry security classifications and provenance.

### S3 — Native integrity controls

Implement a native-library allowlist with optional cryptographic integrity verification and dependency provenance.

### S4 — Expanded call security

Extend call checking from isolated forbidden APIs to policy classes such as:

- privileged filesystem access,
- process creation,
- native loading,
- unsafe memory access,
- cryptographic key extraction,
- network access,
- security-boundary bypasses.

### S5 — Unsafe access audit

Review all paths associated with unsafe memory access. Make conservative/non-conservative policy choices visible in build output and security reports.

### S6 — Agent/JVMTI policy

Define whether agents are trusted, restricted, signed/identified, development-only, or prohibited in a SecureJDK profile.

Agent capability must not be treated as equivalent to ordinary application execution.

### S7 — Image-heap secret scanning

Before final image creation, scan image state for credentials, private keys, tokens, environment-derived secrets, host-specific data, and other prohibited material.

### S8 — Security report

Generate a machine-readable report containing at minimum:

- roots,
- reachability expansion,
- inclusion reasons,
- capabilities,
- reflection/JNI/resource metadata,
- native dependencies,
- build-time initialization decisions,
- security exceptions,
- policy version,
- analysis configuration.

---

# 6. SecureJDK Integration Model

The intended SecureJDK relationship to Graal should be additive and policy-driven.

```text
                    SecureJDK Security Policy
                              |
             +----------------+----------------+
             |                |                |
        Root Policy      Call Policy     Capability Policy
             |                |                |
             +-------- Reachability -----------+
                              |
                    Graal Analysis Universe
                              |
                 Type / Method / Field Graph
                              |
                  Metadata + Image Heap
                              |
                Native Dependency Graph
                              |
                      Security Audit
                              |
                     Final Native Image
```

SecureJDK should not duplicate Graal's reachability engine. It should provide security policy, authorization, provenance, integrity verification, and audit around the existing analysis mechanisms.

---

# 7. Implementation Order

## Phase 1 — Visibility

1. Inventory all roots and inclusion mechanisms.
2. Add inclusion reasons/provenance.
3. Produce a baseline reachability security report.
4. Classify capabilities.
5. Inventory native dependencies.

## Phase 2 — Enforcement

1. Implement Reachability Firewall.
2. Generalize call checking.
3. Add metadata authorization.
4. Add native dependency allowlisting.
5. Add build-time state scanning.

## Phase 3 — Integrity

1. Add image-heap secret scanning.
2. Add artifact/dependency integrity verification.
3. Add signed or otherwise authenticated policy configuration where appropriate.
4. Make security reports reproducible and CI-verifiable.

## Phase 4 — SecureJDK Profiles

Define explicit profiles such as:

- `development`
- `standard`
- `hardened`
- `restricted`

Each profile should state exactly which capabilities and exceptions are permitted.

---

# 8. Acceptance Criteria

The work should not be considered complete merely because a native image builds.

A SecureJDK/Graal security implementation should demonstrate that:

- every security-sensitive root has an attributable reason;
- unauthorized call edges fail deterministically;
- dynamic metadata has provenance and authorization;
- native dependencies are identifiable and policy-controlled;
- build-time sensitive state is detected;
- image contents can be audited for prohibited secrets;
- security exceptions are explicit and reviewable;
- analysis precision/security tradeoffs are visible;
- the final image has a reproducible security report;
- negative tests demonstrate that prohibited behavior is rejected.

---

# 9. Proffer: Conceptual Security Standard

For purposes of SecureJDK, a **proffer** is a proposed security decision presented for authorization rather than silently incorporated into the image.

Every material expansion of executable capability should be representable as:

```text
PROFFER
  subject: <type | method | field | metadata | native library>
  origin: <root / dependency / configuration>
  reason: <why it became reachable>
  capability: <what it enables>
  trust-domain: <where it originated>
  policy: <rule that permits or denies it>
  authorization: <explicit / inherited / denied>
  integrity: <verified / unknown / failed>
  disposition: <accept / reject / review>
```

This gives SecureJDK a concrete vocabulary for connecting Graal's analysis model with security engineering.

The goal is not to make the compiler distrust everything. The goal is to make **security-relevant trust explicit, bounded, attributable, and testable**.

---

# 10. Immediate Source Worklist

The first implementation review should concentrate on:

1. `com.oracle.graal.pointsto.PointsToAnalysis`
2. `com.oracle.graal.pointsto.ClassInclusionPolicy`
3. `com.oracle.graal.pointsto.AnalysisPolicy`
4. `com.oracle.svm.hosted.analysis.NativeImagePointsToAnalysis`
5. `com.oracle.svm.hosted.analysis.NativeImageReachabilityAnalysisEngine`
6. `com.oracle.svm.hosted.analysis.CallChecker`
7. `com.oracle.svm.hosted.analysis.UserLimitationsChecker`
8. native-library dependency processing under `com.oracle.svm.hosted.*`
9. reflection/JNI/resource/serialization configuration processing
10. Native Image agent/JVMTI implementation
11. build-time initialization machinery
12. image-heap construction and verification

Each item should be reviewed for **architecture, care, design, model, and security**, with findings converted into implementation tasks and tests.

## Status

This document is a task specification. The presence of a task does **not** imply that the corresponding SecureJDK control has already been implemented.

The immediate objective is to move from conceptual security review to source-level enforcement, beginning with reachability provenance and security admission policy.
