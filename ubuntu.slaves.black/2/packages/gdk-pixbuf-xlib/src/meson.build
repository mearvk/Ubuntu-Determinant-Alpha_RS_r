project('gdk-pixbuf-xlib', 'c',
        version: '2.40.2',
        license: 'LGPL-2.1-or-later',
        default_options: [
          'buildtype=debugoptimized',
          'warning_level=1',
          'c_std=c99',
        ],
        meson_version: '>= 0.49.0')

add_project_arguments([ '-D_POSIX_C_SOURCE=200809L', '-D_DEFAULT_SOURCE', '-D_XOPEN_SOURCE' ], language: 'c')

cc = meson.get_compiler('c')
host_system = host_machine.system()

# Versioning
version = meson.project_version()
version_arr = version.split('.')
version_major = version_arr[0].to_int()
version_minor = version_arr[1].to_int()
version_micro = version_arr[2].to_int()

api_version = '@0@.0'.format(version_major)
api_name = 'gdk-pixbuf-@0@'.format(api_version)

if version_minor.is_odd()
  interface_age = 0
else
  interface_age = version_micro
endif

binary_age = 100 * version_minor + version_micro

# maintaining compatibility with the previous libtool versioning
# current = binary - interface
# revision = interface
soversion = 0
current = binary_age - interface_age
revision = interface_age
libversion = '@0@.@1@.@2@'.format(soversion, current, revision)
age = binary_age - interface_age
current_minus_age = current - age
darwin_versions = ['@0@'.format(current + 1), '@0@.@1@'.format(current + 1, interface_age)]

# Paths
prefix = get_option('prefix')
libdir = prefix / get_option('libdir')
bindir = prefix / get_option('bindir')
includedir = prefix / get_option('includedir')
datadir = prefix / get_option('datadir')
mandir = prefix / get_option('mandir')
localedir = prefix / get_option('localedir')
libexecdir = prefix / get_option('libexecdir')

# Dependencies
gdk_pixbuf_dep = dependency('gdk-pixbuf-2.0', version: '>= 2.39.2')
x11_dep = dependency('x11')

# Configurations
conf = configuration_data()

check_headers = [
  'unistd.h',
  'sys/resource.h',
  'sys/time.h'
]

foreach h: check_headers
  if cc.has_header(h)
    conf.set('HAVE_' + h.underscorify().to_upper(), 1)
  endif
endforeach

# Look for the math library first, since we use it to test for round() and lrint()
mathlib_dep = cc.find_library('m', required: false)

# Common compiler and linker flags
common_cflags = []
common_ldflags = []

if cc.get_id() == 'gcc' or cc.get_id() == 'clang'
  test_cflags = [
    '-Wpointer-arith',
    '-Wformat=2',
    '-Wstrict-prototypes',
    '-Wnested-externs',
    '-Wold-style-definition',
    '-Wdeclaration-after-statement',
    '-Wunused',
    '-Wcast-align',
    '-Wmissing-noreturn',
    '-Wmissing-format-attribute',
    '-Wlogical-op',
    '-fno-strict-aliasing',
    '-Wno-int-conversion',
    '-Wno-uninitialized',
    '-Wno-discarded-qualifiers',
    '-Werror=implicit',
    '-Werror=nonnull',
    '-Werror=init-self',
    '-Werror=main',
    '-Werror=missing-braces',
    '-Werror=sequence-point',
    '-Werror=return-type',
    '-Werror=trigraphs',
    '-Werror=array-bounds',
    '-Werror=write-strings',
    '-Werror=address',
    '-Werror=int-to-pointer-cast',
    '-Werror=pointer-to-int-cast',
    '-Werror=empty-body',
  ]

  # Ensure we have the correct bit packing on Windows
  if host_system == 'windows'
    test_cflags += '-mms-bitfields'
  endif
else
  test_cflags = []
endif

# Symbol visibility
if get_option('default_library') != 'static'
  if host_system == 'windows'
    conf.set('DLL_EXPORT', true)
    conf.set('_GDK_PIXBUF_EXTERN', '__declspec(dllexport) extern')
    if cc.get_id() != 'msvc'
      test_cflags += ['-fvisibility=hidden']
    endif
  else
    conf.set('_GDK_PIXBUF_EXTERN', '__attribute__((visibility("default"))) extern')
    test_cflags += ['-fvisibility=hidden']
  endif
endif

common_cflags += cc.get_supported_arguments(test_cflags)

if host_machine.system() == 'linux'
  # Additional linker flags
  test_ldflags = ['-Wl,-Bsymbolic', '-Wl,-z,relro', '-Wl,-z,now']
  common_ldflags += cc.get_supported_link_arguments(test_ldflags)
  conf.set('OS_LINUX', 1)
endif

if host_machine.system() == 'darwin'
  # Maintain compatibility with autotools on macOS
  common_ldflags += [ '-compatibility_version', darwin_versions[0], '-current_version', darwin_versions[1]]
  conf.set('OS_DARWIN', 1)
endif

conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())

configure_file(output: 'config.h', configuration: conf)
add_project_arguments([ '-DHAVE_CONFIG_H=1' ], language: 'c')

root_inc = include_directories('.')

gnome = import('gnome')

subdir('gdk-pixbuf-xlib')

# Documentation
subdir('docs')
