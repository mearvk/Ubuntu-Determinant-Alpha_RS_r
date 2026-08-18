/* $Id: auvoxware.c 288 2013-08-11 21:28:33Z auerswald $ */

/*
   SCCS: @(#) auvoxware.c 11.4 95/04/14 
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
   AUVoxConfig additions (sysseh@devetir.qld.gov.au)
   96-01-15
        Put the following  keywords in -
                minrate         -       Minimum sampling rate
                maxrate         -       Maximum sampling rate
                fragsize        -       The fragment size
                minfrags        -       Minimum number of frags in queue
                maxfrags        -       Maximum fragments in queue
                wordsize        -       8 or 16 bit samples
                device          -       What device file to use
                numchans        -       Mono (1) or stereo (2)
                debug           -       Output messages during operation
                verbose         -       Be chatty about config
                inputsection    -       Next lot of specs are for input
                outputsection   -       Next specs are for output
                end             -       End an input or output section
*/
/*
   SCO Modification History:
   S005, 24-Apr-95, shawnm@sco.com
        base # of driver buffer fragments on data rate
   S004, 12-Apr-95, shawnm@sco.com
        finish integration of ausco.c, fix setitimer calls
   S003, 28-Mar-95, shawnm@sco.com, sysseh@devetir.qld.gov.au
        incorporate patch for stereo/mono mixing from Stephen Hocking
   S002, 21-Mar-95, shawnm@sco.com
        incorporate signal handling and audio block/unblock from ausco.c
   S001, 21-Mar-95, shawnm@sco.com, sysseh@devetir.qld.gov.au
        SYSSEH incorporate parts of patch from Stephen Hocking
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
 * $NCDId: @(#)auvoxware.c,v 1.10 1996/04/24 17:04:19 greg Exp $
 * 
 * Copyright (C) Siemens Nixdorf Informationssysteme AG 1993 All rights reserved
 */

/*
 * Originally from the merge of auvoxware by Amancio Hasty (hasty@netcom.com)
 * & auvoxsvr4 by Stephen Hocking (sysseh@devetir.qld.gov.au).
 * 16bit fixes and Linux patches supplied by Christian
 * Schlichtherle (s_schli@ira.uka.de).
 *
 * BUGS:
 * - When the soundcard can do only 8 bit recording, "aurecord" records
 *   twice as long as it should. Is this our fault?
 *
 * TODO:
 * - Adapt the buffer sizes to the current sampling rate,
 *   so that we can record/play high quality audio samples without
 *   swallows/pauses.
 *   Note that setting the buffer size to a fixed maximum will not work,
 *   because it causes playing at slow sample rate to pause. :-(
 *   I already tried to do this, but it seems that the rest of the server
 *   code doesn't recognize the changed buffer sizes. Any help in doing
 *   this is welcome!
 *   [chris]
 * - Support a second input channel for stereo sampling,
 *   so that microphone sampling is done on the mono channel
 *   while line sampling is done on the stereo channel.
 *   [chris]
 *
 * CHANGELOG:
 * - 94/7/2:
 *   Completely rewrote this file. Features:
 *   + Makes use of two sound cards if available.
 *     So you can concurrently record and play samples.
 *   + Tested to work with all combinations of 8/16 bit, mono/stereo
 *     sound card sampling modes.
 *   + Uses a stereo input channel if hardware supports this.
 *   + Can play stereo samples on mono sound cards (but who cares?).
 *   + Always uses the highest possible audio quality, i.e. 8/16 bit and
 *     mono/stereo parameters are fixed while only the sampling rate is
 *     variable. This reduces swallows and pauses to the (currently)
 *     unavoidable minimum while consuming a little bit more cpu time.
 *   + Format conversion stuff is pushed back to the rest of the server code.
 *     Only mono/stereo conversion is done here.
 *   + Debugging output uses indentation.
 *   [chris]
 */

#include <stdio.h>
#include <stdlib.h>
#ifndef SVR4
#include <getopt.h>
#endif
#include <sys/types.h>
#include <errno.h>
#ifndef _POSIX_SOURCE
# include <sys/ioctl.h>
#endif

#if defined(__CYGWIN__)
# ifndef O_SYNC
#  define O_SYNC          _FSYNC
# endif
extern int errno;
#endif


#include "nasconf.h"
#include "config.h"
#include "aulog.h"

#if defined(DEBUGDSPOUT) || defined(DEBUGDSPIN)
int dspin, dspout;
#endif

#  define IDENTMSG (debug_msg_indentation += 2)
#  define UNIDENTMSG (debug_msg_indentation -= 2)

static int debug_msg_indentation = 0;

#include <errno.h>
#include "misc.h"
#include "dixstruct.h"          /* for RESTYPE */
#include "os.h"                 /* for xalloc/xfree and NULL */
#include <fcntl.h>
#include <sys/time.h>
#include <sys/param.h>
#include <assert.h>

#if defined(__DragonFly__)
#  include <sys/soundcard.h>
#  ifndef O_SYNC
#     define O_SYNC O_FSYNC
#  endif
#elif defined(__FreeBSD__)
# if __FreeBSD_version >= 500001
#  include <sys/soundcard.h>
# else
#  include <machine/soundcard.h>
# endif
# include <machine/pcaudioio.h>
#else
# ifdef __NetBSD__
#  include <sys/ioctl.h>
#  include <soundcard.h>
# else
#  include <sys/soundcard.h>
# endif
#endif

#include <audio/audio.h>
#include <audio/Aproto.h>
#include "au.h"

static AuBool processFlowEnabled;
static void disableProcessFlow(void);
static void closeDevice(void);

#define SERVER_CLIENT           0

#define MAX_MINIBUF_SAMPLES     1024    /* Must be a power of 2 */

#define PhysicalOneTrackBufferSize \
    PAD4(auMinibufSamples * auNativeBytesPerSample * 1)
#define PhysicalTwoTrackBufferSize \
    PAD4(auMinibufSamples * auNativeBytesPerSample * 2)

/* VOXware sound driver mixer control variables */

#define useMixerNone 0
#define useMixerIGain 1
#define useMixerRecLev 2
#define useMixerLineMic 3

static AuBool relinquish_device = 0;
static AuBool leave_mixer = 0;
static AuBool share_in_out = 0;
static AuBool share_mixer = 0;

static int recControlMode = 0;  /* how to control recording level */
static int outmixerfd = -1;     /* The output device mixer device */
static int inmixerfd = -1;      /* The input device mixer device */
static int devmask = 0;         /* Bitmask for supported mixer devices */
static int recmask = 0;         /* Supported recording sources */

int VOXMixerInit   = FALSE;     /* overridden by nasd.conf */
int VOXReInitMixer = FALSE;     /* overridden by nasd.conf */

/* end of VOXware driver mixer control variables */

SndStat *confStat;

SndStat sndStatIn = {
    -1,                         /* fd */
    16,                         /* wordSize */
    1,                          /* isStereo */
    0,                          /* curSampleRate */
    4000,                       /* minSampleRate */
    44100,                      /* maxSampleRate */
    256,                        /* fragSize */
    3,                          /* minFrags */
    32,                         /* maxFrags */
    "/dev/dsp1",                /* device */
    "/dev/mixer1",              /* mixer */
    O_RDONLY,                   /* howToOpen */
    1,                          /* autoOpen */
    0,                          /* forceRate */
    0,                          /* isPCSpeaker */
    50,                         /* default gain */
    100                         /* gain reduction factor */
};

SndStat sndStatOut = {

    -1,                         /* fd */
    16,                         /* wordSize */
    1,                          /* isStereo */
    0,                          /* curSampleRate */
    4000,                       /* minSampleRate */
    44100,                      /* maxSampleRate */
    256,                        /* fragSize */
    3,                          /* minFrags */
    32,                         /* maxFrags */
    "/dev/dsp",                 /* device */
    "/dev/mixer",               /* mixer */
    O_WRONLY,                   /* howToOpen */
    1,                          /* autoOpen */
    0,                          /* forceRate */
    0,                          /* isPCSpeaker */
    50,                         /* default gain */
    100                         /* gain reduction factor */
};

#define auDefaultInputGain      AuFixedPointFromSum(sndStatIn.gain, 0)
#define auDefaultOutputGain     AuFixedPointFromSum(sndStatOut.gain, 0)

static AuUint8 *auOutputMono, *auOutputStereo, *auInput;

static ComponentPtr monoInputDevice,
        stereoInputDevice, monoOutputDevice, stereoOutputDevice;

extern AuInt32 auMinibufSamples;


#define auPhysicalOutputChangableMask AuCompDeviceGainMask

#define auPhysicalOutputValueMask \
  (AuCompCommonAllMasks \
   | AuCompDeviceMinSampleRateMask \
   | AuCompDeviceMaxSampleRateMask \
   | AuCompDeviceGainMask \
   | AuCompDeviceLocationMask \
   | AuCompDeviceChildrenMask)

#define auPhysicalInputChangableMask \
  (AuCompDeviceGainMask | AuCompDeviceLineModeMask)

#define auPhysicalInputValueMask \
  (AuCompCommonAllMasks \
   | AuCompDeviceMinSampleRateMask \
   | AuCompDeviceMaxSampleRateMask \
   | AuCompDeviceLocationMask \
   | AuCompDeviceGainMask \
   | AuCompDeviceChildrenMask)

static void setPhysicalOutputGain(AuFixedPoint gain);
static void setPhysicalInputGainAndLineMode(AuFixedPoint gain,
                                            AuUint8 lineMode);


/* internal funtions for enabling/disabling intervalProc using sigaction
   semantics */

static void intervalProc(int sig);

/* use this in disableIntervalProc() instead of SIG_IGN for testing */
#if 0
static void ignoreProc(int sig)
{
  osLogMsg("SIGNAL IGNORE: ENTRY\n");
  return;
}
#endif

static void enableIntervalProc(void)
{
    struct sigaction action;

    action.sa_handler = (void (*)(int))intervalProc;
    action.sa_flags = 0;
    sigemptyset(&action.sa_mask);
    sigaddset(&action.sa_mask, SIGALRM);

    if (sigaction(SIGALRM, &action, NULL) == -1)
        {
          osLogMsg("enableIntervalProc: sigaction failed: %s\n", 
                   strerror(errno));
        }
  
    return;
}

static void disableIntervalProc(void)
{
    struct sigaction action;

    action.sa_handler = (void (*)(int))SIG_IGN;
    action.sa_flags = 0;

    if (sigaction(SIGALRM, &action, NULL) == -1)
        {
          osLogMsg("disableIntervalProc: sigaction failed: %s\n", 
                   strerror(errno));
        }
  
    return;
}

static AuBool audioBlocked = AuFalse;

AuBlock _AuBlockAudio(void)
{                                                          
    sigset_t set;

    audioBlocked = AuTrue;
    sigemptyset(&set); 
    sigaddset(&set, SIGALRM);
    sigprocmask(SIG_BLOCK, &set, NULL);
    return 0;
}

void _AuUnBlockAudio(AuBlock _x)
{
    sigset_t set;

    audioBlocked = AuFalse;
    sigemptyset(&set);
    sigaddset(&set, SIGALRM);
    sigprocmask(SIG_UNBLOCK, &set, NULL);
    return;
}


/* ### SCO ### */
#ifdef sco

AuBlock
AuBlockAudio(void)
{
    audioBlocked = AuTrue;
    return 0;
}

void
AuUnBlockAudio(AuBlock id)
{
    audioBlocked = AuFalse;
}

#endif /* sco */

static int
readMixerOutputGain(void)
{
    int pcm_level = 0;

    if (outmixerfd != -1) {
        if (ioctl(outmixerfd, MIXER_READ(SOUND_MIXER_PCM), &pcm_level) == -1) {
            osLogMsg("readMixerOutputGain: "
                     "%s: ioctl(%d, MIXER_READ(SOUND_MIXER_PCM)) failed: %s\n",
                     sndStatOut.mixer, outmixerfd, strerror(errno));
            return sndStatOut.gain;
        }
    } else {
        return sndStatOut.gain;
    }

    pcm_level = ((pcm_level & 0xFF) + (pcm_level >> 8)) / 2;
    if (sndStatOut.gainScale) {
        pcm_level *= 100;
        pcm_level /= sndStatOut.gainScale;
    }
    return pcm_level;
}

static int
readMixerInputMode(void)
{
    int input_mode = 0;

    if (inmixerfd != -1) {
        if (ioctl(inmixerfd,MIXER_READ(SOUND_MIXER_RECSRC),&input_mode) == -1) {
            osLogMsg("readMixerInputMode: "
                     "%s: ioctl(%d, MIXER_READ(SOUND_MIXER_RECSRC)) failed: "
                     "%s\n", sndStatIn.mixer, inmixerfd, strerror(errno));
            return 1<<SOUND_MIXER_LINE;
        }
        if (!(input_mode & (SOUND_MASK_MIC | SOUND_MIXER_LINE))) {
            return 1<<SOUND_MIXER_LINE;
        }
    } else {
        return 1<<SOUND_MIXER_LINE;
    }

    return input_mode;
}

static int
readMixerInputGain(void)
{
    int in_level = 0;
    int recsrc = 0;
    
    recsrc = readMixerInputMode();

    if (inmixerfd != -1) {
        switch (recControlMode) {
        case useMixerIGain:
            if (ioctl(inmixerfd,MIXER_READ(SOUND_MIXER_IGAIN),&in_level) == -1){
                osLogMsg("readMixerInputGain: %s: "
                         "ioctl(MIXER_READ(SOUND_MIXER_IGAIN)) failed: %s\n",
                         sndStatIn.mixer, strerror(errno));
                return sndStatIn.gain;
            }
            break;

        case useMixerRecLev:
            if (ioctl(inmixerfd,MIXER_READ(SOUND_MIXER_RECLEV),&in_level)==-1) {
                osLogMsg("readMixerInputGain: "
                         "%s: ioctl(%d, MIXER_READ(SOUND_MIXER_RECLEV)) failed:"
                         " %s\n", sndStatIn.mixer, inmixerfd, strerror(errno));
                return sndStatIn.gain;
            }
            break;

        case useMixerLineMic:
            if (recsrc & SOUND_MASK_LINE) {
                if (ioctl(inmixerfd, MIXER_READ(SOUND_MIXER_LINE), &in_level)
                    == -1) {
                    osLogMsg("readMixerInputGain: "
                             "%s: ioctl(%d, MIXER_READ(SOUND_MIXER_LINE)) "
                             "failed: %s\n",
                             sndStatIn.mixer, inmixerfd, strerror(errno));
                    return sndStatIn.gain;
                }
            } else if (recsrc & SOUND_MASK_MIC) {
                if (ioctl(inmixerfd, MIXER_READ(SOUND_MIXER_MIC), &in_level)
                    == -1) {
                    osLogMsg("readMixerInputGain: "
                             "%s: ioctl(%d, MIXER_READ(SOUND_MIXER_MIC)) "
                             "failed: %s\n",
                             sndStatIn.mixer, inmixerfd, strerror(errno));
                    return sndStatIn.gain;
                }
            } else {
                return sndStatIn.gain;
            }
            break;

        case useMixerNone:
            return sndStatIn.gain;
            break;

        default:
            osLogMsg("readMixerInputGain: "
                     "unknown value %d of recControlMode\n", recControlMode);
            return sndStatIn.gain;
        }
    } else {
        return sndStatIn.gain;
    }

    in_level = ((in_level & 0xFF) + (in_level >> 8)) / 2;
    if (sndStatIn.gainScale) {
        in_level *= 100;
        in_level /= sndStatIn.gainScale;
    }
    return in_level;
}

static AuInt8
mixerInputModeToNAS(int input_mode)
{
    if (input_mode & SOUND_MASK_MIC)
        return AuDeviceInputModeMicrophone;

    if (input_mode & SOUND_MASK_LINE)
        return AuDeviceInputModeLineIn;

    if (NasConfig.DoDebug)
        osLogMsg("mixerInputModeToNAS: input mode %d is neither LINE (%d) "
                 "nor MIC (%d)\n", input_mode, SOUND_MASK_LINE, SOUND_MASK_MIC);

    return AuDeviceInputModeLineIn;
}

static void
setMixerDefaults(void)
{
    setPhysicalOutputGain(auDefaultOutputGain);
    setPhysicalInputGainAndLineMode(auDefaultInputGain, AuDeviceLineModeLow);
}

static int
createServerComponents(AuUint32 * auServerDeviceListSize,
                       AuUint32 * auServerBucketListSize,
                       AuUint32 * auServerRadioListSize,
                       AuUint32 * auServerMinRate,
                       AuUint32 * auServerMaxRate)
{
    ComponentPtr d, *p;
    AuUint8 formatIn, formatOut;
    AuUint32 bytesPerSampleIn, bytesPerSampleOut;
    static AuBool initialized = AuFalse;
    extern RESTYPE auComponentType;
    extern ComponentPtr *auServerDevices,       /* array of devices */
        auDevices;              /* list of all devices */
    extern AuUint32 auNumServerDevices; /* number of devices */


    if (NasConfig.DoDebug) {
        osLogMsg("createServerComponents(...);\n");
        IDENTMSG;
    }

    *auServerMinRate = aumax(sndStatIn.minSampleRate,
                             sndStatOut.minSampleRate);
    *auServerMaxRate = aumax(sndStatIn.maxSampleRate,
                             sndStatOut.maxSampleRate);

    auNumServerDevices = *auServerDeviceListSize
            = *auServerBucketListSize = *auServerRadioListSize = 0;

    formatIn = (sndStatIn.wordSize == 16) ? AuFormatLinearSigned16LSB
            : AuFormatLinearUnsigned8;
    formatOut = (sndStatOut.wordSize == 16) ? AuFormatLinearSigned16LSB
            : AuFormatLinearUnsigned8;

    bytesPerSampleIn = sndStatIn.wordSize / 8;
    bytesPerSampleOut = sndStatOut.wordSize / 8;

    AU_ALLOC_DEVICE(d, 1, 0);
    d->id = FakeClientID(SERVER_CLIENT);
    d->changableMask = auPhysicalOutputChangableMask;
    d->valueMask = auPhysicalOutputValueMask;
    d->kind = AuComponentKindPhysicalOutput;
    d->use = AuComponentUseExportMask;
    d->access = AuAccessExportMask | AuAccessListMask;
    d->format = formatOut;
    d->numTracks = 1;
    d->description.type = AuStringLatin1;
    d->description.string = "Mono Channel Output";
    d->description.len = strlen(d->description.string);
    d->minSampleRate = sndStatOut.minSampleRate;
    d->maxSampleRate = sndStatOut.maxSampleRate;
    d->location =
            AuDeviceLocationCenterMask | AuDeviceLocationInternalMask;
    d->numChildren = 0;
    d->minibuf = auOutputMono;
    d->minibufSize = d->numTracks * bytesPerSampleOut * auMinibufSamples;
    d->physicalDeviceMask = PhysicalOutputMono;
    AU_ADD_DEVICE(d);

    monoOutputDevice = d;

    AU_ALLOC_DEVICE(d, 2, 1);
    d->id = FakeClientID(SERVER_CLIENT);
    d->changableMask = auPhysicalOutputChangableMask;
    d->valueMask = auPhysicalOutputValueMask;
    d->kind = AuComponentKindPhysicalOutput;
    d->use = AuComponentUseExportMask;
    d->access = AuAccessExportMask | AuAccessListMask;
    d->format = formatOut;
    d->numTracks = 2;
    d->description.type = AuStringLatin1;
    d->description.string = "Stereo Channel Output";
    d->description.len = strlen(d->description.string);
    d->minSampleRate = sndStatOut.minSampleRate;
    d->maxSampleRate = sndStatOut.maxSampleRate;
    d->location =
            AuDeviceLocationCenterMask | AuDeviceLocationInternalMask;
    d->numChildren = 1;
    d->children = (AuID *) ((AuUint8 *) d + PAD4(sizeof(ComponentRec)));
    d->childSwap = (char *) (d->children + d->numChildren);
    d->children[0] = monoOutputDevice->id;
    d->minibuf = auOutputStereo;
    d->minibufSize = d->numTracks * bytesPerSampleOut * auMinibufSamples;
    d->physicalDeviceMask = PhysicalOutputStereo;
    AU_ADD_DEVICE(d);

    stereoOutputDevice = d;

    AU_ALLOC_DEVICE(d, (sndStatIn.isStereo + 1), 0);
    d->id = FakeClientID(SERVER_CLIENT);
    d->changableMask = auPhysicalInputChangableMask;
    d->valueMask = auPhysicalInputValueMask;
    d->kind = AuComponentKindPhysicalInput;
    d->use = AuComponentUseImportMask;
    d->access = AuAccessImportMask | AuAccessListMask;
    d->format = formatIn;
    d->numTracks = sndStatIn.isStereo + 1;
    d->description.type = AuStringLatin1;
    d->description.string = (sndStatIn.isStereo) ? "Stereo Channel Input"
            : "Mono Channel Input";
    d->description.len = strlen(d->description.string);
    d->minSampleRate = sndStatOut.minSampleRate;
    d->maxSampleRate = sndStatOut.maxSampleRate;
    d->location = AuDeviceLocationRightMask | AuDeviceLocationLeftMask
            | AuDeviceLocationExternalMask;
    d->numChildren = 0;
    d->minibuf = auInput;
    d->minibufSize = d->numTracks * bytesPerSampleIn * auMinibufSamples;
    d->physicalDeviceMask = (sndStatIn.isStereo) ? PhysicalInputStereo
            : PhysicalInputMono;
    AU_ADD_DEVICE(d);

    monoInputDevice = d;        /* Should have two input devices - FIXME */
    stereoInputDevice = d;

    /* set the array of server devices */
    if (!(auServerDevices = (ComponentPtr *) aualloc(sizeof(ComponentPtr)
                                                     *
                                                     auNumServerDevices)))
    {
        UNIDENTMSG;
        return AuBadAlloc;
    }

    p = auServerDevices;
    d = auDevices;

    while (d) {
        *p++ = d;
        d = d->next;
    }

    if (!initialized) {
        initialized = AuTrue;
        if (!leave_mixer) {
            setMixerDefaults();
        }

        /* JET - close the device if requested... only needs to happen
           here during first time init as diasableProcessFlow will handle
           it from here on out. */

        if (relinquish_device)
            closeDevice();

    }

    UNIDENTMSG;

    return AuSuccess;
}

static AuInt32
setTimer(AuInt32 rate)
{
    AuInt32 timer_ms;
    AuInt32 foo;
    struct itimerval ntval, otval;

    if (NasConfig.DoDebug > 5) {
        osLogMsg("setTimer(rate = %d);\n", rate);
        IDENTMSG;
    }

    /* change timer according to new sample rate */
    if (rate == 0) {            /* Disable timer case */
        ntval.it_value.tv_sec = ntval.it_value.tv_usec = 0;
        ntval.it_interval.tv_sec = ntval.it_interval.tv_usec = 0;
        timer_ms = 0x7fff;
    } else {
        timer_ms = (auMinibufSamples * 500) / rate;
        ntval.it_interval.tv_sec = 0;
        ntval.it_interval.tv_usec = timer_ms * 1000;
        ntval.it_value.tv_sec = 0;
        ntval.it_value.tv_usec = timer_ms * 10;
    }
    foo = setitimer(ITIMER_REAL, &ntval, &otval);

    UNIDENTMSG;

    return timer_ms;
}


#ifdef sco
static void
oneMoreTick(void)
{
    struct itimerval ntval, otval;
    int foo;

    ntval.it_interval.tv_sec = 0;
    ntval.it_interval.tv_usec = 0;
    ntval.it_value.tv_sec = 0;
    ntval.it_value.tv_usec = 10;
    foo = setitimer(ITIMER_REAL, &ntval, &otval);
}
#endif /* sco */


static void
setFragmentSize(SndStat * sndStatPtr)
{
    int fragarg, i, j;
    int datarate, numfrags;

    datarate = sndStatPtr->curSampleRate;
    if (sndStatPtr->isStereo)
        datarate *= 2;
    if (sndStatPtr->wordSize == 16)
        datarate *= 2;
    datarate /= 2;              /* half second */
    numfrags = datarate / MAX_MINIBUF_SAMPLES;
    if (numfrags < sndStatPtr->minFrags)
        numfrags = sndStatPtr->minFrags;
    else if (numfrags > sndStatPtr->maxFrags)
        numfrags = sndStatPtr->maxFrags;

    j = MAX_MINIBUF_SAMPLES;
    for (i = 0; j; i++)         /* figure out what power of 2 MAX_MINIBUF_SAMPLES is */
        j = j >> 1;
    fragarg = (numfrags << 16) | i;     /* numfrags of size MAX_MINIBUF_SAMPLES */
    ioctl(sndStatPtr->fd, SNDCTL_DSP_SETFRAGMENT, &fragarg);
}


static AuUint32
setSampleRate(AuUint32 rate)
{
    AuBlock l;

    setTimer(0);                /* JET - turn off the timer here so the
                                   following code has a chance to clean
                                   things up. A race can result
                                   otherwise.  */
    if (NasConfig.DoDebug) {
        osLogMsg("setSampleRate(rate = %d);\n", rate);
        IDENTMSG;
    }

    l = AuBlockAudio();

    if (sndStatOut.curSampleRate != rate) {
        sndStatOut.curSampleRate = rate;

#if defined(SNDCTL_DSP_SETFRAGMENT)
        setFragmentSize(&sndStatOut);
#endif
        ioctl(sndStatOut.fd, SNDCTL_DSP_SYNC, NULL);
        ioctl(sndStatOut.fd, SNDCTL_DSP_SPEED,
              &(sndStatOut.curSampleRate));
        if (sndStatOut.forceRate)
            sndStatOut.curSampleRate = rate;
        if (NasConfig.DoDebug)
            osLogMsg("setSampleRate(): set output sample rate to %d\n",
                     sndStatOut.curSampleRate);
    }

    if ((sndStatIn.fd == sndStatOut.fd) && (sndStatIn.fd != -1)) {
        sndStatIn = sndStatOut;
        if (NasConfig.DoDebug)
            osLogMsg("setSampleRate(): setting sndStatIn = sndStatOut\n");
    }
    else if (sndStatIn.curSampleRate != rate) {
        sndStatIn.curSampleRate = rate;

#if defined(SNDCTL_DSP_SETFRAGMENT)
        setFragmentSize(&sndStatIn);
#endif
        ioctl(sndStatIn.fd, SNDCTL_DSP_SYNC, NULL);
        ioctl(sndStatIn.fd, SNDCTL_DSP_SPEED, &(sndStatIn.curSampleRate));
        if (sndStatIn.forceRate)
            sndStatIn.curSampleRate = rate;
        if (NasConfig.DoDebug)
            osLogMsg("setSampleRate(): set input sample rate to %d\n",
                     sndStatIn.curSampleRate);
    }
#if defined(AUDIO_DRAIN)
    if (sndStatOut.isPCSpeaker)
        ioctl(sndStatOut.fd, AUDIO_DRAIN, 0);
#endif

    AuUnBlockAudio(l);

    setTimer(rate);

    UNIDENTMSG;

    return sndStatOut.curSampleRate;
}

static void setupSoundcard(SndStat * sndStatPtr);

static AuBool
openDevice(AuBool wait)
{
    unsigned int extramode = 0;
    int retries;
    int curSampleRate;

    setTimer(0);                /* no timers here */
#if defined(__CYGWIN__)         /* we want the file to be created if necc under
                                   windows */
    extramode = O_CREAT;
#endif

    if (NasConfig.DoDebug) {
        osLogMsg("openDevice\n");
    }

    curSampleRate = sndStatOut.curSampleRate;
    if (NasConfig.DoDebug) {
        osLogMsg("openDevice: current sample rate = %d\n", curSampleRate);
        if (sndStatOut.curSampleRate != sndStatIn.curSampleRate)
            osLogMsg("openDevice: sndStatOut.curSampleRate !="
                     " sndStatIn.curSampleRate\n");
    }

    if (NasConfig.DoDebug) {
        osLogMsg("openDevice OUT %s mode %d\n",
                 sndStatOut.device, sndStatOut.howToOpen);
    }


    if (sndStatOut.device[0] != '\0') {
        if (sndStatOut.fd == -1) {
            while ((sndStatOut.fd = open(sndStatOut.device,
                                         sndStatOut.
                                         howToOpen | O_SYNC | extramode,
                                         0666)) == -1 && wait) {
                osLogMsg("openDevice: waiting on output device\n");
                sleep(1);
            }
            setupSoundcard(&sndStatOut);
        } else {
            if (NasConfig.DoDebug) {
                osLogMsg("openDevice: output device already open\n");
            }
        }
    } else {
        if (NasConfig.DoDebug) {
            osLogMsg("openDevice: no output device specified\n");
        }
    }

#if  !defined(__CYGWIN__)
    if (sndStatIn.device[0] != '\0') {
        if (sndStatIn.fd == -1 && !share_in_out) {
            if (NasConfig.DoDebug)
                osLogMsg("openDevice IN %s mode %d\n", sndStatIn.device,
                         sndStatIn.howToOpen);

            retries = 0;
            while ((sndStatIn.fd = open(sndStatIn.device,
                                        sndStatIn.howToOpen | extramode,
                                        0666)) == -1 && wait) {
                osLogMsg("openDevice: waiting on input device, retry %d\n",
                         retries);
                sleep(1);
                retries++;

                if (retries >= 5) {
                    osLogMsg("openDevice: maximum retries exceeded, "
                             "giving up\n");
                    sndStatIn.fd = -1;
                    break;
                }
            }
            if (sndStatIn.fd != -1 && sndStatOut.fd != sndStatIn.fd)
                setupSoundcard(&sndStatIn);
        } else {
            sndStatIn.fd = sndStatOut.fd;
            if (NasConfig.DoDebug) {
                osLogMsg("openDevice: input device already open\n");
            }
        }
    } else {
        if (NasConfig.DoDebug) {
            osLogMsg("openDevice: no input device specified\n");
        }
    }

    if (outmixerfd == -1) {
        if (sndStatOut.mixer[0] == '\0') {
            osLogMsg("openDevice: no output mixer device specified\n");
        } else {
            while ((outmixerfd = open(sndStatOut.mixer, O_RDWR | extramode,
                                   0666)) == -1 && wait) {
                if ((errno == EAGAIN) || (errno == EBUSY)) {
                    osLogMsg("openDevice: waiting on mixer device %s\n",
                             sndStatOut.mixer);
                    sleep(1);
                } else {
                    osLogMsg("openDevice: could not open output mixer device"
                             " %s: %s\n", sndStatOut.mixer, strerror(errno));
                    break;
                }
            }
            if (outmixerfd != -1)
                osLogMsg("openDevice: opened mixer %s\n", sndStatOut.mixer);
        }
    } else {
        if (NasConfig.DoDebug) {
            osLogMsg("openDevice: output mixer device already open\n");
        }
    }

    if ((inmixerfd == -1) && !share_mixer) {
        if (sndStatIn.mixer[0] == '\0') {
            osLogMsg("openDevice: no input mixer device specified\n");
        } else {
            while ((inmixerfd = open(sndStatIn.mixer, O_RDWR | extramode,
                                   0666)) == -1 && wait) {
                if ((errno == EAGAIN) || (errno == EBUSY)) {
                    osLogMsg("openDevice: waiting on mixer device %s\n",
                             sndStatIn.mixer);
                    sleep(1);
                } else {
                    osLogMsg("openDevice: could not open input mixer device"
                             " %s: %s\n", sndStatIn.mixer, strerror(errno));
                    break;
                }
            }
            if (inmixerfd != -1)
                osLogMsg("openDevice: opened mixer %s\n", sndStatIn.mixer);
        }
    } else {
        if (share_mixer) {
            inmixerfd = outmixerfd;
        }
        if (NasConfig.DoDebug) {
            osLogMsg("openDevice: input mixer device already open\n");
        }
    }
#endif

    ioctl(sndStatOut.fd, SNDCTL_DSP_SYNC, NULL);

    {
        int rate;
#ifndef sco
        rate = sndStatOut.curSampleRate;
        ioctl(sndStatOut.fd, SNDCTL_DSP_SPEED, &sndStatOut.curSampleRate);
        if (sndStatOut.forceRate)
            sndStatOut.curSampleRate = rate;
#endif /* sco */

        if (sndStatOut.fd != sndStatIn.fd) {
            ioctl(sndStatIn.fd, SNDCTL_DSP_SYNC, NULL);
#ifndef sco
            rate = sndStatIn.curSampleRate;
            ioctl(sndStatIn.fd, SNDCTL_DSP_SPEED,
                  &sndStatIn.curSampleRate);
            if (sndStatIn.forceRate)
                sndStatIn.curSampleRate = rate;
#endif /* sco */
        }
    }

    setSampleRate(curSampleRate);

    return AuTrue;
}

static void
closeDevice(void)
{
    if (NasConfig.DoDebug) {
        osLogMsg("closeDevice: out\n");
    }
    if (sndStatOut.fd == -1) {
        if (NasConfig.DoDebug) {
            osLogMsg("closeDevice: output device already closed\n");
        }
    } else {
        if (NasConfig.DoDebug)
            osLogMsg("closeDevice OUT %s mode %d\n", sndStatOut.device,
                     sndStatOut.howToOpen);

        while (close(sndStatOut.fd)) {
            osLogMsg("closeDevice: waiting on output device\n");
            sleep(1);
        }
    }

    if (!share_in_out) {
        if (NasConfig.DoDebug) {
            osLogMsg("closeDevice: in\n");
        }
        if (sndStatIn.fd == -1) {
            if (NasConfig.DoDebug) {
                osLogMsg("closeDevice: input device already closed\n");
            }
        } else {
            if (NasConfig.DoDebug)
                osLogMsg("closeDevice IN %s mode %d\n",
                         sndStatIn.device, sndStatIn.howToOpen);

            while (close(sndStatIn.fd)) {
                osLogMsg("closeDevice: waiting on input device\n");
                sleep(1);
            }
        }
    }

    if (NasConfig.DoDebug) {
        osLogMsg("closeDevice: mixer\n");
    }

    if (NasConfig.DoKeepMixer) {
        if (NasConfig.DoDebug) {
            osLogMsg("closeDevice: leaving mixer device(s) open\n");
        }
    } else {
        if (-1 == outmixerfd) {
            if (NasConfig.DoDebug) {
                osLogMsg("closeDevice: output mixer device already closed\n");
            }
        } else {
            while (close(outmixerfd)) {
                osLogMsg("closeDevice: waiting on output mixer device\n");
                sleep(1);
            }
            if (NasConfig.DoDebug) {
                osLogMsg("closeDevice: closed output mixer device\n");
            }
            outmixerfd = -1;
        }
        if (-1 == inmixerfd) {
            if (NasConfig.DoDebug) {
                osLogMsg("closeDevice: input mixer device already closed\n");
            }
        } else {
            while (!share_mixer && close(inmixerfd)) {
                osLogMsg("closeDevice: waiting on input mixer device\n");
                sleep(1);
            }
            if (NasConfig.DoDebug) {
                osLogMsg("closeDevice: closed input mixer device\n");
            }
            inmixerfd = -1;
        }
    }

    sndStatIn.fd = -1;
    sndStatOut.fd = -1;
}


static void
serverReset(void)
{
    if (NasConfig.DoDebug) {
        osLogMsg("serverReset();\n");
        IDENTMSG;
    }

    setTimer(0);
    disableIntervalProc(); 

#if defined(AUDIO_DRAIN)
    if (sndStatOut.isPCSpeaker)
        ioctl(sndStatOut.fd, AUDIO_DRAIN, 0);
    else {
#endif

        ioctl(sndStatIn.fd, SNDCTL_DSP_SYNC, NULL);
        if (sndStatOut.fd != sndStatIn.fd)
            ioctl(sndStatOut.fd, SNDCTL_DSP_SYNC, NULL);

#if defined(AUDIO_DRAIN)
    }
#endif

    if (relinquish_device)
        closeDevice();

    if (NasConfig.DoDebug > 2) {
        osLogMsg(" done.\n");
    }

    if (NasConfig.DoDebug) {
        UNIDENTMSG;
    }
}

static void
intervalProc(int sig)
{
    extern void AuProcessData();

#if !defined(sco)
    setTimer(0);                /* turn off the timer here so that
                                   a potential race is avoided */

    if (processFlowEnabled)
        AuProcessData();

    setTimer(sndStatOut.curSampleRate);
#else
    if (!audioBlocked && processFlowEnabled)
        AuProcessData();
#endif /* sco */
}

/**
  * Gains are mapped thusly:
  *
  *   Software   s      0 - 100
  *   Hardware   h      0 - 100
**/

static void
setPhysicalOutputGain(AuFixedPoint gain)
{
    AuInt32 g = AuFixedPointIntegralAddend(gain);
    AuInt32 gusvolume;

    if (g > 100)
        g = 100;
    if (g < 0)
        g = 0;

    if (sndStatOut.gainScale) {
        g *= sndStatOut.gainScale;
        g /= 100;
    }

    gusvolume = g | (g << 8);
    if (outmixerfd != -1)
        if (ioctl(outmixerfd, MIXER_WRITE(SOUND_MIXER_PCM), &gusvolume) == -1)
            osLogMsg("setPhysicalOutputGain: "
                     "%s: ioctl(MIXER_WRITE(SOUND_MIXER_PCM)) failed: %s\n",
                     sndStatOut.mixer, strerror(errno));
}

static AuFixedPoint
getPhysicalOutputGain(void)
{
    return AuFixedPointFromSum(readMixerOutputGain(), 0);
}

static void
setPhysicalInputGainAndLineMode(AuFixedPoint gain, AuUint8 lineMode)
{
    AuInt16 g = AuFixedPointIntegralAddend(gain);
    AuInt16 inputAttenuation;
    AuInt16 zero = 0;
    int recsrc;

    if (g < 100)
        inputAttenuation = g;
    else
        inputAttenuation = 100;

    if (sndStatIn.gainScale) {
        inputAttenuation *= sndStatIn.gainScale;
        inputAttenuation /= 100;
    }

    if (lineMode == AuDeviceLineModeHigh) {
        recsrc = SOUND_MASK_MIC & recmask;
    } else if (lineMode == AuDeviceLineModeLow) {
        recsrc = SOUND_MASK_LINE & recmask;
    } else {
        osLogMsg("setPhysicalInputGainAndLineMode: illegal lineMode %d\n",
                 lineMode);
        recsrc = readMixerInputMode();
    }

    inputAttenuation = inputAttenuation << 8 | inputAttenuation;

    if (inmixerfd != -1) {
        switch (recControlMode) {
        case useMixerNone:
            break;

        case useMixerIGain:
            if (ioctl
                (inmixerfd, MIXER_WRITE(SOUND_MIXER_IGAIN),
                 &inputAttenuation) == -1)
                osLogMsg("setPhysicalInputGainAndLineMode: "
                         "%s: ioctl(MIXER_WRITE(SOUND_MIXER_IGAIN)) failed: "
                         "%s\n", sndStatIn.mixer, strerror(errno));
            break;

        case useMixerRecLev:
            if (ioctl
                (inmixerfd, MIXER_WRITE(SOUND_MIXER_RECLEV),
                 &inputAttenuation) == -1)
                osLogMsg("setPhysicalInputGainAndLineMode: "
                         "%s: ioctl(MIXER_WRITE(SOUND_MIXER_RECLEV)) failed: "
                         "%s\n", sndStatIn.mixer, strerror(errno));
            break;

        case useMixerLineMic:
            if (lineMode == AuDeviceLineModeHigh) {
                if (ioctl(inmixerfd, MIXER_WRITE(SOUND_MIXER_LINE), &zero) ==
                    -1)
                    osLogMsg("setPhysicalInputGainAndLineMode: "
                             "%s: ioctl(MIXER_WRITE(SOUND_MIXER_LINE)) failed: "
                             "%s\n", sndStatIn.mixer, strerror(errno));
                if (ioctl
                    (inmixerfd, MIXER_WRITE(SOUND_MIXER_MIC),
                     &inputAttenuation) == -1)
                    osLogMsg("setPhysicalInputGainAndLineMode: "
                             "%s: ioctl(MIXER_WRITE(SOUND_MIXER_MIC)) failed: "
                             "%s\n", sndStatIn.mixer, strerror(errno));
            } else if (lineMode == AuDeviceLineModeLow) {
                if (ioctl
                    (inmixerfd, MIXER_WRITE(SOUND_MIXER_LINE),
                     &inputAttenuation) == -1)
                    osLogMsg("setPhysicalInputGainAndLineMode: "
                             "%s: ioctl(MIXER_WRITE(SOUND_MIXER_LINE)) failed: "
                             "%s\n", sndStatIn.mixer, strerror(errno));
                if (ioctl(inmixerfd, MIXER_WRITE(SOUND_MIXER_MIC), &zero) ==
                    -1)
                    osLogMsg("setPhysicalInputGainAndLineMode: "
                             "%s: ioctl(MIXER_WRITE(SOUND_MIXER_MIC)) failed: "
                             "%s\n", sndStatIn.mixer, strerror(errno));
            }
            break;

        default:
            osLogMsg("setPhysicalInputGainAndLineMode: "
                     "unknown value %d of recControlMode\n", recControlMode);
            break;
        }

        if (ioctl(inmixerfd, MIXER_WRITE(SOUND_MIXER_RECSRC), &recsrc) == -1)
            osLogMsg("setPhysicalInputGainAndLineMode: "
                     "%s: ioctl(MIXER_WRITE(SOUND_MIXER_RECSRC)) failed: %s\n",
                     sndStatIn.mixer, strerror(errno));
    }
}

static AuFixedPoint
getPhysicalInputGain(void)
{
    return AuFixedPointFromSum(readMixerInputGain(), 0);
}

static AuInt8
getPhysicalInputLineMode(void)
{
    return mixerInputModeToNAS(readMixerInputMode());
}

static void
enableProcessFlow(void)
{

    if (NasConfig.DoDebug) {
        osLogMsg("enableProcessFlow();\n");
    }

    if (relinquish_device) {
        openDevice(AuTrue);
        if (VOXReInitMixer && VOXMixerInit) {
            setMixerDefaults();
        }
    }

#if defined(sco)
    if (!processFlowEnabled) {
        processFlowEnabled = AuTrue;
        setTimer(sndStatOut.curSampleRate);
    }
#else  /* sco */
    processFlowEnabled = AuTrue;
#endif /* sco */

}

static void
disableProcessFlow(void)
{
#ifndef sco
    int rate;

    processFlowEnabled = AuFalse;
#endif /* sco */

    if (NasConfig.DoDebug) {
        osLogMsg("disableProcessFlow() - starting\n");
    }

#ifdef sco
    if (processFlowEnabled) {
#endif /* sco */

        ioctl(sndStatOut.fd, SNDCTL_DSP_SYNC, NULL);
#ifndef sco
        rate = sndStatOut.curSampleRate;
        ioctl(sndStatOut.fd, SNDCTL_DSP_SPEED, &sndStatOut.curSampleRate);
        if (sndStatOut.forceRate)
            sndStatOut.curSampleRate = rate;
#endif /* sco */

        if (sndStatOut.fd != sndStatIn.fd) {
            ioctl(sndStatIn.fd, SNDCTL_DSP_SYNC, NULL);
#ifndef sco
            rate = sndStatOut.curSampleRate;
            ioctl(sndStatIn.fd, SNDCTL_DSP_SPEED,
                  &sndStatIn.curSampleRate);
            if (sndStatIn.forceRate)
                sndStatIn.curSampleRate = rate;
#endif /* sco */
        }
#ifdef sco
        oneMoreTick();
#endif

#ifdef sco
        processFlowEnabled = AuFalse;
#endif

        if (relinquish_device)
            closeDevice();

        if (NasConfig.DoDebug) {
            osLogMsg("disableProcessFlow() - done;\n");
        }
#ifdef sco
    }
#endif /* sco */
}


#if defined(__GNUC__) && !defined(linux) && !defined(__GNU__) && !defined(__GLIBC__) && !defined(USL) && !defined(__CYGWIN__)
inline
#endif
        static void
monoToStereoLinearSigned16LSB(AuUint32 numSamples)
{
    AuInt16 *s = (AuInt16 *) monoOutputDevice->minibuf;
    AuInt16 *d = (AuInt16 *) stereoOutputDevice->minibuf;

    while (numSamples--) {
        *d++ = *s;
        *d++ = *s++;
    }
}

#if defined(__GNUC__) && !defined(linux) && !defined(__GNU__) && !defined(__GLIBC__) && !defined(USL) && !defined(__CYGWIN__)
inline
#endif
        static void
monoToStereoLinearUnsigned8(AuUint32 numSamples)
{
    AuUint8 *s = (AuUint8 *) monoOutputDevice->minibuf;
    AuUint8 *d = (AuUint8 *) stereoOutputDevice->minibuf;

    while (numSamples--) {
        *d++ = *s;
        *d++ = *s++;
    }
}

static void
writePhysicalOutputsMono(void)
{
    AuBlock l;
    void *buf;
    int bufSize;

    if (sndStatOut.isStereo) {
        switch (monoOutputDevice->format) {
        case AuFormatLinearSigned16LSB:
            monoToStereoLinearSigned16LSB(monoOutputDevice->
                                          minibufSamples);
            break;

        case AuFormatLinearUnsigned8:
            monoToStereoLinearUnsigned8(monoOutputDevice->minibufSamples);
            break;

        default:
            /* check createServerComponents(...)! */
            assert(0);
        }

        buf = stereoOutputDevice->minibuf;
        bufSize = stereoOutputDevice->bytesPerSample
                * monoOutputDevice->minibufSamples;
    } else {
        buf = monoOutputDevice->minibuf;
        bufSize = monoOutputDevice->bytesPerSample
                * monoOutputDevice->minibufSamples;
    }

    l = AuBlockAudio();
    write(sndStatOut.fd, buf, bufSize);

#ifdef DEBUGDSPOUT
    {
        char tempbuf[80];

        snprintf(tempbuf, sizeof tempbuf, "\nwriteMono buf: %d size: %d\n",
                 buf, bufSize);
        write(dspout, tempbuf, strlen(tempbuf));
        write(dspout, buf, bufSize);
    }
#endif /* DEBUGDSPOUT */

    AuUnBlockAudio(l);
}

#if defined(__GNUC__) && !defined(linux) && !defined(__GNU__) && !defined(__GLIBC__) && !defined(USL) && !defined(__CYGWIN__)
inline
#endif
        static void
stereoToMonoLinearSigned16LSB(AuUint32 numSamples)
{
    AuInt16 *s = (AuInt16 *) stereoOutputDevice->minibuf;
    AuInt16 *d = (AuInt16 *) monoOutputDevice->minibuf;

    while (numSamples--) {
        *d++ = (s[0] + s[1]) / 2;
        s += 2;
    }
}

#if defined(__GNUC__) && !defined(linux) && !defined(__GNU__) && !defined(__GLIBC__) && !defined(USL) && !defined(__CYGWIN__)
inline
#endif
        static void
stereoToMonoLinearUnsigned8(AuUint32 numSamples)
{
    AuUint8 *s = (AuUint8 *) stereoOutputDevice->minibuf;
    AuUint8 *d = (AuUint8 *) monoOutputDevice->minibuf;

    while (numSamples--) {
        *d++ = (s[0] + s[1]) / 2;
        s += 2;
    }
}

static void
writePhysicalOutputsStereo(void)
{
    AuBlock l;
    void *buf;
    int bufSize;

    if (sndStatOut.isStereo) {
        buf = stereoOutputDevice->minibuf;
        bufSize = stereoOutputDevice->bytesPerSample
                * stereoOutputDevice->minibufSamples;
    } else {
        switch (stereoOutputDevice->format) {
        case AuFormatLinearSigned16LSB:
            stereoToMonoLinearSigned16LSB(stereoOutputDevice->
                                          minibufSamples);
            break;

        case AuFormatLinearUnsigned8:
            stereoToMonoLinearUnsigned8(stereoOutputDevice->
                                        minibufSamples);
            break;

        default:
            /* check createServerComponents(...)! */
            assert(0);
        }

        buf = monoOutputDevice->minibuf;
        bufSize = monoOutputDevice->bytesPerSample
                * stereoOutputDevice->minibufSamples;
    }

    l = AuBlockAudio();
    write(sndStatOut.fd, buf, bufSize);

#ifdef DEBUGDSPOUT
    {
        char tempbuf[80];

        snprintf(tempbuf, sizeof tempbuf, "\nwriteStereo buf: %d size: %d\n",
                 buf, bufSize);
        write(dspout, tempbuf, strlen(tempbuf));
        write(dspout, buf, bufSize);
    }
#endif /* DEBUGDSPOUT */

    AuUnBlockAudio(l);
}

static void
writePhysicalOutputsBoth(void)
{
    AuInt16 *m = (AuInt16 *) monoOutputDevice->minibuf;
    AuInt16 *p, *s;
    AuUint8 *m8 = (AuUint8 *) monoOutputDevice->minibuf;
    AuUint8 *p8, *s8;
    AuUint32 max = aumax(monoOutputDevice->minibufSamples,
                         stereoOutputDevice->minibufSamples);
    AuUint32 i;

    switch (stereoOutputDevice->format) {
    case AuFormatLinearSigned16LSB:
        p = s = (AuInt16 *) stereoOutputDevice->minibuf;

        for (i = 0; i < max; i++) {
            *p++ = (*m + *s++) / 2;
            *p++ = (*m++ + *s++) / 2;
        }
        break;

    case AuFormatLinearUnsigned8:
        p8 = s8 = (AuUint8 *) stereoOutputDevice->minibuf;

        for (i = 0; i < max; i++) {
            *p8++ = (*m8 + *s8++) / 2;
            *p8++ = (*m8++ + *s8++) / 2;
        }
        break;

    default:
        assert(0);
    }

    stereoOutputDevice->minibufSamples = max;

    writePhysicalOutputsStereo();
}

static void
readPhysicalInputs(void)
{
    AuBlock l;

    /* Should make use of two input devices - FIXME */

    l = AuBlockAudio();
    read(sndStatIn.fd, stereoInputDevice->minibuf,
         stereoInputDevice->bytesPerSample * auMinibufSamples);

#ifdef DEBUGDSPIN
    {
        char tempbuf[80];
        snprintf(tempbuf, sizeof tempbuf, "\nreadInputs buf: %d size: %d\n",
                stereoInputDevice->minibuf,
                stereoInputDevice->bytesPerSample * auMinibufSamples);
        write(dspin, tempbuf, strlen(tempbuf));
        write(dspin, stereoInputDevice->minibuf,
              stereoInputDevice->bytesPerSample * auMinibufSamples);
    }
#endif /* DEBUGDSPIN */

    AuUnBlockAudio(l);
}

static void
noop(void)
{
}

static void
setWritePhysicalOutputFunction(CompiledFlowPtr flow, void (**funct) (void))
{
    AuUint32 mask = flow->physicalDeviceMask;

    if ((mask & (PhysicalOutputMono | PhysicalOutputStereo)) ==
        (PhysicalOutputMono | PhysicalOutputStereo))
        *funct = writePhysicalOutputsBoth;
    else if (mask & PhysicalOutputMono)
        *funct = writePhysicalOutputsMono;
    else if (mask & PhysicalOutputStereo)
        *funct = writePhysicalOutputsStereo;
    else
        *funct = noop;
}

/*
 * Setup soundcard at maximum audio quality.
 */
static void
setupSoundcard(SndStat * sndStatPtr)
{

    if (NasConfig.DoDebug) {
        osLogMsg("setupSoundcard(...);\n");
        IDENTMSG;
    }

    if (NasConfig.DoDebug)
        if (sndStatPtr == &sndStatOut) {
            osLogMsg("++ Setting up Output device (%s)\n",
                     sndStatPtr->device);
        } else {
            osLogMsg("++ Setting up Input device (%s)\n",
                     sndStatPtr->device);
        }


    if (sndStatPtr->isPCSpeaker) {
        if (NasConfig.DoDebug)
            osLogMsg("+++ Device is a PC speaker\n");
        sndStatPtr->curSampleRate = sndStatPtr->maxSampleRate
                = sndStatPtr->minSampleRate = 8000;
        sndStatPtr->isStereo = 0;
        sndStatPtr->wordSize = 8;
    } else {
        if (NasConfig.DoDebug)
            osLogMsg("+++ requesting wordsize of %d, ",
                     sndStatPtr->wordSize);
        if (ioctl
            (sndStatPtr->fd, SNDCTL_DSP_SAMPLESIZE, &sndStatPtr->wordSize)
            || sndStatPtr->wordSize != 16) {
            sndStatPtr->wordSize = 8;
            ioctl(sndStatPtr->fd, SNDCTL_DSP_SAMPLESIZE,
                  &sndStatPtr->wordSize);
        }
        if (NasConfig.DoDebug)
            osLogMsg("got %d\n", sndStatPtr->wordSize);

        if (NasConfig.DoDebug)
            osLogMsg("+++ requesting %d channel(s), ",
                     sndStatPtr->isStereo + 1);
        if (ioctl(sndStatPtr->fd, SNDCTL_DSP_STEREO, &sndStatPtr->isStereo)
            == -1 || !sndStatPtr->isStereo) {
            sndStatPtr->isStereo = 0;
            ioctl(sndStatPtr->fd, SNDCTL_DSP_STEREO,
                  &sndStatPtr->isStereo);
        }
        if (NasConfig.DoDebug)
            osLogMsg("got %d channel(s)\n", sndStatPtr->isStereo + 1);

        if (NasConfig.DoDebug)
            osLogMsg("+++ Requesting minimum sample rate of %d, ",
                     sndStatPtr->minSampleRate);
        ioctl(sndStatPtr->fd, SNDCTL_DSP_SPEED,
              &sndStatPtr->minSampleRate);
        if (NasConfig.DoDebug)
            osLogMsg("got %d\n", sndStatPtr->minSampleRate);

        if (NasConfig.DoDebug)
            osLogMsg("+++ Requesting maximum sample rate of %d, ",
                     sndStatPtr->maxSampleRate);
        ioctl(sndStatPtr->fd, SNDCTL_DSP_SPEED,
              &sndStatPtr->maxSampleRate);
        if (NasConfig.DoDebug)
            osLogMsg("got %d\n", sndStatPtr->maxSampleRate);

        sndStatPtr->curSampleRate = sndStatPtr->maxSampleRate;

    }

#if defined(SNDCTL_DSP_SETFRAGMENT)
    setFragmentSize(sndStatPtr);
#endif

    UNIDENTMSG;
}


#ifdef sco
static AuBool
scoInterrupts(void)
{
    struct sigaction act;

    act.sa_handler = intervalProc;
    act.sa_flags = 0;
    sigemptyset(&act.sa_mask);
    sigaddset(&act.sa_mask, SIGALRM);
    if (sigaction(SIGALRM, &act, (struct sigaction *) NULL) == -1) {
        ErrorF("sigaction SIGALRM");
        return FALSE;
    }

    return TRUE;
}
#endif /* sco */

static AuBool
initMixer(void)
{
    unsigned int extramode = 0;

#if defined(__CYGWIN__)         /* we want the file to be created if necc under
                                   windows */
    extramode = O_CREAT;
#endif

    /* open output mixer device */
    if (sndStatOut.mixer[0] != '\0') {
        if ((outmixerfd=open(sndStatOut.mixer, O_RDWR|extramode, 0666)) == -1) {
            UNIDENTMSG;
            osLogMsg("initMixer: could not open output mixer device %s: %s\n",
                     sndStatOut.mixer, strerror(errno));
            return AuFalse;
        }
        if (NasConfig.DoDebug)
            osLogMsg("initMixer: opened output mixer device %s\n",
                     sndStatOut.mixer, outmixerfd);
    } else {
        if (NasConfig.DoDebug)
            osLogMsg("initMixer: no output mixer device specified\n");
    }

    /* open input mixer device */
    if (sndStatIn.mixer[0] != '\0') {
        if (strcmp(sndStatIn.mixer, sndStatOut.mixer) != 0) {
            if ((inmixerfd = open(sndStatIn.mixer, O_RDWR | extramode,
                                0666)) == -1) {
                UNIDENTMSG;
                osLogMsg("initMixer: could not open input mixer device %s: %s\n"
                         , sndStatIn.mixer, strerror(errno));
                if (outmixerfd != -1) {
                    osLogMsg("initMixer: using output mixer %s for input\n",
                             sndStatOut.mixer);
                    share_mixer = AuTrue;
                    inmixerfd = outmixerfd;
                    sndStatIn.mixer = sndStatOut.mixer;
                } else {
                    return AuFalse;
                }
            }
        } else {
            share_mixer = AuTrue;
            inmixerfd = outmixerfd;
            sndStatIn.mixer = sndStatOut.mixer;
            if (NasConfig.DoDebug)
                osLogMsg("initMixer: using the same mixer device for"
                         " in- and output\n");
        }
        if (NasConfig.DoDebug)
            osLogMsg("initMixer: opened input mixer device %s\n",
                     sndStatIn.mixer, inmixerfd);
    } else {
        if (NasConfig.DoDebug)
            osLogMsg("initMixer: no input mixer device specified\n");
        return AuTrue;
    }

    /* get recording devices of input mixer */
    if (ioctl(inmixerfd, SOUND_MIXER_READ_DEVMASK, &devmask) == -1) {
        osLogMsg("initMixer: %s: ioctl(SOUND_MIXER_READ_DEVMASK) failed: %s\n",
                 sndStatIn.mixer, strerror(errno));
        osLogMsg("initMixer: closing input mixer device\n");
        close(inmixerfd);
        inmixerfd = -1;
    } else {
        if (devmask & (1 << SOUND_MIXER_IGAIN)) {
            recControlMode = useMixerIGain;
        } else if (devmask & (1 << SOUND_MIXER_RECLEV)) {
            recControlMode = useMixerRecLev;
        } else if ((devmask & (1 << SOUND_MIXER_LINE)) ||
                   (devmask & (1 << SOUND_MIXER_MIC))) {
            recControlMode = useMixerLineMic;
        } else {
            recControlMode = useMixerNone;
            osLogMsg("initMixer: %s: can't control recording level\n",
                     sndStatIn.mixer);
        }

        if (NasConfig.DoDebug)
            osLogMsg("initMixer: %s: using recording level control method %d\n",
                     sndStatIn.mixer, recControlMode);

        if (ioctl(inmixerfd, SOUND_MIXER_READ_RECMASK, &recmask) == -1) {
            osLogMsg("initMixer: %s: ioctl(SOUND_MIXER_READ_RECMASK) failed: "
                     "%s\n", sndStatIn.mixer, strerror(errno));
            return AuFalse;
        }
    }
    return AuTrue;
}

AuBool
AuInitPhysicalDevices(void)
{
    static AuBool AL_initialized = AuFalse;
    static AuUint8 *physicalBuffers;
    AuUint32 physicalBuffersSize;
    extern AuUint8 *auPhysicalOutputBuffers;
    extern AuUint32 auPhysicalOutputBuffersSize;
    extern void AuProcessData();
    unsigned int extramode = 0; /* for extra open modes (cygwin) */
#if defined(AUDIO_GETINFO)
    audio_info_t spkrinf;
#endif

#if defined(__CYGWIN__)
    extramode = O_CREAT;
#endif

    if (NasConfig.DoDebug) {
        osLogMsg("AuInitPhysicalDevices();\n");
        IDENTMSG;
    }

    if (NasConfig.DoDeviceRelease) {
        relinquish_device = AuTrue;
        if (NasConfig.DoDebug)
            osLogMsg("Init: will close device when finished with stream.\n");
    } else {
        relinquish_device = AuFalse;
        if (NasConfig.DoDebug)
            osLogMsg("Init: will open device exclusivly.\n");
    }

    if (NasConfig.DoKeepMixer) {
        if (NasConfig.DoDebug) {
            osLogMsg("Init: will keep mixer device open.\n");
        }
    } else {
        if (NasConfig.DoDebug) {
            osLogMsg("Init: will close mixer device when closing audio device.\n");
        }
    }

    if (VOXMixerInit) {
        leave_mixer = AuFalse;
        if (NasConfig.DoDebug)
            osLogMsg("Init: will initialize mixer device options.\n");
    } else {
        leave_mixer = AuTrue;
        if (NasConfig.DoDebug)
            osLogMsg("Init: Leaving the mixer device options alone at startup.\n");
    }

    /*
     * create the input and output ports
     */
    if (!AL_initialized) {
        int fd;

        AL_initialized = AuTrue;

        if (sndStatOut.autoOpen) {
            if (sndStatOut.device[0] != '\0') {
                if (NasConfig.DoDebug)
                    osLogMsg("Init: openDevice OUT %s mode %d\n",
                             sndStatOut.device, sndStatOut.howToOpen);

                if ((fd = open(sndStatOut.device,
                               sndStatOut.howToOpen | O_SYNC | extramode,
                               0)) == -1) {
                    UNIDENTMSG;
                    osLogMsg("Init: Output open(%s) failed: %s\n",
                             sndStatOut.device, strerror(errno));
                    return AuFalse;
                }
                sndStatOut.fd = fd;
#if defined(AUDIO_GETINFO)
                if (sndStatOut.isPCSpeaker) {
                    ioctl(fd, AUDIO_GETINFO, &spkrinf);
                    spkrinf.play.encoding = AUDIO_ENCODING_RAW;
                    ioctl(fd, AUDIO_SETINFO, &spkrinf);
                }
#endif
            } else {
                if (NasConfig.DoDebug)
                    osLogMsg("Init: no output device specified\n");
            }
        }
#ifdef DEBUGDSPOUT
        dspout = open("/tmp/dspout", O_WRONLY | O_CREAT, 00666);
#endif
#ifdef DEBUGDSPIN
        dspin = open("/tmp/dspin", O_WRONLY | O_CREAT, 00666);
#endif


        if (sndStatIn.autoOpen) {

            if (sndStatIn.device[0] != '\0') {
                if (NasConfig.DoDebug)
                    osLogMsg("Init: openDevice(1) IN %s mode %d\n",
                             sndStatIn.device, sndStatIn.howToOpen);

                if ((fd =
                     open(sndStatIn.device, sndStatIn.howToOpen | extramode,
                          0)) != -1)
                    sndStatIn.fd = fd;
                else {
                    sndStatIn.fd = sndStatOut.fd;
                    share_in_out = AuTrue;
                    osLogMsg("Init: Input open(%s) failed: %s, using output device\n", sndStatIn.device, strerror(errno));
                }
            } else {
                if (NasConfig.DoDebug)
                    osLogMsg("Init: no input device specified\n");
            }
        }

        if (sndStatOut.fd != -1)
            setupSoundcard(&sndStatOut);
        if ((sndStatIn.fd != -1) && (sndStatOut.fd != sndStatIn.fd))
            setupSoundcard(&sndStatIn);

        if (!sndStatOut.isPCSpeaker) {
            if (initMixer() == AuFalse) {
                osLogMsg("Init: initMixer failed\n");
                if (outmixerfd != -1) {
                    osLogMsg("Init: closing output mixer device\n");
                    close(outmixerfd);
                    outmixerfd = -1;
                }
                if (inmixerfd != -1) {
                    osLogMsg("Init: closing input mixer device\n");
                    close(inmixerfd);
                    inmixerfd = -1;
                }
            } else {
                if (NasConfig.DoDebug)
                    osLogMsg("Init: initMixer was successful\n");
            }
        }
    }

    if (physicalBuffers)
        aufree(physicalBuffers);

    auMinibufSamples = MAX_MINIBUF_SAMPLES;

    /* the output buffers need to be twice as large for output range checking */
    physicalBuffersSize = PhysicalTwoTrackBufferSize +  /* mono/stereo input */
            PhysicalOneTrackBufferSize * 2 +    /* mono output */
            PhysicalTwoTrackBufferSize * 2;     /* stereo output */

    if (!(physicalBuffers = (AuUint8 *) aualloc(physicalBuffersSize))) {
        UNIDENTMSG;
        return AuFalse;
    }

    auInput = physicalBuffers;
    auOutputMono = auInput + PhysicalTwoTrackBufferSize;
    auOutputStereo = auOutputMono + 2 * PhysicalOneTrackBufferSize;

    auPhysicalOutputBuffers = auOutputMono;
    auPhysicalOutputBuffersSize = physicalBuffersSize -
            PhysicalTwoTrackBufferSize;

    /*
     * Call AuProcessData() in signal handler often enough to drain the
     * input devices and keep the output devices full at the current
     * sample rate.
     */

    processFlowEnabled = AuFalse;

#ifdef sco
    if (!scoInterrupts()) {
        return AuFalse;
    }
#else

    enableIntervalProc(); 

#endif /* sco */

    setTimer(0);

    AuRegisterCallback(AuCreateServerComponentsCB, createServerComponents);
    AuRegisterCallback(AuSetPhysicalOutputGainCB, setPhysicalOutputGain);
    AuRegisterCallback(AuGetPhysicalOutputGainCB, getPhysicalOutputGain);
    AuRegisterCallback(AuSetPhysicalInputGainAndLineModeCB,
                       setPhysicalInputGainAndLineMode);
    AuRegisterCallback(AuGetPhysicalInputGainCB, getPhysicalInputGain);
    AuRegisterCallback(AuGetPhysicalInputModeCB, getPhysicalInputLineMode);
    AuRegisterCallback(AuEnableProcessFlowCB, enableProcessFlow);
    AuRegisterCallback(AuDisableProcessFlowCB, disableProcessFlow);
    AuRegisterCallback(AuReadPhysicalInputsCB, readPhysicalInputs);
    AuRegisterCallback(AuSetWritePhysicalOutputFunctionCB,
                       setWritePhysicalOutputFunction);

    AuRegisterCallback(AuSetSampleRateCB, setSampleRate);

    /* bogus resource so we can have a cleanup function at server reset */
    AddResource(FakeClientID(SERVER_CLIENT),
                CreateNewResourceType(serverReset), 0);

    UNIDENTMSG;

    return AuTrue;
}
