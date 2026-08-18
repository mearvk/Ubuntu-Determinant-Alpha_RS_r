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
 * $Id: auplay.c 170 2006-07-28 00:26:52Z jon $
 * $NCDId: @(#)auplay.c,v 1.19 1993/06/15 01:04:58 greg Exp $
 */

/*
 * auplay -- a trivial program for playing audio files.
 */

#include    <unistd.h>
#include    <fcntl.h>
#include    <stdio.h>
#include    <stdlib.h>
#include    <signal.h>
#include    <string.h>
#include    <audio/audiolib.h>
#include    <audio/soundlib.h>

#define FILENM_SIZE   256	/* max lenth of a filename on stdin */

static AuServer *aud = 0;
static int      volume = 100,
                infoflag = 0,
                playflag = 1;
static char    *progname;
static AuFlowID auflowid = 0;

void
sighandler(int i)
{
    char buf[BUFSIZ];

    if (aud && auflowid)
	AuStopFlow(aud, auflowid, 0);

    /* consume anything remaining on stdin to prevent errors */
    fcntl(0, F_SETFL, O_NONBLOCK);
    while (read(0, buf, BUFSIZ) > 0);

    exit(1);
}

/*
 * Unfortunately, in order to get access to the AuFlowID of the flow
 * being played, so that we can call AuStopFlow() on it when we're
 * told to terminate (above), we need to have our own copy of
 * AuSoundPlaySynchronousFromFile(), and a couple of support
 * definitions.
 */

#define	VOL(volume)		((1 << 16) * (volume) / 100)

static void
sync_play_cb(AuServer *aud, AuEventHandlerRec *handler, AuEvent *ev,
             AuPointer data)
{
    int            *d = (int *) data;

    *d = 1;
}

static AuBool
localAuSoundPlaySynchronousFromFile(AuServer *aud, const char *fname,
                                    int volume)
{
    AuStatus        ret;
    AuEvent         ev;
    int             d = 0;

    if (!AuSoundPlayFromFile(aud, fname, AuNone, VOL(volume),
			     sync_play_cb, (AuPointer) &d, &auflowid,
			     (int *) NULL, (int *) NULL, &ret))
	return AuFalse;		/* XXX do something with ret? */

    while (1)
    {
	AuNextEvent(aud, AuTrue, &ev);
	AuDispatchEvent(aud, &ev);

	if (d)
	    break;
    }

    return AuTrue;
}

static void
usage(void)
{
    fprintf(stderr,
       "Usage:  %s [-iIl] [-audio servername] [-volume percent] files ...\n",
	    progname);
    exit(1);
}

static void
do_file(char *fname)
{
    Sound       s;

    if (infoflag)
    {
	s = SoundOpenFileForReading(fname);

	if (s)
	{
	    printf("%15s %.80s\n", "Filename:", fname);
	    printf("%15s %.80s\n", "File Format:", SoundFileFormatString(s));
	    printf("%15s %.80s\n", "Data Format:",
		   AuFormatToString(SoundDataFormat(s)));
	    printf("%15s %d\n", "Tracks:", SoundNumTracks(s));
	    printf("%15s %d Hz\n", "Frequency:", SoundSampleRate(s));
	    printf("%15s %.2f seconds\n", "Duration:",
		   (float) SoundNumSamples(s) / SoundSampleRate(s));
	    printf("\n%s\n", SoundComment(s));
	    SoundCloseFile(s);
	}
	else
	{
	    fprintf(stderr, "Couldn't open file \"%s\"\n", fname);
	    return;
	}
    }

    if (playflag && !localAuSoundPlaySynchronousFromFile(aud, fname, volume))
	fprintf(stderr, "Couldn't play file \"%s\"\n", fname);
}

main(int argc, char **argv)
{
    int             i,
                    numfnames,
		    filelist = 0;
    char           *auservername = NULL;
    AuBool          did_file = AuFalse;

    progname = argv[0];

    argc--;
    numfnames = argc;
    argv++;

    while (argv && argv[0] && *argv[0] == '-')
    {
	if (!strncmp(argv[0], "-a", 2))
	{
	    if (argv[1])
	    {
		argv++;
		numfnames--;
		auservername = argv[0];
	    }
	    else
		usage();
	}
	else if (!strncmp(argv[0], "-v", 2))
	{
	    if (argv[1])
	    {
		argv++;
		numfnames--;
		volume = atoi(argv[0]);
	    }
	    else
		usage();
	}
	else if (!strncmp(argv[0], "-i", 2))
	{
	    infoflag = 1;
	}
	else if (!strncmp(argv[0], "-I", 2))
	{
	    infoflag = 1;
	    playflag = 0;
	}
	else if (!strncmp(argv[0], "-l", 2))
	{
	    filelist = 1;
	}
	else
	    usage();
	argv++;
	numfnames--;
    }

    if (playflag)
    {

      signal(SIGINT, sighandler);
      signal(SIGTERM, sighandler);
      signal(SIGHUP, sighandler);
      
      aud = AuOpenServer(auservername, 0, NULL, 0, NULL, NULL);
      if (!aud)
	{
	  fprintf(stderr, "Can't connect to audio server\n");
	  exit(-1);
	}
    }
    
    for (i = 0; i < numfnames; i++)
    {
	do_file(argv[i]);
	did_file = AuTrue;
    }

    if (filelist) 
      {
	while (1)
	  {
	    char filename[FILENM_SIZE];
	    
	    if (fgets(filename, FILENM_SIZE, stdin) == 0) 
	      break;
	    
	    filename[strlen(filename)-1] = '\0';
	    
	    if (!strcmp(filename, "-"))
	      {
		fprintf(stderr, "Skipping filename \"-\" in file list");
		continue;
	      }
	    do_file(filename);
	  }
      } 
    else 
      {
	if (!did_file)		/* must want stdin */
	  do_file("-");
      }
    
    if (aud)
      AuCloseServer(aud);
    
    exit(0);
}
