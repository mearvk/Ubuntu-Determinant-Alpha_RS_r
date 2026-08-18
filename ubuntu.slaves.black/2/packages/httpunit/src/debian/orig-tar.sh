#!/bin/sh -e

PACKAGE="httpunit"
DEB_VERSION=`dpkg-parsechangelog | sed -ne 's/^Version: \(.*\)-.*/\1/p'`
VERSION=`echo $DEB_VERSION | sed -e 's/+dfsg$//'`
TARBALL="${PACKAGE}_${DEB_VERSION}.orig.tar.gz"
SITE="download.sourceforge.net/pub/sourceforge/h/ht/$PACKAGE/$PACKAGE-${VERSION}.zip"
MIRROR="http://www.mirrorservice.org/sites"
NONDFSG="jars/* lib/* doc/tutorial/*.zip doc/api/* META-INF/*.dtd META-INF/*.xsd"

rm -rf get-orig-source $TARBALL
mkdir get-orig-source
wget ${MIRROR}/${SITE} -O get-orig-source/${PACKAGE}-${VERSION}.zip
unzip -d get-orig-source get-orig-source/${PACKAGE}-${VERSION}.zip
cd get-orig-source/${PACKAGE}-${VERSION} && rm -rf ${NONDFSG}
cd $OLDPWD
mv get-orig-source/${PACKAGE}-${VERSION} get-orig-source/${PACKAGE}-${DEB_VERSION}
GZIP=--best tar czf ${PACKAGE}_${DEB_VERSION}.orig.tar.gz -C get-orig-source \
                    ${PACKAGE}-${DEB_VERSION}
rm -rf get-orig-source
echo "  "${TARBALL}" created; move it to the right destination to build the package"
