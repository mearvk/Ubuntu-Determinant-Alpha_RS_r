private_headers = [
  'config.h',
  'clutter.h',

  'clutter-actor-meta-private.h',
  'clutter-actor-private.h',
  'clutter-backend-private.h',
  'clutter-bezier.h',
  'clutter-cogl-compat.h',
  'clutter-color-static.h',
  'clutter-config.h',
  'clutter-constraint-private.h',
  'clutter-debug.h',
  'clutter-deprecated.h ',
  'clutter-device-manager-private.h',
  'clutter-easing.h',
  'clutter-enum-types.h ',
  'clutter-event-translator.h',
  'clutter-flatten-effect.h',
  'clutter-gesture-action-private.h',
  'clutter-id-pool.h',
  'clutter-keysyms.h',
  'clutter-keysyms-compat.h',
  'clutter-keysyms-table.h',
  'clutter-marshal.h',
  'clutter-master-clock-default.h',
  'clutter-master-clock.h',
  'clutter-model-private.h',
  'clutter-paint-node-private.h',
  'clutter-paint-volume-private.h',
  'clutter-private.h',
  'clutter-script-private.h',
  'clutter-settings-private.h',
  'clutter-stage-manager-private.h',
  'clutter-stage-private.h',
  'clutter-stage-window.h',
  'clutter-timeout-interval.h',

  # Cally
  'cally-actor-private.h',

  # No public symbols
  'tslib',
  'cogl',
]

doc_dirs = [
  clutter_inc,
]

# Backend headers
if enabled_backends.contains('cex100')
  private_headers += [
    'clutter-backend-cex100.h',
  ]
else
  private_headers += 'cex100'
endif

if enabled_backends.contains('eglnative')
  private_headers += [
    'clutter-backend-eglnative.h',
    'clutter-egl-headers.h',
    'clutter-stage-eglnative.h',
  ]
else
  private_headers += 'egl'
endif

if enabled_input_backends.contains('evdev')
  private_headers += [
    'clutter-device-manager-evdev.h',
    'clutter-input-device-evdev.h',
    'clutter-xkb-utils.h',
  ]
else
  private_headers += 'evdev'
endif

if enabled_backends.contains('gdk')
  private_headers += [
    'clutter-backend-gdk.h',
    'clutter-backend-gk-private.h',
    'clutter-device-manager-gdk.h',
    'clutter-event-gdk.h',
    'clutter-input-device-gdk.h',
    'clutter-master-clock-gdk.h',
    'clutter-settings-gdk.h',
    'clutter-stage-gdk.h',
  ]
else
  private_headers += 'gdk'
endif

if enabled_backends.contains('mir')
  private_headers += [
    'clutter-backend-mir.h',
    'clutter-backend-mir-priv.h',
    'clutter-device-manager-mir.h',
    'clutter-event-mir.h',
    'clutter-input-device-mir.h',
    'clutter-stage-mir.h',
  ]
else
  private_headers += 'mir'
endif

if enabled_backends.contains('osx')
  private_headers += [
    'clutter-backend-osx.h',
    'clutter-device-manager-osx.h',
    'clutter-event-loop-osx.h',
    'clutter-stage-osx.h',
  ]
else
  private_headers += 'osx'
endif

if enabled_backends.contains('wayland')
  private_headers += [
    'clutter-backend-wayland.h',
    'clutter-backend-wayland-priv.h',
    'clutter-device-manager-wayland.h',
    'clutter-event-wayland.h',
    'clutter-input-device-wayland.h',
    'clutter-stage-wayland.h',
  ]
else
  private_headers += 'wayland'
endif

if enabled_backends.contains('win32')
  private_headers += [
    'clutter-backend-win32.h',
    'clutter-device-manager-win32.h',
    'clutter-event-win32.h',
    'clutter-stage-win32.h',
  ]
else
  private_headers += 'win32'
endif

if enabled_backends.contains('x11')
  private_headers += [
    'clutter-backend-x11.h',
    'clutter-device-manager-core-x11.h',
    'clutter-device-manager-xi2.h',
    'clutter-input-device-core-x11.h',
    'clutter-input-device-xi2.h',
    'clutter-keymap-x11.h',
    'clutter-settings-x11.h',
    'clutter-stage-x11.h',
    'xsettings',
  ]
else
  private_headers += [ 'x11', 'xsettings' ]
endif

images = [
  'actor-box.png',
  'actor-example.png',
  'animator-key-frames.png',
  'bin-layout.png',
  'box-layout.png',
  'constraints-example.png',
  'easing-modes.png',
  'event-flow.png',
  'flow-layout.png',
  'path-alpha-func.png',
  'offscreen-redirect.png',
  'table-layout.png',
]

content_files = [
  'glossary.xml',
  'clutter-overview.xml',
  'building-clutter.xml',
  'running-clutter.xml',
  'migrating-ClutterAnimation.xml',
  'migrating-ClutterBehaviour.xml',
  'migrating-ClutterEffect.xml',
  'migrating-ClutterPath.xml',
]

expand_content_files = [
  'glossary.xml',
  'clutter-overview.xml',
  'building-clutter.xml',
  'running-clutter.xml',
  'migrating-ClutterAnimation.xml',
  'migrating-ClutterBehaviour.xml',
  'migrating-ClutterEffect.xml',
  'migrating-ClutterPath.xml',
]

docpath = join_paths(get_option('prefix'), get_option('datadir'), 'gtk-doc', 'html')

glib_prefix = dependency('glib-2.0').get_pkgconfig_variable('prefix')
glib_docpath = join_paths(glib_prefix, 'share', 'gtk-doc', 'html')

cairo_prefix = dependency('cairo').get_pkgconfig_variable('prefix')
cairo_docpath = join_paths(cairo_prefix, 'share', 'gtk-doc', 'html', 'cairo')

cogl_prefix = dependency('cogl-1.0').get_pkgconfig_variable('prefix')
cogl_docpath = join_paths(cogl_prefix, 'share', 'gtk-doc', 'html', 'cogl')

pango_prefix = dependency('pango').get_pkgconfig_variable('prefix')
pango_docpath = join_paths(cogl_prefix, 'share', 'gtk-doc', 'html', 'pango')

gdk_prefix = dependency('gdk-3.0').get_pkgconfig_variable('prefix')
gdk_docpath = join_paths(cogl_prefix, 'share', 'gtk-doc', 'html', 'gdk3')

atk_prefix = dependency('atk').get_pkgconfig_variable('prefix')
atk_docpath = join_paths(cogl_prefix, 'share', 'gtk-doc', 'html', 'atk')

subdir('xml')

gnome.gtkdoc('clutter',
  main_xml: 'clutter-docs.xml',
  mode: 'xml',
  namespace: 'clutter',
  src_dir: doc_dirs,
  dependencies: libclutter_dep,
  gobject_typesfile: join_paths(meson.current_source_dir(), 'clutter.types'),
  scan_args: [
    '--ignore-decorators=_CLUTTER_EXTERN',
    '--ignore-headers=' + ' '.join(private_headers),
  ],
  fixxref_args: [
    '--html-dir=@0@'.format(docpath),
    '--extra-dir=@0@'.format(join_paths(glib_docpath, 'glib')),
    '--extra-dir=@0@'.format(join_paths(glib_docpath, 'gobject')),
    '--extra-dir=@0@'.format(join_paths(glib_docpath, 'gio')),
    '--extra-dir=@0@'.format(cairo_docpath),
    '--extra-dir=@0@'.format(cogl_docpath),
    '--extra-dir=@0@'.format(pango_docpath),
    '--extra-dir=@0@'.format(gdk_docpath),
    '--extra-dir=@0@'.format(atk_docpath),
  ],
  content_files: content_files,
  expand_content_files: expand_content_files,
  html_assets: images,
  install: true,
)
