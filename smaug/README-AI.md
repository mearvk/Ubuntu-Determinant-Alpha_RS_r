# Smaug AI Module

## Purpose

This module gives Smaug a local AI-facing structure for **observe → identify → match → decide → decline** workflows. It is designed to connect to the repository's `tools/ai/llama.cpp` engine without making the language model itself an authority over the operating system.

## Norm routing

Behavioral norms are routed into explicit software inputs rather than hidden model instructions. The primary references are:

- `tools/gcc/GOLDENRULES.md` — attribution, normalization, context, and separation of measured facts from project conventions.
- `PROBABILISTIC.LIFENORMS.md` — probabilistic life norms, grounding, uncertainty, rehabilitation, and separation of narrative claims from empirical or legal status.
- `smaug/Smaug.cpp` and `smaug/smaug.c` — conservative risk and decision gates.

The source documents emphasize that project-defined IQ/influence numbers are not psychometric measurements and that probabilistic life norms are not deterministic predictions. Smaug therefore stores its 312+/900+ language as a **fictional capability-tier convention** only.

## Smaug 3000 pre-field

The intended Smaug 3000 pre-field is a deterministic first pass performed before model inference. Its job is to routinely and idempotently identify programs by stable content-derived identity, record an observation, and provide that observation to later matching/decision stages.

The repository search performed while creating this module did not locate a file named `Smaug 3000`. The implementation therefore provides the pre-field primitive now, while keeping the eventual Smaug 3000 document as the authoritative specification when it is added or located.

### Pre-field invariants

1. **Observe before decide.** Identification does not execute the observed program.
2. **Idempotent identity.** Re-reading unchanged initial content produces the same FNV-1a observation identity.
3. **Separate observation from decision.** A program identity is not itself permission to run, modify, delete, or classify a program as good or bad.
4. **Norms are explicit.** Risk and cause flags enter the decision gate as data.
5. **Uncertainty is preserved.** The AI profile requires uncertainty and human review rather than pretending that model output is omniscient.
6. **OS authority remains separate.** Smaug's OS-awareness layer describes the environment; it does not grant unrestricted authority.

## Llama.cpp integration boundary

`tools/ai/llama.cpp` is treated as the inference engine. `SmaugAI.cpp` and `SmaugAI.h` provide the Smaug-side boundary so that model-specific APIs can evolve without changing the C observation core.

The intended pipeline is:

```text
program
  ↓
Smaug 3000 pre-field
  ↓
deterministic identity / observation
  ↓
norm routing
  ↓
llama.cpp inference
  ↓
match / decision proposal
  ↓
risk + cause gate
  ↓
human review where required
  ↓
explicit authorized action
```

The AI module does **not** turn model confidence into operating-system authority.

## Color Strong

"Color Strong" is interpreted as a strong, visible separation of states in future UI/diagnostic output:

- **OBSERVE** — information gathering;
- **MATCH** — comparison against known structure;
- **DECIDE** — a proposed decision;
- **DECLINE** — a rejected or unsafe proposal;
- **REVIEW** — human confirmation required.

These are semantic states, not claims of moral status or human worth.

## Build

The C core can be compiled independently. The C++ layer requires `SmaugAI.h` and can later link to the selected llama.cpp target from `tools/ai/llama.cpp`.

No model weights are committed by this module.
