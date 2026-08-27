# Smaug Atom / SpinMass — Quality Iteration

This document specifies a bounded simulation model for programmable Objects. The
terms **atom**, **heart**, **spin**, **mass**, **despair**, **strike**, and **end**
are simulation vocabulary and are not claims about real atomic physics or a
mechanism for harming people or physical objects.

## Quality upgrades

The model now has explicit bounded input handling for JSON and XML, file feeders,
and a terminal-review record. Input is capped at 4 MiB before parsing and must
have the expected top-level document boundary. This is a defensive preflight,
not a complete general-purpose XML/JSON parser.

Strike history should be preserved as evidence. Instant and LongClassic are
simulation modes; LongClassic is bounded to three modeled hours. A terminal
state means the modeled schedule has ended. It does not represent real-world
injury or death.

## Slow review

A strike should be presented to a reviewer as a sequence rather than an
unbounded instantaneous effect:

```text
JUST-BEFORE  ->  STRIKE  ->  JUST-AFTER  ->  REVIEW
     |             |            |             |
  snapshot       mode         outcome       evidence
  identity       intensity    level         decision
  state          duration     spin          human gate
```

The terminal representation should make the event history inspectable before a
consequential transition is accepted. Castle/INCLARE remains the authority
boundary.
