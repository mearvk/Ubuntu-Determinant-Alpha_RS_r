#!/bin/sh

set -eu

get_ver()
{
	awk "/FB_$1/ { v=\$3; gsub(\"\\\"\", \"\", v); print v}" < src/jrd/build_no.h
}

FB_MAJOR=$( get_ver 'MAJOR_VER' )
FB_MINOR=$( get_ver 'MINOR_VER' )
FB_REV=$( get_ver 'REV_NO' )

FB_VERSION="${FB_MAJOR}.${FB_MINOR}.${FB_REV}"

FB_VER="${FB_MAJOR}.${FB_MINOR}"
FB="firebird$FB_VER"
FB_no_dots=$(echo "$FB" | sed -e 's/\.//g')
FBDIR="firebird/$FB_VER"
ULFB="usr/lib/$DEB_HOST_MULTIARCH/$FBDIR"
VAR="var/lib/$FBDIR"
CLIENT_SO_VER=2
UTIL_SO_VER=

if echo ${DEB_BUILD_OPTIONS:-} | egrep -q '\bnodoc\b'; then
    NODOC="nodoc"
else
    NODOC=
fi

copy ()
{
    type=$1
    dest=$2
    shift
    shift

    case "$type" in
        e*) mode="755" ;;
        f*) mode="644" ;;
        *) echo "Error: Wrong params for copy!"; exit 1;;
    esac

    install -m "$mode" "$@" "$dest"
}

# Helper function used both in -super and -classic
copy_utils()
{
    for s in gbak gfix gpre gsec gstat isql nbackup fbsvcmgr ;
    do
        target="$s"
        if [ "$target" = gstat ];
        then
            target=fbstat
        elif [ "$target" = isql ];
        then
            target=isql-fb
        fi

        copy e "$D/usr/bin/$target" "$S/bin/$s"
    done
}

COMMON_DOC="/usr/share/doc/$FB-common-doc"

doc_symlink() {
    local doc_root
    doc_root="debian/$P/usr/share/doc"
    [ -d "$doc_root" ] || mkdir -p "$doc_root"
    ln -s "$FB-common-doc" "$doc_root/$P"
}

#-server-core
make_server_core () {
    P="$FB-server-core"
    echo "Creating $P content"
    D="debian/$P"
    S=debian/firebird-image

    mkdir -p "$D/$ULFB/UDF" \
             "$D/$ULFB/intl" \
             "$D/var/log/firebird"

    find "$S/plugins" -type f -name '*.so' -not -name '*_example.so'| \
        while read f; do
            f="${f#$S/}"
            mkdir -p "$(dirname "$D/$ULFB/$f")"
            install -m 0644 "$S/$f" "$D/$ULFB/$f"
        done


    copy e "$D/$ULFB/UDF" \
        "$S/UDF/fbudf.so" "$S/UDF/ib_udf.so"

    install -m 0755 "$S/intl/libfbintl.so" "$D/$ULFB/intl/"

    ln -s "/etc/$FBDIR/fbintl.conf" "$D/$ULFB/intl/"
    for f in firebird plugins; do
        ln -s "/etc/$FBDIR/$f.conf" "$D/$ULFB/"
    done

    copy f "$D/$ULFB/UDF" \
        src/extlib/fbudf/fbudf.sql    \
        src/extlib/ib_udf.sql

    doc_symlink
}

#-server
make_server () {
    P="$FB-server"
    echo "Creating $P content"
    D="debian/$P"
    S=debian/firebird-image

    mkdir -p "$D/usr/bin" "$D/usr/sbin" \
             "$D/etc/xinetd.d" "$D/etc/$FBDIR" "$D/$VAR/data" \
             "$D/$VAR/system" "$D/$VAR/backup" \
             "$D/$ULFB" \
             "$D/$COMMON_DOC/examples"

    copy e "$D/usr/sbin"              \
        "$S/bin/firebird"

    copy e "$D/usr/bin"       \
        "$S/bin/fb_lock_print"   \
        "$S/bin/fbtracemgr"


    # manpages
    if [ -z "$NODOC" ]; then
        for u in fbtracemgr fb_lock_print ;
        do
            dh_installman -p "$P" "debian/man/$u.1"
        done
        for u in fbguard firebird ;
        do
            dh_installman -p "$P" "debian/man/$u.8"
        done
    fi

    install -m 0644 "debian/$P.xinetd" \
                    "$D/etc/xinetd.d/$FB_no_dots"

    copy f "$D/etc/$FBDIR" \
        "$S/databases.conf" \
        "$S/fbtrace.conf"

    for f in databases fbtrace ; do
        ln -s "/etc/$FBDIR/$f.conf" "$D/$ULFB/"
    done

    # fix databases.conf: Remove references to employee
    sed -i -e'/^# Example Database/,/^employee / d' \
        "$D/etc/$FBDIR/databases.conf"

    # security db SQL
    mkdir -p "$D/usr/share/$FBDIR"
    install -m0644 "src/dbs/security.sql" "$D/usr/share/$FBDIR/"

    touch "$D/$VAR/backup/no_empty"
    touch "$D/$VAR/data/no_empty"

    copy e "$D/usr/sbin" "$S/bin/fbguard"

    # systemd support
    mkdir -p "$D/lib/systemd/system"
    cp gen/install/misc/*.service gen/install/misc/*.socket "$D/lib/systemd/system/"
    sed -i -e"/^PIDFile/d; s,var/run/firebird/,run/firebird$FB_VER/,g; /^ExecStart/ a RuntimeDirectory=firebird$FB_VER" \
        "$D/lib/systemd/system/"*.service
    sed -i -e"s,var/run/firebird/,run/firebird$FB_VER/,g; /^Accept=/ a RuntimeDirectory=firebird$FB_VER" \
        "$D/lib/systemd/system/"*.socket

    mkdir -p "$D/usr/lib/tmpfiles.d"
    echo "d /tmp/firebird 0770 firebird firebird -" > "$D/usr/lib/tmpfiles.d/firebird$FB_VER.conf"

    mkdir "$D/$COMMON_DOC/examples/systemd"
    mv "$D/lib/systemd/system/firebird-classic"* \
        "$D/$COMMON_DOC/examples/systemd"
    rename "s/firebird-classic/firebird$FB_VER-classic/" \
        "$D/$COMMON_DOC/examples/systemd"/*
    sed -i -e"s,firebird-superserver,firebird$FB_VER-server," \
        "$D/$COMMON_DOC/examples/systemd"/*
    rename "s/firebird-superserver/firebird3.0/" \
        "$D/lib/systemd/system"/*
    sed -i -e"s,firebird-classic,firebird$FB_VER-classic," \
        "$D/lib/systemd/system/firebird$FB_VER.service"

    copy f "$D/$COMMON_DOC/examples" debian/reindex-db

    doc_symlink
}

#libfbclient
make_libfbclient () {
    P="libfbclient$CLIENT_SO_VER"
    echo "Creating $P content"
    D="debian/$P"
    S=debian/firebird-image

    mkdir -p "$D/$ULFB/lib"

    copy e "$D/usr/lib/$DEB_HOST_MULTIARCH" "$S/lib/libfbclient.so.$FB_VERSION"
    ln -s "libfbclient.so.$FB_VERSION" \
        "$D/usr/lib/$DEB_HOST_MULTIARCH/libfbclient.so.$CLIENT_SO_VER"

    ln -s "/usr/lib/$DEB_HOST_MULTIARCH/libfbclient.so.$CLIENT_SO_VER" \
        "$D/$ULFB/lib/"

    for m in "$S"/*.msg;
    do
        copy f "$D/$ULFB" "$m"
    done

    doc_symlink
}

#libib-util
make_libib_util () {
    P="libib-util$UTIL_SO_VER"
    echo "Creating $P content"
    D="debian/$P"
    S=debian/firebird-image

    mkdir -p "$D/$ULFB/lib"

    install -m 0755 "$S/lib/libib_util.so" "$D/usr/lib/$DEB_HOST_MULTIARCH/"

    ln -s "/usr/lib/$DEB_HOST_MULTIARCH/libib_util.so" "$D/$ULFB/lib/"

    doc_symlink
}


#-utils
make_utils () {
    P="$FB-utils"
    echo "Creating $P content"
    D="debian/$P"
    S=debian/firebird-image

    mkdir -p "$D/usr/bin"

    copy_utils

    # manpages
    if [ -z "$NODOC" ]; then
        for u in fbstat gbak gsec isql-fb gfix gpre nbackup fbsvcmgr ;
        do
            dh_installman -p "$P" "debian/man/$u.1"
        done
    fi

    doc_symlink
}

#-common
make_common () {
    P="$FB-common"
    echo "Creating $P content"
    D="debian/$P"
    S=debian/firebird-image

    mkdir -p \
        "$D/etc/$FBDIR" \
        "$D/usr/share/$P"

    # config
    copy f "$D/etc/$FBDIR" "$S/firebird.conf"
    sed -i -e '/^#RemoteBindAddress/ a RemoteBindAddress = localhost' "$D/etc/$FBDIR/firebird.conf"

    sed "s,\$(this),\$(root)/intl," "$S/intl/fbintl.conf" > "$D/etc/$FBDIR/fbintl.conf"
    copy f "$D/etc/$FBDIR/plugins.conf" "$S/plugins.conf"

    install -m 0644 \
        debian/functions.sh \
        "$D/usr/share/$P/"

    doc_symlink
}

#-dev
make_dev () {
    P="firebird-dev"
    echo "Creating $P content"
    D="debian/$P"
    S=debian/firebird-image

    mkdir -p "$D/usr/include" \
             "$D/usr/include/firebird" \
             "$D/usr/bin"

    copy f "$D/usr/include" "$S/include/"*.h
    copy f "$D/usr/include/firebird" "$S/include/firebird"/*
    copy f "$D/usr/include/firebird" "$S/include-gen/Firebird.pas"
    copy e "$D/usr/bin" "$S/bin/fb_config"

    mkdir -p "$D/$ULFB/lib"

    ln -s "libfbclient.so.$CLIENT_SO_VER" \
        "$D/usr/lib/$DEB_HOST_MULTIARCH/libfbclient.so"

    ln -s "/usr/lib/$DEB_HOST_MULTIARCH/libfbclient.so" "$D/$ULFB/lib/"

    ln -s /usr/include "$D/$ULFB/"

    if [ -n "$UTIL_SO_VER" ]; then
        ln -s "libib_utill.so.$UTIL_SO_VER" \
            "$D/usr/lib/$DEB_HOST_MULTIARCH/libib_util.so"
    fi

    if [ -z "$NODOC" ]; then
        dh_installman -p "$P" debian/man/fb_config.1
    fi

    doc_symlink
}


#-examples
make_examples () {
    P="$FB-examples"
    echo "Creating $P content"
    D="debian/$P"
    S=debian/firebird-image

    mkdir -p "$D/$COMMON_DOC"
    cp -r "$S/examples" "$D/$COMMON_DOC"
    rm -r "$D/$COMMON_DOC/examples/empbuild"

    (
        echo "-- This is a generated file"
        echo "set sql dialect 3;"
        echo "create database 'employee.fdb';"
        cat "examples/empbuild/empddl.sql"
        cat "examples/empbuild/indexoff.sql"
        cat "examples/empbuild/empdml.sql"
        cat "examples/empbuild/indexon.sql"
        debian/emp_data.pl --table job --key job_code,job_grade,job_country \
            --blob-col job_requirement \
            < "examples/empbuild/job.inp"
        debian/emp_data.pl --table project --key proj_id \
            --blob-col proj_desc \
            < "examples/empbuild/proj.inp"
    ) > "$D/$COMMON_DOC/examples/employee.sql";


    # remove empty directories
    find "$D/$COMMON_DOC/examples" -type d -print0 \
        | xargs -0 rmdir --ignore-fail-on-non-empty -p

    install -m 0644 \
        "debian/$P.README.Debian" \
        "$D/$COMMON_DOC/examples/README.Debian"

    doc_symlink
}

#-doc
make_doc () {
    P="$FB-doc"
    echo "Creating $P content"
    D="debian/$P/$COMMON_DOC/doc"
    S=doc

    mkdir -p "$D"

    if [ -z "$NODOC" ]; then
        cp -r "$S"/* "$D/"

        recode windows-1251..utf8 "$D/ods11-index-structure.html"
        sed -i -e 's/windows-1252/UTF-8/' "$D/ods11-index-structure.html"

        rm -r "$D/license"
    fi

    doc_symlink
}

#-common-doc
make_common_doc() {
    P="$FB-common-doc"
    echo "Creating $P content"
    mkdir -p "debian/$P/$COMMON_DOC"

    install -m 0644 \
        "debian/README.Debian" \
        "debian/$P/$COMMON_DOC/README.Debian"

}

umask 022
make_server_core
make_server
make_libfbclient
make_utils
make_libib_util
make_common
make_dev
make_examples
make_doc
make_common_doc
echo "Packages ready."
exit 0
