/**
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
 * $Id: auhpux.c 226 2006-08-31 00:46:14Z jon $
 * $NCDId: @(#)auhpux.c,v 1.3 1996/04/24 17:18:13 greg Exp $
 */

/* Supplied by : William J Hunter (III), Email : whunter@melpar.esys.com        */

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

#include <stdio.h>
#include <signal.h>
#include <fcntl.h>
#include <sys/lock.h>
#include <sys/audio.h>
#include <sys/types.h>
#include <sys/time.h>
#include <audio/audio.h>
#include <audio/Aproto.h>
#include <errno.h>

#include "nasconf.h"
#include "misc.h"
#include "dixstruct.h"          /* for RESTYPE */
#include "os.h"                 /* for xalloc/xfree and NULL */
#include "au.h"
#include "aulog.h"

extern void AuProcessData();

static int devAudio = -1, devAudioCtl = -1;
int OutputDevType = AUDIO_OUT_EXTERNAL;

struct audio_describe audio_describe;
struct raw_audio_config raw_params;
struct audio_limits audio_limits;
struct audio_select_thresholds select_thresholds;


static AuUint8 *auOutputMono, *auOutputStereo, *auInputMono, *emptyOutput;

static AuUint32 *monoSamples, *stereoSamples;

static AuInt16 outputGain, inputGain;

static AuUint32 outputMode, inputMode;
static AuBool updateGains;
static AuBool processFlowEnabled;
static AuFixedPoint currentOutputGain;

static AuBool relinquish_device = AuFalse;

extern AuInt32 auMinibufSamples;

char *V_STRING;


#define HPUX_VENDOR     "HPUX /dev/audio"
#define SERVER_CLIENT   0
#define       MINIBUF_SIZE               1024

#define auMinSampleRate (audio_describe.sample_rate[0])
#define auMaxSampleRate (audio_describe.sample_rate[audio_describe.nrates-1])

#define auPhysicalOutputChangableMask                                         \
    (AuCompDeviceGainMask | AuCompDeviceOutputModeMask)

#define auPhysicalOutputValueMask                                              \
    (AuCompCommonAllMasks |                                                    \
     AuCompDeviceMinSampleRateMask |                                           \
     AuCompDeviceMaxSampleRateMask |                                           \
     AuCompDeviceOutputModeMask |                                              \
     AuCompDeviceGainMask |                                                    \
     AuCompDeviceLocationMask |                                                \
     AuCompDeviceChildrenMask)

#define auPhysicalInputChangableMask                                            \
    (AuCompDeviceGainMask | AuCompDeviceLineModeMask)

#define auPhysicalInputValueMask                                               \
    (AuCompCommonAllMasks |                                                    \
     AuCompDeviceMinSampleRateMask |                                           \
     AuCompDeviceMaxSampleRateMask |                                           \
     AuCompDeviceLocationMask |                                                \
     AuCompDeviceGainMask |                                                     \
     AuCompDeviceChildrenMask)


#define auBucketChangableMask   0
#define auBucketValueMask       AuCompBucketAllMasks



#ifndef BUILTIN_BUCKETS
#define NUM_BUILTIN_BUCKETS     0
#else /* BUILTIN_BUCKETS */
static struct {
    AuUint8 *data, format, numTracks;
    AuUint32 sampleRate, numSamples;
    char **comment;
} builtinBuckets[] = {
boingSamples,
            boingFormat,
            boingNumTracks,
            boingSampleRate, boingNumSamples, &boingComment,};



#define NUM_BUILTIN_BUCKETS                                                    \
    (sizeof(builtinBuckets) / sizeof(builtinBuckets[0]))
#endif /* BUILTIN_BUCKETS */


 /*JET*/ static void DumpDeviceStatus(struct audio_status *astat);



/*----------------------------------------------------------*/

static int
createServerComponents(auServerDeviceListSize, auServerBucketListSize,
                       auServerRadioListSize, auServerMinRate,
                       auServerMaxRate)
AuUint32 *auServerDeviceListSize,
        *auServerBucketListSize,
        *auServerRadioListSize, *auServerMinRate, *auServerMaxRate;
{
    AuDeviceID stereo, mono;
    ComponentPtr d, *p;

    extern RESTYPE auComponentType;
    extern ComponentPtr *auServerDevices,       /* array of devices */
       *auServerBuckets,        /* array of server owned
                                 * buckets */
       *auServerRadios,         /* array of server owned
                                 * radios */
        auDevices,              /* list of all devices */
        auBuckets,              /* list of all buckets */
        auRadios;               /* list of all radios */
    extern AuUint32 auNumServerDevices, /* number of devices */
        auNumActions,           /* number of defined actions */
        auNumServerBuckets,     /* number of server owned
                                 * buckets */
        auNumServerRadios;      /* number of server owned
                                 * radios */

    *auServerMinRate = auMinSampleRate;
    *auServerMaxRate = auMaxSampleRate;

    auNumServerDevices = *auServerDeviceListSize =
            *auServerBucketListSize = *auServerRadioListSize = 0;

    stereo = FakeClientID(SERVER_CLIENT);
    mono = FakeClientID(SERVER_CLIENT);

    AU_ALLOC_DEVICE(d, 1, 0);
    d->id = mono;
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
    d->location =
            AuDeviceLocationCenterMask | AuDeviceLocationInternalMask;
    d->numChildren = 0;
    d->minibuf = auOutputMono;
    d->minibufSize = auMinibufSamples * auNativeBytesPerSample *
            d->numTracks;
    d->physicalDeviceMask = PhysicalOutputMono;
    monoSamples = &d->minibufSamples;
    AU_ADD_DEVICE(d);

    AU_ALLOC_DEVICE(d, 2, 1);
    d->id = stereo;
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
    d->location =
            AuDeviceLocationCenterMask | AuDeviceLocationInternalMask;
    d->numChildren = 1;
    d->children = (AuID *) ((AuUint8 *) d + PAD4(sizeof(ComponentRec)));
    d->childSwap = (char *) (d->children + d->numChildren);
    d->children[0] = mono;
    d->minibuf = auOutputStereo;
    d->minibufSize = auMinibufSamples * auNativeBytesPerSample *
            d->numTracks;
    d->physicalDeviceMask = PhysicalOutputStereo;
    stereoSamples = &d->minibufSamples;
    AU_ADD_DEVICE(d);

    AU_ALLOC_DEVICE(d, 1, 0);
    d->id = FakeClientID(SERVER_CLIENT);
    d->changableMask = auPhysicalInputChangableMask;
    d->valueMask = auPhysicalInputValueMask;
    d->kind = AuComponentKindPhysicalInput;
    d->use = AuComponentUseImportMask;
    d->access = AuAccessImportMask | AuAccessListMask;
    d->format = auNativeFormat;
    d->numTracks = 1;
    d->description.type = AuStringLatin1;
    d->description.string = "Mono Channel Input";
    d->description.len = strlen(d->description.string);
    d->minSampleRate = auMinSampleRate;
    d->maxSampleRate = auMaxSampleRate;
    d->location = AuDeviceLocationRightMask | AuDeviceLocationLeftMask | AuDeviceLocationExternalMask;  /* should extern mask be here ? */
    d->numChildren = 0;
    d->gain = AuFixedPointFromFraction(inputGain * 100, AUDIO_MAX_GAIN);
     /**/ d->lineMode = inputMode == AUDIO_IN_MIKE ? AuDeviceLineModeHigh :
            AuDeviceLineModeLow;
    d->minibuf = auInputMono;
    d->minibufSize = auMinibufSamples * auNativeBytesPerSample *
            d->numTracks;
    d->physicalDeviceMask = PhysicalInputMono;
    AU_ADD_DEVICE(d);

    /* set the array of server devices */
    if (!(auServerDevices =
          (ComponentPtr *) aualloc(sizeof(ComponentPtr) *
                                   auNumServerDevices)))
        return AuBadAlloc;

    p = auServerDevices;
    d = auDevices;

    while (d) {
        *p++ = d;
        d = d->next;
    }

#ifdef BUILTIN_BUCKETS
    for (i = 0; i < NUM_BUILTIN_BUCKETS; i++) {
        ALLOC_BUCKET(d);
        d->data = builtinBuckets[i].data;
        d->format = builtinBuckets[i].format;
        d->numTracks = builtinBuckets[i].numTracks;
        d->sampleRate = builtinBuckets[i].sampleRate;
        d->numSamples = builtinBuckets[i].numSamples;
        d->description.string = *builtinBuckets[i].comment;

        d->id = FakeClientID(SERVER_CLIENT);
        d->changableMask = auBucketChangableMask;
        d->valueMask = auBucketValueMask;
        d->kind = AuComponentKindBucket;
        d->use = AuComponentUseImportMask;
        d->access = AuAccessImportMask | AuAccessListMask;
        d->description.type = AuStringLatin1;
        d->description.len = strlen(d->description.string);
        d->minibufSize = auMinibufSamples * auNativeBytesPerSample *
                d->numTracks;
        d->physicalDeviceMask = NotAPhysicalDevice;
        d->dataSize =
                d->numSamples * sizeofFormat(d->format) * d->numTracks;
        d->dataEnd = d->data + d->dataSize;
        d->read = d->write = d->data;
        d->destroyed = AuFalse;
        ADD_BUCKET(d);
    }

    /* set the array of server buckets */
    if (!(auServerBuckets = (ComponentPtr *) aualloc(sizeof(ComponentPtr) *
                                                     auNumServerBuckets)))
        return AuBadAlloc;

    p = auServerBuckets;
    d = auBuckets;

    while (d) {
        *p++ = d;
        d = d->next;
    }
#endif /* BUILTIN_BUCKETS */

    return AuSuccess;
}

/*----------------------------------------------------------*/

/* init the hardware after an open... */
static AuBool
InitDevice()
{
    int temp_int, input;

    if (NasConfig.DoDebug)
        osLogMsg("InitDevice(): starting\n");

    if (devAudio == -1) {
        if (NasConfig.DoDebug)
            osLogMsg("InitDevice(): devAudio not open - failing.\n");

        return (AuFalse);
    }

    /* JET - reset Device */
    if (ioctl(devAudio,
              AUDIO_RESET, (RESET_RX_BUF | RESET_TX_BUF | RESET_RX_OVF |
                            RESET_TX_UNF)) == -1) {
        osLogMsg("ERROR: AUDIO_RESET: %s\n", strerror(errno));
    } else {
        if (NasConfig.DoDebug > 5)
            osLogMsg("AUDIO_RESET Done.\n");
    }

#ifndef NULL_AUDIO_DEVICE
    if (ioctl(devAudio, AUDIO_DESCRIBE, &audio_describe) == -1)
        osLogMsg("ERROR: AUDIO_DESCRIBE: %s\n", strerror(errno));
    errno = 0;

    if (ioctl(devAudio, AUDIO_RAW_GET_PARAMS, &raw_params) == -1)
        osLogMsg("ERROR: AUDIO_RAW_GET_PARAMS: %s\n", strerror(errno));
    errno = 0;
#endif

#ifndef NULL_AUDIO_DEVICE
    if (ioctl(devAudio, AUDIO_GET_LIMITS, &audio_limits) == -1)
        osLogMsg("ERROR: AUDIO_GET_LIMITS: %s\n", strerror(errno));
    errno = 0;

    /*
     * Set buffer sizes
     */
    if (ioctl(devAudio, AUDIO_SET_RXBUFSIZE, (8192 * 2)) == -1)
        osLogMsg("ERROR: AUDIO_SET_RXBUFSIZE: %s\n", strerror(errno));
    errno = 0;
    if (ioctl(devAudio, AUDIO_GET_RXBUFSIZE, &temp_int) == -1)
        osLogMsg("ERROR: AUDIO_GET_RXBUFSIZE: %s\n", strerror(errno));
    errno = 0;

    if (NasConfig.DoDebug)
        osLogMsg("RX buffer size = %d\n", temp_int);

    if (ioctl(devAudio, AUDIO_SET_TXBUFSIZE, (8192 * 2)) == -1)
        osLogMsg("ERROR: AUDIO_SET_TXBUFSIZE: %s\n", strerror(errno));
    errno = 0;

    if (ioctl(devAudio, AUDIO_GET_TXBUFSIZE, &temp_int) == -1)
        osLogMsg("ERROR: AUDIO_GET_TXBUFSIZE: %s\n", strerror(errno));

    errno = 0;

    if (NasConfig.DoDebug)
        osLogMsg("TX buffer size = %d\n", temp_int);

#endif /* NULL_AUDIO_DEVICE */

    select_thresholds.read_threshold = (MINIBUF_SIZE);
    select_thresholds.write_threshold = (MINIBUF_SIZE);
#ifndef NULL_AUDIO_DEVICE
    if (ioctl(devAudio, AUDIO_SET_SEL_THRESHOLD, &select_thresholds) == -1)
        osLogMsg("ERROR: AUDIO_SET_SEL_THRESHOLD: %s\n", strerror(errno));
    errno = 0;

    if (ioctl(devAudio, AUDIO_GET_SEL_THRESHOLD, &select_thresholds) == -1)
        osLogMsg("ERROR: AUDIO_GET_SEL_THRESHOLD: %s\n", strerror(errno));
    errno = 0;

    if (NasConfig.DoDebug) {
        osLogMsg("Read threshold: %d\n", select_thresholds.read_threshold);
        osLogMsg("Write threshold: %d\n",
                 select_thresholds.write_threshold);
    }
#endif /* NULL_AUDIO_DEVICE */

    /*
     * Set to NAS format
     */
#ifndef NULL_AUDIO_DEVICE
    if (ioctl(devAudio, AUDIO_SET_DATA_FORMAT, AUDIO_FORMAT_LINEAR16BIT) ==
        -1)
        osLogMsg("ERROR: AUDIO_SET_DATA_FORMAT: %s\n", strerror(errno));

    errno = 0;
    if (ioctl(devAudio, AUDIO_GET_DATA_FORMAT, &temp_int) == -1)
        osLogMsg("ERROR: AUDIO_GET_DATA_FORMAT: %s\n", strerror(errno));
    errno = 0;
#endif
    if (NasConfig.DoDebug)
        osLogMsg("Audio Format = %d (Lin 16 = %d)\n",
                 temp_int, AUDIO_FORMAT_LINEAR16BIT);

    /*
     * Send output to headphone jack
     * and input to mike jack
     */
#ifndef NULL_AUDIO_DEVICE

    if (ioctl(devAudio, AUDIO_SET_OUTPUT, OutputDevType) == -1)
        osLogMsg("ERROR: AUDIO_SET_OUTPUT: %s\n", strerror(errno));

    errno = 0;
    if (ioctl(devAudio, AUDIO_GET_OUTPUT, &temp_int) == -1)
        osLogMsg("ERROR: AUDIO_GET_OUTPUT: %s\n", strerror(errno));
    errno = 0;
    if (ioctl(devAudio, AUDIO_SET_INPUT, AUDIO_IN_MIKE) == -1)
        osLogMsg("ERROR: AUDIO_SET_INPUT: %s\n", strerror(errno));
    errno = 0;

    if (NasConfig.DoDebug)
        osLogMsg("Input Port   (Mike = %d) (Errorno : %d)\n",
                 AUDIO_IN_MIKE, errno);

    if (ioctl(devAudio, AUDIO_GET_INPUT, &input) == -1)
        osLogMsg("ERROR: AUDIO_GET_INPUT: %s\n", strerror(errno));
    errno = 0;
#endif

    if (NasConfig.DoDebug) {
        osLogMsg("Output Port = %d (Headphones = %d)\n", temp_int,
                 AUDIO_OUT_EXTERNAL);

        osLogMsg("Input Port = %d  (Mike = %d) (Errorno : %d)\n", input,
                 AUDIO_IN_MIKE, errno);
    }

    outputMode = temp_int;

    /*
     * Set number of tracks to 2
     */
#ifndef NULL_AUDIO_DEVICE
    if (ioctl(devAudio, AUDIO_SET_CHANNELS, 2) == -1)
        osLogMsg("ERROR: AUDIO_SET_CHANNELS: %s\n", strerror(errno));

    errno = 0;
    if (ioctl(devAudio, AUDIO_GET_CHANNELS, &temp_int) == -1)
        osLogMsg("ERROR: AUDIO_GET_CHANNELS: %s\n", strerror(errno));
    errno = 0;
#endif

    if (NasConfig.DoDebug)
        osLogMsg("Number of channels = %d\n", temp_int);

    if (NasConfig.DoDebug)
        osLogMsg("InitDevice(): ending\n");

}

static AuBool
openDevice(wait)
AuBool wait;
{

    if (devAudioCtl != -1 && devAudio != -1) {
        if (NasConfig.DoDebug)
            osLogMsg("openDevice() Devices already open, returning\n");
        return (AuTrue);
    }

    if (devAudioCtl == -1)
        while ((devAudioCtl = open("/dev/audioCtl", O_RDWR)) == -1 && wait)
            sleep(5);

    if (devAudioCtl != -1) {

        if (devAudio == -1)
            while ((devAudio = open("/dev/audio", O_RDWR)) == -1 && wait)
                sleep(5);

        if (devAudio != -1) {
            InitDevice();
            return AuTrue;
        } else {
            close(devAudioCtl);
        }
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

    if (devAudioCtl != -1) {
        close(devAudioCtl);
        devAudioCtl = -1;
    }
}

static void
BlockUntilClear(AuBool doreset)
{
    int clear = 0;
    struct audio_status status_b;
    void (*oldhandler) (int);

    if (NasConfig.DoDebug) {
        osLogMsg("BlockUntilClear(): entering\n");
    }

    /*
     * Ignore signal
     */
    oldhandler = signal(SIGALRM, SIG_IGN);

    if (relinquish_device) {
        if (NasConfig.DoDebug)
            osLogMsg("BlockUntilClear(): relinquish_device is true, openDevice will be called\n");

        openDevice(AuTrue);
    }


    /*
     * Reset Device
     */
    if (NasConfig.DoDebug > 5) {
        osLogMsg("BlockUntilClear(): dev stat before reset:\n");
        DumpDeviceStatus((struct audio_status *) NULL);
    }
#ifndef NULL_AUDIO_DEVICE
    /*JET - TEST - drain */
    if (ioctl(devAudio, AUDIO_DRAIN, 0) == -1) {
        if (NasConfig.DoDebug)
            osLogMsg("ERROR: AUDIO_DRAIN: %s\n", strerror(errno));
    } else {
        if (NasConfig.DoDebug > 5)
            osLogMsg("AUDIO_DRAIN done\n");
    }

    errno = 0;

    if (doreset == AuTrue) {
        if (ioctl(devAudio,
                  AUDIO_RESET,
                  (RESET_RX_BUF | RESET_TX_BUF | RESET_RX_OVF |
                   RESET_TX_UNF)) == -1) {
            osLogMsg("ERROR: AUDIO_RESET: %s\n", strerror(errno));
        } else {
            if (NasConfig.DoDebug > 5)
                osLogMsg("AUDIO_RESET Done.\n");
        }
        errno = 0;
    }

    do {
        if (ioctl(devAudio, AUDIO_GET_STATUS, &status_b) == -1) {
            osLogMsg("ERROR: AUDIO_GET_STATUS: %s\n", strerror(errno));
            errno = 0;
            break;              /* JET - avoid infinite loop */
        } else {

            if (NasConfig.DoDebug > 5)
                DumpDeviceStatus(&status_b);

            /*JET - more TESTING with DRAIN instead of RESET */
            /*      clear = (status_b.transmit_status == AUDIO_DONE); */

            if (doreset == AuTrue)
                clear = (status_b.transmit_status == AUDIO_DONE);
            else
                clear = (status_b.transmit_buffer_count == 0);

            if (!clear) {
                if (NasConfig.DoDebug)
                    osLogMsg("BlockUntilClear(): Sleeping for one second.\n");
                sleep(1);
            }
        }
    } while (!clear);

#endif

    /* JET - reset sighandler  */

    signal(SIGALRM, oldhandler);
    return;
}

/*----------------------------------------------------------*/

static AuUint32
setSampleRate(rate)
AuUint32 rate;
{
    int i;
    AuUint32 target_rate;
    struct itimerval ntval, otval;
    int timer_us;
    AuBool set_smpl_failed;
    void (*oldhandler) (int);

    /* JET - BLOCK */

    oldhandler = signal(SIGALRM, SIG_IGN);

    if (NasConfig.DoDebug)
        osLogMsg("setSampleRate() calling BlockUntilClear\n");

    BlockUntilClear(AuTrue);

    for (i = 0; i < audio_describe.nrates; i++) {
        if (rate >= audio_describe.sample_rate[i]) {
            target_rate = audio_describe.sample_rate[i];
        }
    }

    if (NasConfig.DoDebug)
        osLogMsg("Setting rate to %d (should be %d)\n", target_rate, rate);

    set_smpl_failed = AuFalse;

#ifndef NULL_AUDIO_DEVICE
    if (ioctl(devAudio, AUDIO_SET_SAMPLE_RATE, target_rate) == -1) {
        osLogMsg("ERROR: AUDIO_SET_SAMPLE_RATE: %s\n", strerror(errno));
        errno = 0;
        set_smpl_failed = AuTrue;
        if (NasConfig.DoDebug)
            osLogMsg("setSampleRate(): leaving timer alone due to failure\n");
    }
#endif

    if (set_smpl_failed == AuFalse) {   /* JET - no point in changing the timer
                                           if the sample rate call failed... */
        /*
         * Reset timer
         */
        timer_us = (auMinibufSamples * 500000) / target_rate;
        if (NasConfig.DoDebug)
            osLogMsg("Setting timer to %dus\n", timer_us);

        ntval.it_interval.tv_sec = 0;
        ntval.it_interval.tv_usec = timer_us;
        ntval.it_value.tv_sec = 0;
        ntval.it_value.tv_usec = timer_us;
        setitimer(ITIMER_REAL, &ntval, &otval);
    }

    signal(SIGALRM, oldhandler);

    return (target_rate);
}

/*----------------------------------------------------------*/

static void
eventPosted()
{
    if (NasConfig.DoDebug > 2)
        osLogMsg("An event has been posted\n");
}

/*----------------------------------------------------------*/

static void
serverReset()
{
    signal(SIGALRM, SIG_IGN);

    if (NasConfig.DoDebug)
        osLogMsg("Server resetting\n");

#ifndef NULL_AUDIO_DEVICE
    if (!relinquish_device)     /* dev will most likly be closed otherwise */
        if (ioctl(devAudio, AUDIO_DRAIN, 0) == -1)      /* drain everything out */
            osLogMsg("ERROR: AUDIO_DRAIN: %s\n", strerror(errno));

    errno = 0;

    if (relinquish_device)
        closeDevice();
#endif

}

/*----------------------------------------------------------*/

/**
  * Gains are mapped thusly:
  *
  *   Software   0 - 49     50 - 100
  *   Hardware   0 - 49     50 - 255
  */
static void
setPhysicalOutputGain(gain)
AuFixedPoint gain;
{
    AuInt16 g = AuFixedPointIntegralAddend(gain);


    if (g < 50)
        outputGain = g;
    else
        /* (gain - 50) * (205 / 50) + 50 */
        outputGain = ((0x41999 * (g - 50)) >> 16) + 50;


    outputGain = g;

    updateGains = AuTrue;
    currentOutputGain = gain;

}

/*----------------------------------------------------------*/

static AuFixedPoint
getPhysicalOutputGain()
{
    return currentOutputGain;
}

/*----------------------------------------------------------*/

static void
setPhysicalOutputMode(lineMode)
AuUint8 lineMode;
{
    int ret;

    if (NasConfig.DoDebug)
        osLogMsg("Setting physical output mode......\n");

    if ((outputMode == AUDIO_OUT_INTERNAL)
        && (lineMode & AuDeviceOutputModeHeadphone)) {
        outputMode = AUDIO_OUT_EXTERNAL;
    } else {
        if ((outputMode == AUDIO_OUT_EXTERNAL)
            && (lineMode & AuDeviceOutputModeHeadphone)) {
            outputMode = AUDIO_OUT_LINE;
        }
#ifdef __AUDIO__II__
        else {
            if ((outputMode == AUDIO_OUT_LINE)
                && (lineMode & AuDeviceOutputModeHeadphone)) {
                outputMode = AUDIO_OUT_INTERNAL;
            }
        }
#endif
    }

    updateGains = AuTrue;

    if (ioctl(devAudio, AUDIO_SET_OUTPUT, outputMode) == -1)
        osLogMsg("ERROR: AUDIO_SET_OUTPUT: %s\n", strerror(errno));
    errno = 0;
}

/*----------------------------------------------------------*/

static AuUint8
getPhysicalOutputMode()
{

    if (NasConfig.DoDebug)
        osLogMsg("Getting physical output mode....\n");

    return outputMode == AUDIO_OUT_INTERNAL ? AuDeviceOutputModeSpeaker :
            AuDeviceOutputModeHeadphone;

}

/*----------------------------------------------------------*/

static void
setPhysicalInputGainAndLineMode(gain, lineMode)
AuFixedPoint gain;
AuUint8 lineMode;
{
    AuInt16 g = AuFixedPointIntegralAddend(gain);
    int in;
    if (g < 50)
        inputGain = g;
    else
        /* (gain - 50) * (205 / 50) + 50 */
        inputGain = ((0x41999 * (g - 50)) >> 16) + 50;

    /*inputGain = g; */

    if (NasConfig.DoDebug)
        osLogMsg("Input gain : %d\n", g);

    updateGains = AuTrue;

    if (NasConfig.DoDebug)
        osLogMsg("Line mode = %d\n", lineMode);

#ifdef __AUDIO__II__
    if ((inputMode == AUDIO_IN_LINE)
        && (lineMode & AuDeviceInputModeMicrophone)) {
        inputMode = AUDIO_IN_MIKE;
    } else {
        inputMode = AUDIO_IN_LINE;
    }
#endif

    if (NasConfig.DoDebug)
        osLogMsg("Input mode = %d\n", inputMode);

    if (ioctl(devAudio, AUDIO_SET_INPUT, inputMode) == -1)
        osLogMsg("ERROR: AUDIO_SET_INPUT: %s\n", strerror(errno));
    errno = 0;

    if (ioctl(devAudio, AUDIO_GET_INPUT, &in) == -1)
        osLogMsg("ERROR: AUDIO_GET_INPUT: %s\n", strerror(errno));

    if (NasConfig.DoDebug)
        osLogMsg("GET_INPUT : %d\n", in);

}

/*----------------------------------------------------------*/

static void
writeEmptyOutput()
{

    if (NasConfig.DoDebug)
        osLogMsg("Writing empty\n");

#ifndef NULL_AUDIO_DEVICE
    write(devAudio, emptyOutput,
          (auNativeBytesPerSample * auMinibufSamples));
#endif
}

/*----------------------------------------------------------*/

static void
writeOutput(p, n)
AuInt16 *p;
unsigned int n;
{
#ifndef NULL_AUDIO_DEVICE
    write(devAudio, p, (auNativeBytesPerSample * n));
#endif
}

/*----------------------------------------------------------*/

static void
writePhysicalOutputsMono()
{
    if (NasConfig.DoDebug > 10)
        osLogMsg("Writing mono\n");

    writeOutput(auOutputMono, *monoSamples);
}

/*----------------------------------------------------------*/

static void
writePhysicalOutputsStereo()
{
    if (NasConfig.DoDebug > 10)
        osLogMsg("Writing stereo\n");

    writeOutput(auOutputStereo, (2 * (*stereoSamples)));
}

/*----------------------------------------------------------*/

static void
writePhysicalOutputsBoth()
{
    if (NasConfig.DoDebug)
        osLogMsg("Writing both\n");

    writeOutput(auOutputStereo, (2 * (*stereoSamples)));
}

/*----------------------------------------------------------*/

static void
readPhysicalInputs()
{
    if (NasConfig.DoDebug)
        osLogMsg("Reading input\n");

    read(devAudio, auInputMono,
         (auNativeBytesPerSample * auMinibufSamples));
}

/*----------------------------------------------------------*/

static void
setWritePhysicalOutputFunction(flow, funct)
CompiledFlowPtr flow;
void (**funct) ();
{
    AuUint32 mask = flow->physicalDeviceMask;
    int num_channels = 1;

    if (NasConfig.DoDebug > 5)
        osLogMsg("setWritePhysicalOutputFunction(): Playing...\n");

    if ((mask & (PhysicalOutputMono | PhysicalOutputStereo)) ==
        (PhysicalOutputMono | PhysicalOutputStereo)) {
        *funct = writePhysicalOutputsBoth;
        num_channels = 2;
        if (NasConfig.DoDebug > 5)
            osLogMsg("Playing both......\n");
    } else if (mask & PhysicalOutputMono) {
        *funct = writePhysicalOutputsMono;
        if (NasConfig.DoDebug > 5)
            osLogMsg("Playing mono......\n");
    } else if (mask & PhysicalOutputStereo) {
        *funct = writePhysicalOutputsStereo;
        num_channels = 2;
        if (NasConfig.DoDebug)
            osLogMsg("Playing stereo......\n");
    } else {
        *funct = writeEmptyOutput;
        if (NasConfig.DoDebug > 5)
            osLogMsg("Playing m/t......\n");
    }

    if (NasConfig.DoDebug > 5)
        osLogMsg("setWritePhysicalOutputFunction() calling BlockUntilClear\n");

    /* JET - BLOCK */
    BlockUntilClear(AuTrue);

#ifndef NULL_AUDIO_DEVICE
    if (ioctl(devAudio, AUDIO_SET_CHANNELS, num_channels) == -1) {
        osLogMsg("ERROR: AUDIO_SET_CHANNELS (num_channels = %d): %s\n",
                 num_channels, strerror(errno));
        errno = 0;
    } else {
        if (NasConfig.DoDebug)
            osLogMsg("Set channels to %d\n", num_channels);
    }
#endif
}

/*----------------------------------------------------------*/

void
processAudioSignal(sig)
int sig;
{
    struct audio_gain gains;

    signal(SIGALRM, SIG_IGN);

    if (NasConfig.DoDebug > 5) {
        osLogMsg("Processing audio signal....\n");
        if (NasConfig.DoDebug > 10)
            DumpDeviceStatus((struct audio_status *) NULL);
    }

    if (updateGains) {
#ifndef NULL_AUDIO_DEVICE
        if (ioctl(devAudio, AUDIO_GET_GAINS, &gains) == -1)
            osLogMsg("ERROR: AUDIO_GET_GAINS: %s\n", strerror(errno));

        errno = 0;
#endif
        gains.cgain[0].receive_gain = inputGain;
        gains.cgain[0].transmit_gain = outputGain;
        gains.cgain[0].monitor_gain = AUDIO_OFF_GAIN;
        gains.cgain[1].receive_gain = inputGain;
        gains.cgain[1].transmit_gain = outputGain;
        gains.cgain[1].monitor_gain = AUDIO_OFF_GAIN;
        gains.channel_mask = (AUDIO_CHANNEL_LEFT | AUDIO_CHANNEL_RIGHT);
#ifndef NULL_AUDIO_DEVICE
        if (ioctl(devAudio, AUDIO_SET_GAINS, &gains) == -1)
            osLogMsg("ERROR: AUDIO_SET_GAINS: %s\n", strerror(errno));
        errno = 0;
#endif
        updateGains = AuFalse;
    }

    if (processFlowEnabled)
        AuProcessData();

    if (processFlowEnabled)
        signal(SIGALRM, processAudioSignal);
}

/*----------------------------------------------------------*/

static void
enableProcessFlow()
{
    if (NasConfig.DoDebug)
        osLogMsg("Enabling flow\n");

    if (relinquish_device) {
        if (NasConfig.DoDebug)
            osLogMsg("enableProcessFlow(): relinquish_device is true, openDevice will be called\n");

        openDevice(AuTrue);
    }

    writeEmptyOutput();
    processFlowEnabled = AuTrue;
    signal(SIGALRM, processAudioSignal);
}

/*----------------------------------------------------------*/

static void
disableProcessFlow()
{
    signal(SIGALRM, SIG_IGN);
    processFlowEnabled = AuFalse;

    if (NasConfig.DoDebug)
        osLogMsg("disableProcessFlow(): entering\n");

#ifndef NULL_AUDIO_DEVICE
    if (ioctl(devAudio, AUDIO_DRAIN, 0) == -1)
        osLogMsg("ERROR: AUDIO_DRAIN: %s\n", strerror(errno));
    errno = 0;

    if (relinquish_device) {
        if (NasConfig.DoDebug)
            osLogMsg("disableProcessFlow(): relinquish_device is true, closeDevice will be called\n");
        closeDevice();
    }
#endif
    if (NasConfig.DoDebug)
        osLogMsg("Disabling flow\n");
}

/*----------------------------------------------------------*/

#define PhysicalOneTrackBufferSize                                             \
    PAD4(auMinibufSamples * auNativeBytesPerSample * 1)
#define PhysicalTwoTrackBufferSize                                             \
    PAD4(auMinibufSamples * auNativeBytesPerSample * 2)

/*----------------------------------------------------------*/

AuBool
AuInitPhysicalDevices()
{
    static AuUint8 *physicalBuffers;
    AuUint32 physicalBuffersSize;
    extern AuUint32 auPhysicalOutputBuffersSize;
    extern AuUint8 *auPhysicalOutputBuffers;
    extern AuBool AuInitPhysicalDevices_dbri();
    struct itimerval ntval, otval;
    int timer_us;
    int temp_int, input;
    static AuBool FirstTime = AuTrue;



    if (V_STRING) {
        aufree(V_STRING);
        V_STRING = (char *) 0;
    }


    if (FirstTime == AuTrue) {  /* first run - init priority and proclock */

        FirstTime = AuFalse;

        /*
         * Set process to run in real time
         */
        if (rtprio(0, 30) == -1) {
            osLogMsg("ERROR: rtprio(0, 30): %s\n", strerror(errno));

            errno = 0;
        } else {
            if (plock(PROCLOCK) == -1) {
                osLogMsg("ERROR: plock(PROCLOCK): %s\n", strerror(errno));

                errno = 0;
            }
        }
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

    if (devAudio == -1) {
#ifndef NULL_AUDIO_DEVICE
        if ((devAudioCtl = open("/dev/audioCtl", O_RDWR)) == -1) {
            osLogMsg("ERROR: opening /dev/audioCtl: %s\n",
                     strerror(errno));
            errno = 0;
            devAudio = devAudioCtl = -1;
            return AuFalse;
        }

        if ((devAudio = open("/dev/audio", O_RDWR)) == -1) {
            osLogMsg("ERROR: opening /dev/audio: %s\n", strerror(errno));
            errno = 0;
            close(devAudioCtl);
            devAudio = devAudioCtl = -1;
            return AuFalse;
        }
#endif
    }

    if (!(V_STRING = (char *) aualloc(strlen(HPUX_VENDOR) + 1)))
        return AuFalse;

    strcpy(V_STRING, HPUX_VENDOR);

    if (physicalBuffers)
        aufree(physicalBuffers);

    if (emptyOutput)
        aufree(emptyOutput);

    auMinibufSamples = MINIBUF_SIZE;

    if (!(emptyOutput = (AuUint8 *) aualloc(auMinibufSamples)))
        return AuFalse;

/*
    auset(emptyOutput, 0xff, auMinibufSamples);
*/
    auset(emptyOutput, 0x00, auMinibufSamples);

    /* the output buffers need to be twice as large for output range checking */
    physicalBuffersSize = PhysicalOneTrackBufferSize +  /* mono input */
            PhysicalOneTrackBufferSize * 2 +    /* mono output */
            PhysicalTwoTrackBufferSize * 2;     /* stereo output */

    if (!(physicalBuffers = (AuUint8 *) aualloc(physicalBuffersSize)))
        return AuFalse;

    auInputMono = physicalBuffers;
    auOutputMono = auInputMono + PhysicalOneTrackBufferSize;
    auOutputStereo = auOutputMono + 2 * PhysicalOneTrackBufferSize;

    auPhysicalOutputBuffers = auOutputMono;
    auPhysicalOutputBuffersSize = physicalBuffersSize -
            PhysicalOneTrackBufferSize;

    signal(SIGALRM, SIG_IGN);
    if (NasConfig.DoDebug > 2)
        osLogMsg("AuInitPhysicalDevices(): setup to ignore signals\n");

    timer_us = (auMinibufSamples * 500000) / 8000;

    if (NasConfig.DoDebug)
        osLogMsg("Setting timer to %dus\n", timer_us);

    ntval.it_interval.tv_sec = 0;
    ntval.it_interval.tv_usec = timer_us;
    ntval.it_value.tv_sec = 0;
    ntval.it_value.tv_usec = timer_us;
    setitimer(ITIMER_REAL, &ntval, &otval);


    AuRegisterCallback(AuCreateServerComponentsCB, createServerComponents);
    AuRegisterCallback(AuSetPhysicalOutputGainCB, setPhysicalOutputGain);
    AuRegisterCallback(AuGetPhysicalOutputGainCB, getPhysicalOutputGain);
    AuRegisterCallback(AuGetPhysicalOutputModeCB, getPhysicalOutputMode);
    AuRegisterCallback(AuSetPhysicalOutputModeCB, setPhysicalOutputMode);
    AuRegisterCallback(AuSetPhysicalInputGainAndLineModeCB,
                       setPhysicalInputGainAndLineMode);
    AuRegisterCallback(AuEnableProcessFlowCB, enableProcessFlow);
    AuRegisterCallback(AuDisableProcessFlowCB, disableProcessFlow);
    AuRegisterCallback(AuReadPhysicalInputsCB, readPhysicalInputs);
    AuRegisterCallback(AuSetWritePhysicalOutputFunctionCB,
                       setWritePhysicalOutputFunction);

    AuRegisterCallback(AuSetSampleRateCB, setSampleRate);
    AuRegisterCallback(AuEventPostedCB, eventPosted);

    /* JET - init dev start */

    InitDevice();

    /*
     * Display configuration
     */
    switch (audio_describe.audio_id) {
    case AUDIO_ID_CS4215:

        if (NasConfig.DoVerbose) {
            osLogMsg("AUDIO_ID_CS4215: \n");
            osLogMsg("audio_describe.flags & AD_F_NOBEEPER = %d\n",
                     (audio_describe.flags & AD_F_NOBEEPER));

            osLogMsg("       Control:        0x%x\n",
                     raw_params.audio_conf_union.cs4215_conf.control);
            osLogMsg("       DMA Status:     0x%x\n",
                     raw_params.audio_conf_union.cs4215_conf.dmastatus);
            osLogMsg("       Gain Control:   0x%x\n",
                     raw_params.audio_conf_union.cs4215_conf.gainctl);
            osLogMsg("       Over Range:     0x%x\n",
                     raw_params.audio_conf_union.cs4215_conf.over_range);
            osLogMsg("       PIO:            0x%x\n",
                     raw_params.audio_conf_union.cs4215_conf.pio);
        }

        break;
    case AUDIO_ID_PSB2160:
        if (NasConfig.DoDebug)
            osLogMsg("AUDIO_ID_PSB2160: \n");
        break;
    }

     /*JET*/
#if 0
            /*
             * Get buffer limits
             */
#ifndef NULL_AUDIO_DEVICE
            if (ioctl(devAudio, AUDIO_GET_LIMITS, &audio_limits) == -1)
        osLogMsg("ERROR: AUDIO_GET_LIMITS: %s\n", strerror(errno));
    errno = 0;

    /*
     * Set buffer sizes
     */
    if (ioctl(devAudio, AUDIO_SET_RXBUFSIZE, (8192 * 2)) == -1)
        osLogMsg("ERROR: AUDIO_SET_RXBUFSIZE: %s\n", strerror(errno));
    errno = 0;
    if (ioctl(devAudio, AUDIO_GET_RXBUFSIZE, &temp_int) == -1)
        osLogMsg("ERROR: AUDIO_GET_RXBUFSIZE: %s\n", strerror(errno));
    errno = 0;

    if (NasConfig.DoDebug)
        osLogMsg("RX buffer size = %d\n", temp_int);

    if (ioctl(devAudio, AUDIO_SET_TXBUFSIZE, (8192 * 2)) == -1)
        osLogMsg("ERROR: AUDIO_SET_TXBUFSIZE: %s\n", strerror(errno));
    errno = 0;

    if (ioctl(devAudio, AUDIO_GET_TXBUFSIZE, &temp_int) == -1)
        osLogMsg("ERROR: AUDIO_GET_TXBUFSIZE: %s\n", strerror(errno));

    errno = 0;

    if (NasConfig.DoDebug)
        osLogMsg("TX buffer size = %d\n", temp_int);

#endif /* NULL_AUDIO_DEVICE */

    /*
     * Set threshold
     */
    select_thresholds.read_threshold = (MINIBUF_SIZE);
    select_thresholds.write_threshold = (MINIBUF_SIZE);
#ifndef NULL_AUDIO_DEVICE
    if (ioctl(devAudio, AUDIO_SET_SEL_THRESHOLD, &select_thresholds) == -1)
        osLogMsg("ERROR: AUDIO_SET_SEL_THRESHOLD: %s\n", strerror(errno));
    errno = 0;

    if (ioctl(devAudio, AUDIO_GET_SEL_THRESHOLD, &select_thresholds) == -1)
        osLogMsg("ERROR: AUDIO_GET_SEL_THRESHOLD: %s\n", strerror(errno));
    errno = 0;

    if (NasConfig.DoDebug) {
        osLogMsg("Read threshold: %d\n", select_thresholds.read_threshold);
        osLogMsg("Write threshold: %d\n",
                 select_thresholds.write_threshold);
    }
#endif /* NULL_AUDIO_DEVICE */

    /*
     * Set to NAS format
     */
#ifndef NULL_AUDIO_DEVICE
    if (ioctl(devAudio, AUDIO_SET_DATA_FORMAT, AUDIO_FORMAT_LINEAR16BIT) ==
        -1)
        osLogMsg("ERROR: AUDIO_SET_DATA_FORMAT: %s\n", strerror(errno));

    errno = 0;
    if (ioctl(devAudio, AUDIO_GET_DATA_FORMAT, &temp_int) == -1)
        osLogMsg("ERROR: AUDIO_GET_DATA_FORMAT: %s\n", strerror(errno));
    errno = 0;
#endif
    if (NasConfig.DoDebug)
        osLogMsg("Audio Format = %d (Lin 16 = %d)\n",
                 temp_int, AUDIO_FORMAT_LINEAR16BIT);

    /*
     * Send output to headphone jack
     * and input to mike jack
     */
#ifndef NULL_AUDIO_DEVICE

    if (ioctl(devAudio, AUDIO_SET_OUTPUT, OutputDevType) == -1)
        osLogMsg("ERROR: AUDIO_SET_OUTPUT: %s\n", strerror(errno));

    errno = 0;
    if (ioctl(devAudio, AUDIO_GET_OUTPUT, &temp_int) == -1)
        osLogMsg("ERROR: AUDIO_GET_OUTPUT: %s\n", strerror(errno));
    errno = 0;
    if (ioctl(devAudio, AUDIO_SET_INPUT, AUDIO_IN_MIKE) == -1)
        osLogMsg("ERROR: AUDIO_SET_INPUT: %s\n", strerror(errno));
    errno = 0;

    if (NasConfig.DoDebug)
        osLogMsg("Input Port   (Mike = %d) (Errorno : %d)\n",
                 AUDIO_IN_MIKE, errno);

    if (ioctl(devAudio, AUDIO_GET_INPUT, &input) == -1)
        osLogMsg("ERROR: AUDIO_GET_INPUT: %s\n", strerror(errno));
    errno = 0;
#endif

    if (NasConfig.DoDebug) {
        osLogMsg("Output Port = %d (Headphones = %d)\n", temp_int,
                 AUDIO_OUT_EXTERNAL);

        osLogMsg("Input Port = %d  (Mike = %d) (Errorno : %d)\n", input,
                 AUDIO_IN_MIKE, errno);
    }

    outputMode = temp_int;

    /*
     * Set number of tracks to 2
     */
#ifndef NULL_AUDIO_DEVICE
    if (ioctl(devAudio, AUDIO_SET_CHANNELS, 2) == -1)
        osLogMsg("ERROR: AUDIO_SET_CHANNELS: %s\n", strerror(errno));

    errno = 0;
    if (ioctl(devAudio, AUDIO_GET_CHANNELS, &temp_int) == -1)
        osLogMsg("ERROR: AUDIO_GET_CHANNELS: %s\n", strerror(errno));
    errno = 0;
#endif

#endif /* 0 JET */

    currentOutputGain =
            outputGain < 50 ? AuFixedPointFromSum(outputGain,
                                                  0) : (outputGain -
                                                        50) * 0x3e70 +
            0x320000;

    /* bogus resource so we can have a cleanup function at server reset */
    AddResource(FakeClientID(SERVER_CLIENT),
                CreateNewResourceType(serverReset), 0);

    if (relinquish_device)
        closeDevice();

    return AuTrue;
}

/* JET */
static void
DumpDeviceStatus(struct audio_status *astat)
{
    struct audio_status status_b;
    struct audio_status *statptr;
    int rv;

    rv = 0;
    osLogMsg("### DumpDeviceStatus(0x%p)\n", astat);

    if (astat == (struct audio_status *) NULL) {
        statptr = &status_b;
        if ((rv = ioctl(devAudio, AUDIO_GET_STATUS, statptr)) == -1) {
            osLogMsg("ERROR: AUDIO_GET_STATUS: %s\n", strerror(errno));
            errno = 0;
        }
    } else {
        statptr = astat;
    }

    if (rv != -1) {
        osLogMsg("- RX Status = %d\n", statptr->receive_status);
        osLogMsg("- TX Status = %d\n", statptr->transmit_status);
        osLogMsg("- RX Buffer Count = %d\n",
                 statptr->receive_buffer_count);
        osLogMsg("- TX Buffer Count = %d\n",
                 statptr->transmit_buffer_count);
        osLogMsg("- RX Overflow = %d\n", statptr->receive_overflow_count);
        osLogMsg("- TX Underflow = %d\n",
                 statptr->transmit_underflow_count);
    }
    return;
}
