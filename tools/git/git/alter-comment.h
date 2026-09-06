/*
 * Native alter-comment policy for the Ubuntu Determinant Git tree.
 *
 * This is the first implementation step for the integer comment-alteration
 * method:
 *
 *     git alter-comment X "Commit Message"
 *
 * where X is a positive integer naming the last X commits on the current
 * branch whose commit *messages* are to be altered.  "alter-comment" changes
 * only the human-readable message of the addressed commits; it does not change
 * their trees, add or remove files, or reorder history.
 *
 * Because Git commit objects are immutable and the commit message is part of
 * the object being hashed, rewriting a message necessarily produces new commit
 * objects with new object IDs for the addressed commits and every descendant.
 * That rewrite is ordinary Git message-edit history rewriting (the same effect
 * as `git rebase -i` reword or `git commit --amend` for the tip); the native
 * policy layer records provenance and enforces a deterministic, bounded,
 * non-destructive contract around it.  Git's resulting rewritten graph remains
 * authoritative.
 *
 * The planner is deliberately kept separate from builtin/commit.c and the
 * rebase machinery while the policy is being established; the normal Git
 * commit/rebase paths are not changed by this header alone.
 */
#ifndef GIT_ALTER_COMMENT_H
#define GIT_ALTER_COMMENT_H

#ifdef __cplusplus
#include <cstdint>
#include <cstddef>
#else
#include "git-compat-util.h"
#include <stdint.h>
#include <stddef.h>
#endif

/*
 * The number of commits addressed by a single alter-comment request is a
 * positive integer.  Zero is not a valid request (there is nothing to alter),
 * and the count may never exceed the number of commits actually reachable on
 * the selected linear history.
 */
#define GIT_ALTER_COMMENT_MIN_COUNT ((uintmax_t)1)

/*
 * Scope of the message alteration relative to the addressed range.
 *
 *   TIP   - X == 1: only the current tip commit's message is altered
 *           (equivalent in effect to `git commit --amend` of the message).
 *   RANGE - X  > 1: the messages of the last X commits are altered along a
 *           deterministic linear history (equivalent in effect to a reword of
 *           each addressed commit).
 */
enum git_alter_comment_scope {
	GIT_ALTER_COMMENT_SCOPE_TIP = 0,
	GIT_ALTER_COMMENT_SCOPE_RANGE = 1
};

/*
 * A single alter-comment request and its recorded provenance.
 *
 * The message pointer is the replacement commit message applied to the
 * addressed commits.  Provenance fields mirror the other native operation
 * records so an emitted metadata row is individually attributable and the
 * original Git author/committer identity and dates are preserved rather than
 * invented.
 */
struct git_alter_comment_request {
	uintmax_t requested_count;      /* X: number of last commits addressed */
	uintmax_t reachable_count;      /* commits actually reachable on the line */
	const char *message;            /* replacement commit message           */
	const char *base_commit_before; /* tip object id before the alteration   */
	const char *base_commit_after;  /* tip object id after the alteration    */
	const char *author;             /* preserved Git author identity         */
	const char *committer;          /* Git committer identity                */
	const char *date;               /* preserved author/committer date       */
	const char *timestamp;          /* operation timestamp when emitted      */
	const char *parent_commit;      /* parent object of the addressed range  */
	const char *prior_operation;    /* chained prior operation, if any       */
	const char *relevance;          /* TIER-1/TIER-2/PRIORI marker           */
};

/* X == 1 addresses only the tip; X > 1 addresses a linear range. */
static inline enum git_alter_comment_scope git_alter_comment_scope_for(
	uintmax_t count)
{
	return count > GIT_ALTER_COMMENT_MIN_COUNT ?
		GIT_ALTER_COMMENT_SCOPE_RANGE : GIT_ALTER_COMMENT_SCOPE_TIP;
}

/*
 * A requested count is well-formed only when it is at least one and does not
 * exceed the commits actually reachable on the selected linear history.  The
 * request may not address more commits than exist; that is a planning error,
 * never a silent clamp.
 */
static inline int git_alter_comment_count_in_range(uintmax_t requested,
	uintmax_t reachable)
{
	return requested >= GIT_ALTER_COMMENT_MIN_COUNT &&
		requested <= reachable;
}

/*
 * A non-empty replacement message is required.  An empty or absent message is
 * rejected rather than substituting a blank or invented message.
 */
static inline int git_alter_comment_message_valid(const char *message)
{
	return message && message[0] != '\0';
}

/* A request is valid when the count is in range and the message is present. */
static inline int git_alter_comment_request_valid(
	const struct git_alter_comment_request *request)
{
	return request &&
		git_alter_comment_message_valid(request->message) &&
		git_alter_comment_count_in_range(request->requested_count,
			request->reachable_count) &&
		request->base_commit_before && request->parent_commit;
}

/*
 * The number of commit objects that must be rewritten to satisfy the request
 * equals the number of addressed commits (each addressed commit gets a new
 * object because its message changed).  Overflow is rejected rather than
 * wrapped, consistent with the rest of the native method.  Returns 0 for an
 * out-of-range request.
 */
static inline uintmax_t git_alter_comment_rewrite_count(uintmax_t requested,
	uintmax_t reachable)
{
	if (!git_alter_comment_count_in_range(requested, reachable))
		return 0;
	return requested;
}

#endif /* GIT_ALTER_COMMENT_H */
