/*
 * Copyright 1993 Network Computing Devices, Inc.
 * 
 * Permission to use, copy, modify, distribute, and sell this software and its
 * documentation for any purpose is hereby granted without fee, provided that
 * the above copyright notice appear in all copies and that both that
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
 * $NCDId: @(#)auhpux.h,v 1.3 1996/04/24 17:17:17 greg Exp $
 */

/*---------------------------------------------------------
 Hewlett Packard Device Dependent Server Version 1.0

 CHANGES :      Author : J D Brister (University of Manchester, Computer Graphics Unit)
                                                                                                                                                
 (C) Copyright 1995, The University of Manchester, United Kingdom
 
  THIS SOFTWARE IS PROVIDED `AS-IS'.  THE UNIVERSITY OF MANCHESTER,
 DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING WITHOUT
 LIMITATION ALL IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 PARTICULAR PURPOSE, OR NONINFRINGEMENT.  IN NO EVENT SHALL THE UNIVERSITY
 OF MANCHESTER, BE LIABLE FOR ANY DAMAGES WHATSOEVER, INCLUDING
 SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES, INCLUDING LOSS OF USE, DATA,
 OR PROFITS, EVEN IF ADVISED OF THE POSSIBILITY THEREOF, AND REGARDLESS OF
 WHETHER IN AN ACTION IN CONTRACT, TORT OR NEGLIGENCE, ARISING OUT OF OR IN
 CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.                                               

 This program may be used freely within the UK academic community, but it must not be used 
 for commercial gain without the written permission of the authors.

 EMail :  cgu-info@cgu.mcc.ac.uk

 NOTE : THIS SERVER MUST BE RUN AS ROOT.
-----------------------------------------------------------*/


#define _AUHPUX_C_
/*#define __DEBUG__       *//* show __DEBUG__ging info at run time.... */
#define __AUDIO__II__           /* remove if using audio(I) hardware.   */

#ifndef _AUHPUX_H_
#define _AUHPUX_H_

#define V_STRING                auhpuxVendorString
#define VENDOR_RELEASE          1
#define VENDOR_STRING           "HP /dev/audio"

#ifndef _AUHPUX_C_
extern char *V_STRING;
#endif /* !_AUHPUX_C_ */

/*
 * NOTE: The native format endianess should match that of the machine
 * running the audio server.
 */
#define auNativeFormat          AuFormatLinearSigned16MSB
#define auNativeBytesPerSample  2

#include <signal.h>

typedef int AuBlock;
#if defined(SYSV) || defined(SVR4)
#if defined(hpux)

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
    if (sigvector(sig, &vec, &ovec) != 0) {
        perror("sigvector");
    }

    return (ovec.sv_handler);
}

#ifndef NeedFunctionPrototypes
static void
AuUnBlockAudio(l)
AuBlock l;
#else /* NeedFunctionPrototypes */
static void
AuUnBlockAudio(AuBlock l)
#endif                          /* NeedFunctionPrototypes */
{
}

#ifndef NeedFunctionPrototypes
static AuBlock
AuBlockAudio()
#else /* NeedFunctionPrototypes */
static AuBlock
AuBlockAudio(void)
#endif                          /* NeedFunctionPrototypes */
{
}
#else

#define AuUnBlockAudio(_x)                                                    \
do                                                                            \
{                                                                             \
    if ((int) (_x) != (int) SIG_HOLD)                                         \
        (void) signal(SIGALRM, (void (*)(int))(_x));                          \
} while(0)

#define AuBlockAudio()          (int) signal(SIGALRM, SIG_HOLD)
#endif
#else
#define AuUnBlockAudio(_x)      sigsetmask(_x)
#define AuBlockAudio()          sigblock(sigmask(SIGALRM))
#endif
#define AuProtectedMalloc(_s)   xalloc(_s)
#define AuProtectedFree(_p)     free(_p)

#endif /* !_AUHPUX_H_ */
