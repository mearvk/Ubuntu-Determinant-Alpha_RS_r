/* Native merge metadoc implementation. */
#include "git-compat-util.h"
#include "merge-metadoc.h"

int git_merge_metadoc_validate(const struct git_merge_metadoc *doc)
{
	if (!doc || !doc->current_base || !doc->merge_source)
		return -1;
	if (!doc->merge_source_count || !doc->merge_count)
		return -1;
	if (!doc->future_base_message || !doc->parent_commit)
		return -1;
	return 0;
}

int git_merge_metadoc_rebase_qualified(
	const struct git_merge_metadoc *doc)
{
	if (git_merge_metadoc_validate(doc))
		return 0;
	return git_merge_qualifies_rebase(doc->merge_count);
}
