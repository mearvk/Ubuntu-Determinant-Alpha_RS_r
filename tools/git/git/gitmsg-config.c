/*
 * Ubuntu Determinant message-config loader — implementation.
 *
 * Parses .gitmessages into an overlaid catalog and a [MAP] rule table. See
 * gitmsg-config.h for the contract and MESSAGES.md for the file format. The
 * loader defines GITMSG_LISTEN_IMPL so that, if the tree-wide listener header
 * is force-included during the build, its print macros are disabled here.
 */
#define GITMSG_LISTEN_IMPL 1

#include <stdio.h>
#include <string.h>
#include <stdlib.h>

#include "gitmsg-config.h"
#include "messages.h"

/*
 * Local ASCII helpers. We deliberately avoid <ctype.h> isspace()/tolower():
 * in the Git tree those are remapped to the sane_ctype table (ctype.c), and
 * this module is meant to be self-contained and linkable on its own.
 */
static int gm_isspace(char c)
{
	return c == ' ' || c == '\t' || c == '\n' || c == '\r' ||
	       c == '\f' || c == '\v';
}

static char gm_tolower(char c)
{
	return (c >= 'A' && c <= 'Z') ? (char)(c - 'A' + 'a') : c;
}

/* ---- id <-> name -------------------------------------------------------- */

/* Indexed by enum git_msg_id; order must match the enum in messages.h. */
static const char *const gitmsg_id_names[GIT_MSG_ID__COUNT] = {
	"git-required", "not-a-repo", "tree-not-clean", "detached-head",
	"nothing-staged", "message-required", "pathspec-required",
	"bad-argument", "unknown-command", "size-ceiling", "memory-bloat",
	"disk-space", "missing-file", "corruption", "overflow", "permission",
	"no-digest-tool", "resume-interrupted", "resume-halted",
	"resume-complete"
};

const char *gitmsg_id_name(enum git_msg_id id)
{
	if (id < 0 || id >= GIT_MSG_ID__COUNT)
		return "";
	return gitmsg_id_names[id];
}

int gitmsg_id_from_name(const char *name, enum git_msg_id *out)
{
	int i;

	if (!name || !out)
		return -1;
	for (i = 0; i < (int)GIT_MSG_ID__COUNT; i++)
		if (strcmp(name, gitmsg_id_names[i]) == 0) {
			*out = (enum git_msg_id)i;
			return 0;
		}
	return -1;
}

/* ---- small parsing helpers --------------------------------------------- */

static char *gitmsg_trim(char *s)
{
	char *end;

	while (*s && gm_isspace(*s))
		s++;
	if (!*s)
		return s;
	end = s + strlen(s) - 1;
	while (end > s && gm_isspace(*end))
		*end-- = '\0';
	return s;
}

static void gitmsg_lower(char *s)
{
	for (; *s; s++)
		*s = gm_tolower(*s);
}

/* Copy `src` into the arena; return a stable pointer or NULL if it won't fit. */
static const char *gitmsg_arena_dup(const char *src, char *arena,
				    size_t arena_sz, size_t *used)
{
	size_t len = strlen(src) + 1;
	char *dst;

	if (*used + len > arena_sz)
		return NULL;
	dst = arena + *used;
	memcpy(dst, src, len);
	*used += len;
	return dst;
}

/* Parse a severity/stream label. Return -1 on unknown. */
static int gitmsg_parse_severity(const char *v, enum git_msg_severity *out)
{
	if (!strcmp(v, "info"))    { *out = GIT_MSG_INFO;    return 0; }
	if (!strcmp(v, "note"))    { *out = GIT_MSG_NOTE;    return 0; }
	if (!strcmp(v, "warning")) { *out = GIT_MSG_WARNING; return 0; }
	if (!strcmp(v, "error"))   { *out = GIT_MSG_ERROR;   return 0; }
	if (!strcmp(v, "fatal"))   { *out = GIT_MSG_FATAL;   return 0; }
	return -1;
}

static int gitmsg_parse_stream(const char *v, enum git_msg_stream *out)
{
	if (!strcmp(v, "stdout")) { *out = GIT_MSG_STDOUT; return 0; }
	if (!strcmp(v, "stderr")) { *out = GIT_MSG_STDERR; return 0; }
	return -1;
}

/*
 * Parse one [MAP] value line into a rule. The value is the part after "MAP:",
 * of the form: [file=<s>] [func=<s>] [text=<s>] -> <message-id>
 * Selector values may contain spaces only if they precede the next key= or the
 * "->"; to keep it predictable and user-friendly, each selector runs to the
 * next whitespace, and text= may use the remainder up to "->" by quoting is
 * not required — the common case is a single token. Returns 0 on success.
 */
static int gitmsg_parse_map(char *val, struct gitmsg_rule *rule,
			    char *arena, size_t arena_sz, size_t *used)
{
	char *arrow = strstr(val, "->");
	char *lhs, *target;
	enum git_msg_id id;

	if (!arrow)
		return -1;
	*arrow = '\0';
	lhs = gitmsg_trim(val);
	target = gitmsg_trim(arrow + 2);
	if (gitmsg_id_from_name(target, &id) != 0)
		return -1;

	rule->file_substr = NULL;
	rule->func_substr = NULL;
	rule->text_substr = NULL;
	rule->id = id;

	/*
	 * Parse the selectors. `file=` and `func=` are single tokens (a file
	 * path or function name has no spaces). `text=` is the free-form,
	 * usually multi-word pattern (e.g. "No space left on device"), so it
	 * takes the whole remainder of the line — everything after "text=". To
	 * keep parsing predictable, text= must therefore be the LAST selector.
	 * (strtok is banned in the Git tree via banned.h, so we scan manually.)
	 */
	{
		char *p = lhs;
		while (*p) {
			char *key, *eq;

			while (*p == ' ' || *p == '\t')
				p++;
			if (!*p)
				break;

			key = p;
			eq = strchr(p, '=');
			if (!eq) /* stray token without '='; skip to next space */
				break;
			*eq = '\0';

			if (!strcmp(key, "text")) {
				/* Remainder of the line is the pattern. */
				char *rest = gitmsg_trim(eq + 1);
				const char *stored =
					gitmsg_arena_dup(rest, arena,
							 arena_sz, used);
				if (stored && *rest)
					rule->text_substr = stored;
				break; /* text= consumes the rest */
			} else {
				/* Single-token value for file=/func=. */
				char *val = eq + 1, *vend = val;
				const char *stored;
				while (*vend && *vend != ' ' && *vend != '\t')
					vend++;
				if (*vend)
					*vend++ = '\0';
				stored = gitmsg_arena_dup(val, arena,
							  arena_sz, used);
				if (stored && *val) {
					if (!strcmp(key, "file"))
						rule->file_substr = stored;
					else if (!strcmp(key, "func"))
						rule->func_substr = stored;
				}
				p = vend;
			}
		}
	}
	/* A rule with no usable selector matches everything, which is rarely
	 * intended; require at least one selector to be safe. */
	return (rule->file_substr || rule->func_substr || rule->text_substr)
		? 0 : -1;
}

/* ---- path resolution ---------------------------------------------------- */

const char *gitmsg_config_path(const char *repo_root)
{
	static char buf[4096];
	const char *env = getenv("GIT_MESSAGES_CONFIG");

	if (env && env[0])
		return env;
	if (repo_root && repo_root[0]) {
		int n = snprintf(buf, sizeof(buf), "%s/.gitmessages", repo_root);
		if (n > 0 && (size_t)n < sizeof(buf))
			return buf;
	}
	return NULL;
}

/* ---- the loader --------------------------------------------------------- */

int gitmsg_config_load(const char *path, struct gitmsg_config *cfg,
		       struct gitmsg_rule *rules_buf, size_t rules_cap,
		       char *arena, size_t arena_sz)
{
	FILE *f;
	char line[8192];
	size_t used = 0;
	enum { SEC_NONE, SEC_MESSAGE } section = SEC_NONE;
	enum git_msg_id cur_id = GIT_MSG_ID__COUNT;
	int have_cur = 0;

	if (!cfg)
		return -1;

	/* Always begin from the validated compiled defaults. */
	memset(cfg, 0, sizeof(*cfg));
	cfg->rules = rules_buf;
	cfg->rule_count = 0;
	cfg->catalog_count = git_msg_default_catalog(cfg->catalog,
						     GIT_MSG_ID__COUNT);
	cfg->loaded = 0;
	cfg->source_path = NULL;

	if (cfg->catalog_count != (size_t)GIT_MSG_ID__COUNT)
		return 0; /* defaults themselves unusable: pass-through */

	if (!path || !path[0])
		return 0; /* no config: compiled defaults are the result */

	f = fopen(path, "r");
	if (!f)
		return 0; /* unreadable: defaults */

	cfg->source_path = path;

	while (fgets(line, sizeof(line), f)) {
		char *s = gitmsg_trim(line);
		char *colon;

		if (!*s || *s == '#')
			continue;

		if (*s == '[') {
			/* Section header: [MESSAGE <id>] or [MAP] or other. */
			char *close = strchr(s, ']');
			char hdr[256];
			if (!close)
				continue;
			*close = '\0';
			snprintf(hdr, sizeof(hdr), "%s", s + 1);
			have_cur = 0;
			if (!strncmp(hdr, "MESSAGE ", 8)) {
				char *idname = gitmsg_trim(hdr + 8);
				gitmsg_lower(idname);
				section = SEC_MESSAGE;
				if (gitmsg_id_from_name(idname, &cur_id) == 0)
					have_cur = 1;
			} else if (!strcmp(hdr, "MAP")) {
				section = SEC_NONE; /* MAP lines are self-contained */
			} else {
				section = SEC_NONE;
			}
			continue;
		}

		/* A MAP: line can appear anywhere; handle it first. */
		if (!strncmp(s, "MAP:", 4) || !strncmp(s, "map:", 4)) {
			if (cfg->rule_count < rules_cap) {
				struct gitmsg_rule r;
				if (gitmsg_parse_map(s + 4, &r, arena,
						     arena_sz, &used) == 0) {
					rules_buf[cfg->rule_count++] = r;
				}
			}
			continue;
		}

		colon = strchr(s, ':');
		if (!colon)
			continue;
		*colon = '\0';
		{
			char *key = gitmsg_trim(s);
			char *val = gitmsg_trim(colon + 1);
			gitmsg_lower(key);

			if (section == SEC_MESSAGE && have_cur) {
				struct git_msg_entry *e = &cfg->catalog[cur_id];
				if (!strcmp(key, "text") && *val) {
					const char *stored =
						gitmsg_arena_dup(val, arena,
								 arena_sz, &used);
					if (stored)
						e->text = stored;
				} else if (!strcmp(key, "stream")) {
					enum git_msg_stream st;
					char lv[16];
					snprintf(lv, sizeof(lv), "%s", val);
					gitmsg_lower(lv);
					if (gitmsg_parse_stream(lv, &st) == 0)
						e->stream = st;
				} else if (!strcmp(key, "severity")) {
					enum git_msg_severity sv;
					char lv[16];
					snprintf(lv, sizeof(lv), "%s", val);
					gitmsg_lower(lv);
					if (gitmsg_parse_severity(lv, &sv) == 0)
						e->severity = sv;
				}
				/* concern is documented but not applied here */
			}
		}
	}
	fclose(f);

	/*
	 * Re-validate the overlaid catalog. If the overrides produced anything
	 * unsafe (e.g. an error/fatal routed to stdout, an emptied text), fall
	 * back to the compiled defaults entirely rather than emit them.
	 */
	if (git_msg_catalog_validate(cfg->catalog, GIT_MSG_ID__COUNT) != 0) {
		cfg->catalog_count = git_msg_default_catalog(cfg->catalog,
							     GIT_MSG_ID__COUNT);
		cfg->dropped_unsafe = 1;
		/* keep parsed rules only if the catalog is still the valid
		 * default set; rules reference ids, which are always valid */
	}

	cfg->loaded = 1;
	return 0;
}
