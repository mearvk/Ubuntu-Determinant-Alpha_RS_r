clutter_full_includedir = join_paths(clutter_includedir, clutter_api_name, 'clutter')

common_c_args = [
  '-DCLUTTER_PREFIX="@0@"'.format(clutter_prefix),
  '-DCLUTTER_LIBDIR="@0@"'.format(clutter_libdir),
  '-DCLUTTER_DATADIR="@0@"'.format(clutter_datadir),
  '-DCLUTTER_LOCALEDIR="@0@"'.format(clutter_localedir),
  '-DCLUTTER_SYSCONFDIR="@0@"'.format(clutter_sysconfdir),
  '-DCLUTTER_COMPILATION=1',
  '-DCOGL_ENABLE_EXPERIMENTAL_API',
  '-DCOGL_DISABLE_DEPRECATION_WARNINGS',
  '-DG_LOG_DOMAIN="Clutter"',
  '-DG_LOG_USE_STRUCTURED=1',
]

clutter_public_headers = [
  'clutter.h',

  'clutter-action.h',
  'clutter-actor-meta.h',
  'clutter-actor.h',
  'clutter-align-constraint.h',
  'clutter-animatable.h',
  'clutter-backend.h',
  'clutter-bind-constraint.h',
  'clutter-binding-pool.h',
  'clutter-bin-layout.h',
  'clutter-blur-effect.h',
  'clutter-box-layout.h',
  'clutter-brightness-contrast-effect.h',
  'clutter-cairo.h',
  'clutter-canvas.h',
  'clutter-child-meta.h',
  'clutter-click-action.h',
  'clutter-cogl-compat.h',
  'clutter-clone.h',
  'clutter-color-static.h',
  'clutter-color.h',
  'clutter-colorize-effect.h',
  'clutter-constraint.h',
  'clutter-container.h',
  'clutter-content.h',
  'clutter-deform-effect.h',
  'clutter-deprecated.h',
  'clutter-desaturate-effect.h',
  'clutter-device-manager.h',
  'clutter-drag-action.h',
  'clutter-drop-action.h',
  'clutter-effect.h',
  'clutter-enums.h',
  'clutter-event.h',
  'clutter-feature.h',
  'clutter-fixed-layout.h',
  'clutter-flow-layout.h',
  'clutter-gesture-action.h',
  'clutter-grid-layout.h',
  'clutter-group.h',
  'clutter-image.h',
  'clutter-input-device.h',
  'clutter-interval.h',
  'clutter-keyframe-transition.h',
  'clutter-keysyms.h',
  'clutter-layout-manager.h',
  'clutter-layout-meta.h',
  'clutter-macros.h',
  'clutter-main.h',
  'clutter-offscreen-effect.h',
  'clutter-page-turn-effect.h',
  'clutter-paint-nodes.h',
  'clutter-paint-node.h',
  'clutter-pan-action.h',
  'clutter-path-constraint.h',
  'clutter-path.h',
  'clutter-property-transition.h',
  'clutter-rotate-action.h',
  'clutter-script.h',
  'clutter-scriptable.h',
  'clutter-scroll-actor.h',
  'clutter-settings.h',
  'clutter-shader-effect.h',
  'clutter-shader-types.h',
  'clutter-swipe-action.h',
  'clutter-snap-constraint.h',
  'clutter-stage.h',
  'clutter-stage-manager.h',
  'clutter-tap-action.h',
  'clutter-test-utils.h',
  'clutter-texture.h',
  'clutter-text.h',
  'clutter-text-buffer.h',
  'clutter-timeline.h',
  'clutter-transition-group.h',
  'clutter-transition.h',
  'clutter-types.h',
  'clutter-units.h',
  'clutter-zoom-action.h',
]

install_headers(
  clutter_public_headers + [
    'clutter-autocleanups.h',
  ],
  install_dir: clutter_full_includedir,
)

sources = [
  'clutter-action.c',
  'clutter-actor-box.c',
  'clutter-actor-meta.c',
  'clutter-actor.c',
  'clutter-align-constraint.c',
  'clutter-animatable.c',
  'clutter-backend.c',
  'clutter-base-types.c',
  'clutter-bezier.c',
  'clutter-bind-constraint.c',
  'clutter-binding-pool.c',
  'clutter-bin-layout.c',
  'clutter-blur-effect.c',
  'clutter-box-layout.c',
  'clutter-brightness-contrast-effect.c',
  'clutter-cairo.c',
  'clutter-canvas.c',
  'clutter-child-meta.c',
  'clutter-click-action.c',
  'clutter-clone.c',
  'clutter-color.c',
  'clutter-colorize-effect.c',
  'clutter-constraint.c',
  'clutter-container.c',
  'clutter-content.c',
  'clutter-deform-effect.c',
  'clutter-desaturate-effect.c',
  'clutter-device-manager.c',
  'clutter-drag-action.c',
  'clutter-drop-action.c',
  'clutter-effect.c',
  'clutter-event.c',
  'clutter-feature.c',
  'clutter-fixed-layout.c',
  'clutter-flatten-effect.c',
  'clutter-flow-layout.c',
  'clutter-gesture-action.c',
  'clutter-grid-layout.c',
  'clutter-image.c',
  'clutter-input-device.c',
  'clutter-interval.c',
  'clutter-keyframe-transition.c',
  'clutter-keysyms-table.c',
  'clutter-layout-manager.c',
  'clutter-layout-meta.c',
  'clutter-main.c',
  'clutter-master-clock.c',
  'clutter-master-clock-default.c',
  'clutter-offscreen-effect.c',
  'clutter-page-turn-effect.c',
  'clutter-paint-nodes.c',
  'clutter-paint-node.c',
  'clutter-pan-action.c',
  'clutter-path-constraint.c',
  'clutter-path.c',
  'clutter-property-transition.c',
  'clutter-rotate-action.c',
  'clutter-script.c',
  'clutter-script-parser.c',
  'clutter-scriptable.c',
  'clutter-scroll-actor.c',
  'clutter-settings.c',
  'clutter-shader-effect.c',
  'clutter-shader-types.c',
  'clutter-swipe-action.c',
  'clutter-snap-constraint.c',
  'clutter-stage.c',
  'clutter-stage-manager.c',
  'clutter-stage-window.c',
  'clutter-tap-action.c',
  'clutter-test-utils.c',
  'clutter-text.c',
  'clutter-text-buffer.c',
  'clutter-transition-group.c',
  'clutter-transition.c',
  'clutter-timeline.c',
  'clutter-units.c',
  'clutter-util.c',
  'clutter-paint-volume.c',
  'clutter-zoom-action.c',
]

private_sources = [
  'clutter-easing.c',
  'clutter-event-translator.c',
  'clutter-id-pool.c',
]

cally_headers = [
  'cally/cally.h',

  'cally/cally-actor.h',
  'cally/cally-clone.h',
  'cally/cally-factory.h',
  'cally/cally-group.h',
  'cally/cally-main.h',
  'cally/cally-rectangle.h',
  'cally/cally-root.h',
  'cally/cally-stage.h',
  'cally/cally-text.h',
  'cally/cally-texture.h',
  'cally/cally-util.h',
]

cally_sources = [
  'cally/cally-actor.c',
  'cally/cally-clone.c',
  'cally/cally-group.c',
  'cally/cally-rectangle.c',
  'cally/cally-root.c',
  'cally/cally-stage.c',
  'cally/cally-text.c',
  'cally/cally-texture.c',
  'cally/cally-util.c',
  'cally/cally.c',
]

install_headers(
  cally_headers,
  # The root namespace is different for Cally
  install_dir: join_paths(clutter_includedir, clutter_api_name, 'cally'),
)

clutter_deprecated_headers = [
  'deprecated/clutter-actor.h',
  'deprecated/clutter-alpha.h',
  'deprecated/clutter-animatable.h',
  'deprecated/clutter-animation.h',
  'deprecated/clutter-animator.h',
  'deprecated/clutter-backend.h',
  'deprecated/clutter-behaviour.h',
  'deprecated/clutter-behaviour-depth.h',
  'deprecated/clutter-behaviour-ellipse.h',
  'deprecated/clutter-behaviour-opacity.h',
  'deprecated/clutter-behaviour-path.h',
  'deprecated/clutter-behaviour-rotate.h',
  'deprecated/clutter-behaviour-scale.h',
  'deprecated/clutter-bin-layout.h',
  'deprecated/clutter-box.h',
  'deprecated/clutter-cairo-texture.h',
  'deprecated/clutter-container.h',
  'deprecated/clutter-fixed.h',
  'deprecated/clutter-frame-source.h',
  'deprecated/clutter-group.h',
  'deprecated/clutter-input-device.h',
  'deprecated/clutter-keysyms.h',
  'deprecated/clutter-list-model.h',
  'deprecated/clutter-main.h',
  'deprecated/clutter-media.h',
  'deprecated/clutter-model.h',
  'deprecated/clutter-rectangle.h',
  'deprecated/clutter-score.h',
  'deprecated/clutter-shader.h',
  'deprecated/clutter-stage-manager.h',
  'deprecated/clutter-stage.h',
  'deprecated/clutter-state.h',
  'deprecated/clutter-table-layout.h',
  'deprecated/clutter-texture.h',
  'deprecated/clutter-timeline.h',
  'deprecated/clutter-timeout-pool.h',
  'deprecated/clutter-util.h',
]

deprecated_sources = [
  'deprecated/clutter-actor-deprecated.c',
  'deprecated/clutter-alpha.c',
  'deprecated/clutter-animation.c',
  'deprecated/clutter-animator.c',
  'deprecated/clutter-behaviour.c',
  'deprecated/clutter-behaviour-depth.c',
  'deprecated/clutter-behaviour-ellipse.c',
  'deprecated/clutter-behaviour-opacity.c',
  'deprecated/clutter-behaviour-path.c',
  'deprecated/clutter-behaviour-rotate.c',
  'deprecated/clutter-behaviour-scale.c',
  'deprecated/clutter-box.c',
  'deprecated/clutter-cairo-texture.c',
  'deprecated/clutter-fixed.c',
  'deprecated/clutter-frame-source.c',
  'deprecated/clutter-group.c',
  'deprecated/clutter-input-device-deprecated.c',
  'deprecated/clutter-layout-manager-deprecated.c',
  'deprecated/clutter-list-model.c',
  'deprecated/clutter-media.c',
  'deprecated/clutter-model.c',
  'deprecated/clutter-rectangle.c',
  'deprecated/clutter-score.c',
  'deprecated/clutter-shader.c',
  'deprecated/clutter-state.c',
  'deprecated/clutter-table-layout.c',
  'deprecated/clutter-texture.c',
  'deprecated/clutter-timeout-pool.c',
]

deprecated_private_sources = [
  'deprecated/clutter-timeout-interval.c',
]

install_headers(
  clutter_deprecated_headers,
  install_dir: join_paths(clutter_full_includedir, 'deprecated'),
)

clutter_marshal = gnome.genmarshal(
  'clutter-marshal',
  sources: 'clutter-marshal.list',
  prefix: '_clutter_marshal',
  valist_marshallers: true,
)

clutter_enums = gnome.mkenums(
  'clutter-enum-types',
  sources: clutter_public_headers + clutter_deprecated_headers,
  c_template: 'clutter-enum-types.c.in',
  h_template: 'clutter-enum-types.h.in',
  install_header: true,
  install_dir: join_paths(clutter_includedir, clutter_api_name, 'clutter'),
)

clutter_version_h = configuration_data()
clutter_version_h.set('CLUTTER_MAJOR_VERSION', clutter_major_version)
clutter_version_h.set('CLUTTER_MINOR_VERSION', clutter_minor_version)
clutter_version_h.set('CLUTTER_MICRO_VERSION', clutter_micro_version)
clutter_version_h.set('CLUTTER_VERSION', meson.project_version())
configure_file(
  input: 'clutter-version.h.in',
  output: 'clutter-version.h',
  configuration: clutter_version_h,
  install: true,
  install_dir: clutter_full_includedir,
)

clutter_config = []
if enabled_backends.contains('x11')
  clutter_config += [
    '#define CLUTTER_WINDOWING_X11 "x11"',
    '#define CLUTTER_WINDOWING_GLX "glx"',
    '#define CLUTTER_INPUT_X11 "x11"',
  ]
endif
if enabled_backends.contains('gdk')
  clutter_config += [
    '#define CLUTTER_WINDOWING_GDK "gdk"',
    '#define CLUTTER_INPUT_GDK "gdk"',
  ]
endif
if enabled_backends.contains('wayland')
  clutter_config += [
    '#define CLUTTER_WINDOWING_WAYLAND "wayland"',
    '#define CLUTTER_INPUT_WAYLAND "wayland"',
  ]

  if get_variable('enable_wayland_compositor', false)
    clutter_config += '#define CLUTTER_HAS_WAYLAND_COMPOSITOR_SUPPORT 1'
  endif
endif
if enabled_backends.contains('mir')
  clutter_config += [
    '#define CLUTTER_WINDOWING_MIR "mir"',
    '#define CLUTTER_INPUT_MIR "mir"',
  ]
endif
clutter_config += '#define CLUTTER_INPUT_NULL "null"'

clutter_config_h = configuration_data()
clutter_config_h.set('CLUTTER_CONFIG_DEFINES', '\n'.join(clutter_config))
configure_file(
  input: 'clutter-config.h.in',
  output: 'clutter-config.h',
  configuration: clutter_config_h,
  install: true,
  install_dir: clutter_full_includedir,
)

backend_sources = []
backend_deps = []
backend_pc_files = []

if enabled_backends.contains('x11') or
   enabled_backends.contains('wayland') or
   enabled_backends.contains('gdk')
  backend_sources += [
    'cogl/clutter-stage-cogl.c',
  ]

  backend_pc_files += [
    [ 'clutter-cogl-@0@'.format(clutter_api_version), [], ],
  ]
endif

cogl_dep = dependency('cogl-1.0')

if enabled_backends.contains('x11')
  clutter_deps += [
    dependency('pangoft2')
  ]

  x11_deps = [
    dependency('x11'),
    dependency('xext'),
    dependency('xdamage'),
  ]

  xcomposite_dep = dependency('xcomposite', version: xcomposite_req_version, required: false)
  if xcomposite_dep.found()
    x11_deps += xcomposite_dep
    config_h.set('HAVE_XCOMPOSITE', 1)
  endif

  if cc.has_function('XGetEventData', dependencies: x11_deps)
    config_h.set('HAVE_XGE', 1)
  endif

  build_xi2 = false
  xi_dep = dependency('xi', required: false)
  if xi_dep.found()
    if cc.has_header('X11/extensions/XInput2.h')
      config_h.set('HAVE_XINPUT_2', 1)

      if cc.has_function('XIAllowTouchEvents', dependencies: x11_deps + [xi_dep]) and cc.has_member('XIScrollClassInfo', 'number', prefix: '#include <X11/extensions/XInput2.h>', dependencies: x11_deps + [xi_dep])
        config_h.set('HAVE_XINPUT_2_2', 1)
      endif
      build_xi2 = true
      x11_deps += xi_dep
    endif
  endif

  if cc.has_function('XkbQueryExtension', dependencies: x11_deps)
    config_h.set('HAVE_XKB', 1)
  endif

  backend_deps += x11_deps

  backend_sources += [
    'x11/clutter-backend-x11.c',
    'x11/clutter-device-manager-core-x11.c',
    'x11/clutter-event-x11.c',
    'x11/clutter-input-device-core-x11.c',
    'x11/clutter-keymap-x11.c',
    'x11/clutter-stage-x11.c',
    'x11/clutter-x11-texture-pixmap.c',
    'x11/clutter-glx-texture-pixmap.c',
  ]

  if build_xi2
    backend_sources += [
      'x11/clutter-device-manager-xi2.c',
      'x11/clutter-input-device-xi2.c',
    ]
  endif

  backend_sources += [
    'x11/xsettings/xsettings-client.c',
    'x11/xsettings/xsettings-common.c',
  ]

  install_headers([
      'x11/clutter-x11.h',
      'x11/clutter-x11-texture-pixmap.h',

      'x11/clutter-glx.h',
      'x11/clutter-glx-texture-pixmap.h',
    ],
    install_dir: join_paths(clutter_full_includedir, 'x11'),
  )

  backend_pc_files += [
    [ 'clutter-x11-@0@'.format(clutter_api_version), x11_deps ],
    [ 'clutter-glx-@0@'.format(clutter_api_version), x11_deps ],
  ]
endif

if enabled_backends.contains('gdk')
  gdk_dep = dependency('gdk-3.0', version: gdk_req_version)

  backend_deps += gdk_dep

  backend_sources += [
    'gdk/clutter-backend-gdk.c',
    'gdk/clutter-device-manager-gdk.c',
    'gdk/clutter-event-gdk.c',
    'gdk/clutter-input-device-gdk.c',
    'gdk/clutter-master-clock-gdk.c',
    'gdk/clutter-stage-gdk.c',
  ]

  backend_pc_files += [
    [ 'clutter-gdk-@0@'.format(clutter_api_version), gdk_dep ],
  ]

  install_headers([
      'gdk/clutter-gdk.h',
    ],
    install_dir: join_paths(clutter_full_includedir, 'gdk'),
  )
endif

if enabled_backends.contains('win32')
  backend_sources += [
    'win32/clutter-backend-win32.c',
    'win32/clutter-device-manager-win32.c',
    'win32/clutter-event-win32.c',
    'win32/clutter-stage-win32.c',
  ]

  backend_pc_files += [
    [ 'clutter-win32-@0@'.format(clutter_api_version), [] ],
  ]

  install_headers([
      'win32/clutter-win32.h',
    ],
    install_dir: join_paths(clutter_full_includedir, 'win32'),
  )
endif

if enabled_backends.contains('cex100')
  has_gdl_h = false
  if cc.has_header('libgdl.h')
    has_gdl_h = true
    gdl_prefix = ''
  else
    if cc.has_header('CE4100/libgdl.h')
      has_gdl_h = true
      gdl_prefix = 'CE4100'
      add_project_flags('-ICE4100', language: 'c')
    endif
  endif

  if has_gdl_h
    gdl_dep = cc.find_library('gdl')
    backend_deps += gdl_dep
  else
    error('libgdl.h is not available')
  endif

  backend_pc_files += [
    [ 'clutter-cex100-@0@'.format(clutter_api_version), [] ],
  ]

  subdir('cex100')
  backend_sources += [
    'cex100/clutter-backend-cex100.c',
  ]
endif

if enabled_backends.contains('eglnative')
  backend_sources += [
    'egl/clutter-backend-eglnative.c',
    'egl/clutter-stage-eglnative.c',
  ]

  config_h.set('CLUTTER_EGL_BACKEND_GENERIC', 1)

  backend_pc_files += 'clutter-egl-@0@'.format(clutter_api_version)

  install_headers([
      'egl/clutter-egl-headers.h',
      'egl/clutter-egl.h',
    ],
    install_dir: join_paths(clutter_full_includedir, 'egl'),
  )
endif

if enabled_backends.contains('wayland')
  if not cc.has_header_symbol('cogl/cogl.h', 'COGL_HAS_EGL_PLATFORM_WAYLAND_SUPPORT', dependencies: cogl_dep)
    error('Cogl compiled without Wayland support')
  endif

  wayland_deps = [
    dependency('wayland-client'),
    dependency('wayland-cursor'),
    dependency('xkbcommon'),
    dependency('gdk-pixbuf-2.0'),
  ]

  backend_deps += wayland_deps

  backend_sources += [
    'wayland/clutter-backend-wayland.c',
    'wayland/clutter-stage-wayland.c',
    'wayland/clutter-event-wayland.c',
    'wayland/clutter-input-device-wayland.c',
    'wayland/clutter-device-manager-wayland.c',
  ]

  install_headers([
      'wayland/clutter-wayland.h',
    ],
    install_dir: join_paths(clutter_full_includedir, 'wayland'),
  )

  backend_pc_files += [
    [ 'clutter-wayland-@0@'.format(clutter_api_version), wayland_deps ],
  ]

  enable_wayland_compositor = get_option('wayland_compositor')
  if enable_wayland_compositor
    backend_sources += [
      'wayland/clutter-wayland-surface.c',
    ]

    backend_pc_files += [
      [ 'clutter-wayland-compositor-@0@'.format(clutter_api_version), wayland_deps ],
    ]

    install_headers([
        'wayland/clutter-wayland-compositor.h',
        'wayland/clutter-wayland-surface.h',
      ],
      install_dir: join_paths(clutter_full_includedir, 'wayland'),
    )
  endif
endif

if enabled_backends.contains('mir')
  if not cc.has_header_symbol('cogl/cogl.h', 'COGL_HAS_EGL_PLATFORM_MIR_SUPPORT', dependencies: cogl_dep)
    error('Cogl compiled without Wayland support')
  endif

  backend_sources += [
    'mir/clutter-backend-mir.c',
    'mir/clutter-stage-mir.c',
    'mir/clutter-event-mir.c',
    'mir/clutter-input-device-mir.c',
    'mir/clutter-device-manager-mir.c',
  ]

  backend_pc_files += [
    [ 'clutter-mir-@0@'.format(clutter_api_version), [] ],
  ]

  install_headers([
      'mir/clutter-mir.h',
    ],
    install_dir: join_paths(clutter_full_includedir, 'mir'),
  )
endif

if enabled_backends.contains('quartz')
  backend_sources += [
    'osx/clutter-backend-osx.c',
    'osx/clutter-stage-osx.c',
    'osx/clutter-event-loop-osx.c',
    'osx/clutter-event-osx.c',
    'osx/clutter-device-manager-osx.c',
  ]

  backend_pc_files += [
    [ 'clutter-osx-@0@'.format(clutter_api_version), [] ],
  ]

  install_headers([
      'osx/clutter-osx.h',
    ],
    install_dir: join_paths(clutter_full_includedir, 'osx'),
  )

  add_project_flags([ '-xobjective-c' ], language: 'c')
endif

enabled_input_backends = []

if enabled_backends.contains('eglnative') or enabled_backends.contains('wayland')
  enabled_input_backends += 'evdev'
endif

if enabled_input_backends.contains('tslib') 
  backend_sources += [
    'tslib/clutter-event-tslib.c',
  ]
endif

need_xkb_utils = enabled_backends.contains('wayland') or enabled_backends.contains('mir')

if enabled_input_backends.contains('evdev')
  backend_deps += [
    dependency('libinput', version: libinput_req_version),
    dependency('gudev-1.0', version: libudev_req_version),
    dependency('libudev'),
    dependency('xkbcommon'),
  ]

  backend_sources += [
    'evdev/clutter-device-manager-evdev.c',
    'evdev/clutter-input-device-evdev.c',
    'evdev/clutter-event-evdev.c',
  ]

  if need_xkb_utils
    backend_sources += [
      'evdev/clutter-xkb-utils.c',
    ]
  endif

  install_headers([
      'evdev/clutter-evdev.h',
    ],
    install_dir: join_paths(clutter_full_includedir, 'evdev'),
  )
endif

configure_file(
  output: 'config.h',
  configuration: config_h,
)

clutter_inc = include_directories('.')
cally_inc = include_directories('cally')
clutter_cogl_inc = include_directories('cogl')
clutter_x11_inc = include_directories('x11')
clutter_osx_inc = include_directories('osx')
clutter_wayland_inc = include_directories('wayland')
clutter_win32_inc = include_directories('win32')
clutter_gdk_inc = include_directories('gdk')
clutter_egl_inc = include_directories('egl')
clutter_mir_inc = include_directories('mir')

libclutter = library(
  clutter_api_name,
  sources: [
    sources,
    deprecated_sources,
    backend_sources,
    cally_sources,
    private_sources,
    deprecated_private_sources,
    clutter_enums,
    clutter_marshal,
  ],
  dependencies: clutter_deps + backend_deps + [mathlib_dep],
  include_directories: [
    root_inc,
    clutter_inc,
    include_directories('cally'),
  ],
  soversion: clutter_soversion,
  version: clutter_libversion, 
  c_args: common_c_args,
  install: true,
)

introspected_sources = [
  clutter_public_headers,
  sources,
  clutter_deprecated_headers,
  deprecated_sources,
  clutter_enums[1],
]

if get_option('introspection')
  libclutter_gir = gnome.generate_gir(
    libclutter,
    sources: introspected_sources,
    namespace: 'Clutter',
    nsversion: clutter_api_version,
    export_packages: clutter_api_name,
    includes: [
      'GL-1.0',
      'GObject-2.0',
      'cairo-1.0',
      'Cogl-1.0',
      'CoglPango-1.0',
      'Atk-1.0',
      'Json-1.0',
    ],
    header: 'clutter/clutter.h',
    install: true,
    extra_args: [
      '--quiet',
      '-DCLUTTER_COMPILATION=1',
    ],
  )
else
  libclutter_gir = []
endif

libclutter_dep = declare_dependency(
  link_with: libclutter,
  sources: [ clutter_enums[1], libclutter_gir, ],
  include_directories: root_inc,
  dependencies: clutter_deps + [mathlib_dep],
)

pkgconf_files = [
  [ 'clutter-@0@'.format(clutter_api_version), clutter_deps ],
] + backend_pc_files

foreach pkg: pkgconf_files
  pkg_name = pkg[0]
  pkg_deps = pkg[1]
  pkgconf.generate(
    libraries: libclutter,
    name: 'Clutter',
    description: 'Dynamic, accelerated scene graph toolkit',
    version: meson.project_version(),
    variables: [
      'apiversion=@0@'.format(clutter_api_version),
      'backends=@0@'.format(','.join(enabled_backends)),
    ],
    requires: pkg_deps,
    filebase: pkg_name,
    subdirs: clutter_api_name,
    install_dir: join_paths(clutter_libdir, 'pkgconfig'),
  )
endforeach

pkgconf.generate(
  libraries: libclutter,
  name: 'Cally',
  description: 'Clutter Accessibility Implementation Library',
  version: meson.project_version(),
  variables: [
    'apiversion=@0@'.format(clutter_api_version),
  ],
  filebase: 'cally-@0@'.format(clutter_api_version),
  requires: [ 'atk', clutter_api_name ],
  subdirs: clutter_api_name,
  install_dir: join_paths(clutter_libdir, 'pkgconfig'),
)
