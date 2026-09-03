/*
 * Native rebase scheduling / Metadoc contract.
 *
 * This establishes project-level metadata without changing Git's normal
 * rebase behavior yet. Identifiers are references supplied by an authorized
 * caller; the planner must never invent real-world identity values.
 */
#ifndef GIT_REBASE_METADOC_H
#define GIT_REBASE_METADOC_H

#include "git-compat-util.h"

#define GIT_REBASE_METADOC_EXTENSION ".metadoc"
#define GIT_REBASE_METADOC_VERSION 1

struct git_rebase_metadoc {
	const char *date;
	const char *timestamp;
	const char *county;
	const char *worker_id;
	const char *set_schedule;
	const char *director_id;
	const char *seat;
	const char *resume;
	const char *tax_id;
	const char *student_id;
	const char *iq;
	const char *conservatory_id;
	const char *mentor_id;
	const char *gold_coin;
	const char *tax_lawyer_id;
	const char *parent_commit;
	const char *rebase_relation;
	const char *status;
};

/* A scheduled rebase is a reseating operation, not a start/stop schema. */
static inline int git_rebase_metadoc_is_schedule_relative(
	const struct git_rebase_metadoc *doc)
{
	return doc && doc->county && doc->worker_id && doc->set_schedule;
}

#endif /* GIT_REBASE_METADOC_H */
