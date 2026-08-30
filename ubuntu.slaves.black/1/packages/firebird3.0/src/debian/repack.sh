#!/bin/sh
#
# Repack upstream source converting from bz2 to gz and
# removing some debian-supplied libraries and generated
# files in the process
#
# To be called via debian/watch (uscan or uscan --force)
# or
#  sh debian/repack.sh --upstream-version VER FILE

set -e
set -u

usage() {
    cat <<EOF >& 2
Usage: $0 --upstream-version VER FILE

            or

       uscan [--force]
EOF
}

[ "${1:-}" = "--upstream-version" ] \
    && [ -n "${2:-}" ] \
    && [ -n "${3:-}" ] \
    && [ -z "${4:-}" ] \
    || usage

TMPDIR=`mktemp -d -p .`

trap "rm -rf $TMPDIR" INT QUIT 0

VER="$2"
DEB_VER="${VER}.ds4"
UP_VER="${VER}"
UPSTREAM_TAR="$3"
UPSTREAM_DIR=Firebird-${UP_VER}
ORIG="../firebird3.0_${DEB_VER}.orig.tar.xz"
ORIG_DIR="firebird3.0-${DEB_VER}.orig"

if [ -e "$ORIG" ]; then
    echo "$ORIG already exists. Aborting."
    exit 1
fi

echo -n "Expanding upstream source tree..."
if [ "$UPSTREAM_TAR" != "${UPSTREAM_TAR%.bz2}" ]; then
    tar xjf $UPSTREAM_TAR -C $TMPDIR
elif [ "$UPSTREAM_TAR" != "${UPSTREAM_TAR%.gz}" ]; then
    tar xzf $UPSTREAM_TAR -C $TMPDIR
elif [ "$UPSTREAM_TAR" != "${UPSTREAM_TAR%.xz}" ]; then
    tar xJf $UPSTREAM_TAR -C $TMPDIR
else
    echo "Don't know how to expand $UPSTREAM_TAR" >&2
    exit 1
fi
echo " done."

UPSTREAM_DIR=`ls -1 $TMPDIR`

# clean sources, needlessly supplied by upstream.
# Debian has packages for them already
# and generated files
echo -n "Cleaning upstream sources from unneeded things..."
for d in icu editline btyacc/test/ftp.y libtommath;
do
    echo -n " $d"
    rm -r $TMPDIR/$UPSTREAM_DIR/extern/$d
done
echo " done."

echo -n "Removing bundled boost..."
rm -r $TMPDIR/$UPSTREAM_DIR/src/include/firebird/impl/boost
echo " done."

echo -n "Removing source-less database backups..."
for f in msg metadata help; do
    rm -vf $TMPDIR/$UPSTREAM_DIR/builds/misc/$f.gbak
done
echo " done."

echo Removing files with no license...
cat debian/prune-upstream-dfsg.lst \
| while read f; do
    rm -rv $TMPDIR/$UPSTREAM_DIR/$f
done

echo -n "Removing generated files..."
for f in \
    configure \
    builds/make.new/config/config.guess \
    builds/make.new/config/config.h.in \
    builds/make.new/config/config.sub \
    builds/make.new/config/install-sh \
    builds/make.new/config/ltmain.sh \
    src/include/gen/parse.h \
    src/include/gen/autoconfig.auto \
    src/include/gen/ids.h \
    ;
do
    if [ -e $TMPDIR/$UPSTREAM_DIR/$f ]; then
        rm $TMPDIR/$UPSTREAM_DIR/$f
        echo " $f"
    fi
done
echo " done."

echo -n "Removing source-less generated files..."
for f in doc/Firebird-3-QuickStart.pdf doc/ReleaseNotes.pdf; do
    if [ -e $TMPDIR/$UPSTREAM_DIR/$f ]; then
        rm $TMPDIR/$UPSTREAM_DIR/$f
        echo -n " $f"
    fi
done
echo " done."

echo -n "Removing .gitignore files..."
find $TMPDIR/$UPSTREAM_DIR -name .gitignore -delete
echo " done."

find "$TMPDIR/$UPSTREAM_DIR" -type d -empty -delete

mv $TMPDIR/$UPSTREAM_DIR $TMPDIR/$ORIG_DIR

echo -n Repackaging into ${ORIG} ...
tar c -C $TMPDIR $ORIG_DIR | xz > "$ORIG"
echo " done."
