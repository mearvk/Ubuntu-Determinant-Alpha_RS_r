#include "config.h"

#include <errno.h>
#include <fcntl.h>
#include <stddef.h>
#include <stdint.h>
#include <string.h>
#include <pwd.h>
#include <grp.h>

#if defined(HAVE_NSS_H)
/* Linux and BSD */
#include <nss.h>

typedef enum nss_status NSS_STATUS;
#elif defined(HAVE_NSS_COMMON_H)
/* Solaris */
#include <nss_common.h>
#include <nss_dbdefs.h>
#include <nsswitch.h>

typedef nss_status_t NSS_STATUS;

# define NSS_STATUS_SUCCESS     NSS_SUCCESS
# define NSS_STATUS_NOTFOUND    NSS_NOTFOUND
# define NSS_STATUS_UNAVAIL     NSS_UNAVAIL
# define NSS_STATUS_TRYAGAIN    NSS_TRYAGAIN
#else
# error "No nsswitch support detected"
#endif

NSS_STATUS _nss_nwrap_setpwent(void);
NSS_STATUS _nss_nwrap_endpwent(void);
NSS_STATUS _nss_nwrap_getpwent_r(struct passwd *result, char *buffer,
				 size_t buflen, int *errnop);
NSS_STATUS _nss_nwrap_getpwuid_r(uid_t uid, struct passwd *result,
				 char *buffer, size_t buflen, int *errnop);
NSS_STATUS _nss_nwrap_getpwnam_r(const char *name, struct passwd *result,
				   char *buffer, size_t buflen, int *errnop);
NSS_STATUS _nss_nwrap_setgrent(void);
NSS_STATUS _nss_nwrap_endgrent(void);
NSS_STATUS _nss_nwrap_getgrent_r(struct group *result, char *buffer,
				 size_t buflen, int *errnop);
NSS_STATUS _nss_nwrap_getgrnam_r(const char *name, struct group *result,
				 char *buffer, size_t buflen, int *errnop);
NSS_STATUS _nss_nwrap_getgrgid_r(gid_t gid, struct group *result, char *buffer,
				 size_t buflen, int *errnop);
NSS_STATUS _nss_nwrap_initgroups_dyn(char *user, gid_t group, long int *start,
				     long int *size, gid_t **groups,
				     long int limit, int *errnop);

#ifndef PTR_DIFF
#define PTR_DIFF(p1, p2) ((ptrdiff_t)(((const char *)(p1)) - (const char *)(p2)))
#endif

static int pw_copy_r(const struct passwd *src,
		     struct passwd *dst,
		     char *buf,
		     size_t buflen,
		     struct passwd **dstp)
{
	char *first;
	char *last;
	off_t ofs;

	first = src->pw_name;

	last = src->pw_shell;
	while (*last) last++;

	ofs = PTR_DIFF(last + 1, first);

	if (ofs > (off_t) buflen) {
		return ERANGE;
	}

	memcpy(buf, first, ofs);

	ofs = PTR_DIFF(src->pw_name, first);
	dst->pw_name = buf + ofs;
	ofs = PTR_DIFF(src->pw_passwd, first);
	dst->pw_passwd = buf + ofs;
	dst->pw_uid = src->pw_uid;
	dst->pw_gid = src->pw_gid;
#ifdef HAVE_STRUCT_PASSWD_PW_CLASS
	ofs = PTR_DIFF(src->pw_class, first);
	dst->pw_class = buf + ofs;
#endif /* HAVE_STRUCT_PASSWD_PW_CLASS */

#ifdef HAVE_STRUCT_PASSWD_PW_CHANGE
	dst->pw_change = 0;
#endif /* HAVE_STRUCT_PASSWD_PW_CHANGE */

#ifdef HAVE_STRUCT_PASSWD_PW_EXPIRE
	dst->pw_expire = 0;
#endif /* HAVE_STRUCT_PASSWD_PW_EXPIRE */

	ofs = PTR_DIFF(src->pw_gecos, first);
	dst->pw_gecos = buf + ofs;
	ofs = PTR_DIFF(src->pw_dir, first);
	dst->pw_dir = buf + ofs;
	ofs = PTR_DIFF(src->pw_shell, first);
	dst->pw_shell = buf + ofs;

	if (dstp) {
		*dstp = dst;
	}

	return 0;
}

NSS_STATUS _nss_nwrap_setpwent(void)
{
	return NSS_STATUS_UNAVAIL;
}

NSS_STATUS _nss_nwrap_endpwent(void)
{
	return NSS_STATUS_UNAVAIL;
}

NSS_STATUS _nss_nwrap_getpwent_r(struct passwd *result, char *buffer,
				 size_t buflen, int *errnop)
{
	(void) result;
	(void) buffer;
	(void) buflen;
	(void) errnop;

	return NSS_STATUS_UNAVAIL;
}

NSS_STATUS _nss_nwrap_getpwuid_r(uid_t uid, struct passwd *result,
				 char *buffer, size_t buflen, int *errnop)
{
	if (uid == 424242) {
		char buf[] = "hanswurst\0secret\0\0/home/hanswurst\0/bin/false";
		const struct passwd src = {
			.pw_name   = &buf[0],
			.pw_passwd = &buf[10],
			.pw_uid    = 424242,
			.pw_gid    = 424242,
			.pw_gecos  = &buf[17],
			.pw_dir    = &buf[18],
			.pw_shell  = &buf[34],
		};
		memset(buffer, '\0', buflen);
		pw_copy_r(&src, result, buffer, buflen, NULL);
		errnop = 0;

		return NSS_STATUS_SUCCESS;
	}

	return NSS_STATUS_UNAVAIL;
}

NSS_STATUS _nss_nwrap_getpwnam_r(const char *name, struct passwd *result,
				 char *buffer, size_t buflen, int *errnop)
{
	(void) name;
	(void) result;
	(void) buffer;
	(void) buflen;
	(void) errnop;

	return NSS_STATUS_UNAVAIL;
}

NSS_STATUS _nss_nwrap_setgrent(void)
{
	return NSS_STATUS_UNAVAIL;
}

NSS_STATUS _nss_nwrap_endgrent(void)
{
	return NSS_STATUS_UNAVAIL;
}

NSS_STATUS _nss_nwrap_getgrent_r(struct group *result, char *buffer,
				 size_t buflen, int *errnop)
{
	(void) result;
	(void) buffer;
	(void) buflen;
	(void) errnop;

	return NSS_STATUS_UNAVAIL;
}

NSS_STATUS _nss_nwrap_getgrnam_r(const char *name, struct group *result,
				 char *buffer, size_t buflen, int *errnop)
{
	(void) name;
	(void) result;
	(void) buffer;
	(void) buflen;
	(void) errnop;

	return NSS_STATUS_UNAVAIL;
}

NSS_STATUS _nss_nwrap_getgrgid_r(gid_t gid, struct group *result, char *buffer,
				 size_t buflen, int *errnop)
{
	(void) gid;
	(void) result;
	(void) buffer;
	(void) buflen;
	(void) errnop;

	return NSS_STATUS_UNAVAIL;
}

NSS_STATUS _nss_nwrap_initgroups_dyn(char *user, gid_t group, long int *start,
				     long int *size, gid_t **groups,
				     long int limit, int *errnop)
{
	(void) user;
	(void) group;
	(void) start;
	(void) size;
	(void) groups;
	(void) limit;
	(void) errnop;

	return NSS_STATUS_UNAVAIL;
}

