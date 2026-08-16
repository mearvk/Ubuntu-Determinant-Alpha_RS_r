#! /usr/bin/make -f
#
# This is free software, and you are welcome to redistribute it under
# certain conditions; see the end of this file for copyright
# information, grant of license, and disclaimer of warranty.

# Makefile for this code base.

PYTHON ?= /usr/bin/python3
PYTHON_OPTS ?= -bb

PY_MODULE_SUFFIX = .py
PY_MODULE_BYTECODE_SUFFIX = .pyc
package_modules = $(shell find ${CURDIR}/dput/ -name '*${PY_MODULE_SUFFIX}')
python_modules = $(shell find ${CURDIR}/ -name '*${PY_MODULE_SUFFIX}')

GENERATED_FILES :=
GENERATED_FILES += $(patsubst \
	%${PY_MODULE_SUFFIX},%${PY_MODULE_BYTECODE_SUFFIX}, \
	${python_modules})
GENERATED_FILES += ${CURDIR}/*.egg-info
GENERATED_FILES += ${CURDIR}/build ${CURDIR}/dist

DOC_DIR = doc
MANPAGE_GLOB = *.[1-8]
MANPAGE_DIR = ${DOC_DIR}/man
manpage_paths = $(wildcard ${MANPAGE_DIR}/${MANPAGE_GLOB})


.PHONY: all
all:


.PHONY: clean
clean:
	$(RM) -r ${GENERATED_FILES}


.PHONY: tags
tags: TAGS

GENERATED_FILES += TAGS

TAGS: ${python_modules}
	etags --output "$@" --lang=python ${python_modules}


include test.mk
include stylecheck.mk


# Copyright © 2015–2021 Ben Finney <bignose@debian.org>
#
# This is free software: you may copy, modify, and/or distribute this work
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; version 3 of that license or any later version.
# No warranty expressed or implied. See the file ‘LICENSE.GPL-3’ for details.


# Local variables:
# coding: utf-8
# mode: makefile
# End:
# vim: fileencoding=utf-8 filetype=make :
