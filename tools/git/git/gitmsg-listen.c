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

/* ------------------------------------------------------------------------- *
 * Catalog + mapping state.
 *
 * The catalog (compiled defaults, optionally overlaid by a validated config)
 * and the site/pattern -> message-id map are loaded once, lazily, on the first
 * intercepted write. If loading or validation fails, the listener runs in pure
 * pass-through mode: it never fails a write and never invents a message.
 * ------------------------------------------------------------------------- */

struct gitmsg_map_rule {
	const char *file_substr;    /* match when call-site file contains this  */
	const char *func_substr;    /* match when call-site function contains it */
	const char *text_substr;    /* match when rendered text contains this    */
	enum git_msg_id id;         /* catalog message to emit on a match        */
};

/*
 * Built-in default map: intentionally EMPTY. With no rules, every intercepted
 * write is passed through verbatim — the safe default. Real deployments add
 * rules through the config's [MAP] section (loaded by the C config loader),
 * which appends to this table at startup. Keeping the compiled default empty
 * guarantees that merely enabling the listener changes no output.
 */
static const struct gitmsg_map_rule gitmsg_default_map[] = {
	{ NULL, NULL, NULL, GIT_MSG_ID__COUNT } /* sentinel; zero real rules */
};

static struct git_msg_entry gitmsg_catalog[GIT_MSG_ID__COUNT];
static size_t gitmsg_catalog_n;      /* 0 until loaded / usable          */
static int gitmsg_ready;             /* 1 once initialization has run    */

/*
 * One-time initialization. Loads the compiled default catalog and validates
 * it; a future C config loader (see MESSAGES.md) may overlay .gitmessages here
 * and re-validate. On any failure gitmsg_catalog_n stays 0 -> pass-through.
 */
static void gitmsg_init_once(void)
{
	if (gitmsg_ready)
		return;
	gitmsg_ready = 1;

	if (git_msg_default_catalog(gitmsg_catalog, GIT_MSG_ID__COUNT)
	    == (size_t)GIT_MSG_ID__COUNT &&
	    git_msg_catalog_validate(gitmsg_catalog, GIT_MSG_ID__COUNT) == 0)
		gitmsg_catalog_n = GIT_MSG_ID__COUNT;
	else
		gitmsg_catalog_n = 0; /* unusable -> pass-through */
}

static int gitmsg_str_contains(const char *hay, const char *needle)
{
	if (!needle || !needle[0])
		return 1;          /* empty pattern matches anything */
	return hay && strstr(hay, needle) != NULL;
}

/*
 * Resolve an intercepted write to a catalog entry, or NULL for pass-through.
 * Matching is by the [MAP] rules on file/function/text substrings. A resolved
 * entry whose severity is error/fatal but whose stream is not stderr is refused
 * (returns NULL -> the original bytes pass through) so a diagnostic is never
 * demoted onto stdout by a mapping.
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

	for (i = 0; gitmsg_default_map[i].id != GIT_MSG_ID__COUNT; i++) {
		const struct gitmsg_map_rule *r = &gitmsg_default_map[i];

		if (gitmsg_str_contains(file, r->file_substr) &&
		    gitmsg_str_contains(func, r->func_substr) &&
		    gitmsg_str_contains(text, r->text_substr)) {
			const struct git_msg_entry *e =
				git_msg_lookup(gitmsg_catalog,
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
