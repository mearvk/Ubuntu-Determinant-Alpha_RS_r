/* Native operation relevance and provenance implementation. */
#include "git-compat-util.h"
#include "operation-logic.h"

int git_operation_logic_validate(const struct git_operation_logic_record *record)
{
	if (!git_operation_logic_record_valid(record))
		return -1;
	if (record->operation < GIT_OPERATION_ADD ||
		record->operation > GIT_OPERATION_REBASE)
		return -1;
	if (record->relevance < GIT_RELEVANCE_TIER1 ||
		record->relevance > GIT_RELEVANCE_UPLOAD)
		return -1;
	return 0;
}

int git_operation_logic_is_prior_integration(
	const struct git_operation_logic_record *record)
{
	return record && record->relevance == GIT_RELEVANCE_PRIORI_INTEGRATION;
}
