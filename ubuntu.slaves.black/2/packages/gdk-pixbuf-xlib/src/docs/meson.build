version_xml = configuration_data()
version_xml.set('GDK_PIXBUF_VERSION', meson.project_version())
configure_file(
  input: 'version.xml.in',
  output: 'version.xml',
  configuration: version_xml,
)

glib_prefix = dependency('glib-2.0').get_pkgconfig_variable('prefix')
glib_docpath = glib_prefix / 'share' / 'gtk-doc' / 'html'
gdk_pixbuf_prefix = dependency('gdk-pixbuf-2.0').get_pkgconfig_variable('prefix')
gdk_pixbuf_docpath = gdk_pixbuf_prefix / 'share' / 'gtk-doc' / 'html'

docpath = datadir / 'gtk-doc' / 'html'

private_headers = [
  'gdk-pixbuf-xlib-private.h',
]

if get_option('gtk_doc')
  gnome.gtkdoc('gdk-pixbuf-xlib',
    main_xml: 'gdk-pixbuf-xlib-docs.xml',
    src_dir: gdkpixbuf_xlib_inc,
    dependencies: gdkpixbuf_xlib_dep,
    scan_args: [
      '--deprecated-guards="GDK_PIXBUF_ENABLE_BROKEN|GDK_PIXBUF_DISABLE_DEPRECATED"',
      '--ignore-headers=' + ' '.join(private_headers),
    ],
    fixxref_args: [
      '--html-dir=@0@'.format(docpath),
      '--extra-dir=@0@'.format(join_paths(glib_docpath, 'glib')),
      '--extra-dir=@0@'.format(join_paths(glib_docpath, 'gobject')),
      '--extra-dir=@0@'.format(join_paths(glib_docpath, 'gio')),
      '--extra-dir=@0@'.format(join_paths(gdk_pixbuf_docpath, 'gdk-pixbuf')),
    ],
    install: true,
  )
endif
