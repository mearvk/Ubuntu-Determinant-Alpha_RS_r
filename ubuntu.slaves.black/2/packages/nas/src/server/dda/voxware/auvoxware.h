/* $Id: auvoxware.h 270 2007-11-22 23:53:23Z steve_mcintyre $ */
/*
   SCCS: @(#) auvoxware.h 11.2 95/03/22 
*/
/*-------------------------------------------------------------------------

Copyright (C) 1995 The Santa Cruz Operation, Inc.
All Rights Reserved.

Permission to use, copy, modify and distribute this software
for any purpose is hereby granted without fee, provided that the 
above copyright notice and this notice appear in all copies
and that both the copyright notice and this notice appear in
supporting documentation.  SCO makes no representations about
the suitability of this software for any purpose.  It is provided
"AS IS" without express or implied warranty.

SCO DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, 
INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS.  
IN NO EVENT SHALL SCO BE LIABLE FOR ANY SPECIAL, INDIRECT, 
PUNITIVE, CONSEQUENTIAL OR INCIDENTAL DAMAGES OR ANY DAMAGES 
WHATSOEVER RESULTING FROM LOSS OF USE, LOSS OF DATA OR LOSS OF
PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER 
TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR 
PERFORMANCE OF THIS SOFTWARE.

-------------------------------------------------------------------------*/
/*
   SCO Modification History:
   S001, 22-Mar-95, shawnm@sco.com
        change AuBlockAudio, AuUnBlockAudio, vendor string
*/
/*
 * Copyright 1993 Network Computing Devices, Inc. Copyright (C) Siemens
 * Nixdorf Informationssysteme AG 1993
 * 
 * Permission to use, copy, modify, distribute, and sell this software and its
 * documentation for any purpose is hereby granted without fee, provided that
 * the above copyright notice appear in all copies and that both that
 * copyright notice and this permission notice appear in supporting
 * documentation, and that the name Network Computing Devices, Inc.  or
 * Siemens Nixdorf Informationssysteme AG not be used in advertising or
 * publicity pertaining to distribution of this software without specific,
 * written prior permission.
 * 
 * THIS SOFTWARE IS PROVIDED `AS-IS'.  NETWORK COMPUTING DEVICES, INC. AND
 * SIEMENS NIXDORF INFORMATIONSSYSTEME AG DISCLAIMS ALL WARRANTIES WITH
 * REGARD TO THIS SOFTWARE, INCLUDING WITHOUT LIMITATION ALL IMPLIED
 * WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE, OR
 * NONINFRINGEMENT.  IN NO EVENT SHALL NETWORK COMPUTING DEVICES, INC. NOR
 * SIEMENS NIXDORF INFORMATIONSSYSTEME AG BE LIABLE FOR ANY DAMAGES
 * WHATSOEVER, INCLUDING SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES,
 * INCLUDING LOSS OF USE, DATA, OR PROFITS, EVEN IF ADVISED OF THE
 * POSSIBILITY THEREOF, AND REGARDLESS OF WHETHER IN AN ACTION IN CONTRACT,
 * TORT OR NEGLIGENCE, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
 * PERFORMANCE OF THIS SOFTWARE.
 * 
 * $NCDId: @(#)auvoxware.h,v 1.3 1995/05/23 20:54:00 greg Exp $
 * 
 */

#ifndef _AUVOXWARE_H_
#define _AUVOXWARE_H_

#define VENDOR_STRING           "VoxWare"
#define VENDOR_RELEASE          1

/*
 * NOTE: The native format endianess should match that of the machine
 * running the audio server.
 */
#define auNativeFormat          AuFormatLinearSigned16LSB
#define auNativeBytesPerSample  2

#include <signal.h>

typedef int AuBlock;

#if defined(linux) || defined(__GNU__) || defined(__GLIBC__) || defined(__CYGWIN__)

/* use functions defined in auvoxware.c.  These are also used by dia/ */
AuBlock _AuBlockAudio(void);
void    _AuUnblockAudio(AuBlock _x);

#define AuBlockAudio()     _AuBlockAudio()
#define AuUnBlockAudio(_x) _AuUnBlockAudio(_x)

#else /* defined(linux)  */
#ifndef sco
#if defined(SVR4) || defined(SYSV)
#define AuUnBlockAudio(_x)                                                    \
do                                                                            \
{                                                                             \
    if ((int) (_x) != (int) SIG_HOLD)                                         \
        (void) sigset(SIGALRM, (void (*)(int))(_x));                          \
} while(0)

#define AuBlockAudio()          (int) sigset(SIGALRM, SIG_HOLD)
#define signal                  sigset
#else
#define AuUnBlockAudio(_x)      sigsetmask(_x)
#define AuBlockAudio()          sigblock(sigmask(SIGALRM))
#endif
#endif /* sco */
#endif /* defined(linux) */

#define AuProtectedMalloc(_s)   xalloc(_s)
#define AuProtectedFree(_p)     free(_p)

#endif /* !_AUVOXWARE_H_ */
