/*
 * Native resumable commit/push implementation.
 *
 * Provides the checkpoint lifecycle and the per-attempt transaction plan for
 * transferring an ordered set of 50 MiB commit units over a slow or lossy
 * connection. It performs no transport itself; the push guard in
 * push-budget.h remains authoritative for the 200 MiB object ceiling, and
 * ordinary Git negotiation still governs what the remote actually accepts.
 */
#include "git-compat-util.h"
#include "resume-budget.h"

int git_resume_checkpoint_init(struct git_resume_checkpoint *cp,
			       const char *effort_id,
			       uintmax_t total_units,
			       uintmax_t max_attempts)
{
	if (!cp || !effort_id || total_units == 0)
		return -1;

	memset(cp, 0, sizeof(*cp));
	cp->effort_id = effort_id;
	cp->total_units = total_units;
	cp->acked_units = 0;
	cp->attempt = 0;
	cp->max_attempts = max_attempts;
	cp->state = GIT_RESUME_PENDING;
	return git_resume_checkpoint_valid(cp) ? 0 : -1;
}

/*
 * Prepare the next attempt. Returns the number of units the next push
 * transaction should carry (0 when nothing remains), or -1 when the effort
 * cannot proceed (halted, complete, or retry budget exhausted). On success the
 * attempt counter is advanced so a lossy retry is explicitly accounted for.
 */
intmax_t git_resume_begin_attempt(struct git_resume_checkpoint *cp)
{
	uintmax_t units;

	if (!git_resume_checkpoint_valid(cp))
		return -1;
	if (git_resume_is_complete(cp))
		return 0;
	if (!git_resume_may_retry(cp))
		return -1;

	if (cp->attempt == UINTMAX_MAX)
		return -1; /* reject counter overflow rather than wrap */
	cp->attempt++;

	units = git_resume_next_transaction_units(cp);
	return (intmax_t)units;
}

/*
 * Record the outcome of an attempt. newly_acked_units is what the remote
 * confirmed (may be fewer than requested on a lossy link, including zero).
 * connection_lost marks a transport failure so the caller can decide to
 * retry the still-unacknowledged remainder. Returns 0 on success, -1 on
 * invalid input.
 */
int git_resume_record_outcome(struct git_resume_checkpoint *cp,
			      uintmax_t newly_acked_units,
			      int connection_lost)
{
	if (git_resume_ack(cp, newly_acked_units))
		return -1;

	if (git_resume_is_complete(cp)) {
		cp->state = GIT_RESUME_COMPLETE;
		return 0;
	}

	if (connection_lost && !git_resume_may_retry(cp)) {
		/* Out of retries with work remaining: halt, do not loop. */
		cp->state = GIT_RESUME_HALT;
		return 0;
	}

	cp->state = (cp->acked_units > 0) ? GIT_RESUME_PARTIAL
					  : GIT_RESUME_PENDING;
	return 0;
}
