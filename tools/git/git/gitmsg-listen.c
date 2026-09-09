/*
 * Ubuntu Determinant tree-wide print listener — implementation.
 *
 * This translation unit defines GITMSG_LISTEN_IMPL *before* including the
 * listener header so the interposition macros are disabled here: the shims
 * below must be able to call the real libc printing functions.
 *
 * Behaviour of every shim:
 *   1. Capture the call site (file, function, line) and the target stream.
 *   2. Render the text the caller was about to print (vsnprintf into a bounded
 *      buffer; oversized output is handled by falling back to a direct pass).
 *   3. Ask the catalog to resolve the (stream, site, text) into a decision.
 *   4. Emit the decided message on its decided stream, or — the default —
 *      write the original bytes through unchanged.
 *
 * The default is pass-through, so Git's ordinary data output is preserved.
 * Only when the catalog's [MAP] section maps a site or pattern to a message id
 * does the listener substitute the catalogued wording/stream. A resolved
 * decision that would route an error/fatal message to stdout is refused (the
 * same invariant enforced in messages.c), so a diagnostic can never be hidden.
 */
#define GITMSG_LISTEN_IMPL 1

#include <stdio.h>
#include <stdarg.h>
#include <stddef.h>
#include <string.h>

#include "gitmsg-listen.h"
#include "messages.h"
#include "gitmsg-config.h"

/* ------------------------------------------------------------------------- *
 * Catalog + mapping state.
 *
 * The catalog (compiled defaults, optionally overlaid by a validated
 * .gitmessages) and the [MAP] rule table are loaded once — either explicitly
 * at startup via gitmsg_listen_init(), or lazily on the first intercepted
 * write. If loading fails at any point the listener runs in pure pass-through
 * mode: it never fails a write and never invents a message.
 * ------------------------------------------------------------------------- */

#define GITMSG_MAX_RULES 256
#define GITMSG_ARENA_SZ  (64 * 1024)

static struct gitmsg_config gitmsg_cfg;
static struct gitmsg_rule   gitmsg_rules[GITMSG_MAX_RULES];
static char                 gitmsg_arena[GITMSG_ARENA_SZ];
static size_t gitmsg_catalog_n;      /* 0 until loaded / usable          */
static int gitmsg_ready;             /* 1 once initialization has run    */

/*
 * Load (or reload) the catalog and [MAP] rules from `repo_root`'s .gitmessages
 * (or $GIT_MESSAGES_CONFIG). Safe to call more than once; a NULL/empty
 * repo_root and a missing file both yield the compiled defaults with no rules.
 * This is the explicit entry point installed at program startup.
 */
void gitmsg_listen_init(const char *repo_root)
{
	const char *path = gitmsg_config_path(repo_root);

	gitmsg_config_load(path, &gitmsg_cfg, gitmsg_rules, GITMSG_MAX_RULES,
			   gitmsg_arena, sizeof(gitmsg_arena));
	gitmsg_catalog_n = gitmsg_cfg.catalog_count;
	gitmsg_ready = 1;
}

/* Lazy fallback for shims that fire before an explicit init. */
static void gitmsg_init_once(void)
{
	if (gitmsg_ready)
		return;
	/* No repo context known here; resolve via env or compiled defaults. */
	gitmsg_listen_init(NULL);
}

static int gitmsg_str_contains(const char *hay, const char *needle)
{
	if (!needle || !needle[0])
		return 1;          /* empty pattern matches anything */
	return hay && strstr(hay, needle) != NULL;
}

/*
 * Resolve an intercepted write to a catalog entry, or NULL for pass-through.
 * Matching is by the loaded [MAP] rules on file/function/text substrings; the
 * first matching rule wins. A resolved entry whose severity is error/fatal but
 * whose stream is not stderr is refused (returns NULL -> the original bytes
 * pass through) so a diagnostic is never demoted onto stdout by a mapping.
 */
static const struct git_msg_entry *gitmsg_resolve(FILE *stream,
						  const char *file,
						  const char *func,
						  const char *text)
{
	size_t i;

	if (!gitmsg_catalog_n)
		return NULL;
	/* Only stdout/stderr are subject to message treatment. */
	if (stream != stdout && stream != stderr)
		return NULL;

	for (i = 0; i < gitmsg_cfg.rule_count; i++) {
		const struct gitmsg_rule *r = &gitmsg_rules[i];

		if (gitmsg_str_contains(file, r->file_substr) &&
		    gitmsg_str_contains(func, r->func_substr) &&
		    gitmsg_str_contains(text, r->text_substr)) {
			const struct git_msg_entry *e =
				git_msg_lookup(gitmsg_cfg.catalog,
					       gitmsg_catalog_n, r->id);
			if (!e)
				return NULL;
			if (e->severity >= GIT_MSG_ERROR &&
			    e->stream != GIT_MSG_STDERR)
				return NULL; /* refuse to hide a diagnostic */
			return e;
		}
	}
	return NULL;
}

/*
 * Public resolution helper for the diagnostic hook (gitmsg-diag.c): given a
 * severity and rendered text, return the catalogued entry a [MAP] rule selects,
 * or NULL to keep Git's own wording. `func`/`file` may be NULL (unknown site).
 */
const struct git_msg_entry *gitmsg_resolve_diag(const char *file,
						const char *func,
						const char *text)
{
	gitmsg_init_once();
	/* Diagnostics are stderr by nature; resolve against the stderr path. */
	return gitmsg_resolve(stderr, file, func, text);
}

/* Emit a resolved catalog entry on its configured stream. */
static int gitmsg_emit(const struct git_msg_entry *e)
{
	FILE *out = (e->stream == GIT_MSG_STDERR) ? stderr : stdout;
	int n = fprintf(out, "%s\n", e->text);
	return n < 0 ? -1 : n;
}

/*
 * Core path shared by the formatted shims: render the caller's text, try to
 * resolve it, then either emit the resolved message or write the original
 * text through unchanged. `render_ok` is 0 when the text could not be rendered
 * into the bounded buffer, in which case we always pass through.
 */
static int gitmsg_dispatch_text(FILE *stream, const char *file,
				const char *func, const char *text,
				int render_ok)
{
	const struct git_msg_entry *e;

	gitmsg_init_once();

	if (render_ok) {
		e = gitmsg_resolve(stream, file, func, text);
		if (e)
			return gitmsg_emit(e);
	}
	/* Pass-through: write exactly what the caller intended. */
	return fputs(text, stream);
}

/* ------------------------------------------------------------------------- *
 * Shims. Each renders into a bounded buffer; if the message is larger than the
 * buffer, we do not attempt catalog treatment and write directly instead, so
 * no output is ever truncated by the listener.
 * ------------------------------------------------------------------------- */

#define GITMSG_BUF 4096

int gitmsg_vfprintf(const char *file, const char *func, int line,
		    FILE *stream, const char *fmt, va_list ap)
{
	char buf[GITMSG_BUF];
	va_list ap2;
	int len;

	(void)line;
	va_copy(ap2, ap);
	len = vsnprintf(buf, sizeof(buf), fmt, ap2);
	va_end(ap2);

	if (len < 0 || (size_t)len >= sizeof(buf)) {
		/* Cannot inspect safely; write directly, untouched. */
		return vfprintf(stream, fmt, ap);
	}
	/* buf holds the fully rendered text; dispatch via the shared path. */
	if (gitmsg_dispatch_text(stream, file, func, buf, 1) < 0)
		return -1;
	return len;
}

int gitmsg_fprintf(const char *file, const char *func, int line,
		   FILE *stream, const char *fmt, ...)
{
	va_list ap;
	int r;

	va_start(ap, fmt);
	r = gitmsg_vfprintf(file, func, line, stream, fmt, ap);
	va_end(ap);
	return r;
}

int gitmsg_vprintf(const char *file, const char *func, int line,
		   const char *fmt, va_list ap)
{
	return gitmsg_vfprintf(file, func, line, stdout, fmt, ap);
}

int gitmsg_printf(const char *file, const char *func, int line,
		  const char *fmt, ...)
{
	va_list ap;
	int r;

	va_start(ap, fmt);
	r = gitmsg_vfprintf(file, func, line, stdout, fmt, ap);
	va_end(ap);
	return r;
}

int gitmsg_fputs(const char *file, const char *func, int line,
		 const char *s, FILE *stream)
{
	(void)line;
	return gitmsg_dispatch_text(stream, file, func, s ? s : "", 1);
}

int gitmsg_puts(const char *file, const char *func, int line, const char *s)
{
	int r;

	(void)line;
	gitmsg_init_once();
	/* puts() appends a newline; preserve that on pass-through. */
	{
		const struct git_msg_entry *e =
			gitmsg_resolve(stdout, file, func, s ? s : "");
		if (e)
			return gitmsg_emit(e);
	}
	r = fputs(s ? s : "", stdout);
	if (r < 0)
		return EOF;
	if (fputc('\n', stdout) == EOF)
		return EOF;
	return r;
}

/*
 * Single-character and raw-byte writers carry no message text to inspect, so
 * they always pass straight through. They are interposed only so the macro set
 * is complete and consistent; capturing their site is reserved for future use.
 */
int gitmsg_fputc(const char *file, const char *func, int line,
		 int c, FILE *stream)
{
	(void)file; (void)func; (void)line;
	return fputc(c, stream);
}

int gitmsg_putchar(const char *file, const char *func, int line, int c)
{
	(void)file; (void)func; (void)line;
	return fputc(c, stdout);
}

size_t gitmsg_fwrite(const char *file, const char *func, int line,
		     const void *ptr, size_t size, size_t nmemb, FILE *stream)
{
	(void)file; (void)func; (void)line;
	return fwrite(ptr, size, nmemb, stream);
}
