/*
 * aulog.c - provide a global logging function - varargs based for verbosity
 *           and debugging.
 *
 * $Id: aulog.c 288 2013-08-11 21:28:33Z auerswald $
 *
 * Jon Trulson 9/11/99
 */

#include <stdio.h>
#include <stdarg.h>
#include "aulog.h"
#include "NasConfig.h"

#include "misc.h"
#include "dixstruct.h"
#include "globals.h"

#if defined(DIA_USE_SYSLOG)
# include <syslog.h>
#endif

void
osLogMsg(const char *fmt, ...)
{
    va_list ap;
    static char buf[LOG_BUFSIZE];
    static FILE *errfd = NULL;

    va_start(ap, fmt);

    (void) vsnprintf(buf, sizeof buf, fmt, ap);

    va_end(ap);

#if defined(DIA_USE_SYSLOG)

    if (NasConfig.DoDaemon) {   /* daemons use syslog */
        openlog("nas", LOG_PID, LOG_DAEMON);
        syslog(LOG_DEBUG, "%s", buf);
        closelog();
    } else {
        errfd = stderr;
        if (errfd != NULL) {
            fprintf(errfd, "%s", buf);
            fflush(errfd);
        }
    }

#else /* we just send to stdout */

    errfd = stderr;

    if (errfd != NULL) {
        fprintf(errfd, "%s", buf);
        fflush(errfd);
    }
#endif /* DIA_USE_SYSLOG */

    return;

}
