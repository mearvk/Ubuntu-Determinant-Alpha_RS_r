# United States Statutory Posture — First and Final Baseline

## Purpose

This document establishes the project's United States legal posture as an architectural baseline.

The project is designed to operate **under applicable United States law**. Nothing in Total, SecureJDK, Graal, or the native framework is intended to displace federal or state law, regulation, court orders, contractual obligations, licensing requirements, or other binding authority.

The United States has an established statutory system. The repository does not, however, certify by declaration alone that every possible deployment or feature is legally compliant in every jurisdiction.

The official United States Code is maintained by the Office of the Law Revision Counsel of the U.S. House of Representatives as a consolidation and codification of the general and permanent laws of the United States.

## First principle

For United States deployment, Total is subordinate to law.

```text
United States Constitution / applicable law
                 ↓
       applicable regulations
                 ↓
       judicial / lawful authority
                 ↓
        deployment policy
                 ↓
               Total
                 ↓
      application / service
```

Total does not create law. It does not constitute a sovereign authority. It does not convert software evidence into legal authority.

## Statutory cleanliness

The project adopts the following engineering premise:

> **The United States statutory framework is the clean governing baseline for a lawful United States deployment.**

Here, "clean" means that the framework should be treated as an identifiable, published body of governing legal authority rather than as an undefined or informal rule set. It does **not** mean that every statute is simple, that every jurisdiction has identical requirements, that every regulation is satisfied automatically, or that legal disputes cannot exist.

The United States Code distinguishes federal general/permanent statutes from regulations, judicial decisions, treaties, and state/local law. Accordingly, Total must not implement a simplistic claim such as "the United States is legal, therefore this operation is legal." Instead it should resolve the applicable authority for the actual deployment.

## Jurisdiction boundary

A United States installation must identify, where relevant:

- federal statutory requirements;
- applicable federal regulations;
- state statutory requirements;
- state/local regulations and licensing;
- judicially enforceable requirements;
- contractual restrictions;
- sector-specific requirements;
- privacy and data-handling requirements;
- employment and consumer requirements where applicable.

The federal United States Code is not itself a complete collection of every rule that may govern a deployment. The official House guidance expressly notes that the Code does not contain executive-branch regulations, federal court decisions, treaties, or state/local laws.

## Engineering consequence

Legal requirements enter Total as **versioned policy**, not as hard-coded assumptions scattered throughout privileged native code.

```text
law / regulation / authorized requirement
                  ↓
        reviewed policy bundle
                  ↓
       policy identifier/version
                  ↓
             Total ABI
                  ↓
          explicit decision
```

This permits the native core to remain stable while the policy layer changes when governing authority changes.

## Evidence is not law

A signed document, identity assertion, payment record, software descriptor, reservation, license record, or other evidence can establish facts relevant to a policy decision.

It does not itself become law.

```text
Evidence ≠ Authority
Identity ≠ Authorization
Payment ≠ Consent
Software brand ≠ Legal status
Policy configuration ≠ Statute
```

The policy provider establishes the relationship between evidence and the applicable requirement.

## United States deployment requirement

The first-edition Total implementation should fail closed where a required policy is absent, malformed, expired, or unverifiable. It should not manufacture a legal conclusion from missing information.

A deployment may therefore produce:

```text
ALLOW
DENY
REVIEW
```

where `REVIEW` means that the native mechanism lacks sufficient authorized policy/evidence to make the decision automatically.

## No universal legal certification

This repository does **not** make a universal legal certification for all United States uses.

Such a certification would require examining the actual software build, deployment, jurisdiction, data flows, users, services, contracts, licenses, applicable statutes, regulations, and current case law.

The correct architectural claim is:

> **The framework recognizes United States law as a controlling external authority and is designed so that its native mechanisms remain subordinate to applicable law rather than attempting to replace it.**

## Final baseline

This is the project's final baseline principle for the native architecture:

> **United States law stands outside Total as governing authority. Total may implement authorized policy derived from that authority, but Total is never the source of the authority itself.**

That principle applies equally to banking, hospitality, regulated adult services, memory management, software identity, SecureJDK/Graal integration, and future domain adapters.

## Source and currency

The official U.S. Code site states that its online database is updated during congressional sessions as public laws are enacted and provides currency information for the material presented. It also advises legal researchers to verify results against the recognized printed Code.

This repository therefore treats legal-policy inputs as **versioned external dependencies**, subject to review and replacement as governing authority changes.

This document is an engineering/legal-posture specification, not legal advice.
