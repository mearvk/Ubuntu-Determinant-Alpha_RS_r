/* Native autocheck policy contract. */
#ifndef GIT_AUTOCHECK_H
#define GIT_AUTOCHECK_H

#include "git-compat-util.h"
#include <stdint.h>

enum git_autocheck_resolution {
	GIT_AUTOCHECK_NO_CHANGE,
	GIT_AUTOCHECK_COMMIT,
	GIT_AUTOCHECK_MERGE,
	GIT_AUTOCHECK_REBASE,
	GIT_AUTOCHECK_HALT
};

struct git_autocheck_plan {
	uintmax_t age_days;
	uintmax_t conflict_count;
	int local_changes;
	int remote_changes;
	enum git_autocheck_resolution resolution;
	int should_commit;
	int should_push;
};

#define GIT_AUTOCHECK_MERGE_MAX_AGE_DAYS 92U
#define GIT_AUTOCHECK_PUSH_BUDGET_BYTES ((uintmax_t)200 * 1024 * 1024)

static inline int git_autocheck_merge_preferred(uintmax_t age_days)
{
	return age_days < GIT_AUTOCHECK_MERGE_MAX_AGE_DAYS;
}

static inline int git_autocheck_plan_valid(const struct git_autocheck_plan *plan)
{
	return plan && plan->resolution >= GIT_AUTOCHECK_NO_CHANGE &&
		plan->resolution <= GIT_AUTOCHECK_HALT;
}

#endif /* GIT_AUTOCHECK_H */
