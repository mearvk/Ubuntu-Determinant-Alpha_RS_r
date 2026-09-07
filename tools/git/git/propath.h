/*
 * Ubuntu Determinant native "propath" module.
 *
 *     git propath URL [PATH ...]
 *
 * `propath` is a path-scoped, lazily-expanding partial-clone policy. Instead of
 * materializing an entire (possibly very large) repository, a developer clones
 * only a *tuple of paths* — the directories they are actually working on — and
 * then iteratively or recursively fetches the rest **on demand** as they reach
 * for it. Working directory-by-directory becomes cheap: the initial clone is a
 * small partial scope, and the tree grows only where it is used.
 *
 * To keep the local footprint bounded, a materialized path that has not been
 * used for roughly two days is a candidate for eviction. Eviction removes only
 * the *local cached copy*; the path is re-fetchable from the remote whenever it
 * is next needed, because the scope entry itself is retained. Nothing about the
 * remote history or object identity changes.
 *
 * Like the other native modules, propath supplements Git and never replaces
 * object identity or history:
 *   - the authoritative object graph is always the remote's;
 *   - a scope/cache record is advisory local bookkeeping;
 *   - eviction never deletes committed local work, only clean re-fetchable
 *     cached copies, and never rewrites history or weakens transport policy.
 *
 * Defaults are read from a per-repository config file (see PROPATH.md); a stale
 * or altered config can never authorize deleting un-pushed work.
 */
#ifndef GIT_PROPATH_H
#define GIT_PROPATH_H

/*
 * In C we use Git's compat layer. In C++ (the self-contained policy companion
 * and any C++ consumer) git-compat-util.h is not C++-clean, so we pull only the
 * fixed-width integer/size types and the standard string helpers directly.
 */
#ifdef __cplusplus
#include <cstdint>
#include <cstddef>
#include <cstring>
#else
#include "git-compat-util.h"
#include <stdint.h>
#include <string.h>
#endif

/*
 * The idle time-to-live before a materialized path is a candidate for
 * eviction. "About two days" is expressed exactly as a policy constant in
 * seconds so age arithmetic is deterministic and unit-safe.
 */
#define GIT_PROPATH_DAY_SECONDS       ((uintmax_t)86400)
#define GIT_PROPATH_DEFAULT_TTL_DAYS  ((uintmax_t)2)
#define GIT_PROPATH_DEFAULT_TTL_SECONDS \
	(GIT_PROPATH_DEFAULT_TTL_DAYS * GIT_PROPATH_DAY_SECONDS) /* 172800 */

/*
 * How a scope entry expands beyond its own directory when its contents are
 * reached for.
 *
 *   SHALLOW    - materialize only the entries directly at the scoped path
 *                (one directory level); subdirectories are fetched only when
 *                they are themselves reached (iterative, level-by-level).
 *   RECURSIVE  - materialize the scoped path and its whole subtree on first
 *                use (recursive descent from the scope root).
 */
enum git_propath_expand {
	GIT_PROPATH_EXPAND_SHALLOW = 0, /* iterative, one level at a time   */
	GIT_PROPATH_EXPAND_RECURSIVE = 1 /* recursive whole-subtree on use  */
};

/*
 * Lifecycle state of a single scoped path's local cache.
 *
 *   DECLARED     - part of the scope tuple, not yet materialized locally.
 *   MATERIALIZED - present locally and usable.
 *   EVICTED      - local copy removed after idle TTL; still in scope, so it is
 *                  transparently re-fetchable on next use.
 */
enum git_propath_state {
	GIT_PROPATH_DECLARED = 0,
	GIT_PROPATH_MATERIALIZED,
	GIT_PROPATH_EVICTED
};

/*
 * A single scoped path within a propath working set.
 *
 * `last_used_epoch` is the wall-clock time (seconds since the Unix epoch) the
 * path was last accessed; `now_epoch` is supplied by the caller so the module
 * itself performs no I/O and stays deterministic and testable. Eviction is
 * decided purely from these two values and the TTL.
 */
struct git_propath_entry {
	const char *path;             /* repo-relative scoped directory        */
	enum git_propath_expand expand;
	enum git_propath_state state;
	uintmax_t last_used_epoch;    /* seconds since epoch of last use       */
	uintmax_t materialized_bytes; /* local on-disk estimate for the path   */
	const char *url;              /* source URL the scope was cloned from  */
	const char *author;
	const char *committer;
	const char *date;
	const char *timestamp;
	const char *parent_commit;
	const char *prior_operation;
	const char *relevance;        /* TIER-1/TIER-2/PRIORI marker           */
};

/*
 * The propath configuration, seeded from the per-repository config file.
 *
 * `ttl_seconds` defaults to GIT_PROPATH_DEFAULT_TTL_SECONDS (~2 days). A
 * ttl_seconds of 0 means "never auto-evict by policy" — eviction is disabled,
 * not immediate; nothing is ever deleted merely because a TTL of zero was set.
 */
struct git_propath_config {
	const char *url;                 /* source repository URL             */
	uintmax_t ttl_seconds;           /* idle TTL before eviction candidacy */
	enum git_propath_expand default_expand;
	int evict_enabled;               /* 0 disables eviction entirely       */
};

static inline int git_propath_expand_valid(enum git_propath_expand e)
{
	return e == GIT_PROPATH_EXPAND_SHALLOW ||
		e == GIT_PROPATH_EXPAND_RECURSIVE;
}

static inline int git_propath_state_valid(enum git_propath_state s)
{
	return s >= GIT_PROPATH_DECLARED && s <= GIT_PROPATH_EVICTED;
}

/* Human-readable labels; never return NULL. */
static inline const char *git_propath_expand_label(enum git_propath_expand e)
{
	return e == GIT_PROPATH_EXPAND_RECURSIVE ? "recursive" : "shallow";
}

static inline const char *git_propath_state_label(enum git_propath_state s)
{
	switch (s) {
	case GIT_PROPATH_MATERIALIZED: return "materialized";
	case GIT_PROPATH_EVICTED:      return "evicted";
	case GIT_PROPATH_DECLARED:
	default:                       return "declared";
	}
}

/*
 * Initialize a config with the ~2-day default TTL, shallow (iterative)
 * expansion, and eviction enabled. Returns 0 on success, -1 on bad input.
 */
static inline int git_propath_config_init(struct git_propath_config *cfg,
					const char *url)
{
	if (!cfg || !url || url[0] == '\0')
		return -1;
	cfg->url = url;
	cfg->ttl_seconds = GIT_PROPATH_DEFAULT_TTL_SECONDS;
	cfg->default_expand = GIT_PROPATH_EXPAND_SHALLOW;
	cfg->evict_enabled = 1;
	return 0;
}

static inline int git_propath_config_valid(const struct git_propath_config *cfg)
{
	return cfg && cfg->url && cfg->url[0] != '\0' &&
		git_propath_expand_valid(cfg->default_expand);
}

/*
 * Idle age of an entry in seconds, given the current epoch. Returns 0 when the
 * entry was used at or after `now_epoch` (clock skew is treated as "just
 * used", never as negative age).
 */
static inline uintmax_t git_propath_idle_seconds(
				const struct git_propath_entry *entry,
				uintmax_t now_epoch)
{
	if (!entry || now_epoch <= entry->last_used_epoch)
		return 0;
	return now_epoch - entry->last_used_epoch; /* overflow-safe: now > last */
}

/*
 * Whether an entry is a candidate for eviction under a config at time
 * `now_epoch`. Only a *materialized* path can be evicted; a declared or
 * already-evicted path is never re-deleted. Eviction requires it to be enabled
 * and a non-zero TTL, and the idle age to have reached the TTL.
 */
static inline int git_propath_should_evict(
				const struct git_propath_config *cfg,
				const struct git_propath_entry *entry,
				uintmax_t now_epoch)
{
	if (!cfg || !entry)
		return 0;
	if (!cfg->evict_enabled || cfg->ttl_seconds == 0)
		return 0;
	if (entry->state != GIT_PROPATH_MATERIALIZED)
		return 0;
	return git_propath_idle_seconds(entry, now_epoch) >= cfg->ttl_seconds;
}

/*
 * Whether an entry must be (re)fetched before use: it is either declared but
 * not yet materialized, or it was evicted and is being reached for again.
 */
static inline int git_propath_needs_fetch(const struct git_propath_entry *entry)
{
	return entry && (entry->state == GIT_PROPATH_DECLARED ||
			 entry->state == GIT_PROPATH_EVICTED);
}

static inline int git_propath_entry_valid(const struct git_propath_entry *entry)
{
	return entry && entry->path && entry->path[0] != '\0' &&
		git_propath_expand_valid(entry->expand) &&
		git_propath_state_valid(entry->state);
}

/*
 * Lifecycle/reporting functions implemented in propath.c / propath.cpp.
 * Declared here so C and C++ callers share one prototype set; the C++ companion
 * defines them with extern "C" linkage to match.
 */
#ifdef __cplusplus
extern "C" {
#endif

int git_propath_config_validate(const struct git_propath_config *cfg);
int git_propath_entry_validate(const struct git_propath_entry *entry);

/* Mark an entry used at `now_epoch`, materializing it if it needed a fetch. */
int git_propath_touch(struct git_propath_entry *entry, uintmax_t now_epoch);

/* Evict an entry if it is an eviction candidate; returns 1 if evicted, else 0. */
int git_propath_evict_if_idle(const struct git_propath_config *cfg,
			      struct git_propath_entry *entry,
			      uintmax_t now_epoch);

/*
 * Count how many entries in an array are eviction candidates at `now_epoch`,
 * rejecting integer overflow rather than wrapping. Returns the count, or 0 for
 * invalid input.
 */
uintmax_t git_propath_evictable_count(const struct git_propath_config *cfg,
				      const struct git_propath_entry *entries,
				      size_t count, uintmax_t now_epoch);

#ifdef __cplusplus
}
#endif

#endif /* GIT_PROPATH_H */
