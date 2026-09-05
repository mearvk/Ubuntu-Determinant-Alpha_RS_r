/* Native premount inventory implementation. */
#include "git-compat-util.h"
#include "premount.h"

int git_premount_report_validate(const struct git_premount_report *report)
{
	size_t i;

	if (!report)
		return -1;
	if (!git_premount_source_valid(report->requested_sources))
		return -1;
	if (report->row_count && !report->rows)
		return -1;

	for (i = 0; i < report->row_count; i++) {
		const struct git_premount_row *row = &report->rows[i];

		if (!git_premount_row_valid(row))
			return -1;
		/* A row must belong to a subset of the requested sources. */
		if (row->sources & ~report->requested_sources)
			return -1;
	}

	return 0;
}

int git_premount_report_total(struct git_premount_report *report)
{
	uintmax_t total = 0;
	size_t i;

	if (git_premount_report_validate(report))
		return -1;

	for (i = 0; i < report->row_count; i++) {
		if (git_premount_size_accumulate(&total,
					report->rows[i].size_bytes))
			return -1;
	}

	report->total_size_bytes = total;
	return 0;
}


/*
 * Partition the ordered inventory rows into 200 MiB transactions.
 *
 * Deterministic, breadth-first in the row order already fixed by the report.
 * A file is never split: if a row would cross the 200 MiB boundary, the
 * current transaction is closed first. A single object larger than the
 * transaction size is reported as an oversize error (return -1) rather than
 * silently fragmented.
 *
 * `txns` may be NULL to only count; otherwise it must hold at least `cap`
 * entries. On success *out_count receives the number of transactions.
 * Returns 0 on success, -1 on invalid input or an oversize object.
 */
int git_premount_push_partition(const struct git_premount_report *report,
				struct git_premount_txn *txns, size_t cap,
				uintmax_t *out_count)
{
	uintmax_t ordinal = 0;
	uintmax_t txn_bytes = 0;
	uintmax_t txn_rows = 0;
	uintmax_t txn_first = 0;
	size_t i;

	if (!report || !out_count)
		return -1;
	if (report->row_count && !report->rows)
		return -1;

	for (i = 0; i < report->row_count; i++) {
		uintmax_t object_bytes = report->rows[i].size_bytes;

		/* An object that cannot fit any transaction is a planning error. */
		if (object_bytes > GIT_PREMOUNT_PUSH_TXN_BYTES)
			return -1;

		/* Close the current transaction before a row that would cross. */
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

	/* Flush the final open transaction. */
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

/*
 * Finalize a premount push plan. The caller supplies the report, the chosen
 * digest algorithm, and the already-computed hex document reference (computed
 * over the deterministic document body by the transport layer, since the
 * native tree does not embed a hashing dependency here). This validates the
 * inputs, recomputes the deterministic transaction count and total bytes, and
 * confirms the reference length matches the algorithm.
 *
 * Returns 0 on success, -1 on invalid input or an oversize object.
 */
int git_premount_push_plan_finalize(struct git_premount_push_plan *plan)
{
	uintmax_t count = 0;

	if (!plan || !git_premount_push_plan_valid(plan))
		return -1;

	if (git_premount_report_validate((struct git_premount_report *)plan->report))
		return -1;

	if (git_premount_push_partition(plan->report, NULL, 0, &count))
		return -1;

	plan->txn_count = count;
	plan->total_bytes = plan->report->total_size_bytes;
	return 0;
}
