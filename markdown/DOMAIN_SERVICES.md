# Total Domain Services

## Purpose

The Total three-tier architecture can expose a common service-domain adapter for applications that operate in regulated, commercial, or otherwise sensitive environments. The adapter gives the Top, Middle, and Ground tiers a common way to carry evidence without turning Total into the business authority for the domain.

Initial domain examples include **banking**, **hospitality/hotels**, and **regulated adult services**. The same mechanism can support additional service domains.

## Architecture

```text
TOP
SecureJDK 28 / Graal
  └─ domain applications
       ├─ banking
       ├─ hospitality
       ├─ regulated adult services
       └─ other commerce
             │
             ▼
MIDDLE
Total
  ├─ identity / provenance
  ├─ authorization evidence
  ├─ resource management
  ├─ policy enforcement
  └─ audit / evidence
             │
             ▼
GROUND
Linux / hardware / OS
```

The domain application owns the actual business operation. Total provides infrastructure for evidence, provenance, resource policy, and controlled mediation.

## Common Domain Adapter

Each domain adapter should expose a small common surface:

`identify → describe → authorize → transact → observe → retain → audit`

The adapter should be able to represent service identity, software/package identity, operator/provider identity where applicable, authorization state, transaction or reservation state, provenance, policy requirements, jurisdictional constraints, integrity evidence, lifecycle events, and audit references.

The adapter does not determine whether a person is valuable, trustworthy as a human being, or deserving of service. It reports the machine-verifiable facts and policy assertions needed by the application.

## Banking

A banking adapter can provide evidence concerning account/service identity, transaction provenance, payment authorization, service permissions, authorized fraud/risk signals, audit events, and integrity/deployment state.

Total should not independently authorize a financial transaction merely because it can observe one. The banking application and its authorized controls remain responsible for financial decisions.

## Hospitality / Hotels

A hotel adapter can represent property/service identity, reservation state, payment authorization, room/service lifecycle, guest/service-system authorization state, operational events, and provenance/audit information.

Total may use this evidence for resource and service management without becoming the reservation authority.

## Regulated Adult Services

For lawful adult or otherwise regulated services, the adapter can carry only the minimum necessary evidence for the application to establish applicable requirements, such as service/provider authorization, age or eligibility verification where legally required, consent state where the application is responsible for recording it, payment provenance, jurisdictional restrictions, licensing/compliance state, and service lifecycle/audit events.

The adapter must **not** infer consent from payment, identity, presence, or prior behavior. Consent and other human decisions remain application/domain matters and must be represented according to applicable law and policy.

The system should avoid unnecessary retention of sensitive personal information. Where a proof of eligibility can be represented as a signed assertion without retaining the underlying identity document, the minimal assertion is preferred.

## Protected / Regulated Commerce

Other regulated services can use the same adapter for licensing, eligibility, identity, authorization, transaction provenance, compliance, and audit evidence.

A domain adapter should be enabled only when its requirements are explicitly configured and its evidence sources are trusted.

## Evidence Contract

Domain evidence enters the three-tier system through the same mechanism used elsewhere:

`input → normalization → provenance → validation → policy → action → observation → retained evidence`

Each evidence item should carry, where appropriate:

```text
source
schema/version
issued_at
expires_at
subject
jurisdiction
provenance
integrity
purpose
policy_reference
audit_reference
```

Sensitive fields should be minimized, access-controlled, and retained only for an explicit purpose and period.

## Human Boundary

The central architectural rule is:

> **Total proves and mediates the mechanism; it does not decide a person's worth, humanity, consent, or dignity.**

This keeps privileged infrastructure technically useful without allowing an operating-system service to become an inappropriate social authority.

Total can establish that an application possesses a valid authorization assertion. It cannot establish that a human being is morally authorized by the mere existence of software evidence.

## Trust and Brand Recognition

Software may be grouped by trusted descriptors, signatures, package provenance, executable identity, dependency metadata, and administrator policy. Brand names alone are insufficient.

This permits assisting software—database servers, helpers, launchers, runtime components, payment processors, protection systems, or other related services—to be represented as a software group without treating a familiar string as proof of identity.

## Privacy and Security

Domain adapters follow least privilege, purpose limitation, data minimization, explicit authorization, authenticated evidence, bounded retention, auditable policy, fail-safe behavior, and separation of business authority from infrastructure authority.

Total should receive enough evidence to perform its infrastructure function and no more.

## Relationship to the Three Tiers

**Ground** supplies facts about the operating environment.

**Middle / Total** validates, mediates, and retains appropriately scoped infrastructure evidence.

**Top / SecureJDK + Graal** implements the domain application's semantics and makes domain decisions within its authorized environment.

The same evidence can therefore enter and remain available for verification across the three proving grounds without collapsing their authority boundaries.

## Status

This is an architectural specification. Banking, hospitality, regulated-adult-service, and other domain adapters should be implemented as separate modules with their own legal, security, privacy, and functional tests. No adapter should be enabled merely because its software descriptor is recognized.
