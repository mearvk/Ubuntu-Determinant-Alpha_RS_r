# DEFINITIONS — Master Glossary

**Project:** Ubuntu Determinant
**Edition:** Ubuntu White Edition
**Project attention:** Max Rupplin — MEARVK LLC — 2026
**Status:** Master glossary for the repository

---

## 1. Purpose

This is the master glossary for the project. It defines the terms that are
defined or referenced across the repository — both the project's own coined
vocabulary (Proffer, Total, the three tiers, JPIX, UTF-4088, and related terms)
and the terms used by the vendored-source documentation set.

Governing documentation this glossary serves:

- [`README.md`](README.md) — the project overview and core vocabulary.
- [`tools/git/FOUNDING.md`](tools/git/FOUNDING.md) — founding note for the vendored Git source.
- [`MODIFICATIONS.md`](MODIFICATIONS.md) — record of deviations from upstream.
- [`HEADINGS.md`](HEADINGS.md) — attribution standard for new code.
- [`tools/git/EXPLANATIONS.md`](tools/git/EXPLANATIONS.md) — the Git command set.

It defines terms that carry a specific meaning in this repository so the working
experience stays clear and continuable. Where a term is Git's own, industry
standard, or specified in full elsewhere in the repository, the definition notes
that and points to the authoritative source rather than redefining it.

**Reader's note.** This project uses several terms — *300 IQ*, *color*,
*fall*, *scape*, *net universe* — as deliberate design metaphors. They describe
software modeling constructs. They are **not** measurements of human or machine
intelligence, worth, or physical reality. This caution is part of the
definitions, not a disclaimer around them.

Terms are grouped by topic; within each group they are alphabetical.
[Sections 2–6](#2-documentation-artifacts) cover the vendored-source and Git
documentation. [Sections 7–13](#7-project-architecture--proffer) cover the wider
project vocabulary.

## 2. Documentation artifacts

**DEFINITIONS (this document).** The glossary of terms used by the vendored-source
documentation set.

**EXPLANATIONS.** The reference that documents the Git command (method) set:
every command with its invocation, importance rating, classification, and
purpose. See [`tools/git/EXPLANATIONS.md`](tools/git/EXPLANATIONS.md).

**FOUNDING note.** A document that founds the repository's relationship to a
vendored third-party source tree: what is vendored, its provenance, what is and
is not modified, its license, and how to re-acquire it. See
[`tools/git/FOUNDING.md`](tools/git/FOUNDING.md).

**HEADINGS.** The standard establishing that new code authored for this
repository is the work of *Max Rupplin — MEARVK LLC — 2026*, with the per-file
heading forms to apply. See [`HEADINGS.md`](HEADINGS.md).

**MODIFICATIONS record.** The repository-wide record of how each vendored source
tree differs from its upstream original, under the headings Additions,
Omissions, and Alterations. See [`MODIFICATIONS.md`](MODIFICATIONS.md).

## 3. Vendoring, provenance, and source management

**Acquisition.** The command and method by which a vendored tree was obtained
(for the Git source: `git clone --depth 1` via `tools/git/pull-source.sh`).

**Additions.** In the modification record, repository-local files placed
alongside upstream source (for example `commit.sh` and `.source-commit`). They
are project files, not upstream ones.

**Alterations.** In the modification record, edits made to upstream source files
themselves. "None" means the upstream files are byte-faithful to the recorded
snapshot commit.

**Faithful (byte-faithful).** Identical to the upstream source at the recorded
snapshot commit, with no content edits. The Git source under `tools/git/git/` is
faithful except for the documented Additions and Omissions.

**Flattened source snapshot.** A copy of upstream source at one point in time,
stored as ordinary files without upstream Git history, submodule gitlinks, or a
live `.git` database. It is a snapshot for local use, not a fork or a mirror.

**Fork.** A copy of a project intended to diverge from and evolve independently
of its upstream. The vendored Git source is explicitly **not** a fork.

**Gitlink.** A Git index entry that records a submodule as a single commit
reference rather than as files. A gitlink with no populated submodule content is
a *dangling* reference; the modification record omits such references
deliberately.

**Mirror.** A copy that tracks upstream's live history and refs. The vendored Git
source is **not** a mirror; it is a single snapshot.

**Omissions.** In the modification record, upstream files intentionally left out
of the snapshot (for the Git source: `.gitmodules` and the unpopulated
`sha1collisiondetection` submodule).

**Provenance.** The recorded origin of vendored source: the upstream repository,
release marker, and exact snapshot commit, stored authoritatively in
[`tools/git/git/.source-commit`](tools/git/git/.source-commit).

**Release marker.** The upstream version label a snapshot corresponds to (for the
current Git source, `v2.55.GIT`). Paired with the snapshot commit for precision.

**Re-verify.** To confirm a vendored tree still corresponds to a known upstream
state by comparing it against the recorded provenance.

**Snapshot commit.** The exact upstream commit hash a snapshot was taken from
(currently `c73e85354c275c9d409b26445089bc16940fc527`). The authoritative
pointer to "which upstream state this is."

**Vendored source.** Third-party source code copied into this repository for
local build and source-management use, kept distinct from application source and
governed by a founding note and the modification record.

## 4. Attribution and authorship

**Attribution boundary.** The explicit statement that this repository does **not**
claim authorship of vendored third-party software; upstream copyright and license
notices inside the source tree remain authoritative.

**Attribution line.** The canonical single line identifying new project work:
`Max Rupplin — MEARVK LLC — 2026`. Defined in [`HEADINGS.md`](HEADINGS.md).

**New (project-authored) code.** Files created for this repository as part of
Ubuntu Determinant, which carry the project heading. Distinct from vendored
upstream files, whose original notices are never overwritten or re-attributed.

**Re-attribution.** Reassigning authorship of existing work. Upstream authorship
is never re-attributed to the project.

## 5. Project framing terms used by these documents

These are the wider repository's own terms, defined here only as used by the
vendored-source documentation. The authoritative definitions live in the project
root [`README.md`](README.md).

**Continuable / continuance.** The property that work can be reproduced,
re-verified, advanced, and maintained by a future maintainer without guesswork.
A stated aim of the founding note and this glossary.

**Infrastructure, not application source.** Repository policy classifying the
Git tooling and vendored source as reusable build/tooling infrastructure that
stays independent of GNOME, MATE, Ubuntu White Edition, and individual upstream
projects, so it can be reused by the ISO build system.

**Software art.** The project's framing for the craft embodied in the source it
depends on; the founding note aims to give that work a clean, durable home.

**Ubuntu Determinant / Ubuntu White Edition.** The project and edition names that
appear in every document header. Used here as identifiers; see the project
`README.md` for their full meaning.

## 6. Git command-classification terms

Git classifies its own commands in `tools/git/git/command-list.txt`. These
definitions summarize that classification as used by
[`tools/git/EXPLANATIONS.md`](tools/git/EXPLANATIONS.md); Git's documentation is
authoritative.

**Ancillary command.** A user-facing command that is not part of the everyday
core — configuration, inspection, or maintenance. Git splits these into
*ancillary interrogators* (read/report) and *ancillary manipulators* (change
state). Example: `git config`, `git fsck`.

**Classification.** Git's own category for a command, taken from
`command-list.txt`. Used in EXPLANATIONS as a principled, non-arbitrary basis for
the importance rating.

**Command (method).** An invocable Git operation — the `git <verb>` surface a
user or script calls. In EXPLANATIONS, "method set" means this command surface,
not Git's internal C functions.

**Foreign SCM interface.** A command that bridges Git with another
source-control system (for example `git svn`, `git p4`, `git cvsimport`).

**Importance rating (1–10).** The EXPLANATIONS score, where 10 is most important;
derived from Git's classification and typical usage frequency, not a judgment of
engineering quality. See EXPLANATIONS Section 3 for the full scale.

**Interrogator.** A command that reads and reports repository state without
changing it.

**Main porcelain.** Git's term for the high-level, user-facing commands that make
up the everyday working experience (for example `git add`, `git commit`,
`git log`). Contrasted with plumbing.

**Manipulator.** A command that changes repository state.

**NAME line.** The one-line purpose of a command, taken verbatim from the `NAME`
section of its upstream manual page in `tools/git/git/Documentation/`. Used as
the "Purpose" column in EXPLANATIONS.

**Plumbing.** Git's term for low-level building-block commands used by scripts,
tools, and porcelain internals (for example `git cat-file`, `git rev-parse`).
Split into *plumbing interrogators* and *plumbing manipulators*.

**Porcelain.** The user-facing command layer built on top of plumbing. Git's
standard term for its high-level commands.

**Pure helper.** An internal scriptlet or helper not normally invoked directly by
users (for example `git sh-setup`, `git mailsplit`).

**Synchronization command / helper.** Transport-layer commands that move objects
between repositories, usually invoked indirectly by fetch/push (for example
`git upload-pack`, `git receive-pack`, `git daemon`).

## 7. Project architecture — Proffer

Authoritative source: [`README.md`](README.md),
[`markdown/PROFFER_FRAMING_SEED.md`](markdown/PROFFER_FRAMING_SEED.md), and
[`markdown/TOTAL.md`](markdown/TOTAL.md). The definitions below summarize those
records; the coined terms are stable and must not be silently redefined.

**300 IQ (300-IQ framing).** A design metaphor for **high-dimensional systems
reasoning** — reasoning simultaneously across space, time, process, memory,
reachability, semantics, provenance, and policy. Explicitly **not** a
measurement of human or machine intelligence, and no substitute for accuracy,
statistical significance, or engineering quality.

**Color.** Intentional, controlled implementation variance between tiers,
platforms, or versions that preserves the common proving shape. Color must never
silently alter authority, provenance, memory-safety guarantees, or the meaning
of a proof; material variance is surfaced as evidence and versioned policy.

**Evidence surface.** The extensible set of controlled inputs Total may accept
(a deployment may expose **3 through 1000 input channels** at startup). The
existence of an input is not proof of truth; provenance, validation,
authorization, and policy determine what an input may influence.

**Memmerable.** An engineering property of related functions across the tiers:
recognizable as implementations of the same root operation even when their local
mechanism differs between kernel, native Total, and JVM/Graal environments.

**Proffer.** The project's central framing. As a design proposition: a secure
runtime should know what it is doing, where its state came from, what transition
produced it, what capability it exercises, why the transition is permitted, and
what to examine next. As a concrete object: a **proposed transition/decision
carrying subject, origin, reason, capability, trust-domain, policy,
authorization, integrity, and disposition**.

**Provenance.** The recorded origin and lineage of state or evidence — source,
time, scope, and confidence/provenance class — used to determine what an input
or transition may influence. (See also the vendored-source sense in
[Section 3](#3-vendoring-provenance-and-source-management).)

**Relative size of meaning.** The principle that semantic consequence is not
proportional to byte size: a small event can carry large semantic consequence,
and a large amount of data can carry little if it introduces no new state,
capability, provenance, or decision.

**Root service function.** The canonical inward service path shared across tiers:
`observe → understand → admit → serve → measure → correct`. Implementations at
Ground, Middle, and Top may differ but converge on the same root semantics.

## 8. The three tiers and Total

Authoritative source: [`markdown/THREE_TIER.md`](markdown/THREE_TIER.md) and
[`markdown/TOTAL.md`](markdown/TOTAL.md).

**Ground.** The lowest tier: the Linux kernel, hardware, processes, virtual
memory, and operating-system state. It establishes operating-system facts.

**Manager (three senses).** Total's central role, understood as: the *manager*
(policy and coordination), the *manager* (the concrete native service that does
the work), and the *memory manager* (footprint, admission, accounting, pressure,
and safe release/reclamation). Total does not replace Linux's memory manager or
JVM garbage collection; it observes, mediates, and coordinates under policy.

**Middle.** The Total tier: the native privileged moderator that mediates
evidence, resource policy, provenance, and service behavior.

**Tier.** One of the three logically-aware-but-separately-authoritative layers
(Ground, Middle, Top). Tiers exchange evidence rather than assuming an assertion
made at one tier is automatically true at another.

**Top.** The highest tier: SecureJDK 28 / Graal and managed application
semantics.

**Total.** The project's native C/C++ moderator layer (the Middle tier), sitting
between kernel state and userland policy with controlled cooperation from
SecureJDK 28 and Graal. "Total" denotes a system-wide *view*, not unrestricted
authority; it operates within explicit OS privilege, security, provenance, and
authorization boundaries. Its conceptual interface is a *Proffer of Java* while
its implementation is native.

## 9. Domain services

Authoritative source: [`markdown/DOMAIN_SERVICES.md`](markdown/DOMAIN_SERVICES.md).

**Domain adapter (domain-service adapter).** An explicit adapter that lets the
three tiers carry evidence for a regulated or sensitive commercial domain without
making Total the business authority. Common surface:
`identify → describe → authorize → transact → observe → retain → audit`.

**Domain examples.** *Banking* (transaction provenance, payment authorization,
audit evidence); *hospitality / hotels* (property identity, reservation state,
service lifecycle); *regulated adult services* (provider authorization, legally
required eligibility/age verification, recorded consent state, jurisdictional
restrictions); *other regulated commerce* (licensing, eligibility, compliance,
audit). The application remains the business authority.

**Consent boundary.** A firm rule for sensitive domains: **consent must never be
inferred from payment, identity, presence, or prior behavior.** Consent and other
human decisions remain application/domain matters governed by applicable law.
Total proves and mediates the mechanism; it does not decide a person's worth,
humanity, consent, or dignity.

**Software identity.** Identity based on trusted descriptors, signatures, package
provenance, executable identity, dependency metadata, and administrator policy —
not branding alone.

## 10. Proffer framing seed vocabulary

Authoritative source:
[`markdown/PROFFER_FRAMING_SEED.md`](markdown/PROFFER_FRAMING_SEED.md). These
seed terms are stable; algorithms and numeric datums may improve but must not
redefine them.

**Call fall.** A probable-fall analysis in which the next candidate reaction is
represented with probability and ranked for the next step, rather than silently
promoted to certainty.

**Exact fall.** A deterministic model resolution of an intended fall/transition
against a declared model surface, coordinate frame, and tolerance.

**Fall center.** The center at which the current fall is resolved.

**Fielter.** The exact-fall and call-fall model together with the means of
analysis applied to that fall, centered on the process.

**Memory time.** A time coordinate an object in memory acquires over its
lifetime; for tick `t` and birth tick `t0`, seed age is `max(0, t - t0)`. A model
convention, not a claim that physical time causes RAM objects to move.

**Monolith.** The defined reference object that objects approach in the model
(seed values: area 40 m², nominal thickness 3 m).

**Net universe / net center.** A conceptual coordinate universe with an ideal
alignment reference (seed net-center value **2.0**) in which objects, memory,
processor activity, and process state share a common 3D frame.

**Next-to-fall.** The candidate state selected for the next reaction/analysis
step.

**Process diagonal.** The ordered relationship between the RAM endpoint (memory
state) and the processor endpoint (where memory state is acted upon).

**Profit/proffer model.** The complete model in which objects approach the
monolith, falls are resolved, probable next falls are evaluated, and decisions
are expressed as proffers.

**Scape.** The resulting three-dimensional process field formed by the model; the
model's 3D space.

**Subasmission.** A carrier/part transition in which a thing is represented next
to its carrier and parts, and the next part is selected for subsequent analysis;
the continuation mechanism between analysis centers.

**Unit spectrum.** The finite resolution field used to partition and inspect the
three-dimensional model.

## 11. JSpec Pixel Format (JPIX)

Authoritative source: [`README.md`](README.md) (`JSpec Pixel Format` section).

**Boundary.** First-class information: the outermost participating pixels define
the object's outward shape, whether uniform, rounded, irregular, or jagged.

**Extent.** The minimum envelope required to store or render a Pixel Map. The
extent is a storage/rendering convenience, **not** the object itself.

**JPIX (`.jpix`).** An experimental pixel-native image representation built around
a Pixel Map; complementary to — not a replacement for — PNG and JPEG.

**Mapped pixel.** A pixel that belongs explicitly to the Pixel Map (opaque,
partially transparent, or fully transparent). A *mapped transparent pixel* is
distinct from *unmapped space*.

**Pixel Map.** The canonical JPIX object: a geometric map of pixels with
coordinates, values, alpha, boundary, topology, orientation, and transformation
semantics. *The Pixel Map is the object; a rectangle is only a storage or
rendering envelope when one is required.* There is no intrinsic requirement that
an image be square or rectangular.

**Trim.** To remove storage space that is not part of the Pixel Map while
preserving every mapped pixel and the defined boundary — not an ordinary
rectangular crop.

## 12. UTF-4088, ASYSMA, and runtime

Authoritative sources: [`README.md`](README.md),
[`markdown/ASYSMA-NORMS.md`](markdown/ASYSMA-NORMS.md), and
[`markdown/SECUREJDK28.md`](markdown/SECUREJDK28.md).

**ASYSMA.** The project's native package/handoff contract and control artifact
(`.asysma`), providing a package and native-to-Java handoff rather than a
replacement operating system. Governed by the ASYSMA norms (N1–N12).

**Digest vs. signature.** A precise-usage rule (ASYSMA norm N5): **SHA-256 is an
integrity digest, not an authentication signature.** The terms *digest*,
*signature*, *provenance*, and *authorization* are used distinctly.

**Distributed character candidates.** Candidate symbols produced by the UTF-4088
sampler — explicitly not claims that new human-language meanings have been
established. Interpretation continues through the curated symbol layer, corpus,
graph semantics, and neural relayer.

**Graal.** The execution/compiler layer that participates in the managed path and
consumes the same evidence model, without becoming the final authority over
kernel resources.

**SecureJDK 28.** The project's OpenJDK/Graal variant, intended to make the
security and provenance model native to the runtime (explicit provenance, policy,
resource, and integrity hooks) rather than a bolt-on library.

**UTF-4088.** An experimental character and graph system built around a
16,606-symbol front end, an 8×12 glyph representation, historical language seeds,
directed concept graphs, and a procedural 4D remainder space.

**XMC.** The ASYSMA-associated format whose version must come from a single
authoritative definition (ASYSMA norm N2), producing deterministic `.xclass`
output.

## 13. Accounting, observability, and native utilities

Authoritative source: [`README.md`](README.md).

**limit.** A native utility that inventories executable formats and available
application-identity metadata — answering *what executable identity and metadata
can be established*. Complements `size`.

**norm cost / opportunity cost model.** A bounded accounting/observability model
of the *observable cost of a selected transition*, producing `scatter`
(normalized deviation from a declared baseline), `norm_cost`, optional
`fine_cost`, and `opportunity_cost`. It is an accounting model, **not** an
inference about a person's character, worth, or status, and must not turn role,
status, ethnicity, nationality, language, or history into an automatic penalty.

**scatter.** The normalized deviation metric from the norm-cost model, which may
be emitted as a bounded, access-controlled, provenance-tagged telemetry datum.
Observability does not itself grant permission to inspect or act on memory.

**size.** A portable, read-only native utility that recursively measures the
*logical byte size of a parent folder and all regular files beneath it* —
answering *how much file data exists*. It reports logical file length, not
filesystem allocation.

## 14. Continuance

When new documents, vendored trees, or project subsystems are added, extend this
glossary with any term that carries a repository-specific meaning, keeping each
group alphabetical and pointing to the authoritative source document. Coined
project terms are stable: this glossary records them but does not redefine them.
This document is authored for this repository under the attribution defined in
[`HEADINGS.md`](HEADINGS.md).
