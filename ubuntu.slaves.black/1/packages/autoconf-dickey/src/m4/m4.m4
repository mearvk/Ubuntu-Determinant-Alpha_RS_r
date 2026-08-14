# AC_PROG_GNU_M4
# --------------
# Check for GNU m4, at least 1.3 (supports frozen files).
AC_DEFUN([AC_PROG_GNU_M4],
[AC_PATH_PROGS(M4, gm4 gnum4 m4, m4)
AC_CACHE_CHECK(version of $M4, ac_cv_m4_version,
[
	ac_cv_m4_version=`$M4 --version | head -n 1 | sed -E -e 's/^.*[[ ]]([[1-9]][[0-9]]*\.)/\1/g' -e 's/[[^0-9.]]*$//' 2>/dev/null`
	test -z "$ac_cv_m4_version" && ac_cv_m4_version=unknown
])
AC_CACHE_CHECK(whether $M4 supports frozen files, ac_cv_prog_gnu_m4,
[ac_cv_prog_gnu_m4=no
if test x"$M4" != x; then
  case `$M4 --help < /dev/null 2>&1` in
    *reload-state*) ac_cv_prog_gnu_m4=yes ;;
  esac
fi])])
