# DESCRIPTIVE.md — What this code actually is (and is not)

This document describes how the vendored `llama.cpp` in `tools/ai/llama.cpp`
actually works, grounded in its real source files. It was written to answer a
set of specific questions honestly, including questions whose premises do not
match the code. Where a premise does not correspond to anything in the
codebase, that is stated plainly rather than invented.

The goal is that every claim here can be checked against a real file and, where
useful, a real line. If you find a discrepancy, the source is authoritative —
not this document.

---

## 1. What `llama.cpp` is

`llama.cpp` is an **inference engine** for large language models (LLMs) and
vision-language models (VLMs), written in plain C/C++. Its stated purpose (see
`README.md`) is to run LLM inference with minimal setup and high performance
across a wide range of hardware.

Two facts frame everything else:

1. **It runs a model; it does not contain the model's knowledge.**
   The "intelligence" attributed to an LLM lives in its **weights** — billions
   of floating-point numbers produced during *training* on text. Those weights
   are loaded at runtime from a `.gguf` file (see `src/llama-model-loader.cpp`,
   `gguf-py/`). This repository is the *machinery* that loads those numbers and
   does the arithmetic. It is not the training code, and it is not where any
   "understanding" resides.

2. **It is an executor, not a reasoner.**
   The engine's job is: turn text into tokens, run a forward pass through the
   neural network, get a list of scores, and pick the next token. It repeats
   that loop. There is no separate module that "reasons," "decides right from
   wrong," or "plans." Any appearance of reasoning is a property of the trained
   weights, expressed one token at a time through this loop.

---

## 2. The actual pipeline (what happens on every step)

Traced through the public API in `include/llama.h` and the core sources:

1. **Tokenize** — text is split into integer tokens.
   - Code: `src/llama-vocab.cpp` / `.h`, with Unicode handling in
     `src/unicode.cpp` and `src/unicode-data.cpp`.
   - API: `llama_tokenize` (`include/llama.h`).

2. **Forward pass (the neural network)** — tokens are fed through the model's
   computation graph to produce **logits** (one raw score per vocabulary token).
   - Model definition / weights wiring: `src/llama-model.cpp`, `src/llama-arch.cpp`.
   - Computation graph: `src/llama-graph.cpp` / `.h`.
   - Tensor math backend: the `ggml/` library (`ggml/src/ggml.c`, plus backend
     folders such as `ggml-cpu`, `ggml-cuda`, `ggml-metal`, `ggml-vulkan`).
   - API: `llama_decode`, then `llama_get_logits` (`include/llama.h`).
   - Attention state is cached in the KV-cache (`src/llama-kv-cache*.cpp`).

3. **Sample (pick the next token)** — the logits are transformed and one token
   is selected.
   - Code: `src/llama-sampler.cpp`.
   - API: `llama_sampler_sample`.

4. **Repeat** — the chosen token is appended and the loop runs again.

That is the whole engine, at a high level. Everything else is supporting
infrastructure (memory mapping, quantization, adapters, batching, etc.).

---

## 3. "Is it a neural net, or rigorous division logic?"

**Both — but at different layers.** This distinction is real and is the single
most important thing to understand about the codebase.

### 3a. The neural-net layer (statistical, learned, probabilistic)
The *model* being run is a neural network (a transformer). Its behavior comes
from learned weights, and its output is a **probability-like distribution** over
possible next tokens. This is the "soft," statistical part. It lives in the
model/graph/ggml code (`src/llama-model.cpp`, `src/llama-graph.cpp`, `ggml/`)
and, crucially, in the external weights file — not in hand-written rules.

### 3b. The engine layer (deterministic, rigorous, rule-based)
The C/C++ *around* the network is ordinary, exact, deterministic logic: tensor
arithmetic, memory management, tokenization, and the sampling step. Two concrete
examples from `src/llama-sampler.cpp` make the contrast vivid:

- **Greedy sampling is pure, deterministic logic.**
  `llama_sampler_greedy_apply` (around line 967) simply scans the scores and
  picks the single highest one — an `argmax`. Given identical inputs it always
  returns the identical token. No randomness, no learning:

  ```cpp
  static void llama_sampler_greedy_apply(struct llama_sampler * /*smpl*/, llama_token_data_array * cur_p) {
      cur_p->selected = 0;
      for (size_t i = 1; i < cur_p->size; ++i) {
          if (cur_p->data[i].logit > cur_p->data[cur_p->selected].logit) {
              cur_p->selected = i;
          }
      }
  }
  ```

- **Distribution sampling is deterministic math plus explicit randomness.**
  `llama_sampler_dist_apply` (around line 1042) applies a softmax to turn logits
  into probabilities, then draws from them using a seeded pseudo-random number
  generator (`std::mt19937`). The math is exact; the *choice* is randomized by
  design, and the randomness is reproducible from a seed.

So: the network produces scores probabilistically; the engine then applies
rigorous, inspectable rules (optionally with controlled randomness) to convert
those scores into a concrete token. Neither description alone is correct — the
answer is layered.

### 3c. Where genuinely "rigorous division logic" is enforced
If you want a place where the engine imposes hard, formal rules on the model's
output, look at the **grammar** sampler:

- Code: `src/llama-grammar.cpp` / `.h`, with GBNF grammar files in `grammars/`.
- It constrains generation to a formal grammar (e.g., forcing valid JSON) by
  masking out any token that would violate the grammar *before* selection.
- This is classic rule-based parsing logic (it even has guards like
  `MAX_REPETITION_THRESHOLD`), layered on top of the statistical model. It is
  the clearest example in the codebase of rigorous, deterministic constraint
  logic governing the "soft" neural output.

---

## 4. Where are "decisions" made?

The only place the engine makes a discrete *decision* is the **sampler**
(`src/llama-sampler.cpp`). Everything before it produces continuous scores; the
sampler collapses those into one chosen token. The chain of samplers a caller
assembles (temperature, top-k, top-p/nucleus, min-p, typical, penalties,
mirostat, grammar, etc.) is exactly the set of knobs that determine *how* that
decision is made — from fully deterministic (greedy/argmax) to controlled-random
(distribution sampling with a seed).

In short: **the model proposes, the sampler disposes.** The disposal is
governed by explicit, readable code.

---

## 5. On "syllogism of manuture" / a model of a hand and a man moving through space-time

There is **nothing in this codebase that models hands, bodies, embodiment, or
movement through space and time.** This was checked against the source:

- The engine has **no physics, no kinematics, no spatial or temporal world
  model, and no geometric model of a body.**
- The only "domain" it operates on is a **sequence of tokens** (chunks of text,
  and for VLMs, encoded image patches). Its notion of "position" is a token
  index / sequence position used for attention and the KV-cache
  (`src/llama-kv-cache*.cpp`), not a coordinate in physical space.

If an LLM run through this engine ever produces text *about* a hand moving, that
is the trained weights predicting plausible words — it is language output, not a
mechanical or spatial simulation happening inside the code. No source file
implements such a concept, and this document will not pretend one does.

---

## 6. Files that describe morals, intelligence, generosity, or law?

**There are none.** A search of the source tree (`src/`, `include/`) for terms
such as *moral*, *ethic*, *virtue*, and *generosity* returns no matches. There
is no file, module, or data structure that encodes:

- **Morality or ethics** — not represented anywhere in code.
- **Generosity** or other character traits — not represented anywhere in code.
- **Law or legal rules** — not represented anywhere in code.
- **"Intelligence"** as a component — there is no "intelligence" module. What
  people call the model's intelligence is an emergent property of the trained
  weights, produced elsewhere (during training), and merely *executed* here.

The closest thing to "rules about how the model should behave" is **not code at
all** — it is text supplied at runtime:

- **Chat templates** (`src/llama-chat.cpp`, `src/llama-chat.h`,
  `llm_chat_apply_template`) format a conversation, including any *system
  prompt*. A system prompt can contain instructions ("be helpful," "refuse X"),
  but that is plain text the operator provides, interpreted by the model — not
  logic hard-coded into the engine.
- **Grammars** (`src/llama-grammar.cpp`) can constrain *format*, not values or
  ethics.

If behavioral guardrails, morality, or legal constraints are ever needed, they
would have to come from one of three places outside this engine: patterns baked
into the training data, a system prompt / template supplied at runtime, or an
external moderation layer wrapping the engine. None of those live in this code.

---

## 7. Reader's guide: where to look

| Concern | Primary files |
| --- | --- |
| Public C API / entry points | `include/llama.h`, `include/llama-cpp.h` |
| Tokenization (text ↔ tokens) | `src/llama-vocab.cpp`, `src/unicode*.cpp` |
| Model definition & weights wiring | `src/llama-model.cpp`, `src/llama-arch.cpp` |
| Forward-pass computation graph | `src/llama-graph.cpp`, `src/llama-graph.h` |
| Tensor math / hardware backends | `ggml/src/ggml.c`, `ggml/src/ggml-*` |
| Attention state cache | `src/llama-kv-cache*.cpp` |
| Token selection ("decisions") | `src/llama-sampler.cpp` |
| Formal-grammar constraints | `src/llama-grammar.cpp`, `grammars/` |
| Conversation / system-prompt formatting | `src/llama-chat.cpp`, `src/llama-chat.h` |
| Quantization (compressing weights) | `src/llama-quant.cpp` |

---

## 8. Vocabulary and decoding descriptors (mapping intuitive terms to the real machinery)

This section answers a follow-up set of questions about *vocabulary* and about
giving a "decider" more control over content. As elsewhere in this document, the
intuitive framing is kept but each idea is anchored to a real construct in the
source; where a framing has no counterpart in the code, that is said plainly. A
fuller treatment lives in `tools/ai/DISPERSIONS.md`; this is the DESCRIPTIVE
summary tied to specific files.

### 8a. The vocabulary is a 2-D table, and it is storage — not reasoning

A model's vocabulary lives in a 2-D **embedding matrix** of shape
`[n_vocab, n_embd]` — one row per token, each row a vector of hidden width
`n_embd`. At the input, the row for each token ID is selected (a `get_rows`
operation); at the output, a similar matrix projects the final hidden state back
onto one **logit** per vocabulary token.

- Code: token/vocab handling in `src/llama-vocab.cpp`; weights wired in
  `src/llama-model.cpp`; the tensor op in `ggml/` (`GGML_OP_GET_ROWS`).

The load-bearing point: the embedding table stores *what each token means in
isolation*. The reasoning happens **between** the input and output tables, in the
attention + feed-forward stack (`src/llama-graph.cpp`). Changing the vocabulary
changes how meaning is *packed into tokens*; it does not, by itself, change how
meaning is *composed*.

### 8b. The only trigonometry over tokens is RoPE — and it encodes order, not meaning

If one is looking for a "trigonometric model of vocabulary," the one real
candidate is **Rotary Position Embedding (RoPE)**. RoPE does not rotate the
vocabulary table; it rotates the *query and key* vectors by an angle proportional
to a token's position, using paired sine/cosine rotations.

- Code: `GGML_OP_ROPE`, applied to Q and K in `src/llama-graph.cpp`.

So the honest description is: the 2-D embedding table (8a) supplies *meaning*, and
RoPE adds a trigonometric encoding of *position/order* on top. There is no
separate trigonometric vocabulary model beyond this.

### 8c. "Richer vocabulary" is a trade-off with a sweet spot, not a free win

Enlarging `n_vocab` (for example, the LLaMA-1 ~32K vocabulary versus the
LLaMA-3 ~128K vocabulary) has mixed effects:

| Effect of a larger vocabulary | Direction | Why |
| --- | --- | --- |
| Tokens needed for the same text | decreases | each token carries more meaning |
| Attention compute (quadratic in length) | improves | shorter sequences; more content fits context |
| Embedding + output-projection parameters | grows (linear in `n_vocab`) | both tables and the final softmax scale with vocabulary size |
| Rare-token quality | degrades | training signal is spread thinner across more tokens |
| Coverage of code, math, non-Latin scripts | improves | fewer tokenization artifacts |

The practical rule: the useful vocabulary size **scales with model size**. Large
models can exploit a richer vocabulary; small models are hurt by one because
undertrained rare tokens dominate. Effect on *reasoning* specifically: modest and
bounded — better packing and coverage, not a higher reasoning ceiling. That
ceiling is set by depth, width, training data, and alignment, not by the size of
the vocabulary table.

### 8d. Giving the "decider" more authorship: what the sampler can and cannot do

The engine's only discrete decision is the **sampler** (Section 4;
`src/llama-sampler.cpp`). It can reshape or hard-mask the distribution — more
deterministic, more exploratory, or format-constrained — but it **cannot add
knowledge or reasoning the weights do not already contain.** It reorders and
prunes what the network already made likely. So "more authorship by the decider"
buys *reliability, style, and validity*, not deeper reasoning.

### 8e. Definitions of the decoding terms

At each step the network emits a **logit** per token; softmax turns logits into a
probability distribution; the following samplers shape it and select a token. All
are assembled into a chain via `llama_sampler_chain_add` (`include/llama.h`) and
implemented in `src/llama-sampler.cpp`.

- **Logits** — the raw, unnormalized scores the model assigns to each candidate
  next token (before softmax). Higher = the model finds it more likely.
- **Softmax** — converts logits into a probability distribution (values in
  `[0,1]` summing to 1). Tensor op `GGML_OP_SOFT_MAX`.
- **Temperature (`temp`)** — divides logits before softmax. `temp < 1` sharpens
  (more deterministic); `temp > 1` flattens (more diverse); `temp = 1` is
  unchanged. API: `llama_sampler_init_temp`.
- **Top-k (`top_k`)** — keep only the *k most probable* tokens, renormalize, and
  sample from them. A fixed-count cutoff; `k = 1` is effectively greedy. API:
  `llama_sampler_init_top_k`.
- **Top-p / nucleus (`top_p`)** — keep the *smallest set of tokens whose
  cumulative probability reaches p* (e.g. 0.9 = 90% of the mass), then
  renormalize and sample. An adaptive cutoff: narrow when the model is confident,
  wide when it is unsure. API: `llama_sampler_init_top_p`.
- **Greedy / argmax** — always take the single highest-probability token
  (`llama_sampler_greedy_apply`, Section 3b; equivalent to `top_k = 1`). Fully
  deterministic.
- **Grammar-constrained (GBNF)** — a *hard* mask that zeroes out any token
  violating a formal grammar's production rules (`nonterminal ::= sequence...`),
  guaranteeing, e.g., valid JSON. Code: `src/llama-grammar.cpp`, `grammars/`; API
  `llama_sampler_init_grammar`. This is the format/legality layer of Section 3c.
- **Sampler chain** — samplers applied in sequence (e.g. grammar → top-k → top-p
  → temperature → draw). The chain *is* the "decider," expressed as explicit,
  readable code.

Relation to "intent / authorship": temperature and top-k/top-p tune how much
freedom versus commitment the decider exercises; greedy decoding and grammar
constraints are the two ways to exert *maximal* control (single deterministic
choice, and hard legality). None of them add knowledge — they govern *selection*
from the distribution the trained weights produce.

---

## 9. Summary

- `llama.cpp` is an **inference engine**: it runs a pre-trained neural network,
  it does not contain knowledge, reasoning, morality, or a world model.
- It is **both** a neural net and rigorous logic — the *model* is statistical
  and learned; the *engine* around it (tokenizer, tensor math, sampler,
  grammar) is deterministic, inspectable code.
- The only discrete decision the engine makes is in the **sampler**, ranging
  from deterministic `argmax` (greedy) to seeded probabilistic sampling.
- There is **no** modeling of hands, bodies, space-time, morals, intelligence,
  generosity, or law anywhere in the source. Where such constraints are wanted,
  they come from training data, a runtime system prompt/template, or an external
  layer — never from a dedicated file in this engine.
- The **vocabulary** is a 2-D embedding table (`[n_vocab, n_embd]`) that *stores*
  token meaning; reasoning happens in the stack between the input and output
  tables. A richer vocabulary is a bounded trade-off (better packing/coverage,
  not a higher reasoning ceiling), and the **sampler** ("decider") controls
  selection, determinism, and validity — never added knowledge. See Section 8 and
  `tools/ai/DISPERSIONS.md`.
