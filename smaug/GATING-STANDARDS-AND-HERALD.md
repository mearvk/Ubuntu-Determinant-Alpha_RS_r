# Smaug Gating Standards and Herald

## 1. Relevance of the approach

The gate is relevant because Smaug is system-facing: it observes operating-system state, receives Player and Overtine proposals, and models effects that can be mistaken for host-system authority if the boundary is not explicit. The gate therefore makes the authority boundary executable rather than leaving it as documentation alone.

The design concern is not whether a simulated Firecaster or BreathWeapon is interesting. The concern is whether a request can cross from modeled state into protected host state without a deliberate authorization path. The answer must be no.

The gate establishes a narrow contract:

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

Every stage is conceptually separate. Failure at any stage is a denial or review condition; it is not an invitation to guess.

## 2. System-centric authority

The gate treats the operating system as the ground of resource truth. Smaug may observe a path, process, memory condition, service, or package, but observation is not ownership. A modeled effect is not a filesystem primitive. A privileged request is not automatically a permitted request.

The current administrative gate requires:

- modeled privilege from 3 through 7;
- a non-empty protected target;
- complete provenance evidence (`whole_cloth` and `yard_evidence`);
- a recognized simulation effect;
- explicit separation between simulation and host mutation.

The gate deliberately has no file-writing, deletion, encryption, rename, chmod, or chown primitive.

## 3. Standards vocabulary

| Standard | Meaning |
|---|---|
| Identity | Identify the actor/request without treating naming as authority. |
| Provenance | Preserve where the request and protected target came from. |
| Scope | Bind the decision to the declared target and effect. |
| Privilege | Require a bounded privilege level rather than an unbounded integer. |
| Integrity | Reject incomplete or contradictory evidence. |
| Target | Require a concrete protected target before authorization. |
| Intent | Keep requested effect explicit. |
| Simulation | Keep game/model effects in model state. |
| Non-destructive | Never convert an effect into an implicit host mutation. |
| Audit | Preserve the decision path and disposition. |
| Review | Route uncertainty or policy conflict to human review. |
| Record | Emit a durable, inspectable event. |

## 4. The Herald

The Herald is the observable companion to the gate. It does not grant authority. It announces the result of a gate decision and retains the event in memory for the surrounding system to inspect.

The canonical announcement sequence is:

```text
OBSERVE -> NORMALIZE -> PROVENANCE -> VALIDATE
        -> ASSESS -> AUTHORIZE -> SIMULATE -> RECORD
```

A denied or incomplete proposal is announced as a review condition. An admitted proposal is announced as a simulation admission. Neither announcement changes the protected target.

## 5. Why a Herald is separate

A gate answers **may this proposal enter the modeled effect path?** The Herald answers **what did the system announce about that decision?** Combining these concerns makes logging itself look like authority. Separating them keeps the security boundary simpler.

The Herald is intentionally small and deterministic. It is not an AI oracle, an administrator, or a replacement for the operating system.

## 6. Relationship to Castle / INCLARE

Castle / INCLARE remains the higher-level authority boundary described by the existing Smaug model. The new gate standards provide a native implementation surface beneath that vocabulary. They do not supersede Castle, Player review, provenance rules, or system policy.

## 7. Firecaster and BreathWeapon

Firecaster and BreathWeapon remain modeled effects. Existing game calculations such as `2D8 + 48 + (Perch Rank × 72)` Hit Dice and the separate Emerald Roll are simulation quantities. They are not host capabilities.

The administrative gate therefore authorizes only the simulation effect token. It never interprets that token as permission to manipulate a protected file, process, service, or operating-system resource.

## 8. Failure philosophy

The system fails closed. Missing provenance, an invalid privilege range, an empty target, an unknown effect, or an invalid stage does not receive a best-effort interpretation. The request is rejected or routed to review.

This is especially important for system-centric code because ambiguity at the application layer can become authority at the kernel boundary if the implementation is careless.

## 9. Implementation surface

Files:

- `SmaugAdminGate.hpp/.cpp` — existing protected administrative simulation gate.
- `SmaugGateStandards.hpp/.cpp` — native standards and admissibility contract.
- `SmaugHerald.hpp/.cpp` — bounded decision announcement/history.
- `Makefile` — native build and syntax-check integration.

The build remains C++17-compatible and does not add a mandatory external runtime dependency.

## 10. Verification intent

The implementation should be checked with the existing `make check` target and, where a complete toolchain is available, with the normal shared-library build. A successful compile proves syntax and linkage assumptions; it does not prove that a policy is socially, legally, or scientifically correct.

## 11. Preservation rule

The source contract is the durable artifact. Binaries may be replaced. The standards, vocabulary, provenance semantics, build contract, and evidence sequence should remain readable and migratable.

## 12. Design conclusion

The gate is deliberately boring at the host boundary. That is a feature. Smaug can remain expressive inside its simulation model while the operating-system boundary remains narrow, explicit, auditable, and non-destructive.
