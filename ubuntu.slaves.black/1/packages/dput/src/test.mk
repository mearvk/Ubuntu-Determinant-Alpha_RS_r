# test.mk
# Part of ‘dput’, a Debian package upload toolkit.
#
# This is free software, and you are welcome to redistribute it under
# certain conditions; see the end of this file for copyright
# information, grant of license, and disclaimer of warranty.

# Makefile rules for test suite.

MODULE_DIR := $(CURDIR)

TEST_MODULES += $(shell find ${MODULE_DIR}/ -name 'test_*.py')

PYTHON_UNITTEST = $(PYTHON) ${PYTHON_OPTS} -m unittest
UNITTEST_NAMES ?= discover
UNITTEST_OPTS ?= ${UNITTEST_NAMES} --buffer

export COVERAGE_DIR = ${MODULE_DIR}/.coverage
coverage_html_report_dir = ${MODULE_DIR}/htmlcov

PYTHON_COVERAGE = $(PYTHON) ${PYTHON_OPTS} -m coverage
COVERAGE_RUN_OPTS ?= --branch
COVERAGE_REPORT_OPTS ?=
COVERAGE_TEXT_REPORT_OPTS ?=
COVERAGE_HTML_REPORT_OPTS ?=


.PHONY: test
test: test-unittest test-manpages

.PHONY: test-unittest
test-unittest:
	$(PYTHON_UNITTEST) ${UNITTEST_OPTS}

.PHONY: test-coverage
test-coverage: test-coverage-run test-coverage-html test-coverage-report

.PHONY: test-coverage-run
test-coverage-run: coverage_opts = ${COVERAGE_RUN_OPTS}
test-coverage-run: ${CODE_MODULES}
	$(PYTHON_COVERAGE) run ${coverage_opts} \
		-m unittest ${UNITTEST_OPTS}

${COVERAGE_DIR}: test-coverage-run

GENERATED_FILES += ${COVERAGE_DIR}

.PHONY: test-coverage-html
test-coverage-html: coverage_opts = ${COVERAGE_REPORT_OPTS} ${COVERAGE_HTML_REPORT_OPTS}
test-coverage-html: ${COVERAGE_DIR}
	$(PYTHON_COVERAGE) html ${coverage_opts} \
		--directory ${coverage_html_report_dir}/ \
		$(filter-out ${TEST_MODULES},${package_modules})

GENERATED_FILES += ${coverage_html_report_dir}

.PHONY: test-coverage-report
test-coverage-report: coverage_opts = ${COVERAGE_REPORT_OPTS} ${COVERAGE_TEXT_REPORT_OPTS}
test-coverage-report: .coverage
	$(PYTHON_COVERAGE) report ${coverage_opts} \
		$(filter-out ${TEST_MODULES},${package_modules})


.PHONY: test-manpages
test-manpages: export LC_ALL = C.UTF-8
test-manpages: export MANROFFSEQ =
test-manpages: export MANWIDTH = 80
test-manpages: export MANOPTS = --encoding=UTF-8 --troff-device=utf8 --ditroff
test-manpages: ${manpage_paths}
	for manfile in $^ ; do \
		printf "Rendering %s:" $$manfile ; \
		man --local-file --warnings $$manfile > /dev/null ; \
		printf " done.\n" ; \
	done


# Copyright © 2008–2021 Ben Finney <bignose@debian.org>
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
