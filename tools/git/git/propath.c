/* Native propath scope/cache lifecycle implementation. */
#include "git-compat-util.h"
#include "propath.h"

int git_propath_config_validate(const struct git_propath_config *cfg)
{
	return git_propath_config_valid(cfg) ? 0 : -1;
}

int git_propath_entry_validate(const struct git_propath_entry *entry)
{
	return git_propath_entry_valid(entry) ? 0 : -1;
}

/*
 * Record use of a scoped path at `now_epoch`. If the path still needs a fetch
 * (declared or previously evicted), using it materializes it. The last-used
 * clock only ever moves forward, so a stale timestamp can never make a freshly
 * used path look idle.
 */
int git_propath_touch(struct git_propath_entry *entry, uintmax_t now_epoch)
{
	if (git_propath_entry_validate(entry))
		return -1;
	if (git_propath_needs_fetch(entry))
		entry->state = GIT_PROPATH_MATERIALIZED;
	if (now_epoch > entry->last_used_epoch)
		entry->last_used_epoch = now_epoch;
	return 0;
}

/*
 * Evict a single entry when it is an idle materialized candidate. Eviction
 * clears only the local cached copy (state + local byte estimate); the scope
 * entry is retained so the path is transparently re-fetchable on next use.
 * Returns 1 when it evicted, 0 when it left the entry untouched.
 */
int git_propath_evict_if_idle(const struct git_propath_config *cfg,
			      struct git_propath_entry *entry,
			      uintmax_t now_epoch)
{
	if (!git_propath_should_evict(cfg, entry, now_epoch))
		return 0;
	entry->state = GIT_PROPATH_EVICTED;
	entry->materialized_bytes = 0;
	return 1;
}

uintmax_t git_propath_evictable_count(const struct git_propath_config *cfg,
				      const struct git_propath_entry *entries,
				      size_t count, uintmax_t now_epoch)
{
	uintmax_t evictable = 0;
	size_t i;

	if (!cfg || !entries)
		return 0;

	for (i = 0; i < count; i++) {
		if (git_propath_should_evict(cfg, &entries[i], now_epoch)) {
			if (evictable == UINTMAX_MAX)
				return evictable; /* reject overflow, do not wrap */
			evictable++;
		}
	}
	return evictable;
}
