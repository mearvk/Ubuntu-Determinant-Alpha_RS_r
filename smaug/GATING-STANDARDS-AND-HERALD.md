# Smaug Gating Standards and Herald

## 1. System-centric contract

The gate and Herald are treated as native system components. They are not prose-only policy and they are not an authority shortcut. The operating system remains the ground of resource truth. A modeled effect is not a host capability, and an observation is not ownership.

The executable sequence is:

```text
observe
  -> normalize
  -> provenance
  -> validate
  -> assess
  -> authorize
  -> simulate
  -> record
```

Each stage has a distinct purpose. Failure or uncertainty routes to denial or review rather than best-effort interpretation.

## 2. Dependent and independent paths

The **dependent path** follows the system's authoritative prerequisites: valid stage, recognized effect, bounded privilege, explicit target, complete input, and the existing administrative simulation boundary.

The **independent path** is the Herald's evidence check. It recomputes basic integrity conditions from the decision itself, validates subject/reason shape, checks provenance, verifies protected scope, and preserves a fingerprint and audit token. The Herald cannot turn a failed gate into an approval.

This creates two related but distinguishable questions:

1. Did the dependent system path admit the proposal?
2. Does the independent observation support the recorded disposition?

A mismatch is a review condition.

## 3. Gating implementation

`SmaugGateStandards.cpp` has been expanded into an 1800+ line native policy implementation. The source contains a 1800-entry system-rule catalog plus the executable admission, dependency, provenance, scope, fingerprint, audit-token, failure-reason, and fail-closed logic.

The rule catalog is deliberately data-driven: each rule records a bounded privilege floor and policy flags. The catalog is not permission to mutate the host; every rule remains simulation-only.

The public gate contract now exposes:

- dependency safety;
- independent evidence validation;
- protected-scope validation;
- decision fingerprinting;
- stable rule metadata;
- text/provenance/privilege/stage/effect validation;
- dependency-chain validation;
- review detection;
- fail-closed detection;
- structured failure reasons;
- audit tokens.

## 4. Herald implementation

`SmaugHerald.cpp` is the independent recording layer. It now records:

- canonical sequence;
- subject and reason;
- provenance disposition;
- decision fingerprint;
- audit token;
- monotonically increasing event sequence;
- accepted/review state;
- explicit event status;
- bounded history;
- event verification;
- deterministic rendering;
- batch announcement;
- configurable retention and fail-closed behavior.

The Herald never authorizes a host operation. It announces and verifies the disposition of the gate.

## 5. Explicit status model

The Herald distinguishes:

| Status | Meaning |
|---|---|
| `Accepted` | The gate admitted a bounded simulation proposal and independent evidence supports the record. |
| `Review` | Evidence, scope, or policy conditions are incomplete or require human review. |
| `Denied` | The gate rejected admission. The Herald preserves the denial. |
| `DependencyFailure` | A prerequisite in the dependent system path failed. |
| `Invalid` | The event does not satisfy its structural contract. |

## 6. Evidence preservation

Every recorded event carries a fingerprint derived from the decision and an audit token derived from that fingerprint. These are integrity aids, not cryptographic signatures and not substitutes for a trusted audit store.

The Herald verifies event shape and disposition consistency. It does not claim that an in-memory event is tamper-proof after the process terminates.

## 7. Protected-system boundary

The administrative layer continues to expose only declarative simulation authorization. Firecaster and BreathWeapon remain modeled effects. They do not become filesystem, process, service, permission, encryption, deletion, rename, or kernel operations.

The correct boundary is therefore:

```text
model request
    |
    v
native gate -----> deny/review
    |
    v
bounded simulation
    |
    v
independent Herald record
```

There is no implicit arrow from a simulation effect to protected host mutation.

## 8. ClamAV.US.Legal.Edition reference discipline

The `ClamAV.US.Legal.Edition` repository is treated as a reference for provenance, legal/compliance documentation, attribution, and system-facing review discipline. It is not treated as permission to copy unrelated code or as an authority over the Smaug architecture.

The security engine and the legal/analytical layer remain conceptually separate. A security finding is not weakened by a Herald interpretation.

## 9. Build contract

The existing `smaug/Makefile` already compiles `SmaugGateStandards.cpp` and `SmaugHerald.cpp` as part of the native C++17 shared-library build. No additional mandatory runtime dependency is introduced.

The intended verification command remains:

```text
make check
```

A syntax-clean build establishes compiler correctness for the checked source; it does not by itself establish that a policy is legally or socially sufficient.

## 10. Failure philosophy

The system fails closed. Missing provenance, invalid privilege, unknown effects, invalid stages, incomplete target scope, contradictory evidence, and dependent-system failures cannot be silently promoted to approval.

The independent Herald is especially important here: it prevents the reporting layer from becoming a hidden second authorization mechanism.

## 11. Preservation rule

The source code, rule catalog, event schema, provenance semantics, and evidence sequence are the durable artifacts. Generated binaries may change without changing the conceptual contract.

## 12. Design conclusion

The improved architecture is intentionally careful, dependent where dependency is authoritative, and independent where evidence can be recomputed. The gate decides admission into a bounded simulation path. The Herald independently observes and records the disposition. Neither component acquires an implicit right to alter the host system.
