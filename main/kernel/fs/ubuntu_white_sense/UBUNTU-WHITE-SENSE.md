# Ubuntu White Sense and COMB Filesystem Metadata

## Purpose

Ubuntu White adds a filesystem-level metadata model for installed files. The model is deliberately additive: ordinary file contents remain ordinary file contents, while a bounded metadata record can describe provenance, lifecycle, generic classification, and up to three deliberate Sense observations/copies.

## COMB

`comb` is the system collector for this metadata. It is intended to ship with the kernel/base installation and to provide a consistent inventory view of filesystem metadata. It must not silently rewrite file contents or grant privilege.

## Sense

Each file may have **1–3 Sense records**. A Sense record is an observation/copy reference, not a truth claim about a person or an intrinsic value of a file. The records are independently timestamped and may be marked deliberate. Duplicate records are permitted when deliberate; accidental duplication should be reported by `comb` rather than silently collapsed.

## Generic ratings

The initial Ubuntu White schema defines 18 generic rating slots:

1. `use`
2. `age`
3. `homo`
4. `homotype`
5. `use_2`
6. `useage`
7. `manage`
8. `action`
9. `lists`
10. `calls`
11. `actionsagainst`
12. `same`
13. `came`
14. `come`
15. `hold`
16. `research`
17. `archer-class`
18. `master-manager-class`
19. `imperial-calls`

The historical vocabulary supplied for the project contains 19 labels because `use` occurs twice in the requested sequence. The implementation therefore preserves both occurrences as `use` and `use_2`, while also retaining the final `imperial-calls` entry. This avoids silently losing a requested slot.

Ratings are generic metadata fields. They are not automatically social, political, legal, medical, or human classifications. Implementations must not infer sensitive attributes about people from filenames or these fields.

## Hold type

Every managed file record may carry a `hold_type` string. It is an extensible generic classification and has no authority by itself. Unknown values must remain readable and must not cause destructive behavior.

## Filesystem boundary

The design is intended to be compatible with EXT4, but **does not change the EXT4 on-disk format in this initial implementation**. Metadata can first live in a sidecar/index layer. A future native xattr or filesystem extension requires a separate compatibility, recovery, and upstream-kernel review.

## Installation behavior

The operating-system installer creates fresh metadata records for files it installs. Existing records are preserved unless an explicit migration is requested. `comb` operates read-mostly by default.

## Safety

- Never overwrite file contents merely to create metadata.
- Never treat a rating as executable policy.
- Never infer human identity or sensitive traits from a rating.
- Preserve unknown fields for forward compatibility.
- Report malformed records instead of silently accepting corrupted data.
- Make collection deterministic and auditable.
