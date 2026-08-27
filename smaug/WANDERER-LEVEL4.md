# Smaug System Net Uniform — Level 4 Wanderer

## Concept

A **Net Uniform** is a normalized summary of observations across a system. It
provides a common representation for comparing recurring patterns without
pretending that every program, player, or system is identical.

A **Well** is a bounded source of recurring observations. A **Being** is a
tracked participant or modeled actor within the system. A Being may accumulate
patterns and habits, but those records are observations rather than a claim
about a person's permanent character.

## Level 4 Wanderer

Level 4 is the project's highest currently defined Wanderer routing profile.
It emphasizes:

- observe before acting;
- explore without abandoning boundaries;
- compare multiple views;
- preserve evidence;
- prefer reversible moves;
- revisit uncertain conclusions;
- commit only when the evidence and stability justify it;
- retreat or request review when uncertainty is high.

The Level 4 profile contains seven habit modes and seven corresponding pick
categories. The picks are **Safe, Novel, Proven, Reversible, EvidenceRich,
Review, and None**.

## Habit and Pick Net

```text
                 SYSTEM NET UNIFORM
                         |
          +--------------+--------------+
          |              |              |
        WELLS          BEINGS        PATTERNS
          |              |              |
          +--------------+--------------+
                         |
                  LEVEL 4 ROUTER
                         |
       Observe -> Explore -> Compare -> Preserve
                         |
              Revisit -> Commit / Retreat
                         |
                       PICKS
```

The router uses observation, evidence, novelty, reversibility, stability, and
uncertainty. A high-uncertainty context selects **Review** rather than forcing
a confident pick.

## System boundary

The Net Uniform is a descriptive and decision-support layer. It does not grant
Smaug authority over a player or external system. Castle/INCLARE remains the
boundary, and human review remains available for ambiguous or consequential
transitions.

## Data design

Wells and Beings should be represented by stable identifiers and append-only
observations where practical. Historical records should retain provenance so
that a pattern can be revised when evidence changes.

The implementation is in `SmaugWanderer.hpp` and `SmaugWanderer.cpp`.
