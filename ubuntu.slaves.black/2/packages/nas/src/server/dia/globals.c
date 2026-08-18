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
 * $NCDId: @(#)globals.c,v 1.2 1993/08/28 00:33:22 lemke Exp $
 */
/************************************************************
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

********************************************************/

/* $XConsortium: globals.c,v 1.51 92/03/13 15:40:57 rws Exp $ */

/*
 * $Id: globals.c 225 2006-08-30 00:08:16Z jon $
 * Mostly rewritten from here on out... -Jon Trulson
 */

#include <audio/Amd.h>
#include "misc.h"
#include "site.h"
#include "dixstruct.h"
#include "os.h"

                                /* Instantiate all of the globals
                                   here only */

                                /* instantiate global config options */
#define NASCONFIG_INSTANTIATE
#include "nasconf.h"
#undef NASCONFIG_INSTANTIATE

                                /* instantiate other globals */
#define GLOBALS_INSTANTIATE
#include "globals.h"
#undef GLOBALS_INSTANTIATE      /* clean up */

/* Initialize the globals, called from main */

void
diaInitGlobals(void)
{
    clients = (ClientPtr *) 0;
    serverClient = (ClientPtr) NULL;
    currentMaxClients = 0;

    serverGeneration = 0;

    currentTime.months = 0;
    currentTime.milliseconds = 0;


    display = NULL;

    TimeOutValue = DEFAULT_TIMEOUT * MILLI_PER_SECOND;

    argcGlobal = 0;
    argvGlobal = NULL;

    /* init the global configs */
    diaInitGlobalConfig();

    return;                     /* that's it */
}
