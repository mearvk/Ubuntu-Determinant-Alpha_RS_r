pkgconfigdir = $(libdir)/pkgconfig
pkgconfig_DATA = clutter-imcontext-$(CLUTTER_IMCONTEXT_API_VERSION).pc

clutter-imcontext-$(CLUTTER_IMCONTEXT_API_VERSION).pc: clutter-imcontext.pc
	$(QUIET_GEN)cp $< $@

pcfiles = clutter-imcontext-$(CLUTTER_IMCONTEXT_API_VERSION).pc \
		clutter-imcontext.pc

#library_include_HEADERS = clutter-imcontext.h

#Tell library where data directory is (/usr/share/clutter-imcontext)
AM_CFLAGS = -DPKGDATADIR="\"$(pkgdatadir)\""

INCLUDES = \
	-DCLUTTER_IMCONTEXT_SYSCONFDIR=\"$(sysconfdir)\"	\
	-DCLUTTER_IMCONTEXT_LIBDIR=\"$(libdir)\"		\
	$(CLUTTER_CFLAGS)

MARSHALFILES = clutter-imcontext-marshal.c clutter-imcontext-marshal.h
STAMP_FILES = stamp-clutter-imcontext-marshal.h

BUILT_SOURCES = \
	$(MARSHALFILES)

clutter-imcontext-marshal.h: stamp-clutter-imcontext-marshal.h
	@true
stamp-clutter-imcontext-marshal.h: Makefile clutter-imcontext-marshal.list
	$(GLIB_GENMARSHAL) \
		--prefix=clutter_imcontext_marshal \
		--header \
	$(srcdir)/clutter-imcontext-marshal.list > xgen-tmh && \
	(cmp -s xgen-tmh clutter-imcontext-marshal.h || cp -f xgen-tmh clutter-imcontext-marshal.h) && \
	rm -f xgen-tmh && \
	echo timestamp > $(@F)

clutter-imcontext-marshal.c: Makefile clutter-imcontext-marshal.list
	(echo "#include \"clutter-imcontext-marshal.h\"" ; \
	 $(GLIB_GENMARSHAL) \
		--prefix=clutter_imcontext_marshal \
		--body \
	 $(srcdir)/clutter-imcontext-marshal.list ) > xgen-tmc && \
	cp -f xgen-tmc clutter-imcontext-marshal.c && \
	rm -f xgen-tmc

lib_LTLIBRARIES = libclutter-imcontext-@CLUTTER_IMCONTEXT_API_VERSION@.la

clutter_imcontext_source_c = \
		clutter-imcontext.c \
		clutter-imcontext-marshal.c \
		clutter-imcontext-private.c \
		clutter-imcontextsimple.c \
		clutter-immodule.c \
		clutter-immulticontext.c \
		clutter-imtext.c

clutter_imcontext_source_h = \
		clutter-imcontext.h \
		clutter-imcontext-marshal.h \
		clutter-imcontextsimple.h \
		clutter-immodule.h \
		clutter-immulticontext.h \
		clutter-imtext.h

clutter_imcontext_source_h_priv = \
		clutter-imcontext-private.h

clutterimcontext_includedir=$(includedir)/clutter-imcontext-$(CLUTTER_IMCONTEXT_API_VERSION)/clutter-imcontext
clutterimcontext_include_DATA=$(clutter_imcontext_source_h)

libclutter_imcontext_@CLUTTER_IMCONTEXT_API_VERSION@_la_SOURCES = \
		$(clutter_imcontext_source_c) \
		$(clutter_imcontext_source_h) \
		$(clutter_imcontext_source_h_priv)

libclutter_imcontext_@CLUTTER_IMCONTEXT_API_VERSION@_la_LIBADD = $(CLUTTER_LIBS)
libclutter_imcontext_@CLUTTER_IMCONTEXT_API_VERSION@_la_LDFLAGS= -no-undefined

DISTCLEANFILES = \
        $(MARSHALFILES)

CLEANFILES = *~ $(pcfiles) $(STAMP_FILES) $(BUILT_SOURCES)

EXTRA_DIST = \
        clutter-imcontext-marshal.list
