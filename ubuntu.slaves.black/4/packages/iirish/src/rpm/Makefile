# Makefile for spell-ga/rpm,
#
# Copyright (C) Alastair McKinstry, 1997,1998, 2002
# Released under the GNU Public License
#
# $Id: $
#

# This Makefile builds the RPM files as necessary
# Called from the top-level makefile '$MAKE rpm', with kit

VERSION=2.0
TARFILE=iirish_${VERSION}.orig.tar.gz


ifndef RPM_SOURCE_DIR
RPM_SOURCE_DIR=/usr/src/rpm/SOURCES
endif



rpm: iirish.spec ../../${TARFILE}
	cp ../../${TARFILE} ${RPM_SOURCE_DIR}
	rpm -ba -vv iirish.spec

clean:
	rm -f *~ *# *.log *.spec

iirish.spec: iirish.spec.sed
	sed 's/@VERSION@/${VERSION}/' < $< > $@

# if the Debian-style tarfile doesn't exist, build it
../../${TARFILE}:
	( cd ../.. ; tar zcpf ${TARFILE} iirish-${VERSION} )
