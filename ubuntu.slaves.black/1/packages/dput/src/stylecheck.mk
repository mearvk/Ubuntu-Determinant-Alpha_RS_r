# stylecheck.mk
# Part of ‘dput’, a Debian package upload toolkit.
#
# This is free software, and you are welcome to redistribute it under
# certain conditions; see the end of this file for copyright
# information, grant of license, and disclaimer of warranty.

# Makefile rules for static style checks.

MODULE_DIR := $(CURDIR)

PYTHON_PYCODESTYLE ?= $(PYTHON) ${PYTHON_OPTS} -m pycodestyle
PYTHON_PYCODESTYLE_OPTS ?=

PYTHON_PYDOCSTYLE ?= $(PYTHON) ${PYTHON_OPTS} -m pydocstyle
PYTHON_PYDOCSTYLE_OPTS ?=

PYTHON_PYLINT ?= $(PYTHON) ${PYTHON_OPTS} -m pylint
PYTHON_PYLINT_OPTS ?=


.PHONY: stylecheck
stylecheck: stylecheck-pycodestyle

.PHONY: stylecheck-pycodestyle
stylecheck-pycodestyle:
	$(PYTHON_PYCODESTYLE) ${PYTHON_PYCODESTYLE_OPTS} ${python_modules}

.PHONY: stylecheck-pydocstyle
stylecheck-pydocstyle:
	$(PYTHON_PYDOCSTYLE) ${PYTHON_PYDOCSTYLE_OPTS} ${python_modules}

.PHONY: stylecheck-pylint
stylecheck-pylint:
	$(PYTHON_PYLINT) ${PYTHON_PYLINT_OPTS} ${python_modules}


# Copyright © 2015–2021 Ben Finney <bignose@debian.org>
#
# This is free software: you may copy, modify, and/or distribute this work
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; version 3 of that license or any later version.
# No warranty expressed or implied. See the file ‘LICENSE.GPL-3’ for details.


# Local Variables:
# coding: utf-8
# mode: makefile
# End:
# vim: fileencoding=utf-8 filetype=make :
