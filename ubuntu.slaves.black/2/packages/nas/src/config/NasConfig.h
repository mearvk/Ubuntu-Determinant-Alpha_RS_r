/*
 * NasConfig.h - some configurable features, probably candidates for
 *              autoconf'ing
 *
 * $Id: NasConfig.h 94 2002-07-07 21:56:35Z jon $
 *
 * Jon Trulson 9/11/99
 */

#ifndef _NASCONFIG_H_INCLUDED
#define _NASCONFIG_H_INCLUDED

/* define this if you want the logger to use syslog.  Otherwise
 * stderr will be used 
 */
  
#ifndef hpux
#define DIA_USE_SYSLOG 
#endif

/*
 * the location of the directory in which to find config files 
 *  by default if NASCONFSEARCHPATH isn't defined 
 *  (see config/NetAudio.def).
 */

#ifndef NASCONFSEARCHPATH
#define NASCONFSEARCHPATH "/etc/nas/"
#endif

#define NAS_USEMTSAFEAPI	/* if defined, try to use xthread mutexes
				   if XTHREADS is also defined by your
				   system.  #undef this if you want to
				   disable mutexes for thread saftey.
				 */


/* for ADMPATHin osinit.c */
#define NAS_AUDIOMSGFILE  "/var/adm/X%smsgs"

#endif /* _NASCONFIG_H_INCLUDED */
