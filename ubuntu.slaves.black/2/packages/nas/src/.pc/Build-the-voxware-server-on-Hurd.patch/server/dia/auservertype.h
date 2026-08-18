/*
 * $Id: auservertype.h 178 2006-08-14 01:10:07Z jon $
 * 
 */

#ifndef _AUSERVERTYPE_H_
#define _AUSERVERTYPE_H_

#ifdef sun
# define SUN_SERVER
#endif /* sun */

#ifdef sgi
# define SGI_SERVER
#endif /* sgi */

#if defined(__DragonFly__) || defined(__FreeBSD_kernel__) || defined(__FreeBSD__) || defined(__NetBSD__) || defined(linux) || (defined(SVR4) && (defined(SYSV386) || defined(i386))) || defined(__CYGWIN__)
# define VOXWARE_SERVER
#endif /* voxware */

#ifdef hpux
# define HPUX_SERVER
#endif /* hpux */

#endif /* _AUSERVERTYPE_H_ */
