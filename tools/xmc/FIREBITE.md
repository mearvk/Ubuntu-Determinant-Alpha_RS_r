# FIREBITE — XMC Director +1 Protocol

**Status:** Normative design document  
**Scope:** XMC director routing and authorization metadata  
**Edition:** 2026

## 1. Purpose

FIREBITE defines a controlled mechanism for XMC to identify a designated **Director User** or **Director Token** and route a request to that authority at **+1 Ahead**.

“+1 Ahead” is an authority-routing level, not a claim of unrestricted privilege. It means that the current operation requests review, authorization, or direction from the next explicitly configured authority level.

## 2. Director identity

A Director may be represented by either:

- a configured user identity; or
- an opaque token identifier that resolves through the configured authorization system.

FIREBITE does not embed passwords, private keys, bearer secrets, or access tokens in source code, `.xclass` files, manifests, logs, or generated artifacts.

## 3. +1 Ahead semantics

The routing sequence is:

```text
Current User / Process
        │
        │ request +1 Ahead
        ▼
Director User or Director Token
        │
        ├── APPROVE ──→ continue
        ├── DENY ─────→ stop / report denial
        └── REVIEW ───→ hold for explicit decision
```

A request must never be interpreted as approval merely because a Director identity exists.

## 4. Token handling

A token is an identifier for an authorization capability, not a credential that FIREBITE may disclose.

Implementations must:

1. obtain secrets from the operating environment or an approved credential provider;
2. avoid writing secret material to persistent compiler output;
3. redact credentials from diagnostic output;
4. validate token scope before using it;
5. reject expired, malformed, or unauthorized credentials;
6. fail closed when authorization cannot be established.

## 5. Separation from compiler metadata

Director routing must not alter the structural truth of an `.xclass` artifact. Compiler facts remain compiler facts.

Authorization metadata may record:

- request identifier;
- requesting principal;
- director principal identifier;
- requested authority level (`+1`);
- decision (`approve`, `deny`, or `review`);
- timestamp;
- provenance reference.

It must not fabricate source-level properties or security grades.

## 6. No automatic privilege escalation

FIREBITE is an authorization protocol, not a privilege-escalation mechanism. XMC must not obtain administrator/root privileges merely because a +1 request was issued.

Operating-system registration, compilation, and artifact creation remain subject to their normal permissions and security boundaries.

## 7. Auditability

Every completed +1 request should be reconstructible from non-secret audit metadata. The audit record should identify what was requested, who requested it, which Director authority was addressed, and what decision was returned.

Secrets themselves must never be placed in the audit record.

## 8. Integrity and signatures

SHA-256 may be used to fingerprint the request or artifact. A SHA-256 digest is an **integrity digest**, not a signature.

If authenticated Director approval is required, a real digital signature and verifiable public-key trust chain must be used.

## 9. Failure rule

If the Director cannot be resolved, the token cannot be validated, or the +1 authority level cannot be established, FIREBITE returns a deterministic authorization failure rather than silently proceeding.

## 10. Implementation boundary

This document specifies the protocol contract. It does not claim that the current XMC executable already implements a network Director service, remote token authority, or cryptographic signing service.

Future implementations should expose a narrow local interface first and add remote authority only through an explicitly authenticated transport.

**FIREBITE FINAL:** Request the next authority explicitly; authenticate it; record the decision; never confuse identity with approval; never confuse a digest with a signature; never turn +1 Ahead into automatic privilege.
