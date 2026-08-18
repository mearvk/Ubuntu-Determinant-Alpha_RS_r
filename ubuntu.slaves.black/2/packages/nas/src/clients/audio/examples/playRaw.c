/**
 * play a raw audio file
 *
 * usage: playraw <filename> <audio server>
 *
 *	if <filename> is -, playraw will read from standard input
 *
 * $NCDId: @(#)playRaw.c,v 1.1 1995/05/23 00:21:24 greg Exp $
 */

#include <stdio.h>
#include <stdlib.h>
#include <audio/audiolib.h>
#include <audio/soundlib.h>

#define NUM_TRACKS	2
#define DATA_FORMAT	AuFormatLinearSigned16MSB
#define SAMPLE_RATE	11025
#define BUF_SAMPLES	(1 * SAMPLE_RATE)
#define LOW_WATER	BUF_SAMPLES / 2

typedef struct
{
    AuServer       *aud;
    AuFlowID        flow;
    FILE           *fp;
    char           *buf;
}               InfoRec, *InfoPtr;

static void
fatalError(const char *message, const char *arg)
{
    fprintf(stderr, message, arg);
    fprintf(stderr, "\n");
    exit(1);
}

static void
sendFile(AuServer *aud, InfoPtr i, AuUint32 numBytes)
{
    int             n;

    while (numBytes)
	if (n = fread(i->buf, 1, numBytes, i->fp))
	{
	    AuWriteElement(aud, i->flow, 0, n, i->buf, AuFalse, NULL);
	    numBytes -= n;
	}
}

static AuBool
eventHandler(AuServer *aud, AuEvent *ev, AuEventHandlerRec *handler)
{
    InfoPtr         i = (InfoPtr) handler->data;

    switch (ev->type)
    {
	case AuEventTypeElementNotify:
	    {
		AuElementNotifyEvent *event = (AuElementNotifyEvent *) ev;

		switch (event->kind)
		{
		    case AuElementNotifyKindLowWater:
			sendFile(aud, i, event->num_bytes);
			break;
		    case AuElementNotifyKindState:
			switch (event->cur_state)
			{
			    case AuStatePause:
				if (event->reason != AuReasonUser)
				    sendFile(aud, i, event->num_bytes);
				break;
			}
		}
	    }
    }

    return AuTrue;
}

int
main(int argc, char **argv)
{
    AuDeviceID      device = AuNone;
    AuElement       elements[3];
    char           *file = argv[1],
                   *server = argv[2];
    int             i;
    InfoRec         info;

    if (!(info.aud = AuOpenServer(server, 0, NULL, 0, NULL, NULL)))
	exit(1);

    if (*file == '-')
	info.fp = stdin;
    else if (!(info.fp = fopen(file, "r")))
	exit(1);

    /* look for an output device */
    for (i = 0; i < AuServerNumDevices(info.aud); i++)
	if ((AuDeviceKind(AuServerDevice(info.aud, i)) ==
	     AuComponentKindPhysicalOutput) &&
	    AuDeviceNumTracks(AuServerDevice(info.aud, i)) == NUM_TRACKS)
	{
	    device = AuDeviceIdentifier(AuServerDevice(info.aud, i));
	    break;
	}

    if (device == AuNone)
	fatalError("Couldn't find an output device", NULL);

    if (!(info.flow = AuCreateFlow(info.aud, NULL)))
	fatalError("Couldn't create flow", NULL);

    AuMakeElementImportClient(&elements[0], SAMPLE_RATE, DATA_FORMAT,
			      NUM_TRACKS,
			      AuTrue, BUF_SAMPLES, LOW_WATER, 0, NULL);
    AuMakeElementExportDevice(&elements[1], 0, device, SAMPLE_RATE,
			      AuUnlimitedSamples, 0, NULL);
    AuSetElements(info.aud, info.flow, AuTrue, 2, elements, NULL);

    AuRegisterEventHandler(info.aud, AuEventHandlerIDMask, 0, info.flow,
			   eventHandler, (AuPointer) &info);

    info.buf = (char *) malloc(BUF_SAMPLES * NUM_TRACKS *
			       AuSizeofFormat(DATA_FORMAT));

    AuStartFlow(info.aud, info.flow, NULL);

    while (1)
	AuHandleEvents(info.aud);
}
