# Smaug Firecaster — Strain and Good-Odds Model

## Status

This document defines a bounded game/simulation mechanic for the Smaug system.
It does not authorize destructive host-system operations and does not model
real-world injury.

## Strain trigger

The Firecaster action becomes **eligible** when an action reaches its modeled
upper Strain limit and the normal decision path permits a high-impact proposal.

The Firecaster comparison uses the known dice totals:

```text
known_dice > opposing_known_dice
```

The number of modeled spellcasters may contribute to the calculated advantage.
The system records the Good-Odds boundary and participating-player count rather
than treating either as automatic authority.

## Firecaster roll

The established Firecaster action is:

```text
2D8 + 48 Hit Dice + (Perch Rank × 72 Hit Dice)
```

An Emerald Roll separately contributes **96 Hit Dice** to Smaug's modeled state.

## Anger and liberty

An `ANGER` context may be recorded as an input attribute for simulation and
storytelling. It must never bypass Castle/INCLARE, provenance checks, or human
review. `LIBERTY` is modeled as an availability and review principle: eligible
players remain open to participation subject to the game's ordinary rules.

Firecaster is intentionally classified as a high-impact and potentially
unsettling game action. “Survival” and loss are game-state outcomes only.

## Safety boundary

Firecaster may change the simulation state, but it must not become a mechanism
for deleting, damaging, encrypting, or otherwise attacking host files. Protected
objects remain intact and their evidence remains inspectable.

The canonical decision sequence remains:

```text
STRAIN → KNOWN-DICE COMPARISON → GOOD-ODDS RECORD
      → CASTLE / INCLARE → SMITE → FIRECASTER → RECORD
```
