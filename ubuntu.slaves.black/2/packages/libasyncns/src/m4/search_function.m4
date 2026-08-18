dnl Copyright (c) 2008 Diego Pettenò <flameeyes@gmail.com>
dnl
dnl This program is free software; you can redistribute it and/or modify
dnl it under the terms of the GNU General Public License as published by
dnl the Free Software Foundation; either version 2, or (at your option)
dnl any later version.
dnl
dnl This program is distributed in the hope that it will be useful,
dnl but WITHOUT ANY WARRANTY; without even the implied warranty of
dnl MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
dnl GNU General Public License for more details.
dnl
dnl You should have received a copy of the GNU General Public License
dnl along with this program; if not, write to the Free Software
dnl Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
dnl 02110-1301, USA.
dnl
dnl As a special exception, the copyright owners of the
dnl macro gives unlimited permission to copy, distribute and modify the
dnl configure scripts that are the output of Autoconf when processing the
dnl Macro. You need not follow the terms of the GNU General Public
dnl License when using or distributing such scripts, even though portions
dnl of the text of the Macro appear in them. The GNU General Public
dnl License (GPL) does govern all other use of the material that
dnl constitutes the Autoconf Macro.
dnl 
dnl This special exception to the GPL applies to versions of the
dnl Autoconf Macro released by this project. When you make and
dnl distribute a modified version of the Autoconf Macro, you may extend
dnl this special exception to the GPL to apply to your modified version as
dnl well.

dnl ACF_SEARCH_FUNCTION([function name],
dnl                     [m4 list of libraries],
dnl                     [action if found],
dnl                     [action if not found],
dnl                     [test source])
dnl
dnl Improved modified version of AC_SEARCH_LIBS, with some
dnl differences:
dnl  - it accepts an m4 list for libraries to allow compound libraries
dnl    instead of using the other-libraries parameter;
dnl  - action if not found is only invoked when the function is not
dnl    found at all;
dnl  - an optional parameter allows for custom source code for testing
dnl    (allowing to search for functions that are actually aliased).
AC_DEFUN([ACF_SEARCH_FUNCTION], [
  m4_pushdef([search_sourcecode], [
    m4_default([$5], [
      AC_LANG_CALL([], [$1])
    ])
  ])
  m4_pushdef([cache_variable], AS_TR_SH([acf_cv_library_$1]))

  m4_pushdef([action_if_found],
    m4_default([$3], [LIBS="$LIBS $]cache_variable["]))
  m4_pushdef([action_if_not_found], m4_default([$4], [:]))

  AC_CACHE_CHECK([for library containing $1],
    cache_variable,
    [while true; do
       m4_foreach([library], [, $2], [
         save_libs=$LIBS
	 LIBS="$LIBS library"
         AC_LINK_IFELSE(search_sourcecode,
           cache_variable=" library")
         LIBS=$save_libs
	 AS_IF(test -n "$cache_variable", [break])
       ])
       break
     done
    ])

  m4_popdef([search_sourcecode])

  AS_IF(test -n "$cache_variable",
    m4_n([action_if_found]),
    m4_n([action_if_not_found])
    )

  m4_popdef([cache_variable])
])
