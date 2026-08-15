/* $MirOS: src/gnu/usr.bin/cvs/lib/error.h,v 1.2 2021/01/30 02:06:03 tg Exp $ */
/* Declaration for error-reporting function
   Copyright (C) 1995, 1996, 1997, 2003 Free Software Foundation, Inc.
   Copyright (c) 2021 mirabilos <m@mirbsd.org>
   This file is part of GNU CVS.

   This program is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 2, or (at your option)
   any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License along
   with this program; if not, write to the Free Software Foundation,
   Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.  */

#ifndef _ERROR_H
#define _ERROR_H 1

/* for exit(3) */
#include <stdlib.h>

#ifndef __attribute__
/* This feature is available in gcc versions 2.5 and later.  */
# if __GNUC__ < 2 || (__GNUC__ == 2 && __GNUC_MINOR__ < 5)
#  define __attribute__(Spec) /* empty */
# endif
/* The __-protected variants of `format' and `printf' attributes
   are accepted by gcc versions 2.6.4 (effectively 2.7) and later.  */
# if __GNUC__ < 2 || (__GNUC__ == 2 && __GNUC_MINOR__ < 7)
#  define __format__ format
#  define __printf__ printf
# endif
#endif

#ifdef	__cplusplus
extern "C" {
#endif

/* Print a message with `fprintf (stderr, FORMAT, ...)';
   if ERRNUM is nonzero, follow it with ": " and strerror (ERRNUM).
   If STATUS is nonzero, terminate the program with `exit (STATUS)'.  */

/* changed for CVS: if STATUS is nonzero, use EXIT_FAILURE */

#if 0
#define error(status,...) do {			\
	int CVS_error_st = (status);		\
						\
	warning(__VA_ARGS__);			\
	if (CVS_error_st)			\
		exit(CVS_error_st);		\
} while (/* CONSTCOND */ 0)

extern void warning (int __errnum, const char *__format, ...)
     __attribute__ ((__format__ (__printf__, 2, 3)));

#else /* ↑ lib │ ↓ CVS */

#define error(...) do {				\
	if (warning(__VA_ARGS__))		\
		exit(EXIT_FAILURE);		\
} while (/* CONSTCOND */ 0)

extern int warning(int status, int errnum, const char *message, ...)
    __attribute__((__format__(__printf__, 3, 4)));
#endif

#define error_at_line(status,...) do {		\
	int CVS_error_st = (status);		\
						\
	warning_at_line(__VA_ARGS__);		\
	if (CVS_error_st)			\
		exit(CVS_error_st);		\
} while (/* CONSTCOND */ 0)

extern void warning_at_line (int __errnum, const char *__fname,
			   unsigned int __lineno, const char *__format, ...)
     __attribute__ ((__format__ (__printf__, 4, 5)));

/*XXX this calls for some trickery with __builtin_constant_p
      to eliminate the if, if not the exit, but let’s just
      rely on the optimiser for constant arguments; this API sucks */

/* If NULL, error will flush stdout, then print on stderr the program
   name, a colon and a space.  Otherwise, error will call this
   function without parameters instead.  */
extern void (*error_print_progname) (void);

/* This variable is incremented each time `error' is called.  */
extern unsigned int error_message_count;

/* Sometimes we want to have at most one error per line.  This
   variable controls whether this mode is selected or not.  */
extern int error_one_per_line;

#ifdef	__cplusplus
}
#endif

#endif /* error.h */
