/*
    libfakechroot -- fake chroot environment
    Copyright (c) 2010, 2013 Piotr Roszatycki <dexter@debian.org>

    This library is free software; you can redistribute it and/or
    modify it under the terms of the GNU Lesser General Public
    License as published by the Free Software Foundation; either
    version 2.1 of the License, or (at your option) any later version.

    This library is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
    Lesser General Public License for more details.

    You should have received a copy of the GNU Lesser General Public
    License along with this library; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-1307  USA
*/


#include <config.h>

/*
 * Starting with glibc 2.32 the compat nss module for getpwnam calls
 * __nss_files_fopen (which is a GLIBC_PRIVATE symbol provided by glibc)
 * instead of fopen (see 299210c1fa67e2dfb564475986fce11cd33db9ad). This
 * leads to getpwnam calls accessing /etc/passwd from *outside* the chroot
 * and as a result programs like adduser do not work correctly anymore
 * under fakechroot.
 *
 * Adhemerval Zanella (azanella) argued on IRC:
 *
 *  > But another problem is the ship has sailed, so there are nss modules that
 *  > will bind to an external symbol. And there is not much we can do about
 *  > it. And since nss modules are most compat, I am not sure community will
 *  > be willing to move back. I think it will be better to add the interpose
 *  > logic of private symbols on fakechroot instead, it is ugly but it is
 *  > better than messing even more with the nss interface.
 *
 * Thus, instead of changing glibc, we instead wrap __nss_files_fopen.
 *
 */
#ifdef HAVE___NSS_FILES_FOPEN

#include <stdio.h>
#include "libfakechroot.h"


wrapper(__nss_files_fopen, FILE *, (const char * path))
{
    char fakechroot_abspath[FAKECHROOT_PATH_MAX];
    char fakechroot_buf[FAKECHROOT_PATH_MAX];
    debug("__nss_files_fopen(\"%s\")", path);
    expand_chroot_path(path);
    return nextcall(__nss_files_fopen)(path);
}

#else
typedef int empty_translation_unit;
#endif
