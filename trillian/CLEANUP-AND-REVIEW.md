# Trillian / Dino Cleanup and Review Standard

## Status

This document is the working specification for cleaning the imported Dino source without confusing project improvements with upstream defects.

## 1. Completeness

A specification is complete when it states its purpose, inputs, outputs, failure behavior, security/privacy implications, user-visible behavior, and verification method. Unknown behavior must be marked as unknown rather than implied.

## 2. Professional engineering

Code should favor explicit ownership, bounded lifetimes, checked errors, deterministic state transitions, small interfaces, useful diagnostics, tests, and maintainable documentation. Avoid cosmetic rewrites that add churn without improving one of these properties.

## 3. Error handling

Errors must be classified rather than hidden:

- **Build error:** prevents configuration or compilation.
- **Test error:** reproducible test failure.
- **Runtime error:** reproducible incorrect or unsafe behavior.
- **Security issue:** confidentiality, integrity, authentication, authorization, or availability impact.
- **UX/accessibility issue:** materially harms usability or access.
- **Documentation/specification gap:** behavior is insufficiently defined.
- **Upstream limitation:** intentional or inherited behavior that is not itself a defect.

No issue is pronounced as a defect without evidence.

## 4. Security and privacy

Never weaken authentication, encryption, certificate validation, authorization, sandboxing, or privacy controls merely for convenience. Secrets must not be committed, logged unnecessarily, or exposed through diagnostics. User data should have clear retention and deletion behavior.

## 5. Social quality

Chat software is social infrastructure. Respectful language, accessibility, privacy, blocking, reporting, consent, and user agency are product requirements. Presence, availability, read receipts, or automation must never be treated as permission for unwanted interaction.

## 6. Accessibility and inclusion

User-visible controls should have labels, keyboard access, sensible focus behavior, adequate contrast, localization support, and understandable error messages. Avoid assumptions about disability, identity, language, or social role.

## 7. Upstream boundaries

Dino remains identifiable as upstream GPL-3.0 software. Changes made in this repository should be reviewable and attributable. Do not rewrite upstream copyright, licensing, or provenance information.

## 8. Verification gate

Before declaring a cleanup complete:

1. inspect the affected code;
2. build the affected target;
3. run applicable tests;
4. review warnings and diagnostics;
5. exercise failure paths;
6. review security/privacy implications;
7. document anything that could not be verified.

## Consensus

The target state is **clean, professional, secure, accessible, socially responsible, and maintainable**. “Liberate” means reducing unnecessary coupling and ambiguity while preserving user control, upstream licensing, and security boundaries.
