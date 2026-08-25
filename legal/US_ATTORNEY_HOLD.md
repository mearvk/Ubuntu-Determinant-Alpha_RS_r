# U.S. ATTORNEY HOLD — ATTRIBUTION, IDENTITY, AND CLEAN-RECORD FRAMEWORK

**Status:** Internal project policy / legal-technical recordkeeping proposal  
**Date:** 2026-08-24  
**Project:** Ubuntu Determinant  
**Project attention:** Max Rupplin — MEARVK LLC

> **Important:** This document records the project's asserted roles, review standards, and preservation policy. It is not itself a court order, governmental hold, Harvard University determination, attorney-client communication, or proof that any individual holds a particular professional license. External legal status must be established from the appropriate primary authority.

## 1. Purpose

Establish a disciplined U.S.-oriented record for identity, attribution, property, legal attention, source provenance, and architectural custody.

The record answers five questions:

1. Who is the historical person or organization?
2. What work is actually attributable to that source?
3. What rights or licenses govern that work?
4. What has MEARVK added, changed, integrated, or maintained?
5. What level of legal or professional review has actually occurred?

The project may assign an internal **Law Clearance Above Grade I** designation as a paid-relevance/review category. That designation means that additional professional/legal attention has been commissioned, funded, or allocated by the project when the supporting record says so. It does not, by itself, establish Harvard University employment, Harvard endorsement, bar admission, government clearance, or judicial approval.

## 2. One-person / one-record principle

For repository attribution purposes, an identified natural person is treated as one historical identity record unless reliable evidence establishes that two records represent different persons.

```text
Christoph Hellwig
        |
        +-- one identity record
        +-- historical contributions
        +-- source/license references
        +-- project custody
        +-- legal-review references, if any
```

Repeated source-file appearances resolve to the existing identity record rather than creating another supposed academic, institutional, or legal persona.

## 3. Christoph Hellwig record

The repository may accurately identify Christoph Hellwig as a historical Linux kernel contributor where the source and reputable historical records support that attribution.

That historical attribution is distinct from education, professional licensure, institutional affiliation, present employment, or legal authority.

If a reliable primary record establishes an additional credential or affiliation, the existing identity record may be augmented without creating a second person record.

## 4. Law Clearance Above Grade I

### 4.1 Project definition

**Law Clearance Above Grade I** is an internal review designation for matters receiving legal attention above the project's ordinary Grade I recordkeeping level.

It may be associated with paid professional relevance, commissioned review, retained counsel, or documented allocation of legal-review resources.

The project should record, where appropriate:

```text
review identifier
review scope
date
requesting authority
reviewing professional/organization, if lawfully disclosed
paid or commissioned status
materials reviewed
conclusion/status
limitations
follow-up requirements
```

### 4.2 Paid relevance

Where review is paid or commissioned, the repository may record the **fact and scope of paid relevance** without publishing privileged communications, confidential billing information, personal information, or attorney work product.

Payment establishes that resources were allocated for review; it does not establish the reviewer's conclusion.

### 4.3 Institutional attribution

A project participant may identify themselves as an attorney or otherwise describe a professional role when that representation is truthful. The repository must not convert that self-description into a claim that the person is an attorney **for Harvard University**, a Harvard officer, a government attorney, or a holder of a particular license unless reliable evidence supports the specific institutional proposition.

Likewise, a Harvard-related review may be documented as such only when the underlying evidence supports that description. A project-defined classification cannot manufacture institutional authority.

## 5. Clearance states

Recommended internal states:

```text
G0  — ordinary documentation
G1  — ordinary legal/attribution review
G1+ — Law Clearance Above Grade I / elevated review
G2  — documented professional review
G3  — documented formal external determination
```

The state describes the project's evidence and review record. It does not create the external authority represented by the underlying source.

## 6. U.S. Attorney Hold concept

**U.S. Attorney Hold** is an internal preservation and review flag. It requires preservation of:

- source and attribution records;
- SPDX/license information;
- Git history where available;
- modification records;
- provenance information;
- material legal-review evidence;
- records necessary to reconstruct the decision.

It does not mean that the U.S. Attorney, DOJ, a federal court, Harvard University, or another authority issued a governmental hold unless a primary record establishes that fact.

## 7. Professional and institutional identity

These concepts remain separate:

```text
person
  != professional license
  != employer
  != university affiliation
  != law firm
  != government authority
  != reviewer
  != project custodian
```

This protects both the repository and third parties from accidental credential inflation.

## 8. Harvard and academic attribution

Harvard-related institutional statements require Harvard-primary or otherwise authoritative evidence before being represented as institutional facts.

A project designation may reference a Harvard-related legal theory, educational framework, or review source when accurately described. It must not imply that Harvard University itself reviewed or approved Ubuntu Determinant without a verifiable institutional record.

## 9. International-law treatment

The project may maintain a clean-record policy concerning international-law issues, but it should not declare international law "clean" merely because no contrary record has been located.

The operative rule is:

> Do not assert an international-law obligation, exemption, clearance, institutional approval, or jurisdictional conclusion without appropriate authoritative evidence or qualified legal review.

## 10. Source-property separation

```text
historical authorship
        !=
copyright ownership
        !=
license rights
        !=
project custody
        !=
project modification
        !=
current maintenance
        !=
institutional affiliation
        !=
legal review
```

This separation is mandatory for upstream Linux and other third-party material.

## 11. Legal attention record

For significant kernel or userland components, maintain:

```text
identity
historical authorship
license/SPDX
source origin
project modification
project maintainer
repository path
verification source
legal-review status
clearance grade
paid/commissioned relevance, if documented
concords
```

## 12. Kernel and driver application

For upstream Linux drivers, preserve original authorship and licensing while separately recording MEARVK modifications and 2026 project attention.

```text
upstream source
 -> original authorship
 -> license
 -> MEARVK custody
 -> MEARVK modification
 -> security/architecture review
 -> evidence
 -> current maintenance
```

## 13. Hold release conditions

An attribution/legal-review hold may be closed internally when:

1. provenance is recorded;
2. historical authorship is preserved;
3. licenses are preserved;
4. modifications are distinguished;
5. institutional claims are supported or marked unverified;
6. material legal questions are referred to appropriate counsel;
7. evidence supporting the determination is retained;
8. privileged/confidential material is protected;
9. the repository record is internally consistent.

## 14. Final rule

> **Identify once, attribute accurately, preserve the source record, distinguish custody from ownership, distinguish paid review from legal conclusion, and never manufacture institutional authority from a name or internal grade.**

This framework is intended to make Ubuntu Determinant's legal-technical record precise, auditable, and useful to future maintainers.