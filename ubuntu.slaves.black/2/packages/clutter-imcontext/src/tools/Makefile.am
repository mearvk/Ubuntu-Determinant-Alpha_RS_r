AM_CFLAGS = @CLUTTER_CFLAGS@
AM_LDFLAGS = @CLUTTER_LIBS@

INCLUDES = -I$(top_srcdir)
bin_PROGRAMS = \
	clutter-scan-immodules

clutter_scan_immodules_SOURCES = scan-immodules.c
clutter_scan_immodules_LDADD = $(top_builddir)/clutter-imcontext/libclutter-imcontext-@CLUTTER_IMCONTEXT_API_VERSION@.la
