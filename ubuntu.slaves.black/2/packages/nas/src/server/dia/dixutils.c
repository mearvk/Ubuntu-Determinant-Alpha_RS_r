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
 * $NCDId: @(#)dixutils.c,v 1.3 1994/04/07 20:54:09 greg Exp $
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


#include <audio/Amd.h>
#include "misc.h"
#include "dixstruct.h"

/* No-op Don't Do Anything : sometimes we need to be able to call a procedure
 * that doesn't do anything.  For example, on screen with only static
 * colormaps, if someone calls install colormap, it's easier to have a dummy
 * procedure to call than to check if there's a procedure 
 */
void
NoopDDA(pointer value, AuID id)
{
}

/*
 * A general work queue.  Perform some task before the server
 * sleeps for input.
 */

WorkQueuePtr workQueue;
static WorkQueuePtr *workQueueLast = &workQueue;
/* static Bool          WorkBlockHandlerRegistered; */

/* ARGSUSED */
void
ProcessWorkQueue(void)
{
    WorkQueuePtr q, n, p;

    p = NULL;
    /*
     * Scan the work queue once, calling each function.  Those
     * which return TRUE are removed from the queue, otherwise
     * they will be called again.  This must be reentrant with
     * QueueWorkProc, hence the crufty usage of variables.
     */
    for (q = workQueue; q; q = n) {
        if ((*q->function) (q->client, q->closure)) {
            /* remove q from the list */
            n = q->next;        /* don't fetch until after func called */
            if (p)
                p->next = n;
            else
                workQueue = n;
            xfree(q);
        } else {
            n = q->next;        /* don't fetch until after func called */
            p = q;
        }
    }
    if (p)
        workQueueLast = &p->next;
    else {
        workQueueLast = &workQueue;
    }
}

Bool
QueueWorkProc(function, client, closure)
Bool(*function) ();
ClientPtr client;
pointer closure;
{
    WorkQueuePtr q;

    q = (WorkQueuePtr) xalloc(sizeof *q);
    if (!q)
        return FALSE;
    q->function = function;
    q->client = client;
    q->closure = closure;
    q->next = NULL;
    *workQueueLast = q;
    workQueueLast = &q->next;
    return TRUE;
}

