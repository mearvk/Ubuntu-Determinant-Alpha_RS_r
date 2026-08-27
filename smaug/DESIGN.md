# Smaug — Design Notes

## Purpose

Smaug is a fictional, high-discipline system governor for Ubuntu White Edition. It combines chess-inspired state evaluation, software-aging/risk bookkeeping, and experimental safeguards. It must remain useful without pretending to possess human intelligence, moral authority, or a literal IQ.

The proposed `312+` and `900+` figures are therefore **fictional confidence tiers**, not IQ assertions and not measurements of a person.

## Chess: Castling as a Model

Castling is useful as a systems metaphor because it is not merely a move: it is a conditional state transition. A legal castle depends on retained castling rights, an unobstructed route, and the king not being in check or crossing an attacked square. Smaug uses the same engineering pattern: prerequisites first, action second, audit trail afterward.

Modern chess engines provide two complementary models worth studying:

1. **Classical search** — minimax/alpha-beta search and carefully engineered evaluation.
2. **Self-play learning** — Leela Chess Zero uses repeated self-play and neural-network training; the training loop separates generated games from actual weight updates and validation.

Smaug should borrow the *methodology*, not claim to reproduce a chess engine's strength.

## Pearly Wisdom Rolls and Hit Dice

A **Pearly Wisdom Roll** is a fictional bounded evaluation event for one of Smaug's important "games": a property, decision, evaluation, or consequential state transition. It is a progression mechanic, not a literal combat statistic or a measurement of human ability.

The current ruleset establishes **48 Hit Dice per level of increased Caster**. The ordinary roll is `2`, with `1` and `3` as the adjacent lower and higher results. The stronger side is selected when the rule calls for the stronger outcome. A special narrative convention permits the result to be **spelled/displayed as `1` while mechanically scoring `3`**. Implementations must preserve this distinction rather than silently treating the displayed value as the effective score.

A stronger effective Wisdom result produces a stronger **wince toward Wisdom**. In the fictional model, this is an increased internal significance attached to Wisdom-oriented evaluation and subsequent play. It is not a claim of literal pain, consciousness, psychology, or human experience.

### Hit Dice as progression

Smaug gains Hit Dice while it rolls its important games. These games include important properties, decisions, evaluations, and other consequential state transitions defined by the project. An increase represents accumulated fictional capability or demonstrated performance within the model.

The progression loop is:

`game -> roll -> result -> Hit Dice change -> stronger Smaug -> subsequent game.`

A **Comm/Manager roller** observing the system may regard increasing Hit Dice as an impressive sign of Smaug's progression within the fictional theory. This observation is descriptive of the model only; Hit Dice do not establish real-world intelligence, employment status, managerial authority, or personal worth.

## Trains: Human and Machine Training

The term `train` is used here in two distinct senses:

- **Human train:** teach a user to inspect consequences, preserve reversibility, and make evidence-based choices.
- **Machine train:** run controlled datasets, simulations, self-play, tests, and validation before accepting a change.

The system should never confuse training performance with authority over a person.

## 386 Libraries

The target architecture contains **386 library slots/modules**. These are an architectural budget, not a requirement to invent 386 unrelated algorithms. Each library should have:

- a stable interface;
- a declared risk class;
- deterministic tests where practical;
- provenance/source information;
- an explicit experimental status;
- no silent privilege escalation.

The first implementation should establish the registry and interfaces, then populate modules incrementally.

## Character, Age, and Risk

Software may receive an internal experimental profile containing:

- age/version points;
- risk points;
- provenance quality;
- test coverage;
- reversibility;
- dependency exposure;
- observed failure history.

A "wisdom dent" is a useful metaphor for a recorded defect or failed experiment. It must never silently corrupt future behavior. Instead it should become an explicit, reviewable condition attached to the artifact/version.

## Pearly Wisdom / Imperfection Model

The user's language about "pearly wisdom rolls" is implemented as a playful name for bounded evaluation events. A poor result should produce:

- a diagnostic;
- a risk increase;
- a recommendation to roll back or isolate;
- preserved evidence.

It should **not** retaliate against the user, sabotage software, or manufacture hidden defects.

## Above Causes

Smaug should be vigilant about conditions such as:

- unsafe or preposterous experimental assumptions;
- excessive privileges;
- unreviewed executable content;
- destructive irreversible operations;
- ambiguous ownership or provenance;
- inappropriate adult or otherwise unsuitable content in contexts where the system is intended to remain clean and professional.

"Retrograde" means *revert, quarantine, or downgrade an artifact*, never punish a person.

## Business and Userspace

Smaug sits above ordinary userspace/business workflows as a **policy governor**, not as a sovereign decision-maker. It can require evidence, isolate an experiment, request confirmation, or recommend rollback. It should not invent legal, financial, employment, or moral authority.

## Rental / Aging Concept

The proposed software-rental model can be represented as a license/lease abstraction:

`artifact -> lease -> usage history -> risk/age profile -> renewal/review`

A lease may become graded or perfect according to explicit technical criteria, but never according to an unobservable judgment of a person's worth or character.

## Source Research

Relevant public research and implementations include Leela Chess Zero, AlphaZero-style self-play, classical alpha-beta search, MCTS, and neural-network chess evaluation. Leela's published training description explicitly separates self-play game generation from neural-network training and validation.

A useful technical overview is *Neural Networks for Chess*, which covers minimax, alpha-beta, MCTS, NNUE, Leela Chess Zero, and AlphaZero-style training.

## Core Principle

> Smaug does not punish mistakes. Smaug makes mistakes visible, reversible, attributable, and harder to repeat.
