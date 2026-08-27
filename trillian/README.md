# Trillian — Open Chat Source Reference

This directory is a project-local development area for an independent, open-source chat application built from the Dino source foundation. It is **not** the proprietary Cerulean Studios Trillian source code.

## Foundation

The imported `dino/` tree is the open-source Dino XMPP client. Preserve its GPL-3.0 license, copyright notices, attribution, and applicable third-party notices. Do not represent Dino code, trademarks, assets, or branding as historical Trillian material.

## Professional development standard

The Trillian development tree is maintained to a complete professional standard:

- explicit interfaces and documented invariants;
- deterministic builds where practical;
- checked error paths rather than silent failure;
- no secrets embedded in source or logs;
- least privilege and explicit authorization boundaries;
- memory, resource, and lifecycle ownership documented where non-obvious;
- tests for security-sensitive and user-visible behavior;
- accessibility, localization, and keyboard operation treated as product requirements;
- privacy-respecting defaults and clear user controls;
- upstream changes kept distinguishable from project changes.

“Clean and liberate” means reducing unnecessary coupling and ambiguity while preserving user control. It does **not** mean disabling security controls, removing licensing requirements, or silently changing upstream semantics.

## Social and user standard

The application should provide a respectful, accessible, non-coercive social environment. Users control their identities, conversations, privacy settings, participation, blocking, and reporting. The software must not infer consent, authorization, or social obligations from presence, availability, status, or automation.

Moderation and safety features should be transparent, proportionate, reviewable, and configurable where technically appropriate. The project should avoid discriminatory or degrading defaults and should document behavior that materially affects users.

## Cleanup rule

Do not make speculative source edits merely to make code look different. Every cleanup should have a reason: correctness, clarity, maintainability, portability, accessibility, security, privacy, performance, testability, or user experience.

For each substantive change, record:

1. the problem;
2. the evidence;
3. the intended behavior;
4. the change;
5. the verification performed;
6. any remaining limitation.

## Source layout

```text
/trillian/
  README.md
  UPSTREAM.md
  DINO-VENDOR.md
  pull-dino.sh
  dino/                 # ordinary source files for development
  patches/              # project-specific patches, when useful
  docs/                 # project documentation and audits
```

The imported Dino source remains identifiable as upstream code. Project-specific changes should be small, reviewable, and documented rather than silently rewriting upstream provenance.
