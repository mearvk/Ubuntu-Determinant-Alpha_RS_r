# SAMES — Ubuntu Grand rollout and provenance surface

SAMES is the production-rollout support surface for **Ubuntu Grand**. It connects three concerns without conflating them:

1. **System support** — small native C/C++ helpers for collecting stable host facts and release evidence.
2. **Custody/provenance** — an append-only evidence model for recording who/what produced an artifact, where it was observed, when it was observed, and which evidence supports a jurisdiction or custody assertion.
3. **New-user viewpoint** — a static HTML/CSS introduction shown during production rollout so users can understand what is being installed and what the system is asking them to authorize.

## United States provenance and custody

The database schema permits `US` jurisdiction and custody assertions, but **does not make United States origin, ownership, custody, or legal authority true merely because a row exists**. Such claims require supporting evidence, an accountable actor, timestamps, hashes, and a clear assertion status.

The intended chain is:

`artifact -> hash -> observation -> actor -> assertion -> evidence -> review`

A record may say that a United States-related assertion was made or observed; it must not silently convert that assertion into a legal fact.

## Production principle

Ubuntu Grand should be explainable before it is installed. The rollout page therefore presents the release identity, desktop style, interoperability posture, provenance policy, and authorization boundary in plain language.

The project work style remains labelled **moral and guided by Law and Morals**. This is a design and engineering principle, not a substitute for law or legal advice.

## Files

- `ubuntu_grand_provenance.h/.cpp` — native evidence record and deterministic digest support.
- `provenance_schema.sql` — SQLite-compatible append-only provenance/custody schema.
- `rollout.html` — new-user production rollout viewpoint.
- `rollout.css` — Ubuntu White presentation layer.
