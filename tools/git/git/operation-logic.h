/* Native operation relevance and provenance contract. */
#ifndef GIT_OPERATION_LOGIC_H
#define GIT_OPERATION_LOGIC_H

#include "git-compat-util.h"
#include <stdint.h>

enum git_operation_kind {
	GIT_OPERATION_ADD,
	GIT_OPERATION_COMMIT,
	GIT_OPERATION_PUSH,
	GIT_OPERATION_MERGE,
	GIT_OPERATION_REBASE
};

enum git_relevance_kind {
	GIT_RELEVANCE_TIER1,
	GIT_RELEVANCE_TIER2,
	GIT_RELEVANCE_PRIORI_INTEGRATION,
	GIT_RELEVANCE_UPLOAD
};

struct git_operation_logic_record {
	enum git_operation_kind operation;
	enum git_relevance_kind relevance;
	const char *path_or_object;
	const char *prior_operation;
	const char *parent_commit;
	const char *author;
	const char *committer;
	const char *date;
	const char *timestamp;
	uintmax_t bytes;
};

static inline int git_operation_logic_record_valid(
	const struct git_operation_logic_record *record)
{
	return record && record->path_or_object && record->parent_commit;
}

#endif /* GIT_OPERATION_LOGIC_H */
