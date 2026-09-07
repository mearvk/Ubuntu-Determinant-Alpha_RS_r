# Native `propath` method

`propath` is a path-scoped, lazily-expanding partial-clone operation:

```
git propath URL [PATH ...]
```

Instead of materializing an entire (possibly very large) repository, a developer
clones only a **tuple of paths** — the directories they are actually working on
— and then fetches the rest **on demand**, iteratively or recursively, as they
reach for it. Working directory-by-directory becomes cheap: the initial clone is
a small scope, and the local tree grows only where it is used. Unused local
copies are evicted after roughly two days so the footprint stays bounded.

It supplements Git and never replaces object identity or history. The remote
object graph is always authoritative; a scope/cache record is advisory local
bookkeeping.

## The scope tuple

The arguments after `URL` are the initial scope — a tuple of repo-relative
directories to clone up front:

```
git propath https://example.com/group/repo.git tools/git countries/japan markdown
```

Everything outside the scope is left unmaterialized. Each scoped path is one of
three states:

| State | Meaning |
|---|---|
| `declared` | in the scope tuple, not yet materialized locally |
| `materialized` | present locally and usable |
| `evicted` | local copy removed after idle TTL; still in scope, re-fetchable |

A `declared` or `evicted` path "needs fetch": reaching for it transparently
materializes it again.

## Iterative vs. recursive expansion

Each scoped path expands in one of two modes when its contents are reached for:

| Mode | Behavior |
|---|---|
| `shallow` (default) | materialize one directory level; subdirectories are fetched only when they are themselves reached — **iterative**, level by level |
| `recursive` | materialize the scoped path and its whole subtree on first use — **recursive** descent from the scope root |

`shallow` keeps the local tree as small as possible and is the natural mode for
"seek the rest upon need"; `recursive` is for when a developer wants a complete
subtree in one step. The mode can be set globally in the config (`EXPAND:`) and
overridden per path.

## Idle eviction (~2 days)

To bound the local footprint, a **materialized** path that has not been used for
its idle time-to-live becomes an eviction candidate. The default TTL is **2
days** (`GIT_PROPATH_DEFAULT_TTL_SECONDS` = 172800 seconds).

Eviction is deliberately conservative:

- only a `materialized` path is ever evicted; a `declared` or already-`evicted`
  path is never re-deleted;
- eviction removes only the **clean, re-fetchable local copy** — it clears the
  cache state and the local byte estimate, retaining the scope entry so the path
  is transparently re-fetched on next use;
- it **never deletes committed or un-pushed local work**, and never rewrites
  history or changes remote object identity;
- idle age is computed as `now - last_used`, with clock skew treated as "just
  used" (age never goes negative);
- eviction can be disabled entirely (`EVICT: false`), and a TTL of `0` means
  "never auto-evict", **not** "evict immediately".

Time is supplied by the caller (the current epoch), so the policy module itself
performs no I/O and is deterministic and testable.

## Configuration file

Defaults come from a per-repository config file (recommended location `.propath`
at the repository root). It is UTF-8, line-oriented `KEY: value`, mirroring the
native `struct git_propath_config`:

| Key | Meaning |
|---|---|
| `URL:` | source repository URL (required, non-empty) |
| `TTL-DAYS:` / `TTL-SECONDS:` | idle TTL before eviction candidacy (default 2 days; seconds wins if both set; `0` = never) |
| `EVICT:` | `true` (default) enables idle eviction; `false` disables it |
| `EXPAND:` | default expansion mode, `shallow` (default) or `recursive` |
| `PATH:` | one scoped directory per line, with an optional trailing `shallow`/`recursive` override |

A fully commented template is provided in
[`git/propath.config.example`](git/propath.config.example). A stale or altered
config can never authorize deleting un-pushed local work.

## Native implementation contract

The policy lives in native source — `git/propath.h` with C and C++ companions
`git/propath.c` and `git/propath.cpp` — rather than a shell wrapper. The current
change establishes the constants (the ~2-day TTL), the scope-entry and config
structures, expansion/state enums and labels, overflow-safe idle-age arithmetic,
the eviction predicate (`git_propath_should_evict`), the fetch predicate
(`git_propath_needs_fetch`), and the lifecycle companions
(`git_propath_touch`, `git_propath_evict_if_idle`, `git_propath_evictable_count`).

The eventual implementation should:

1. leave ordinary `git clone` / `git fetch` behavior unchanged unless the
   `propath` form is deliberately selected;
2. perform the initial clone as a partial, path-scoped checkout of the scope
   tuple (building on Git's partial-clone and sparse-checkout machinery);
3. lazily fetch a scoped path's contents on first use, honoring the shallow
   (iterative) or recursive expansion mode;
4. record `last_used` on access and evict idle materialized copies per the TTL,
   never deleting committed or un-pushed work;
5. re-fetch an evicted path transparently when it is reached for again;
6. treat the scope/cache record as advisory local bookkeeping that never
   rewrites history or weakens transport policy.

The scope/expansion/eviction semantics are therefore **presumed now in the
source architecture**, while the final clone/fetch/checkout integration remains a
subsequent, deliberate step.
