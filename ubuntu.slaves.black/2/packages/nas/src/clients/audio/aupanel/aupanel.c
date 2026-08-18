/**
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
 * Author:	Greg Renda <greg@ncd.com>
 * 		Network Computing Devices, Inc.
 * 		350 North Bernardo Ave.
 * 		Mountain View, CA  94043
 *
 * $NCDId: @(#)aupanel.c,v 1.13 1994/11/01 23:20:06 greg Exp $
 */

#include <stdio.h>
#include <stdlib.h>
#ifndef SYSV
#include <audio/Aos.h>		/* for string and other os stuff */
#endif
#include <audio/Afuncs.h> 	/* for bcopy et. al. */
#include <audio/audiolib.h>
#include <audio/soundlib.h>

#include <X11/Intrinsic.h>
#include <X11/StringDefs.h>
#include <X11/Shell.h>
#include <X11/Xaw/Cardinals.h>
#include <audio/Xtutil.h>

/* widgets */
#include <X11/Xaw/Form.h>
#include <X11/Xaw/Command.h>
#include <X11/Xaw/Label.h>
#include <X11/Xaw/Toggle.h>
#include <X11/Xaw/SimpleMenu.h>
#include <X11/Xaw/MenuButton.h>
#include <X11/Xaw/SmeBSB.h>

#include <Slider.h>

#define	APP_CLASS		"Aupanel"

#define DEFAULT_QUERY_INTERVAL  10000UL

#define USAGE "\
usage: aupanel [-a audioserver] [-dev id] [-in seconds]\
"

#define MakeCommandButton(w, parent, label, callback)			       \
{									       \
    (w) = XtCreateManagedWidget(label, commandWidgetClass, parent, NULL, 0);   \
									       \
    if ((void *) (callback) != NULL)					       \
	XtAddCallback(w, XtNcallback, callback, g);			       \
}

#define MakeLabel(w, parent, label)					       \
{									       \
    (w) = XtCreateManagedWidget(label, labelWidgetClass, parent, NULL, 0);     \
}

#define MakeWidget(w, parent, type, name)				       \
{									       \
    (w) = XtCreateManagedWidget(name, type, parent, NULL, 0);		       \
}

typedef struct
{
    Widget          top,
                    form,
                    quit,
                    query,
                    mute,
                    menu,
                    menuButton,
                    device,
                    gainSlider,
                    inputModeLabel,
                    inputModeLine,
                    inputModeMic,
                    outputModeLabel,
                    outputModeSpk,
                    outputModeHead,
                    outputModeLine;
    AuServer       *aud;
    int             numDevices,
                    deviceNum,
                   *restoreValues;
    AuDeviceAttributes *da;
    unsigned long   queryInterval;
    XtIntervalId    queryTimerID;
}               GlobalDataRec, *GlobalDataPtr;

static String   defaultResources[] =
{
    "*input:                          true",
    "*font:                           *courier-medium-r-normal*140*",
    "*query.label:                    Query",
    "*mute.label:                     Mute",
    "*mute.fromHoriz:                 devices",
    "*devices.label:                  Devices",
    "*devices.fromHoriz:              query",
    "*quit.label:                     Quit",
    "*quit.fromHoriz:                 mute",
    "*deviceLabel.label:              Stereo Channel Output",
    "*deviceLabel.fromVert:           query",
    "*deviceLabel.font:               *courier-bold-r-normal*140*",
    "*deviceLabel.resizable:          true",
    "*deviceLabel.borderWidth:        0",
    "*gainSlider.label:               \\ Gain:  %3d%%",
    "*gainSlider.fromVert:            deviceLabel",
    "*gainSlider.min:                 0",
    "*gainSlider.max:                 100",
    "*gainSlider.resizable:           true",
    "*inputModeLabel.label:           \\ Input mode:",
    "*inputModeLabel.fromVert:        gainSlider",
    "*inputModeLabel.borderWidth:     0",
    "*inputModeLine.label:            Line-In",
    "*inputModeLine.fromHoriz:        inputModeLabel",
    "*inputModeLine.fromVert:         gainSlider",
    "*inputModeMic.label:             Microphone",
    "*inputModeMic.fromHoriz:         inputModeLine",
    "*inputModeMic.fromVert:          gainSlider",
    "*inputModeMic.radioGroup:        inputModeLine",
    "*outputModeLabel.label:          Output mode:",
    "*outputModeLabel.fromVert:       inputModeLabel",
    "*outputModeLabel.borderWidth:    0",
    "*outputModeSpk.label:            Speaker",
    "*outputModeSpk.fromHoriz:        outputModeLabel",
    "*outputModeSpk.fromVert:         inputModeLine",
    "*outputModeHead.label:           Headphone",
    "*outputModeHead.fromHoriz:       outputModeSpk",
    "*outputModeHead.fromVert:        inputModeLine",
    "*outputModeLine.label:           Line-Out",
    "*outputModeLine.fromHoriz:       outputModeHead",
    "*outputModeLine.fromVert:        inputModeLine",
    NULL
};

static void
fatalError(const char *message, const char *arg)
{
    fprintf(stderr, message, arg);
    fprintf(stderr, "\n");
    exit(1);
}

static void
quitCB(Widget w, XtPointer gp, XtPointer call_data)
{
    exit(0);
}

static void
showDevice(GlobalDataPtr g)
{
    Boolean         inputModeEnable, outputModeEnable,
                    gainEnable;
    AuDeviceAttributes *da = &g->da[g->deviceNum];

    XtVaSetValues(g->device, XtNlabel, AuDeviceDescription(da)->data, NULL);

    gainEnable = AuDeviceChangableMask(da) & AuCompDeviceGainMask ?
	True : False;
    XtVaSetValues(g->gainSlider, XtNsensitive, gainEnable, NULL);

    if (gainEnable)
	XtVaSetValues(g->gainSlider, XtNvalue,
		      AuFixedPointRoundUp(AuDeviceGain(da)), NULL);

    inputModeEnable = (AuDeviceChangableMask(da) & AuCompDeviceInputModeMask) &&
	(AuDeviceKind(da) == AuComponentKindPhysicalInput) ? True : False;

    outputModeEnable =
	(AuDeviceChangableMask(da) & AuCompDeviceOutputModeMask) &&
	(AuDeviceKind(da) == AuComponentKindPhysicalOutput) ? True : False;

    XtVaSetValues(g->inputModeLabel, XtNsensitive, inputModeEnable, NULL);
    XtVaSetValues(g->inputModeLine, XtNsensitive, inputModeEnable, NULL);
    XtVaSetValues(g->inputModeMic, XtNsensitive, inputModeEnable, NULL);

    XtVaSetValues(g->outputModeLabel, XtNsensitive, outputModeEnable, NULL);
    XtVaSetValues(g->outputModeSpk, XtNsensitive, outputModeEnable, NULL);
    XtVaSetValues(g->outputModeHead, XtNsensitive, outputModeEnable, NULL);
    XtVaSetValues(g->outputModeLine, XtNsensitive, outputModeEnable, NULL);

    if (inputModeEnable)
    {
	Boolean mic = AuDeviceInputMode(da) == AuDeviceInputModeMicrophone;

	XtCallActionProc(g->inputModeLine, mic ? "reset" : "set",
			 NULL, NULL, 0);
	XtCallActionProc(g->inputModeMic, mic ? "set" : "reset",
			 NULL, NULL, 0);
    }
    else
    {
	XtCallActionProc(g->inputModeLine, "reset", NULL, NULL, 0);
	XtCallActionProc(g->inputModeMic, "reset", NULL, NULL, 0);
    }

    if (outputModeEnable)
    {
	XtCallActionProc(g->outputModeSpk,
			 AuDeviceOutputMode(da) & AuDeviceOutputModeSpeaker ?
			 "set" : "reset", NULL, NULL, 0);
	XtCallActionProc(g->outputModeHead,
			 AuDeviceOutputMode(da) & AuDeviceOutputModeHeadphone ?
			 "set" : "reset", NULL, NULL, 0);
	XtCallActionProc(g->outputModeLine,
			 AuDeviceOutputMode(da) & AuDeviceOutputModeLineOut ?
			 "set" : "reset", NULL, NULL, 0);
    }
    else
    {
	XtCallActionProc(g->outputModeSpk, "reset", NULL, NULL, 0);
	XtCallActionProc(g->outputModeHead, "reset", NULL, NULL, 0);
	XtCallActionProc(g->outputModeLine, "reset", NULL, NULL, 0);
    }

    if ((AuFixedPointRoundUp(AuDeviceGain(da)) == 0) &&
        (g->restoreValues[g->deviceNum] > 0))
        XtCallActionProc(g->mute, "set", NULL, NULL, 0);
    else
        XtCallActionProc(g->mute, "reset", NULL, NULL, 0);

}

static void timedQueryCB(XtPointer, XtIntervalId *);

static void
queryCB(Widget w, XtPointer gp, XtPointer call_data)
{
    GlobalDataPtr   g = (GlobalDataPtr) gp;

    if(g->queryInterval)
        XtRemoveTimeOut(g->queryTimerID);

    AuFreeDeviceAttributes(g->aud, g->numDevices, g->da);
    g->da = AuListDevices(g->aud, 0, NULL, &g->numDevices, NULL);
    showDevice(g);

    if(g->queryInterval)
        g->queryTimerID = XtAppAddTimeOut(XtWidgetToApplicationContext(g->top),
                                          g->queryInterval, timedQueryCB, gp);
}

static void
timedQueryCB(XtPointer gp, XtIntervalId *queryIntervalID)
{
    GlobalDataPtr   g = (GlobalDataPtr) gp;

    queryCB(g->top, gp, NULL);
}

static void
inputModeCB(Widget w, XtPointer gp, XtPointer call_data)
{
    GlobalDataPtr   g = (GlobalDataPtr) gp;
    AuDeviceAttributes *da = &g->da[g->deviceNum];
    Boolean state;

    XtVaGetValues(w, XtNstate, &state, NULL);

    if (!state)			/* ignore resets */
	return;

    AuDeviceInputMode(da) = (int) XawToggleGetCurrent(w) == 1
	? AuDeviceInputModeLineIn : AuDeviceInputModeMicrophone;

    AuSetDeviceAttributes(g->aud, AuDeviceIdentifier(da),
			  AuCompDeviceInputModeMask, da, NULL);
}

static void
outputModeCB(Widget w, XtPointer gp, XtPointer call_data)
{
    GlobalDataPtr   g = (GlobalDataPtr) gp;
    AuDeviceAttributes *da = &g->da[g->deviceNum];
    Boolean state;
    int mode;

    mode = w == g->outputModeSpk ? AuDeviceOutputModeSpeaker :
	(w == g->outputModeHead ? AuDeviceOutputModeHeadphone :
	 AuDeviceOutputModeLineOut);

    XtVaGetValues(w, XtNstate, &state, NULL);

    if (state)
	AuDeviceOutputMode(da) |= mode;
    else
	AuDeviceOutputMode(da) &= ~mode;

    AuSetDeviceAttributes(g->aud, AuDeviceIdentifier(da),
			  AuCompDeviceOutputModeMask, da, NULL);
    queryCB(w, g, call_data);
}

static void set_device_by_name(GlobalDataPtr g, const char *name);

static void
menuCB(Widget w, XtPointer gp, XtPointer call_data)
{
    GlobalDataPtr   g = (GlobalDataPtr) gp;
    String          string;

    XtVaGetValues(w, XtNlabel, &string, NULL);
    XtVaSetValues(g->device, XtNlabel, string, NULL);
    set_device_by_name(g, string);
    queryCB(w, g, call_data);
    showDevice(g);
}

static void
setGain(Widget w, XtPointer gp, XtPointer valuep)
{
    GlobalDataPtr   g = (GlobalDataPtr) gp;
    AuDeviceAttributes *da = &g->da[g->deviceNum];
    int             value = (int) valuep;

    AuDeviceGain(da) = AuFixedPointFromSum(value, 0);
    AuSetDeviceAttributes(g->aud, AuDeviceIdentifier(da),
			  AuCompDeviceGainMask, da, NULL);

    if ((AuFixedPointRoundUp(AuDeviceGain(da)) != 0) &&
        (g->restoreValues[g->deviceNum] > 0)) {
        g->restoreValues[g->deviceNum] = 0;
        XtCallActionProc(g->mute, "reset", NULL, NULL, 0);
    }
}

static void
muteCB(Widget w, XtPointer gp, XtPointer call_data)
{
    GlobalDataPtr g = (GlobalDataPtr) gp;
    AuDeviceAttributes *da;
    int current;

    queryCB(w, gp, call_data);
    da = &g->da[g->deviceNum];
    current = AuFixedPointRoundUp(AuDeviceGain(da));

    if(current > 0) {
        g->restoreValues[g->deviceNum] = current;
        setGain(w, gp, (XtPointer)0);
    } else if(g->restoreValues[g->deviceNum] > 0){
        setGain(w, gp, (XtPointer)g->restoreValues[g->deviceNum]);
        g->restoreValues[g->deviceNum] = 0;
    }
    showDevice((GlobalDataPtr)gp);
}

static void
createWidgets(GlobalDataPtr g)
{
    int             i;
    Widget          w;

    MakeWidget(g->form, g->top, formWidgetClass, "form");

    MakeCommandButton(g->query, g->form, "query", queryCB);

    g->menu = XtCreatePopupShell("menu", simpleMenuWidgetClass, g->form,
				 NULL, 0);

    g->da = AuListDevices(g->aud, 0, NULL, &g->numDevices, NULL);

    if (!g->numDevices)
	fatalError("no devices", NULL);

    for (i = 0; i < g->numDevices; i++)
    {
	MakeWidget(w, g->menu, smeBSBObjectClass,
		   AuDeviceDescription(&g->da[i])->data);
	XtAddCallback(w, XtNcallback, menuCB, g);
    }

    MakeWidget(g->menuButton, g->form, menuButtonWidgetClass, "devices");

    MakeWidget(g->mute, g->form, toggleWidgetClass, "mute");
    XtAddCallback(g->mute, XtNcallback, muteCB, g);
    XtVaSetValues(g->mute, XtNsensitive, True, NULL);

    MakeCommandButton(g->quit, g->form, "quit", quitCB);

    MakeLabel(g->device, g->form, "deviceLabel");

    MakeWidget(g->gainSlider, g->form, sliderWidgetClass, "gainSlider");
    XtAddCallback(g->gainSlider, XtNcallback, setGain, g);

    MakeLabel(g->inputModeLabel, g->form, "inputModeLabel");
    MakeWidget(g->inputModeLine, g->form, toggleWidgetClass, "inputModeLine");
    MakeWidget(g->inputModeMic, g->form, toggleWidgetClass, "inputModeMic");
    XtAddCallback(g->inputModeLine, XtNcallback, inputModeCB, g);
    XtAddCallback(g->inputModeMic, XtNcallback, inputModeCB, g);
    XtVaSetValues(g->inputModeLine, XtNradioData, 1, NULL);
    XtVaSetValues(g->inputModeMic, XtNradioData, 2, NULL);

    MakeLabel(g->outputModeLabel, g->form, "outputModeLabel");
    MakeWidget(g->outputModeSpk, g->form, toggleWidgetClass, "outputModeSpk");
    MakeWidget(g->outputModeHead, g->form, toggleWidgetClass, "outputModeHead");
    MakeWidget(g->outputModeLine, g->form, toggleWidgetClass, "outputModeLine");
    XtAddCallback(g->outputModeSpk, XtNcallback, outputModeCB, g);
    XtAddCallback(g->outputModeHead, XtNcallback, outputModeCB, g);
    XtAddCallback(g->outputModeLine, XtNcallback, outputModeCB, g);
}

static void
alignWidgets(GlobalDataPtr g)
{
    Dimension       w,
                    w1;
    Position        x,
                    x1;
    int             d;

    XtVaGetValues(g->outputModeLine, XtNwidth, &w, XtNx, &x, NULL);
    XtVaGetValues(g->gainSlider, XtNhorizDistance, &d, NULL);
    XtVaSetValues(g->gainSlider, XtNwidth, w + x - d, NULL);

    XtVaGetValues(g->device, XtNhorizDistance, &d, NULL);
    XtVaSetValues(g->device, XtNwidth, w + x - d, NULL);

    XtVaGetValues(g->quit, XtNx, &x1, XtNhorizDistance, &d, XtNwidth, &w1,
		  NULL);
    XtVaSetValues(g->quit, XtNhorizDistance, w - w1 - (x1 - d - x), NULL);

    XtVaSetValues(g->device, XtNresizable, False, NULL);
}

static AuInt32 parse_hex(const char *s)
{
    AuInt32 val = 0;

    sscanf (s, "%lx", &val);
    return val;
}

static AuBool is_decimal_number(const char *s)
{
    int i;

    if (!s)
        return AuFalse;

    for (i=0; s[i]; i++)
        if ((s[i] < '0') || (s[i] > '9'))
            return AuFalse;

    return AuTrue;
}

static AuDeviceID parse_device_id(const char *s)
{
    if ((s[0] == '0') && ((s[1] == 'x') || (s[1] == 'X')))
        return parse_hex(s);
    return AuNone;
}

static void set_device_by_id(GlobalDataPtr g, AuDeviceID id)
{
    int i;
    AuDeviceAttributes *d;

    for (i=0; i<g->numDevices; i++) {
        d = AuServerDevice(g->aud, i);
        if ((AuDeviceValueMask(d) & AuCompCommonIDMask) &&
            id == d->common.id) {
            g->deviceNum = i;
            break;
        }
    }
}

static void set_device_by_name(GlobalDataPtr g, const char *name)
{
    int i;

    for (i = 0; i < g->numDevices; i++)
	if (!strcmp(name, AuDeviceDescription(&g->da[i])->data)) {
            g->deviceNum = i;
	    break;
        }
}

int
main(int argc, char **argv)
{
    GlobalDataRec   globals;
    GlobalDataPtr   g = &globals;
    XtAppContext    appContext;
    char           *audioServer = NULL;
    int             i;
    AuDeviceID      initialDevice = AuNone;
    char           *initialDeviceName = NULL;

    g->top = XtVaAppInitialize(&appContext, APP_CLASS, NULL, ZERO,
			       &argc, argv, defaultResources, NULL, NULL);

    g->queryInterval = DEFAULT_QUERY_INTERVAL;

    for (i = 1; i < argc; i++) {
        if (!strncmp(argv[i], "-a", 2)) {
            audioServer = argv[++i];
        } else if (!strncmp(argv[i], "-dev", 4)) {
            initialDeviceName = argv[++i];
            initialDevice = parse_device_id(initialDeviceName);
        } else if (!strncmp(argv[i], "-in", 3)) {
            int tmp = atoi(argv[++i]);
            if (tmp >= 0) {
                g->queryInterval = tmp * 1000;
            }
        } else {
            fatalError(USAGE, NULL);
        }
    }

    if (!(g->aud = AuOpenServer(audioServer, 0, NULL, 0, NULL, NULL)))
	fatalError("Can't connect to audio server", NULL);

    if(!(g->restoreValues = calloc(AuServerNumDevices(g->aud), sizeof(int))))
        fatalError("Out of memory", NULL);

    createWidgets(g);
    XtRealizeWidget(g->top);
    alignWidgets(g);

    AuXtAppAddAudioHandler(appContext, g->aud);

    g->deviceNum = 0;

    if (initialDevice != AuNone) {
        set_device_by_id(g, initialDevice);
    } else if (initialDeviceName) {
        if (is_decimal_number(initialDeviceName)) {
            g->deviceNum = atoi(initialDeviceName);
            if (g->deviceNum >= g->numDevices) {
                fprintf(stderr, "cannot activate device %d, there are only %d"
                                " devices (0 to %d)\n",
                                g->deviceNum, g->numDevices, g->numDevices - 1);
                g->deviceNum = 0;
            }
        } else {
            set_device_by_name(g, initialDeviceName);
        }
    }

    showDevice(g);

    g->queryTimerID = XtAppAddTimeOut(appContext, g->queryInterval,
                                      timedQueryCB , g);

    XtAppMainLoop(appContext);

    free(g->restoreValues);
    return 0;
}
