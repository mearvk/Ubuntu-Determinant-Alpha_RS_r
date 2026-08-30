#!/bin/sh

set -e

if [ ! -f debian/control ] ;
then
    echo Run from wrong directory: "$PWD"
    exit 1
fi


if [ -f Makefile ];
then
    make --no-builtin-rules clean
fi

rm -rf	temp autom4te.cache gen

rm -rf	Makefile config.log config.status libtool

#	src/dsql/dsql.tab.h

rm -rf	src/dsql/dsql.tab.c \
	src/dsql/parse.cpp \
	src/include/gen/autoconfig.h \
	src/include/gen/blrtable.h \
	src/include/gen/Firebird.pas \
	src/v5_examples/Makefile

rm -f 	src/burp/backup.cpp \
	src/burp/restore.cpp \
	src/gpre/gpre_meta.cpp \
	src/jrd/codes.cpp \
	src/msgs/build_file.cpp \
	src/dsql/array.cpp \
	src/dsql/blob.cpp \
	src/dsql/metd.cpp \
	src/dudley/exe.cpp \
	src/isql/extract.cpp \
	src/isql/isql.cpp \
	src/isql/show.cpp \
	src/jrd/dfw.cpp \
	src/jrd/dpm.cpp \
	src/jrd/dyn.cpp \
	src/jrd/dyn_def.cpp \
	src/jrd/dyn_del.cpp \
	src/jrd/dyn_mod.cpp \
	src/jrd/dyn_util.cpp \
	src/jrd/fun.cpp \
	src/jrd/grant.cpp \
	src/jrd/ini.cpp \
	src/jrd/met.cpp \
	src/jrd/pcmet.cpp \
	src/jrd/scl.cpp \
	src/msgs/change_msgs.cpp \
	src/msgs/check_msgs.cpp \
	src/msgs/enter_msgs.cpp \
	src/msgs/modify_msgs.cpp \
	src/qli/help.cpp \
	src/qli/meta.cpp \
	src/qli/proc.cpp \
	src/qli/show.cpp \
	src/utilities/security.cpp

rm -f   src/include/gen/parse.h \
        src/include/firebird/IdlFbInterfaces.h \
        src/include/gen/autoconfig.auto \
        src/include/gen/ids.h

rm -f   extern/btyacc/btyacc \
        src/dsql/dsql.tab.h

rm -f src/*.fdb src/*.lnk src/indicator.* src/Makefile

rm -rf m4

rm -rf debian/tmp-lock

rm -f debian/fdb-r15y-prune debian/fdb-r15y-prune.d

exit 0
