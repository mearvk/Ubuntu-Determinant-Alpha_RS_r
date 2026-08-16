# Copyright (C) 1999-2009  Free Software Foundation, Inc.
#  
# This file is part of GNU gengetopt 
#
# GNU gengetopt is free software; you can redistribute it and/or modify 
# it under the terms of the GNU General Public License as published by 
# the Free Software Foundation; either version 3, or (at your option) 
# any later version. 
#
# GNU gengetopt is distributed in the hope that it will be useful, but 
# WITHOUT ANY WARRANTY; without even the implied warranty of 
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
# Public License for more details. 
#
# You should have received a copy of the GNU General Public License along 
# with gengetopt; see the file COPYING. If not, write to the Free Software 
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA. 

if NO_CROSSCOMPILING

# .ggonu is used in this test suite for command line parsers that have
# to be created without --unnamed-opt

SUFFIXES = .ggo .ggonu .ggoconf .ggostr

# we do not generate the gengetopt version number in the output
# file so that the number does not disturb in diffing when changing
# gengetopt version
NEW_GENGETOPT = $(top_builddir)/src/gengetopt$(EXEEXT) --gen-version
GGO_COMPILE = $(NEW_GENGETOPT) --input=$< --func-name=$*_parser --file-name=$*

.ggo.c:
	$(GGO_COMPILE) --unnamed-opt --show-required

test_unamed_cmd.c: test_unamed_cmd.ggo
	$(GGO_COMPILE) --unamed-opt --show-required

.ggonu.c:
	$(GGO_COMPILE)

.ggoconf.c:
	$(GGO_COMPILE) --unnamed-opt="OTHER NAMES" --conf-parser \
		--arg-struct-name="my_args_info" --no-handle-error

.ggostr.c:
	$(GGO_COMPILE) --unnamed-opt="OTHER NAMES" --string-parser \
		--arg-struct-name=$*_struct --include-getopt

test_manual_help_cmd.c: $(srcdir)/test_manual_help_cmd.ggo
	$(GGO_COMPILE) --unnamed-opt --show-required --no-help --no-version

# INCLUDES is added to LDFLAGS because .ggo file are sources, and thus
# the .c files are passed to the linker, which also compiles, thus
# the include options should be passed to it as well
AM_LDFLAGS = $(DEFS) $(INCLUDES)

# these are for gnulib
AM_CPPFLAGS = -I$(top_srcdir)/gl -I$(top_builddir)/gl

LDADD = $(top_builddir)/gl/libgnu.la

EXPECT = 1

VALGRINDTESTS = \
	canonize-names \
	default_cmdline \
	default_values \
	more_than_once.sh \
	no_multi_strings \
	no_multi_types \
	no_optgiven.sh \
	no_prog_name \
	no_strings \
	no_unnamed \
	test_all_opts.sh \
	test_all_opts_file_save.sh \
	test_all_opts_option_help \
	test_conf_parser.sh \
	test_conf_parser_err.sh \
	test_conf_parser_err_string.sh \
	test_conf_parser_grp.sh \
	test_conf_parser_ov.sh \
	test_conf_parser_ov2.sh \
	test_conf_parser_ov3.sh \
	test_conf_parser_ov4.sh \
	test_conf_parser_save.sh \
	test_default_values.sh \
	test_dep.sh \
	test_groups.sh \
	test_groups_option_help \
	test_manual_help.sh \
	test_manual_help_args.sh \
	test_modes.sh \
	test_modes_option_help \
	test_multiple.sh \
	test_multiple_err.sh \
	test_multiple_parsers.sh \
	test_newlines \
	test_no_options \
	test_only_flags \
	test_sections.sh \
	test_sections_option_help \
	test_simple_multiple.sh \
	test_simple_multiple_default.sh \
	test_text \
	test_usage \
	test_unamed.sh \
	test_unnamed.sh \
	test_values.sh \
	test_values_err.sh

TESTS = \
	$(VALGRINDTESTS) \
	test_output_dir.sh \
	test_output_dirs.sh \
	test_show_help.sh \
	test_wrong_ggo.sh

check_PROGRAMS = \
	canonize-names \
	default_cmdline \
	default_values \
	more_than_once \
	no_multi_strings \
	no_multi_types \
	no_optgiven \
	no_optgiven2 \
	no_prog_name \
	no_strings \
	no_unnamed \
	test_all_opts \
	test_all_opts_option_help \
	test_conf_parser \
	test_conf_parser_file_save \
	test_conf_parser_ov \
	test_conf_parser_ov2 \
	test_conf_parser_ov3 \
	test_conf_parser_ov4 \
	test_groups \
	test_groups_option_help \
	test_manual_help \
	test_manual_help_args \
	test_modes \
	test_modes_option_help \
	test_multiple \
	test_multiple_parsers \
	test_newlines \
	test_no_handle_help \
	test_no_options \
	test_only_flags \
	test_redef_help \
	test_sections \
	test_sections_option_help \
	test_simple_multiple \
	test_text \
	test_usage \
	test_unamed \
	test_unnamed \
	test_values \
	test_values_cc

hidden_options_programs = test_all_opts
details_options_programs = test_all_opts test_no_handle_help

no_strings_cmd.h: no_strings_cmd.c
no_multi_strings_cmd.h: no_multi_strings_cmd.c
no_multi_types_cmd.h: no_multi_types_cmd.c
no_unnamed_cmd.h: no_unnamed_cmd.c
no_optgiven_cmd.h: no_optgiven_cmd.c
more_than_once_cmd.h: more_than_once_cmd.c
canonize-names-cmd.h: canonize-names-cmd.c
default_values_cmd.h: default_values_cmd.c
cmdline.h: cmdline.c
test_all_opts_cmd.h: test_all_opts_cmd.c
test_groups_cmd.h: test_groups_cmd.c
test_modes_cmd.h: test_modes_cmd.c
test_conf_parser_cmd.h: test_conf_parser_cmd.c
test_multiple_cmd.h: test_multiple_cmd.c
test_simple_multiple_cmd.h: test_simple_multiple_cmd.c
test_sections_cmd.h: test_sections_cmd.c
test_unamed_cmd.h: test_unamed_cmd.c
test_unnamed_cmd.h: test_unnamed_cmd.c
test_values_cmd.h: test_values_cmd.c
test_values_cmd_cc.cc: test_values_cmd.c
test_redef_help_cmd.h: test_redef_help_cmd.c
test_manual_help_cmd.h: test_manual_help_cmd.c
test_manual_help_args_cmd.h: test_manual_help_args_cmd.c
test_no_handle_help_cmd.h: test_no_handle_help_cmd.c
test_main_cmdline_cmd.h: test_main_cmdline_cmd.c
test_first_cmdline_cmd.h: test_first_cmdline_cmd.c
test_second_cmdline_cmd.h: test_second_cmdline_cmd.c
test_no_options_cmd.h: test_no_options_cmd.c
test_align_cmd.h: test_align_cmd.c
test_newlines_cmd.h: test_newlines_cmd.c
test_text_cmd.h: test_text_cmd.c
test_only_flags_cmd.h: test_only_flags_cmd.c
test_usage_cmd.h: test_usage_cmd.c

no_strings_SOURCES = \
	no_strings.c \
	no_strings_cmd.ggo
no_multi_strings_SOURCES = \
	no_multi_strings.c \
	no_multi_strings_cmd.ggo
no_multi_types_SOURCES = \
	no_multi_types.c \
	no_multi_types_cmd.ggo
no_unnamed_SOURCES = \
	no_unnamed.c \
	no_unnamed_cmd.ggonu
no_optgiven_SOURCES = \
	no_optgiven.c \
	no_optgiven_cmd.ggo
no_optgiven2_SOURCES = \
	no_optgiven2.c \
	no_optgiven_cmd.ggo
more_than_once_SOURCES = \
	more_than_once.c \
	more_than_once_cmd.ggo
canonize_names_SOURCES = \
	canonize-names-cmd.ggo \
	canonize-names.c
default_values_SOURCES = \
	default_values.c \
	default_values_cmd.ggo
default_cmdline_SOURCES = \
	cmdline.ggo \
	default_cmdline.c
test_all_opts_SOURCES = \
	test_all_opts.c \
	test_all_opts_cmd.ggo
no_prog_name_SOURCES = \
	no_prog_name.c \
	test_all_opts_cmd.ggo
test_groups_SOURCES = \
	test_groups.c \
	test_groups_cmd.ggo
test_modes_SOURCES = \
	test_modes.c \
	test_modes_cmd.ggo
test_conf_parser_SOURCES = \
	test_conf_parser.c \
	test_conf_parser_cmd.ggoconf
test_conf_parser_ov_SOURCES = \
	test_conf_parser_cmd.ggoconf \
	test_conf_parser_ov.c
test_conf_parser_ov2_SOURCES = \
	test_conf_parser_cmd.ggoconf \
	test_conf_parser_ov2.c
test_conf_parser_ov3_SOURCES = \
	test_conf_parser_cmd.ggoconf \
	test_conf_parser_ov3.c
test_conf_parser_ov4_SOURCES = \
	test_conf_parser_cmd.ggoconf \
	test_conf_parser_ov4.c
test_conf_parser_file_save_SOURCES = \
	test_conf_parser_cmd.ggoconf \
	test_conf_parser_file_save.c
test_multiple_SOURCES = \
	test_multiple.cc \
	test_multiple_cmd.ggo
test_simple_multiple_SOURCES = \
	test_simple_multiple.cc \
	test_simple_multiple_cmd.ggo
test_sections_SOURCES = \
	test_sections.c \
	test_sections_cmd.ggo
test_unamed_SOURCES = \
	test_unamed.c \
	test_unamed_cmd.ggo
test_unnamed_SOURCES = \
	test_unnamed.c \
	test_unnamed_cmd.ggo
test_values_SOURCES = \
	test_values.c \
	test_values_cmd.ggo
test_values_cc_SOURCES = \
	test_values_cc.cc \
	test_values_cmd_cc.cc
test_redef_help_SOURCES = \
	test_redef_help.c \
	test_redef_help_cmd.ggo
test_manual_help_SOURCES = \
	test_manual_help.c \
	test_manual_help_cmd.ggo
test_manual_help_args_SOURCES = \
	test_manual_help_args.c \
	test_manual_help_args_cmd.ggo
test_no_handle_help_SOURCES = \
	test_no_handle_help.c \
	test_no_handle_help_cmd.ggo
test_multiple_parsers_SOURCES = \
	test_first_cmdline_cmd.ggostr \
	test_main_cmdline_cmd.ggo \
	test_multiple_parsers.c \
	test_second_cmdline_cmd.ggostr
test_sections_option_help_SOURCES = \
	test_sections_cmd.ggo \
	test_sections_option_help.c
test_all_opts_option_help_SOURCES = \
	test_all_opts_cmd.ggo \
	test_all_opts_option_help.c
test_groups_option_help_SOURCES = \
	test_groups_cmd.ggo \
	test_groups_option_help.c
test_modes_option_help_SOURCES = \
	test_modes_cmd.ggo \
	test_modes_option_help.c
test_no_options_SOURCES = \
	test_no_options.c \
	test_no_options_cmd.ggo
test_newlines_SOURCES = \
	test_newlines.c \
	test_newlines_cmd.ggo
test_text_SOURCES = \
	test_text.c \
	test_text_cmd.ggo
test_only_flags_SOURCES = \
	test_only_flags.c \
	test_only_flags_cmd.ggo
test_usage_SOURCES = \
	test_usage.c \
	test_usage_cmd.ggo

CHECKDIFFFILES = \
	canonize-names-cmd.c \
	canonize-names-cmd.h \
	cmdline.c \
	cmdline.h \
	default_values_cmd.c \
	default_values_cmd.h \
	more_than_once_cmd.c \
	more_than_once_cmd.h \
	no_multi_strings_cmd.c \
	no_multi_strings_cmd.h \
	no_multi_types_cmd.c \
	no_multi_types_cmd.h \
	no_optgiven_cmd.c \
	no_optgiven_cmd.h \
	no_strings_cmd.c \
	no_strings_cmd.h \
	no_unnamed_cmd.c \
	no_unnamed_cmd.h \
	test_align_cmd.c \
	test_align_cmd.h \
	test_all_opts_cmd.c \
	test_all_opts_cmd.h \
	test_conf_parser_cmd.c \
	test_conf_parser_cmd.h \
	test_first_cmdline_cmd.c \
	test_first_cmdline_cmd.h \
	test_groups_cmd.c \
	test_groups_cmd.h \
	test_main_cmdline_cmd.c \
	test_main_cmdline_cmd.h \
	test_manual_help_args_cmd.c \
	test_manual_help_args_cmd.h \
	test_manual_help_cmd.c \
	test_manual_help_cmd.h \
	test_modes_cmd.c \
	test_modes_cmd.h \
	test_multiple_cmd.c \
	test_multiple_cmd.h \
	test_newlines_cmd.c \
	test_newlines_cmd.h \
	test_no_handle_help_cmd.c \
	test_no_handle_help_cmd.h \
	test_no_options_cmd.c \
	test_no_options_cmd.h \
	test_only_flags_cmd.c \
	test_only_flags_cmd.h \
	test_redef_help_cmd.c \
	test_redef_help_cmd.h \
	test_second_cmdline_cmd.c \
	test_second_cmdline_cmd.h \
	test_sections_cmd.c \
	test_simple_multiple_cmd.c \
	test_simple_multiple_cmd.h \
	test_text_cmd.c \
	test_text_cmd.h \
	test_usage_cmd.c \
	test_usage_cmd.h \
	test_unamed_cmd.c \
	test_unamed_cmd.h \
	test_unnamed_cmd.c \
	test_unnamed_cmd.h \
	test_values_cmd.c \
	test_values_cmd.h

BUILT_SOURCES = $(CHECKDIFFFILES)

no_optgiven_cmd.c: no_optgiven_cmd.ggo
	$(GGO_COMPILE)
no_optgiven_cmd.h: no_optgiven_cmd.c
	@if test -f $@; then :; else \
		rm -f -- $<; \
		$(MAKE) $(AM_MAKEFLAGS) $<; \
	fi

# using $(top_builddir) should test also the removal of leading path
# for the generation of the #ifndef in the generated header file
canonize-names-cmd.c: canonize-names-cmd.ggo
	$(NEW_GENGETOPT) \
		--input $(srcdir)/canonize-names-cmd.ggo \
		--func-name $*-parser \
		--file-name $(top_builddir)/tests/$*

cmdline.c: cmdline.ggo
	$(NEW_GENGETOPT) --input $(srcdir)/cmdline.ggo
cmdline.h: cmdline.c
	@if test -f $@; then :; else \
		rm -f -- $<; \
		$(MAKE) $(AM_MAKEFLAGS) $<; \
	fi

TESTSOUT = test.out
TESTSOUTPUT = test.output

ERRFILES = \
	wrong_ggo/wrong_default.err \
	wrong_ggo/wrong_dep.err \
	wrong_ggo/wrong_enum_use.err \
	wrong_ggo/wrong_flag.err \
	wrong_ggo/wrong_flag2.err \
	wrong_ggo/wrong_group.err \
	wrong_ggo/wrong_group2.err \
	wrong_ggo/wrong_help_redef.err \
	wrong_ggo/wrong_multiple_occurrence.err \
	wrong_ggo/wrong_numeric_value.err \
	wrong_ggo/wrong_version_redef.err
ERRGGOFILES = \
	wrong_ggo/wrong_default.ggo \
	wrong_ggo/wrong_dep.ggo \
	wrong_ggo/wrong_enum_use.ggo \
	wrong_ggo/wrong_flag.ggo \
	wrong_ggo/wrong_flag2.ggo \
	wrong_ggo/wrong_group.ggo \
	wrong_ggo/wrong_group2.ggo \
	wrong_ggo/wrong_help_redef.ggo \
	wrong_ggo/wrong_multiple_occurrence.ggo \
	wrong_ggo/wrong_numeric_value.ggo \
	wrong_ggo/wrong_version_redef.ggo

gengetoptexamples_DATA = \
	test_manual_help.c \
	test_manual_help_cmd.c \
	test_manual_help_cmd.ggo \
	test_manual_help_cmd.h

EXTRA_DIST = \
	$(ERRFILES) \
	$(ERRGGOFILES) \
	$(TESTSOUTPUT) \
	$(gengetoptexamples_DATA) \
	more_than_once.sh.in \
	no_optgiven.sh.in \
	test_align_cmd.ggo \
	test_all_opts.sh.in \
	test_all_opts_file_save.sh.in \
	test_conf.conf.in \
	test_conf2.conf \
	test_conf3.conf \
	test_conf_err.conf \
	test_conf_err_string.conf \
	test_conf_err_string2.conf \
	test_conf_inc.conf.in \
	test_conf_inc2.conf \
	test_conf_inc_inc.conf \
	test_conf_parser.sh.in \
	test_conf_parser_err.sh.in \
	test_conf_parser_err_string.sh.in \
	test_conf_parser_grp.sh.in \
	test_conf_parser_ov.sh.in \
	test_conf_parser_ov2.c.in \
	test_conf_parser_ov2.sh.in \
	test_conf_parser_ov3.c.in \
	test_conf_parser_ov3.sh.in \
	test_conf_parser_ov4.c.in \
	test_conf_parser_ov4.sh.in \
	test_conf_parser_save.sh.in \
	test_default_values.sh.in \
	test_dep.sh.in \
	test_groups.sh.in \
	test_manual_help.sh.in \
	test_manual_help_args.sh.in \
	test_manual_help_args_cmd.ggo \
	test_modes.sh.in \
	test_multiple.sh.in \
	test_multiple_err.sh.in \
	test_multiple_parsers.sh.in \
	test_required_optional_cmd.ggo \
	test_section_with_all_hidden.ggo \
	test_sections.sh.in \
	test_show_help.sh.in \
	test_simple_multiple.sh.in \
	test_simple_multiple_default.sh.in \
	test_unamed.sh.in \
	test_unnamed.sh.in \
	test_values.sh.in \
	test_values_err.sh.in \
	valgrind_tests.sh.in

check-valgrind:
	./valgrind_tests.sh $(VALGRINDTESTS)

clean-local:
	rm -rf output_dir
	rm -rf output_dirs

CLEANFILES = \
	*-cmd.c \
	*-cmd.h \
	*.err.out \
	*.save \
	*_cmd.c \
	*_cmd.h \
	cmdline.c \
	cmdline.h

endif
