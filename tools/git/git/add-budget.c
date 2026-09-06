/*
 * Native add-budget policy implementation.
 *
 * This file deliberately contains policy helpers only.  The ordinary
 * builtin/add.c command path remains unchanged until the policy is wired
 * into the index mutation path.
 */

#include "git-compat-util.h"
#include "add-budget.h"

/*
 * These are the *1-based block ordinal* planning helpers. They intentionally
 * have distinct names from the header's inline primitives
 * (git_add_block_for_bytes / git_add_block_would_cross_boundary), which return
 * a 0-based block index and a simple boundary test. Sharing the header names
 * here would redefine those inline functions; the "_planned" suffix keeps both
 * the inline primitives and these ordinal helpers available.
 */
uintmax_t git_add_block_planned_ordinal(uintmax_t bytes)
{
	if (!bytes)
		return 1;
	return ((bytes - 1) / GIT_ADD_BLOCK_BYTES) + 1;
}

int git_add_block_planned_would_cross(uintmax_t current_bytes,
				      uintmax_t file_bytes)
{
	uintmax_t current_block;
	uintmax_t next_bytes;

	if (!file_bytes)
		return 0;
	if (current_bytes > UINTMAX_MAX - file_bytes)
		return 1;

	next_bytes = current_bytes + file_bytes;
	current_block = git_add_block_planned_ordinal(current_bytes);
	return git_add_block_planned_ordinal(next_bytes) != current_block &&
		current_bytes % GIT_ADD_BLOCK_BYTES != 0;
}
