noinst_PROGRAMS = \
        test-imtext

INCLUDES = -I$(top_srcdir)
LDADD = $(top_builddir)/clutter-imcontext/libclutter-imcontext-@CLUTTER_IMCONTEXT_API_VERSION@.la

AM_CFLAGS = $(CLUTTER_CFLAGS)
AM_LDFLAGS = $(CLUTTER_LIBS)

test_imtext_SOURCES = test-imtext.c
