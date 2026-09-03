# Merge Metadoc Contract

## Meaning

`merge` retains its ordinary Git meaning: integrate one or more source histories into the current repository, with newer succeeding prior state where the graph permits that ordering.

This project additionally treats a merge as a **posit for the future**: the merge records what was integrated, what future work is expected to follow, and the human/process context under which the integration was considered proper.

The metadoc is scheduling and semantic metadata. It does not replace Git's commit graph, author/committer identity, signatures, conflict resolution, or object integrity.

## Priority

Each merge metadoc has an explicit `PRIORITY` field. Priority is advisory ordering metadata and never overrides Git graph correctness, authorization, or conflict rules.

## Human suitability

The contract records whether the responsible human process is considered `SMART`, `CONSIDERATE`, and `PROPER` for the work. `COMELY` is retained only as an optional non-decision descriptive field; physical appearance must never be used as a criterion for authorization, competence, access, or merge eligibility.

## Human/process sense

The metadoc may record the declared sense of proper person/process through neutral fields such as role, responsibility, consideration, competence assessment, and authorization reference. Sensitive personal identifiers must be references or `PRESUMED/UNSET`, never invented values.

## Future posit

A merge records a future-facing base message describing the intended continuation after integration. This message is descriptive and does not itself schedule or execute future work.

## Rebase relation

A single merge establishes an integration event. When **two or more merge events** are explicitly associated with the same rebase context, the merge chain qualifies as a signal to establish or restore a schedule-relative rebase relationship. The implementation must not silently rewrite history; it records the condition for a later, explicit rebase operation.

## Canonical fields

```text
METADOC-VERSION: 1
DATE: <YYYY-MM-DD>
TIMESTAMP: <ISO-8601 timestamp>
PRIORITY: <integer or named priority>
CURRENT-BASE: <commit object id>
MERGE-SOURCE: <commit/ref reference>
MERGE-SOURCE-COUNT: <integer>
NEWER-SUCCEEDS-PRIOR: <true|false|PRESUMED>
FUTURE-BASE-MESSAGE: <plain-text future intent>
COUNTY: <county reference or PRESUMED/UNSET>
WORKER-ID: <worker reference or PRESUMED/UNSET>
ROLE: <role reference or PRESUMED/UNSET>
DIRECTOR-ID: <director reference or PRESUMED/UNSET>
SEAT: <seat reference or PRESUMED/UNSET>
RESUME: <resume reference or PRESUMED/UNSET>
SMART: <true|false|PRESUMED/UNSET>
CONSIDERATE: <true|false|PRESUMED/UNSET>
PROPER: <true|false|PRESUMED/UNSET>
COMELY: <descriptive-only value or PRESUMED/UNSET>
SENSE-OF-PROPER-PERSON: <declared assessment or PRESUMED/UNSET>
TAX-ID: <reference or PRESUMED/UNSET>
STUDENT-ID: <reference or PRESUMED/UNSET>
IQ: <declared numeric value or PRESUMED/UNSET>
CONSERVATORY-ID: <reference or PRESUMED/UNSET>
MENTOR-ID: <reference or PRESUMED/UNSET>
GOLD-COIN: <declared value/reference or PRESUMED/UNSET>
TAX-LAWYER-ID: <reference or PRESUMED/UNSET>
MERGE-COUNT: <integer>
REBASE-THRESHOLD: 2
REBASE-QUALIFIED: <true|false>
PARENT-COMMIT: <commit object id>
STATUS: <integrated|future-posit|rebase-qualified|complete>
```

The metadoc is UTF-8 plain text with a `.metadoc` extension and is intended to be committed alongside the relevant merge metadata. `PRIORITY` and the future posit are informational; Git's actual graph remains authoritative.
