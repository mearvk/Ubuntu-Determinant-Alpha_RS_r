subdir('xml')

private_headers = [
  'gtk-clutter-actor-internal.h',
  'gtk-clutter-offscreen.h',
]

glib_prefix = dependency('glib-2.0').get_pkgconfig_variable('prefix')
glib_docpath = join_paths(glib_prefix, 'share', 'gtk-doc', 'html')
gtk_prefix = dependency('gtk+-3.0').get_pkgconfig_variable('prefix')
gtk_docpath = join_paths(gtk_prefix, 'share', 'gtk-doc', 'html')
clutter_prefix = dependency('clutter-1.0').get_pkgconfig_variable('prefix')
clutter_docpath = join_paths(clutter_prefix, 'share', 'gtk-doc', 'html')

docpath = join_paths(gtk_clutter_datadir, 'gtk-doc', 'html')

gnome.gtkdoc(gtk_clutter_api_name,
             main_xml: '@0@-docs.xml'.format(gtk_clutter_api_name),
             src_dir: [
               join_paths(meson.source_root(), 'clutter-gtk'),
               join_paths(meson.build_root(), 'clutter-gtk'),
             ],
             dependencies: clutter_gtk_dep,
             gobject_typesfile: gtk_clutter_api_name + '.types',
             scan_args: [
               '--rebuild-types',
               '--ignore-decorators=CLUTTER_GTK_EXTERN',
               '--ignore-headers=' + ' '.join(private_headers),
             ],
             fixxref_args: [
               '--html-dir=@0@'.format(docpath),
               '--extra-dir=@0@'.format(join_paths(glib_docpath, 'glib')),
               '--extra-dir=@0@'.format(join_paths(glib_docpath, 'gobject')),
               '--extra-dir=@0@'.format(join_paths(glib_docpath, 'gio')),
               '--extra-dir=@0@'.format(join_paths(gtk_docpath, 'gtk3')),
               '--extra-dir=@0@'.format(join_paths(gtk_docpath, 'gdk3')),
               '--extra-dir=@0@'.format(join_paths(clutter_docpath, 'clutter-1.0')),
             ],
             install: true)

