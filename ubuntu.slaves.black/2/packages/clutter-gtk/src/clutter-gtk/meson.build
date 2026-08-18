clutter_gtk_sources = [
  'gtk-clutter-actor.c',
  'gtk-clutter-embed.c',
  'gtk-clutter-offscreen.c',
  'gtk-clutter-texture.c',
  'gtk-clutter-util.c',
  'gtk-clutter-window.c',
]

clutter_gtk_headers = [
  'clutter-gtk.h',

  'gtk-clutter-actor.h',
  'gtk-clutter-embed.h',
  'gtk-clutter-texture.h',
  'gtk-clutter-util.h',
  'gtk-clutter-window.h',
]

install_headers(clutter_gtk_headers, subdir: gtk_clutter_api_path)

gtk_clutter_version_conf = configuration_data()
gtk_clutter_version_conf.set('CLUTTER_GTK_MAJOR_VERSION', gtk_clutter_major_version)
gtk_clutter_version_conf.set('CLUTTER_GTK_MINOR_VERSION', gtk_clutter_minor_version)
gtk_clutter_version_conf.set('CLUTTER_GTK_MICRO_VERSION', gtk_clutter_micro_version)
gtk_clutter_version_conf.set('CLUTTER_GTK_VERSION', meson.project_version())
configure_file(input: 'gtk-clutter-version.h.in',
               output: 'gtk-clutter-version.h',
               configuration: gtk_clutter_version_conf,
               install: true,
               install_dir: join_paths(gtk_clutter_includedir, gtk_clutter_api_path))

clutter_gtk = shared_library(gtk_clutter_api_name, clutter_gtk_sources,
                             soversion: soversion,
                             version: libversion,
                             dependencies: [ mathlib_dep, clutter_dep, gtk_dep ],
                             include_directories: root_inc,
                             c_args: common_cflags + gtk_clutter_debug_cflags + [
                               '-DPREFIX="@0@"'.format(gtk_clutter_prefix),
                               '-DLIBDIR="@0@"'.format(gtk_clutter_libdir),
                               '-DG_LOG_DOMAIN="Clutter-Gtk"',
                               '-DG_LOG_USE_STRUCTURED=1',
                               '-DCLUTTER_GTK_COMPILATION',
                             ],
                             link_args: common_ldflags,
                             install: true)

clutter_gtk_dep = declare_dependency(link_with: clutter_gtk,
                                     dependencies: [ mathlib_dep, clutter_dep, gtk_dep ],
                                     include_directories: include_directories('.'))

if not meson.is_cross_build()
  gnome.generate_gir(clutter_gtk,
                     sources: clutter_gtk_headers + clutter_gtk_sources,
                     namespace: 'GtkClutter',
                     nsversion: gtk_clutter_api_version,
                     identifier_prefix: 'GtkClutter',
                     symbol_prefix: 'gtk_clutter',
                     export_packages: gtk_clutter_api_name,
                     includes: [ 'Clutter-1.0', 'Gtk-3.0' ],
                     install: true,
                     extra_args: [
                       '--quiet',
                       '--c-include=clutter-gtk/clutter-gtk.h',
                       '-DCLUTTER_GTK_COMPILATION',
                     ])
endif
