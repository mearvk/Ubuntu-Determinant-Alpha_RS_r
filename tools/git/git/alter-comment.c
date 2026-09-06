/* Native alter-comment request validation and planning implementation. */
#include "git-compat-util.h"
#include "alter-comment.h"

/*
 * Validate a fully-populated alter-comment request.  Returns 0 when the
 * request is well-formed and -1 otherwise.  The count must be at least one and
 * within the reachable linear history, and a non-empty replacement message
 * must be present.  Provenance anchors (tip-before and parent) must be set so
 * the resulting record is attributable.
 */
int git_alter_comment_request_validate(
	const struct git_alter_comment_request *request)
{
	if (!git_alter_comment_request_valid(request))
		return -1;
	return 0;
}

/*
 * Report how many commit objects the request will rewrite.  Because altering a
 * message changes the commit object, the count of rewritten objects equals the
 * count of addressed commits.  Out-of-range requests report zero.
 */
uintmax_t git_alter_comment_plan_rewrites(uintmax_t requested,
	uintmax_t reachable)
{
	return git_alter_comment_rewrite_count(requested, reachable);
}

/*
 * Resolve the alteration scope for a requested count: X == 1 addresses only
 * the tip, X > 1 addresses a deterministic linear range.
 */
enum git_alter_comment_scope git_alter_comment_plan_scope(uintmax_t requested)
{
	return git_alter_comment_scope_for(requested);
}
