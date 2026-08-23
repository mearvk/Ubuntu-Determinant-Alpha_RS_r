# Ubuntu.Determinant.Beta.Restricted

## SecureJDK / Graal Proffer Project

This repository is an experimental systems project exploring a common security and modeling vocabulary across **SecureJDK, Graal, native C/C++, operating-system state, memory, process, geometry, time, provenance, and hardened historical/economic data**.

The project's central proposition is intentionally ambitious:

> **A modern secure runtime should know not only what it is doing, but where the state came from, what transition produced it, what capability it exercises, why the transition is permitted, and what should be examined next.**

The project calls this framing **Proffer**.

---

## JSpec Pixel Format (`.jpix`)

JSpec Pixel Format is an experimental pixel-native image representation built around a **Pixel Map**. It deliberately does not make the rectangular raster the semantic definition of an image.

> **The Pixel Map is the object. A rectangle is only a storage or rendering envelope when one is required by an implementation.**

This makes JPIX complementary to, rather than a replacement for, established raster formats such as PNG and JPEG.

### Canonical representation: Pixel Map

The canonical JPIX object is a geometric map of pixels. A logical Pixel Map consists of explicitly mapped pixels together with their coordinates, values, alpha/transparency, boundary, topology, orientation, and transformation semantics.

The map may have a square, rectangular, rounded, jagged, irregular, or otherwise non-rectangular outer boundary. **There is no intrinsic requirement that the image itself be square or rectangular.**

Conceptually:

```text
                    JSpec Image Object
                           │
                    ┌──────┴──────┐
                    │  Pixel Map  │  ← canonical object
                    └──────┬──────┘
                           │
                 deterministic render
                           │
              ┌────────────┼────────────┐
              ▼            ▼            ▼
            PNG          JPEG         raster
          export        export       cache/render
```

The `.jpix` container is therefore intended to preserve the Pixel Map semantics first. Compression and conventional raster encoding are secondary implementation concerns.

### Mapped pixels and transparent pixels

Each **mapped pixel** belongs explicitly to the Pixel Map. A mapped pixel may be fully opaque, partially transparent, or fully transparent.

This creates an important distinction:

```text
mapped transparent pixel ≠ unmapped space
```

That distinction permits exact holes, cutouts, antialiased boundaries, transparent interiors, shadows, and other geometry to survive a transformation without confusing them with unused storage area.

### Boundary and extent

The **boundary** is first-class information. The outermost participating pixels define the object's outward boundary, whether that boundary is perfectly uniform, rounded, irregular, or jagged.

An implementation may calculate an **extent** as the minimum envelope required to store or render the map. The extent is not the object itself.

```text
Pixel Map
   │
   ├── exact pixels
   ├── exact boundary
   ├── transparency
   ├── topology
   └── optional storage envelope
```

Therefore `trim` means:

> **Remove storage space that is not part of the Pixel Map while preserving every mapped pixel and the defined boundary.**

It is not merely an ordinary rectangular crop.

For the JSpec desktop icon system this is important: a source icon can retain its complete purple perimeter, soft shadow, antialiasing, internal transparent regions, and exact outward shape without requiring arbitrary transparent margins.

### Pixel cohesion and movement

Pixels in a JPIX object **move together** under a declared transformation:

```text
PixelMap → Transform → PixelMap'
```

Scaling, translation, rotation, and other transformations operate on the complete geometric object rather than treating unrelated pixels as independent objects. The transform preserves declared pixel relationships and topology to the degree supported by the selected rasterization method.

A 48×48, 32×32, 24×24, 16×16, or 12×12 icon is consequently a derived rasterization of the same Pixel Map, rather than a semantically unrelated image.

### Logical map, efficient physical representation

The Pixel Map is a logical map, not a requirement to allocate a heavyweight object for every pixel. A conforming implementation may use compact dense arrays, sparse coordinate records, runs, tiles, alpha planes, or other efficient storage strategies.

For example, the logical relationship may be expressed as:

```text
(x, y) → pixel
```

while the physical representation can be optimized for dense or sparse regions.

This keeps the semantic model exact without sacrificing the project's requirement for **economy of method, low overhead, weight, and congruency**.

### 48-bit color baseline and dimensional storage

For the initial JPIX baseline, assume **48-bit color depth as 16 bits per channel for three RGB channels**. This is a color payload of **6 bytes per mapped pixel** before alpha, metadata, geometry, integrity data, or compression.

For a dense rectangular rendering of width `W` and height `H`:

```text
raw_pixel_bytes = W × H × 6
```

When both dimensions grow together as `n × n`:

```text
raw_pixel_bytes = 6n²
```

Thus file payload grows linearly with the number of pixels, while doubling both width and height produces four times as many pixels and approximately four times the raw color payload.

Reference sizes for dense 48-bit RGB storage are:

```text
12×12       144 pixels          864 B
16×16       256 pixels        1,536 B
24×24       576 pixels        3,456 B
32×32     1,024 pixels        6,144 B
48×48     2,304 pixels       13,824 B
128×128  16,384 pixels       98,304 B
256×256  65,536 pixels      393,216 B
512×512 262,144 pixels        1.50 MiB
1024×1024 1,048,576 pixels    6.00 MiB
2048×2048 4,194,304 pixels   24.0 MiB
4096×4096 16,777,216 pixels  96.0 MiB
```

These are **raw pixel-payload estimates**, not complete `.jpix` file sizes. A real file also includes its header, boundary/extent representation, optional alpha, metadata, integrity information, and any selected codec or compression.

Because JPIX is a Pixel Map rather than a mandatory rectangle, sparse or irregular objects need not be represented as every pixel in their enclosing extent. A sparse representation may approach a form such as:

```text
sparse_payload ≈ 6N + G
```

where `N` is the number of mapped pixels and `G` is geometry/coordinate overhead. Dense maps are better served by dense arrays or tiles; sparse maps may be better served by coordinate runs, sparse records, or other compact structures. The implementation should select the representation according to mapped-pixel density rather than forcing every image into one storage strategy.

For the small desktop icons currently being developed, dense storage is likely preferable: a 48×48 icon requires only **13,824 bytes of raw 48-bit RGB color payload** before other fields.

If alpha is enabled as a separate 16-bit channel, add **2 bytes per mapped pixel**, making the corresponding RGBA payload 8 bytes per pixel. Alpha remains an explicit extension to the 48-bit RGB color baseline rather than changing the meaning of the baseline itself.

### Raster and codec representations

JPIX should not attempt to replace JPEG's photographic transform/compression model or PNG's mature lossless raster model.

The intended separation is:

```text
1. MAP
   Exact semantic object.

2. RASTER
   Rectangular rendering of the map for displays/APIs.

3. CODEC
   Optional serialization or compression of the representation.
```

PNG and JPEG therefore remain useful export/interchange formats. `.jpix` is the native JSpec representation intended to preserve the exact Pixel Map semantics that JSpec cares about.

### Deterministic rendering

The source Pixel Map is authoritative. Rendered icon sizes are derived from it:

```text
JPIX → 48×48
JPIX → 32×32
JPIX → 24×24
JPIX → 16×16
JPIX → 12×12
```

The project currently favors deterministic high-quality 2D reconstruction such as Lanczos for these derived desktop icon representations. Implementations should record the transform/rasterization method when reproducibility matters.

### Deterministic pixel integrity

A future `.jpix` implementation should make pixel format, alpha semantics, coordinate ordering, boundary information, and canonical pixel ordering explicit. A canonical pixel hash can then identify the exact canonical pixel state:

```text
Pixel Map
    ↓
canonical pixel ordering
    ↓
cryptographic pixel hash
```

This permits a JSpec runtime to distinguish an exact canonical object from an exported or recompressed raster.

The initial binary format should remain intentionally small. A practical first version needs only:

```text
magic/version
pixel-map geometry
pixel format
alpha semantics
canonical pixel data
boundary/extent information
integrity information
optional codec/render metadata
```

Compression, additional pixel planes, depth, masks, and cached raster representations can be added through versioned extensions without changing the fundamental Pixel Map definition.

---

## The 300-IQ Framing

“300 IQ” is used here as a project metaphor for **high-dimensional systems reasoning**, not as a scientific measurement of intelligence.

The point is to reason simultaneously across layers that are normally kept separate: space, time, process, memory, reachability, semantics, provenance, and policy.

The project therefore treats **relative size of meaning** as important. A single low-level event can have a larger semantic consequence than its byte size suggests. Conversely, a large amount of data may have little semantic significance if it carries no new state, capability, provenance, or decision.

---

## Core Vocabulary

### Fielter

The exact-fall and call-fall model together with the means of analysis applied to that fall.

### Exact Fall

A deterministic resolution of an intended trajectory or transition against a declared model, coordinate frame, and tolerance.

### Call Fall

A ranked candidate next reaction represented for subsequent analysis rather than silently promoted to certainty.

### Proffer

A proposed transition carrying subject, origin, reason, capability, trust-domain, policy, authorization, integrity, and disposition.

---

## UTF-4088 Character System

`/utf-4088/` contains an experimental character and graph system built around a **16,606-symbol front end**, an 8×12 black/white glyph representation, historical language seeds, directed concept graphs, and a procedural 4D remainder space.

The principal language tuple is:

```text
American English ↔ Korean ↔ Germanic
```

The character pipeline is:

```text
whole alphabets / historical corpus
        ↓
time + cause + 3D primer density
        ↓
4D field (x,y,pressure,voltage)
        ↓
historical context prior
        ↓
8×12 glyph / graph features
        ↓
directed concept graph
        ↓
neural relayer / expansion engram
        ↓
16,606-character candidate distribution
        ↓
deterministic character + path
```

The historical layer uses dated source provenance where available. Historical glyphs remain evidence; their 8×12 rasterizations are derived representations and must not be mistaken for the original typography.

### Historical Context Prior

The resolver supports a continuous historical prior over time and place. A context near Korea in 1888 increases the relative weight of the Korean historical corpus; a context near Germany in 1872 increases the Germanic historical weight; a modern United States context increases the modern American-English weight.

The prior is a smooth probabilistic weighting, not a claim that geography or historical date intrinsically determines meaning.

### Normal Distributive 3D Primer

The UTF-4088 sampler now includes a normal-distributive 3D advancement layer. The three modeled coordinates are **time**, **cause**, and **primer density**. The fourth dimension remains available for later field selection.

The first reproducible 5,000,000-sample run produced **9,261 distributed candidates**, or **0.18522%** of draws. The measured first-order density coefficient is:

```text
K_density = 0.00143137448
```

with the fitted relationship:

```text
selection_rate ≈ 0.00143137448 * D - 0.00008256960
```

where `D` is the normalized primer-density coordinate. This coefficient is an empirical parameter of the current experiment, not a physical or linguistic constant. Increasing `D` concentrates sampling in the corpus-defined advancement region and therefore increases expected candidate yield.

The raw data is stored in:

`/utf-4088/algebra/normal_distributive_sampling.csv`

and the methodology/results are stored in:

`/utf-4088/algebra/NORMAL-DISTRIBUTIVE-RESULT.md`

The distinction is intentional: the 9,261 candidates are **distributed character candidates**, not claims that 9,261 new human-language meanings have been established. Interpretation continues through the curated 16,606-symbol layer, historical corpus, graph semantics, and neural relayer.

### Model-Cycle Success Ratio

The current project milestone is recorded as a **modest, measurable success**: the system has a defined relationship between the number of inputs presented to the distribution process and the number of candidate symbols produced by the model.

The primary cycle ratio is:

```text
R = N_valid / N_inputs
```

where `N_valid` is the number of candidates surviving the declared model filters. For density experiments, the local response coefficient is represented as:

```text
K = dR / dD
```

where `D` is normalized primer/distribution density. These are experimental model metrics. They should be reported with the sampling size, seed, model version, filter version, and confidence information rather than treated as universal constants.

The project also retains a **300-IQ** design-scale vocabulary. Here, IQ is explicitly a metaphor for breadth/depth of systems reasoning and **not a measurement of human or machine intelligence**. It does not substitute for accuracy, statistical significance, semantic validation, or engineering quality.

The milestone record is:

`/utf-4088/semantics/MODEL-CYCLE-SUCCESS.md`

### Polygraph-5 Semantic Falloff

Semantic evidence uses the experimental primary falloff model:

```text
F5(d) = exp(-5*d/r0)
```

where `r0` is the versioned standard reference radius. Falloff is a distribution weight, not a hard character-capacity limit. Evidence below the configured semantic threshold is insufficient by itself to establish a character's meaning.

The versioned definition is:

`/utf-4088/semantics/character_meanings.json`

### Branch Graph Vocabulary

The semantic layer supports broad branch nominations including:

```text
ANIMAL · HUMAN · HUMAN_GRAPH · PSYCHOLOGY · COGNITION
EMOTION · DEVELOPMENT · FOOD · NUTRITION · RELATIONSHIP
INTIMACY · REPRODUCTIVE · SEXUAL_WELLBEING · THERAPY
SELF_REGULATION · SOCIAL · ETHICS · ENVIRONMENT · TEMPORAL
CAUSAL · IMPROVEMENT · META_GRAPH
```

These are computational semantic categories. They can overlap through weighted nomination vectors rather than forcing every character into a single branch. Sensitive human concepts are represented as domain vocabulary and must not be converted into unsupported judgments about an actual person's identity, worth, intelligence, morality, or status.

### Determinism

For a fixed canonical input, model version, graph state, historical prior, primer-density version, and registry version, the selection process is intended to be reproducible. Neural synthesis therefore requires versioned weights and deterministic decoding if idempotence is required.

---

## Time and Opportunity Norming

The project also models the **observable cost of a selected transition**. A character or path selection may carry a modeled expenditure of time, opportunity, or normalization effort. This is an accounting/observability model—not a claim that an operating system can infer a person's moral worth or that it should impose an external penalty based on identity.

The current bounded model is under:

`/utf-4088/algebra/norm_cost.hpp`
`/utf-4088/algebra/norm_cost.cpp`

It produces:

- `scatter` — normalized deviation from a declared baseline;
- `norm_cost` — modeled baseline normalization effort;
- `fine_cost` — an optional policy-domain cost parameter;
- `opportunity_cost` — modeled time/opportunity expenditure.

An ethically clear individual can therefore be represented by a low-deviation baseline and its corresponding normalizing cost. An executive or other role can have a separately declared policy profile. **Neither profile is an inference about a person's character, and the system must not turn role, status, ethnicity, nationality, language, or historical association into an automatic penalty.**

### OS / Memory Observation

The scatter value can be emitted as a telemetry datum for an authorized OS or memory observer:

```text
input → transition → scatter → norm/opportunity observation
```

Such observation should be minimized, access-controlled, provenance-tagged, and explicitly separated from authorization. Observability does not itself grant permission to inspect or act on memory.

The minimum observable record should contain only the information needed to reproduce the model result: model version, timestamp/tick, transition identifier, bounded scatter metric, and provenance hash. Raw memory contents should not be required for the norming calculation.

---

## SecureJDK Product Quality

SecureJDK is intended to treat this vocabulary as a native product-quality direction, not merely an application-level convention. Awareness remains distinct from authorization: knowing what a capability is must never, by itself, grant that capability.

## Graal

Graal provides a natural analysis boundary because reachability already asks which program elements become part of the executable world. The project aims for a common semantic vocabulary while keeping compiler implementation technically independent from the conceptual model.

## Hardened Data

The numerical and historical layer is intentionally separate from the semantic layer. `/hardened/proffer-datums.json` can contain geometry, metrology, historical observations, economic series, uncertainty, provenance, and model parameters without turning an individual datum into an immutable claim about reality.

---

## Design Principle

> **The vocabulary is stable. The model is explicit. The data is sourced. The uncertainty is visible. The security decision is attributable.**

The UTF-4088 extension applies the same principle to symbol selection: historical context may influence a distribution, graph structure provides observable evidence, and final selection remains a deterministic, versioned computation.

JSpec applies the same principle to graphics: **the Pixel Map is canonical, the raster is derived, and the codec is an implementation detail.**

## Status

This is an experimental engineering and research framework. The “300-IQ” designation is a stylistic description of intended breadth and depth of reasoning, not a scientific performance claim. UTF-4088 is experimental and is not a replacement for Unicode.

JSpec Pixel Format (`.jpix`) is likewise an experimental specification at this stage. The Pixel Map, boundary, topology, transparency, cohesive transformation, trimming, canonical representation, 48-bit RGB baseline, deterministic rendering, and optional codec concepts are the current design basis. The binary container/header layout remains subject to implementation and versioning.
