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


extern "C" int git_premount_push_partition(
				const struct git_premount_report *report,
				struct git_premount_txn *txns, size_t cap,
				uintmax_t *out_count)
{
	uintmax_t ordinal = 0;
	uintmax_t txn_bytes = 0;
	uintmax_t txn_rows = 0;
	uintmax_t txn_first = 0;

	if (!report || !out_count)
		return -1;
	if (report->row_count && !report->rows)
		return -1;

	for (size_t i = 0; i < report->row_count; i++) {
		uintmax_t object_bytes = report->rows[i].size_bytes;

		if (object_bytes > GIT_PREMOUNT_PUSH_TXN_BYTES)
			return -1;

		if (git_premount_txn_would_cross(txn_bytes, object_bytes)) {
			if (txns) {
				if (ordinal >= cap)
					return -1;
				txns[ordinal].ordinal = ordinal + 1;
				txns[ordinal].first_row = txn_first;
				txns[ordinal].row_count = txn_rows;
				txns[ordinal].bytes = txn_bytes;
			}
			ordinal++;
			txn_bytes = 0;
			txn_rows = 0;
			txn_first = i;
		}

		txn_bytes += object_bytes;
		txn_rows++;
	}

	if (txn_rows) {
		if (txns) {
			if (ordinal >= cap)
				return -1;
			txns[ordinal].ordinal = ordinal + 1;
			txns[ordinal].first_row = txn_first;
			txns[ordinal].row_count = txn_rows;
			txns[ordinal].bytes = txn_bytes;
		}
		ordinal++;
	}

	*out_count = ordinal;
	return 0;
}

extern "C" int git_premount_push_plan_finalize(
				struct git_premount_push_plan *plan)
{
	uintmax_t count = 0;

	if (!plan || !git_premount_push_plan_valid(plan))
		return -1;
	if (git_premount_report_validate(
			const_cast<struct git_premount_report *>(plan->report)))
		return -1;
	if (git_premount_push_partition(plan->report, nullptr, 0, &count))
		return -1;

	plan->txn_count = count;
	plan->total_bytes = plan->report->total_size_bytes;
	return 0;
}
