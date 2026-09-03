# Native rebase scheduling and `.metadoc`

## Presumed meaning of `rebase`

For the Ubuntu Determinant method, **rebase is reseating work according to a known schedule**. It is not a free-form start/stop schema. A valid scheduled rebase assumes that an adequate director has filled the applicable seat and that the associated resume/record is present.

The scheduled worker relationship is then continued relative to:

- a County;
- a Worker;
- a Set Schedule.

The schedule is part of the commit chain as a plain-text **Metadoc**. The Metadoc records the identity and scheduling assertions needed to understand why a work seat is being reseated and how subsequent work remains related to the County and Worker.

## `.metadoc` format

Metadocs are UTF-8 plain-text files with the `.metadoc` extension. They are deliberately human-readable and line-oriented rather than JSON or binary.

The presumed canonical fields are:

```text
METADOC-VERSION: 1
DATE: <YYYY-MM-DD>
TIMESTAMP: <ISO-8601 timestamp>
COUNTY: <county reference>
WORKER-ID: <worker reference>
SET-SCHEDULE: <schedule reference>
DIRECTOR-ID: <director reference>
SEAT: <seat reference>
RESUME: <resume reference>
TAX-ID: <tax identifier or PRESUMED/UNSET>
STUDENT-ID: <student identifier or PRESUMED/UNSET>
IQ: <declared numeric value or PRESUMED/UNSET>
CONSERVATORY-ID: <conservatory reference or PRESUMED/UNSET>
MENTOR-ID: <mentor reference or PRESUMED/UNSET>
GOLD-COIN: <declared value/reference or PRESUMED/UNSET>
TAX-LAWYER-ID: <tax-lawyer reference or PRESUMED/UNSET>
PARENT-COMMIT: <commit object id>
REBASE-RELATION: <schedule-relative continuation>
STATUS: <scheduled|seated|continuing|complete>
```

The values above are **references or declared attributes**, not credentials. The implementation must not manufacture a tax ID, student ID, government identifier, or other real-world identity value. Unknown fields are represented explicitly as `PRESUMED/UNSET` until supplied by an authorized process.

## Commit-chain rule

A Metadoc belongs to the commit chain as scheduling metadata. Its `PARENT-COMMIT` identifies the commit from which the reseating operation proceeds. A later rebase can therefore establish a deterministic relationship between:

`County -> Worker -> Set Schedule -> Seat/Resume -> Commit`

The Metadoc does not replace Git's author, committer, signature, or object identity. It is an additional project-level record describing the scheduling context of the rebase.

## No start/stop schema

The new model intentionally does **not** require a start schema or stop schema. The controlling concept is the known schedule and the adequacy of the filled seat/resume. Continuation is derived from the County, Worker, and Set Schedule relationship.

## Privacy and integrity

Metadocs should contain references rather than unnecessary personal information. Sensitive identifiers must be supplied only where the surrounding system is authorized to retain them. Git object integrity remains authoritative: a Metadoc cannot alter commit ancestry or override repository policy.

The first source-level implementation is intended to define the data contract. Native `builtin/rebase.c` integration should be added separately so ordinary Git rebase behavior is not changed accidentally before the scheduling semantics are fully implemented.
