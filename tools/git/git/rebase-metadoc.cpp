/*
 * C++ companion implementation for scheduled rebase metadata.
 *
 * This mirrors the native C contract so project-side C++ components can
 * validate the same schedule-relative record without invoking a script.
 */

#include <string_view>

namespace git_rebase_metadoc_policy {

struct record_view {
	std::string_view date;
	std::string_view timestamp;
	std::string_view county;
	std::string_view worker_id;
	std::string_view set_schedule;
	std::string_view director_id;
	std::string_view seat;
	std::string_view resume;
};

static bool present(std::string_view value)
{
	return !value.empty();
}

bool schedule_relative(const record_view &record)
{
	return present(record.county) &&
		present(record.worker_id) &&
		present(record.set_schedule);
}

bool structurally_complete(const record_view &record)
{
	return present(record.date) &&
		present(record.timestamp) &&
		schedule_relative(record) &&
		present(record.director_id) &&
		present(record.seat) &&
		present(record.resume);
}

} // namespace git_rebase_metadoc_policy
