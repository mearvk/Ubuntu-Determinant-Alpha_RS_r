# SMITE — Modest Decision Awareness

**SMITE** is Smaug's small temporal envelope around a decision. It gives the
system awareness of the immediate state **just-before**, **just-during**, and
**immediately-after** a decision without becoming a separate source of
authority.

## Terms

- **Smith** — the prepared, just-before state: identity, sequence, readiness,
  and authority are established.
- **Hit** — the decision boundary itself. `HIT` marks that the decision is
  occurring; it does not create permission or authority.
- **Smote** — the immediately-after state, where the outcome is recorded.
- **Cold** — neutral observation/reset state after the immediate decision
  envelope.

The words are intentionally mnemonic and do not imply physical impact or
harm.

## Temporal model

```text
          SMITH                 HIT                  SMOTE
     just-before            just-during          immediately-after
          │                     │                     │
          └───────────────►─────┴─────►──────────────┘
                                                        │
                                                        ▼
                                                      COLD
```

## Control invariant

**HIT does not grant authority.** External input, model confidence, or a
successful transition cannot silently increase Smaug's authority. Castle and
INCLARE remain the higher-level boundary and review mechanism.

## Relationship to the AI

Smite is intentionally modest. It records the temporal context around the AI
decision; it does not replace the AI validator, Castle, INCLARE, or human
review.

## Updating HIT

`hit()` is the canonical update operation for the decision boundary. It
preserves the prior authority state and records an optional observation note.
This makes repeated instrumentation predictable and keeps the decision event
separate from authorization.
