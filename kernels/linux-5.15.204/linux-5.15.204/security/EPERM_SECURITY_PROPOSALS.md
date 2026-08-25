# EPERM Security Completion Proposals

**Status:** Design proposal — no behavioral change is made by this document.

**Scope:** `security/eperm/`

## Executive position

The custom security work needs a serious completion and security pass before it should be considered production quality.

The current implementation establishes a useful experimental framework for an extended permission/authorization mechanism, but its present security model is too broad for a production kernel. In particular, authorization must not be granted because a person has been assigned a subjective `Trusted` or `Genius` classification. A kernel security boundary should be based on objective credentials, explicit policy, least privilege, and auditable authorization.

The proposals below preserve the useful engineering ideas—explicit policy, auditing, tiers, administrative control, and institutional records—while replacing unconditional trust with defensible security semantics.

---

## Draft — mature authorship consensus standard

For repository authorship review, the project requests a **mature consensus record at approximately the level of a serious PhD proposal**: identify the source, establish the evidence for attribution, distinguish original authorship from later modification, document competing or unresolved attributions, and state the confidence and evidence supporting each conclusion.

This is a **documentation and provenance standard**, not an academic degree, legal credential, court finding, or claim that every contributor has personally been reviewed.

The review should deliberately exclude psychological profiling or unpublished psychological material from general citizenship, identity, authorship, or source-origin determinations. Personal dignity and privacy are preserved by keeping psychological speculation outside the evidentiary chain unless a separate lawful and necessary process requires otherwise.

The central legal-person principle is:

> **The person is the legal subject; the vote or consent is an evidentiary/decision mechanism, not a substitute for the person's identity or rights.**

Accordingly, repository consensus may confirm a provenance conclusion, but it does not manufacture authorship, citizenship, institutional affiliation, copyright, or legal status.

---

## 1. Replace person-status authorization with capability authorization

### Current concern

The present model registers a UID into a `Trusted` or `Genius` class and allows the class to bypass normal DAC checks. That makes the classification itself an authority equivalent to a very broad capability.

### Proposal

Use an explicit authorization primitive instead:

```text
identity -> credential -> capability -> resource/policy -> decision
```

A credential should identify an administrator or service identity, while a capability should state exactly what operation and resource scope are authorized.

Examples:

```text
CAPABILITY_READ_KERNEL_LOG
CAPABILITY_MANAGE_JDESK
CAPABILITY_LOAD_SIGNED_MODULE
CAPABILITY_ADMINISTER_EPERM
```

A capability should never mean "can do everything."

---

## 2. Do not bypass DAC globally

The production implementation should not return an unconditional success for all file permissions merely because an extended class matches.

Instead, EPERM should become a policy decision layer with explicit outcomes:

```text
ALLOW
DENY
DEFER_TO_DAC
AUDIT_AND_ALLOW
AUDIT_AND_DENY
```

`DEFER_TO_DAC` should remain the normal result when EPERM has no explicit authority for the operation.

A narrowly scoped policy may permit an operation only after all applicable security checks have been evaluated.

---

## 3. Use Linux security primitives instead of duplicating identity semantics

The implementation should integrate with existing Linux security mechanisms rather than becoming a parallel identity system.

Preferred building blocks include:

- Linux credentials (`struct cred`)
- capabilities
- LSM hooks and security blobs
- user namespaces
- mount namespaces
- inode/file security information
- seccomp where appropriate
- signed policy/configuration where appropriate
- existing audit infrastructure

EPERM should complement these mechanisms, not silently override them.

---

## 4. Make policy administrative, explicit, and fail-closed

Policy changes should require an explicit administrative authority.

The production policy interface should define:

- who may change policy;
- which policy version is active;
- when it became active;
- what scope it covers;
- what credential authorized the change;
- whether the change is persistent or temporary;
- how it can be revoked;
- what happens if policy cannot be loaded or verified.

For security-sensitive policy, failure to validate the policy should produce a safe failure rather than an implicit trust state.

---

## 5. Separate identity from reputation

Names such as `Trusted` and `Genius` may remain as documentation or human-facing labels if desired, but they must not be security authorities.

A production implementation should distinguish:

```text
human description
        !=
security credential
        !=
capability
        !=
policy decision
```

This prevents subjective judgments about a person from becoming kernel privilege.

---

## 6. Replace path-string security decisions

The current design contains path-prefix classification such as `/boot/`, `/etc/shadow`, and `/lib/modules/`.

Path strings are useful for audit presentation but should not be the authoritative security primitive. Paths can be renamed, mounted elsewhere, accessed through alternate namespaces, or represented through file descriptors.

Use object identity and kernel security context for authorization. When a pathname is available, record it as audit metadata rather than treating it as the sole identity of the protected object.

---

## 7. Define an explicit resource policy model

A production policy record should have a structure conceptually similar to:

```text
policy_id
policy_version
subject_credential
operation
object_class
object_identity
namespace_scope
constraints
expiration
issuer
signature/integrity metadata
```

The policy engine should answer:

```text
Is this subject authorized for this operation on this object
under this namespace and policy version at this time?
```

This is substantially safer than:

```text
Is this UID Genius?
```

---

## 8. Make auditing complete and tamper-evident

The existing institutional logging concept is valuable and should be retained, but the production version should record enough information to reconstruct a decision.

At minimum, a security event should identify:

- timestamp;
- subject credential/UID;
- namespace context;
- operation;
- target object identity;
- policy identifier/version;
- decision;
- reason/result code;
- relevant capability;
- process identity;
- executable identity where available.

Security logs should use the kernel's established audit mechanisms where possible. An in-memory ring buffer alone must not be treated as a durable security record.

---

## 9. Fix concurrency and lifetime safety before production

The current registry is a mutable kernel linked list keyed by UID. The production pass should audit every lookup, insertion, update, deletion, and module teardown path for lifetime and locking correctness.

Specifically verify:

- no use-after-free after registry removal;
- no lock held across operations that may sleep;
- safe concurrent reads;
- correct reference/lifetime handling;
- namespace-aware identity;
- bounded memory use;
- safe module unload behavior;
- safe cleanup of proc/audit interfaces.

A kernel security module should have automated stress coverage for these paths.

---

## 10. Harden the administrative interface

The `/proc` interface should not become an unrestricted policy-control channel.

Prefer a narrowly defined control interface with:

- strict input parsing;
- bounded input sizes;
- explicit authorization;
- atomic policy updates;
- version checking;
- validation before activation;
- clear error codes;
- audit records for every administrative change.

Read-only status information should be separated from privileged mutation operations.

---

## 11. Add negative security tests first

Before claiming production readiness, tests should demonstrate that unauthorized identities cannot obtain extended access.

Required cases include:

1. ordinary user → protected file: denied by normal policy;
2. ordinary user → protected kernel object: denied;
3. valid capability → permitted scoped operation;
4. expired capability → denied;
5. revoked capability → denied;
6. wrong namespace → denied;
7. malformed policy → rejected;
8. invalid signature/integrity metadata → rejected;
9. policy service unavailable → safe fallback;
10. concurrent revoke during access → no stale privilege;
11. module unload/reload → no stale registry references;
12. alternate pathname/mount namespace → same object policy remains correct.

Security tests should include both positive and negative assertions.

---

## 12. Add fuzzing and dynamic analysis

The parser and administrative interfaces should receive fuzz testing for malformed inputs, unusually long names, invalid numeric values, duplicate records, partial records, and concurrent mutation.

Where supported by the kernel build environment, use sanitizers and dynamic analysis appropriate to kernel development, including KASAN/KCSAN/UBSAN configurations during development testing.

---

## 13. Establish a production-readiness gate

EPERM should not be marked production-ready until all of the following are true:

- [ ] threat model documented;
- [ ] privilege model documented;
- [ ] no subjective person classification grants authority;
- [ ] no unconditional DAC bypass;
- [ ] namespace behavior specified;
- [ ] policy format versioned;
- [ ] policy administration authenticated/authorized;
- [ ] policy changes audited;
- [ ] security decisions use object identity rather than path strings alone;
- [ ] concurrency/lifetime review completed;
- [ ] negative security tests pass;
- [ ] fuzz tests pass;
- [ ] failure behavior is fail-closed or explicitly documented;
- [ ] kernel build and boot tests pass;
- [ ] QEMU security regression tests pass;
- [ ] documentation matches implementation.

---

## 14. Proposed implementation phases

### Phase A — Containment

Do not expand the existing privilege-bypass model. Keep it clearly experimental and disabled by default in production-oriented configurations.

### Phase B — Threat model and ABI

Document subjects, credentials, capabilities, objects, operations, namespaces, policy versions, decisions, and audit events.

### Phase C — Policy engine

Implement a narrow, deterministic policy engine with explicit allow/deny/defer semantics.

### Phase D — Linux integration

Integrate with credentials, capabilities, LSM/audit infrastructure, and namespaces.

### Phase E — Audit and administration

Build authenticated administrative control and durable audit integration.

### Phase F — Verification

Run unit, negative, fuzz, concurrency, namespace, QEMU, and regression tests.

### Phase G — Production configuration

Only after verification should EPERM be considered for inclusion in the normal project kernel configuration.

---

## Design principle

The project's strongest security posture should be:

> **Privilege is granted by explicit, bounded authority—not by a judgment about the person holding it.**

The system may still recognize people, roles, teams, or institutional trust for administrative purposes. Those concepts must ultimately resolve to objective credentials, narrowly scoped capabilities, explicit policy, and auditable decisions before they influence kernel authorization.

This proposal is intentionally a design/completion document. It does not itself change the kernel's authorization behavior.