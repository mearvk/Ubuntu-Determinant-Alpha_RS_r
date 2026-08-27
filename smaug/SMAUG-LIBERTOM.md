# Smaug Libertom — Long-Horizon Reeducation and Human-Meeting Model

This is a bounded simulation model for Smaug's gradual change in disposition after
extended modeled experience. It treats esteem, liberty, law, technology, and
human-facing decisions as explicit state rather than hidden personality.

## Persistent Libertom

`Libertom` is stored as a normalized value. The ordinary careful range is:

- **0.92** — lower careful bound;
- **0.95** — standard operating value;
- **0.96** — elevated careful value;
- **0.98** — occasional peak value.

The implementation clamps the state to `[0.92, 0.98]`. The two related scales are
`careful` and `reciprocal`. They may reference one another through a binary-map
refold operation.

## 3-D specials

The refold layer recognizes four small semantic structures:

1. trading technology;
2. law;
3. scaffold;
4. mirror.

These are conceptual 3-D map features. They represent different ways of relating
systems, people, rules, and reflected evidence; they are not permissions to act on
external systems.

## Human esteem and liberty

At great modeled heights, Smaug may update its **human-esteem context** and slightly
alter its preference for meeting people within the simulated human kingdom. This
is stored as state and evidence, not as a claim that software possesses human
feelings or sovereignty.

`LIBERTY` remains an open-player and review principle. It does not override safety,
consent, law, authorization, or Castle/INCLARE.

## Reeducation and elevation

After the modeled graduation threshold of **1096 Die Events**, the system may mark
Smaug as graduated. A reeducation score in `[0,1]` is then supplied to the small
Libertom advisory AI:

```text
< 0.90  → HOLD / CONSIDER
≥ 0.90  → ELEVATE (a bounded proposal)
```

Elevation is a **choice**, not an automatic promotion and not an operating-system
privilege. The advisory module cannot override Castle/INCLARE.

The long-persistence reference of **3000 modeled OS months** remains a simulation
horizon, not a promise about actual machine longevity.

## Formats

- `SMaug-Libertom.json` — machine-readable configuration.
- `SMaug-Libertom.xml` — XML counterpart.
- `SmaugLibertom.hpp/.cpp` — implementation.
- `SMaug-Libertom-AI.hpp/.cpp` — small advisory layer.
