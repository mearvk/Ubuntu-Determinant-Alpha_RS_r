/*
 * Ubuntu Determinant structured-diagnostic hook.
 *
 * Git funnels essentially all of its diagnostics through a small set of
 * pluggable routines in usage.c: die(), error(), and warning() call, via
 * function pointers, into die_routine / error_routine / warn_routine. This
 * module installs replacements for those routines so that structured
 * diagnostics also pass through the message catalog: the text Git was about to
 * print is rendered, offered to the catalog's [MAP] rules, and — only when a
 * rule matches — replaced by the catalogued wording. Otherwise Git's original
 * behaviour and wording are preserved exactly.
 *
 * This complements the tree-wide print listener (gitmsg-listen.*), which
 * catches raw printf/fprintf output. Together they route both raw prints and
 * structured diagnostics through one catalog.
 *
 * Contracts preserved:
 *   - die()    must not return and must exit(128); our die route emits, then
 *              exits 128, matching die_builtin.
 *   - error()  returns -1; warning() returns void. We keep those by delegating
 *              the return path to the saved builtin routines when we do not
 *              substitute, and by exiting/returning appropriately when we do.
 *   - a [MAP] target that is an error/fatal message is never routed to stdout
 *     (enforced in gitmsg_resolve_diag): diagnostics always go to stderr here.
 *
 * The module is installed once from cmd_main() via gitmsg_diag_install().
 */
#define GITMSG_LISTEN_IMPL 1

#include "git-compat-util.h"
#include "messages.h"
#include "gitmsg-listen.h"

/* Saved originals so we can fall back to Git's exact behaviour/wording. */
static report_fn gitmsg_saved_error;
static report_fn gitmsg_saved_warn;

/*
 * Render (fmt,params) into buf. Uses a va_copy so the caller's list is not
 * consumed (some callers walk it again). Returns 0 on success.
 */
static int gitmsg_render(char *buf, size_t sz, const char *fmt, va_list params)
{
	va_list cp;
	int n;

	va_copy(cp, params);
	n = vsnprintf(buf, sz, fmt, cp);
	va_end(cp);
	return (n < 0 || (size_t)n >= sz) ? -1 : 0;
}

/*
 * die route: emit a catalogued substitution if one matches, then exit 128 to
 * honour die()'s contract; otherwise print with Git's own "fatal: " prefix and
 * exit 128, matching die_builtin/vreportf.
 */
static NORETURN void gitmsg_die_route(const char *err, va_list params)
{
	char buf[4096];

	if (gitmsg_render(buf, sizeof(buf), err, params) == 0) {
		const struct git_msg_entry *e =
			gitmsg_resolve_diag(NULL, NULL, buf);
		if (e) {
			fprintf(stderr, "%s\n", e->text);
			exit(128);
		}
		/* No substitution: preserve Git's fatal wording verbatim. */
		fprintf(stderr, "fatal: %s\n", buf);
		exit(128);
	}
	/* Could not render: fall back to a plain fatal line. */
	fprintf(stderr, "fatal: (message unavailable)\n");
	exit(128);
}

static void gitmsg_error_route(const char *err, va_list params)
{
	char buf[4096];

	if (gitmsg_render(buf, sizeof(buf), err, params) == 0) {
		const struct git_msg_entry *e =
			gitmsg_resolve_diag(NULL, NULL, buf);
		if (e) {
			fprintf(stderr, "%s\n", e->text);
			return;
		}
	}
	/* No substitution / render failure: defer to Git's original routine so
	 * wording, prefix, and trace2 behaviour are exactly preserved. */
	if (gitmsg_saved_error)
		gitmsg_saved_error(err, params);
}

static void gitmsg_warn_route(const char *warn, va_list params)
{
	char buf[4096];

	if (gitmsg_render(buf, sizeof(buf), warn, params) == 0) {
		const struct git_msg_entry *e =
			gitmsg_resolve_diag(NULL, NULL, buf);
		if (e) {
			fprintf(stderr, "%s\n", e->text);
			return;
		}
	}
	if (gitmsg_saved_warn)
		gitmsg_saved_warn(warn, params);
}

/*
 * Install the diagnostic hook. Call once, early in cmd_main(), after the
 * listener catalog has been initialized (gitmsg_listen_init). Saves the
 * existing error/warn routines for fall-through. die is replaced outright since
 * it never returns.
 */
void gitmsg_diag_install(void)
{
	gitmsg_saved_error = get_error_routine();
	gitmsg_saved_warn = get_warn_routine();

	set_die_routine(gitmsg_die_route);
	set_error_routine(gitmsg_error_route);
	set_warn_routine(gitmsg_warn_route);
}
