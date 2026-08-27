# Smaug Input Sources — Player and Overtine

Smaug may receive a bounded input from either of two recognized sources:

1. **Player** — a direct user-provided request, observation, or proposed action.
2. **Overtine** — a request or observation produced by Smaug's stable companion
   layer (Constantine/Reign/Better-Be/Better-Companion-Be).

Both sources are treated as **inputs**, not automatic authority.

## Acceptance path

```text
Player ────────┐
               ├──> identify → validate → normalize → Castle/INCLARE
Overtine ──────┘                                  │
                                                  ▼
                                          decision / review
```

An input must have an identity and payload before normal acceptance. Missing
identity or payload routes to review. Acceptance does not grant authority.

## Detail and Treasure

**Detail** means retaining useful provenance: source, identity, sequence,
payload, observation digest, and resulting decision record.

**Treasure** means preserving the valuable evidence and patterns discovered by
Smaug without allowing them to become unreviewed authority. Reusable patterns
may inform the habit layer, while Castle/INCLARE continues to protect the
system boundary.

This makes Player and Overtine complementary: the Player supplies direct human
intent; Overtine supplies structured companion observations. Smaug evaluates
both through the same disciplined path.
