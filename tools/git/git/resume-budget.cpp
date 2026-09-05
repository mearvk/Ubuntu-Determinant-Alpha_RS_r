/*
 * C++ companion for the native resumable commit/push policy.
 *
 * Uses the same C ABI and constants as resume-budget.c so C++ translation
 * units share one checkpoint model. Transport is never performed here; the
 * 200 MiB push guard remains authoritative for every attempt.
 */
#include "git-compat-util.h"
#include "resume-budget.h"

extern "C" int git_resume_checkpoint_init(struct git_resume_checkpoint *cp,
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

extern "C" intmax_t git_resume_begin_attempt(struct git_resume_checkpoint *cp)
{
	if (!git_resume_checkpoint_valid(cp))
		return -1;
	if (git_resume_is_complete(cp))
		return 0;
	if (!git_resume_may_retry(cp))
		return -1;
	if (cp->attempt == UINTMAX_MAX)
		return -1;
	cp->attempt++;
	return (intmax_t)git_resume_next_transaction_units(cp);
}

extern "C" int git_resume_record_outcome(struct git_resume_checkpoint *cp,
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
		cp->state = GIT_RESUME_HALT;
		return 0;
	}
	cp->state = (cp->acked_units > 0) ? GIT_RESUME_PARTIAL
					  : GIT_RESUME_PENDING;
	return 0;
}
