/* C++ companion for the native propath scope/cache contract. */
#include "propath.h"

extern "C" int git_propath_config_validate(const struct git_propath_config *cfg)
{
	return git_propath_config_valid(cfg) ? 0 : -1;
}

extern "C" int git_propath_entry_validate(const struct git_propath_entry *entry)
{
	return git_propath_entry_valid(entry) ? 0 : -1;
}

extern "C" int git_propath_touch(struct git_propath_entry *entry,
				 uintmax_t now_epoch)
{
	if (git_propath_entry_validate(entry))
		return -1;
	if (git_propath_needs_fetch(entry))
		entry->state = GIT_PROPATH_MATERIALIZED;
	if (now_epoch > entry->last_used_epoch)
		entry->last_used_epoch = now_epoch;
	return 0;
}

extern "C" int git_propath_evict_if_idle(const struct git_propath_config *cfg,
					 struct git_propath_entry *entry,
					 uintmax_t now_epoch)
{
	if (!git_propath_should_evict(cfg, entry, now_epoch))
		return 0;
	entry->state = GIT_PROPATH_EVICTED;
	entry->materialized_bytes = 0;
	return 1;
}

extern "C" uintmax_t git_propath_evictable_count(
				const struct git_propath_config *cfg,
				const struct git_propath_entry *entries,
				size_t count, uintmax_t now_epoch)
{
	uintmax_t evictable = 0;

	if (!cfg || !entries)
		return 0;

	for (size_t i = 0; i < count; i++) {
		if (git_propath_should_evict(cfg, &entries[i], now_epoch)) {
			if (evictable == UINTMAX_MAX)
				return evictable; /* reject overflow, do not wrap */
			evictable++;
		}
	}
	return evictable;
}
