/* C++ companion for the native alter-comment contract. */
#include "alter-comment.h"

extern "C" int git_alter_comment_request_validate(
	const struct git_alter_comment_request *request)
{
	if (!git_alter_comment_request_valid(request))
		return -1;
	return 0;
}

extern "C" uintmax_t git_alter_comment_plan_rewrites(uintmax_t requested,
	uintmax_t reachable)
{
	return git_alter_comment_rewrite_count(requested, reachable);
}

extern "C" enum git_alter_comment_scope git_alter_comment_plan_scope(
	uintmax_t requested)
{
	return git_alter_comment_scope_for(requested);
}
