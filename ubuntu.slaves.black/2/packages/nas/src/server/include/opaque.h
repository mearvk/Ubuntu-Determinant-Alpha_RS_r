/* $XConsortium: opaque.h,v 1.9 89/07/16 14:37:10 rws Exp $ */

#ifndef OPAQUE_H
#define OPAQUE_H

extern long MaxClients;
extern char isItTimeToYield;
extern char dispatchException;

/* bit values for dispatchException */
#define DE_RESET     1
#define DE_TERMINATE 2

extern long TimeOutValue;
extern int argcGlobal;
extern char **argvGlobal;

#endif /* OPAQUE_H */
