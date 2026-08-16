/*
 *  Copyright 1993 Open Software Foundation, Inc., Cambridge, Massachusetts.
 *  All rights reserved.
 */
/*
 * Copyright (c) 1994  
 * Open Software Foundation, Inc. 
 *  
 * Permission is hereby granted to use, copy, modify and freely distribute 
 * the software in this file and its documentation for any purpose without 
 * fee, provided that the above copyright notice appears in all copies and 
 * that both the copyright notice and this permission notice appear in 
 * supporting documentation.  Further, provided that the name of Open 
 * Software Foundation, Inc. ("OSF") not be used in advertising or 
 * publicity pertaining to distribution of the software without prior 
 * written permission from OSF.  OSF makes no representations about the 
 * suitability of this software for any purpose.  It is provided "as is" 
 * without express or implied warranty. 
 */
/*
 * Copyright (c) 1996 X Consortium
 * Copyright (c) 1995, 1996 Dalrymple Consulting
 * 
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 * 
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 * 
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
 * X CONSORTIUM OR DALRYMPLE CONSULTING BE LIABLE FOR ANY CLAIM, DAMAGES OR
 * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
 * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
 * OTHER DEALINGS IN THE SOFTWARE.
 * 
 * Except as contained in this notice, the names of the X Consortium and
 * Dalrymple Consulting shall not be used in advertising or otherwise to
 * promote the sale, use or other dealings in this Software without prior
 * written authorization.
 */
/* ________________________________________________________________________
 *
 *  Program to read an SGML document instance, creating any of several things:
 *
 *	"translated" output for formatting applications (given a trans. spec)
 *	validation report (given a appropriate trans spec)
 *	tree of the document's structure
 *	statistics about the element usage
 *	summary of the elements used
 *	context of each element used
 *	IDs of each element
 *
 *  A C structure is created for each element, which includes:
 *	name, attributes, parent, children, content
 *  The tree is descended, and the desired actions performed.
 *
 *  Takes input from James Clark's "sgmls" program (v. 1.1).
 * ________________________________________________________________________
 *
 *
 * [ANS-db3l]
 *   General modifications for better interaction with DocBook markup.
 *   Significant changes (but not every change) marked in source with
 *   ANS tag as above.  Primary for this module is processing of ESIS
 *   data for elements (ESIS quoting/CMAP/SDATA) here rather than holding
 *   off until DoData() or OutputString().
 *
 */

#ifndef lint
static char *RCSid =
  "$Header: /aolnet/dev/src/CVS/sgml/docbook-to-man/Instant/main.c,v 1.3 1999/02/23 20:31:37 db3l Exp $";
#endif

#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <string.h>
#include <memory.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <sys/file.h>
#include <time.h>

#define STORAGE
#include "general.h"

/* [ANS-db3l] Included for character mapping in ReadESIS */
#include <tptregexp.h>
#include "translate.h"

/* [ANS-db3l] Don't have "makeVersionFile", so just stamp the overall */
/* release here.  Starting with 2.0 to isolate from earlier releases, */ 
/* and tagging with ANS to distinguish it a bit further.	      */
#define VERSION "2.0(0)-ANS"

static int	do_context, do_tree, do_summ, do_stats, do_validate, do_idlist;
static int	do_DATAhack = 0;
static char	*this_prog;
static char	*in_file, *out_file;
static char	*tranfile, *cmapfile, *sdatafile;
static char	*start_id;
static char	*last_file;
static int	last_lineno;

extern int	BOFTTextThresh;

/* forward references */
static void	HandleArgs(int, char *[]);
static void	Initialize1();
static void	Initialize2();
static void	ReadInstance(char *);
static void	DoHelpMessage();
extern void	Browse();

/* external reference to version number */
extern char	_HeadVeRsIoN_[];

/* ______________________________________________________________________ */
/*  Program entry point.  Look at args, read instance, dispatch to the
 *  correct routines to do the work, and finish.
 */

int
main(
    int		ac,
    char	*av[]
)
{
    Initialize1(av[0]);
    HandleArgs(ac, av);
    Initialize2();

    if (sdatafile) ReadSDATA(sdatafile);
    if (cmapfile)  ReadCharMap(cmapfile);

    ReadInstance(in_file);

    if (interactive) {
	Browse();	/* this will handle interactive commands */
    }
    else {
	/* Perform tasks based on command line flags... */
	if (tranfile) {
	    Element_t *e;
	    /* If user wants to start at a particular ID, point to that
	     * element.  Else, point to the top of the tree. */
	    if (start_id) {
		if (!(e=FindElemByID(start_id))) {
		    fprintf(stderr, "Error: Can not find element with ID %s\n",
			start_id);
		    exit(1);
		}
	    }
	    else e = DocTree;
	    /* If we're doing validation, make output file pointer null.
	     * This means that we generate no output, except error messages. */
	    if (do_validate) outfp = NULL;
	    DoTranslate(e, tranfile, outfp);
	}
	if (do_summ)		PrintElemSummary(DocTree);
	if (do_tree)		PrintElemTree(DocTree);
	if (do_stats)		PrintStats(DocTree);
	if (do_context)		PrintContext(DocTree);
	if (do_idlist)		PrintIDList();
    }
    if (out_file && outfp) fclose(outfp);

    return 0;
}

/* ______________________________________________________________________ */
/* Initialization stuff done before dealing with args.
 *  Arguments:
 *	Name of program (string).
 */

static void
Initialize1(
    char	*myname
)
{
    time_t	tnow;
    struct tm	*nowtm;
    char	*cp, buf[100];
    extern	int gethostname(char *, int);	/* not in a system .h file... */

    /* where we try to find data/library files */
    if (!(tpt_lib=getenv(TPT_LIB))) tpt_lib = DEF_TPT_LIB;

    /* set some global variables */
    warnings  = 1;
    fold_case = 1;
    this_prog = myname;

    /* setup global variable mapping */
    Variables = NewMap(IMS_variables);

    /* set some pre-defined variables */
    SetMappingNV(Variables, "user", (cp=getenv("USER")) ? cp : "UnknownUser" );
    time(&tnow);
    nowtm = localtime(&tnow);
    strftime(buf, 100, "%a %d %b %Y, %R", nowtm);
    SetMappingNV(Variables, "date", buf);
    if (gethostname(buf, 100) < 0) strcpy(buf, "unknown-host");
    SetMappingNV(Variables, "host", buf);
    SetMappingNV(Variables, "transpec", tranfile ? tranfile : "??");
}

/* Initialization stuff done after dealing with args. */

static void
Initialize2()
{
    SetMappingNV(Variables, "transpec", tranfile ? tranfile : "??");

    /* If user wants to send output to a file, open the file, and set
     * the file pointer.  Else we send output to standard out. */
    if (out_file) {
	if (!(outfp = fopen(out_file, "w"))) {
	    fprintf(stderr, "Could not open output '%s' file for writing.\n%s",
		out_file, strerror(errno));
	    exit(1);
	}
    }
    else outfp = stdout;
}

/* ______________________________________________________________________ */
/*  Set a variable.  If it is one of the "known" variables, set the
 *  variable in the C code (this program).
 *  Arguments:
 *	Variable name/value string - separated by an '=' (eg, "myname=Sally").
 */
static void
CmdLineSetVariable(
    char	*var
)
{
    char	*cp, buf[100], **tok;
    int		n;

    /* Turn '=' into a space, to isolate the name.  Then set variable. */
    strcpy(buf, var);
    if ((cp=strchr(buf, '='))) {
	/* we have "var=value" */
	*cp = ' ';
	n = 2;
	tok = Split(buf, &n, 0);
	/* see if variable name matches one of our internal ones */
	if (!strcmp(tok[0], "verbose"))		verbose   = atoi(tok[1]);
	else if (!strcmp(tok[0], "warnings"))	warnings  = atoi(tok[1]);
	else if (!strcmp(tok[0], "foldcase"))	fold_case = atoi(tok[1]);
	else SetMappingNV(Variables, tok[0], tok[1]);
    }
    else {
	fprintf(stderr, "Expected an '=' in variable assignment: %s. Ignored\n",
		var);
    }
}

/* ______________________________________________________________________ */
/*  Bounce through arguments, setting variables and flags.
 *  Arguments:
 *	Argc and Argv, as passed to main().
 */
static void
HandleArgs(
    int		ac,
    char	*av[]
)
{
    int		c, errflag=0;
    extern char	*optarg;
    extern int	optind;

    while ((c=getopt(ac, av, "df:t:vc:s:o:huSxIl:bHVWi:D:Z")) != EOF) {
	switch (c) {
	    case 't': tranfile		= optarg;	break;
	    case 'v': do_validate	= 1;		break;
	    case 's': sdatafile		= optarg;	break;
	    case 'c': cmapfile		= optarg;	break;
	    case 'h': do_tree		= 1;		break;
	    case 'u': do_summ		= 1;		break;
	    case 'S': do_stats		= 1;		break;
	    case 'x': do_context	= 1;		break;
	    case 'I': do_idlist		= 1;		break;
	    case 'l': tpt_lib		= optarg;	break;
	    case 'i': start_id		= optarg;	break;
	    case 'o': out_file		= optarg;	break;
	    case 'd': do_DATAhack++;	 		break;
	    case 'f': BOFTTextThresh	= atoi(optarg);	break;
	    case 'b': interactive	= 1;		break;
	    case 'W': warnings		= 0;		break;
	    case 'V': verbose		= 1;		break;
	    case 'Z': slave		= 1;		break;
	    case 'H': DoHelpMessage();	exit(0);	break;
	    case 'D': CmdLineSetVariable(optarg);	break;
	    case '?': errflag		= 1;		break;
	}
	if (errflag) {
	    fprintf(stderr, "Try '%s -H' for help.\n", this_prog);
	    exit(1);
	}
    }

    /* input (ESIS) file name */
    if (optind < ac) in_file = av[optind];

    /* If doing interactive/browsing, we can't take ESIS from stdin. */
    if (interactive && !in_file) {
	fprintf(stderr,
	    "You must specify ESIS file on cmd line for browser mode.\n");
	exit(1);
    }
}

/* ______________________________________________________________________ */
/*  Simply print out a help/usage message.
 */

static char *help_msg[] = {
  "",
  "  -t file   Print translated output using translation spec in <file>",
  "  -s file   <file> contains a list of SDATA entity mappings",
  "  -c file   <file> contains a list of character mappings",
  "  -v        Validate using translation spec specified with -t",
  "  -i id     Consider only subtree starting at element with ID <id>",
  "  -b        Interactive browser",
  "  -S        Print statistics (how often elements occur, etc.)",
  "  -u        Print element usage summary (# of children, depth, etc.)",
  "  -x        Print context of each element",
  "  -h        Print document hierarchy as a tree",
  "  -o file   Write output to <file>.  Default is standard output.",
  "  -l dir    Set library directory to <dir>. (or env. variable TPT_LIB)",
  "  -I        List all IDs used in the instance",
  "  -W        Do not print warning messages",
  "  -H        Print this help message",
  "  -Dvar=val Set variable 'var' to value 'val'",
  "  file      Take input from named file.  If not specified, assume stdin.",
  "            File should be output from the 'sgmls' program (ESIS).",
  NULL
};

static void
DoHelpMessage()
{
    char	**s = help_msg;
    printf("Instant: SGML document processor/translator, Version %s\n",
	   VERSION);
    printf("usage: %s [option ...] [file]", this_prog);
    while (*s) puts(*s++);
    /*    printf("\nVersion: %s\n", _HeadVeRsIoN_); */
    
}

/* ______________________________________________________________________ */
/*  Remember an external entity for future reference.
 *  Arguments:
 *	Pointer to entity structure to remember.
 */

static void
AddEntity(
    Entity_t	*ent
)
{
    static Entity_t *last_ent;

    if (!Entities) {
        Malloc(1, Entities, Entity_t);
        last_ent = Entities;
    }
    else {
        Malloc(1, last_ent->next, Entity_t);
        last_ent = last_ent->next;
    }
    *last_ent = *ent;
    
}

/*  Find an entity, given its entity name.
 *  Arguments:
 *	Name of entity to retrieve.
 */
static Entity_t *
FindEntity(
    char	*ename
)
{
    Entity_t	*n;
    for (n=Entities; n; n=n->next)
	if (StrEq(ename, n->ename)) return n;
    return 0;
}

/*  Accumulate lines up to the open tag.  Attributes, line number,
 *  entity info, notation info, etc., all come before the open tag.
 */
static Element_t *
AccumElemInfo(
    FILE	*fp
)
{
    char	buf[LINESIZE+1];
    int		c;
    int		i, na;
    char	*cp, *atval;
    Mapping_t	a[100];
    Element_t	*e;
    Entity_t	ent, *ent2;
    char	**tok;
    static int	Index=0;
    static Element_t	*last_e;
    

    Calloc(1, e, Element_t);
    memset(&ent, 0, sizeof ent);	/* clean space for entity info */

    /* Also, keep a linked list of elements, so we can easily scan through */
    if (last_e) last_e->next = e;
    last_e = e;

    e->index = Index++;		/* just a unique number for identification */

    /* in case these are not set for this element in the ESIS */
    e->lineno = last_lineno;
    e->infile = last_file;

    na = 0;
    while (1) {
	if ((c = getc(fp)) == EOF) break;
	fgets(buf, LINESIZE, fp);
	stripNL(buf);
	switch (c) {
	    case EOF:		/* End of input */
		fprintf(stderr, "Error: Unexpectedly reached end of ESIS.\n");
		exit(1);
		break;

	    case CMD_OPEN:	/* (gi */
		e->gi = AddElemName(buf);
		if (na > 0) {
		    Malloc(na, e->atts, Mapping_t);
		    memcpy(e->atts, a, na*sizeof(Mapping_t));
		    e->natts = na;
		    na = 0;
		}
		/*  Check if this elem has a notation attr.  If yes, and there
		    is no notation specified, recall the previous one. (feature
		    of sgmls - it does not repeat notation stuff if we the same
		    is used twice in a row) */
		if (((atval=FindAttValByName(e, "NAME")) ||
		     (atval=FindAttValByName(e, "ENTITYREF")) ||
		     (atval=FindAttValByName(e, "EXTERNAL"))) &&   /* HACK */
					(ent2=FindEntity(atval))) {
		    e->entity = ent2;
		}

		return e;
		break;

	    case CMD_ATT:	/* Aname val */
		i = 3;
		tok = Split(buf, &i, 0);
		if (!strcmp(tok[1], "IMPLIED")) break;	/* skip IMPLIED atts. */
		if (!strcmp(tok[1], "CDATA") || !strcmp(tok[1], "TOKEN") ||
		    !strcmp(tok[1], "ENTITY") ||!strcmp(tok[1], "NOTATION"))
		{
		    a[na].name = AddAttName(tok[0]);
		    a[na].sval = AddAttName(tok[2]);
		    na++;
		}
		else {
		    fprintf(stderr, "Error: Bad attr line (%d): A%s %s...\n",
			e->lineno, tok[0], tok[1]);
		}
		break;

	    case CMD_LINE:	/* Llineno */
		/* These lines come in 2 forms: "L123" and "L123 file.sgml".
		 * Filename is given only at 1st occurance. Remember it.
		 */
		if ((cp = strchr(buf, ' '))) {
		    cp++;
		    last_file = strdup(cp);
		}
		last_lineno = e->lineno = atoi(buf);
		e->infile = last_file;
		break;

	    case CMD_DATA:	/* -data */
		fprintf(stderr, "Error: Data in AccumElemInfo, line %d:\n%c%s\n",
			e->lineno, c,buf);
		/*return e;*/
		exit(1);
		break;

	    case CMD_D_ATT:	/* Dename name val */

	    case CMD_NOTATION:	/* Nnname */
	    case CMD_PI:	/* ?pi */
				/* This should be reworked soon, as it 
				   forces all PI's before the first GI
				   to be ignored. -CSS */
		break;

	    case CMD_EXT_ENT:	/* Eename typ nname */
		i = 3;
		tok = Split(buf, &i, 0);
		ent.ename = strdup(tok[0]);
		ent.type  = strdup(tok[1]);
		ent.nname = strdup(tok[2]);
		AddEntity(&ent);
		break;
	    case CMD_INT_ENT:	/* Iename typ text */
		fprintf(stderr, "Error: Got CMD_INT_ENT in AccumElemInfo: %s\n", buf);
		break;
	    case CMD_SYSID:	/* ssysid */
		ent.sysid = strdup(buf);
		break;
	    case CMD_PUBID:	/* ppubid */
		ent.pubid = strdup(buf);
		break;
	    case CMD_FILENAME:	/* ffilename */
		ent.fname = strdup(buf);
		break;

	    case CMD_CLOSE:	/* )gi */
	    case CMD_SUBDOC:	/* Sename */
	    case CMD_SUBDOC_S:	/* {ename */
	    case CMD_SUBDOC_E:	/* }ename */
	    case CMD_EXT_REF:	/* &name */
	    case CMD_APPINFO:	/* #text */
	    case CMD_CONFORM:	/* C */
	    default:
		fprintf(stderr, "Error: Unexpected input in AccumElemInfo, %d:\n%c%s\n",
			e->lineno, c,buf);
		exit(1);
		break;
	}
    }
    fprintf(stderr, "Error: End of AccumElemInfo - should not be here: %s\n",
	    (e && e->gi) ? e->gi : "(No element)");
/*    return e;*/
    exit(1);
}

/*  Read ESIS lines.
 *  Limitation?  Max 5000 children per node.  (done for efficiency --
 *  should do some malloc and bookkeeping games later).
 *
 *  [ANS-db3l]
 *    Changes to process ESIS input quoting/cmap/sdata at this point.  Also
 *    pass in parent element to function so it can look up the hierarchy
 *    for parent attributes if necessary (such as for FORMAT).
 */

static Element_t *
ReadESIS(
    FILE	*fp,
    int		depth,
    Element_t   *parent
)
{
    char	*buf, *xlatebuf, *dst, *src, *pch, *sdata;
    int		i, c, ncont, inspace, nomap;
    Element_t	*e, *cur_e;
    Content_t	cont[5000];

    Malloc( LINESIZE+1, buf, char );
    Malloc( LINESIZE+1, xlatebuf, char );

    /* Read input stream - the output of "sgmls", called "ESIS".  */
    e = AccumElemInfo(fp);
    e->depth = depth;
    e->parent = parent;

    ncont = 0;
    while (1) {
	if ((c = getc(fp)) == EOF) break;
	switch (c) {
	    case EOF:		/* End of input */
		break;

	    case CMD_DATA:	/* -data */
		fgets(buf, LINESIZE, fp);
		stripNL(buf);

		/* [ANS-db3l]  Process/sanitize element data		   */
		/*							   */
		/* The new default behavior (unless "-d" - do_DATAhack is  */
		/* given) is to process inbound translation of ESIS data   */
		/* elements at the input stage.  This handles all quoting  */
		/* from [n]sgmls, as well as character mapping.  Doing it  */
		/* now avoids a lot of headaches later.  OutputString will */
		/* still do Transpec mappings but this way character maps  */
		/* only apply to input data, thus freeing the SDATA and    */
		/* translation spec from knowing what is in the CMAP.      */
		/*							   */
		/* After translating quoting and mapping characters, as    */
		/* long as this attribute doesn't have a defined format of */
		/* linespecific (preserve whitespace/line formatting), the */
		/* result is further processed to translate all spans of   */
		/* whitespace into a single space.			   */
		/*							   */
		/* Using "-d" restores the previous do_DATAhack behavior,  */
		/* while "-d -d" restores original non-translating mode.   */

		if (!do_DATAhack) {
#ifdef DEBUG
		   fprintf(stderr,"Data: Element '%s'\n      Input='%s'\n",
			   e->gi,buf);
#endif
		   /* Use the secondary buffer to avoid moving things    */
		   /* around too much.  Note that unless no further cmap */
		   /* translation should be performed (nomap==1), *dst   */
		   /* should point to the last character stored and not  */
		   /* one past (it should be one past for no cmap).	 */
		   src = buf;
		   dst = xlatebuf;
		   while (*src) {
		      nomap = 0;
		      if (*src == '\\') {
			 src++;
			 switch (*src) {
			    case '\\':
			       /* Quoted backslash */
			       *dst = *src++;
			       break;
			    case 'n':
			       /* Newline */
			       *dst = '\n'; src++;
			       break;
			    case '0':  case '1':  case '2':  case '3':
			    case '4':  case '5':  case '6':  case '7':
			       /* Octal encoding */
			       *dst = ((*src-'0') << 6) +
				      ((*(src+1)-'0') << 3) +
				      ((*(src+2)-'0'));
			       src += 3;
			       break;
			    case '#':  case '%':
			       /* Decimal internal(#)/document(%) char */
			       /* XXX: Handle better */
			       *dst++ = '[';
			       while (*src != ';') {
				  *dst++ = *src++;
			       }
			       *dst++ = ']';
			       src++;
			       /* XXX: Whimp out - no translation */
			       nomap = 1;
			       break;
			    case '|':
			       /* SDATA reference */
			       sdata = ++src;
			       while (*src && *src != '\\' &&	
				      *(src+1) != '|') {
				  src++;
			       }
			       if (!*src) break;
			       *src = '\0';  /* Terminate SDATA name */
			       src += 2;	/* and skip past */
			       if (pch = LookupSDATA(sdata)) {
				  strcpy(dst,pch);
				  dst += strlen(pch);
			       } else {
				  /* Output in brackets */
				  *dst++ = '[';
				  strcpy(dst,sdata);
				  dst += strlen(sdata);
				  *dst++ = ']';
			       }
			       /* No cmap translation of sdata */
			       nomap = 1;
			       break;
			    default:
			       fprintf(stderr,
				       "? Warning: Unknown ESIS escape "
				       "sequence in stream: ('%c')\n",
				       *src);
			       *dst++ = *src++;
			       nomap = 1;
			 }
		      } else {
			 *dst = *src++;
		      }

		      /* Handle any character mapping of last character */
		      if (!nomap) {
			 if (nCharMap) {
			    for (i=0; i<nCharMap; i++) {
			       if (*dst != CharMap[i].name[0]) continue;
			       strcpy(dst,CharMap[i].sval);
			       dst += strlen(CharMap[i].sval)-1;
			    }
			 } else if (*dst == '\\') {
			    /* If no map, we'll quote \ automatically to */
			    /* avoid always requiring a single line cmap */
			    *++dst = '\\';
			 }
			 dst++;
		      }
		   } /* while *src */
		   *dst = '\0';

		   /* So it still ends up in "buf" (doesn't matter */
		   /* if we just keep swapping them over time.     */
		   pch      = xlatebuf;
		   xlatebuf = buf;
		   buf      = pch;
#ifdef DEBUG
		   fprintf(stderr,"   D: ESIS/Charmap xlate='%s'\n",buf);
#endif
		   /* Attempt to locate a FORMAT attribute for this element */
		   /* or any parent elements, to use as the guide for	    */
		   /* whether or not whitespace is kept in this element     */
		   cur_e = e;
		   while (cur_e) {
		      if (pch = FindAttValByName(cur_e,"FORMAT")) {
#ifdef DEBUG
			 fprintf(stderr,"   D: Using FORMAT from %s element\n",
				 cur_e->gi);
#endif			 
			 break;
		      }
		      cur_e = cur_e->parent;
		   }
		   if (!(pch && !(strcmp(pch,"LINESPECIFIC")))) {
#ifdef DEBUG
		      fprintf(stderr,"   D: Compressing whitespace\n");
#endif
		      /* Replace any span of whitespace with a single space */
		      dst = src = buf;
		      inspace = 0;
		      while (*src) {
			 i = isspace(*src);
			 if (!(inspace && i)) {
			    *dst++ = i ? ' ' : *src;
			 }
			 inspace = i;
			 src++;
		      }
		      *dst = '\0';
		   } /* if !linespecific */
#ifdef DEBUG
		   fprintf(stderr,"   D: Output='%s'\n",buf);
#endif
		} /* if !do_DATAhack */

		/* Remove any empty elements (not sure you can ever */
		/* get this from NSGMLS, but while I'm here...)     */
		if (*buf == '\0') {
		   /* Nothing left - skip this chunk */
		   break;
		}

		/* Original "do_DATAhack" support.  We check explicitly */
		/* here for a do_DATAhack value of 1, since using -d    */
		/* twice on the command line can now restore the older  */
		/* default behavior of not doing anything.		*/
		if (do_DATAhack==1 && (buf[0] == '\\') && (buf[1] == 'n')) {
			if ( ! buf[2] )
				break;
			buf[0] = ' ';
			memcpy(&buf[1], &buf[2], strlen(buf)-1);
		}

		cont[ncont].ch.data = strdup(buf);
		cont[ncont].type = CMD_DATA;
		ncont++;
		break;

	    case CMD_PI:	/* ?pi */
		fgets(buf, LINESIZE, fp);
		stripNL(buf);
		cont[ncont].type = CMD_PI;
		cont[ncont].ch.data = strdup(buf);
		ncont++;
		break;

	    case CMD_CLOSE:	/* )gi */
		fgets(buf, LINESIZE, fp);
		stripNL(buf);
		if (ncont) {
		    e->ncont = ncont;
		    Malloc(ncont, e->cont, Content_t);
		    for (i=0; i<ncont; i++) e->cont[i] = cont[i];
		}
		free(buf);
		free(xlatebuf);
		return e;
		break;

	    case CMD_OPEN:	/* (gi */
/*fprintf(stderr, "+++++ OPEN +++\n");*/
/*		break;*/

	    case CMD_ATT:	/* Aname val */
	    case CMD_D_ATT:	/* Dename name val */
	    case CMD_NOTATION:	/* Nnname */
	    case CMD_EXT_ENT:	/* Eename typ nname */
	    case CMD_INT_ENT:	/* Iename typ text */
	    case CMD_SYSID:	/* ssysid */
	    case CMD_PUBID:	/* ppubid */
	    case CMD_FILENAME:	/* ffilename */
		ungetc(c, fp);
		cont[ncont].ch.elem = ReadESIS(fp, depth+1,e);
		cont[ncont].type = CMD_OPEN;
		cont[ncont].ch.elem->parent = e;
		ncont++;
		break;

	    case CMD_LINE:	/* Llineno */
		fgets(buf, LINESIZE, fp);
		break;		/* ignore these here */

	    case CMD_SUBDOC:	/* Sename */
	    case CMD_SUBDOC_S:	/* {ename */
	    case CMD_SUBDOC_E:	/* }ename */
	    case CMD_EXT_REF:	/* &name */
	    case CMD_APPINFO:	/* #text */
	    case CMD_CONFORM:	/* C */
	    default:
		fgets(buf, LINESIZE, fp);
		fprintf(stderr, "Error: Unexpected input at %d: '%c%s'\n",
			e->lineno, c, buf);
		exit(1);
		break;
	}
    }
    fprintf(stderr, "Error: End of ReadESIS - should not be here: %s\n", e->gi);
    free(buf);
    free(xlatebuf);
    return NULL;
}

/* ______________________________________________________________________ */
/*  Read input stream, creating a tree in memory of the elements and data.
 *  Arguments:
 *	Filename where instance's ESIS is.
 */
static void
ReadInstance(
    char	*filename
)
{
    int		i, n;
    FILE	*fp;
    Element_t	*e;
    char	*idatt;

    if (filename) {	/* if we specified input file.  else stdin */
	if ((fp=fopen(filename, "r")) == NULL) {
	    perror(filename);
	    exit(1);
	}
    }
    else fp = stdin;
    last_file = filename;
    DocTree = ReadESIS(fp, 0, NULL);
    if (filename) fclose(fp);

    /* Traverse tree, filling in econt and figuring out which child
     * (ie. what birth order) each element is. */
    DocTree->my_eorder = -1;
    for (e=DocTree; e; e=e->next) {

	/* count element children */
	for (i=0,n=0; i<e->ncont; i++) if (IsContElem(e,i)) n++;
	if (n > 0) Calloc(n, e->econt, Element_t *);
	for (i=0; i<e->ncont; i++)
	    if (IsContElem(e,i)) e->econt[e->necont++] = ContElem(e,i);

	/* count data children */
	for (i=0,n=0; i<e->ncont; i++) if (IsContData(e,i)) n++;
	if (n > 0) Calloc(n, e->dcont, char *);
	for (i=0; i<e->ncont; i++)
	    if (IsContData(e,i)) e->dcont[e->ndcont++] = ContData(e,i);

	/* where in child order order */
	for (i=0; i<e->necont; i++)
	    e->econt[i]->my_eorder = i;

	/* Does this element have an ID? */
	for (i=0; i<e->natts; i++) {
	    if ((idatt=FindAttValByName(e, "ID"))) {
		AddID(e, idatt);
		/* remember ID value for quick reference */
		e->id = idatt;
		break;
	    }
	}
    }
    return;
}

/* ______________________________________________________________________ */
