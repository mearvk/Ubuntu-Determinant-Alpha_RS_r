/* C++ companion for the native message-catalog contract. */
#include "messages.h"

/*
 * The default catalog mirrors the C companion's git_msg_defaults exactly; the
 * two are held identical by the header/source check and by MESSAGES.md. Keeping
 * a self-contained copy here lets the C++ translation unit build without
 * pulling in git-compat-util.h (which is not C++-clean standalone), matching
 * the pattern used by the other native modules.
 */
static const struct git_msg_entry git_msg_defaults[] = {
	{ GIT_MSG_ID_GIT_REQUIRED,      GIT_MSG_STDERR, GIT_MSG_ERROR, GIT_CONCERN_PRECONDITION,
	  "Git is required but was not found on PATH. Please install Git and try again." },
	{ GIT_MSG_ID_NOT_A_REPO,        GIT_MSG_STDERR, GIT_MSG_ERROR, GIT_CONCERN_PRECONDITION,
	  "The target path is not a Git repository. Choose a repository or initialize one first." },
	{ GIT_MSG_ID_TREE_NOT_CLEAN,    GIT_MSG_STDERR, GIT_MSG_ERROR, GIT_CONCERN_PRECONDITION,
	  "The working tree has uncommitted changes. This operation was declined to protect them; commit or stash first." },
	{ GIT_MSG_ID_DETACHED_HEAD,     GIT_MSG_STDERR, GIT_MSG_ERROR, GIT_CONCERN_PRECONDITION,
	  "HEAD is detached, so no branch can be inferred. Please name the branch explicitly." },
	{ GIT_MSG_ID_NOTHING_STAGED,    GIT_MSG_STDERR, GIT_MSG_ERROR, GIT_CONCERN_PRECONDITION,
	  "There are no staged changes to commit. Stage the intended paths and try again." },
	{ GIT_MSG_ID_MESSAGE_REQUIRED,  GIT_MSG_STDERR, GIT_MSG_ERROR, GIT_CONCERN_PRECONDITION,
	  "A commit message is required. Please provide one." },
	{ GIT_MSG_ID_PATHSPEC_REQUIRED, GIT_MSG_STDERR, GIT_MSG_ERROR, GIT_CONCERN_PRECONDITION,
	  "At least one pathspec is required for this operation." },
	{ GIT_MSG_ID_BAD_ARGUMENT,      GIT_MSG_STDERR, GIT_MSG_ERROR, GIT_CONCERN_PRECONDITION,
	  "An argument was not understood. Please review the usage and try again." },
	{ GIT_MSG_ID_UNKNOWN_COMMAND,   GIT_MSG_STDERR, GIT_MSG_ERROR, GIT_CONCERN_PRECONDITION,
	  "That command is not recognized. See the usage for the available commands." },

	{ GIT_MSG_ID_SIZE_CEILING,      GIT_MSG_STDERR, GIT_MSG_ERROR, GIT_CONCERN_SIZE_CEILING,
	  "A single item exceeds the 200 MiB transaction ceiling and cannot be split, so the plan cannot proceed. Please reduce the item or adjust the plan." },
	{ GIT_MSG_ID_MEMORY_BLOAT,      GIT_MSG_STDERR, GIT_MSG_WARNING, GIT_CONCERN_MEMORY_BLOAT,
	  "Memory use has grown beyond the advisory budget for this operation. Consider working in smaller batches." },
	{ GIT_MSG_ID_DISK_SPACE,        GIT_MSG_STDERR, GIT_MSG_ERROR, GIT_CONCERN_DISK_SPACE,
	  "There is not enough free disk space to complete this operation safely. Please free space and try again." },
	{ GIT_MSG_ID_MISSING_FILE,      GIT_MSG_STDERR, GIT_MSG_ERROR, GIT_CONCERN_MISSING_FILE,
	  "An expected file or object could not be found. Please confirm the path and repository state." },
	{ GIT_MSG_ID_CORRUPTION,        GIT_MSG_STDERR, GIT_MSG_FATAL, GIT_CONCERN_CORRUPTION,
	  "An integrity check failed, which suggests a damaged file or object. No changes were made; please run a repository check before continuing." },
	{ GIT_MSG_ID_OVERFLOW,          GIT_MSG_STDERR, GIT_MSG_ERROR, GIT_CONCERN_ARITHMETIC_OVERFLOW,
	  "A size or count calculation would overflow and was rejected rather than allowed to wrap. Please reduce the scope of the request." },
	{ GIT_MSG_ID_PERMISSION,        GIT_MSG_STDERR, GIT_MSG_ERROR, GIT_CONCERN_PERMISSION,
	  "Permission was denied for this action. Please check file and remote permissions and try again." },
	{ GIT_MSG_ID_NO_DIGEST_TOOL,    GIT_MSG_STDERR, GIT_MSG_ERROR, GIT_CONCERN_PRECONDITION,
	  "No suitable checksum tool (SHA-256 or SHA-512) is available, so an integrity reference cannot be computed." },

	{ GIT_MSG_ID_RESUME_INTERRUPTED, GIT_MSG_STDERR, GIT_MSG_NOTE, GIT_CONCERN_NETWORK_LOSS,
	  "The connection was interrupted; the remaining work will resume from the last acknowledged point." },
	{ GIT_MSG_ID_RESUME_HALTED,      GIT_MSG_STDERR, GIT_MSG_ERROR, GIT_CONCERN_NETWORK_LOSS,
	  "The retry limit was reached with work still remaining, so the effort was halted rather than looping. Please retry when the connection is stable." },
	{ GIT_MSG_ID_RESUME_COMPLETE,    GIT_MSG_STDOUT, GIT_MSG_INFO,  GIT_CONCERN_NONE,
	  "The remote has acknowledged all work; the transfer is complete." }
};

extern "C" size_t git_msg_default_catalog(struct git_msg_entry *out,
					  size_t out_count)
{
	size_t n = sizeof(git_msg_defaults) / sizeof(git_msg_defaults[0]);

	if (!out || out_count < n)
		return 0;
	for (size_t i = 0; i < n; i++)
		out[i] = git_msg_defaults[i];
	return n;
}

extern "C" int git_msg_catalog_validate(const struct git_msg_entry *entries,
					size_t count)
{
	if (!entries || count != static_cast<size_t>(GIT_MSG_ID__COUNT))
		return -1;

	bool seen[GIT_MSG_ID__COUNT] = { false };

	for (size_t i = 0; i < count; i++) {
		const struct git_msg_entry *e = &entries[i];

		if (!git_msg_entry_valid(e))
			return -1;
		if (e->severity >= GIT_MSG_ERROR && e->stream != GIT_MSG_STDERR)
			return -1;
		if (seen[e->id])
			return -1;
		seen[e->id] = true;
	}

	for (size_t i = 0; i < static_cast<size_t>(GIT_MSG_ID__COUNT); i++)
		if (!seen[i])
			return -1;

	return 0;
}

extern "C" const struct git_msg_entry *git_msg_lookup(
		const struct git_msg_entry *entries, size_t count,
		enum git_msg_id id)
{
	if (!entries || !git_msg_id_valid(id))
		return nullptr;
	for (size_t i = 0; i < count; i++)
		if (entries[i].id == id)
			return &entries[i];
	return nullptr;
}
