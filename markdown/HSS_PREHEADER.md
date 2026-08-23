# HSS — Human/System Surface Pre-Header

**Status:** First-edition project specification

## Purpose

`.hss` is a proposed, language-neutral **pre-header** for notional system traffic, evidence, and interface metadata. It precedes the ordinary logical layer represented by C/C++ `.h`, `.hpp`, Python modules, Perl packages, Java classes, shell programs, configuration files, or other software surfaces.

HSS does not replace a programming-language header. It supplies a soft semantic envelope before language-specific parsing and execution:

```text
HSS pre-header
     ↓
source / module / executable
     ↓
language parser
     ↓
logical program
     ↓
service
```

The HSS layer is descriptive and evidentiary first, rather than executable by default.

## Design principle

HSS answers questions ordinary headers do not necessarily answer: what an artifact is, who or what claims to provide it, what system or jurisdiction it describes, what evidence accompanies the claim, what capabilities it requests, what dependencies it declares, what policy profile is intended, and what is asserted versus independently verified.

> **Description precedes execution; evidence precedes authority.**

An HSS file never grants authority merely because a field says that authority exists.

## First-edition syntax

The first edition uses simple records suitable for tooling in C, C++, Python, Perl, Java, Rust, shell, and other languages.

```text
hss: 1
kind: module
name: example.service
version: 1.0
language: c
source: local
provenance: declared
jurisdiction: US
purpose: service
capabilities: memory.observe, process.observe
requires: total >= 1
policy: total/default-v1
evidence: local-descriptor
integrity: unverified
authority: none
```

Unknown fields should be treated as extensions unless a later HSS profile explicitly makes them mandatory.

## Core fields

`hss`, `kind`, `name`, `version`, and `language` identify the descriptor and artifact.

`source`, `provenance`, and `integrity` describe origin and confidence. Suggested integrity states are `unverified`, `observed`, `validated`, `signed`, and `attested`. These are evidentiary states, not legal conclusions.

`jurisdiction` identifies the relevant legal/policy environment. `US` means United States context; it does **not** mean every applicable federal, state, local, regulatory, contractual, or judicial requirement has been satisfied.

`capabilities` declares requested or supported capabilities; it does not grant them. A runtime or Total must separately authorize capabilities.

`requires` describes expected dependencies, versions, or service relationships. It is not proof that a dependency is installed or trustworthy.

`evidence` names supporting evidence classes or references. Future profiles may reference signed descriptors, package manifests, statutory sources, administrative records, judicial records, build attestations, and runtime observations.

`authority` is explicit. First-edition values are `none`, `declared`, `verified-policy`, and `runtime-granted`. HSS cannot manufacture governmental or judicial authority.

## Notional U.S. traffic

For Total, HSS provides a common envelope around traffic or state moving among:

```text
application ↕ runtime / JVM / interpreter ↕ Total ↕ OS / kernel ↕ trusted external service
```

An HSS descriptor may accompany an event, request, package, service declaration, administrative record, or software artifact. It need not be transmitted on every packet; implementations may compile or serialize it into a smaller representation.

## Cross-language benefit

HSS is deliberately language-neutral:

```text
example.hss + example.hpp + example.cpp
example.hss + example.py
example.hss + example.pl
example.hss + Example.java
```

It provides a common semantic envelope without forcing languages to share a type system.

## Relationship to `.h` and `.hpp`

`.h` and `.hpp` primarily describe **how code is declared to a compiler**. `.hss` primarily describes **what the artifact claims to be and what context accompanies it**.

```text
.hss  → semantic/provenance pre-header
.h    → C/C interface
.hpp  → C++ interface
.py   → Python implementation
.pl   → Perl implementation
.java → Java implementation
```

HSS should not duplicate language-level declarations.

## Security model

HSS is metadata and evidence infrastructure and must be parsed defensively. Implementations should bound field lengths, reject malformed mandatory fields, never execute HSS content, distinguish declared from verified information, avoid treating names as proof of identity, avoid treating identity as authorization, authenticate signed references before trusting them, preserve unknown extensions, fail closed when required evidence cannot be verified, and record policy decisions separately from original declarations.

## Relationship to Total

Total can consume HSS as one evidence input:

```text
HSS → parse → normalize → provenance → validate → Total policy → controlled action
```

HSS is therefore a **soft front door** to the three-tier model without becoming privileged authority itself.

## Statutory-source extension

HSS may identify source classes such as:

```text
statute
regulation
judicial-record
administrative-record
contract
policy
```

A reference identifies a source. It does not transform software into law, a court, an administrative agency, or a prosecutor.

## 200+ IQ design criterion

The project's informal “200+ IQ” language is treated as a design aspiration: high structural compression, explicit semantics, low ambiguity, strong provenance, and composability across languages. It is **not** a scientific measurement of software or a claim about human intelligence.

The sophistication is intended to come from keeping the pre-header small while allowing evidence and policy layers beneath it to become rich.

## Versioning

The first field remains:

```text
hss: 1
```

Future versions should preserve backward readability where possible. New semantics should be introduced through versioned profiles rather than silently changing existing field meanings.

## First-edition boundary

HSS does not yet define a cryptographic signature format, canonical binary serialization, universal governmental standard, packet-wire protocol, legal certification mechanism, automatic authority delegation, or replacement for language headers.

## Final credo

**HSS precedes the program, but does not command the program. It describes the evidence surrounding a program so that the program can be understood before it is trusted.**
