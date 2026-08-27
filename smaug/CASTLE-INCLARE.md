# SMAUG CASTLE — STRONG INCLARE PRINCIPLE

## Purpose

**Castle** is Smaug's protected-state concept. It establishes a safe internal
position before consequential transitions and preserves that position while
Smaug interacts with external programs, models, users, or opponents.

## INCLARE

**INCLARE** is a Smaug project term meaning:

> Define the inside from the inside-out; expose only an intentional interface;
preserve internal invariants when external pressure, claims, or opponents are
encountered.

The central invariant is:

> **External input may inform, challenge, or trigger reevaluation. It may not
> silently redefine Smaug's internal state or authority.**

## Castle sequence

```text
ESTABLISH INSIDE
      |
      v
PRESERVE INVARIANTS
      |
      v
OBSERVE EXTERNAL / OPPONENT
      |
      v
EVALUATE CLAIM
      |
      +---- unsafe / ambiguous ---> HUMAN REVIEW
      |
      v
CONTROLLED TRANSITION
      |
      v
PRESERVE EVIDENCE + REVERSIBILITY
```

Castle therefore means **control of one's own state**, not domination of an
opponent. An opponent can supply evidence and cause reevaluation without
becoming the authority over Smaug's internal state.

## Relationship to Train

**Castle** protects state and boundaries.

**Train** experiments, learns, evaluates hypotheses, and improves models.

Train operates inside Castle's boundaries; model confidence cannot by itself
create authority.

## Strong implementation rule

Every consequential external transition should be evaluated against:

1. internal authority integrity;
2. preserved evidence;
3. explicit boundary classification;
4. reversibility where practical;
5. human review when the invariant is uncertain or fails.

The C++ interface is defined in `SmaugCastle.hpp` and implemented in
`SmaugCastle.cpp`.
