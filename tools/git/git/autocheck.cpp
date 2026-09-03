/* C++ companion for the native autocheck policy. */
#include "git-compat-util.h"
#include "autocheck.h"

extern "C" int git_autocheck_plan_make(struct git_autocheck_plan *plan,
	uintmax_t age_days, uintmax_t conflict_count,
	int local_changes, int remote_changes)
{
	if (!plan)
		return -1;
	plan->age_days = age_days;
	plan->conflict_count = conflict_count;
	plan->local_changes = local_changes != 0;
	plan->remote_changes = remote_changes != 0;
	plan->should_commit = plan->local_changes;
	plan->should_push = 0;
	if (conflict_count)
		plan->resolution = git_autocheck_merge_preferred(age_days) ?
			GIT_AUTOCHECK_MERGE : GIT_AUTOCHECK_REBASE;
	else if (local_changes)
		plan->resolution = GIT_AUTOCHECK_COMMIT;
	else
		plan->resolution = GIT_AUTOCHECK_NO_CHANGE;
	return git_autocheck_plan_valid(plan) ? 0 : -1;
}
