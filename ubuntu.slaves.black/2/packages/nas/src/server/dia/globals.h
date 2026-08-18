/*
 * globals.h
 *
 * $Id: globals.h 180 2006-08-20 05:06:24Z jon $
 *
 * Jon Trulson 9/19/99
 */

#include "nasconf.h"

#ifndef GLOBALS_H_INCLUDED
#define GLOBALS_H_INCLUDED

#ifdef GLOBALS_INSTANTIATE
# define GEXTERN
#else
# define GEXTERN extern
#endif /* GLOBALS_INSTANTIATE */

GEXTERN ClientPtr *clients;
GEXTERN ClientPtr serverClient;
GEXTERN int currentMaxClients;  /* current size of clients array */

GEXTERN unsigned long serverGeneration;

GEXTERN TimeStamp currentTime;

GEXTERN char *display;

GEXTERN long TimeOutValue;
GEXTERN int argcGlobal;
GEXTERN char **argvGlobal;

GEXTERN NasConfig_t NasConfig;

void diaInitGlobals(void);      /* init function */

#undef GEXTERN
#endif /* GLOBALS_H_INCLUDED */
