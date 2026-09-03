/*
 * Native commit-part planning implementation.
 *
 * The integer commit method is expressed as ordered 50 MiB logical units.
 * This translation unit deliberately contains no shell/process wrapper and
 * does not replace Git's ordinary commit implementation by itself.
 */
#include "git-compat-util.h"
#include "commit-budget.h"

int git_commit_part_plan_validate(const struct git_commit_part_plan *plan)
{
	if (!plan || !plan->requested_units)
		return -1;
	if (plan->part_bytes != GIT_COMMIT_PART_BYTES)
		return -1;
	if (plan->push_parts != GIT_COMMIT_PUSH_PARTS)
		return -1;
	if (plan->logical_bytes !=
	    plan->requested_units * GIT_COMMIT_PART_BYTES)
		return -1;
	return 0;
}

uintmax_t git_commit_part_units_for_push(uintmax_t units,
					 unsigned int push_index)
{
	uintmax_t first;

	if (!units || !push_index)
		return 0;

	first = ((uintmax_t)push_index - 1) * GIT_COMMIT_PUSH_PARTS;
	if (first >= units)
		return 0;

	return units - first > GIT_COMMIT_PUSH_PARTS
		? GIT_COMMIT_PUSH_PARTS
		: units - first;
}
