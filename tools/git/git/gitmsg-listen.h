/*
 * Ubuntu Determinant tree-wide print listener (interposition layer).
 *
 * Goal: every stdout/stderr *print* in the Edition Git passes through a single
 * listener so that, at the moment output is about to be written, we know the
 * call site (file, function, line) and the target stream, and the message
 * catalog (see messages.h / MESSAGES.md / .gitmessages) gets to decide what the
 * real message is before it is emitted.
 *
 * How it is applied. This header is *force-included* into every translation
 * unit of the vendored Git tree (the build passes `-include gitmsg-listen.h`),
 * rather than edited into each of the ~300 files by hand. It redefines the C
 * output primitives as macros that capture __FILE__/__func__/__LINE__ and the
 * destination stream and forward to the listener shims in gitmsg-listen.c.
 *
 * IMPORTANT — this is opt-in and pass-through by default:
 *   - It only takes effect when GITMSG_LISTEN is defined by the build; without
 *     it the header is inert, so an ordinary build is unchanged.
 *   - The listener's DEFAULT action is to write the bytes through verbatim.
 *     Git's data output (git log / diff / cat-file / the pack protocol on
 *     stdout) is therefore NOT altered unless the catalog's [MAP] section
 *     explicitly maps a call site or pattern to a catalog message. This layer
 *     observes and, only where told, re-words/re-streams — it never silently
 *     rewrites Git's payload output.
 *   - The listener translation unit itself defines GITMSG_LISTEN_IMPL before
 *     including this header, which disables the macros there so the shims can
 *     call the real libc functions.
 *
 * What it deliberately does NOT touch:
 *   - the banned string helpers in banned.h (sprintf/vsprintf/...): those are
 *     poisoned there and are none of our business here;
 *   - trace/log-file writers and other non-stdout/stderr sinks: deferred by
 *     request (log files can wait). Only stdout/stderr print primitives are
 *     interposed.
 *
 * The header is C and C++ clean, matching the other native modules.
 */
#ifndef GIT_MSG_LISTEN_H
#define GIT_MSG_LISTEN_H

#include <stdio.h>
#include <stdarg.h>
#include <stddef.h>

#ifdef __cplusplus
extern "C" {
#endif

/*
 * Listener shims. Each receives the originating call site (file, function,
 * line) and writes to the given stream after consulting the catalog. They
 * return the same value contract as the libc function they stand in for, so
 * callers that check the return value keep working.
 *
 * `stream` is the FILE* the caller targeted (stdout, stderr, or any other
 * FILE*); the shim only applies message treatment to stdout/stderr and passes
 * every other stream straight through.
 */
int gitmsg_fprintf(const char *file, const char *func, int line,
		   FILE *stream, const char *fmt, ...);
int gitmsg_vfprintf(const char *file, const char *func, int line,
		    FILE *stream, const char *fmt, va_list ap);
int gitmsg_printf(const char *file, const char *func, int line,
		  const char *fmt, ...);
int gitmsg_vprintf(const char *file, const char *func, int line,
		   const char *fmt, va_list ap);
int gitmsg_fputs(const char *file, const char *func, int line,
		 const char *s, FILE *stream);
int gitmsg_puts(const char *file, const char *func, int line, const char *s);
int gitmsg_fputc(const char *file, const char *func, int line,
		 int c, FILE *stream);
int gitmsg_putchar(const char *file, const char *func, int line, int c);
size_t gitmsg_fwrite(const char *file, const char *func, int line,
		     const void *ptr, size_t size, size_t nmemb, FILE *stream);

/*
 * Load (or reload) the message catalog and [MAP] rules for the listener from
 * `repo_root`'s .gitmessages (or $GIT_MESSAGES_CONFIG). Install this once at
 * program startup; a NULL repo_root and a missing file both yield the compiled
 * defaults with no rules (pure pass-through). Safe to call more than once.
 */
void gitmsg_listen_init(const char *repo_root);

/*
 * Resolve a structured diagnostic (from the die/error/warning hook) to a
 * catalogued entry a [MAP] rule selects, or NULL to keep Git's own wording.
 * Forward-declared struct so callers need not include messages.h.
 */
struct git_msg_entry;
const struct git_msg_entry *gitmsg_resolve_diag(const char *file,
						const char *func,
						const char *text);

/*
 * Install the die/error/warning diagnostic hook (implemented in gitmsg-diag.c)
 * so structured diagnostics resolve through the catalog too. Call once, early
 * in startup, after gitmsg_listen_init(). Requires Git's usage.c routines and
 * so links only into the full binary, not the standalone policy archive.
 */
void gitmsg_diag_install(void);

#ifdef __cplusplus
}
#endif

/*
 * The interposition macros. Active only when the build requests the listener
 * (GITMSG_LISTEN) and only outside the listener's own implementation
 * (GITMSG_LISTEN_IMPL). We #undef first so a force-include after <stdio.h> is
 * well defined.
 *
 * __func__ is a C99/C++11 predefined identifier (not a macro), so it is valid
 * in every function body; at file scope no print primitive is called, so the
 * macros are only expanded where __func__ exists.
 */
#if defined(GITMSG_LISTEN) && !defined(GITMSG_LISTEN_IMPL)

#undef fprintf
#define fprintf(stream, ...) \
	gitmsg_fprintf(__FILE__, __func__, __LINE__, (stream), __VA_ARGS__)

#undef vfprintf
#define vfprintf(stream, fmt, ap) \
	gitmsg_vfprintf(__FILE__, __func__, __LINE__, (stream), (fmt), (ap))

#undef printf
#define printf(...) \
	gitmsg_printf(__FILE__, __func__, __LINE__, __VA_ARGS__)

#undef vprintf
#define vprintf(fmt, ap) \
	gitmsg_vprintf(__FILE__, __func__, __LINE__, (fmt), (ap))

#undef fputs
#define fputs(s, stream) \
	gitmsg_fputs(__FILE__, __func__, __LINE__, (s), (stream))

#undef puts
#define puts(s) \
	gitmsg_puts(__FILE__, __func__, __LINE__, (s))

#undef fputc
#define fputc(c, stream) \
	gitmsg_fputc(__FILE__, __func__, __LINE__, (c), (stream))

#undef putc
#define putc(c, stream) \
	gitmsg_fputc(__FILE__, __func__, __LINE__, (c), (stream))

#undef putchar
#define putchar(c) \
	gitmsg_putchar(__FILE__, __func__, __LINE__, (c))

#undef fwrite
#define fwrite(ptr, size, nmemb, stream) \
	gitmsg_fwrite(__FILE__, __func__, __LINE__, (ptr), (size), (nmemb), (stream))

#endif /* GITMSG_LISTEN && !GITMSG_LISTEN_IMPL */

#endif /* GIT_MSG_LISTEN_H */
