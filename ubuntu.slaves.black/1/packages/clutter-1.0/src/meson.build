project(
  'clutter', 'c',
  version: '1.26.4',
  license: 'LGPLv2.1+',
  meson_version: '>= 0.44.1',
  default_options: [
    'buildtype=debugoptimized',
    'c_std=c99',
    'warning_level=1',
  ],
)

version = meson.project_version().split('.')
clutter_major_version = version[0].to_int()
clutter_minor_version = version[1].to_int()
clutter_micro_version = version[2].to_int()

clutter_api_version = '@0@.0'.format(clutter_major_version)
clutter_api_name = '@0@-@1@'.format(meson.project_name(), clutter_api_version)

# soname versioning, compatible with libtool
clutter_so_age = 0
clutter_interface_age = clutter_minor_version.is_even() ? clutter_micro_version : 0
clutter_binary_age = 100 * clutter_minor_version + clutter_micro_version - clutter_interface_age
clutter_soversion = clutter_so_age
clutter_libversion = '@0@.@1@.@2@'.format(clutter_so_age, clutter_binary_age, clutter_interface_age)

cc = meson.get_compiler('c')
config_h = configuration_data()

add_project_arguments([ '-D_GNU_SOURCE', '-DHAVE_CONFIG_H' ], language: 'c')

# Paths
clutter_prefix = get_option('prefix')
clutter_libdir = join_paths(clutter_prefix, get_option('libdir'))
clutter_datadir = join_paths(clutter_prefix, get_option('datadir'))
clutter_sysconfdir = get_option('sysconfdir')
clutter_libexecdir = join_paths(clutter_prefix, get_option('libexecdir'))
clutter_includedir = join_paths(clutter_prefix, get_option('includedir'))
clutter_localedir = join_paths(clutter_datadir, 'locale')

# Dependencies
glib_req_version = '>= 2.53.4'
cogl_req_version = '>= 1.21.2'
json_glib_req_version = '>= 0.12.0'
atk_req_version = '>= 2.5.3'
cairo_req_version = '>= 1.14.0'
pango_req_version = '>= 1.30'
gi_req_version = '>= 1.39.0'
gtk_doc_req_version = '>= 1.20'
xcomposite_req_version = '>= 0.4'
gdk_req_version = '>= 3.22.6'
libinput_req_version = '>= 0.19.0'
libudev_req_version = '>= 136'

clutter_deps = [
  dependency('gobject-2.0', version: glib_req_version),
  dependency('gio-2.0'),
  dependency('cogl-1.0', version: cogl_req_version),
  dependency('cogl-path-1.0'),
  dependency('cogl-pango-1.0'),
  dependency('cairo-gobject', version: cairo_req_version),
  dependency('atk', version: atk_req_version),
  dependency('json-glib-1.0', version: json_glib_req_version),
]

mathlib_dep = cc.find_library('m', required: false)

# Linker flags
common_ldflags = []
if host_machine.system() == 'linux' and cc.get_id() == 'gcc'
  common_ldflags += [ '-Wl,-Bsymbolic', '-Wl,-z,relro', '-Wl,-z,now', ]
elif host_machine.system() == 'darwin'
  common_ldflags += [ '-compatibility_version 1', '-current_version 1.0' ]
endif

# Detect and set symbol visibility
if get_option('default_library') != 'static'
  if host_machine.system() == 'windows'
    config_h.set('DLL_EXPORT', true)
    config_h.set('_CLUTTER_EXTERN', '__declspec(dllexport) extern')
    if cc.get_id() != 'msvc'
      add_project_arguments(['-fvisibility=hidden'], language: 'c')
    endif
  else
    config_h.set('_CLUTTER_EXTERN', '__attribute__((visibility("default"))) extern')
    add_project_arguments(['-fvisibility=hidden'], language: 'c')
  endif
endif

# Windowing system backends
all_backends = [
  'gdk',
  'x11',
  'wayland',
  'win32',
  'quartz',
  'cogl',
  'eglnative',
]

system_backends = []
if host_machine.system() == 'linux'
  system_backends += [ 'gdk', 'x11', 'wayland', ]
elif host_machine.system() == 'windows'
  system_backends += 'win32'
elif host_machine.system() == 'darwin'
  system_backends += 'quartz'
endif

requested_backends = get_option('backends').split(',')
if requested_backends.contains('system')
  enabled_backends = system_backends
elif requested_backends.contains('all')
  enabled_backends = all_backends
else
  enabled_backends = requested_backends
endif

all_drivers = ['*']
requested_drivers = get_option('drivers').split(',')
if requested_drivers.contains('all')
  enabled_drivers = all_drivers
else
  enabled_drivers = requested_drivers
endif

config_h.set('COGL_ENABLE_EXPERIMENTAL_2_0_API', 1)
config_h.set_quoted('CLUTTER_DRIVERS', enabled_drivers)
config_h.set_quoted('GETTEXT_PACKAGE', meson.project_name())

root_inc = include_directories('.')

gnome = import('gnome')
pkgconf = import('pkgconfig')

subdir('clutter')
subdir('po')

if get_option('build_tests')
  subdir('tests')
endif

if get_option('build_examples')
  subdir('examples')
endif

if get_option('documentation')
  subdir('doc')
endif

summary = [
  'Clutter',
  '----------------',
  '        version: @0@'.format(meson.project_version()),
  '',
  '         prefix: @0@'.format(clutter_prefix),
  '         libdir: @0@'.format(clutter_libdir),
  '     includedir: @0@'.format(clutter_includedir),
  '        datadir: @0@'.format(clutter_datadir),
  '     libexecdir: @0@'.format(clutter_libexecdir),
  '',
  '       backends: @0@'.format(' '.join(enabled_backends)),
  '     GL drivers: @0@'.format(get_option('drivers')),
  '',
  '  documentation: @0@'.format(get_option('documentation')),
  '  introspection: @0@'.format(get_option('introspection')),
  '       examples: @0@'.format(get_option('build_examples')),
  '          tests: @0@'.format(get_option('build_tests')),
  '',
]

message('\n'.join(summary))
