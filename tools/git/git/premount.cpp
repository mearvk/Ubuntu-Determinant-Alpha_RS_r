/* C++ companion for the native premount policy. */
#include "git-compat-util.h"
#include "premount.h"

extern "C" int git_premount_report_validate(
					const struct git_premount_report *report)
{
	if (!report)
		return -1;
	if (!git_premount_source_valid(report->requested_sources))
		return -1;
	if (report->row_count && !report->rows)
		return -1;
	for (size_t i = 0; i < report->row_count; i++) {
		const struct git_premount_row *row = &report->rows[i];
		if (!git_premount_row_valid(row))
			return -1;
		if (row->sources & ~report->requested_sources)
			return -1;
	}
	return 0;
}

extern "C" int git_premount_report_total(struct git_premount_report *report)
{
	if (git_premount_report_validate(report))
		return -1;
	uintmax_t total = 0;
	for (size_t i = 0; i < report->row_count; i++) {
		if (git_premount_size_accumulate(&total,
					report->rows[i].size_bytes))
			return -1;
	}
	report->total_size_bytes = total;
	return 0;
}
