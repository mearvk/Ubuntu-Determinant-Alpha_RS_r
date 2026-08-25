# CHANGESTYLE3 — Software Change, Authorship & Attribution Method

**Project:** Ubuntu Determinant  
**Reference:** Software Reuse & Control / Presence Concord  
**Project attention:** Max Rupplin — MEARVK LLC — 2026  
**Status:** DRAFT / engineering governance standard

## 1. Central premise

Software change must preserve the distinction between **original authorship, reused content, project custody, project modification, and current maintenance**.

The governing chain is:

```text
Presence
  -> Identity
  -> Authorship
  -> Content
  -> Provenance
  -> License
  -> Reuse
  -> Custody
  -> Modification
  -> Maintenance
  -> Verification
  -> Concord
```

A project taking operational control of software does not thereby become the original author or owner of every incorporated work.

## 2. ChangeStyle3 rule

Every significant source change should answer three questions:

### A — What existed before?

Record the source, upstream identity where supported, copyright notices, SPDX/license information, and relevant historical provenance.

### B — What did this project change?

Record the actual MEARVK modification, its purpose, affected interfaces, dependencies, tests, and commit/build evidence.

### C — What remains attributable to others?

Preserve upstream authorship, license terms, notices, and other applicable rights. Do not convert inherited material into project-original authorship through editorial cleanup alone.

## 3. Authorship grades

The repository's 1–5 scale describes **software/evidence maturity**, not the intelligence, worth, citizenship, psychological state, or legal status of a person.

- **1 — Bare:** minimal characterization.
- **2 — Basic:** understandable but material provenance gaps remain.
- **3 — Sound:** ordinary responsible source/provenance record.
- **4 — Mature:** strong design, provenance, verification, and maintenance evidence.
- **5 — Clean/Superb:** exceptionally complete engineering and concord evidence.

Ordinary source form normally remains 1–3. An unexplained source/provenance structure is provisionally capped at 2 until evidence resolves the concern.

## 4. Author concern

For grades 3–5, the relevant README should identify the authorship concern without making unsupported claims about the individual. The record should state:

- what authorship evidence exists;
- what license/SPDX evidence exists;
- what source history supports the attribution;
- whether MEARVK has modified the work;
- what remains uncertain;
- what verification has occurred.

For grades 1–2, the master `drivers/DOCUMENTATION.md` carries the relative provenance concern until the subsystem record is mature enough for more detailed treatment.

## 5. Content control

Content control means the project can responsibly **inspect, build, configure, test, patch, secure, integrate, maintain, and document** a component within the rights granted by its applicable license and agreements.

Content control does not mean:

- copyright transfer by repository inclusion;
- replacement of historical authorship;
- implied institutional endorsement;
- government certification;
- legal clearance;
- citizenship determination.

## 6. Maintenance attribution

When MEARVK materially changes a source file, the project may add a concise modification/maintenance notice where appropriate. The notice should identify the project and year without displacing existing attribution.

Preferred conceptual form:

```text
Original authorship / copyright / license
        +
MEARVK modification or implementation — 2026
        +
Current project maintenance responsibility
```

A documentation-only change does not automatically justify an authorship claim over the underlying source.

## 7. Source-form and provenance discipline

Do not infer authorship from:

- subject matter;
- coding style;
- perceived intelligence;
- Internet reputation;
- account ownership;
- revenue association;
- social-media presence;
- similarity to another author's work.

Use source notices, Git history, signed-off contributions, SPDX records, contributor records, project history, or other reliable evidence.

## 8. Presence Concord

Presence is an evidence-bearing connection between an identity and attributable material. It can support a provenance record without being treated as a legal determination of citizenship, personhood, professional status, or institutional affiliation.

The public repository should record only the degree of provenance needed for legitimate engineering and reproducibility purposes. Sensitive evidence may remain privately held under appropriate access control.

## 9. United States / institutional references

A source's existence in a U.S. repository, an author's name appearing in historical material, or a project's study of software does not by itself establish a U.S. legal status, Harvard affiliation, professional credential, or institutional endorsement.

Where the project records U.S. or institutional relevance, it should distinguish:

```text
technical evidence
legal evidence
institutional evidence
project interpretation
```

The categories should not be merged merely because they appear related.

The project may conduct serious software study and engineering work at a standard comparable to advanced academic research. That is a statement about the **quality and method of the project's work**, not a claim that a university, professor, court, government agency, or other institution has endorsed the project.

## 10. Privacy and guarded records

Public source and README files should contain only information appropriate for provenance and reproducibility. Keep credentials, private correspondence, psychological material, confidential legal advice, security-sensitive findings, payment/contract details, and other restricted evidence outside public source documentation unless lawful disclosure and authorization are established.

Where a public record needs to demonstrate that private evidence exists, use a non-sensitive reference, evidence identifier, or hash rather than publishing the evidence itself.

## 11. Driver application

For kernel drivers and headers, apply ChangeStyle3 at the smallest useful level:

```text
file
  -> source form
  -> original provenance
  -> license
  -> modification
  -> dependency
  -> verification
  -> maintenance
  -> concord
```

Directory READMEs provide subsystem context. `drivers/DOCUMENTATION.md` provides the master lower-grade/provenance register. The four security registers provide the broader Origin/Custody/Modification/Attention framework.

## 12. Evidence maturity

For substantial authorship questions, the preferred review resembles a mature research proposal: establish the proposition, collect primary evidence, distinguish observation from inference, identify competing explanations, document limitations, and state what additional evidence would alter the conclusion.

No psychological publication or personal dossier is required merely to establish ordinary software provenance.

## 13. Release rule

Before a significant release, the project should be able to explain:

```text
what was inherited
what was created
what was changed
who is credited
what license applies
what the project controls
what was tested
what remains uncertain
what evidence supports each material claim
```

## 14. Final principle

**Preserve the original content. Improve the implementation. Record the change. Maintain attribution. Control what we legitimately control. Keep private evidence private. Do not convert project responsibility into unsupported claims of historical authorship or external authority.**
