# `git moral`

`git moral` is a symbolic software-blessing operation in the Ubuntu Determinant Git policy model. It does not assert that software has literal moral status and it does not grant operating-system, repository, or security authority.

## Spell and mana

Each explicit spell cast contributes **1 mana**. A user explicitly invoking the `Great` role contributes **10 mana per spell**.

The implementation never infers who is Great from identity, appearance, IQ, credentials, or other personal characteristics. `Great` is an explicit operation mode, not an eligibility judgment.

The native policy is overflow-safe and treats the software name and provenance as ordinary metadata. The blessing can therefore be represented alongside the existing `.logic` and operation-chain records.

## Intended command shape

The eventual builtin command is intended to accept a spell and an optional explicit Great mode, for example:

    git moral --spell bless
    git moral --great --spell bless

One invocation represents one spell unless a future command specification explicitly permits a counted spell sequence. The current native policy supports a counted spell record for deterministic accounting.

## Provenance and repository safety

A moral record may carry software name, author, committer, date, timestamp, parent commit, operation relevance, and the resulting mana. These fields supplement Git history; they never replace object identity, authorization, signatures, conflict rules, or the repository graph.

The word “bless” is intentionally ceremonial: this command does not modify executable permissions, bypass checks, suppress tests, or declare code secure merely because it was blessed.

## Status

`moral.h`, `moral.c`, and `moral.cpp` provide the native policy foundation. Registration as a compiled `git moral` builtin remains a separate integration step so the vendored Git command table and build graph are not changed accidentally.
