/*
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
 * $NCDId: @(#)execute.c,v 1.7 1994/04/07 18:10:33 greg Exp $
 */

#include "auctl.h"

static int _execute_set PROTO((AuServer *, int, char **));
static int _execute_list PROTO((AuServer *, int, char **));
static int _execute_help PROTO((AuServer *, int, char **));
static int _execute_nop PROTO((AuServer *, int, char **));

static int _execute_list_device PROTO((AuServer *, int, char **, AuPointer));
static int _execute_list_gain PROTO((AuServer *, int, char **, AuPointer));
static int _execute_list_linemode PROTO((AuServer *, int, char **, AuPointer));
static int _execute_set_device PROTO((AuServer *, int, char **, AuPointer));
static int _execute_set_gain PROTO((AuServer *, int, char **, AuPointer));
static int _execute_set_linemode PROTO((AuServer *, int, char **, AuPointer));

static char *_lower_word PROTO((char *));
static AuInt32 _parse_long PROTO((char *, AuBool *));

#define NELEMS(what) ((sizeof(what))/(sizeof((what)[0])))

int execute_command (AuServer *aud, int argc, char **argv, AuBool *donep)
{
    static struct {
	const char *name;
	int (*proc) PROTO((AuServer *, int, char **));
	AuBool done;
    } keytab[] = {
	{ "set",	_execute_set,		AuFalse },
	{ "list",	_execute_list,		AuFalse },
	{ "help",	_execute_help,		AuFalse },
	{ "?",		_execute_help,		AuFalse },
	{ "quit",	_execute_nop,		AuTrue },
	{ "exit",	_execute_nop,		AuTrue },
    };
    int i;
    int len;

    len = strlen (_lower_word(argv[0]));
    for (i = 0; i < NELEMS(keytab); i++) {
	if (strncmp (argv[0], keytab[i].name, len) == 0) {
	    if (donep && keytab[i].done)
		*donep = AuTrue;
	    return (*keytab[i].proc) (aud, argc - 1, argv + 1);
	}
    }

    fprintf (stderr, "%s: unknown command: %s\n", ProgramName, argv[0]);
    return 1;
}


typedef struct _NameValue {
    const char *name;
#ifndef mips
    int (*proc) PROTO ((AuServer *, int, char **, AuPointer));
#else
    int (*proc)();
#endif
} NameTable;

static int 
_do_parse (AuServer *aud, int argc, char **argv, const char *title,
           NameTable *tab, int ntab, AuPointer data)
{
    int i;
    int len;

    len = strlen (_lower_word(argv[0]));
    for (i = 0; i < ntab; i++) {
	if (strncmp (argv[0], tab[i].name, len) == 0) {
	    return (*tab[i].proc) (aud, argc - 1, argv + 1, data);
	}
    }

    fprintf (stderr, "%s: unknown %s command: %s\n",
	     ProgramName, title, argv[0]);
    return 1;
}
    

static int _execute_set (AuServer *aud, int argc, char **argv)
{
    static NameTable settab[] = {
	{ "device",	_execute_set_device },
    };

    if (argc < 2) {
	fprintf (stderr, "%s:  no set operation\n", ProgramName);
	return 1;
    }

    return _do_parse (aud, argc, argv, "set", settab, NELEMS(settab),
		      NULL);
}



static int _execute_list (AuServer *aud, int argc, char **argv)
{
    static NameTable settab[] = {
	{ "device",	_execute_list_device },
    };

    if (argc < 2) {
	fprintf (stderr, "%s:  no list operation\n", ProgramName);
	return 1;
    }

    return _do_parse (aud, argc, argv, "list", settab, NELEMS(settab), NULL);
}


static AuDeviceID _parse_device_id (AuServer *aud, char *s)
{
    AuBool ishex; 
    AuDeviceID id = _parse_long (s, &ishex);
    int i;
    AuDeviceAttributes *d;

    if (ishex && !id) {
	fprintf (stderr, "%s: invalid device id\n", ProgramName);
	return AuNone;
    }
    if (ishex) {
	for (i = 0; i < AuServerNumDevices(aud); i++) {
	    d = AuServerDevice(aud,i);
	    if ((AuDeviceValueMask(d) & AuCompCommonIDMask) &&
		id == d->common.id)
		break;
	}
	if (i == AuServerNumDevices(aud)) {
	  nodev:
	    fprintf (stderr, "%s: no such device: 0x%lx\n",
		     ProgramName, id);
	    return AuNone;
	}
    } else {
	if (id >= AuServerNumDevices(aud) ||
	    !(d = AuServerDevice (aud, id)) ||
	    !(AuDeviceValueMask(d) & AuCompCommonIDMask))
	    goto nodev;
	id = d->common.id;
    }
    return id;
}



/* ARGSUSED */
static int
_execute_set_device (AuServer *aud, int argc, char **argv, AuPointer data)
{
    AuDeviceID id;
    static NameTable optab[] = {
	{ "gain=",	_execute_set_gain },
	{ "linemode=",	_execute_set_linemode },
    };

    /*
     *     DEVID "gain" "=" PERCENTAGE
     *     DEVID "line[mode]" "=" {l[ow],h[igh]}
     */
    
    if (argc < 2)
	return 1;

    id = _parse_device_id (aud, argv[0]);
    if (id == AuNone)
	return 1;

    return _do_parse (aud, argc - 1, argv + 1, "set device", 
		      optab, NELEMS(optab), (AuPointer) &id);
}


static int _do_list_device_attributes(AuServer *aud, AuDeviceID id, AuMask mask)
{
    AuStatus status;
    AuDeviceAttributes *d = AuGetDeviceAttributes (aud, id, &status);
    int errors = 0;

    if (!d) {
	fprintf (stderr, "%s: unable to list device 0x%lx\n",
		 ProgramName, id);
	return 1;
    }
    if (mask & AuCompDeviceGainMask) {
	if (!(AuDeviceValueMask(d) & AuCompDeviceGainMask)) {
	    fprintf (stderr, "%s: device 0x%lx does not provide gain\n",
		     ProgramName, id);
	    errors++;
	} else
	    printf ("set device 0x%lx gain = %d\n", id,
		    AuFixedPointRoundDown(AuDeviceGain(d)));
    }
    if (mask & AuCompDeviceLineModeMask) {
	if (!(AuDeviceValueMask(d) & AuCompDeviceLineModeMask)) {
	    fprintf (stderr, "%s: device 0x%lx does not provide line mode\n",
		     ProgramName, id);
	    errors++;
	} else {
	    char *what;
	    char tmp[20];

	    switch (AuDeviceLineMode(d)) {
	      case AuDeviceLineModeNone: what = "none"; break;
	      case AuDeviceLineModeLow: what = "low"; break;
	      case AuDeviceLineModeHigh: what = "high"; break;
	      default: sprintf (what = tmp, "%d", AuDeviceLineMode(d)); break;
	    }
	    printf ("set device 0x%lx linemode = %s\n", id, what);
	}
    }
    AuFreeDeviceAttributes (aud, 1, d);
    return errors;
}


/* ARGSUSED */
static int
_execute_list_device (AuServer *aud, int argc, char **argv, AuPointer data)
{
    AuDeviceID id;
    static NameTable optab[] = {
	{ "gain",	_execute_list_gain },
	{ "linemode",	_execute_list_linemode },
    };

    /*
     *     DEVID "gain"
     *     DEVID "line[mode]"
     */
    
    if (argc < 1)
	return 1;

    id = _parse_device_id (aud, argv[0]);
    if (id == AuNone)
	return 1;

    if (argc == 1) {
	return _do_list_device_attributes (aud, id,
					   (AuCompDeviceGainMask |
					    AuCompDeviceLineModeMask));
    } else
	return _do_parse (aud, argc - 1, argv + 1, "list device", 
			  optab, NELEMS(optab), (AuPointer) &id);
}



/* ARGSUSED */
static int
_execute_list_gain (AuServer *aud, int argc, char **argv, AuPointer data)
{
    AuDeviceID id = *(AuDeviceID *) data;
    return _do_list_device_attributes (aud, id, AuCompDeviceGainMask);
}


/* ARGSUSED */
static int
_execute_list_linemode (AuServer *aud, int argc, char **argv, AuPointer data)
{
    AuDeviceID id = *(AuDeviceID *) data;
    return _do_list_device_attributes (aud, id, AuCompDeviceGainMask);
}


static int _execute_help (AuServer *aud, int argc, char **argv)
{
    static const char * const msg[] = {
"The following commands are supported:",
"",
"    help                             print this message",
"    set device ID gain =/+/- PERCENT set the gain on a device",
"    set device ID linemode = low     set the device line mode",
"    set device ID linemode = high    set the device line mode",
"    list device ID gain              list the gain of a device",
"    list device ID linemode          list the linemode of a device",
"    list device ID                   list the gain and linemode of a device",
"    quit, exit, or ^D                exit the program",
"",
"A device ID may either be a decimal number (e.g., 0) indicating",
"the nth device returned by the server, or a hexidecimal number",
"(e.g., 0x32) specifying the resource id of the device.",
"",
	(char *) 0
    };
    const char * const *cpp;

    for (cpp = msg; *cpp; cpp++) 
	printf ("%s\n", *cpp);

    return 0;
}

    
/* ARGSUSED */
static int _execute_nop (AuServer *aud, int argc, char **argv)
{
    return 0;
}


static int
_execute_set_gain (AuServer *aud, int argc, char **argv, AuPointer data)
{
    AuDeviceID id = *(AuDeviceID *) data;
    int p;
    AuDeviceAttributes attr;
    AuStatus status;
    int delta = 0;

    /*
     *     ["=","+","-" ] PERCENTAGE
     */
    switch (argc) {
      case 2:
	switch (argv[0][0]) {
	  case '=':
	    delta = 0;
	    break;
	  case '+':
	    delta = +1;
	    break;
	  case '-':
	    delta = -1;
	    break;
	  default:
	  usage:
	    fprintf (stderr, "%s: invalid gain syntax\n", ProgramName);
	    return 1;
	}
	argc--, argv++;
	/* fall through */
      case 1:
	p = atoi (argv[0]);
	if (delta) {
	    delta *= p;
	    if (!delta)  /* no change (i.e. +/- 0), so we're done */
		return 0;
	}
	break;

      default:
	goto usage;
    }

    if (delta) {

	AuDeviceAttributes *d = AuGetDeviceAttributes (aud, id, &status);

	if (!d) {
	    fprintf (stderr, "%s: unable to get device 0x%lx gain\n",
		     ProgramName, id);
	    return 1;
	}
	if (!(AuDeviceValueMask(d) & AuCompDeviceGainMask)) {
	    fprintf (stderr, "%s: device 0x%lx does not provide current gain\n",
		     ProgramName, id);
	    return 1;
	} else {
	    p = AuFixedPointRoundDown(AuDeviceGain(d));
	}

	AuFreeDeviceAttributes (aud, 1, d);

	p += delta;
	if (p < 0)
	    p = 0;
	else if (p > 100)
	    p = 100;
    }

    /* okay, we can now set the gain for the specified device */
    attr.device.gain = AuFixedPointFromSum (p, 0);
    AuSetDeviceAttributes (aud, id, AuCompDeviceGainMask, &attr, &status);
    if (status != AuSuccess) {
	fprintf (stderr, "%s: unable to set gain on device 0x%lx\n",
		 ProgramName, id);
	return 1;
    }
    return 0;
}

static int
_execute_set_linemode (AuServer *aud, int argc, char **argv, AuPointer data)
{
    AuDeviceID id = *(AuDeviceID *) data;
    AuDeviceAttributes attr;
    AuStatus status;
    static struct {
	const char *name;
	int value;
    } lmtab[] = {
	{ "none",	AuDeviceLineModeNone },
	{ "low",	AuDeviceLineModeLow },
	{ "high",	AuDeviceLineModeHigh },
    };
    int i;
    int len;

    /*
     *     ["="] {lo,hi}
     */
    switch (argc) {
      case 2:
	if (argv[0][0] != '=') {
	  usage:
	    fprintf (stderr, "%s: invalid linemode syntax\n", ProgramName);
	    return 1;
	}
	argc--, argv++;
	/* fall through */
      case 1:
	break;

      default:
	goto usage;
    }

    len = strlen (argv[0]);
    for (i = 0; i < ((sizeof lmtab)/(sizeof lmtab[0])); i++) {
	if (strncmp (argv[0], lmtab[i].name, len) == 0)
	    break;
    }
    if (i == ((sizeof lmtab)/(sizeof lmtab[0]))) {
	fprintf (stderr, "%s: invalid linemode value\n", ProgramName);
	return 1;
    }

    /* okay, we can now set the gain for the specified device */
    attr.device.line_mode = lmtab[i].value;
    AuSetDeviceAttributes (aud, id, AuCompDeviceLineModeMask, &attr, &status);
    if (status != AuSuccess) {
	fprintf (stderr, "%s: unable to set line mode on device 0x%lx\n",
		 ProgramName, id);
	return 1;
    }
    return 0;
}




static char *_lower_word (char *s)
{
    char *cp;

    for (cp = s; *cp; cp++) {
	if (isupper(*cp))
	    *cp = tolower (*cp);
    }
    return s;
}


static AuInt32 _parse_long (char *s, AuBool *ishexp)
{
    const char *fmt = "%ld";
    AuInt32 val = 0;

    if (*s == '0') s++;
    if (*s == 'x' || *s == 'X') {
	s++;
	fmt = "%lx";
	*ishexp = AuTrue;
    } else
	*ishexp = AuFalse;

    sscanf (s, fmt, &val);
    return val;
}
