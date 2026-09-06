/*
 * Native C helpers for scheduled rebase metadoc handling.
 *
 * The metadoc is intentionally plain text and line-oriented.  These helpers
 * validate the structural contract without assigning real-world identity
 * values to the record.
 */

#include "git-compat-util.h"
#include "rebase-metadoc.h"

/*
 * Stricter, non-empty-checking refinement of the header's inline
 * git_rebase_metadoc_is_schedule_relative() predicate. Renamed with a
 * "_strict" suffix so it coexists with the inline contract rather than
 * redefining it.
 */
int git_rebase_metadoc_is_schedule_relative_strict(
	const struct git_rebase_metadoc *doc)
{
	if (!doc)
		return 0;
	return doc->county && doc->county[0] &&
		doc->worker_id && doc->worker_id[0] &&
		doc->set_schedule && doc->set_schedule[0];
}

int git_rebase_metadoc_has_required_metadata(const struct git_rebase_metadoc *doc)
{
	if (!doc || !doc->date || !doc->timestamp)
		return 0;
	if (!git_rebase_metadoc_is_schedule_relative_strict(doc))
		return 0;
	return doc->director_id && doc->director_id[0] &&
		doc->seat && doc->seat[0] &&
		doc->resume && doc->resume[0];
}
