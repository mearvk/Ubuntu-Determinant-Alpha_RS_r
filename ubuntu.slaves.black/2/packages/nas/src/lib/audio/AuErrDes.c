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
 * $NCDId: @(#)AuErrDes.c,v 1.7 1994/08/09 17:34:27 greg Exp $
 */

#ifndef ERRORDB
#define ERRORDB "/usr/lib/X11/AuErrorDB"
#endif /* !ERRORDB */

#include "Alibint.h"
#include <audio/Aos.h>

#undef BufAlloc
#ifdef USG
#define __TIMEVAL__	/* prevent redefinition of struct timeval */
#endif

#define NO_XLIB
#ifndef NO_XLIB
#include <X11/Xlibint.h>
#include <X11/Xresource.h>
#endif /* !NO_XLIB */

#if XlibSpecificationRelease < 5
typedef char   *XPointer;
#endif

static const char * const _AuErrorList[] = {
    /* No error	*/		"no error",
    /* AuBadRequest */		"BadRequest",
    /* AuBadValue */		"BadValue",
    /* AuBadDevice */		"BadDevice",
    /* AuBadBucket */		"BadBucket",
    /* AuBadFlow */		"BadFlow",
    /* AuBadElement */		"BadElement",
    /* empty */			"no error",
    /* AuBadMatch */		"BadMatch",
    /* empty */			"no error",
    /* AuBadAccess */		"BadAccess",
    /* AuBadAlloc */		"BadAlloc",
    /* empty */  		"no error",
    /* AuBadConnection */  	"BadConnection",
    /* AuBadIDChoice */		"BadIDChoice",
    /* AuBadName */		"BadName",
    /* AuBadLength */		"BadLength",
    /* AuBadImplementation */	"BadImplementation",
};

#ifdef NO_XLIB
#define False			0
#define True			(!False)
#define XrmInitialize()
#define XrmGetFileDatabase	getFileDataBase
#define XrmGetResource(_db, _name, _class, _type_ret, _value_ret)	      \
	getResource(_db, _name, _value_ret)

typedef char   *XrmString;
typedef struct
{
    XPointer        addr;
    int             size;
}               XrmValue;

typedef struct _dbNode
{
    char           *key,
                   *value;
    int             len;
    struct _dbNode *next,
                   *child;
}               dbNodeRec, *dbNodePtr;

typedef dbNodePtr XrmDatabase;

static dbNodePtr
addNode(dbNodePtr parent, dbNodePtr sib, char *p)
{
    dbNodePtr       n;

    if (!(n = (dbNodePtr) Aumalloc(sizeof(dbNodeRec))))
	return NULL;

    if (sib)
	sib->next = n;
    else if (parent)
	parent->child = n;

    n->key = strdup(p);
    n->child = n->next = NULL;
    return n;
}

static XrmDatabase
getFileDataBase(const char *filename)
{
    FILE           *fp;
    char            line[BUFSIZ],
                   *res,
                   *arg,
                   *p;
    dbNodePtr       db = NULL,
                    n,
                    parent,
                    sib;

    if (!(fp = fopen(filename, "r")))
	return NULL;

    while (fgets(line, BUFSIZE, fp))
    {
	if (*line == '!' || !(res = strtok(line, ":")) ||
	    !(arg = strtok(NULL, "\n")))
	    continue;

	while (*arg == ' ' || *arg == '\t')
	    arg++;

	n = db;
	sib = parent = NULL;
	p = strtok(res, ".");

	while (p)
	{
	    while (n)
	    {
		if (!strcmp(p, n->key))
		    break;

		sib = n;
		n = n->next;
	    }

	    if (n)
	    {
		parent = n;
		sib = NULL;
		n = n->child;
	    }
	    else
	    {
		parent = addNode(parent, sib, p);
		n = sib = NULL;

		if (!db)
		    db = parent;
	    }

	    p = strtok(NULL, ".");
	}

	if (parent)
	{
	    parent->value = strdup(arg);
	    parent->len = strlen(parent->value);
	}
    }

    return (XrmDatabase) db;
}

static AuBool
getResource(XrmDatabase db, char *name, XrmValue *value_ret)
{
    char           *p;
    dbNodePtr       parent;

    value_ret->addr = (XPointer) NULL;
    p = strtok(name, ".");

    while (p)
    {
	parent = NULL;

	while (db)
	{
	    if (!strcmp(db->key, p))
	    {
		parent = db;
		db = db->child;
		break;
	    }
	    else
		db = db->next;
	}

	if (!parent)
	    return AuFalse;

	p = strtok(NULL, ".");
    }

    value_ret->addr = parent->value;
    value_ret->size = parent->len;
    return AuTrue;
}
#endif						/* NO_XLIB */

void
AuGetErrorText(AuServer *aud, int code, 
               char *buffer, int nbytes)
{
    char buf[150];
    _AuExtension *ext;
    _AuExtension *bext = (_AuExtension *)NULL;

    if (nbytes == 0) return;
    if (code <= AuBadImplementation && code > 0) {
	sprintf(buf, "%d", code);
	AuGetErrorDatabaseText(aud, "AuProtoError", buf, _AuErrorList[code],
			      buffer, nbytes);
    } else
	buffer[0] = '\0';
    ext = aud->ext_procs;
    while (ext) {		/* call out to any extensions interested */
 	if (ext->error_string != NULL) 
 	    (*ext->error_string)(aud, code, &ext->codes, buffer, nbytes);
	if (ext->codes.first_error &&
	    ext->codes.first_error < code &&
	    (!bext || ext->codes.first_error > bext->codes.first_error))
	    bext = ext;
 	ext = ext->next;
    }    
    if (!buffer[0] && bext) {
	sprintf(buf, "%s.%d", bext->name, code - bext->codes.first_error);
	AuGetErrorDatabaseText(aud, "AuProtoError", buf, "", buffer, nbytes);
    }
    if (!buffer[0])
	sprintf(buffer, "%d", code);
    return;
}

void
/*ARGSUSED*/
AuGetErrorDatabaseText(
    AuServer *aud,
    const char *name,
    const char *type,
    const char *defaultp,
    char *buffer,
    int nbytes)
{
    static XrmDatabase db;
    static int initialized = False;
    XrmString type_str;
    XrmValue result;
    char temp[BUFSIZ];

    if (nbytes == 0) return;
    if (!initialized) {
	XrmInitialize();
        db = XrmGetFileDatabase(ERRORDB);
	initialized = True;
    }
    if (db)
    {
	sprintf(temp, "%s.%s", name, type);
	XrmGetResource(db, temp, "ErrorType.ErrorNumber", &type_str, &result);
    }
    else
	result.addr = (XPointer)NULL;
    if (!result.addr) {
	result.addr = (XPointer) defaultp;
	result.size = strlen(defaultp) + 1;
    }
    (void) strncpy (buffer, (char *) result.addr, nbytes);
    if (result.size > nbytes) buffer[nbytes-1] = '\0';
}
