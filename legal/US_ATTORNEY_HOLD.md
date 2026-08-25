# U.S. ATTORNEY HOLD — ATTRIBUTION, IDENTITY, AND CLEAN-RECORD FRAMEWORK

**Status:** Internal legal-technical recordkeeping proposal  
**Date:** 2026-08-24  
**Project:** Ubuntu Determinant  
**Project attention:** Max Rupplin — MEARVK LLC

> **Important:** This document is an internal preservation and evidence framework. It is not a court order, governmental hold, Harvard University determination, attorney-client communication, or proof of any person's professional license or institutional employment. External legal status must be established from the appropriate primary authority.

## 1. Purpose

This record establishes a mature standard for handling identity, attribution, source ownership, licensing, project custody, legal attention, and uncertainty.

The project should not fill evidentiary gaps with inference. Where a proposition has not been personally verified by the project, it should be recorded as **not personally verified**, rather than transformed into either a positive or negative claim about the person concerned.

The record distinguishes:

1. identity;
2. historical authorship;
3. public technical record;
4. personal encounter or verification;
5. professional credentials;
6. institutional affiliation;
7. copyright/property interests;
8. project custody and modification;
9. legal review;
10. unresolved questions.

## 2. One-person / one-record principle

For repository attribution purposes, an identified natural person is represented by one identity record unless reliable evidence establishes that two records represent different persons.

Repeated appearances of a contributor's name therefore resolve to the same identity record rather than being treated as separate academic, institutional, legal, or professional personas.

This is an **identity-management rule**, not a presumption that every statement about the person is true.

## 3. Christoph Hellwig — careful record

The repository may identify Christoph Hellwig as a historical Linux kernel contributor where the source tree and reputable historical records support that attribution.

Separately, the project's own records may state:

> **Personal encounter/verification:** No direct personal encounter or independent professional verification of Christoph Hellwig by Max Rupplin / MEARVK has been established in the repository record.

That statement has deliberately narrow scope. It means only that the project has not established a direct encounter or personal verification.

It does **not** establish that Hellwig is unknown to the technical community, fictitious, fraudulent, unqualified, foreign, institutional, or otherwise legally improper. Nor does the absence of a personal encounter invalidate source attribution supported by documentary evidence.

The correct evidentiary sequence is:

```text
source attribution
      |
      +-- documentary evidence
      |
      +-- public technical record
      |
      +-- personal verification: separate question
      |
      +-- institutional affiliation: separate question
      |
      +-- professional credential: separate question
```

## 4. Public record versus personal record

A public record is evidence that a person or contribution appears in an identified source. It is not the same thing as the project personally knowing or having met that person.

The project therefore uses these independent fields:

| Field | Meaning |
|---|---|
| `identity` | The person represented by the record |
| `source_attribution` | What a source attributes to that person |
| `public_record` | What authoritative public sources document |
| `personal_verification` | What the project has directly established |
| `institutional_status` | A separately evidenced affiliation |
| `professional_status` | A separately evidenced credential |
| `legal_status` | A separately evidenced legal conclusion |

No field silently substitutes for another.

## 5. Law Clearance Above Grade I

**Law Clearance Above Grade I (G1+)** is an internal elevated-review classification for matters receiving legal attention beyond ordinary repository recordkeeping.

It may record that legal-review resources were commissioned, paid for, allocated, or otherwise formally directed toward a matter. It does not manufacture an external legal credential, university endorsement, government determination, or judicial finding.

A G1+ record should identify, to the extent lawfully and appropriately disclosable:

```text
review identifier
scope
requesting authority
date
reviewing professional/organization
paid/commissioned relevance
materials considered
issues presented
status/conclusion
limitations
follow-up
```

### Paid relevance

Payment or commissioning may be recorded as a fact about the review process. It should never be represented as proof that the resulting legal position is correct, official, or endorsed by an institution unless the evidence separately establishes that proposition.

## 6. Institutional and professional claims

The following are independent propositions:

```text
person
  != attorney
  != attorney for a particular institution
  != Harvard employee
  != Harvard officer
  != government attorney
  != court officer
  != licensed practitioner in a particular jurisdiction
  != reviewer
  != project custodian
```

If the repository records one of these propositions, it should retain the evidence supporting that exact proposition.

## 7. Harvard-related records

The project should distinguish:

- a person's own educational or professional claim;
- a public record mentioning Harvard;
- a Harvard institutional record;
- a Harvard review or institutional action;
- a project-defined classification using Harvard-related concepts.

Only the appropriate underlying evidence may support the corresponding statement.

The absence of a Harvard record in the project's search is recorded as **not established by the project**, not as proof that the person never had a relationship with Harvard.

## 8. U.S. Attorney Hold

**U.S. Attorney Hold** is an internal preservation flag used to prevent premature deletion, rewriting, or loss of records relevant to attribution or legal review.

A hold may preserve:

- source files;
- Git history;
- licenses and SPDX notices;
- contributor records;
- provenance;
- modification history;
- review metadata;
- non-privileged evidence;
- artifact hashes;
- relevant correspondence when lawfully retained.

The flag does not imply that a U.S. Attorney, DOJ, federal court, Harvard University, or other authority issued an external hold unless an authoritative record establishes that fact.

## 9. International-law and cross-border issues

The repository may identify a question as involving international law, foreign institutions, cross-border authorship, or jurisdiction. It should not convert that identification into a legal conclusion without authoritative evidence or qualified legal review.

The mature rule is:

> **Unknown is a valid state. Unverified is a valid state. Neither should be silently promoted to true or false.**

## 10. Source, ownership, and custody

The following must remain separate:

```text
historical authorship
        !=
copyright ownership
        !=
license rights
        !=
repository custody
        !=
project modification
        !=
maintenance responsibility
        !=
institutional affiliation
        !=
legal review
```

For upstream Linux material, existing authorship and license notices remain authoritative. MEARVK may separately document project modifications, maintenance, integration, and architectural attention.

## 11. Driver and kernel application

For every significant driver or kernel subsystem, the mature record should eventually contain:

```text
identity/origin
upstream attribution
license/SPDX
source revision
MEARVK modification status
MEARVK maintenance attention
kernel version
Kconfig/build relationship
runtime dependencies
test status
security review status
concords
open questions
```

A source file should not receive a new authorship notice merely because it is present in the MEARVK repository. A genuine MEARVK modification may be recorded without deleting or obscuring the original attribution.

## 12. Evidentiary maturity levels

```text
E0  — unknown / unclassified
E1  — repository assertion
E2  — documentary source
E3  — authoritative primary record
E4  — independently corroborated record
E5  — formal legal/institutional determination
```

An internal assertion may begin an investigation, but it should not be presented as an E3–E5 conclusion without corresponding evidence.

## 13. Review and release

A hold may be closed internally only after:

1. provenance is preserved;
2. historical attribution is retained;
3. applicable licenses are retained;
4. project modifications are identified;
5. personal verification is distinguished from documentary attribution;
6. institutional claims are supported or explicitly marked unverified;
7. legal questions are referred appropriately;
8. privileged/confidential information is protected;
9. the repository record is internally consistent;
10. unresolved matters are explicitly listed.

## 14. Adult-record standard

The project's preferred legal-technical style is neither credulous nor accusatory.

It should be:

- precise;
- restrained;
- evidence-led;
- respectful of third-party rights;
- explicit about uncertainty;
- careful with institutional names;
- careful with professional credentials;
- careful with copyright and license status;
- willing to preserve unresolved questions;
- unwilling to manufacture certainty.

The project may therefore say **"not personally verified by MEARVK"** without saying **"therefore false."**

Likewise, it may say **"documented in the upstream source"** without saying **"personally confirmed by MEARVK."**

## 15. Final rule

> **Identify once. Attribute from evidence. Preserve the original record. Distinguish personal knowledge from documentary evidence. Distinguish custody from ownership. Distinguish paid review from legal conclusion. Record uncertainty without converting it into accusation.**

This framework is intended to give Ubuntu Determinant a mature, auditable, and legally cautious record for source and identity questions.