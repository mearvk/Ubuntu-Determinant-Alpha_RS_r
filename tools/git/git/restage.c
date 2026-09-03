/* Native restage observation and index-history implementation. */
#include "git-compat-util.h"
#include "restage.h"

int git_restage_record_validate(const struct git_restage_record *record)
{
	if (!git_restage_record_valid(record))
		return -1;
	if (record->observation_sequence == 0)
		return -1;
	return 0;
}

int git_restage_net_offset(intmax_t before, intmax_t movement,
	intmax_t *after)
{
	if (!after)
		return -1;
	if ((movement > 0 && before > INTMAX_MAX - movement) ||
		(movement < 0 && before < INTMAX_MIN - movement))
		return -1;
	*after = before + movement;
	return 0;
}

int git_restage_is_round_trip(intmax_t first, intmax_t second)
{
	return first != 0 && second != 0 && first == -second;
}
