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
 * THIS SOFTWARE IS PROVIDED 'AS-IS'.  NETWORK COMPUTING DEVICES, INC.,
 * DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE, INCLUDING WITHOUT
 * LIMITATION ALL IMPLIED WARRANTIES OF MERCHANTABILITY, FITNESS FOR A
 * PARTICULAR PURPOSE, OR NONINFRINGEMENT.  IN NO EVENT SHALL NETWORK
 * COMPUTING DEVICES, INC., BE LIABLE FOR ANY DAMAGES WHATSOEVER, INCLUDING
 * SPECIAL, INCIDENTAL OR CONSEQUENTIAL DAMAGES, INCLUDING LOSS OF USE, DATA,
 * OR PROFITS, EVEN IF ADVISED OF THE POSSIBILITY THEREOF, AND REGARDLESS OF
 * WHETHER IN AN ACTION IN CONTRACT, TORT OR NEGLIGENCE, ARISING OUT OF OR IN
 * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 * 
 * $NCDId: @(#)sound.c,v 1.26 1995/11/28 22:47:00 greg Exp $
 */

/*
 * generic sound handling routines
 */

#define _SOUND_C_

#include "config.h"

#include	<stdio.h>

#if defined(HAVE_STDLIB_H)
# include <stdlib.h> 
#endif

#if defined(HAVE_MALLOC_H)
# include <malloc.h>
#endif

#include	<audio/Aos.h>
#include	<audio/audio.h>
#include	<audio/sound.h>

/* JET  - 7/20/2002
   Due to issues with cygwin's inability to import an array of structs
   for a DLL, we will put the declaration of SoundFileInfo[] here (from
   sound.h) and provide a function that will return the appropriate
   struct based on an index supplied.
   Since apps shouldn't have been accessing this struct directly anyway,
   there should be no effect on applications adhering to this rule.
*/

#ifndef hpux
typedef void   *(*_pFunc) ();
#define _VOIDP_ (_pFunc)
#else						/* hpux */
#define _VOIDP_
#endif						/* hpux */

#define _oo SoundDataFormatBit

static int      sndToSound(), soundToSnd(),
                vocToSound(), soundToVoc(),
                waveToSound(), soundToWave(),
                aiffToSound(), soundToAiff(),
                svxToSound(), soundToSvx();


/* This order must match the _SoundFileFormatsID enum defined in sound.h */
static _SoundConst SoundInfo _SoundFileInfo[] =
{
    "Sun/NeXT", "snd", "snd au",
    (_oo(AuFormatULAW8) | _oo(AuFormatLinearUnsigned8) |
     _oo(AuFormatLinearSigned16MSB)),
    _VOIDP_ SndOpenFileForReading, _VOIDP_ SndOpenFileForWriting,
    SndReadFile, SndWriteFile, SndCloseFile, SndRewindFile,
    SndSeekFile, SndTellFile, SndFlushFile, sndToSound, soundToSnd,

    "Creative Labs VOC", "voc", "voc",
    _oo(AuFormatLinearUnsigned8),
    _VOIDP_ VocOpenFileForReading, _VOIDP_ VocOpenFileForWriting,
    VocReadFile, VocWriteFile, VocCloseFile, VocRewindFile,
    VocSeekFile, VocTellFile, VocFlushFile, vocToSound, soundToVoc,

    "Microsoft WAVE", "wave", "wav",
    (_oo(AuFormatLinearUnsigned8) | _oo(AuFormatLinearSigned16LSB)),
    _VOIDP_ WaveOpenFileForReading, _VOIDP_ WaveOpenFileForWriting,
    WaveReadFile, WaveWriteFile, WaveCloseFile, WaveRewindFile,
    WaveSeekFile, WaveTellFile, WaveFlushFile, waveToSound, soundToWave,

    "AIFF", "aiff", "aiff",
    (_oo(AuFormatLinearSigned8) | _oo(AuFormatLinearSigned16MSB)),
    _VOIDP_ AiffOpenFileForReading, _VOIDP_ AiffOpenFileForWriting,
    AiffReadFile, AiffWriteFile, AiffCloseFile, AiffRewindFile,
    AiffSeekFile, AiffTellFile, AiffFlushFile, aiffToSound, soundToAiff,

    "Amiga IFF/8SVX", "8svx", "iff",
    _oo(AuFormatLinearSigned8),
    _VOIDP_ SvxOpenFileForReading, _VOIDP_ SvxOpenFileForWriting,
    SvxReadFile, SvxWriteFile, SvxCloseFile, SvxRewindFile,
    SvxSeekFile, SvxTellFile, SvxFlushFile, svxToSound, soundToSvx,
};

#undef _oo
#undef _VOIDP_

const int SoundNumFileFormats =
(sizeof(_SoundFileInfo) / sizeof(_SoundFileInfo[0]));

char *SoundFileFormatString(Sound s)
{
  return(_SoundFileInfo[SoundFileFormat(s)].string);
}

int SoundValidDataFormat(int _f, int _d)
{
  return((_SoundFileInfo[_f].dataFormats & SoundDataFormatBit(_d) ? 1 : 0));
}

char *SoundFileFormatToString(int _i)
{
  return(_SoundFileInfo[_i].string);
}

char *SoundFileFormatToAbbrev(int _i)
{
  return(_SoundFileInfo[_i].abbrev);
}

char *SoundFileFormatToSuffixes(int _i)
{
  return(_SoundFileInfo[_i].suffixes);
}

SoundFileInfoProc SoundFileGetProc(int format, int proc)
{
  switch (proc)
    {
    case SoundFileInfoProcTo:
      return(_SoundFileInfo[format].toSound);
      break;
    case SoundFileInfoProcFrom:
      return(_SoundFileInfo[format].fromSound);
      break;
    default:
      return(NULL);
    }
}
   

static int
SndToSoundFormat(int fmt)
{
    switch (fmt)
    {
      case SND_FORMAT_ULAW_8:
	return AuFormatULAW8;
      case SND_FORMAT_LINEAR_8:
	return AuFormatLinearUnsigned8;
      case SND_FORMAT_LINEAR_16:
	return AuFormatLinearSigned16MSB;
      default:
	return AuNone;
    }
}

static int
SoundToSndFormat(int fmt)
{
    switch (fmt)
    {
      case AuFormatULAW8:
	return SND_FORMAT_ULAW_8;
      case AuFormatLinearUnsigned8:
	return SND_FORMAT_LINEAR_8;
      case AuFormatLinearSigned16MSB:
	return SND_FORMAT_LINEAR_16;
      default:
	return SND_FORMAT_UNSPECIFIED;
    }
}

static int
sndToSound(Sound s)
{
    SndInfo        *p = (SndInfo *)s->formatInfo;
    SndHeader      *h = &p->h;

    SoundFileFormat(s) = SoundFileFormatSnd;
    SoundDataFormat(s) = SndToSoundFormat(h->format);

    if (SoundDataFormat(s) == AuNone)
	return 0;

    SoundSampleRate(s) = h->sampleRate;
    SoundNumTracks(s) = h->tracks;
    SoundComment(s) = p->comment;
    SoundNumSamples(s) = h->dataSize == SND_DATA_SIZE_UNKNOWN ?
	SoundUnknownNumSamples :
	h->dataSize / SoundNumTracks(s) / SoundBytesPerSample(s);

    return 1;
}

static int
soundToSnd(Sound s)
{
    SndInfo        *si;

    if (!(si = (SndInfo *) malloc(sizeof(SndInfo))))
	return 0;

    si->comment = SoundComment(s);
    si->h.format = SoundToSndFormat(SoundDataFormat(s));
    si->h.dataSize =
	SoundNumSamples(s) == SoundUnknownNumSamples ? SND_DATA_SIZE_UNKNOWN :
	SoundNumSamples(s);
    si->h.sampleRate = SoundSampleRate(s);
    si->h.tracks = SoundNumTracks(s);

    s->formatInfo = (void *) si;
    return 1;
}

static int
vocToSound(Sound s)
{
    VocInfo        *p = (VocInfo *)s->formatInfo;

    SoundFileFormat(s) = SoundFileFormatVoc;
    SoundDataFormat(s) = AuFormatLinearUnsigned8;
    SoundSampleRate(s) = p->sampleRate;
    SoundNumTracks(s) = p->tracks;
    SoundComment(s) = p->comment;
    SoundNumSamples(s) = p->dataSize / SoundNumTracks(s) /
	SoundBytesPerSample(s);
    return 1;
}

static int
soundToVoc(Sound s)
{
    VocInfo        *vi;

    if (!(vi = (VocInfo *) malloc(sizeof(VocInfo))))
	return 0;

    vi->comment = SoundComment(s);
    vi->sampleRate = SoundSampleRate(s);
    vi->tracks = SoundNumTracks(s);

    s->formatInfo = (void *) vi;
    return 1;
}

static int
WaveToSoundFormat(WaveInfo *wi)
{
    if (wi->bitsPerSample == 8)
	return AuFormatLinearUnsigned8;

    if (wi->bitsPerSample == 16)
	return AuFormatLinearSigned16LSB;

    return -1;
}

static int
waveToSound(Sound s)
{
    WaveInfo       *wi = (WaveInfo *)s->formatInfo;

    SoundFileFormat(s) = SoundFileFormatWave;
    SoundDataFormat(s) = WaveToSoundFormat(wi);
    SoundSampleRate(s) = wi->sampleRate;
    SoundNumTracks(s) = wi->channels;
    SoundComment(s) = wi->comment;
    SoundNumSamples(s) = wi->numSamples;

    return 1;
}

static int
soundToWave(Sound s)
{
    WaveInfo       *wi;

    if (!(wi = (WaveInfo *) malloc(sizeof(WaveInfo))))
	return 0;

    wi->comment = SoundComment(s);
    wi->sampleRate = SoundSampleRate(s);
    wi->channels = SoundNumTracks(s);
    wi->bitsPerSample = AuSizeofFormat(SoundDataFormat(s)) << 3;

    s->formatInfo = (void *) wi;
    return 1;
}

static int
AiffToSoundFormat(AiffInfo *ai)
{
    if (ai->bitsPerSample == 8)
	return AuFormatLinearSigned8;

    if (ai->bitsPerSample == 16)
	return AuFormatLinearSigned16MSB;

    return -1;
}

static int
aiffToSound(Sound s)
{
    AiffInfo       *ai = (AiffInfo *)s->formatInfo;

    SoundFileFormat(s) = SoundFileFormatAiff;
    SoundDataFormat(s) = AiffToSoundFormat(ai);
    SoundSampleRate(s) = ai->sampleRate;
    SoundNumTracks(s) = ai->channels;
    SoundComment(s) = ai->comment;
    SoundNumSamples(s) = ai->numSamples;

    return 1;
}

static int
soundToAiff(Sound s)
{
    AiffInfo       *ai;

    if (!(ai = (AiffInfo *) malloc(sizeof(AiffInfo))))
	return 0;

    ai->comment = SoundComment(s);
    ai->sampleRate = SoundSampleRate(s);
    ai->channels = SoundNumTracks(s);
    ai->bitsPerSample = AuSizeofFormat(SoundDataFormat(s)) << 3;

    s->formatInfo = (void *) ai;
    return 1;
}

static int
svxToSound(Sound s)
{
    SvxInfo        *si = (SvxInfo *)s->formatInfo;

    SoundFileFormat(s) = SoundFileFormatSvx;
    SoundDataFormat(s) = AuFormatLinearSigned8;
    SoundSampleRate(s) = si->sampleRate;
    SoundNumTracks(s) = 1;
    SoundComment(s) = si->comment;
    SoundNumSamples(s) = si->numSamples;

    return 1;
}

static int
soundToSvx(Sound s)
{
    SvxInfo        *si;

    if (!(si = (SvxInfo *) malloc(sizeof(SvxInfo))))
	return 0;

    si->comment = SoundComment(s);
    si->sampleRate = SoundSampleRate(s);

    s->formatInfo = (void *) si;
    return 1;
}

Sound
SoundOpenFileForReading(const char *name)
{
    Sound           s;
    int             i;

    if (!(s = (Sound) malloc(sizeof(SoundRec))))
	return NULL;

    SoundComment(s) = NULL;

    for (i = 0; i < SoundNumFileFormats; i++)
	if ((s->formatInfo = (_SoundFileInfo[i].openFileForReading) (name)))
	{
	    if (!(_SoundFileInfo[i].toSound) (s))
	    {
		SoundCloseFile(s);
		return NULL;
	    }
	    break;
	}

    if (i == SoundNumFileFormats)
    {
	SoundCloseFile(s);
	return NULL;
    }

    return s;
}

Sound
SoundOpenFileForWriting(
                        const char *name,
                        Sound           s
                        )
{
    if (SoundFileFormat(s) != SoundFileFormatNone &&
	(_SoundFileInfo[SoundFileFormat(s)].openFileForWriting) (name,
							     s->formatInfo))
    {
        SoundNumSamples(s) = 0;
	return s;
    }

    return NULL;
}

int
SoundReadFile(
              char           *p,
              int             n,
              Sound           s
              )
{
    return (_SoundFileInfo[SoundFileFormat(s)].readFile) (p, n, s->formatInfo);
}

int
SoundWriteFile(
               char           *p,
               int             n,
               Sound           s
               )
{
    int             num;

    num = (_SoundFileInfo[SoundFileFormat(s)].writeFile) (p, n, s->formatInfo);
    if (SoundNumSamples(s) != SoundUnknownNumSamples)
        SoundNumSamples(s) += (num / SoundNumTracks(s) /
                               SoundBytesPerSample(s));
       /* Let's not confuse unknown's with real data! */

    return num;
}

int
SoundRewindFile(Sound s)
{
    return (_SoundFileInfo[SoundFileFormat(s)].rewindFile) (s->formatInfo);
}

int
SoundSeekFile(
              int             n,
              Sound           s
              )
{
    return (_SoundFileInfo[SoundFileFormat(s)].seekFile) (n, s->formatInfo);
}

int
SoundTellFile(Sound s)
{
    return (_SoundFileInfo[SoundFileFormat(s)].tellFile) (s->formatInfo);
}

int
SoundFlushFile(Sound s)
{
    return (_SoundFileInfo[SoundFileFormat(s)].flushFile) (s->formatInfo);
}

int
SoundCloseFile(Sound s)
{
    int             status = 0;

    if (!s || (s == (Sound) -1))
	return status;

    if (s->formatInfo)
	status = (_SoundFileInfo[SoundFileFormat(s)].closeFile) (s->formatInfo);
    else if (SoundComment(s))
	free(SoundComment(s));

    free(s);
    return status;
}

Sound
SoundCreate(
            int fileFormat,
            int dataFormat,
            int numTracks,
            int sampleRate,
            int numSamples,
            const char *comment
            )
{
    Sound           s;

    if (!(s = (Sound) malloc(sizeof(SoundRec))))
	return NULL;

    SoundFileFormat(s) = fileFormat;
    SoundDataFormat(s) = dataFormat;
    SoundNumTracks(s) = numTracks;
    SoundSampleRate(s) = sampleRate;
    SoundNumSamples(s) = numSamples;

    if (comment)
    {
	char           *p;

	if ((p = (char *) malloc(strlen(comment) + 1)))
	{
	    strcpy(p, comment);
	    SoundComment(s) = p;
	}
	else
	{
	    free(s);
	    return NULL;
	}
    }
    else
    {
	char           *p;

	if ((p = (char *) malloc(1)))
	{
	    *p = 0;
	    SoundComment(s) = p;
	}
	else
	{
	    free(s);
	    return NULL;
	}
    }

    s->formatInfo = NULL;

    if (SoundFileFormat(s) != SoundFileFormatNone)
	if (!SoundValidateDataFormat(s) ||
	    !(_SoundFileInfo[SoundFileFormat(s)].fromSound) (s))
	{
	    free(SoundComment(s));
	    free(s);
	    return NULL;
	}

    return s;
}

int
SoundStringToFileFormat(const char *s)
{
    int             i;

    for (i = 0; i < SoundNumFileFormats; i++)
	if (!strcasecmp(s, _SoundFileInfo[i].string))
	    break;

    return i == SoundNumFileFormats ? -1 : i;
}

int
SoundAbbrevToFileFormat(const char *s)
{
    int             i;

    for (i = 0; i < SoundNumFileFormats; i++)
	if (!strcasecmp(s, _SoundFileInfo[i].abbrev))
	    break;

    return i == SoundNumFileFormats ? -1 : i;
}
