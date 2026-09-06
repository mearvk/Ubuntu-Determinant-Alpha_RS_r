/* Native two-level restage/index history contract. */
#ifndef GIT_RESTAGE_H
#define GIT_RESTAGE_H

#ifdef __cplusplus
#include <cstdint>
#else
#include "git-compat-util.h"
#include <stdint.h>
#endif

enum git_restage_direction {
	GIT_RESTAGE_BACKWARD = -1,
	GIT_RESTAGE_FRAME = 0,
	GIT_RESTAGE_FORWARD = 1
};

struct git_restage_record {
	intmax_t offset;
	const char *admin_chain_id;
	const char *admin_parent;
	const char *base_commit_before;
	const char *base_commit_after;
	const char *index_before;
	const char *index_after;
	const char *function_call;
	const char *author;
	const char *committer;
	const char *date;
	const char *timestamp;
	const char *parent_commit;
	const char *prior_operation;
	const char *relevance;
	uintmax_t observation_sequence;
};

static inline enum git_restage_direction git_restage_direction_for(intmax_t offset)
{
	return offset < 0 ? GIT_RESTAGE_BACKWARD :
		offset > 0 ? GIT_RESTAGE_FORWARD : GIT_RESTAGE_FRAME;
}

static inline int git_restage_record_valid(const struct git_restage_record *record)
{
	return record && record->admin_chain_id && record->base_commit_before &&
		record->base_commit_after && record->index_before && record->index_after &&
		record->function_call && record->parent_commit;
}

#endif /* GIT_RESTAGE_H */
