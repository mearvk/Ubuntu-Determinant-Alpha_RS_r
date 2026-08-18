/*
 * Copyright 1993 Network Computing Devices, Inc.
 *
 * Permission to use, copy, modify, distribute, and sell this software and
 * its documentation for any purpose is hereby granted without fee, provided
 * that the above copyright notice appear in all copies and that both that
 * copyright notice and this permission notice appear in supporting
 * documentation, and that the name Network Computing Devices, Inc. not be
 * used in advertising or publicity pertaining to distribution of this 
 * software without specific, written prior permission.
 * 
 * THIS SOFTWARE IS PROVIDED `AS-IS'.  NETWORK COMPUTING DEVICES, INC.,
 * DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING WITHOUT
 * LIMITATION ALL IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 * PARTICULAR PURPOSE, OR NONINFRINGEMENT.  IN NO EVENT SHALL NETWORK
 * COMPUTING DEVICES, INC., BE LIABLE FOR ANY DAMAGES WHATSOEVER, INCLUDING
 * SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES, INCLUDING LOSS OF USE, DATA,
 * OR PROFITS, EVEN IF ADVISED OF THE POSSIBILITY THEREOF, AND REGARDLESS OF
 * WHETHER IN AN ACTION IN CONTRACT, TORT OR NEGLIGENCE, ARISING OUT OF OR IN
 * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 * 
 * $Id: utils.c 287 2013-08-09 17:19:13Z auerswald $
 * $NCDId: @(#)utils.c,v 1.8 1996/04/24 17:16:15 greg Exp $
 */
/***********************************************************
Some portions derived from:

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

#include <audio/audio.h>
#include <audio/Aos.h>
#include <audio/Aproto.h>
#include <errno.h>
#include <limits.h>
#include <stdio.h>
#include <stdlib.h>
#include "nasconf.h"
#include "misc.h"
#include "opaque.h"
#include "audio/release.h"
#include <signal.h>
#if !defined(SYSV) && !defined(AMOEBA) && !defined(_MINIX)
#include <sys/resource.h>
#endif
#include <time.h>

#ifdef AMOEBA
#include "osdep.h"
#include <amoeba.h>
#include <module/mutex.h>
#endif

#ifdef SIGNALRETURNSINT
#define SIGVAL int
#else
#define SIGVAL void
#endif

#if defined(SYSV) || defined(SVR4)
#ifdef hpux
#define signal  _local_signal
#define sigset  _local_signal

#ifndef NeedFunctionPrototypes
static void (*_local_signal(sig, action)) ()
int sig;
void (*action) ();
#else /* NeedFunctionPrototypes */
static void (*_local_signal(int sig, void (*action) (int))) (int)
#endif                          /* NeedFunctionPrototypes */
{
    struct sigvec vec;
    struct sigvec ovec;

    vec.sv_handler = action;
    vec.sv_flags = 0;
    sigvector(sig, &vec, &ovec);

    return (ovec.sv_handler);
}
#else
#define signal sigset
#endif
#endif

extern char *display;

#ifndef AMOEBA
extern Bool PartialNetwork;
#endif

Bool CoreDump;
Bool noTestExtensions;

#ifdef STARTSERVER
int timeoutWithNoClients = 0;
#endif /* STARTSERVER */

int auditTrailLevel = 1;

#ifdef AMOEBA
static mutex print_lock
#endif
void ddxUseMsg(void);

#if defined(SVR4) || defined(hpux) || defined(linux) || defined(AMOEBA) || defined(_MINIX)
#include <unistd.h>
#endif

#ifdef DEBUG
#ifndef SPECIAL_MALLOC
/*#define MEMBUG - This breaks things with unknown CheckMemory call */
#endif
#endif

#ifdef MEMBUG
#define MEM_FAIL_SCALE 100000
long Memory_fail = 0;

#endif

#ifdef sgi
int userdefinedfontpath = 0;
#endif /* sgi */

Bool Must_have_memory = FALSE;

char *dev_tty_from_init = NULL; /* since we need to parse it anyway */

/* Force connections to close on SIGHUP from init */

 /*ARGSUSED*/ SIGVAL
AutoResetServer(int sig)
{
    dispatchException |= DE_RESET;
    isItTimeToYield = TRUE;
#ifdef GPROF
    chdir("/tmp");
    exit(0);
#endif
#if defined(USG) || defined(SYSV) || defined(SVR4) || defined(linux) || defined(_MINIX)
    signal(SIGHUP, AutoResetServer);
#endif
#ifdef AMOEBA
    WakeUpMainThread();
#endif
}

/* Force connections to close and then exit on SIGTERM, SIGINT */

 /*ARGSUSED*/ SIGVAL
GiveUp(int sig)
{

#if defined(SYSV) || defined(SVR4) || defined(linux) || defined(_MINIX)
    /*
     * Don't let any additional occurances of thses signals cause
     * premature termination
     */
    signal(SIGTERM, SIG_IGN);
    signal(SIGINT, SIG_IGN);
#endif

    dispatchException |= DE_TERMINATE;
    isItTimeToYield = TRUE;
#ifdef AMOEBA
    WakeUpMainThread();
#endif
}


static void
AbortServer(void)
{
    fflush(stderr);
    if (CoreDump) {
#ifdef AMOEBA
        IOPCleanUp();
#endif
        abort();
    }
    exit(1);
}

void
Error(char *str)
{
#ifdef AMOEBA
    mu_lock(&print_lock);
#endif
    perror(str);
#ifdef AMOEBA
    mu_unlock(&print_lock);
#endif
}

#ifndef DDXTIME
#ifndef AMOEBA
long
GetTimeInMillis(void)
{
    struct timeval tp;

    gettimeofday(&tp, 0);
    return (tp.tv_sec * 1000) + (tp.tv_usec / 1000);
}
#else
long
GetTimeInMillis(void)
{
    return sys_milli();
}
#endif /* AMOEBA */
#endif

void
UseMsg(void)
{
    ErrorF("Usage: nasd [:<listen port offset>] [option]\n");
    ErrorF(" -aa                allow any client to connect\n");
    ErrorF(" -local             allow local clients only\n");
    ErrorF(" -b                 detach and run in background\n");
    ErrorF(" -v                 enable verbose messages\n");
    ErrorF(" -d <num>           enable debug messages at level <num>\n");
    ErrorF(" -config <file>     use <file> as the nasd config file\n");
    ErrorF(" -V                 print version and exit (ignores other opts)\n");
#ifndef AMOEBA
#ifdef PART_NET
    ErrorF(" -pn                partial networking enabled [default]\n");
    ErrorF(" -nopn              partial networking disabled\n");
#else
    ErrorF(" -pn                partial networking enabled\n");
    ErrorF(" -nopn              partial networking disabled [default]\n");
#endif
#endif
    ddaUseMsg();                /* print dda specific usage */
}

/* 
 * This function parses the command line to check if a non-default
 * config file has been specified. This needs to be separate from the
 * normal command-line processing below because we _only_ want to grab
 * the config file name. Other options need to be read from the config
 * file and (potentially) overridden by command-line options later.
 */
char *
FindConfigFile(int argc, char *argv[])
{
    int i;

    for (i = 1; i < argc; i++) {
        if (strcmp(argv[i], "-config") == 0) {
            i++;
            if (i < argc)
                return argv[i];
            else {
                UseMsg();
                exit(1);
            }
        }
    }
    return NULL;                /* Not found */
}


/*
 * This function parses the command line. Handles device-independent fields
 * and allows ddx to handle additional fields.  It is not allowed to modify
 * argc or any of the strings pointed to by argv.
 */
void
ProcessCommandLine(int argc, char *argv[])
{
    int i;
#ifndef AMOEBA
#ifdef PART_NET
    PartialNetwork = TRUE;
#endif
#endif

    for (i = 1; i < argc; i++) {
        if (argv[i][0] == ':') {
            char *check;
            long display_value;
            errno = 0;
            display_value = strtol(argv[i]+1, &check, 10);
            if (errno) {
                Error("Unable to parse display number");
                continue;
            }
            if (check[0] != '\0') {
                fprintf(stderr, "Listen port offset must be a number.\n");
                continue;
            }
            if (display_value > USHRT_MAX - AU_DEFAULT_TCP_PORT) {
                fprintf(stderr, "Ignoring too big listen port offset.\n");
                continue;
            }
            if (display_value < 0) {
                fprintf(stderr, "Ignoring negative listen port offset.\n");
                continue;
            }
            display = argv[i];
            display++;
        } else if (strcmp(argv[i], "-aa") == 0)
            NasConfig.AllowAny = TRUE;
#ifdef STARTSERVER
        else if (strcmp(argv[i], "-timeout") == 0) {
            i++;
            if (i < argc)
                timeoutWithNoClients = atoi(argv[i]);
            else {
                UseMsg();
                exit(1);
            }
        }
#endif /* STARTSERVER */
#ifndef AMOEBA
        else if (strcmp(argv[i], "-pn") == 0)
            PartialNetwork = TRUE;
        else if (strcmp(argv[i], "-nopn") == 0)
            PartialNetwork = FALSE;
#endif
        else if (strcmp(argv[i], "-v") == 0) {
            NasConfig.DoVerbose = TRUE;
        } else if (strcmp(argv[i], "-config") == 0) {
            i++;
            if (i < argc)
                i++;
            else {
                UseMsg();
                exit(1);
            }
        } else if (strcmp(argv[i], "-b") == 0) {
            NasConfig.DoDaemon = TRUE;
        } else if (strcmp(argv[i], "-V") == 0) {        /* print version and exit */
            printf("%s\n", release);
            exit(0);
        } else if (strcmp(argv[i], "-d") == 0) {
            i++;
            if (i < argc)
                NasConfig.DoDebug = atoi(argv[i]);
            else {
                UseMsg();
                exit(1);
            }
        } else if (strcmp(argv[i], "-local") == 0) {
            NasConfig.LocalOnly = TRUE;
        } else {
            /* see if the dda understands it.
               we pass (in addition to argc/argv
               an index to the current arg
               being processed.  If the arg is
               processed, i is set to the last arg
               processed (in the event of an option
               that takes an arguement */
            if (ddaProcessArg(&i, argc, argv)) {        /* returns non-zero for an unidentified
                                                           arg */
                UseMsg();       /* this will call ddaUseMsg() */
                exit(1);
            }
        }
    }
}

/* XALLOC -- X's internal memory allocator.  Why does it return unsigned
 * int * instead of the more common char *?  Well, if you read K&R you'll
 * see they say that alloc must return a pointer "suitable for conversion"
 * to whatever type you really want.  In a full-blown generic allocator
 * there's no way to solve the alignment problems without potentially
 * wasting lots of space.  But we have a more limited problem. We know
 * we're only ever returning pointers to structures which will have to
 * be long word aligned.  So we are making a stronger guarantee.  It might
 * have made sense to make Xalloc return char * to conform with people's
 * expectations of malloc, but this makes lint happier.
 */

void *
Xalloc(unsigned long amount)
{
    pointer ptr;

    if ((long) amount <= 0)
        return NULL;
    /* aligned extra on long word boundary */
    amount = (amount + 3) & ~3;
#ifdef MEMBUG
    if (!Must_have_memory && Memory_fail &&
        ((random() % MEM_FAIL_SCALE) < Memory_fail))
        return NULL;
#endif
    if (ptr = (pointer) malloc(amount))
        return ptr;
    if (Must_have_memory)
        FatalError("Out of memory");
    return NULL;
}

/*****************
 * Xcalloc
 *****************/

void *
Xcalloc(unsigned long amount)
{
    unsigned long *ret;

    ret = Xalloc(amount);
    if (ret)
        bzero((char *) ret, (int) amount);
    return ret;
}

/*****************
 * Xrealloc
 *****************/

void *
Xrealloc(pointer ptr, unsigned long amount)
{

#ifdef MEMBUG
    if (!Must_have_memory && Memory_fail &&
        ((random() % MEM_FAIL_SCALE) < Memory_fail))
        return (unsigned long *) NULL;
#endif
    if (amount <= 0) {
        if (ptr && !amount)
            free(ptr);
        return NULL;
    }
    amount = (amount + 3) & ~3;
    if (ptr)
        ptr = (pointer) realloc((char *) ptr, amount);
    else
        ptr = (pointer) malloc(amount);
    if (ptr)
        return ptr;
    if (Must_have_memory)
        FatalError("Out of memory");
    return NULL;
}

/*****************
 *  Xfree
 *    calls free 
 *****************/

void
Xfree(pointer ptr)
{
    if (ptr)
        free((char *) ptr);
}

#ifdef CAHILL_MALLOC
#include <malloc.h>

void *
debug_Xalloc(char *file, int line, unsigned long amount)
{
    pointer ptr;

    if ((long) amount <= 0)
        return NULL;
    /* aligned extra on long word boundary */
    amount = (amount + 3) & ~3;
    if (ptr = (pointer) debug_malloc(file, line, amount))
        return ptr;
    if (Must_have_memory)
        FatalError("Out of memory");
    return NULL;
}

/*****************
 * Xcalloc
 *****************/

void *
debug_Xcalloc(char *file, int line, unsigned long amount)
char *file;
int line;
unsigned long amount;
{
    unsigned long *ret;

    ret = debug_Xalloc(file, line, amount);
    if (ret)
        bzero((char *) ret, (int) amount);
    return ret;
}

/*****************
 * Xrealloc
 *****************/

void *
debug_Xrealloc(char *file, int line, pointer ptr,
               unsigned long amount)
{
    if ((long) amount <= 0) {
        if (ptr && !amount)
            debug_free(file, line, ptr);
        return NULL;
    }
    amount = (amount + 3) & ~3;
    if (ptr)
        ptr = (pointer) debug_realloc(file, line, (char *) ptr, amount);
    else
        ptr = (pointer) debug_malloc(file, line, amount);
    if (ptr)
        return ptr;
    if (Must_have_memory)
        FatalError("Out of memory");
    return NULL;
}

/*****************
 *  Xfree
 *    calls free 
 *****************/

void
debug_Xfree(char *file, int line, pointer ptr)
{
    if (ptr)
        debug_free(file, line, (char *) ptr);
}
#endif

void
OsInitAllocator(void)
{
#ifdef MEMBUG
    static int been_here;

    /* Check the memory system after each generation */
    if (been_here)
        CheckMemory();
    else
        been_here = 1;
#endif
    return;
}

/*VARARGS1*/
void
AuditF(char *f, char *s0, char *s1, char *s2, char *s3, char *s4, char *s5,
       char *s6, char *s7, char *s8, char *s9)
{                               /* limit of ten args */
#ifdef X_NOT_STDC_ENV
    long tm;
#else
    time_t tm;
#endif
    char *autime, *s;

    if (*f != ' ') {
        time(&tm);
        autime = ctime(&tm);
        if (s = index(autime, '\n'))
            *s = '\0';
        if (s = rindex(argvGlobal[0], '/'))
            s++;
        else
            s = argvGlobal[0];
        ErrorF("AUDIT: %s: %d %s: ", autime, getpid(), s);
    }
    ErrorF(f, s0, s1, s2, s3, s4, s5, s6, s7, s8, s9);

    return;
}

/*VARARGS1*/
void
FatalError(char *f, char *s0, char *s1, char *s2, char *s3, char *s4,
           char *s5, char *s6, char *s7, char *s8, char *s9)
{                               /* limit of ten args */
    ErrorF("\nFatal server error:\n");
    ErrorF(f, s0, s1, s2, s3, s4, s5, s6, s7, s8, s9);
    ErrorF("\n");
    AbortServer();
     /*NOTREACHED*/ return;
}

/*VARARGS1*/
void
ErrorF(char *f, char *s0, char *s1, char *s2, char *s3, char *s4, char *s5,
       char *s6, char *s7, char *s8, char *s9)
{                               /* limit of ten args */
#ifdef AMOEBA
    mu_lock(&print_lock);
#endif
    fprintf(stderr, f, s0, s1, s2, s3, s4, s5, s6, s7, s8, s9);
#ifdef AMOEBA
    mu_unlock(&print_lock);
#endif

    return;
}

