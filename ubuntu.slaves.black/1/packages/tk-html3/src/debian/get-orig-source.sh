#!/bin/sh

#
# Download tkHTML from its fossil repository. This reqires that we know 
# the patch ID and have a session cookie.
#

#
# Fossil uuid and corresponding date. The date goes only into the version 
# number. Since the development is rather slow, there putting year-month-day
# here is more than enough.
#
UUID=4ee7aaa953d6cb59905b9ee1bf9f292a7138deb2
DATE="20110109"

SID=$(echo ${UUID} | cut -c-16)
INCOMING_TAR=tkHTML-${SID}.tar.gz

#
# Get the values for login
#
wget -O fossil_login.html http://tkhtml.tcl.tk/fossil/login
PASSWD=$(fgrep "getElementById('p')" fossil_login.html | cut -d\' -f4)
CS=$(fgrep \"cs\" fossil_login.html | cut -d\" -f6)
echo $PASSWD $CS
rm -f fossil_login.html

#
# Save the login cookie
#
wget -O /dev/null --save-cookies fossil_cookies.txt \
     --post-data "cs=${CS}&u=anonymous&p=${PASSWD}&in=Login" \
     http://tkhtml.tcl.tk/fossil/login

#
# Retrieve file with the login cookie
# 
wget --load-cookies fossil_cookies.txt -O ${INCOMING_TAR} \
     "http://tkhtml.tcl.tk/fossil/tarball/${INCOMING_TAR}?uuid=${UUID}"
rm -f fossil_cookies.txt

VERSION=$(tar xOf ${INCOMING_TAR} --wildcards \*/configure.in |\
          grep ^AC_INIT | cut -d, -f2 | cut -d\) -f1)
VERSION=$(echo ${VERSION} | tr -d \[\])

if [ "${VERSION}" != "" ] ; then
  DEBIAN_ORIG_TAR=tk-html3_${VERSION}~fossil${DATE}.orig.tar.gz
  ln -sf ${INCOMING_TAR} ${DEBIAN_ORIG_TAR}
else
  echo "Could not find version info in tar file. Check ${INCOMING_TAR}"
fi
