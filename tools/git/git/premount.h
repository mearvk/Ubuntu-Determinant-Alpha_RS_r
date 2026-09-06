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

/*
 * In C we use Git's compat layer. In C++ (the self-contained policy companion
 * and any C++ consumer) git-compat-util.h is not C++-clean, so we pull only the
 * fixed-width integer, size, and string helpers directly.
 */
#ifdef __cplusplus
#include <cstdint>
#include <cstddef>
#include <cstring>
#else
#include "git-compat-util.h"
#include <stdint.h>
#endif

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
 * ---------------------------------------------------------------------------
 * premount push: deterministic document reference + ordered 200 MiB sequence.
 * ---------------------------------------------------------------------------
 *
 * `premount push` turns the read-only inventory into a *transfer plan*:
 *
 *   1. It produces a deterministic premount document over the ordered
 *      candidate set (paths, object-byte sizes, and their 200 MiB grouping).
 *   2. It computes a cryptographic digest of that document as the stable
 *      output *reference* for the premount call itself. SHA-256 is the floor;
 *      "or better" (SHA-512) is permitted. The reference is computed over the
 *      deterministic document body only, never over volatile fields such as a
 *      wall-clock timestamp, so the same candidate set always yields the same
 *      reference.
 *   3. It partitions the ordered set into transactions of at most 200 MiB and
 *      emits them as an ordered add/commit sequence, which the resume
 *      checkpoint (resume-budget.h) drives for partial commits and resume.
 *
 * The digest reference is integrity metadata, not authenticity or authority
 * (see SHA256.md). It never relaxes the 200 MiB push ceiling and never
 * authorizes a transfer the push guard would reject.
 */

/* Transaction size for the ordered add/commit sequence: 200 MiB. */
#define GIT_PREMOUNT_PUSH_TXN_BYTES ((uintmax_t)200 * 1024 * 1024)

/*
 * Digest algorithm for the premount document reference. SHA-256 is the policy
 * floor; SHA-512 is the permitted "or better" option. The values are stable
 * identifiers, not raw Git hash-algo numbers.
 */
enum git_premount_digest_algo {
	GIT_PREMOUNT_DIGEST_SHA256 = 0, /* floor: 256-bit reference */
	GIT_PREMOUNT_DIGEST_SHA512 = 1  /* "or better": 512-bit    */
};

/* One ordered transaction (<= 200 MiB) of the emitted add/commit sequence. */
struct git_premount_txn {
	uintmax_t ordinal;      /* 1-based transaction order            */
	uintmax_t first_row;    /* zero-based index of first row        */
	uintmax_t row_count;    /* rows in this transaction             */
	uintmax_t bytes;        /* accumulated object bytes (<= 200 MiB) */
};

/* The transfer plan produced by premount push. */
struct git_premount_push_plan {
	const struct git_premount_report *report; /* the inventory        */
	enum git_premount_digest_algo algo;       /* reference algorithm  */
	const char *document_reference;           /* hex digest, caller-owned */
	uintmax_t txn_count;                      /* number of 200 MiB txns */
	uintmax_t total_bytes;                    /* == report total       */
};

static inline int git_premount_digest_valid(enum git_premount_digest_algo a)
{
	return a == GIT_PREMOUNT_DIGEST_SHA256 || a == GIT_PREMOUNT_DIGEST_SHA512;
}

/* Human-readable digest label; never returns NULL. */
static inline const char *git_premount_digest_label(
					enum git_premount_digest_algo a)
{
	switch (a) {
	case GIT_PREMOUNT_DIGEST_SHA512: return "SHA-512";
	case GIT_PREMOUNT_DIGEST_SHA256:
	default:                         return "SHA-256";
	}
}

/* Expected hex length of the reference for an algorithm (excludes NUL). */
static inline size_t git_premount_digest_hexlen(enum git_premount_digest_algo a)
{
	return a == GIT_PREMOUNT_DIGEST_SHA512 ? 128u : 64u;
}

/*
 * Would appending object_bytes to the current transaction cross the 200 MiB
 * boundary? A single file is never split; an object larger than the
 * transaction size is an oversize planning error for the caller to surface,
 * not a silent fragmentation. Mirrors the add-block boundary primitive.
 */
static inline int git_premount_txn_would_cross(uintmax_t txn_bytes,
					uintmax_t object_bytes)
{
	return txn_bytes &&
		object_bytes > GIT_PREMOUNT_PUSH_TXN_BYTES - txn_bytes;
}

/* Deterministic count of 200 MiB transactions needed for total_bytes when no
 * single object exceeds the transaction size. Rounds up. */
static inline uintmax_t git_premount_txn_count_for_bytes(uintmax_t total_bytes)
{
	if (!total_bytes)
		return 0;
	return (total_bytes + GIT_PREMOUNT_PUSH_TXN_BYTES - 1) /
		GIT_PREMOUNT_PUSH_TXN_BYTES;
}

static inline int git_premount_push_plan_valid(
				const struct git_premount_push_plan *plan)
{
	return plan && plan->report &&
		git_premount_digest_valid(plan->algo) &&
		plan->document_reference &&
		strlen(plan->document_reference) ==
			git_premount_digest_hexlen(plan->algo);
}

/*
 * The exported report/plan functions are implemented in premount.c and
 * premount.cpp. They are intentionally not forward-declared here so each
 * translation unit can declare them with the linkage it needs (C, or
 * extern "C" from C++), matching the convention used by the other native
 * operation headers.
 */

#endif /* GIT_PREMOUNT_H */
