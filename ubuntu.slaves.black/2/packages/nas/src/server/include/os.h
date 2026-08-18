/***********************************************************
Copyright 1987 by Digital Equipment Corporation, Maynard, Massachusetts,
and the Massachusetts Institute of Technology, Cambridge, Massachusetts.

                        All Rights Reserved

Permission to use, copy, modify, and distribute this software and its 
documentation for any purpose and without fee is hereby granted, 
provided that the above copyright notice appear in all copies and that
both that copyright notice and this permission notice appear in 
supporting documentation, and that the names of Digital or MIT not be
used in advertising or publicity pertaining to distribution of the
software without specific, written prior permission.  

DIGITAL DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING
ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS, IN NO EVENT SHALL
DIGITAL BE LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR
ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION,
ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS
SOFTWARE.

******************************************************************/

/* $XConsortium: os.h,v 1.48 92/10/20 09:27:53 rws Exp $ */

#ifndef OS_H
#define OS_H
#include "misc.h"

#ifdef INCLUDE_ALLOCA_H
#include <alloca.h>
#endif

#ifndef MAX_REQUEST_SIZE
#define MAX_REQUEST_SIZE 65535
#endif
#ifndef MAX_BIG_REQUEST_SIZE
#define MAX_BIG_REQUEST_SIZE 1048575
#endif

#ifndef NO_ALLOCA
/*
 * os-dependent definition of local allocation and deallocation
 * If you want something other than Xalloc/Xfree for ALLOCATE/DEALLOCATE
 * LOCAL then you add that in here.
 */
#ifdef __HIGHC__

extern char *alloca();

#if HCVERSION < 21003
#define ALLOCATE_LOCAL(size)    alloca((int)(size))
#pragma on(alloca);
#else /* HCVERSION >= 21003 */
#define ALLOCATE_LOCAL(size)    _Alloca((int)(size))
#endif /* HCVERSION < 21003 */

#define DEALLOCATE_LOCAL(ptr)   /* as nothing */

#endif /* defined(__HIGHC__) */


#if defined(__GNUC__) && !defined(alloca)
#define alloca __builtin_alloca
#endif

/*
 * warning: old mips alloca (pre 2.10) is unusable, new one is builtin
 * Test is easy, the new one is named __builtin_alloca and comes
 * from alloca.h which #defines alloca.
 */
#if defined(vax) || defined(sun) || defined(apollo) || defined(stellar) || defined(alloca)
/*
 * Some System V boxes extract alloca.o from /lib/libPW.a; if you
 * decide that you don't want to use alloca, you might want to fix 
 * ../os/4.2bsd/Imakefile
 */
#ifndef alloca
char *alloca();
#endif
#ifdef DEBUG_ALLOCA
extern char *debug_alloca();
extern void debug_dealloca();
#define ALLOCATE_LOCAL(size) debug_alloca(__FILE__,__LINE__,(int)(size))
#define DEALLOCATE_LOCAL(ptr) debug_dealloca(__FILE__,__LINE__,(ptr))
#else
#define ALLOCATE_LOCAL(size) alloca((int)(size))
#define DEALLOCATE_LOCAL(ptr)   /* as nothing */
#endif
#endif /* who does alloca */

#endif /* NO_ALLOCA */

#ifdef CAHILL_MALLOC
#define Xalloc(len)             debug_Xalloc(__FILE__,__LINE__,(len))
#define Xcalloc(len)            debug_Xcalloc(__FILE__,__LINE__,(len))
#define Xrealloc(ptr,len)       debug_Xrealloc(__FILE__,__LINE__,(ptr),(len))
#define Xfree(ptr)              debug_Xfree(__FILE__,__LINE__,(ptr))
#endif

#ifndef ALLOCATE_LOCAL
#define ALLOCATE_LOCAL(size) Xalloc((size))
#define DEALLOCATE_LOCAL(ptr) Xfree((pointer)(ptr))
#endif /* ALLOCATE_LOCAL */


#ifndef sgi
#define xalloc(size) Xalloc(((size)))
#define xrealloc(ptr, size) Xrealloc(((pointer)(ptr)), ((size)))
#define xfree(ptr) Xfree(((pointer)(ptr)))
#else /* sgi */
extern void *safe_alloc(size_t size);
extern void *safe_realloc(void *ptr, size_t size);
extern void safe_free(void *ptr);

#define xalloc(size) safe_alloc((size))
#define xrealloc(ptr, size) \
        safe_realloc(((pointer)(ptr)), (size))
#define xfree(ptr) safe_free(((pointer)(ptr)))
#endif /* sgi */

#ifndef X_NOT_STDC_ENV
#include <string.h>
#else
#ifdef SYSV
#include <string.h>
#else
#include <strings.h>
#endif
#endif

int ReadRequestFromClient();
void CloseDownConnection();
void CreateWellKnownSockets();
void ErrorF();
void Error();
void FatalError();
void ProcessCommandLine();
char *FindConfigFile();
void FlushAllOutput();
void FlushIfCriticalOutputPending();
#ifndef CAHILL_MALLOC
void Xfree(pointer ptr);
void *Xalloc(unsigned long size);
void *Xcalloc(unsigned long amount);
void *Xrealloc(pointer ptr, unsigned long amount);
#else
void debug_Xfree(char *file, int line, pointer ptr);
void *debug_Xalloc(char *file, int line, unsigned long amount);
void *debug_Xcalloc(char *file, int line, unsigned long amount);
void *debug_Xrealloc(char *file, int line, pointer ptr,
                     unsigned long amount);
#endif
long GetTimeInMillis();

#endif /* OS_H */
