VERSION = 2.0
ARCHIVE = Gargi-${VERSION}
CURDIR := $(shell pwd)

TMP := $(shell mktemp -d Gargi.XXX)

default:
	./generate.pe *.sfd
clean:
	rm -rf *.ttf
sdist:
	mkdir -p ${TMP}/${ARCHIVE}
	cp *.sfd COPYING *.txt Makefile generate.pe ${TMP}/${ARCHIVE}
	tar -cvJf ${ARCHIVE}.src.tar.xz -C ${TMP}/${ARCHIVE} .
	rm -rf ${TMP}

bdist: default
	mkdir -p ${TMP}/${ARCHIVE}
	cp *.ttf COPYING *.txt ${TMP}/${ARCHIVE}
	tar -cvJf ${ARCHIVE}.tar.xz -C ${TMP}/${ARCHIVE} .
	rm -rf ${TMP}

distclean: clean
	rm -rf *.xz
