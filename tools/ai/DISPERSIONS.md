# DISPERSIONS.md

**Observing the design philosophy of the llama.cpp codebase, and the productions (linear algebras) that let an AI system reason across general language, software paradigms, morality, and the ordering of laws and legality.**

> Scope note. This document is an *observational essay*. It reads the actual
> `llama.cpp` / `ggml` source vendored under `tools/ai/llama.cpp`, names the
> concrete operations it finds there, and then connects those operations to the
> published research literature on how large language models (LLMs) come to
> generalize. Where a claim comes from outside the codebase it is cited inline.
> Content drawn from external sources has been rephrased for compliance with
> licensing restrictions. Nothing here asserts that a model "possesses" morality
> or legal authority — it describes the *mathematical machinery* by which
> statistical regularities about those domains are encoded and reproduced.

---

## 0. Why "dispersions"?

A *dispersion* is what happens when a single ray of white light passes through a
prism and fans out into a spectrum. Every color was already latent in the input;
the prism simply *separates* and *reorders* it along an axis.

That is a precise metaphor for what llama.cpp does at inference time. A prompt
enters as one undifferentiated sequence of token IDs. The network disperses it —
across thousands of dimensions, dozens of attention heads, and many layers —
into a structured field of directions and weights. The final layer *recombines*
that field into a probability distribution over the next token. The design
philosophy of the codebase is almost entirely about making this dispersion
**fast, portable, and numerically honest** on ordinary hardware.

Everything below is an attempt to trace *which linear-algebra "productions"*
carry the light, and *how* the same small set of productions ends up being
enough to talk about grammar, code, ethics, and law.

---

## 1. The design philosophy of llama.cpp (as observed in the source)

The project's own `README.md` states the goal plainly: enable LLM (and
vision-language) inference **with minimal setup and state-of-the-art performance
on a wide range of hardware**, locally and in the cloud. Reading the tree under
`tools/ai/llama.cpp`, four design commitments recur:

1. **A plain C/C++ core with no mandatory dependencies.** The tensor library
   `ggml` (`ggml/include/ggml.h`, `ggml/src/ggml.c`) is self-contained. This is
   a *portability-first* philosophy: the same graph runs on a laptop CPU or a
   datacenter GPU.

2. **A small, closed "alphabet" of tensor operations.** Intelligence is *not*
   implemented as bespoke code per model. Instead the code defines an
   enumeration of primitive ops (`enum ggml_op` in `ggml.h`) and every model —
   LLaMA, Qwen, Mistral, Mamba, RWKV, DeepSeek — is expressed as a *graph* built
   from that same alphabet in `src/llama-graph.cpp`. The philosophy is
   **compositional**: few primitives, arbitrarily many architectures.

3. **Quantization as a first-class citizen.** The README advertises 1.5-bit
   through 8-bit integer quantization; `ggml/src/ggml-quants.c` implements it.
   The bet is that the *dispersion pattern* — the relative geometry of the
   weights — survives aggressive precision reduction. Meaning lives in
   *directions and ratios*, not in the last bits of any single number.

4. **Separation of the compute graph from the backend.** `ggml-backend.cpp`,
   `ggml-cpu`, `ggml-cuda`, `ggml-metal`, `ggml-vulkan`, etc. let the *same*
   graph be dispatched to different silicon. The graph is a *description of
   linear algebra*; the backend is a *physics engine* for it.

The manifesto behind the project (linked from the README as
[ggml-org/llama.cpp discussion #205](https://github.com/ggml-org/llama.cpp/discussions/205))
frames this as democratizing access to large models by refusing heavyweight
runtime dependencies. The whole design is downstream of one idea: *if you get
the linear algebra right and portable, the intelligence rides along for free.*

---

## 2. The productions: the linear-algebra alphabet in `ggml.h`

The single most important observation in this document: **an LLM's apparent
breadth of competence is produced by a startlingly small set of operations.**
The following are taken verbatim from the `enum ggml_op` and `enum
ggml_unary_op` / `enum ggml_glu_op` declarations in
`tools/ai/llama.cpp/ggml/include/ggml.h`.

### 2.1 The load-bearing production: `GGML_OP_MUL_MAT`

Matrix multiplication (`MUL_MAT`, with its mixture-of-experts sibling
`MUL_MAT_ID`) is the beating heart. Nearly all of the model's *learned knowledge*
lives in weight matrices, and it is *accessed* by multiplying activations against
them. In the attention builder `build_attn_mha` (`src/llama-graph.cpp`, near
line 2395) the two most consequential lines are literally:

```c
ggml_tensor * kq  = ggml_mul_mat(ctx0, k, q);   // scores: how much each token attends to each other token
// ... softmax over kq ...
ggml_tensor * kqv = ggml_mul_mat(ctx0, v, kq);  // mix values by those scores
```

That is the entire "attention" operation in two matrix products with a softmax
between them. Written in standard notation it is the scaled dot-product form
`Attention(Q, K, V) = softmax(QKᵀ / √dₖ) · V`
([dev.to explainer](https://dev.to/zeromathai/how-self-attention-works-qkv-softmax-and-matrix-computation-514j),
[arXiv:2511.11572](https://arxiv.org/abs/2511.11572)). The division by `√dₖ` keeps
the dot-product logits from growing too large in magnitude and saturating the
softmax
([why-√dₖ discussion](https://medium.com/@srivatsa.n63/why-is-attention-divided-by-d%E2%82%96-the-secret-behind-scaled-attention-in-transformers-44f36465266f)).
In the code this scale is folded into `ggml_soft_max_ext(ctx0, kq, kq_mask,
kq_scale, ...)`.

### 2.2 The supporting productions

| Production (ggml op) | Role in the dispersion |
|---|---|
| `GET_ROWS` | Embedding lookup: turns discrete token IDs into continuous vectors — the entry point into vector space. |
| `MUL_MAT`, `MUL_MAT_ID` | Projections (Q/K/V/O), feed-forward weights, and expert routing. The knowledge stores. |
| `SOFT_MAX` / `SOFT_MAX_EXT` | Converts raw scores into a normalized probability distribution (attention weights, and the final token distribution). |
| `ROPE` | Rotary position embedding — injects *order* by rotating Q and K by a position-dependent angle. |
| `RMS_NORM`, `NORM`, `L2_NORM`, `GROUP_NORM` | Normalization: keeps activations at a stable scale so deep stacks don't explode or vanish. |
| `ADD`, `MUL`, `SCALE`, `SUB`, `DIV` | Residual connections and element-wise gating that let information skip and modulate. |
| Activations: `GELU`, `GELU_ERF`, `SILU`, `RELU`, `SIGMOID`, `TANH`, `EXP`, `SOFTPLUS` | The *only* nonlinearities. Without them the whole network would collapse into a single linear map. |
| Gated units: `REGLU`, `GEGLU`, `SWIGLU`, `SWIGLU_OAI` | The feed-forward "reasoning" block; SwiGLU is the variant LLaMA-family models use. |
| `ARGSORT`, `TOP_K`, `ARGMAX` | Selection at the output — the bridge from a continuous field to a discrete choice. |
| `FLASH_ATTN_EXT` | A fused, memory-efficient rewrite of the attention block above. |
| `SSM_CONV`, `SSM_SCAN`, `RWKV_WKV6/7`, `GATED_LINEAR_ATTN` | Alternative "state-space"/linear-attention mixers (Mamba, RWKV) built from the *same* alphabet. |

**The philosophical point.** There is no `GGML_OP_UNDERSTAND_LANGUAGE`, no
`GGML_OP_JUDGE_MORALITY`, no `GGML_OP_APPLY_LAW`. There is only linear algebra
plus a handful of nonlinearities. Everything the model appears to "know" is a
*standing wave* in the interference pattern these productions set up over the
learned weights.

---

## 3. How the LLaMA design shapes the dispersion

The vendored source targets the modern decoder-only transformer family. Three
choices, all visible in the graph builder, define the LLaMA lineage
([LLaMA concepts summary](https://akgeni.medium.com/llama-concepts-explained-summary-a87f0bd61964)):

- **RMSNorm instead of LayerNorm.** It normalizes by the root-mean-square of the
  activation and drops the mean-centering term, achieving comparable quality at
  lower computational cost — reported reductions in running time versus LayerNorm
  in the 7%–64% range
  ([LLaMA concepts summary](https://akgeni.medium.com/llama-concepts-explained-summary-a87f0bd61964)).
  In the code this is `GGML_OP_RMS_NORM`.

- **SwiGLU feed-forward.** The `GGML_GLU_OP_SWIGLU` gate replaces a plain MLP: one
  linear stream is passed through SiLU and used to *gate* a second stream. This
  is where most of the per-token nonlinear "thinking" happens.

- **Rotary Position Embeddings (RoPE).** Rather than adding a position vector,
  RoPE *rotates* the query and key vectors by an angle proportional to position,
  so that attention scores depend on *relative* position through the geometry of
  the rotation ([positional-encoding survey, arXiv:2608.10021](https://arxiv.org/abs/2608.10021)).
  RoPE can be read as phase modulation of a bank of oscillators, and the choice
  of its base frequency governs how far the model can reliably extrapolate in
  context length — there is effectively a numerical "Goldilocks zone" beyond
  which positional information is aliased or erased
  ([arXiv:2602.10959](https://arxiv.org/abs/2602.10959)). In the code this is
  `GGML_OP_ROPE`, applied to Q and K before the attention matmul.

Self-attention on its own models content-dependent interactions but is blind to
order; position encoding is precisely the ingredient that repairs that blindness
([arXiv:2608.10021](https://arxiv.org/abs/2608.10021)). The cost of attention is
quadratic in sequence length, which is why the codebase also carries the fused
`FLASH_ATTN_EXT` path and the linear-attention state-space mixers
([efficient-attention survey, arXiv:2507.19595](https://arxiv.org/abs/2507.19595)).

---

## 4. From linear algebra to *meaning*: the representational bridge

Why should stacking matrix multiplies produce something that can discuss ethics
or write code? The prevailing explanation in the interpretability literature is
the **Linear Representation Hypothesis (LRH)**: high-level, human-interpretable
concepts are encoded as *directions* in the model's activation space
([arXiv:2311.03658](https://arxiv.org/abs/2311.03658),
[arXiv:2406.01506](https://arxiv.org/abs/2406.01506)).

Three consequences of LRH explain the dispersion:

1. **Concepts are directions, not neurons.** "Formality," "past tense,"
   "is-a-programming-language," or "is-harmful" can each correspond to a
   direction in the residual stream. A `MUL_MAT` against a weight matrix is
   literally a projection that reads how much of each direction is present.

2. **Superposition packs far more concepts than dimensions.** Because the
   relevant directions are *nearly orthogonal* rather than exactly orthogonal, a
   model can store many more features than it has neurons — the phenomenon named
   *superposition*, which also makes individual neurons *polysemantic* (firing on
   several unrelated concepts)
   ([arXiv:2508.16560](https://arxiv.org/abs/2508.16560), building on Elhage et
   al., 2022). This is why a fixed-width vector space can host language, code,
   and normative concepts *at once* — they are dispersed across overlapping
   directions.

3. **Categorical and hierarchical structure is geometric.** Related concepts sit
   in structured geometric arrangements, so "software," "morality," and "law"
   are not separate modules but neighboring regions of one continuous space
   ([arXiv:2406.01506](https://arxiv.org/abs/2406.01506)). The same attention and
   feed-forward productions traverse all of them.

This is the whole trick: **the model never leaves linear algebra.** It reasons
about law the same way it reasons about grammar — by projecting the current
context onto learned directions and mixing them with attention.

---

## 5. The four requested domains, mechanically

### 5.1 General language
Tokenization maps text to IDs; `GET_ROWS` maps IDs to vectors; stacked
attention + SwiGLU blocks disperse and recombine those vectors; the output
projection + softmax produce next-token probabilities. Grammar, morphology, and
long-range agreement are all encoded as directions and attention patterns.
Position (via RoPE) is what lets the model track *word order* — the difference
between "dog bites man" and "man bites dog."

### 5.2 Software paradigms
Code is a formal language with unusually rigid structure, so the same machinery
applies but with a sharper signal. Two codebase features are directly relevant:

- **Constrained decoding.** llama.cpp ships **GBNF grammars**
  (`grammars/README.md`, `grammars/c.gbnf`, `grammars/json.gbnf`). GBNF is a BNF
  variant whose own documentation describes it in terms of **production rules** —
  `nonterminal ::= sequence...` — used to *force* model output to conform to a
  formal grammar. This is the literal, code-level meaning of "productions": the
  *statistical* productions of §2 propose tokens, and the *grammatical*
  production rules of GBNF filter them so that only syntactically legal programs
  or JSON can be emitted. Enabled via `llama_sampler_init_grammar` in
  `include/llama.h`.

- **Sampling controls.** `top_k`, `top_p`, and `temperature` samplers
  (`llama_sampler_init_top_k` / `_top_p` / `_temp`) shape how sharply the
  dispersion collapses to a single choice — the knob between deterministic,
  correct-by-construction code and exploratory generation.

### 5.3 Morality questions
The model has no built-in ethics engine. Moral tendencies are *learned* — first
implicitly from pretraining text, then shaped by alignment procedures such as
Reinforcement Learning from Human Feedback (RLHF) and Direct Preference
Optimization (DPO), where the values are **implicit and inferred from human
preferences over outputs** rather than stated as rules
([arXiv:2410.01639](https://arxiv.org/abs/2410.01639)). Mechanically this just
adjusts the weights that the same `MUL_MAT` productions read, nudging certain
directions to be more or less favored.

The literature is candid about the limits: models often lean on surface patterns
rather than integrating contextual trade-offs and ethical theories the way people
do ([arXiv:2506.14948](https://arxiv.org/abs/2506.14948)); there is documented
"moral indifference" traceable to specific internal mechanisms
([arXiv:2603.15615](https://arxiv.org/abs/2603.15615)); and RLHF-style alignment
carries structural contradictions and cannot fully capture ethical pluralism
([arXiv:2406.18346](https://arxiv.org/abs/2406.18346)). Benchmarks such as
**ETHICS**, **Moral Stories**, and **Social Chemistry 101** exist precisely to
measure the gap ([arXiv:2603.16017](https://arxiv.org/abs/2603.16017)). The
honest framing: the productions can *represent and reproduce* moral discourse;
they do not *possess* moral judgment.

### 5.4 Ordering of laws and legality
Two senses of "ordering," and the codebase touches both:

- **Substantive legal reasoning** (precedence of statutes, hierarchy of courts,
  conflict-of-laws) is, to the model, another region of the concept geometry from
  §4 — hierarchical relationships encoded as directions and traversed by
  attention. It is only as reliable as the legal text in training plus alignment,
  and inherits the same surface-pattern caveats as §5.3.

- **Formal legality of outputs** is enforced *outside* the probabilistic core by
  the same GBNF **production rules** used for code (§5.2). This is the cleanest
  demonstration in the repository that "linear-algebra productions" and
  "formal-grammar production rules" are two complementary layers: the tensor
  productions decide *what is likely*; the grammar productions decide *what is
  permitted*. Legality, in the machine, is a mask applied to a dispersion.

---

## 6. Where the generalization comes from (and the caveat)

The ability to handle tasks the model was never explicitly trained on is often
called **emergence** — capabilities present in large models but absent in small
ones, and not straightforwardly predictable by extrapolating from smaller scales
([Wei et al., arXiv:2206.07682](https://arxiv.org/abs/2206.07682)). There is an
active debate about whether this is genuine emergence or largely the product of
**in-context learning combined with stored memory and linguistic knowledge**,
sometimes sharpened or hidden by the choice of evaluation metric
([arXiv:2309.01809](https://arxiv.org/abs/2309.01809),
[arXiv:2503.05788](https://arxiv.org/abs/2503.05788)).

Either way, the mechanism is the dispersion described here: a fixed alphabet of
linear-algebra productions, run over weights whose geometry encodes concepts as
directions, recombined by attention and gated feed-forward layers, and finally
collapsed to a token — optionally masked by formal production rules to guarantee
syntactic or legal validity.

---

## 7. The vocabulary–intent question: your terms, mapped to the known machinery

This section takes a set of conceptual framings — *"a 2D matrix for vocabulary,"
"increasing the intent over authorship,"* *"a decider,"* *"a 3D trig model for
vocabulary,"* and *"a much richer vocabulary to observe with"* — and translates
each into the corresponding, well-attested Computer Science construct in
`llama.cpp`, then states honestly how much improvement is and is not on the
table. The goal is a faithful mix: keep the intent of the original framing, but
anchor every claim to something real in the source and the literature.

### 7.1 "A 2D matrix for vocabulary" → the **embedding matrix** `[n_vocab, n_embd]`

The intuition is exactly right. In llama.cpp the token embeddings *are* a 2-D
matrix of shape `[n_vocab, n_embd]` — one row per vocabulary entry, each row a
vector of hidden dimension `n_embd`. At the input, `GGML_OP_GET_ROWS` selects the
row for each token ID; at the output, the transpose of a similar matrix projects
the final hidden state back onto vocabulary logits. So "vocabulary" enters and
leaves the model through a flat 2-D table. Everything between the two tables is
the reasoning stack (attention + SwiGLU) described in §2–§3.

**Load-bearing consequence:** the embedding table is *storage of what each token
means in isolation*. It is **not** where reasoning happens. Enriching the table
changes how meaning is *packed*, not how it is *composed*.

### 7.2 "A 3D trig model for vocabulary" → **RoPE**, the one genuinely trigonometric part

There is a real, and only one, place where trigonometry meets vocabulary in this
architecture: **Rotary Position Embedding** (`GGML_OP_ROPE`, §3). RoPE does not
rotate the *vocabulary* table; it rotates the *query and key vectors* by an angle
proportional to a token's position, using paired sine/cosine rotations across the
embedding dimensions. If one wants a "trig model," this is it — but it encodes
**order**, not **meaning**. So the honest mapping of "3D trig model for
vocabulary" is: *the 2-D embedding table (§7.1) supplies meaning; RoPE adds a
rotational, trigonometric encoding of position on top.* Together they are as close
as the architecture gets to a "geometry-plus-trigonometry" model of tokens. There
is no separate trigonometric vocabulary model beyond this, and inventing one would
not correspond to any operation in `ggml.h`.

### 7.3 "Intent / authorship / the decider" → the **decoding (sampling) layer**

The cluster of ideas around *intent over authorship* and *a decider* maps
cleanly onto the **sampler chain** — the stage that decides *which* token is
actually emitted from the probability distribution the network produces. In
llama.cpp this is the sampler API in `include/llama.h` (`llama_sampler_init_top_k`,
`_top_p`, `_temp`, `_grammar`, and others), assembled into a chain via
`llama_sampler_chain_add`. This is the "decider": the network *proposes* a
distribution; the sampler *disposes* by choosing.

The precise, honest statement about how much "authorship" this layer can exert:

- **It can reshape and mask the distribution** — make output more deterministic
  or more exploratory, or forbid tokens outright (grammar). This is real control
  over *style, determinism, and validity*.
- **It cannot add knowledge or reasoning the weights do not already contain.**
  The sampler only reorders and prunes what the productions of §2 already made
  likely. Turning the "decider" up does not deepen reasoning; it sharpens
  *selection*. In the vocabulary of §0, the sampler chooses where along the
  dispersed spectrum to collapse — it does not widen the spectrum.

So "how much better can reasoning be made by giving the decider more authorship
over content?" — bounded, and mostly about *reliability and format*, not
*reasoning depth*. The reasoning ceiling is set upstream, by the trained weights.

### 7.4 "A much richer vocabulary to observe with" → the **vocabulary-size trade-off**

This is the most quantifiable part of your question, and the answer is a genuine
engineering trade-off with a sweet spot, **not** a monotonic "richer is better":

| Effect of enlarging `n_vocab` | Direction | Why |
|---|---|---|
| Sequence length for the same text | **decreases** | each token carries more meaning, so fewer tokens are needed |
| Attention compute (quadratic in length) | **improves** | shorter sequences are cheaper; more content fits the context window |
| Embedding + output-projection parameters | **grows (linear in `n_vocab`)** | both tables scale with vocabulary size; the final softmax also costs more |
| Rare-token quality | **degrades** | a bigger vocabulary spreads training signal thinner; rare tokens are undertrained |
| Coverage of code, math symbols, non-Latin scripts | **improves** | fewer tokenization artifacts, cleaner handling of specialized text |

The historical arc is concrete: LLaMA-1 used a ~32K-token vocabulary; LLaMA-3
moved to ~128K. The larger vocabulary shortens sequences and improves
multilingual/code coverage, at the cost of larger embedding/output tables. The
practical rule is that **the useful vocabulary size scales with model size** —
big models can afford and exploit a richer vocabulary; small models are hurt by
one, because the undertrained-rare-token problem dominates.

**Effect on *reasoning* specifically:** modest and bounded. A richer vocabulary
improves *how efficiently meaning is packed into tokens* and *coverage of
specialized notation* — it does **not** move the reasoning ceiling, which lives
in depth, width, training data, and alignment (§3, §4, §6). There is no theorem of
the form "increase vocabulary by X ⇒ reasoning improves by Y"; the relationship is
non-linear, task-dependent, and empirically a plateau, not a lever.

### 7.5 The honest bottom line

Mixing your framing with the established terms:

- Your **"2D vocabulary matrix"** is the embedding table — real, and it is
  *storage*, not *reasoning*.
- Your **"3D trig model"** is best identified with RoPE — real, and it encodes
  *order*, not *meaning*.
- Your **"intent / authorship / decider"** is the sampler chain — real, and it
  controls *selection, determinism, and validity*, but cannot manufacture
  reasoning the weights lack.
- Your **"richer vocabulary"** is the vocabulary-size trade-off — real, with a
  size-dependent sweet spot and bounded, efficiency-oriented gains.

The single most important correction: **vocabulary and the decider shape how the
dispersion is packed and collapsed; they do not deepen the dispersion itself.**
Reasoning improvement comes from the stack that sits *between* the two vocabulary
tables, not from the tables or the chooser at the ends.

---

## 8. Definitions — the decoding vocabulary (top-k, top-p, and friends)

These are the standard Computer Science terms for the "decider" of §7.3. Each is
a sampler that can be added to the chain in `include/llama.h`. At every step the
network outputs a **logit** (raw score) for every token in the vocabulary;
softmax turns logits into a probability distribution; the samplers below decide
how that distribution is shaped and how a single token is drawn from it.

- **Logits** — the unnormalized scores the model assigns to each candidate next
  token before softmax. Higher logit = the model finds that token more likely.

- **Softmax** — the function that converts a vector of logits into a probability
  distribution (all values in `[0,1]`, summing to 1). Implemented as
  `GGML_OP_SOFT_MAX`. It is what makes the output a *distribution* that the
  samplers below can operate on.

- **Temperature (`temp`)** — a scalar that divides the logits before softmax.
  `temp < 1` sharpens the distribution (more deterministic, the top token
  dominates); `temp > 1` flattens it (more random, more diverse); `temp = 1`
  leaves it unchanged. In llama.cpp: `llama_sampler_init_temp(t)`. Intuitively,
  temperature is *how boldly the decider commits* to the most likely token.

- **Top-k sampling (`top_k`)** — keep only the **k most probable** tokens,
  discard the rest, renormalize, and sample from those k. A fixed-count cutoff.
  Small k (e.g. 1) is nearly greedy/deterministic; larger k admits more
  candidates. In llama.cpp: `llama_sampler_init_top_k(k)`. Example: `top_k = 50`
  means "only ever consider the 50 best next tokens."

- **Top-p sampling / nucleus sampling (`top_p`)** — instead of a fixed count,
  keep the **smallest set of tokens whose cumulative probability reaches p**
  (e.g. `p = 0.9` keeps just enough top tokens to cover 90% of the probability
  mass), then renormalize and sample. This adapts the candidate set to how
  confident the model is: when one token dominates, the set is tiny; when the
  model is unsure, the set widens. In llama.cpp: `llama_sampler_init_top_p(p,
  min_keep)`. "Nucleus" refers to that adaptive high-probability core.

- **Greedy decoding / argmax** — always take the single highest-probability token
  (`GGML_OP_ARGMAX`, or equivalently `top_k = 1`). Fully deterministic; no
  exploration. This is the extreme "maximal authorship by the decider toward the
  single most likely continuation."

- **Grammar-constrained sampling (GBNF)** — a *hard* mask, not a soft reweighting:
  at each step it zeroes out every token that would violate a formal grammar's
  **production rules** (`nonterminal ::= sequence...`), so the output is
  guaranteed to be, e.g., valid JSON or valid C. In llama.cpp:
  `llama_sampler_init_grammar`, with grammars in `grammars/*.gbnf`. This is the
  "legality" layer of §5.4 — the decider enforcing *what is permitted*, on top of
  the statistical productions that decide *what is likely*.

- **Sampler chain** — samplers are composed in sequence (`llama_sampler_chain_add`)
  so that, for example, a grammar mask, then top-k, then top-p, then temperature,
  then a final draw are applied in order. The chain *is* the decider of §7.3 in
  concrete form.

**How these relate to "intent / authorship":** temperature and top-k/top-p tune
*how much freedom vs. commitment* the decider exercises over content; greedy
decoding and grammar constraints are the two ways to exert *maximal* control
(deterministic choice, and hard legality respectively). None of them add
knowledge — they govern *selection* from the distribution the trained weights
produce.

---

## 9. Summary table — production → capability

| Requested capability | Primary productions that carry it | External grounding |
|---|---|---|
| General language | `GET_ROWS`, `MUL_MAT`, `SOFT_MAX`, `ROPE`, SwiGLU | scaled dot-product attention; RoPE for order |
| Software paradigms | above **+ GBNF grammar production rules**, `top_k`/`top_p`/`temp` samplers | constrained decoding over formal grammars |
| Morality questions | same core productions, weights shaped by RLHF/DPO | values inferred from human preferences; known limits |
| Ordering of laws / legality | concept-geometry traversal **+ GBNF masking** | hierarchical concept geometry; formal masking |

**One-sentence thesis.** llama.cpp shows that a small, portable alphabet of
linear-algebra productions — dominated by matrix multiplication, softmax,
normalization, and rotary position — is sufficient to *disperse* a prompt into a
concept geometry rich enough to discuss language, code, ethics, and law, while a
second, formal layer of *grammatical* production rules constrains that dispersion
back into legal form.

---

## Sources

Codebase (vendored under `tools/ai/llama.cpp`):
- `ggml/include/ggml.h` — `enum ggml_op`, `enum ggml_unary_op`, `enum ggml_glu_op`
- `ggml/src/ggml.c`, `ggml/src/ggml-quants.c`, `ggml/src/ggml-backend.cpp`
- `src/llama-graph.cpp` — `build_attn_mha`, `build_ffn`, RoPE application
- `include/llama.h` — sampler API (`top_k`, `top_p`, `temp`, `grammar`)
- `grammars/README.md`, `grammars/*.gbnf` — GBNF production rules
- `README.md` and the [project manifesto (discussion #205)](https://github.com/ggml-org/llama.cpp/discussions/205)

External literature (all rephrased for licensing compliance):
- Scaled dot-product attention: [dev.to](https://dev.to/zeromathai/how-self-attention-works-qkv-softmax-and-matrix-computation-514j), [arXiv:2511.11572](https://arxiv.org/abs/2511.11572), [√dₖ scaling](https://medium.com/@srivatsa.n63/why-is-attention-divided-by-d%E2%82%96-the-secret-behind-scaled-attention-in-transformers-44f36465266f)
- Efficient/linear attention & quadratic cost: [arXiv:2507.19595](https://arxiv.org/abs/2507.19595)
- LLaMA design (RMSNorm, SwiGLU, RoPE): [LLaMA concepts summary](https://akgeni.medium.com/llama-concepts-explained-summary-a87f0bd61964)
- Position encoding & RoPE: [arXiv:2608.10021](https://arxiv.org/abs/2608.10021), [arXiv:2602.10959](https://arxiv.org/abs/2602.10959)
- Linear Representation Hypothesis & concept geometry: [arXiv:2311.03658](https://arxiv.org/abs/2311.03658), [arXiv:2406.01506](https://arxiv.org/abs/2406.01506)
- Superposition & polysemanticity: [arXiv:2508.16560](https://arxiv.org/abs/2508.16560) (building on Elhage et al., 2022)
- Emergent abilities & the in-context-learning debate: [arXiv:2206.07682](https://arxiv.org/abs/2206.07682), [arXiv:2309.01809](https://arxiv.org/abs/2309.01809), [arXiv:2503.05788](https://arxiv.org/abs/2503.05788)
- Moral reasoning, value alignment (RLHF/DPO) & limits: [arXiv:2410.01639](https://arxiv.org/abs/2410.01639), [arXiv:2506.14948](https://arxiv.org/abs/2506.14948), [arXiv:2603.15615](https://arxiv.org/abs/2603.15615), [arXiv:2406.18346](https://arxiv.org/abs/2406.18346), [arXiv:2603.16017](https://arxiv.org/abs/2603.16017)

*Content from external sources was rephrased and summarized for compliance with licensing restrictions; factual substance is preserved.*
