#!/bin/bash

# get-git-source.sh - Retrieve upstream's sources from a GIT repository
#
# Copyright 2014 Alessio Treglia <alessio@debian.org>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
#
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

set -e

PACKAGE=libmtp
BASE_REL=${BASE_REL:-$(dpkg-parsechangelog 2>/dev/null | sed -ne 's/Version: \([0-9\.]\+\)-.*/\1/p')}
OLDDIR=${PWD}
GOS_DIR=${OLDDIR}/get-orig-source
REPACK_EXT=~ds0

if [ -z ${BASE_REL} ]; then
    echo 'Please run this script from the sources root directory.'
    exit 1
fi

rm -rf ${GOS_DIR}
mkdir -p ${GOS_DIR} && cd ${GOS_DIR}
git clone git://git.code.sf.net/p/libmtp/code ${PACKAGE}

cd ${PACKAGE}/
GITIFIED_VERSION=${BASE_REL//./-}
GIT_DESCRIBE=$(git describe --tags | sed -e "s/${PACKAGE}-${GITIFIED_VERSION}-\(.*\)/\1/")
NEWVER=${BASE_REL}-${GIT_DESCRIBE}${REPACK_EXT}
cd .. && mv ${PACKAGE} ${PACKAGE}-${NEWVER} && cd ${PACKAGE}-${NEWVER}
cd .. && XZ_OPT=-f9 tar cJf \
    ${OLDDIR}/${PACKAGE}_${NEWVER}.orig.tar.xz \
    ${PACKAGE}-${NEWVER} --exclude-vcs --exclude='*/logs'
rm -rf ${GOS_DIR}
