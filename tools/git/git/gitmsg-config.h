/*
 * Ubuntu Determinant message-config loader.
 *
 * Parses a `.gitmessages` document (see MESSAGES.md / messages.config.example)
 * at runtime and turns it into two things the compiled git binary can use:
 *
 *   1. an overlaid message catalog — the compiled defaults from messages.h with
 *      any `[MESSAGE <id>]` TEXT/STREAM/SEVERITY overrides applied; and
 *   2. a table of `[MAP]` rules — call-site/text selectors that name which
 *      catalogued message an intercepted output should become.
 *
 * The loader is deliberately conservative and user-friendly:
 *   - it never fails a caller: a missing, unreadable, empty, or malformed file
 *     simply yields the compiled defaults and zero map rules (pass-through);
 *   - it never produces an unsafe catalog: the overlay is re-validated with
 *     git_msg_catalog_validate(), and an override that would route an
 *     error/fatal message to stdout is dropped rather than honoured;
 *   - it copies every string it keeps into a caller-provided arena, so nothing
 *     points back into transient read buffers.
 *
 * C and C++ clean, matching the other native modules.
 */
#ifndef GIT_MSG_CONFIG_H
#define GIT_MSG_CONFIG_H

#include "messages.h"

#ifdef __cplusplus
#include <cstddef>
extern "C" {
#else
#include <stddef.h>
#endif

/*
 * One parsed [MAP] rule. Any selector may be NULL/empty, which matches
 * anything; a rule matches when all of its present selectors are substrings of
 * the corresponding call-site field. `id` is the catalogued message to emit.
 * The string pointers are owned by the arena passed to gitmsg_config_load().
 */
struct gitmsg_rule {
	const char *file_substr;
	const char *func_substr;
	const char *text_substr;
	enum git_msg_id id;
};

/*
 * Result of a load. `catalog` is filled with GIT_MSG_ID__COUNT validated
 * entries; `rules`/`rule_count` describe the parsed [MAP] table. `loaded` is 1
 * when a readable config was applied, 0 when the compiled defaults are in force
 * (which is still a fully usable result). `source_path` points at the file that
 * was used, or NULL when none was found.
 */
struct gitmsg_config {
	struct git_msg_entry catalog[GIT_MSG_ID__COUNT];
	size_t catalog_count;
	struct gitmsg_rule *rules;
	size_t rule_count;
	int loaded;
	/*
	 * Set to 1 when the file was read but its [MESSAGE] overrides produced
	 * an unsafe catalog (e.g. an error/fatal routed to stdout, or an
	 * emptied text), so the loader discarded them and restored the compiled
	 * defaults. The result is still safe to use; this flag lets an
	 * inspector tell the user their overrides did not take effect.
	 */
	int dropped_unsafe;
	const char *source_path;
};

/*
 * Translate a message-id name (e.g. "disk-space") to its enum value. Returns 0
 * on success and writes *out; returns -1 for an unknown name. Names match the
 * ids listed in messages.config.example and enum git_msg_id.
 */
int gitmsg_id_from_name(const char *name, enum git_msg_id *out);

/* The canonical lowercase name for an id (e.g. "disk-space"); never NULL. */
const char *gitmsg_id_name(enum git_msg_id id);

/*
 * Load and apply a message config.
 *
 *   path      - the .gitmessages file to read, or NULL to auto-resolve via
 *               gitmsg_config_path().
 *   cfg       - filled in on return (always initialized to a usable state).
 *   rules_buf - caller storage for parsed [MAP] rules.
 *   rules_cap - capacity of rules_buf (rules beyond this are ignored).
 *   arena     - caller storage the loader copies kept strings into.
 *   arena_sz  - size of arena in bytes (strings beyond this are dropped).
 *
 * Returns 0 always: the result is a usable config even on error (defaults +
 * no rules). A negative return is reserved for a programming error (NULL cfg).
 */
int gitmsg_config_load(const char *path, struct gitmsg_config *cfg,
		       struct gitmsg_rule *rules_buf, size_t rules_cap,
		       char *arena, size_t arena_sz);

/*
 * Resolve which config file to use, without reading it. Preference order:
 *   1. $GIT_MESSAGES_CONFIG            (explicit override), else
 *   2. <repo_root>/.gitmessages        when repo_root is non-NULL, else
 *   3. NULL                            (use compiled defaults).
 * Returns a pointer to a static buffer or an environment string, or NULL.
 */
const char *gitmsg_config_path(const char *repo_root);

#ifdef __cplusplus
}
#endif

#endif /* GIT_MSG_CONFIG_H */
