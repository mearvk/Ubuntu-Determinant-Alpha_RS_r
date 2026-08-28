# Ubuntu.Determinant.Beta.Restricted

## SecureJDK / Graal Proffer Project

This repository is an experimental systems project exploring a common security and modeling vocabulary across **SecureJDK, Graal, native C/C++, operating-system state, memory, process, geometry, time, provenance, and hardened historical/economic data**.

The project's central proposition is intentionally ambitious:

> **A modern secure runtime should know not only what it is doing, but where the state came from, what transition produced it, what capability it exercises, why the transition is permitted, and what should be examined next.**

The project calls this framing **Proffer**.

---

## Total: Three-Tier Native Moderator

**Total** is the project's native C/C++ moderator layer. It sits between Linux kernel state and ordinary userland policy, with controlled cooperation from SecureJDK 28 and Graal.

```text
                 TOP
        SecureJDK 28 / Graal
       managed semantics
                │
       authenticated evidence
                ▼
              MIDDLE
               Total
        native moderation
                │
       kernel / OS evidence
                ▼
              GROUND
       Linux kernel / hardware
```

The three tiers are logically aware of one another while retaining separate authority. Ground establishes operating-system facts. Total mediates evidence, resource policy, provenance, and service behavior. Top supplies managed-runtime and application semantics.

The native Total bootstrap lives under `/total/`. It is deliberately conservative: it observes Linux memory state, maintains controlled admission accounting, and provides a foundation for future systemd, cgroup, PSI, eBPF, SecureJDK/Graal IPC, provenance, and policy modules. It does not replace Linux virtual memory, `malloc`, `free`, or JVM garbage collection.

### Evidence surface

Total has an extensible input surface. A deployment may expose **3 through 1000 input channels at startup**, according to configuration, hardware, policy, and service profile. Potential evidence includes process/thread state, memory pressure, allocation observations, executable/library descriptors, package metadata, JVM/Graal runtime events, trusted software descriptors, signed configuration, filesystem provenance, service lifecycle events, application self-description, cgroup/PSI observations, integrity measurements, resource requests, and diagnostic/test evidence.

Evidence follows:

```text
input → normalization → provenance → validation → policy
      → action → observation → retained evidence
```

The existence of an input is not proof of truth. Provenance, validation, authorization, and policy determine what an input may influence.

### Root service function and manager

The inward/main service function is:

```text
observe → understand → admit → serve → measure → correct
```

Related functions across Ground, Total, and Top should remain **memmerable**: recognizable as implementations of the same root operation even when their local mechanisms differ.

Total is the middle-tier **manager / manager / memory manager**: policy coordination, native service execution, and memory/resource accounting. It observes and mediates without silently seizing ownership of arbitrary application allocations.

Minor implementation variance between tiers and platforms is permitted where it preserves the root invariants. This intentional **color** must not silently alter authority, provenance, memory-safety guarantees, or proof meaning.

See [`markdown/THREE_TIER.md`](markdown/THREE_TIER.md) for the detailed proving-surface specification.

---

## Domain Services

The same three-tier mechanism can support applications operating in regulated or sensitive commercial domains through explicit **domain-service adapters**. Initial examples include:

- **Banking** — transaction provenance, payment authorization, service permissions, audit evidence, and integrity state.
- **Hospitality / hotels** — property identity, reservation state, payment authorization, service lifecycle, and operational evidence.
- **Regulated adult services** — provider authorization, eligibility/age verification where legally required, consent state where the application records it, payment provenance, licensing, jurisdictional restrictions, and audit evidence.
- **Other regulated commerce** — licensing, eligibility, authorization, provenance, compliance, and audit evidence.

The common domain surface is:

```text
identify → describe → authorize → transact → observe → retain → audit
```

The domain application remains the business authority. Total supplies infrastructure for evidence, provenance, resource policy, and controlled mediation.

For sensitive services, the architecture follows data minimization, least privilege, purpose limitation, bounded retention, authenticated evidence, and explicit authorization. In particular, **consent must never be inferred from payment, identity, presence, or prior behavior**.

> **Total proves and mediates the mechanism; it does not decide a person's worth, humanity, consent, or dignity.**

Software identity is likewise based on trusted descriptors, signatures, package provenance, executable identity, dependency metadata, and administrator policy—not branding alone.

The full domain-adapter specification is in [`markdown/DOMAIN_SERVICES.md`](markdown/DOMAIN_SERVICES.md).

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

A future `.jpix` implementation should make pixel format, alpha semantics, coordinate ordering, boundary information, and canonical pixel ordering explicit. A canonical pixel hash can then identify the exact canonical pixel state.

The initial binary format should remain intentionally small: magic/version, pixel-map geometry, pixel format, alpha semantics, canonical pixel data, boundary/extent information, integrity information, and optional codec/render metadata.

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

The minimum observable record should contain only the information needed to reproduce the model result: model version, timestamp/tick, transition identifier, bounded scatter metric, and relevant provenance/version identifiers.

---

## SecureJDK 28 and Graal

The project treats the current OpenJDK/Graal variant as **SecureJDK 28** and intends the security and provenance model to be native to the runtime rather than a bolt-on application library.

The intended layering is:

```text
Application
    ↓
SecureJDK 28
    ↓
Graal runtime / compiler
    ↓
Proffer + Total assistance
    ↓
Linux
```

SecureJDK is expected to preserve ordinary Java compatibility where practical while adding explicit provenance, policy, resource, and integrity hooks. Graal participates as the execution/compiler layer and should be able to consume the same evidence model without becoming the final authority over kernel resources.

### Total integration

Supported Java programs may run through the SecureJDK/Graal path with Total providing policy assistance and memory/resource observation. Native programs may continue to use the ordinary OS allocator and VM path. Participation in the managed path should be explicit and authenticated.

### Repository status

The project is experimental. Native Total, UTF-4088, JPIX, SecureJDK/Graal integration, and domain-service adapters should not be treated as production-certified merely because the architecture is complete on paper. The project prioritizes deterministic behavior, evidence, provenance, reproducibility, and auditable policy as it progresses toward a larger Linux framework.

For current repository maturity and remaining engineering work, see [`markdown/PROGRESS.md`](markdown/PROGRESS.md).

---

## Native Utilities: `size` and `limit`

The repository now includes small native utilities under `/tools` for direct inspection of the local system.

### `size`

`/tools/size/` provides a portable C implementation for recursively measuring the **logical byte size of a parent folder and all regular files beneath it**. It reports exact bytes plus a human-readable binary-unit value and accepts multiple paths.

```text
size tools/xmc tools/gcc tools/limit
```

The utility is read-only. POSIX symbolic links are not followed; Windows reparse points are not recursively followed. Its result is logical file length, not filesystem allocation, so it deliberately does not claim to measure disk blocks, snapshots, compression, or other filesystem overhead.

The initial utility version is `size 1.00`. See [`tools/size/README.md`](tools/size/README.md).

### `limit`

`/tools/limit/` inventories executable formats and available application identity metadata. It complements `size`: `size` answers **how much file data exists**, while `limit` answers **what executable identity and metadata can be established**.

Together they provide a simple native inspection surface for source/build/output directories and installed binaries.

---

## Desktop News: GNOME and MATE

The project is continuing its desktop work with attention to **GNOME** and **MATE Desktop** environments. The goal is a practical, respectful desktop integration layer that keeps the Ubuntu White / JavaFX direction coherent while remaining useful on established Linux desktops.

Current desktop priorities include:

- **GNOME** — integration and preview work should respect the GNOME desktop model, application launch conventions, icon presentation, and current Linux session behavior.
- **MATE Desktop** — integration should preserve the familiar, lightweight MATE experience while providing the same icon, launcher, and Java desktop-preview capabilities.
- **Shared assets** — desktop references should use the project's PNG/JPEG icon sources where appropriate, with transparent backgrounds preserved and the source assets kept explicit.
- **JavaFX preview** — the desktop preview remains a full-screen-capable JavaFX interface, with `ESC` available to exit full-screen mode.

We appreciate the volunteer efforts of **SAS** and **CorpAmerica** as contributors and supporters of open collaboration. As volunteers, we aim to **Pull ahead**: contribute carefully, review what we build, improve interoperability, and leave the desktop in a better state for the next contributor.

This is a community-minded project statement rather than an assertion of affiliation, endorsement, or employment by any organization named above.

**Max Rupplin — MEARVK LLC — 2026**
