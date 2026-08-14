# Build an RPM for imanx
# 
# Copyright (C) 2002 Alastair McKinstry, <mckinstry@computer.org>
# Released under the GPL; see file COPYING for details.
#
#

VERSION=0.5
TARFILE=imanx_${VERSION}.orig.tar.gz


ifndef RPM_SOURCE_DIR
RPM_SOURCE_DIR=/usr/src/rpm/SOURCES
endif


rpm: imanx.spec ../../${TARFILE}
	cp ../../${TARFILE} ${RPM_SOURCE_DIR}
	rpm -ba -vv imanx.spec
	
clean:
	rm -f *~ *# *.log *.spec

imanx.spec: imanx.spec.sed
	sed 's/@VERSION@/${VERSION}/' < $< > $@

# if the Debian-style tarfile doesn't exist, build it
../../${TARFILE}:
	( cd ../.. ; tar zcpf ${TARFILE} imanx-${VERSION} )
