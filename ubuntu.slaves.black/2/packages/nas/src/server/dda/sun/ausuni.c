/* Unified NAS dda for Sun Sparc architecture

Copyright 1995, 1997, 1998, 2000 Charles Levert

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE COPYRIGHT HOLDER BE LIABLE FOR ANY CLAIM, DAMAGES OR
OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
OTHER DEALINGS IN THE SOFTWARE.

Except as contained in this notice, the name of the copyright holder shall
not be used in advertising or otherwise to promote the sale, use or
other dealings in this Software without prior written authorization
from the copyright holder.

 $Id: ausuni.c 288 2013-08-11 21:28:33Z auerswald $


 HISTORY:

 John Wehle 12/10/2000:
        * ausuni.c: (errno.h): Include.  
                    (devAudioMode): New static variable.  
                    (openDevice): If open for O_RDWR fails
                                  then retry open using O_WRONLY.
                    (AuInitPhysicalDevices): Likewise.   
                    (writeOutput): Check devAudioMode and
                                   reopen device if necessary.
                    (readPhysicalInputs): Likewise. 

 


*/

/**
 *
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
 * $NCDId$
 */

#define _AUSUN_C_ 1


#include <stdio.h>              /* for sprintf */
#include <stdlib.h>             /* for getenv */
#include <errno.h>
#include "misc.h" 
#include "dixstruct.h"          /* for RESTYPE */
#include "os.h"                 /* for xalloc/xfree and NULL */
#include "nasconf.h"
#include <fcntl.h>
#include <stropts.h>
#include <string.h>             /* for strcmp */
#ifndef SVR4
#include <sun/audioio.h>
#else /* SVR4 */
#include <sys/audioio.h>
#endif /* SVR4 */
#include <audio/audio.h>
#include <audio/Aproto.h>
#include "au.h"

/* These constants are for SS5 and the like (SS4, ultra?) with a
   CS4231.  With SunOS 4.1.x on a SS5, make sure you have at least
   4.1.4 + patch 102387-06.  Solaris 2.5 is reported to work.  Can't
   speak for other CS4231 configurations.  */

#ifndef AUDIO_INTERNAL_CD_IN
#define AUDIO_INTERNAL_CD_IN 0x04
#endif /* not defined AUDIO_INTERNAL_CD_IN */
#ifndef SVR4
#ifndef AUDIO_DEV_CS4231
#define AUDIO_DEV_CS4231 5
#endif /* not defined AUDIO_DEV_CS4231 */
#endif /* not defined SVR4 */

#if defined(SYSV) || defined(SVR4)
#define signal sigset
#else
#define BSD_SIGNALS
#endif

static char name_am79c30[] = "SUNW,am79c30";
static char name_CS4231[] = "SUNW,CS4231";
static char name_dbri[] = "SUNW,dbri";
static char name_unknown[] = "unknown audio device";
static char *name_of_physical_device;   /* must point to one of the above */

/* pebl: on some solaris (for example sun rays) have pseudo audio devices as
   there are used for multiply users. The pseudo device is create by 'utadem'
   in /tmp/SUNWut/dev/utaudio/<literal>. It seems that sun uses/encourage to
   use the env AUDIODEV to point to the pseudo devide, so it should be checked
   before trying the default devices. If there is a pseodu device the ctl is
   /tmp/SUNWut/dev/utaudio/<literal>ctl. 
   http://www.sun.com/desktop/products/software/sunforum/sunforumnotes.html*/

static const char *const default_device = "/dev/audio";


extern int errno;

#ifndef SVR4
typedef int audio_device_t;
#define IS_AMD(_t)              ((_t) == AUDIO_DEV_AMD)
#define IS_CS4231(_t)           ((_t) == AUDIO_DEV_CS4231)
#define IS_DBRI(_t) \
    ((_t) == AUDIO_DEV_SPEAKERBOX || (_t) == AUDIO_DEV_CODEC)
#else /* defined SVR4 */
#define IS_AMD(_t)      (!strcmp((_t).name, name_am79c30))
#define IS_CS4231(_t)   (!strcmp((_t).name, name_CS4231))
#define IS_DBRI(_t)     (!strcmp((_t).name, name_dbri))
#endif /* defined SVR4 */

/**********************************************************************/

/* Local compilation options. */
#define ADD_OUTPUTS
#undef DEBUGLOG
#define REVERSE_WRITE
#undef DELAYED_TRIGGER
#define WRITE_EMPTY_ENABLE
#undef SEPARATE_CTLS
#define SYNC_PROCESS_ENABLED

/**********************************************************************/

extern void AuNativeToULAW8();
extern void AuULAW8ToNative();
extern void AuProcessData();
static AuFixedPoint getPhysicalFeedbackGain();
static AuFixedPoint getPhysicalInputGain();
static AuUint8 getPhysicalInputMode();

/**********************************************************************/

static AuBool is_cs4231_or_dbri;
static AuBool relinquish_device = 0;
static int devAudio = -1, devAudioCtl = -1,
#ifdef SEPARATE_CTLS
        devAudioCtl2 = -1,
#endif
        devAudioMode = O_RDWR, bufSize;
static volatile AuBool signalEnabled = 0;
#ifdef DELAYED_TRIGGER
static AuBool delayedTrigger = 0;
#endif
static AuBool pendingTrigger = AuFalse;
static AuInt32 chunksPerSignal;
static volatile audio_info_t syncAudioInfo;
static audio_info_t audioInfo;
static AuUint8 *auOutputMono, *auOutputStereo, *auOutputLeft, *auOutputRight, *auInput, /* mono or stereo */
   *emptyOutput;
static volatile AuBool updateSampleRate;
#ifdef SYNC_PROCESS_ENABLED
static volatile AuBool updateSyncAudioInfo;
#endif
static AuUint32 sampleRate,
#ifndef ADD_OUTPUTS
    theAverage,
#endif
 
        
        *leftSamples,
        *rightSamples,
        *monoSamples, *stereoSamples, availInputModes, availOutputModes;

extern AuInt32 auMinibufSamples;

char *VENDOR_STRING;
#define SUN_VENDOR              "Sun unified dda (running on %s)"
#define SERVER_CLIENT           0
#define MINIBUF_SAMPLES         800
#define SIGNAL_RATE             10

#define auMinSampleRate         8000
static AuUint32 auMaxSampleRate;

#define auPhysicalOutputChangableMask \
        (AuCompDeviceGainMask | AuCompDeviceOutputModeMask)

#define auPhysicalOutputValueMask \
        (AuCompCommonAllMasks | \
         AuCompDeviceMinSampleRateMask | \
         AuCompDeviceMaxSampleRateMask | \
         AuCompDeviceOutputModeMask | \
         AuCompDeviceGainMask | \
         AuCompDeviceLocationMask | \
         AuCompDeviceChildrenMask)

#define auPhysicalInputValueMask \
        (AuCompCommonAllMasks | \
         AuCompDeviceMinSampleRateMask | \
         AuCompDeviceMaxSampleRateMask | \
         AuCompDeviceLocationMask | \
         AuCompDeviceGainMask)

#define auPhysicalFeedbackValueMask \
        (AuCompCommonAllMasks | \
         AuCompDeviceGainMask)

/**********************************************************************/

/* callback */
static AuStatus
createServerComponents(auServerDeviceListSize, auServerBucketListSize,
                       auServerRadioListSize, auServerMinRate,
                       auServerMaxRate)
AuUint32 *auServerDeviceListSize,
        *auServerBucketListSize,
        *auServerRadioListSize, *auServerMinRate, *auServerMaxRate;
{
    AuDeviceID stereo, mono, left, right;
    ComponentPtr d, *p;
    AuUint8 num;
    AuUint32 location;
    extern RESTYPE auComponentType;
    extern ComponentPtr *auServerDevices,       /* array of devices */
        auDevices;              /* list of all devices */
    extern AuUint32 auNumServerDevices; /* number of devices */

#ifdef DEBUGLOG
    fprintf(stderr, "createServerComponents()\n");
    fflush(stderr);
#endif

    *auServerMinRate = auMinSampleRate;
    *auServerMaxRate = auMaxSampleRate;

    auNumServerDevices
            = *auServerDeviceListSize
            = *auServerBucketListSize = *auServerRadioListSize = 0;

    if (is_cs4231_or_dbri) {
        AU_ALLOC_DEVICE(d, 1, 0);
        d->id = left = FakeClientID(SERVER_CLIENT);
        d->changableMask = auPhysicalOutputChangableMask;
        d->valueMask = auPhysicalOutputValueMask;
        d->kind = AuComponentKindPhysicalOutput;
        d->use = AuComponentUseExportMask;
        d->access = AuAccessExportMask | AuAccessListMask;
        d->format = auNativeFormat;
        d->numTracks = 1;
        d->description.type = AuStringLatin1;
        d->description.string = "Left Channel Output";
        d->description.len = strlen(d->description.string);
        d->minSampleRate = auMinSampleRate;
        d->maxSampleRate = auMaxSampleRate;
        d->location = AuDeviceLocationLeftMask;
        d->numChildren = 0;
        d->minibuf = auOutputLeft;
        d->minibufSize = auMinibufSamples * auNativeBytesPerSample *
                d->numTracks;
        d->physicalDeviceMask = PhysicalOutputLeft;
        leftSamples = &d->minibufSamples;
        AU_ADD_DEVICE(d);

        AU_ALLOC_DEVICE(d, 1, 0);
        d->id = right = FakeClientID(SERVER_CLIENT);
        d->changableMask = auPhysicalOutputChangableMask;
        d->valueMask = auPhysicalOutputValueMask;
        d->kind = AuComponentKindPhysicalOutput;
        d->use = AuComponentUseExportMask;
        d->access = AuAccessExportMask | AuAccessListMask;
        d->format = auNativeFormat;
        d->numTracks = 1;
        d->description.type = AuStringLatin1;
        d->description.string = "Right Channel Output";
        d->description.len = strlen(d->description.string);
        d->minSampleRate = auMinSampleRate;
        d->maxSampleRate = auMaxSampleRate;
        d->location = AuDeviceLocationRightMask;
        d->numChildren = 0;
        d->minibuf = auOutputRight;
        d->minibufSize = auMinibufSamples * auNativeBytesPerSample *
                d->numTracks;
        d->physicalDeviceMask = PhysicalOutputRight;
        rightSamples = &d->minibufSamples;
        AU_ADD_DEVICE(d);
    }

    if (is_cs4231_or_dbri) {
        num = 2;
        location = AuDeviceLocationLeftMask | AuDeviceLocationRightMask;
    } else {
        num = 0;
        location = AuDeviceLocationCenterMask |
                AuDeviceLocationInternalMask;
    }
    AU_ALLOC_DEVICE(d, 1, num);
    d->id = mono = FakeClientID(SERVER_CLIENT);
    d->changableMask = auPhysicalOutputChangableMask;
    d->valueMask = auPhysicalOutputValueMask;
    d->kind = AuComponentKindPhysicalOutput;
    d->use = AuComponentUseExportMask;
    d->access = AuAccessExportMask | AuAccessListMask;
    d->format = auNativeFormat;
    d->numTracks = 1;
    d->description.type = AuStringLatin1;
    d->description.string = "Mono Channel Output";
    d->description.len = strlen(d->description.string);
    d->minSampleRate = auMinSampleRate;
    d->maxSampleRate = auMaxSampleRate;
    d->location = location;
    d->numChildren = num;
    if (is_cs4231_or_dbri) {
        d->children = (AuID *) ((AuUint8 *) d +
                                PAD4(sizeof(ComponentRec)));
        d->childSwap = (char *) (d->children + d->numChildren);
        d->children[0] = left;
        d->children[1] = right;
    }
    d->minibuf = auOutputMono;
    d->minibufSize = auMinibufSamples * auNativeBytesPerSample *
            d->numTracks;
    d->physicalDeviceMask = PhysicalOutputMono;
    monoSamples = &d->minibufSamples;
    AU_ADD_DEVICE(d);

    num = is_cs4231_or_dbri ? 2 : 1;
    AU_ALLOC_DEVICE(d, 2, num);
    d->id = stereo = FakeClientID(SERVER_CLIENT);
    d->changableMask = auPhysicalOutputChangableMask;
    d->valueMask = auPhysicalOutputValueMask;
    d->kind = AuComponentKindPhysicalOutput;
    d->use = AuComponentUseExportMask;
    d->access = AuAccessExportMask | AuAccessListMask;
    d->format = auNativeFormat;
    d->numTracks = 2;
    d->description.type = AuStringLatin1;
    d->description.string = "Stereo Channel Output";
    d->description.len = strlen(d->description.string);
    d->minSampleRate = auMinSampleRate;
    d->maxSampleRate = auMaxSampleRate;
    d->location = location;
    d->numChildren = num;
    d->children = (AuID *) ((AuUint8 *) d + PAD4(sizeof(ComponentRec)));
    d->childSwap = (char *) (d->children + num);
    if (is_cs4231_or_dbri) {
        d->children[0] = left;
        d->children[1] = right;
    } else
        d->children[0] = mono;
    d->minibuf = auOutputStereo;
    d->minibufSize = auMinibufSamples * auNativeBytesPerSample *
            d->numTracks;
    d->physicalDeviceMask = PhysicalOutputStereo;
    stereoSamples = &d->minibufSamples;
    AU_ADD_DEVICE(d);

    /* same value; don't recompute */
    /* num = is_cs4231_or_dbri ? 2 : 1; */
    AU_ALLOC_DEVICE(d, num, 0);
    d->id = FakeClientID(SERVER_CLIENT);
    d->changableMask = AuCompDeviceGainMask;
    d->valueMask = auPhysicalFeedbackValueMask;
    d->kind = AuComponentKindPhysicalFeedback;
    d->use = 0;
    d->access = AuAccessListMask;
    d->format = 0;
    d->numTracks = num;
    d->description.type = AuStringLatin1;
    d->description.string = "Feedback";
    d->description.len = strlen(d->description.string);
    d->numChildren = 0;
    d->gain = getPhysicalFeedbackGain();
    d->lineMode = AuDeviceLineModeNone;
    d->physicalDeviceMask = (is_cs4231_or_dbri
                             ? PhysicalFeedbackStereo
                             : PhysicalFeedbackMono);
    d->minibuf = NULL;
    d->minibufSize = 0;
    AU_ADD_DEVICE(d);

    /* same value; don't recompute */
    /* num = is_cs4231_or_dbri ? 2 : 1; */
    AU_ALLOC_DEVICE(d, num, 0);
    d->id = FakeClientID(SERVER_CLIENT);
    if (is_cs4231_or_dbri) {
        d->changableMask = (AuCompDeviceGainMask |
                            AuCompDeviceLineModeMask);
        d->valueMask = (auPhysicalInputValueMask |
                        AuCompDeviceLineModeMask);
    } else {
        d->changableMask = AuCompDeviceGainMask;
        d->valueMask = auPhysicalInputValueMask;
    }
    d->kind = AuComponentKindPhysicalInput;
    d->use = AuComponentUseImportMask;
    d->access = AuAccessImportMask | AuAccessListMask;
    d->format = auNativeFormat;
    d->numTracks = num;
    d->description.type = AuStringLatin1;
    d->description.string = (is_cs4231_or_dbri
                             ? "Stereo Channel Input"
                             : "Mono Channel Input");
    d->description.len = strlen(d->description.string);
    d->minSampleRate = auMinSampleRate;
    d->maxSampleRate = auMaxSampleRate;
    /* External on most machines now */
    d->location = (AuDeviceLocationRightMask | AuDeviceLocationLeftMask |
                   AuDeviceLocationExternalMask);
    d->numChildren = 0;
    d->gain = getPhysicalInputGain();
    d->lineMode = getPhysicalInputMode();
    d->minibuf = auInput;
    d->minibufSize = auMinibufSamples * auNativeBytesPerSample *
            d->numTracks;
    d->physicalDeviceMask = (is_cs4231_or_dbri
                             ? PhysicalInputStereo : PhysicalInputMono);
    AU_ADD_DEVICE(d);

    /* set the array of server devices */
    if (!(auServerDevices =
          (ComponentPtr *) aualloc(sizeof(ComponentPtr) *
                                   auNumServerDevices)))
        return AuBadAlloc;

    p = auServerDevices;
    for (d = auDevices; d; d = d->next)
        *p++ = d;

    return AuSuccess;
}

static AuBool
openDevice(wait)
AuBool wait;
{
    audio_info_t info;
    const char *device = NULL;

    /* pebl: Check whether a pseudo device is used, else try the normal ones */
    if ((device = getenv("AUDIODEV")) == NULL)
        device = default_device;


    if (devAudio == -1)
        while ((devAudio = open(device, devAudioMode)) == -1 && wait) {
            if (errno == EINVAL && devAudioMode == O_RDWR)
                devAudioMode = O_WRONLY;
            sleep(5);
        }

    if (devAudio != -1) {
        if (is_cs4231_or_dbri) {
            audioInfo.play.sample_rate
                    = audioInfo.record.sample_rate = sampleRate;
            aucopy(&audioInfo, &info, sizeof(audio_info_t));
            ioctl(devAudio, AUDIO_SETINFO, &info);
        }

        return AuTrue;
    }

    return AuFalse;
}

static void
closeDevice()
{
    if (devAudio != -1) {
        close(devAudio);
        devAudio = -1;
    }
}

/* cleanup function at server reset */
static void
serverReset()
{
#ifdef DEBUGLOG
    fprintf(stderr, "serverReset()\n");
    fflush(stderr);
#endif

    if (!relinquish_device || openDevice(AuFalse)) {
        signal(SIGPOLL, SIG_IGN);       /* discard pending signals */
        ioctl(devAudio, AUDIO_DRAIN, 0);        /* drain everything out */
        if (relinquish_device)
            closeDevice();
    }
}

static void
updateHardware()
{
    /* We don't delay updating anything that can be changed via
       audioCtl, possibly by some other application, anymore.
       Those values aren't cached in static variables either.
       This way, we can control the audio device through the
       server for immediate feedback only operations, which don't
       involve software manipulated audio data, without resorting
       to a non-NAS application. */

    if (updateSampleRate
#ifdef SYNC_PROCESS_ENABLED
        || updateSyncAudioInfo
#endif
            ) {
        audio_info_t info;

        ioctl(devAudioCtl, I_SETSIG, 0);        /* disable signal */

#ifdef SYNC_PROCESS_ENABLED
        if (updateSyncAudioInfo) {
            ioctl(devAudioCtl, AUDIO_SETINFO, &syncAudioInfo);
            AUDIO_INITINFO(&syncAudioInfo);
            updateSyncAudioInfo = AuFalse;
        }

        if (updateSampleRate) {
#endif
            AUDIO_INITINFO(&info);
            info.play.sample_rate = info.record.sample_rate = sampleRate;
            ioctl(devAudio, AUDIO_SETINFO, &info);
            updateSampleRate = AuFalse;
#ifdef SYNC_PROCESS_ENABLED
        }
#endif

        if (signalEnabled)
            ioctl(devAudioCtl, I_SETSIG, S_MSG);
    }
}

static void
setAudioCtlInfo()
{
#ifndef SEPARATE_CTLS
#ifdef SYNC_PROCESS_ENABLED
    if (signalEnabled)
        updateSyncAudioInfo = AuTrue;
    else {
#endif
        ioctl(devAudioCtl, I_SETSIG, 0);
        ioctl(devAudioCtl, AUDIO_SETINFO, &syncAudioInfo);
        AUDIO_INITINFO(&syncAudioInfo);
        if (signalEnabled)
            ioctl(devAudioCtl, I_SETSIG, S_MSG);
#ifdef SYNC_PROCESS_ENABLED
    }
#endif
#else
    ioctl(devAudioCtl2, AUDIO_SETINFO, infoPtr);
#endif
}

/**
  * Gains are mapped thusly:
  *
  *   Software   0 - 49     50 - 100
  *   Hardware   0 - 49     50 - 255
  */
/* g in FixedPoint */
#define gain100togain255(g) (((g) < 0x320000) \
                             ? ((g) >> 16) \
                             : ((0x41999 * ((g) >> 9) - 0x4d77f100) >> 23))
        /* (g - 50) * (205 / 50) + 50 */
#define gain255togain100(g) (((g) < 50) \
                             ? AuFixedPointFromSum((g), 0) \
                             : ((((g) * 0x3e7064) >> 8) + 0x25ce0d))
        /* (g - 50) * (50 / 205) + 50 */


#ifdef SYNC_PROCESS_ENABLED
        /* We assume that AUDIO_INITINFO uses ~0 as a filler. This is
           because clients like aupanel do a get right after a set.  It's
           not a good thing to waste CPU like that, but it should not
           happen that often (usually in response to user action).  */

#define getCtl(info, field) \
        do { \
                while (~syncAudioInfo.field) /*  */ ; \
                ioctl(devAudioCtl, AUDIO_GETINFO, &(info)); \
        } while (0)
#else
#define getCtl(info, field) \
        ioctl(devAudioCtl, AUDIO_GETINFO, &(info))
#endif

/* callback */
static AuFixedPoint
getPhysicalOutputGain()
{
    audio_info_t info;

#ifdef DEBUGLOG
    fprintf(stderr, "getPhysicalOutputGain()\n");
    fflush(stderr);
#endif

    getCtl(info, play.gain);

    return gain255togain100(info.play.gain);
}

/* callback */
static void
setPhysicalOutputGain(gain)
AuFixedPoint gain;
{
#ifdef DEBUGLOG
    fprintf(stderr, "setPhysicalOutputGain(gain=%08d)\n", gain);
    fflush(stderr);
#endif

    syncAudioInfo.play.gain = gain100togain255(gain);
    setAudioCtlInfo();
}

/* callback */
static AuFixedPoint
getPhysicalFeedbackGain()
{
    audio_info_t info;

#ifdef DEBUGLOG
    fprintf(stderr, "getPhysicalFeedbackGain()\n");
    fflush(stderr);
#endif

    getCtl(info, monitor_gain);

    return gain255togain100(info.monitor_gain);
}

/* callback */
static void
setPhysicalFeedbackGain(gain)
AuFixedPoint gain;
{
#ifdef DEBUGLOG
    fprintf(stderr, "setPhysicalFeedbackGain(gain=%08d)\n", gain);
    fflush(stderr);
#endif

    syncAudioInfo.monitor_gain = gain100togain255(gain);
    setAudioCtlInfo();
}

/* callback */
static AuUint8
getPhysicalOutputMode()
{
    AuUint8 mode = 0;
    audio_info_t info;

#ifdef DEBUGLOG
    fprintf(stderr, "getPhysicalOutputMode()\n");
    fflush(stderr);
#endif

    getCtl(info, play.port);

    if (info.play.port & AUDIO_HEADPHONE)
        mode |= AuDeviceOutputModeHeadphone;

    if (info.play.port & AUDIO_SPEAKER)
        mode |= AuDeviceOutputModeSpeaker;

    if (info.play.port & AUDIO_LINE_OUT)
        mode |= AuDeviceOutputModeLineOut;

    return mode;
}

/* callback */
static void
setPhysicalOutputMode(lineMode)
AuUint8 lineMode;
{
#ifdef DEBUGLOG
    fprintf(stderr, "setPhysicalOutputMode(=%d)\n", lineMode);
    fflush(stderr);
#endif

    if (name_of_physical_device == name_am79c30) {
        /* Must implement some kind of a toggle in this case.
           (One and only one behavior.) */

        /* We absolutely must do this before changing
           syncAudioInfo.  */
        AuUint8 oldLineMode = getPhysicalOutputMode();

        if (lineMode & ~oldLineMode)
            lineMode &= ~oldLineMode;
    }
#ifdef SYNC_PROCESS_ENABLED
    {
        AuBlock l = AuBlockAudio();
#endif

        /* A final value of zero is allowed for output (play).  */
        /* Any number of bits can be set.  */
        syncAudioInfo.play.port = 0;

        if (lineMode & AuDeviceOutputModeHeadphone)
            syncAudioInfo.play.port |= AUDIO_HEADPHONE;

        if (lineMode & AuDeviceOutputModeSpeaker)
            syncAudioInfo.play.port |= AUDIO_SPEAKER;

        if (lineMode & AuDeviceOutputModeLineOut)
            syncAudioInfo.play.port |= AUDIO_LINE_OUT;

        syncAudioInfo.play.port &= availOutputModes;

#ifdef SYNC_PROCESS_ENABLED
        AuUnBlockAudio(l);
    }
#endif

    setAudioCtlInfo();
}

/* callback */
static AuFixedPoint
getPhysicalInputGain()
{
    audio_info_t info;
    unsigned int g;

#ifdef DEBUGLOG
    fprintf(stderr, "getPhysicalInputGain()\n");
    fflush(stderr);
#endif

    getCtl(info, record.gain);
    g = info.record.gain;

    /* This little hack helps get/map/round up/map/set stability.
       Don't ask.  */
    if (is_cs4231_or_dbri && (g >= 50) && (g < 255))
        g -= 5;

    return gain255togain100(g);
}

/* callback */
static AuUint8
getPhysicalInputMode()
{
    AuUint8 mode = 0;
    audio_info_t info;

#ifdef DEBUGLOG
    fprintf(stderr, "getPhysicalInputMode()\n");
    fflush(stderr);
#endif

    getCtl(info, record.port);

    if (info.record.port & AUDIO_MICROPHONE)
        mode |= AuDeviceLineModeHigh;

    if (info.record.port & AUDIO_LINE_IN)
        mode |= AuDeviceLineModeLow;

#ifdef UNCOMMENT_THIS_WHEN_NAS_SUPPORTS_IT
    if (info.record.port & AUDIO_INTERNAL_CD_IN)
        mode |= AuDeviceLineModeInternalCD;
#endif

    return mode;
}

/* callback */
static void
setPhysicalInputGainAndLineMode(gain, lineMode)
AuFixedPoint gain;
AuUint8 lineMode;
{
    AuUint32 newInputLineMode;

#ifdef DEBUGLOG
    fprintf(stderr,
            "setPhysicalInputGainAndLineMode(gain=%04x.%04x, lineMode=%u)\n",
            gain >> 16, gain & 0xffff, lineMode);
    fflush(stderr);
#endif

    syncAudioInfo.record.gain = gain100togain255(gain);

    /* one and only one bit must be set */
    if (lineMode == AuDeviceLineModeHigh)
        newInputLineMode = AUDIO_MICROPHONE;
    else if (lineMode == AuDeviceLineModeLow)
        newInputLineMode = AUDIO_LINE_IN;
#ifdef UNCOMMENT_THIS_WHEN_NAS_SUPPORTS_IT
    else if (lineMode == AuDeviceLineModeInternalCD)
        newInputLineMode = AUDIO_INTERNAL_CD_IN;
#endif
    else
        newInputLineMode = 0;

#if 0
    /* A value of zero is rejected by some drivers, so don't even try it. */
    /* XXX - Really?  Doesn't matter since zero does not even get here!  */
    if (newInputLineMode &= availInputModes)
#endif
        syncAudioInfo.record.port = newInputLineMode;

    setAudioCtlInfo();
}

/* A zero-length write() triggers a SIGPOLL. */
#define trigger() \
        write(devAudio, emptyOutput, 0)
#define triggerIfPending() \
        do { \
                if (pendingTrigger) { \
                        trigger(); \
                        pendingTrigger = AuFalse; \
                } \
        } while (0)
#ifdef REVERSE_WRITE
#define write0(buf, n) \
        do { triggerIfPending(); write(devAudio, buf, n); } while (0)
#else
#ifndef DELAYED_TRIGGER
#define write0(buf, n) \
        do { write(devAudio, buf, n); triggerIfPending(); } while (0)
#else
#define write0(buf, n) \
        do { write(devAudio, buf, n); delayedTrigger = AuTrue; } while (0)
#endif
#endif

/* Warning:  this function must be called between Au{Block,UnBlock}Audio,
 *   which is already the case in a BSD signal handler.  */
static void
writeEmptyOutput()
{
#ifndef BSD_SIGNALS
    AuBlock l = AuBlockAudio();
#endif

#ifdef DEBUGLOG
    fprintf(stderr, "writeEmptyOutput(bufSize=%d)\n", bufSize);
    fflush(stderr);
#endif

    write0(emptyOutput, bufSize);

#ifndef BSD_SIGNALS
    AuUnBlockAudio(l);
#endif
}

/* callback */
static void
enableProcessFlow()
{
    AuBlock l;

#ifdef DEBUGLOG
    fprintf(stderr, "\nenableProcessFlow()\n");
    fflush(stderr);
#endif

    if (relinquish_device)
        openDevice(AuTrue);
    ioctl(devAudio, I_FLUSH, FLUSHRW);  /* flush pending io */
    signalEnabled = AuTrue;
    ioctl(devAudioCtl, I_SETSIG, S_MSG);        /* enable signal */
    updateHardware();
    /* XXX - Shouldn't this be done only one time when audioctl is
       opened? */
    l = AuBlockAudio();
#if defined(REVERSE_WRITE) && defined(WRITE_EMPTY_ENABLE)
    pendingTrigger = AuTrue;
    writeEmptyOutput();
#else
#ifdef WRITE_EMPTY_ENABLE
    write(devAudio, emptyOutput,
          getenv("NAS_EMPTY_SIZE") ? atoi(getenv("NAS_EMPTY_SIZE")) :
          bufSize);
#endif
    trigger();                  /* a SIGPOLL. */
#endif
    AuUnBlockAudio(l);
}

/* callback */
static void
disableProcessFlow()
{
#ifdef DEBUGLOG
    fprintf(stderr, "disableProcessFlow()\n");
    fflush(stderr);
#endif

    signalEnabled = AuFalse;
    ioctl(devAudioCtl, I_SETSIG, 0);    /* disable signal */

#if 0                           /* this seems to cause problems on some
                                   sun kernels/sound drivers */
    ioctl(devAudio, AUDIO_DRAIN, 0);    /* drain everything out */
#endif

    if (relinquish_device)
        closeDevice();
}

/* for CS4231 and dbri */
/* Warning:  this function must be called between Au{Block,UnBlock}Audio,
 *   which is already the case in a BSD signal handler.  */
static void
writeOutput(p, n)
AuInt16 *p;
unsigned int n;
{
#ifndef BSD_SIGNALS
    AuBlock l = AuBlockAudio();
#endif

#ifdef DEBUGLOG
    fprintf(stderr, "writeOutput(n=%d, n*4=%d)\n", n, n << 2);
    fflush(stderr);
#endif

    /*
     * The sbpro can only be opened for reading or for writing, not both.
     */

    if (!(devAudioMode == O_RDWR || devAudioMode == O_WRONLY)) {
        closeDevice();
        devAudioMode = O_WRONLY;
        openDevice(1);
    }


    write0(p, n << 2);

#ifndef BSD_SIGNALS
    AuUnBlockAudio(l);
#endif
}

/* for am79c30 */
/* Warning:  this function must be called between Au{Block,UnBlock}Audio,
 *   which is already the case in a BSD signal handler.  */
static void
writePhysicalOutput(p, n)
AuInt16 *p;
unsigned int n;
{
#ifndef BSD_SIGNALS
    AuBlock l;
#endif

#ifdef DEBUGLOG
    fprintf(stderr, "writePhysicalOutput(n=%d)\n", n);
    fflush(stderr);
#endif

    AuNativeToULAW8(p, 1, n);
#ifndef BSD_SIGNALS
    l = AuBlockAudio();
#endif

    write0(p, n);

#ifndef BSD_SIGNALS
    AuUnBlockAudio(l);
#endif
}

/* for CS4231 and dbri */
static void
writeStereoOutput()
{
    writeOutput(auOutputStereo, *stereoSamples);
}

/* for am79c30 */
static void
writePhysicalOutputsStereo()
{
    AuInt32 i;
    AuInt16 *s, *m;

    s = (AuInt16 *) auOutputStereo;
    m = (AuInt16 *) auOutputMono;

    for (i = 0; i < *stereoSamples; i++, s += 2)
        *m++ = (s[0] + s[1]) >> 1;

    writePhysicalOutput(auOutputMono, *stereoSamples);
}

/* for CS4231 and dbri */
static void
writeMonoOutput()
{
    AuInt16 *m, *p;
    int i;

    m = (AuInt16 *) auOutputMono;
    p = (AuInt16 *) auOutputStereo;

    for (i = 0; i < *monoSamples; i++) {
        *p++ = *m;
        *p++ = *m++;
    }

    writeOutput(auOutputStereo, *monoSamples);
}

/* for am79c30 */
static void
writePhysicalOutputsMono()
{
    writePhysicalOutput(auOutputMono, *monoSamples);
}

/* for CS4231 and dbri */
static void
writeAllOutputs()
{
    AuInt16 *l, *r, *m, *s, *p;
    int i;
    unsigned int n;

    l = (AuInt16 *) auOutputLeft;
    r = (AuInt16 *) auOutputRight;
    m = (AuInt16 *) auOutputMono;
    s = p = (AuInt16 *) auOutputStereo;
    n = aumax(aumax(*monoSamples, *stereoSamples),
              aumax(*leftSamples, *rightSamples));

    /* XXX - This assumes that any non participating flow has null value;
       true? */
    for (i = 0; i < n; i++) {
#ifndef ADD_OUTPUTS
        *p++ = ((*l++ + *m + *s++) * theAverage) >> 16;
        *p++ = ((*r++ + *m++ + *s++) * theAverage) >> 16;
#else
        *p++ = (*l++ + *m + *s++);
        *p++ = (*r++ + *m++ + *s++);
#endif
    }

    writeOutput(auOutputStereo, n);
}

/* for am79c30 */
static void
writePhysicalOutputsBoth()
{
    AuInt32 i;
    AuInt16 *s, *m;
    AuUint32 n;

    s = (AuInt16 *) auOutputStereo;
    m = (AuInt16 *) auOutputMono;
    n = aumax(*monoSamples, *stereoSamples);

#ifndef ADD_OUTPUTS
    for (i = 0; i < n; i++, s += 2, m++)
        /* XXX - That's not right, conceptually. */
        /* beware: can't put m++ on this line because of
           unknown order of eval */
        *m = ((s[0] + s[1] + *m) * 0x5555) >> 16;
#else
    for (i = 0; i < n; i++, s += 2)
        *m++ += (s[0] + s[1]) >> 1;
#endif

    writeOutput(auOutputMono, n);
}

/* callback */
static void
readPhysicalInputs()
{
#ifdef DEBUGLOG
    fprintf(stderr, "readPhysicalInputs()\n");
    fflush(stderr);
#endif


    /*
     * The sbpro can only be opened for reading or for writing, not both.
     */

    if (!(devAudioMode == O_RDWR || devAudioMode == O_RDONLY)) {
        closeDevice();
        devAudioMode = O_RDONLY;
        openDevice(1);
    }

    read(devAudio, auInput, bufSize);

    if (!is_cs4231_or_dbri)
        AuULAW8ToNative(auInput, 1, auMinibufSamples);
}

/* callback */
/* for am79c30 */
static void
setWritePhysicalOutputFunction(flow, funct)
CompiledFlowPtr flow;
void (**funct) ();
{
    AuUint32 mask = flow->physicalDeviceMask;

#ifdef DEBUGLOG
    fprintf(stderr, "setWritePhysicalOutputFunction()\n");
    fflush(stderr);
#endif

    if ((mask & (PhysicalOutputMono | PhysicalOutputStereo)) ==
        (PhysicalOutputMono | PhysicalOutputStereo))
        *funct = writePhysicalOutputsBoth;
    else if (mask & PhysicalOutputMono)
        *funct = writePhysicalOutputsMono;
    else if (mask & PhysicalOutputStereo)
        *funct = writePhysicalOutputsStereo;
    else
        *funct = writeEmptyOutput;
}

/* callback */
/* for CS4231 and dbri */
static void
setWriteOutputFunction(flow, funct)
CompiledFlowPtr flow;
void (**funct) ();
{
    AuUint32 mask = flow->physicalDeviceMask & AllPhysicalOutputs;

#ifdef DEBUGLOG
    fprintf(stderr, "setWriteOutputFunction()\n");
    fflush(stderr);
#endif

    if (mask)
        if (mask == PhysicalOutputMono)
            *funct = writeMonoOutput;
        else if (mask == PhysicalOutputStereo)
            *funct = writeStereoOutput;
        else {
#ifndef ADD_OUTPUTS
            int both;

            theAverage = 0x10000;

            both = (mask & (PhysicalOutputLeft |
                            PhysicalOutputRight)) ? 1 : 0;

            if (mask & PhysicalOutputMono)
                both++;

            if (mask & PhysicalOutputStereo)
                both++;

            if (both > 1)
                theAverage /= both;
#endif

            *funct = writeAllOutputs;
    } else
        *funct = writeEmptyOutput;
}

/* signal handler */
#ifdef DEBUGLOG
#include <sys/time.h>
#endif
static void
processAudioSignal(sig)
int sig;
{
    int i;
#ifdef DEBUGLOG
    static struct timeval tv0;
    struct timeval tv1, tv2, tv3;
    long ds1, du1, ds2, du2, ds3, du3;

    fprintf(stderr, "processAudioSignal...\n");
    fflush(stderr);

    gettimeofday(&tv1, 0);
#endif /* DEBUGLOG */

    updateHardware();

#ifdef DEBUGLOG
    gettimeofday(&tv2, 0);
#endif /* DEBUGLOG */

    pendingTrigger = AuFalse;
    for (i = 0; i < chunksPerSignal - 1; i++)
        AuProcessData();

    pendingTrigger = AuTrue;
    AuProcessData();

#if defined(DELAYED_TRIGGER) && !defined(REVERSE_WRITE)
    if (delayedTrigger) {
        /* Here's the very reason delaying this is useful.
           Don't do it if AuProcessData() called
           disableProcessFlow() between the write and now. */
        if (signalEnabled)
            trigger();          /* a SIGPOLL. */

        delayedTrigger = AuFalse;
    }
#endif /* DELAYED_TRIGGER && !REVERSE_WRITE */

#ifdef DEBUGLOG
    gettimeofday(&tv3, 0);

#define tv_diff(tv_a, tv_b, ds, du) \
        do { \
                ds = tv_a.tv_sec - tv_b.tv_sec; \
                du = tv_a.tv_usec - tv_b.tv_usec; \
                if (du < 0) { \
                        --ds; \
                        du += 1000000L; \
                } \
        } while (0)

    tv_diff(tv1, tv0, ds1, du1);
    tv_diff(tv2, tv1, ds2, du2);
    tv_diff(tv3, tv2, ds3, du3);

#undef tv_diff

    tv0 = tv1;

    fprintf(stderr,
            "...processAudioSignal [%ld.%06ld %ld.%06ld %ld.%06ld]\n",
            ds1, du1, ds2, du2, ds3, du3);
    fflush(stderr);
#endif /* DEBUGLOG */
}

/* callback */
/* for CS4231 and dbri */
static AuUint32
setSampleRate(rate)
AuUint32 rate;
{
    int i;
    AuUint32 closestRate;
    static AuUint32 rates[] = {
        /* 5510, 6620, */
        8000, 9600, 11025, 16000, 18900, 22050,
        /* 27420, */
        32000,
        /* 33075, */
        37800, 44100, 48000
    };

    closestRate = 48000;

    for (i = 0; i < sizeof(rates) / sizeof(rates[0]); i++)
        if ((rates[i] >= rate) && (rates[i] < closestRate))
            closestRate = rates[i];

    if (closestRate != sampleRate) {
        sampleRate = closestRate;
        updateSampleRate = AuTrue;
    }

    chunksPerSignal = sampleRate / SIGNAL_RATE / MINIBUF_SAMPLES;

#ifdef DEBUGLOG
    fprintf(stderr, "setSampleRate(rate=%d) --> %d\n", rate, closestRate);
    fflush(stderr);
#endif

    return closestRate;
}

#define PhysicalOneTrackBufferSize \
        PAD4(auMinibufSamples * auNativeBytesPerSample * 1)
#define PhysicalTwoTrackBufferSize \
        PAD4(auMinibufSamples * auNativeBytesPerSample * 2)

AuBool
AuInitPhysicalDevices()
{
    int open_for_business;
    static AuUint8 *physicalBuffers;
    AuUint32 physicalBuffersSize;
    audio_info_t info;
    extern AuUint32 auPhysicalOutputBuffersSize;
    extern AuUint8 *auPhysicalOutputBuffers;
    char *nas_device_policy;

#ifdef DEBUGLOG
    fprintf(stderr, "AuInitPhysicalDevices()\n");
    fflush(stderr);
#endif

    if (VENDOR_STRING) {
        aufree(VENDOR_STRING);
        VENDOR_STRING = (char *) 0;
    }

    if (NasConfig.DoDeviceRelease) {
        relinquish_device = AuTrue;
        if (NasConfig.DoDebug)
            osLogMsg("Init: will close device when finished with stream.\n");
    } else {
        relinquish_device = AuFalse;
        if (NasConfig.DoDebug)
            osLogMsg("Init: will open device exclusively.\n");
    }

    if (devAudio == -1) {
        audio_device_t type;
        const char *device = NULL;
        char *devicectl = NULL;

        /* pebl: Check whether a pseudo device is used, else try the normal one */
        if ((device = getenv("AUDIODEV")) == NULL)
            device = default_device;

#ifdef DEBUGLOG
        fprintf(stderr, "Trying device %s\n", device);
        fflush(stderr);
#endif

        devAudio = open(device, devAudioMode);
        if (devAudio == -1 && errno == EINVAL && devAudioMode == O_RDWR) {
            devAudioMode = O_WRONLY;
            devAudio = open(device, devAudioMode);
        }


        /* pebl: We cannot just concat "ctl" on variable device, so
           make a copy and concat "ctl".  (free it again) */
        if (!(devicectl = (char *) aualloc(strlen(device) +
                                           strlen("ctl") + 1)))
            return AuFalse;
        sprintf(devicectl, "%sctl", device);

        open_for_business = (devAudio != -1 &&
#ifdef SEPARATE_CTLS
                             (devAudioCtl2 = open(devicectl, O_RDWR)) != -1
                             &&
#endif
                             (devAudioCtl =
                              open(devicectl, O_RDWR)) != -1);

        aufree(devicectl);

        if (open_for_business) {
#ifndef AUDIO_GETDEV
            name_of_physical_device = name_unknown;
#else /* defined AUDIO_GETDEV */
            if ((open_for_business =
                 (ioctl(devAudio, AUDIO_GETDEV, &type) != -1))) {
                if (IS_AMD(type))
                    name_of_physical_device = name_am79c30;
                else if (IS_CS4231(type))
                    name_of_physical_device = name_CS4231;
                else if (IS_DBRI(type))
                    name_of_physical_device = name_dbri;
                else
                    name_of_physical_device = name_unknown;
            }
#endif /* defined AUDIO_GETDEV */
        }

        if (!open_for_business) {
            if (devAudio != -1)
                close(devAudio);
            if (devAudioCtl != -1)
                close(devAudioCtl);
#ifdef SEPARATE_CTLS
            if (devAudioCtl2 != -1)
                close(devAudioCtl2);
#endif
            devAudio = devAudioCtl = -1;
            name_of_physical_device = 0;
            return AuFalse;
        }
    }

    if (!(VENDOR_STRING = (char *) aualloc(strlen(SUN_VENDOR) +
                                           strlen(name_of_physical_device)
                                           - 1)))
        return AuFalse;

    sprintf(VENDOR_STRING, SUN_VENDOR, name_of_physical_device);

    if (physicalBuffers) {
        aufree(physicalBuffers);
        physicalBuffers = 0;
    }

    if (emptyOutput) {
        aufree(emptyOutput);
        emptyOutput = 0;
    }

    is_cs4231_or_dbri =
            (name_of_physical_device == name_CS4231 ||
             name_of_physical_device == name_dbri);

    auMaxSampleRate = is_cs4231_or_dbri ? 48000 : 8000;

    auMinibufSamples = MINIBUF_SAMPLES;

    /* the output buffers need to be twice as large for output
       range checking */
    physicalBuffersSize = (PhysicalOneTrackBufferSize * 2 +     /* mono output */
                           PhysicalTwoTrackBufferSize * 2);     /* stereo output */

    if (is_cs4231_or_dbri) {
        physicalBuffersSize += (PhysicalTwoTrackBufferSize +    /* stereo input */
                                PhysicalOneTrackBufferSize * 2 +        /* left output */
                                PhysicalOneTrackBufferSize * 2);        /* right output */
        bufSize = MINIBUF_SAMPLES * 2 * 2;      /* stereo, 16 bits */
    } else {
        physicalBuffersSize += PhysicalTwoTrackBufferSize;      /* mono input */
        bufSize = MINIBUF_SAMPLES;      /* mono, 8 bits */
    }

    if (!(emptyOutput = (AuUint8 *) aualloc(bufSize)))
        return AuFalse;

    auset(emptyOutput, is_cs4231_or_dbri ? 0 : 0xff, bufSize);

    if (!(physicalBuffers = (AuUint8 *) aualloc(physicalBuffersSize)))
        return AuFalse;

    auInput = physicalBuffers;

    if (is_cs4231_or_dbri) {
        auOutputMono = auInput + PhysicalTwoTrackBufferSize;
        auOutputLeft = auOutputMono + 2 * PhysicalOneTrackBufferSize;
        auOutputRight = auOutputLeft + 2 * PhysicalOneTrackBufferSize;
        auOutputStereo = auOutputRight + 2 * PhysicalOneTrackBufferSize;

        auPhysicalOutputBuffersSize =
                physicalBuffersSize - PhysicalTwoTrackBufferSize;
    } else {
        auOutputMono = auInput + PhysicalOneTrackBufferSize;
        auOutputStereo = auOutputMono + 2 * PhysicalOneTrackBufferSize;

        auPhysicalOutputBuffersSize =
                physicalBuffersSize - PhysicalTwoTrackBufferSize;
    }

    auPhysicalOutputBuffers = auOutputMono;

    signal(SIGPOLL, processAudioSignal);

    AuRegisterCallback(AuCreateServerComponentsCB, createServerComponents);
    AuRegisterCallback(AuSetPhysicalOutputGainCB, setPhysicalOutputGain);
    AuRegisterCallback(AuGetPhysicalOutputGainCB, getPhysicalOutputGain);
    AuRegisterCallback(AuGetPhysicalOutputModeCB, getPhysicalOutputMode);
    AuRegisterCallback(AuSetPhysicalOutputModeCB, setPhysicalOutputMode);
    AuRegisterCallback(AuGetPhysicalFeedbackGainCB,
                       getPhysicalFeedbackGain);
    AuRegisterCallback(AuSetPhysicalFeedbackGainCB,
                       setPhysicalFeedbackGain);
    AuRegisterCallback(AuSetPhysicalInputGainAndLineModeCB,
                       setPhysicalInputGainAndLineMode);
    AuRegisterCallback(AuGetPhysicalInputGainCB, getPhysicalInputGain);
    AuRegisterCallback(AuGetPhysicalInputModeCB, getPhysicalInputMode);
    AuRegisterCallback(AuEnableProcessFlowCB, enableProcessFlow);
    AuRegisterCallback(AuDisableProcessFlowCB, disableProcessFlow);
    AuRegisterCallback(AuReadPhysicalInputsCB, readPhysicalInputs);

    if (is_cs4231_or_dbri) {
        AuRegisterCallback(AuSetWritePhysicalOutputFunctionCB,
                           setWriteOutputFunction);
        AuRegisterCallback(AuSetSampleRateCB, setSampleRate);
    } else {
        AuRegisterCallback(AuSetWritePhysicalOutputFunctionCB,
                           setWritePhysicalOutputFunction);
    }

    ioctl(devAudioCtl, AUDIO_GETINFO, &info);
    availInputModes = info.record.avail_ports;
    availOutputModes = info.play.avail_ports;
    sampleRate = info.play.sample_rate; /* XXX */
    chunksPerSignal = sampleRate / SIGNAL_RATE / MINIBUF_SAMPLES;

    AUDIO_INITINFO(&audioInfo);
    /* We only need to setup fields that differ from the open()
       defaults.  */
    if (is_cs4231_or_dbri) {
        audioInfo.play.encoding
                = audioInfo.record.encoding = AUDIO_ENCODING_LINEAR;
        audioInfo.play.precision = audioInfo.record.precision = 16;
        audioInfo.play.channels = audioInfo.record.channels = 2;

        aucopy(&audioInfo, &info, sizeof(audio_info_t));
        ioctl(devAudio, AUDIO_SETINFO, &info);
    }

    AUDIO_INITINFO(&syncAudioInfo);

    /* bogus resource so we can have a cleanup function at server reset */
    AddResource(FakeClientID(SERVER_CLIENT),
                CreateNewResourceType(serverReset), 0);

    if (relinquish_device)
        closeDevice();

    return AuTrue;
}
