include $(top_srcdir)/build/autotools/Makefile.am.silent

NULL =

noinst_PROGRAMS = \
	gtk-clutter-events \
	gtk-clutter-multistage \
	gtk-clutter-test \
	gtk-clutter-test-actor \
	gtk-clutter-window-test

AM_CPPFLAGS = \
	-I$(srcdir) -I$(top_srcdir) -I$(top_builddir)/clutter-gtk \
	-DGLIB_DISABLE_DEPRECATION_WARNINGS \
	-DGDK_DISABLE_DEPRECATION_WARNINGS \
	-DCLUTTER_DISABLE_DEPRECATION_WARNINGS \
	-DEXAMPLES_DATADIR=\"$(srcdir)\"
AM_CFLAGS = $(MAINTAINER_CFLAGS) $(CLUTTER_GTK_DEPS_CFLAGS)

common_deps = \
	$(top_builddir)/clutter-gtk/libclutter-gtk-@CLUTTER_GTK_API_VERSION@.la

common_ldadd = \
	$(top_builddir)/clutter-gtk/libclutter-gtk-@CLUTTER_GTK_API_VERSION@.la \
	$(CLUTTER_GTK_DEPS_LIBS) \
	$(LIBM)

LDADD = $(common_ldadd)

EXTRA_DIST = \
	redhand.png
