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
 * $NCDId: @(#)ausgi.h,v 1.3 1995/11/28 22:48:39 greg Exp $
 * 
 * Copyright (C) Siemens Nixdorf Informationssysteme AG 1993 All rights reserved
 */

#ifndef _SGI_H_
#define _SGI_H_

#ifdef SNI
#define VENDOR_STRING           "SNI RWxxx"
#else
#define VENDOR_STRING           "SGI"
#endif
#define VENDOR_RELEASE          1

/*
 * NOTE: The native format endianess should match that of the machine
 * running the audio server.
 */
#define auNativeFormat          AuFormatLinearSigned16MSB
#define auNativeBytesPerSample  2

#define _BSD_SIGNALS
#include <signal.h>

extern void *safe_alloc(size_t size);
extern void *safe_realloc(void *ptr, size_t size);
extern void safe_free(void *ptr);

typedef int AuBlock;
#define AuUnBlockAudio(_x)      sigsetmask(_x)
#define AuBlockAudio()          sigblock(sigmask(SIGALRM))
#define AuProtectedMalloc(_s)   safe_alloc(_s)
#define AuProtectedFree(_p)             safe_free(_p)

#endif /* !_SGI_H_ */
