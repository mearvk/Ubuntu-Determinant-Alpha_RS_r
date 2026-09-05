/*
 * Ubuntu Determinant native premount planner.
 *
 * `premount` is a read-only pre-operation inventory. It gathers the files
 * newly introduced by a pending `add`, a pending `commit`, or both, and
 * assembles a deterministic per-file record intended for a printable table.
 *
 * The operation supplements Git; it never replaces object identity or the
 * ordinary index/commit semantics. The recorded rows are advisory metadata
 * that later add/commit/push planning may reference. premount performs no
 * staging, commit, or transport itself.
 */

#ifndef GIT_PREMOUNT_H
#define GIT_PREMOUNT_H

#include "git-compat-util.h"
#include <stdint.h>

/*
 * Which pending operations premount should account for. The set is a bit
 * field so a caller may request the union of the pending `add` worktree
 * candidates and the pending `commit` staged candidates.
 */
enum git_premount_source {
	GIT_PREMOUNT_NONE   = 0,
	GIT_PREMOUNT_ADD    = 1 << 0, /* candidates for a pending `add`    */
	GIT_PREMOUNT_COMMIT = 1 << 1  /* candidates for a pending `commit` */
};

#define GIT_PREMOUNT_BOTH (GIT_PREMOUNT_ADD | GIT_PREMOUNT_COMMIT)

/*
 * Learning grade for a file. This is a deterministic pedagogical relevance
 * marker, not a security or authorization grade, and never influences object
 * identity, staging, or transport. It mirrors the advisory spirit of the
 * TIER-1/TIER-2 relevance markers in GIT_OPERATIONS.logic.
 */
enum git_premount_learning_grade {
	GIT_PREMOUNT_GRADE_NONE = 0,
	GIT_PREMOUNT_GRADE_INTRODUCTORY,   /* CS100-level: first exposure       */
	GIT_PREMOUNT_GRADE_FOUNDATIONAL,   /* CS200-level: core competency      */
	GIT_PREMOUNT_GRADE_INTERMEDIATE,   /* CS300-level: applied competency   */
	GIT_PREMOUNT_GRADE_ADVANCED,       /* CS400-level: specialization       */
	GIT_PREMOUNT_GRADE_GRADUATE        /* CS500+-level: research competency */
};

/*
 * A single deterministic premount row. Every string field is owned by the
 * caller; premount treats them as read-only references. Missing optional
 * fields are represented by NULL, never by an invented placeholder.
 */
struct git_premount_row {
	/* Provenance and object facts (preserved from Git, never invented). */
	const char *path;             /* deterministic Git pathname            */
	const char *timestamp;        /* operation/inspection timestamp        */
	const char *author;           /* Git author identity                   */
	uintmax_t   size_bytes;       /* object-byte estimate for the file     */
	const char *suffix;           /* filename suffix incl. leading dot     */
	const char *operating_system; /* recording host OS identifier          */

	/* Advisory pedagogical relevance metadata. */
	enum git_premount_learning_grade learning_grade;
	const char *cs_prerequisites;  /* prerequisite CS topics, if declared  */
	const char *graded_authorships; /* graded authorship attribution        */
	const char *college_references; /* course/college reference citations   */

	/* Chain markers, consistent with the CHAIN rules in the .logic model. */
	const char *prior_operation;
	const char *parent_commit;

	/* Which pending source(s) contributed this row. */
	unsigned int sources;          /* bit field of enum git_premount_source */
};

/* A complete premount inventory produced for a printable table. */
struct git_premount_report {
	unsigned int requested_sources; /* union requested by the caller       */
	const struct git_premount_row *rows;
	size_t row_count;
	uintmax_t total_size_bytes;     /* sum of row sizes, overflow-checked   */
};

static inline int git_premount_source_valid(unsigned int sources)
{
	return sources != GIT_PREMOUNT_NONE &&
		(sources & ~(unsigned int)GIT_PREMOUNT_BOTH) == 0;
}

static inline int git_premount_grade_valid(enum git_premount_learning_grade g)
{
	return g >= GIT_PREMOUNT_GRADE_NONE && g <= GIT_PREMOUNT_GRADE_GRADUATE;
}

static inline int git_premount_row_valid(const struct git_premount_row *row)
{
	return row && row->path &&
		git_premount_grade_valid(row->learning_grade) &&
		git_premount_source_valid(row->sources);
}

/*
 * Accumulate a row's size into a running total, rejecting integer overflow
 * rather than wrapping (consistent with the MORAL overflow rule).
 * Returns 0 on success, -1 on overflow or invalid input.
 */
static inline int git_premount_size_accumulate(uintmax_t *total,
					uintmax_t size_bytes)
{
	if (!total)
		return -1;
	if (*total > UINTMAX_MAX - size_bytes)
		return -1;
	*total += size_bytes;
	return 0;
}

/*
 * Human-readable label for a learning grade, suitable for a table cell.
 * Never returns NULL.
 */
static inline const char *git_premount_grade_label(
					enum git_premount_learning_grade g)
{
	switch (g) {
	case GIT_PREMOUNT_GRADE_INTRODUCTORY: return "introductory";
	case GIT_PREMOUNT_GRADE_FOUNDATIONAL: return "foundational";
	case GIT_PREMOUNT_GRADE_INTERMEDIATE: return "intermediate";
	case GIT_PREMOUNT_GRADE_ADVANCED:     return "advanced";
	case GIT_PREMOUNT_GRADE_GRADUATE:     return "graduate";
	case GIT_PREMOUNT_GRADE_NONE:
	default:                              return "ungraded";
	}
}

/*
 * The exported report functions are implemented in premount.c and premount.cpp.
 * They are intentionally not forward-declared here so each translation unit can
 * declare them with the linkage it needs (C, or extern "C" from C++), matching
 * the convention used by the other native operation headers.
 */

#endif /* GIT_PREMOUNT_H */
