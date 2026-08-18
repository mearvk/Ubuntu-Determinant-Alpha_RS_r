use strict;
use warnings;

return [
  {
    'author' => [
      'Dominique Dumont'
    ],
    'class_description' => 'Model of Debian source package files (e.g debian/control, debian/copyright...)',
    'copyright' => [
      '2010-2015 Dominique Dumont'
    ],
    'element' => [
      'my_config',
      {
        'config_class_name' => 'Dpkg::Meta',
        'description' => 'This element contains a set of parameters to tune the behavior of this dpkg editor. You can for instance specify e-mail replacements. These parameters are stored in ~/.dpkg-meta.yml or ~/.local/share/.dpkg-meta.yml. These parameters can be applied to all Debian packages you maintain in this unix account.',
        'type' => 'node'
      },
      'compat',
      {
        'description' => 'compat file defines the debhelper compatibility level',
        'type' => 'leaf',
        'value_type' => 'integer'
      },
      'control',
      {
        'config_class_name' => 'Dpkg::Control',
        'description' => 'Package control file. Specifies the most vital (and version-independent) information about the source package and about the binary packages it creates.',
        'type' => 'node'
      },
      'rules',
      {
        'default' => '#!/usr/bin/make -f
# See debhelper(7) (uncomment to enable)
# output every command that modifies files on the build system.
#DH_VERBOSE = 1

# see EXAMPLES in dpkg-buildflags(1) and read /usr/share/dpkg/*
DPKG_EXPORT_BUILDFLAGS = 1
include /usr/share/dpkg/default.mk

# see FEATURE AREAS in dpkg-buildflags(1)
#export DEB_BUILD_MAINT_OPTIONS = hardening=+all

# see ENVIRONMENT in dpkg-buildflags(1)
# package maintainers to append CFLAGS
#export DEB_CFLAGS_MAINT_APPEND  = -Wall -pedantic
# package maintainers to append LDFLAGS
#export DEB_LDFLAGS_MAINT_APPEND = -Wl,--as-needed

# main packaging script based on dh7 syntax
%:
	dh $@
',
        'description' => 'debian/rules is a makefile containing all instructions required to build a debian package.',
        'summary' => 'package build rules',
        'type' => 'leaf',
        'value_type' => 'string'
      },
      'changelog',
      {
        'compute' => {
          'allow_override' => '1',
          'formula' => '$pkg_name (0.0.0.0-0) UNRELEASED; urgency=medium

  * ...

 -- $name <$mail>  Wed, 18 Jan 2017 18:28:23 +0100
',
          'variables' => {
            'mail' => '! my_config email',
            'name' => '! my_config fullname',
            'pkg_name' => '! control source Source'
          }
        },
        'description' => 'Dummy changelog entry with a dummy date.
Don\'t forget to change the version
number. Use L<dch> command to update.',
        'type' => 'leaf',
        'value_type' => 'string'
      },
      'scan-copyright-patterns',
      {
        'config_class_name' => 'Dpkg::Copyright::ScanPatterns',
        'description' => 'This parameter is used by "cme update dpkg-copyright". This command scans all source files to get copyright and license information. By default, the decision whether to scan a file or not is left to licensecheck. You can override this behavior using this parameter.

See L<Dpkg::Copyright::Scanner/"electing or ignoring files to scan"> for more details.',
        'type' => 'node'
      },
      'fill-copyright-blanks',
      {
        'config_class_name' => 'Dpkg::Copyright::FillBlanks',
        'description' => 'This parameter is used by "cme update dpkg-copyright command".

Sometimes, upstream coders are not perfect: some source files cannot be parsed correctly or some legal information is missing. A file without copyright and license information is skipped. On the other hand, a file with either copyright or license missing will be used. Unfortunately, this will prevent a correct grouping and merging of copyright entries. Instead of patching upstream source files to fill the blank, you can specify the missing information in a special file.',
        'summary' => 'Provides missing copyright info for cme update',
        'type' => 'node'
      },
      'fix.scanned.copyright',
      {
        'description' => 'Instructions to alter or set specific copyright entries in
"debian/fix.scanned.copyright" file. Each line of this file
follows the syntax described in L<Config::Model::Loader>
to modify copyright information.

See L<Config::Model::Dpkg::Copyright/"Tweak copyright entries"> for more
details',
        'type' => 'leaf',
        'value_type' => 'string'
      },
      'copyright',
      {
        'config_class_name' => 'Dpkg::Copyright',
        'description' => 'copyright and license information of all files contained in this package',
        'summary' => 'copyright and license information',
        'type' => 'node'
      },
      'install',
      {
        'cargo' => {
          'config_class_name' => 'Dpkg::Install',
          'type' => 'node'
        },
        'description' => 'List the files to install into each package and the directory they should be installed to.

Here the mapping between the install files and the install key:

'.'=over 4

'.'=item *

"." -> C<debian/install>

'.'=item *

"package" -> C<debian/package.install>

'.'=item *

"package/arch" -> C<debian/package.install.arch>

'.'=back

',
        'index_type' => 'string',
        'type' => 'hash'
      },
      'examples',
      {
        'cargo' => {
          'config_class_name' => 'Dpkg::Install',
          'type' => 'node'
        },
        'description' => 'List of the examples files to install into
C</usr/share/doc/package/examples>

Use the package name as the key of the hash
',
        'index_type' => 'string',
        'type' => 'hash'
      },
      'not-installed',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline',
          'warn_if_match' => {
            '^/' => {
              'fix' => 's!^/!!',
              'msg' => 'path should not begin with \'/\''
            }
          }
        },
        'description' => 'List the files that are deliberately not installed in any binary package. Paths listed in this file are (only) ignored by the check done via --list-missing (or --fail-missing). However, it is not a method to exclude files from being installed. Please use --exclude for that.

Please keep in mind that dh_install will not expand wildcards in this file.
',
        'type' => 'list'
      },
      'source',
      {
        'config_class_name' => 'Dpkg::Source',
        'type' => 'node'
      },
      'lintian-overrides',
      {
        'cargo' => {
          'class' => 'Config::Model::Dpkg::Lintian::Overrides',
          'type' => 'leaf',
          'value_type' => 'string'
        },
        'description' => 'Contains the lintian overrides parameters from all lintian overrides files contained in C<debian/*lintian-overrides>.

plain C<lintian-overrides> is contained in "." element.

Other files are contained in basename element.

For instance, C<debian/foo.lintian-overrides> is contained in C<foo> element.

Unknown L<lintian tags| https://lintian.debian.org/tags.html> trigger a warning.


',
        'index_type' => 'string',
        'type' => 'hash'
      },
      'clean',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'description' => 'list of files to remove when dh_clean is run. Files names can include wild cards. For instance:

 build.log
 Makefile.in
 */Makefile.in
 */*/Makefile.in

',
        'summary' => 'list of files to clean',
        'type' => 'list'
      },
      'bugfiles',
      {
        'cargo' => {
          'config_class_name' => 'Dpkg::BugFiles',
          'type' => 'node'
        },
        'follow_keys_from' => '- control binary',
        'index_type' => 'string',
        'type' => 'hash'
      },
      'package-scripts',
      {
        'cargo' => {
          'config_class_name' => 'Dpkg::PackageScripts',
          'type' => 'node'
        },
        'index_type' => 'string',
        'type' => 'hash'
      },
      'patches',
      {
        'cargo' => {
          'config_class_name' => 'Dpkg::Patch',
          'type' => 'node'
        },
        'description' => 'Series of patches applied by Debian. Note that you cannot change the order of patches in the series. Use L<quilt> for this task. Comments in series file are skipped and not shown in annotation.',
        'index_type' => 'string',
        'ordered' => '1',
        'summary' => 'Debian patches applied to original sources',
        'type' => 'hash'
      },
      'dirs',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline',
          'warn' => 'Make sure that this directory is actually needed. See L<http://www.debian.org/doc/manuals/maint-guide/dother.en.html#dirs> for details'
        },
        'description' => 'This file specifies any directories which we need but which are not created by the normal installation procedure (make install DESTDIR=... invoked by dh_auto_install). This generally means there is a problem with the Makefile.

Files listed in an install file don\'t need their directories created first. 

It is best to try to run the installation first and only use this if you run into trouble. There is no preceding slash on the directory names listed in the dirs file. ',
        'summary' => 'Extra directories',
        'type' => 'list'
      },
      'docs',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'description' => 'This file specifies the file names of documentation files we can have dh_installdocs(1) install into the temporary directory for us.

By default, it will include all existing files in the top-level source directory that are called BUGS, README*, TODO etc. ',
        'type' => 'list'
      },
      'watch',
      {
        'description' => 'watch file used by L<uscan> to monitor upstream sources',
        'type' => 'leaf',
        'value_type' => 'string'
      },
      'tests',
      {
        'config_class_name' => 'Dpkg::Tests',
        'description' => 'Debian CI test suite specification. See L<README.package-tests.rst|https://salsa.debian.org/ci-team/autopkgtest/blob/master/doc/README.package-tests.rst> for more details',
        'level' => 'hidden',
        'type' => 'warped_node',
        'warp' => {
          'follow' => {
            'testsuite' => '- control source Testsuite'
          },
          'rules' => [
            'not $testsuite',
            {
              'level' => 'normal'
            }
          ]
        }
      }
    ],
    'license' => 'LGPL2',
    'name' => 'Dpkg',
    'rw_config' => {
      'auto_create' => '1',
      'auto_delete' => '1',
      'backend' => 'Dpkg',
      'config_dir' => 'debian'
    }
  }
]
;

