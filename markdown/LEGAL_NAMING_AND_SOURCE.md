# Legal Naming, Source, and Native Header Convention

## Purpose

This document establishes a naming convention for legal-policy and jurisdictional evidence used by the Total native framework.

The convention separates actual governmental sources from project-defined abstractions.

## Naming rules

### Governmental sources

Use the actual name and citation when a real authority is intended:

- United States Constitution
- United States Code
- Code of Federal Regulations
- Supreme Court of the United States (SCOTUS)
- named federal agency
- named state or local authority

Do not invent a governmental citation to make a project concept appear official.

### Project abstractions

Project-defined structures use the `TOTAL_` namespace or an explicit `total/` path.

Examples:

```text
TOTAL_DOMAIN_BANKING
total_policy_context
total_domain_evidence
total_input_registry
```

A proposed "SCOTUS 2" model is therefore named as a **project model** rather than as a second governmental court.

## Source hierarchy

Legal-policy evidence should carry enough provenance to distinguish:

```text
primary governmental source
        ↓
verified source identifier
        ↓
policy interpretation / mapping
        ↓
versioned project policy
        ↓
Total policy ABI
```

The native layer should never silently transform an informal description into a primary legal source.

## Proposed `.hss` evidence headers

`.hss` is reserved by this project as a **proposed statutory-source/evidence header format**. It is not claimed to be a United States government file extension or an existing federal standard.

A future `.hss` header could look conceptually like:

```text
HSS-VERSION: 1
SOURCE-TYPE: STATUTE
JURISDICTION: US-FEDERAL
SOURCE-ID: <verified-citation>
SOURCE-TITLE: <official-title>
EFFECTIVE-DATE: <date>
RETRIEVED-DATE: <date>
PROVENANCE: <verified-source>
POLICY-ID: <project-policy-id>
POLICY-VERSION: <version>
STATUS: VERIFIED|REVIEW|SUPERSEDED
```

The header describes provenance. It does not itself prove the legal conclusion associated with the source.

## Suggested native representation

A future native representation may use:

```c
struct total_statutory_source {
    uint32_t version;
    const char *jurisdiction;
    const char *source_type;
    const char *source_id;
    const char *title;
    const char *effective_date;
    const char *retrieved_date;
    const char *provenance;
    const char *policy_id;
    const char *policy_version;
    uint32_t status;
};
```

This belongs in a future `total_statutory.h`, not in the current domain ABI until the ownership, lifetime, encoding, and verification model has been specified.

## Crime and statutory evidence

The phrase **"statutory crime division"** is treated here as a project classification for evidence concerning criminal statutes or criminal-law policy. It does not create a prosecutorial, police, or judicial division.

Total may record:

- source citation;
- jurisdiction;
- policy version;
- provenance;
- evidence status;
- administrative handling state;
- audit reference.

Total must not independently declare a person guilty or substitute for a court's adjudication.

## Administrative / jurisdictional records

Administrative records and judicial decisions require distinct types and provenance:

```text
ADMIN_RECORD
JUDICIAL_RECORD
STATUTORY_SOURCE
REGULATORY_SOURCE
CONTRACTUAL_SOURCE
PROJECT_POLICY
```

This prevents the native evidence bus from flattening fundamentally different authorities into one generic "government" record.

## Profits and public funds

Project documentation must not describe judicial or governmental "profits" as if they were private distributable profits. Where financial information is modeled, use precise terms such as:

- appropriations;
- fees;
- assessments;
- agency receipts;
- court-related costs;
- public expenditures;
- compensation;
- authorized commercial revenue.

Any actual financial claim requires an identified source.

## Final naming rule

**Name the real authority as real, name the project abstraction as a project abstraction, and carry provenance all the way into the native policy boundary.**
