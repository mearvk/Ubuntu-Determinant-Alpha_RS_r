/* Native merge intellectual/metadoc contract. */
#ifndef GIT_MERGE_METADOC_H
#define GIT_MERGE_METADOC_H

#include "git-compat-util.h"
#include <stdint.h>

#define GIT_MERGE_METADOC_EXTENSION ".metadoc"
#define GIT_MERGE_METADOC_VERSION 1
#define GIT_MERGE_REBASE_THRESHOLD 2U

struct git_merge_metadoc {
	const char *date;
	const char *timestamp;
	const char *priority;
	const char *current_base;
	const char *merge_source;
	uintmax_t merge_source_count;
	const char *newer_succeeds_prior;
	const char *future_base_message;
	const char *county;
	const char *worker_id;
	const char *role;
	const char *director_id;
	const char *seat;
	const char *resume;
	const char *smart;
	const char *considerate;
	const char *proper;
	const char *comely;
	const char *sense_of_proper_person;
	const char *tax_id;
	const char *student_id;
	const char *iq;
	const char *conservatory_id;
	const char *mentor_id;
	const char *gold_coin;
	const char *tax_lawyer_id;
	uintmax_t merge_count;
	const char *parent_commit;
	const char *status;
};

static inline int git_merge_qualifies_rebase(uintmax_t merge_count)
{
	return merge_count >= GIT_MERGE_REBASE_THRESHOLD;
}

#endif /* GIT_MERGE_METADOC_H */
