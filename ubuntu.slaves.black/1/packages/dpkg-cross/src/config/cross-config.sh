# read in package-specific and global values.
. `dirname $ac_site_file`/cross-config.cache
# now ensure the real architecture-dependent values take priority
# sh specific configure variables
ac_cv_c_char_unsigned=no
ac_cv_func_setpgrp_void=yes
ac_cv_prog_cc_cross=yes
ac_cv_search_clock_gettime=no
# DB2, DB3
db_cv_alignp_t=int
db_cv_fcntl_f_setfd=yes
db_cv_mutex=sh/gcc-assembly
db_cv_spinlocks=sh/gcc
db_cv_sprintf_count=yes
# Python
ac_cv_malloc_zero=yes
ac_cv_opt_olimit_ok=no
ac_cv_olimit_ok=no

path=`dirname $ac_site_file`
# now allow package-specific architecture-independent values to be set
if [ -d $path/cross-config.d/sh/ ]; then
for file in `ls $path/cross-config.d/sh/`; do
	if [ "$file" = "$PACKAGE" -o "$file" = "$PACKAGE_NAME" ]; then
		[ -d $path/cross-config.d/sh/$file ] || . $path/cross-config.d/sh/$file
		HAVE_PKG_CACHE=1
	fi
done
fi

if [ -z "$HAVE_PKG_CACHE" ]; then
	# only needed until the packages provide these directly
	# using the mechanism above.
fi
