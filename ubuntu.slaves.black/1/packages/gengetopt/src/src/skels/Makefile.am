# Copyright (C) 1999-2008 Free Software Foundation, Inc.
#
# This file is free software; as a special exception the author gives
# unlimited permission to copy and/or distribute it, with or without
# modifications, as long as this notice is preserved.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY, to the extent permitted by law; without even the
# implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

skels = \
	c_source.h_skel \
	check_modes.h_skel \
	clear_arg.h_skel \
	clear_given.h_skel \
	copyright.h_skel \
	custom_getopt_gen.h_skel \
	dependant_option.h_skel \
	enum_decl.h_skel \
	exit_failure.h_skel \
	file_save.h_skel \
	file_save_multiple.h_skel \
	free_list.h_skel \
	free_multiple.h_skel \
	free_string.h_skel \
	generic_option.h_skel \
	given_field.h_skel \
	group_counter.h_skel \
	group_option.h_skel \
	handle_help.h_skel \
	handle_version.h_skel \
	header.h_skel \
	init_args_info.h_skel \
	multiple_fill_array.h_skel \
	multiple_opt_list.h_skel \
	option_arg.h_skel \
	print_help_string.h_skel \
	required_option.h_skel \
	reset_group.h_skel \
	update_given.h_skel

h_gens = $(skels:.h_skel=.h)
c_gens = $(skels:.h_skel=.cc)

.h_skel.cc:
	$(GENGEN) -i $< -F $(@:.cc=.h) -f $(@:.cc=) \
		--separate-files --expand-tabs --force

.cc.h:
	@if test -f $@; then :; else \
		rm -f -- $<; \
		$(MAKE) $(AM_MAKEFLAGS) $<; \
	fi

noinst_LTLIBRARIES = libgen.la

libgen_la_SOURCES = $(BUILT_SOURCES)

BUILT_SOURCES = $(h_gens) $(c_gens)
EXTRA_DIST = $(skels) $(BUILT_SOURCES)

built-clean:
	cd @srcdir@ && rm -f $(BUILT_SOURCES)
