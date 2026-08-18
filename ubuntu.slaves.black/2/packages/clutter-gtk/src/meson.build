project('clutter-gtk', 'c', version: '1.8.4',
        license: 'LGPLv2.1+',
        default_options: [
          'buildtype=debugoptimized',
          'c_std=c99',
          'warning_level=1',
        ],
        meson_version: '>= 0.40.1')

add_project_arguments([ '-D_XOPEN_SOURCE=700' ], language: 'c')

cc = meson.get_compiler('c')
host_system = host_machine.system()

version = meson.project_version().split('.')
gtk_clutter_major_version = version[0].to_int()
gtk_clutter_minor_version = version[1].to_int()
gtk_clutter_micro_version = version[2].to_int()

gtk_clutter_api_version = '@0@.0'.format(gtk_clutter_major_version)

if gtk_clutter_minor_version.is_odd()
  gtk_clutter_interface_age = 0
else
  gtk_clutter_interface_age = gtk_clutter_micro_version
endif

gtk_clutter_api_name = '@0@-@1@'.format(meson.project_name(), gtk_clutter_api_version)
gtk_clutter_api_path = join_paths(gtk_clutter_api_name, meson.project_name())

gtk_clutter_prefix = get_option('prefix')
gtk_clutter_libdir = join_paths(gtk_clutter_prefix, get_option('libdir'))
gtk_clutter_includedir = join_paths(gtk_clutter_prefix, get_option('includedir'))
gtk_clutter_datadir = join_paths(gtk_clutter_prefix, get_option('datadir'))

# maintaining compatibility with the previous libtool versioning
# current = minor * 100 + micro - interface
# revision = interface
soversion = 0
current = 100 * gtk_clutter_minor_version + gtk_clutter_micro_version - gtk_clutter_interface_age
revision = gtk_clutter_interface_age
libversion = '@0@.@1@.@2@'.format(soversion, current, revision)

config_h = configuration_data()
config_h.set_quoted('GETTEXT_PACKAGE', 'cluttergtk-@0@'.format(gtk_clutter_api_version))

# Compiler flags
common_cflags = []
common_ldflags = []

if cc.get_id() == 'msvc'
  # Make MSVC more pedantic, this is a recommended pragma list
  # from _Win32_Programming_ by Rector and Newcomer.  Taken from
  # glib's msvc_recommended_pragmas.h--please see that file for
  # the meaning of the warning codes used here
  test_cflags = [
    '-we4002',
    '-we4003',
    '-w14010',
    '-we4013',
    '-w14016',
    '-we4020',
    '-we4021',
    '-we4027',
    '-we4029',
    '-we4033',
    '-we4035',
    '-we4045',
    '-we4047',
    '-we4049',
    '-we4053',
    '-we4071',
    '-we4150',
    '-we4819'
  ]
elif cc.get_id() == 'gcc' or cc.get_id() == 'clang'
  test_cflags = [
    '-ffast-math',
    '-fstrict-aliasing',
    '-Wpointer-arith',
    '-Wmissing-declarations',
    '-Wformat=2',
    '-Wstrict-prototypes',
    '-Wmissing-prototypes',
    '-Wnested-externs',
    '-Wold-style-definition',
    '-Wunused',
    '-Wuninitialized',
    '-Wshadow',
    '-Wmissing-noreturn',
    '-Wmissing-format-attribute',
    '-Wredundant-decls',
    '-Wlogical-op',
    '-Wcast-align',
    '-Wno-unused-local-typedefs',
    '-Werror=implicit',
    '-Werror=init-self',
    '-Werror=main',
    '-Werror=missing-braces',
    '-Werror=return-type',
    '-Werror=array-bounds',
    '-Werror=write-strings',
  ]
else
  test_cflags = []
endif

# Symbol visibility
if get_option('default_library') != 'static'
  if host_system == 'windows'
    config_h.set('DLL_EXPORT', true)
    config_h.set('CLUTTER_GTK_EXTERN', '__declspec(dllexport) extern')
    if cc.get_id() != 'msvc'
      test_cflags += ['-fvisibility=hidden']
    endif
  else
    config_h.set('CLUTTER_GTK_EXTERN', '__attribute__((visibility("default"))) extern')
    test_cflags += ['-fvisibility=hidden']
  endif
endif

foreach cflag: test_cflags
  if cc.has_argument(cflag)
    common_cflags += cflag
  endif
endforeach

if host_system == 'linux'
  foreach ldflag: [ '-Wl,-Bsymbolic-functions', '-Wl,-z,relro', '-Wl,-z,now' ]
    if cc.has_argument(ldflag)
      common_ldflags += ldflag
    endif
  endforeach
endif

if host_system == 'darwin'
  common_ldflags += [ '-compatibility_version=1', '-current_version=1.0', ]
endif

gtk_clutter_debug_cflags = []
if get_option('buildtype').startswith('debug')
  gtk_clutter_debug_cflags += '-DCLUTTER_GTK_ENABLE_DEBUG'
elif get_option('buildtype') == 'release'
  gtk_clutter_debug_cflags += '-DG_DISABLE_CAST_CHECKS'
endif

if gtk_clutter_minor_version.is_even()
  gtk_clutter_debug_cflags += [
    '-DGLIB_DISABLE_DEPRECATION_WARNINGS',
    '-DCLUTTER_DISABLE_DEPRECATION_WARNINGS',
    '-DGDK_DISABLE_DEPRECATION_WARNINGS',
  ]
endif

# Dependencies
clutter_req_version = '>= 1.23.7'
gtk_req_version = '>= 3.21.0'

mathlib_dep = cc.find_library('m', required: false)
clutter_dep = dependency('clutter-1.0', version: clutter_req_version)
gtk_dep = dependency('gtk+-3.0', version: gtk_req_version)

configure_file(output: 'config.h', configuration: config_h) 

pkgconf = configuration_data()
pkgconf.set('prefix', gtk_clutter_prefix)
pkgconf.set('exec_prefix', gtk_clutter_prefix)
pkgconf.set('libdir', gtk_clutter_libdir)
pkgconf.set('includedir', gtk_clutter_includedir)
pkgconf.set('CLUTTER_GTK_API_VERSION', gtk_clutter_api_version)
pkgconf.set('VERSION', meson.project_version())
configure_file(input: 'clutter-gtk.pc.in',
               output: 'clutter-gtk-@0@.pc'.format(gtk_clutter_api_version),
               configuration: pkgconf,
               install: true,
               install_dir: join_paths(gtk_clutter_libdir, 'pkgconfig'))

root_inc = include_directories('.')

gnome = import('gnome')

subdir('clutter-gtk')
subdir('po')

subdir('examples')

if get_option('enable_docs')
  subdir('doc')
endif
