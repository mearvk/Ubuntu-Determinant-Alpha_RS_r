/*
 * Ubuntu Determinant native "messages" module.
 *
 * A single, reviewable contract for the human-facing text the Edition Git
 * emits on stdout and stderr, and for the *concerns* those messages describe
 * (memory bloat, disk-space exhaustion, missing files, and the like).
 *
 * Rationale. Until now, every user-facing string lived inline in the command
 * surface (git-workflow.sh) as an ad-hoc `echo "ERROR: ..." >&2`. That made the
 * wording inconsistent, hard to review, and impossible to reason about as a
 * whole. This module centralizes:
 *
 *   1. a stable *catalog* of messages, each addressed by a stable identifier,
 *      classified by output stream and severity; and
 *   2. a stable set of *concern* classes an operation may need to report
 *      (resource, integrity, and precondition concerns), each with a settled,
 *      mature definition.
 *
 * The catalog is seeded from a per-repository config document (see
 * MESSAGES.md and git/messages.config.example), which mirrors the enums and
 * the default catalog declared here. Like the other native modules, this one
 * is advisory and supplements Git; it never changes object identity, history,
 * or transport policy:
 *
 *   - the authoritative behaviour of an operation is unchanged by its text;
 *   - a message config only re-words, re-streams, or localizes output, and can
 *     never turn an error into a success, suppress a safety refusal, change an
 *     exit status into a passing one, or authorize a destructive action;
 *   - a stale, missing, or altered config falls back to the compiled defaults
 *     below rather than failing the operation or inventing a permissive result.
 *
 * The header is both C and C++ clean, matching the other policy contracts.
 */
#ifndef GIT_MESSAGES_H
#define GIT_MESSAGES_H

#ifdef __cplusplus
#include <cstdint>
#include <cstddef>
#include <cstring>
#else
#include "git-compat-util.h"
#include <stdint.h>
#include <string.h>
#endif

#define GIT_MESSAGES_CONFIG_VERSION ((unsigned)1)

/*
 * The output stream a message is written to. Diagnostics, warnings, and
 * refusals go to stderr; ordinary progress and results go to stdout. This
 * mirrors the existing convention in git-workflow.sh (every "ERROR:" line is
 * redirected with `>&2`).
 */
enum git_msg_stream {
	GIT_MSG_STDOUT = 0,
	GIT_MSG_STDERR = 1
};

/*
 * Severity of a message, in increasing order. Kept deliberately small and
 * conventional so wording and stream selection stay predictable.
 *
 *   INFO    - ordinary progress or result (stdout).
 *   NOTE    - a benign, non-blocking observation the reader should see.
 *   WARNING - something the reader should weigh; the operation still proceeds.
 *   ERROR   - the operation cannot proceed as asked and stops.
 *   FATAL   - an unrecoverable condition; the process cannot safely continue.
 */
enum git_msg_severity {
	GIT_MSG_INFO = 0,
	GIT_MSG_NOTE = 1,
	GIT_MSG_WARNING = 2,
	GIT_MSG_ERROR = 3,
	GIT_MSG_FATAL = 4
};

/*
 * The classes of *concern* an operation may need to report. A concern is the
 * underlying condition; a message is how it is phrased. Grouped into resource,
 * integrity, and precondition concerns.
 *
 *   NONE            - no concern; ordinary success/progress.
 *
 *   Resource concerns (bounded, observable local limits):
 *   MEMORY_BLOAT    - resident/working-set growth beyond an advisory budget.
 *   DISK_SPACE      - insufficient or nearly-exhausted local disk (ENOSPC).
 *   SIZE_CEILING    - a planned unit exceeds a policy size ceiling (e.g. the
 *                     200 MiB push/transaction budget) and must not be split.
 *   ARITHMETIC_OVERFLOW - a size/count computation would overflow; rejected
 *                     rather than wrapped (mirrors the native overflow rules).
 *
 *   Integrity concerns (the object graph or files are not as expected):
 *   MISSING_FILE    - an expected path or object is absent.
 *   CORRUPTION      - a file or object failed an integrity or fsck check.
 *   PROVENANCE_GAP  - required provenance (author/commit/reference) is absent;
 *                     recorded as absent, never invented.
 *
 *   Precondition concerns (the request or environment is not ready):
 *   PERMISSION      - a filesystem/transport permission prevents the action.
 *   PRECONDITION    - a required state is unmet (not a repo, detached HEAD,
 *                     dirty tree, nothing staged, missing tool, bad argument).
 *   NETWORK_LOSS    - a slow/lossy or interrupted connection (a normal
 *                     condition handled by resume, not a failure by itself).
 */
enum git_msg_concern {
	GIT_CONCERN_NONE = 0,
	GIT_CONCERN_MEMORY_BLOAT,
	GIT_CONCERN_DISK_SPACE,
	GIT_CONCERN_SIZE_CEILING,
	GIT_CONCERN_ARITHMETIC_OVERFLOW,
	GIT_CONCERN_MISSING_FILE,
	GIT_CONCERN_CORRUPTION,
	GIT_CONCERN_PROVENANCE_GAP,
	GIT_CONCERN_PERMISSION,
	GIT_CONCERN_PRECONDITION,
	GIT_CONCERN_NETWORK_LOSS,
	GIT_CONCERN__COUNT /* sentinel; not a concern */
};

/*
 * Stable message identifiers. These name a slot in the catalog; the *text* for
 * a slot may be overridden by config, but the identifier, its stream, and its
 * severity are the contract. Ordered by the operation/area they belong to so
 * the catalog reads top-to-bottom like the command surface.
 */
enum git_msg_id {
	/* Environment / preconditions (shared) */
	GIT_MSG_ID_GIT_REQUIRED = 0,   /* git binary not found on PATH        */
	GIT_MSG_ID_NOT_A_REPO,         /* target is not a Git repository      */
	GIT_MSG_ID_TREE_NOT_CLEAN,     /* working tree dirty; refusing action */
	GIT_MSG_ID_DETACHED_HEAD,      /* no branch; one must be named        */
	GIT_MSG_ID_NOTHING_STAGED,     /* no staged changes to commit         */
	GIT_MSG_ID_MESSAGE_REQUIRED,   /* commit message required             */
	GIT_MSG_ID_PATHSPEC_REQUIRED,  /* at least one pathspec required      */
	GIT_MSG_ID_BAD_ARGUMENT,       /* malformed / unexpected argument     */
	GIT_MSG_ID_UNKNOWN_COMMAND,    /* unknown workflow command            */

	/* Resource / integrity concerns */
	GIT_MSG_ID_SIZE_CEILING,       /* unit exceeds the transaction ceiling*/
	GIT_MSG_ID_MEMORY_BLOAT,       /* working set beyond advisory budget  */
	GIT_MSG_ID_DISK_SPACE,         /* local disk exhausted / near full    */
	GIT_MSG_ID_MISSING_FILE,       /* expected path/object absent         */
	GIT_MSG_ID_CORRUPTION,         /* integrity/fsck check failed         */
	GIT_MSG_ID_OVERFLOW,           /* size/count arithmetic would overflow*/
	GIT_MSG_ID_PERMISSION,         /* permission prevents the action      */
	GIT_MSG_ID_NO_DIGEST_TOOL,     /* no SHA-256/512 tool available       */

	/* Transport / resume progress */
	GIT_MSG_ID_RESUME_INTERRUPTED, /* attempt interrupted; will resume    */
	GIT_MSG_ID_RESUME_HALTED,      /* retry ceiling reached, work remains */
	GIT_MSG_ID_RESUME_COMPLETE,    /* remote fully acknowledged           */

	GIT_MSG_ID__COUNT /* sentinel; not a message */
};

/*
 * One catalog entry: the fixed contract for a message slot plus the text in
 * force. `text` points at the compiled default until a validated config
 * overrides it; it is never NULL.
 */
struct git_msg_entry {
	enum git_msg_id id;
	enum git_msg_stream stream;
	enum git_msg_severity severity;
	enum git_msg_concern concern;
	const char *text; /* current wording; default until config overrides */
};

/* --- validity predicates (pure; never touch I/O) ------------------------- */

static inline int git_msg_stream_valid(enum git_msg_stream s)
{
	return s == GIT_MSG_STDOUT || s == GIT_MSG_STDERR;
}

static inline int git_msg_severity_valid(enum git_msg_severity s)
{
	return s >= GIT_MSG_INFO && s <= GIT_MSG_FATAL;
}

static inline int git_msg_concern_valid(enum git_msg_concern c)
{
	return c >= GIT_CONCERN_NONE && c < GIT_CONCERN__COUNT;
}

static inline int git_msg_id_valid(enum git_msg_id id)
{
	return id >= GIT_MSG_ID_GIT_REQUIRED && id < GIT_MSG_ID__COUNT;
}

/* Human-readable labels; never return NULL. */
static inline const char *git_msg_stream_label(enum git_msg_stream s)
{
	return s == GIT_MSG_STDERR ? "stderr" : "stdout";
}

static inline const char *git_msg_severity_label(enum git_msg_severity s)
{
	switch (s) {
	case GIT_MSG_NOTE:    return "note";
	case GIT_MSG_WARNING: return "warning";
	case GIT_MSG_ERROR:   return "error";
	case GIT_MSG_FATAL:   return "fatal";
	case GIT_MSG_INFO:
	default:              return "info";
	}
}

static inline const char *git_msg_concern_label(enum git_msg_concern c)
{
	switch (c) {
	case GIT_CONCERN_MEMORY_BLOAT:        return "memory-bloat";
	case GIT_CONCERN_DISK_SPACE:          return "disk-space";
	case GIT_CONCERN_SIZE_CEILING:        return "size-ceiling";
	case GIT_CONCERN_ARITHMETIC_OVERFLOW: return "arithmetic-overflow";
	case GIT_CONCERN_MISSING_FILE:        return "missing-file";
	case GIT_CONCERN_CORRUPTION:          return "corruption";
	case GIT_CONCERN_PROVENANCE_GAP:      return "provenance-gap";
	case GIT_CONCERN_PERMISSION:          return "permission";
	case GIT_CONCERN_PRECONDITION:        return "precondition";
	case GIT_CONCERN_NETWORK_LOSS:        return "network-loss";
	case GIT_CONCERN_NONE:
	default:                              return "none";
	}
}

/*
 * A default catalog entry is well-formed when its id/stream/severity/concern
 * are valid and it carries non-empty text. Config overrides are held to the
 * same standard by the validator in messages.c / messages.cpp.
 */
static inline int git_msg_entry_valid(const struct git_msg_entry *e)
{
	return e && git_msg_id_valid(e->id) &&
		git_msg_stream_valid(e->stream) &&
		git_msg_severity_valid(e->severity) &&
		git_msg_concern_valid(e->concern) &&
		e->text && e->text[0] != '\0';
}

/*
 * Whether a severity should be written to stderr by convention. ERROR, FATAL,
 * WARNING, and NOTE are diagnostics (stderr); INFO is a result (stdout). The
 * catalog's per-entry stream is authoritative; this is the default used when
 * validating that an entry's stream is consistent with its severity.
 */
static inline enum git_msg_stream git_msg_default_stream(enum git_msg_severity s)
{
	return (s >= GIT_MSG_NOTE) ? GIT_MSG_STDERR : GIT_MSG_STDOUT;
}

/*
 * Loader / lookup / validation implemented in messages.c / messages.cpp. The
 * C++ companion defines them with extern "C" linkage to match, exactly like the
 * other native modules.
 */
#ifdef __cplusplus
extern "C" {
#endif

/*
 * Fill `out` (an array of at least GIT_MSG_ID__COUNT entries) with the compiled
 * default catalog. Returns the number of entries written, or 0 on bad input.
 * Performs no I/O.
 */
size_t git_msg_default_catalog(struct git_msg_entry *out, size_t out_count);

/*
 * Validate a whole catalog: every id 0..COUNT-1 present exactly once, each
 * entry well-formed, and each stream consistent with its severity (an ERROR or
 * FATAL must not be routed to stdout). Returns 0 if the catalog is usable, -1
 * otherwise. A failing catalog means "fall back to defaults", never "proceed
 * permissively".
 */
int git_msg_catalog_validate(const struct git_msg_entry *entries, size_t count);

/*
 * Look up the entry for `id` within a catalog. Returns a pointer into the
 * supplied array, or NULL if `id` is not present. Never allocates.
 */
const struct git_msg_entry *git_msg_lookup(const struct git_msg_entry *entries,
					   size_t count, enum git_msg_id id);

#ifdef __cplusplus
}
#endif

#endif /* GIT_MESSAGES_H */
