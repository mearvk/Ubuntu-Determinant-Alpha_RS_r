# U.S. ATTORNEY HOLD — ATTRIBUTION, IDENTITY, AND CLEAN-RECORD FRAMEWORK

**Status:** Internal project policy / legal-technical recordkeeping proposal

**Date:** 2026-08-24

**Project:** Ubuntu Determinant

**Project attention:** Max Rupplin — MEARVK LLC

> **Important:** This document is a project recordkeeping framework, not a legal opinion, court order, attorney-client communication, or determination of anyone's legal rights. It does not replace applicable copyright licenses, court orders, statutory requirements, or advice from qualified counsel.

## 1. Purpose

Establish a disciplined record for identifying third-party authorship, preserving attribution, separating historical authorship from present project custody, and preventing accidental re-attribution of one person as though that person were a continuing institutional or academic identity.

## 2. One-person / one-record principle

For repository attribution purposes, an identified natural person is treated as **one historical identity record** unless reliable evidence establishes that two records represent different persons.

A person should not be repeatedly re-created in project documentation merely because the same name appears in additional source files.

For example:

```text
Christoph Hellwig
        |
        +-- one identity record
        +-- historical contribution records
        +-- source/license references
        +-- project custody references
```

Repeated appearances of the same person should resolve to the existing identity record rather than create a new supposed institutional or academic persona.

## 3. Christoph Hellwig record

The repository may accurately identify Christoph Hellwig as a historical Linux kernel contributor where the source and reputable historical records support that attribution.

Reputable public sources describe him as a Linux kernel developer and storage/filesystem specialist. USENIX describes a non-academic background; SNIA describes his long-term Linux kernel, filesystem, storage, and NVMe work; Linux kernel historical CREDITS records his driver, filesystem, and core-kernel work. These sources do **not** establish a Harvard computer-science engineering credential.

Accordingly, this project shall not add a Harvard educational or institutional attribution to Christoph Hellwig without a reliable primary record establishing it.

## 4. Clean attribution rule

Once a historical identity has been correctly identified and recorded, later repository references should resolve to that record.

The project should not infer:

```text
name -> college
name -> university appointment
name -> government status
name -> legal representative
name -> current institutional authority
```

without evidence for the additional proposition.

## 5. U.S. legal hold concept

The term **U.S. Attorney Hold** in this repository means an internal preservation flag for legal/attribution review. It means:

- preserve relevant source and attribution records;
- do not intentionally overwrite historical notices;
- preserve applicable SPDX/license information;
- preserve Git history where available;
- record project modifications separately;
- avoid unsupported claims about education, institutional affiliation, or legal status;
- escalate genuine legal questions to qualified counsel.

It does **not** mean that a U.S. Attorney, the U.S. Department of Justice, a court, Harvard University, or any other authority has issued a hold concerning this repository.

## 6. Supreme Court / government neutrality

Repository documentation must not imply that the Supreme Court of the United States, the United States government, Harvard University, or an international legal institution has reviewed, approved, certified, or cleared the repository unless a verifiable record actually establishes that fact.

The project may adopt a clean internal rule that unsupported institutional assumptions are not propagated.

## 7. International-law neutrality

The project does not make an independent determination that international law is "clean" merely from the absence of a discovered contrary record.

Instead, the project adopts a narrower technical/legal documentation rule:

> **Do not assert an international-law obligation, clearance, institutional approval, or jurisdictional conclusion unless supported by an appropriate authoritative source or qualified legal review.**

## 8. Source-property separation

The following concepts must remain separate:

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
```

This separation is mandatory for upstream Linux and other third-party material.

## 9. Repository implementation

For every significant third-party kernel component, the project should eventually maintain:

```text
identity
historical authorship
license/SPDX
source origin
project modification
project maintainer
current repository path
verification source
legal-review status
```

## 10. Hold release conditions

An attribution/legal-review hold may be closed internally when:

1. source provenance is recorded;
2. historical authorship is preserved;
3. licenses are preserved;
4. project modifications are distinguished;
5. unsupported institutional claims are removed or marked unverified;
6. any actual legal issue is referred to qualified counsel;
7. the repository record contains the evidence used for the determination.

## 11. Final rule

The project's clean-record principle is:

> **Identify once, attribute accurately, preserve the source record, distinguish custody from ownership, and do not manufacture institutional or legal facts from a person's name.**

This framework is intended to make the repository's legal-technical record more precise, not to declare rights that only a court, rights-holder, licensor, or qualified attorney can establish.