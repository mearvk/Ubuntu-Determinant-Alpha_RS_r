include $(top_srcdir)/build/autotools/Makefile.am.silent

NULL =

CLEANFILES =
DISTCLEANFILES =
EXTRA_DIST =


AM_CPPFLAGS = \
	-I$(top_srcdir) -I$(top_builddir) \
	-DG_LOG_DOMAIN=\"Clutter-Gtk\" 		\
	-DPREFIX=\""$(prefix)"\" 		\
	-DLIBDIR=\""$(libdir)"\"		\
	-DCLUTTER_GTK_COMPILATION		\
	$(CLUTTER_GTK_HIDDEN_VISIBILITY_CFLAGS)	\
	$(CLUTTER_GTK_DEPRECATED_CFLAGS)	\
	$(CLUTTER_GTK_DEBUG_CFLAGS) 		\
	$(NULL)

AM_CFLAGS = $(MAINTAINER_CFLAGS) $(CLUTTER_GTK_DEPS_CFLAGS)

lib_LTLIBRARIES = libclutter-gtk-@CLUTTER_GTK_API_VERSION@.la

source_c = \
	gtk-clutter-actor.c 	\
	gtk-clutter-embed.c 	\
	gtk-clutter-offscreen.c	\
	gtk-clutter-texture.c	\
	gtk-clutter-util.c 	\
	gtk-clutter-window.c	\
	$()

source_h_public = \
	gtk-clutter-actor.h 	\
	gtk-clutter-embed.h 	\
	gtk-clutter-texture.h	\
	gtk-clutter-util.h 	\
	gtk-clutter-window.h	\
	$()

source_h_private = \
	gtk-clutter-offscreen.h		\
	gtk-clutter-actor-internal.h	\
	$()

# please, keep the list sorted alphabetically
libclutter_gtk_@CLUTTER_GTK_API_VERSION@_la_SOURCES = $(source_c) $(source_h) $(source_h_private)
libclutter_gtk_@CLUTTER_GTK_API_VERSION@_la_LIBADD  = $(CLUTTER_GTK_DEPS_LIBS) $(LIBM)
libclutter_gtk_@CLUTTER_GTK_API_VERSION@_la_LDFLAGS = $(CLUTTER_GTK_LT_LDFLAGS)

cluttergtkheadersdir = $(includedir)/clutter-gtk-@CLUTTER_GTK_API_VERSION@/clutter-gtk

# please, keep the list sorted alphabetically
cluttergtkheaders_HEADERS = \
	clutter-gtk.h 		\
	gtk-clutter-version.h	\
	$(source_h_public)	\
	$(NULL)

EXTRA_DIST += gtk-clutter-version.h.in

-include $(INTROSPECTION_MAKEFILE)

INTROSPECTION_GIRS =

if HAVE_INTROSPECTION
GtkClutter-@CLUTTER_GTK_API_VERSION@.gir: libclutter-gtk-@CLUTTER_GTK_API_VERSION@.la Makefile

GtkClutter_@CLUTTER_GTK_API_VERSION_AM@_gir_SCANNERFLAGS = \
	--identifier-prefix=GtkClutter \
	--warn-all \
	--pkg-export clutter-gtk-@CLUTTER_GTK_API_VERSION@ \
	--c-include='clutter-gtk/clutter-gtk.h'
GtkClutter_@CLUTTER_GTK_API_VERSION_AM@_gir_NAMESPACE    = GtkClutter
GtkClutter_@CLUTTER_GTK_API_VERSION_AM@_gir_VERSION      = 1.0
GtkClutter_@CLUTTER_GTK_API_VERSION_AM@_gir_INCLUDES     = Gtk-3.0 Clutter-1.0
GtkClutter_@CLUTTER_GTK_API_VERSION_AM@_gir_PACKAGES     = gtk+-3.0 clutter-1.0
GtkClutter_@CLUTTER_GTK_API_VERSION_AM@_gir_CFLAGS       = $(INCLUDES) $(AM_CPPFLAGS)
GtkClutter_@CLUTTER_GTK_API_VERSION_AM@_gir_LIBS         = libclutter-gtk-@CLUTTER_GTK_API_VERSION@.la
GtkClutter_@CLUTTER_GTK_API_VERSION_AM@_gir_FILES        = $(source_h_public) $(source_c)

INTROSPECTION_GIRS += GtkClutter-@CLUTTER_GTK_API_VERSION@.gir

girdir = $(datadir)/gir-1.0/
gir_DATA = $(INTROSPECTION_GIRS)

typelibsdir = $(libdir)/girepository-1.0/
typelibs_DATA = $(INTROSPECTION_GIRS:.gir=.typelib)

CLEANFILES += $(gir_DATA) $(typelibs_DATA)
endif # HAVE_INTROSPECTION
