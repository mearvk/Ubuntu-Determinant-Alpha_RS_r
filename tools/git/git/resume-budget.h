/*
 * Ubuntu Determinant native resumable commit/push policy.
 *
 * Slow or lossy connections are a normal operating condition. A push effort
 * bounded by the native 200 MiB ceiling can still be interrupted mid-transfer.
 * This policy layers a deterministic *checkpoint/resume* model over the
 * existing ordered 50 MiB commit units so that an interrupted effort is
 * retried from the last acknowledged unit rather than restarted from zero.
 *
 * It supplements, and never weakens, the authoritative policies:
 *   - commit-budget.h : ordered 50 MiB commit units;
 *   - push-budget.h   : hard 200 MiB (4 x 50 MiB) object ceiling per push.
 *
 * The resume record is advisory transport bookkeeping. The push guard must
 * still recompute the actual reachable object graph and enforce the 200 MiB
 * ceiling for every attempt; a stale or altered checkpoint can never authorize
 * an oversized transfer or bypass ordinary Git ref/negotiation semantics.
 */
#ifndef GIT_RESUME_BUDGET_H
#define GIT_RESUME_BUDGET_H

#include "git-compat-util.h"
#include "commit-budget.h"

#include <stdint.h>
#include <inttypes.h>

/*
 * A resumable effort is the ordered set of 50 MiB commit units produced by the
 * commit-part planner, partitioned into push transactions of at most
 * GIT_COMMIT_PUSH_PARTS units (200 MiB). A checkpoint records how far the
 * transfer has been *acknowledged by the remote*, never merely attempted.
 */

enum git_resume_state {
	GIT_RESUME_PENDING = 0, /* nothing acknowledged yet                   */
	GIT_RESUME_PARTIAL,     /* some units acknowledged, more remain       */
	GIT_RESUME_COMPLETE,    /* all units acknowledged by the remote       */
	GIT_RESUME_HALT         /* unsafe/ambiguous; do not silently continue */
};

struct git_resume_checkpoint {
	uintmax_t total_units;        /* total ordered 50 MiB units in effort  */
	uintmax_t acked_units;        /* units confirmed present on the remote */
	uintmax_t attempt;            /* 1-based attempt counter               */
	uintmax_t max_attempts;       /* retry ceiling for a lossy connection  */
	const char *effort_id;        /* stable id correlating the attempts    */
	const char *base_commit;      /* remote-side base the effort extends   */
	const char *last_acked_tip;   /* last unit tip the remote acknowledged */
	const char *author;
	const char *committer;
	const char *date;
	const char *timestamp;
	const char *prior_operation;
	const char *parent_commit;
	enum git_resume_state state;
};

/* Remaining ordered units still to be transferred. */
static inline uintmax_t git_resume_units_remaining(
					const struct git_resume_checkpoint *cp)
{
	if (!cp || cp->acked_units >= cp->total_units)
		return 0;
	return cp->total_units - cp->acked_units;
}

/*
 * Number of units the *next* push transaction should carry: the remaining
 * units, capped at the 200 MiB transaction size (GIT_COMMIT_PUSH_PARTS).
 * This is a planning value; the push guard still measures the real object
 * graph before transfer.
 */
static inline uintmax_t git_resume_next_transaction_units(
					const struct git_resume_checkpoint *cp)
{
	uintmax_t remaining = git_resume_units_remaining(cp);

	return remaining > GIT_COMMIT_PUSH_PARTS
		? (uintmax_t)GIT_COMMIT_PUSH_PARTS
		: remaining;
}

/* Zero-based index of the first unit the next transaction must (re)start at. */
static inline uintmax_t git_resume_next_unit_index(
					const struct git_resume_checkpoint *cp)
{
	return cp ? cp->acked_units : 0;
}

static inline int git_resume_is_complete(const struct git_resume_checkpoint *cp)
{
	return cp && cp->total_units && cp->acked_units >= cp->total_units;
}

/* A checkpoint may retry while attempts remain and it has not halted. */
static inline int git_resume_may_retry(const struct git_resume_checkpoint *cp)
{
	return cp && cp->state != GIT_RESUME_HALT &&
		!git_resume_is_complete(cp) &&
		(cp->max_attempts == 0 || cp->attempt < cp->max_attempts);
}

/*
 * Advance a checkpoint after a transaction the remote acknowledged. Rejects
 * regression (acked count must never decrease) and overflow. A partial ack is
 * legitimate on a lossy link: fewer units than requested may have landed.
 * Returns 0 on success, -1 on invalid/regressing/overflowing input.
 */
static inline int git_resume_ack(struct git_resume_checkpoint *cp,
				 uintmax_t newly_acked_units)
{
	uintmax_t updated;

	if (!cp || cp->total_units == 0)
		return -1;
	if (cp->acked_units > cp->total_units)
		return -1;
	if (newly_acked_units > cp->total_units - cp->acked_units)
		return -1; /* cannot ack more than remain */

	updated = cp->acked_units + newly_acked_units; /* overflow-safe: bounded above */
	cp->acked_units = updated;
	cp->state = (updated >= cp->total_units) ? GIT_RESUME_COMPLETE
		: (updated > 0) ? GIT_RESUME_PARTIAL
		: GIT_RESUME_PENDING;
	return 0;
}

static inline int git_resume_checkpoint_valid(
					const struct git_resume_checkpoint *cp)
{
	if (!cp || !cp->effort_id || cp->total_units == 0)
		return 0;
	if (cp->acked_units > cp->total_units)
		return 0;
	if (cp->state < GIT_RESUME_PENDING || cp->state > GIT_RESUME_HALT)
		return 0;
	return 1;
}

/* Implemented in resume-budget.c / resume-budget.cpp; declared per-TU. */

#endif /* GIT_RESUME_BUDGET_H */
