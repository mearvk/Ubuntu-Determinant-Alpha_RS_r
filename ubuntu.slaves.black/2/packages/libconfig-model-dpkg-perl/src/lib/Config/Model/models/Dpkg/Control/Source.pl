use strict;
use warnings;

return [
  {
    'accept' => [
      '.*',
      {
        'description' => 'Additional user-defined fields

Fields in the main source control information file with names starting X, followed by one or more of the letters BCS and a hyphen -, will be copied to the output files. Only the part of the field name after the hyphen will be used in the output file. Where the letter B is used the field will appear in binary package control files, where the letter S is used in Debian source control files and where C is used in upload control (.changes) files.

For details, see L<section 5.7 of Debian policy|https://www.debian.org/doc/debian-policy/#document-ch-controlfields>',
        'summary' => 'User defined field',
        'type' => 'leaf',
        'value_type' => 'string'
      }
    ],
    'author' => [
      'Dominique Dumont'
    ],
    'copyright' => [
      '2010,2011 Dominique Dumont'
    ],
    'element' => [
      'Source',
      {
        'compute' => {
          'allow_override' => '1',
          'formula' => 'use Cwd; getcwd =~ m!/([^/]+)$!; $1;',
          'use_eval' => '1'
        },
        'description' => 'Source package name. Defaults to the name of the current directory.',
        'mandatory' => '1',
        'match' => '\\w[\\w+\\-\\.]{1,}',
        'summary' => 'source package name',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'debhelper-version',
      {
        'default' => '0',
        'description' => 'Debhelper version. This parameter is hidden because it does not exist in control. It\'s used to drive warp mechanism for parameters that  depend on debhelper version.',
        'level' => 'hidden',
        'type' => 'leaf',
        'value_type' => 'integer'
      },
      'Maintainer',
      {
        'compute' => {
          'allow_override' => '1',
          'formula' => 'my $name = $ENV{DEBFULLNAME};
my $email = $ENV{DEBEMAIL} ;
my $ret;
$ret = "$name <$email>" if $name and $email;
$ret;',
          'use_eval' => '1'
        },
        'description' => 'The package maintainer\'s name and email address. The name must come first, then the email address inside angle brackets <> (in RFC822 format).

If the maintainer\'s name contains a full stop then the whole field will not work directly as an email address due to a misfeature in the syntax specified in RFC822; a program using this field as an address must check for this and correct the problem if necessary (for example by putting the name in round brackets and moving it to the end, and bringing the email address forward). ',
        'summary' => 'package maintainer\'s name and email address',
        'type' => 'leaf',
        'value_type' => 'uniline',
        'warn_unless_match' => {
          '@' => {
            'msg' => 'Maintainer is empty or is not an email address'
          }
        }
      },
      'Uploaders',
      {
        'cargo' => {
          'replace_follow' => '!Dpkg my_config email-updates',
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'type' => 'list'
      },
      'Standards-Version',
      {
        'class' => 'Config::Model::Dpkg::Control::Source::StandardVersion',
        'description' => 'This field indicates the Debian policy version number this package complies to.

Before updating this field, please read L<upgrading-checklist|https://www.debian.org/doc/debian-policy/upgrading-checklist.html>
to know what changes came with a new policy version number and apply the required changes (if any) to your package.',
        'mandatory' => '1',
        'match' => '\\d+\\.\\d+\\.\\d+(\\.\\d+)?',
        'summary' => 'Debian policy version number this package complies to',
        'type' => 'leaf',
        'value_type' => 'uniline',
        'warn_if' => {
          'current' => {
            'code' => '$self->compare_with_last_version($_) == -1;',
            'fix' => '$_ = $self->_fetch_std; # restore default value',
            'msg' => 'Current standards version is \'$std_value\'. Please read https://www.debian.org/doc/debian-policy/upgrading-checklist.html for the changes that may be needed on your package to upgrade it from standard version \'$_\' to \'$std_value\'.
'
          },
          'old_lintian' => {
            'code' => '$self->compare_with_last_version($_) == 1;',
            'msg' => 'Current standards version \'$_\' is newer than lintian version ($std_value). Please check your system
'
          }
        }
      },
      'Section',
      {
        'default' => 'misc',
        'description' => 'The packages in the archive areas main, contrib and non-free are
grouped further into sections to simplify handling.

The archive area and section for each package should be specified in
the package\'s Section control record (see 
L<Section 5.6.5|https://www.debian.org/doc/debian-policy/#section>).
However, the maintainer of the Debian archive may override
this selection to ensure the consistency of the Debian
distribution. The Section field should be of the form:

'.'=over

'.'=item * 

section if the package is in the main archive area,

'.'=item *

area/section if the package is in the contrib or non-free archive areas.

'.'=back

',
        'type' => 'leaf',
        'value_type' => 'uniline',
        'warn_unless' => {
          'area' => {
            'code' => '(not defined) or m!^((contrib|non-free)/)?[\\w\\-]+$!;',
            'msg' => 'Bad area. Should be \'non-free\' or \'contrib\''
          },
          'empty' => {
            'code' => 'defined and length',
            'msg' => 'Section is empty'
          },
          'section' => {
            'code' => '(not defined) or m!^([-\\w]+/)?(admin|cli-mono|comm|database|devel|debug|doc|editors|education|electronics|embedded|fonts|games|gnome|golang|graphics|gnu-r|gnustep|hamradio|haskell|httpd|interpreters|introspection|java|javascript|kde|kernel|libs|libdevel|lisp|localization|mail|math|metapackages|misc|net|news|ocaml|oldlibs|otherosfs|perl|php|python|ruby|rust|science|shells|sound|tex|text|utils|vcs|video|web|x11|xfce|zope)$!;',
            'msg' => 'Bad section.'
          }
        }
      },
      'XS-Testsuite',
      {
        'description' => 'Enable a test suite to be used with this package. For more details see L<README.package-tests.rst|https://anonscm.debian.org/cgit/autopkgtest/autopkgtest.git/plain/doc/README.package-tests.rst>',
        'status' => 'deprecated',
        'summary' => 'name of the non regression test suite',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'Testsuite',
      {
        'description' => 'Enable a test suite to be used with this package. For more details see L<README.package-tests.rst|https://salsa.debian.org/ci-team/autopkgtest/blob/master/doc/README.package-tests.rst>',
        'migrate_from' => {
          'formula' => '$xs_testsuite',
          'variables' => {
            'xs_testsuite' => '- XS-Testsuite'
          }
        },
        'summary' => 'name of the non regression test suite',
        'type' => 'leaf',
        'value_type' => 'uniline',
        'warn_unless' => {
          'defined-test' => {
            'code' => 'my $m = $self->grab_value(\'- Maintainer\');
my ($team) = ( $m =~ /(pkg-(?:perl|ruby|go))/ );
not defined $team or defined $_ or file(\'debian/tests/control\')->exists;',
            'fix' => 'my $m = $self->grab_value(\'- Maintainer\');
my ($str) = ($m =~ /pkg-(perl|ruby|go)/);
$_ = $str ? \'autopkgtest-pkg-\'.$str : undef;',
            'msg' => 'Undefined while packaging team supports test suite'
          },
          'team-test' => {
            'code' => 'my $m = $self->grab_value(\'- Maintainer\');
my ($team) = ( $m =~ /(pkg-(?:perl|ruby|go))/ );
not defined $_ or not defined $team or $_ eq \'autopkgtest-\'.$team  or -e \'debian/tests/control\';',
            'fix' => 'my $m = $self->grab_value(\'- Maintainer\');
my ($str) = ($m =~ /pkg-(perl|ruby|go)/);
$_ = $str ? \'autopkgtest-pkg-\'.$str : undef;',
            'msg' => 'value does not match maintainer team'
          }
        },
        'warn_unless_match' => {
          '^autopkgtest(-pkg-(dkms|elpa|go|nodejs|octave|perl|python|r|ruby))?$' => {
            'fix' => 'my $m = $self->grab_value(\'- Maintainer\');
my ($str) = ($m =~ /pkg-(perl|ruby|go)/);
$_ = $str ? \'autopkgtest-pkg-\'.$str : undef;',
            'msg' => 'Unknown value'
          }
        }
      },
      'XS-Autobuild',
      {
        'default' => '0',
        'description' => 'Read the full description from 
L<section 5.10.5|https://www.debian.org/doc/manuals/developers-reference/pkgs.html#non-free-buildd> 
in Debian developer reference.',
        'level' => 'hidden',
        'summary' => 'Allow automatic build of non-free or contrib package',
        'type' => 'leaf',
        'value_type' => 'boolean',
        'warp' => {
          'follow' => {
            'section' => '- Section'
          },
          'rules' => [
            '$section =~ m!^(contrib|non-free)/!',
            {
              'level' => 'normal'
            }
          ]
        },
        'write_as' => [
          'no',
          'yes'
        ]
      },
      'Priority',
      {
        'choice' => [
          'required',
          'important',
          'standard',
          'optional',
          'extra'
        ],
        'default' => 'optional',
        'help' => {
          'extra' => 'This contains all packages that conflict with others with required, important, standard or optional priorities, or are only likely to be useful if you already know what they are or have specialized requirements (such as packages containing only detached debugging symbols).',
          'important' => 'Important programs, including those which one would expect to find on any Unix-like system. If the expectation is that an experienced Unix person who found it missing would say "What on earth is going on, where is foo?", it must be an important package.[5] Other packages without which the system will not run well or be usable must also have priority important. This does not include Emacs, the X Window System, TeX or any other large applications. The important packages are just a bare minimum of commonly-expected and necessary tools.',
          'optional' => '(In a sense everything that isn\'t required is optional, but that\'s not what is meant here.) This is all the software that you might reasonably want to install if you didn\'t know what it was and don\'t have specialized requirements. This is a much larger system and includes the X Window System, a full TeX distribution, and many applications. Note that optional packages should not conflict with each other. ',
          'required' => 'Packages which are necessary for the proper functioning of the system (usually, this means that dpkg functionality depends on these packages). Removing a required package may cause your system to become totally broken and you may not even be able to use dpkg to put things back, so only do so if you know what you are doing. Systems with only the required packages are probably unusable, but they do have enough functionality to allow the sysadmin to boot and install more software. ',
          'standard' => 'These packages provide a reasonably small but not too limited character-mode system. This is what will be installed by default if the user doesn\'t select anything else. It doesn\'t include many large applications. '
        },
        'type' => 'leaf',
        'value_type' => 'enum',
        'warp' => {
          'follow' => {
            'std_ver' => '- Standards-Version'
          },
          'rules' => [
            '$std_ver ge \'4.0.1\'',
            {
              'replace' => {
                'extra' => 'optional'
              }
            }
          ]
        }
      },
      'Build-Depends',
      {
        'cargo' => {
          'class' => 'Config::Model::Dpkg::Dependency',
          'type' => 'leaf',
          'value_type' => 'uniline',
          'warn_if_match' => {
            'libpng12-dev' => {
              'fix' => '$_ = \'libpng-dev\';',
              'msg' => 'This dependency is deprecated and should be replaced with libpng-dev. See BTS 650601 for details'
            }
          },
          'warp' => {
            'follow' => {
              'dhv' => '- debhelper-version'
            },
            'rules' => [
              'defined $dhv and $dhv and $dhv+0 >= 10',
              {
                'warn_if_match' => {
                  '^(autotools-dev|dh-autoreconf)' => {
                    'fix' => '$_ = undef',
                    'msg' => 'dependency "$_" is not necessary with debhelper > 10'
                  }
                }
              }
            ]
          }
        },
        'class' => 'Config::Model::Dpkg::DependencyList',
        'description' => 'List of packages that must be installed:

'.'=over

'.'=item *

during clean

'.'=item *

to build architecture-dependent binaries ("Architecture: any" or specific architectures).

'.'=back

Technically, these packages must be installed for the following build targets: clean, build-arch, and binary-arch.
See L<build target|https://www.debian.org/doc/debian-policy/#relationships-between-source-and-binary-packages-build-depends-build-depends-indep-build-depends-arch-build-conflicts-build-conflicts-indep-build-conflicts-arch>.

On the other hand, the list of packages that must be installed to build architecture-independent binaries ("Architecture: all") should be listed in "Build-Depends-Indep" field.

Including a dependency in this field does not have the exact same effect as including it in both Build-Depends-Arch and Build-Depends-Indep, because the dependency also needs to be satisfied when building the source package.

See also L<deb-src-control|https://manpages.debian.org/unstable/dpkg-dev/deb-src-control.5.en.html> man page',
        'duplicates' => 'warn',
        'summary' => 'List of package required during clean or build of architecture-dependent packages',
        'type' => 'list'
      },
      'Build-Depends-Arch',
      {
        'cargo' => {
          'class' => 'Config::Model::Dpkg::Dependency',
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'class' => 'Config::Model::Dpkg::DependencyList',
        'description' => 'Same as Build-Depends, but these packages are only needed when building the architecture dependent packages. The Build-Depends are also installed in this case. 

See L<deb-src-control man page|https://manpages.debian.org/unstable/dpkg-dev/deb-src-control.5.en.html> for details',
        'duplicates' => 'warn',
        'summary' => 'List of package required to build architecture-dependent packages',
        'type' => 'list'
      },
      'Build-Depends-Indep',
      {
        'cargo' => {
          'class' => 'Config::Model::Dpkg::Dependency',
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'class' => 'Config::Model::Dpkg::DependencyList',
        'description' => 'List of packages that must be installed to build architecture-independent binaries ("Architecture: all").

Technically, these packages must be installed for the following build targets: build, build-indep, binary, and binary-indep.
See L<build target|https://www.debian.org/doc/debian-policy/#relationships-between-source-and-binary-packages-build-depends-build-depends-indep-build-depends-arch-build-conflicts-build-conflicts-indep-build-conflicts-arch>.

Note that packages required during "clean" phase must be declared in "Build-Depends" field.',
        'duplicates' => 'warn',
        'summary' => 'List of package required during build of architecture-independent package',
        'type' => 'list'
      },
      'Build-Conflicts',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'class' => 'Config::Model::Dpkg::DependencyList',
        'description' => 'List of packages that must be missing (i.e. B<not> installed):

'.'=over

'.'=item *

during clean

'.'=item *

to build architecture-dependent binaries ("Architecture: any" or specific architectures).

'.'=back

Technically, these packages must B<not> be installed for the following build targets: clean, build-arch, and binary-arch.
See L<build target|https://www.debian.org/doc/debian-policy/#relationships-between-source-and-binary-packages-build-depends-build-depends-indep-build-depends-arch-build-conflicts-build-conflicts-indep-build-conflicts-arch>.

On the other hand, the list of packages that must B<not> be installed to build architecture-independent binaries ("Architecture: all") should be listed in "Build-Conflicts-Indep" field.

Including a dependency in this list has the same effect as including it in both Build-Conflicts-Arch and Build-Conflicts-Indep, with the additional effect of being used for source-only builds. 

See L<deb-src-control man page|https://manpages.debian.org/unstable/dpkg-dev/deb-src-control.5.en.html> for details.',
        'duplicates' => 'warn',
        'summary' => 'List of package not wanted during clean or build of architecture-dependent packages',
        'type' => 'list'
      },
      'Build-Conflicts-Arch',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'class' => 'Config::Model::Dpkg::DependencyList',
        'description' => 'List of packages that must be missing (i.e. B<not> installed) to build archictecture dependent binaries 

See L<deb-src-control man page|https://manpages.debian.org/unstable/dpkg-dev/deb-src-control.5.en.html> for details.',
        'duplicates' => 'warn',
        'summary' => 'List of package not wanted during build of architecture dependent packages',
        'type' => 'list'
      },
      'Build-Conflicts-Indep',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'class' => 'Config::Model::Dpkg::DependencyList',
        'description' => 'List of packages that must be missing (i.e. B<not> installed) to build binaries with arch set to "all.

Technically, these packages must B<not> be installed for the following build targets: build, build-indep, binary, and binary-indep.
See L<build target|https://www.debian.org/doc/debian-policy/#relationships-between-source-and-binary-packages-build-depends-build-depends-indep-build-depends-arch-build-conflicts-build-conflicts-indep-build-conflicts-arch>.

Note that packages not wanted during "clean" phase must be declared in "Build-Conflicts" field.',
        'duplicates' => 'warn',
        'summary' => 'List of package not wanted during build of architecture-independent packages',
        'type' => 'list'
      },
      'Built-Using',
      {
        'cargo' => {
          'class' => 'Config::Model::Dpkg::Dependency',
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'class' => 'Config::Model::Dpkg::DependencyList',
        'description' => ' Some binary packages incorporate parts of other packages when built but do not have to depend on those packages. Examples include linking with static libraries or incorporating source code from another package during the build. In this case, the source packages of those other packages are a required part of the complete source (the binary package is not reproducible without them).

A Built-Using field must list the corresponding source package for any such binary package incorporated during the build, including an B<exactly equal> ("=") version relation on the version that was used to build that binary package[57].

A package using the source code from the gcc-4.6-source binary package built from the gcc-4.6 source package would have this field in its control file:

     Built-Using: gcc-4.6 (= 4.6.0-11)

A package including binaries from grub2 and loadlin would have this field in its control file:

     Built-Using: grub2 (= 1.99-9), loadlin (= 1.6e-1)
',
        'duplicates' => 'warn',
        'summary' => 'Additional source packages used to build the binary',
        'type' => 'list'
      },
      'Vcs-Browser',
      {
        'compute' => {
          'allow_override' => '1',
          'formula' => '  $pkgname =~ /r-cran-/ ? "https://salsa.debian.org/r-pkg-team/$pkgname"
: $maintainer =~ /pkg-perl/ ? "https://salsa.debian.org/perl-team/modules/packages/$pkgname"
: $maintainer =~ /pkg-ruby-extras/ ? "https://salsa.debian.org/ruby-team/$pkgname"
: $maintainer =~ /pkg-javascript/ ? "https://salsa.debian.org/js-team/$pkgname"
: $maintainer =~ /debian-med-packaging/ ? "https://salsa.debian.org/med-team/$pkgname"
: $maintainer =~ /team\\@neuro.debian.net/ ? "https://salsa.debian.org/neurodebian-team/$pkgname"
: $maintainer =~ /debian-science-maintainers/ ? "https://salsa.debian.org/science-team/$pkgname"
: $maintainer =~ /pkg-phototools-devel/ ? "https://salsa.debian.org/debian-phototools-team/$pkgname"
: $maintainer =~ /pkg-java-maintainers/ ? "https://salsa.debian.org/java-team/$pkgname"
: $maintainer =~ /r-pkg-team/ ? "https://salsa.debian.org/r-pkg-team/$pkgname"
:                                                     undef ;',
          'use_eval' => '1',
          'variables' => {
            'maintainer' => '- Maintainer',
            'pkgname' => '- Source'
          }
        },
        'description' => 'Value of this field should be a https:// URL pointing to a web-browsable copy of the Version Control System repository used to maintain the given package, if available.

The information is meant to be useful for the final user, willing to browse the latest work done on the package (e.g. when looking for the patch fixing a bug tagged as pending in the bug tracking system). ',
        'match' => '^https?://',
        'summary' => 'web-browsable URL of the VCS repository',
        'type' => 'leaf',
        'value_type' => 'uniline',
        'warn_unless' => {
          'debian-uri' => {
            'code' => '!defined $_ or ! /debian.org/ or m{^https://salsa.debian.org/};',
            'fix' => '$_ = undef; # let the correct value be set by compute setup',
            'msg' => 'URL is not the canonical one for repositories hosted on Debian infrastructure.'
          }
        }
      },
      'Vcs-Arch',
      {
        'description' => 'Value of this field should be a string identifying unequivocally the location of the Version Control System repository used to maintain the given package, if available. * identify the Version Control System; currently the following systems are supported by the package tracking system: arch, bzr (Bazaar), cvs, darcs, git, hg (Mercurial), mtn (Monotone), svn (Subversion). It is allowed to specify different VCS fields for the same package: they will all be shown in the PTS web interface.

The information is meant to be useful for a user knowledgeable in the given Version Control System and willing to build the current version of a package from the VCS sources. Other uses of this information might include automatic building of the latest VCS version of the given package. To this end the location pointed to by the field should better be version agnostic and point to the main branch (for VCSs supporting such a concept). Also, the location pointed to should be accessible to the final user; fulfilling this requirement might imply pointing to an anonymous access of the repository instead of pointing to an SSH-accessible version of the same. ',
        'summary' => 'URL of the VCS repository',
        'type' => 'leaf',
        'value_type' => 'uniline',
        'warn_if' => {
          'debian-uri' => {
            'code' => 'defined $_ and /debian.org/;',
            'fix' => '$_ = undef;',
            'msg' => 'URL is invalid, no support for this Vcs on Debian infrastructure anymore.'
          }
        }
      },
      'Vcs-Bzr',
      {
        'description' => 'Value of this field should be a string identifying unequivocally the location of the Version Control System repository used to maintain the given package, if available. * identify the Version Control System; currently the following systems are supported by the package tracking system: arch, bzr (Bazaar), cvs, darcs, git, hg (Mercurial), mtn (Monotone), svn (Subversion). It is allowed to specify different VCS fields for the same package: they will all be shown in the PTS web interface.

The information is meant to be useful for a user knowledgeable in the given Version Control System and willing to build the current version of a package from the VCS sources. Other uses of this information might include automatic building of the latest VCS version of the given package. To this end the location pointed to by the field should better be version agnostic and point to the main branch (for VCSs supporting such a concept). Also, the location pointed to should be accessible to the final user; fulfilling this requirement might imply pointing to an anonymous access of the repository instead of pointing to an SSH-accessible version of the same. ',
        'summary' => 'URL of the VCS repository',
        'type' => 'leaf',
        'value_type' => 'uniline',
        'warn_if' => {
          'debian-uri' => {
            'code' => 'defined $_ and /debian.org/;',
            'fix' => '$_ = undef;',
            'msg' => 'URL is invalid, no support for this Vcs on Debian infrastructure anymore.'
          }
        }
      },
      'Vcs-Cvs',
      {
        'description' => 'Value of this field should be a string identifying unequivocally the location of the Version Control System repository used to maintain the given package, if available. * identify the Version Control System; currently the following systems are supported by the package tracking system: arch, bzr (Bazaar), cvs, darcs, git, hg (Mercurial), mtn (Monotone), svn (Subversion). It is allowed to specify different VCS fields for the same package: they will all be shown in the PTS web interface.

The information is meant to be useful for a user knowledgeable in the given Version Control System and willing to build the current version of a package from the VCS sources. Other uses of this information might include automatic building of the latest VCS version of the given package. To this end the location pointed to by the field should better be version agnostic and point to the main branch (for VCSs supporting such a concept). Also, the location pointed to should be accessible to the final user; fulfilling this requirement might imply pointing to an anonymous access of the repository instead of pointing to an SSH-accessible version of the same. ',
        'summary' => 'URL of the VCS repository',
        'type' => 'leaf',
        'value_type' => 'uniline',
        'warn_if' => {
          'debian-uri' => {
            'code' => 'defined $_ and /debian.org/;',
            'fix' => '$_ = undef;',
            'msg' => 'URL is invalid, no support for this Vcs on Debian infrastructure anymore.'
          }
        }
      },
      'Vcs-Darcs',
      {
        'description' => 'Value of this field should be a string identifying unequivocally the location of the Version Control System repository used to maintain the given package, if available. * identify the Version Control System; currently the following systems are supported by the package tracking system: arch, bzr (Bazaar), cvs, darcs, git, hg (Mercurial), mtn (Monotone), svn (Subversion). It is allowed to specify different VCS fields for the same package: they will all be shown in the PTS web interface.

The information is meant to be useful for a user knowledgeable in the given Version Control System and willing to build the current version of a package from the VCS sources. Other uses of this information might include automatic building of the latest VCS version of the given package. To this end the location pointed to by the field should better be version agnostic and point to the main branch (for VCSs supporting such a concept). Also, the location pointed to should be accessible to the final user; fulfilling this requirement might imply pointing to an anonymous access of the repository instead of pointing to an SSH-accessible version of the same. ',
        'summary' => 'URL of the VCS repository',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'Vcs-Git',
      {
        'compute' => {
          'allow_override' => '1',
          'formula' => '  $pkgname =~ /r-cran-/ ? "https://salsa.debian.org/r-pkg-team/$pkgname.git"
: $maintainer =~ /pkg-perl/                        ? "https://salsa.debian.org/perl-team/modules/packages/$pkgname.git"
: $maintainer =~ /pkg-ruby-extras/ ? "https://salsa.debian.org/ruby-team/$pkgname.git"
: $maintainer =~ /pkg-javascript/ ? "https://salsa.debian.org/js-team/$pkgname.git"
: $maintainer =~ /debian-med-packaging/ ? "https://salsa.debian.org/med-team/$pkgname.git"
: $maintainer =~ /team\\@neuro.debian.net/ ? "https://salsa.debian.org/neurodebian-team/$pkgname.git"
: $maintainer =~ /debian-science-maintainers/ ? "https://salsa.debian.org/science-team/$pkgname.git"
: $maintainer =~ /pkg-phototools-devel/ ? "https://salsa.debian.org/debian-phototools-team/$pkgname.git"
: $maintainer =~ /pkg-java-maintainers/ ? "https://salsa.debian.org/java-team/$pkgname.git"
: $maintainer =~ /r-pkg-team/ ? "https://salsa.debian.org/r-pkg-team/$pkgname.git"
:                                                    \'\' ;',
          'use_eval' => '1',
          'variables' => {
            'maintainer' => '- Maintainer',
            'pkgname' => '- Source'
          }
        },
        'description' => 'Value of this field should be a string identifying unequivocally the location of the Version Control System repository used to maintain the given package, if available. * identify the Version Control System; currently the following systems are supported by the package tracking system: arch, bzr (Bazaar), cvs, darcs, git, hg (Mercurial), mtn (Monotone), svn (Subversion). It is allowed to specify different VCS fields for the same package: they will all be shown in the PTS web interface.

The information is meant to be useful for a user knowledgeable in the given Version Control System and willing to build the current version of a package from the VCS sources. Other uses of this information might include automatic building of the latest VCS version of the given package. To this end the location pointed to by the field should better be version agnostic and point to the main branch (for VCSs supporting such a concept). Also, the location pointed to should be accessible to the final user; fulfilling this requirement might imply pointing to an anonymous access of the repository instead of pointing to an SSH-accessible version of the same. ',
        'summary' => 'URL of the VCS repository',
        'type' => 'leaf',
        'value_type' => 'uniline',
        'warn_if_match' => {
          '^(git|http)://' => {
            'fix' => 's/^(git|http):/https:/;',
            'msg' => 'An unencrypted transport protocol is used for this URI. It is recommended to use a secure transport such as HTTPS for anonymous read-only access.'
          },
          'debian.org/~' => {
            'msg' => 'URL contains deprecated \'~\' path to user'
          }
        },
        'warn_unless' => {
          'debian-uri' => {
            'code' => '!defined $_ or ! /debian.org/ or m{^https://salsa.debian.org/};',
            'fix' => '$_ = undef; # let the correct value be set by compute setup',
            'msg' => 'URL is not the canonical one for repositories hosted on Debian infrastructure.'
          }
        }
      },
      'Vcs-Hg',
      {
        'description' => 'Value of this field should be a string identifying unequivocally the location of the Version Control System repository used to maintain the given package, if available. * identify the Version Control System; currently the following systems are supported by the package tracking system: arch, bzr (Bazaar), cvs, darcs, git, hg (Mercurial), mtn (Monotone), svn (Subversion). It is allowed to specify different VCS fields for the same package: they will all be shown in the PTS web interface.

The information is meant to be useful for a user knowledgeable in the given Version Control System and willing to build the current version of a package from the VCS sources. Other uses of this information might include automatic building of the latest VCS version of the given package. To this end the location pointed to by the field should better be version agnostic and point to the main branch (for VCSs supporting such a concept). Also, the location pointed to should be accessible to the final user; fulfilling this requirement might imply pointing to an anonymous access of the repository instead of pointing to an SSH-accessible version of the same. ',
        'summary' => 'URL of the VCS repository',
        'type' => 'leaf',
        'value_type' => 'uniline',
        'warn_if' => {
          'debian-uri' => {
            'code' => 'defined $_ and /debian.org/;',
            'fix' => '$_ = undef;',
            'msg' => 'URL is invalid, no support for this Vcs on Debian infrastructure anymore.'
          }
        }
      },
      'Vcs-Mtn',
      {
        'description' => 'Value of this field should be a string identifying unequivocally the location of the Version Control System repository used to maintain the given package, if available. * identify the Version Control System; currently the following systems are supported by the package tracking system: arch, bzr (Bazaar), cvs, darcs, git, hg (Mercurial), mtn (Monotone), svn (Subversion). It is allowed to specify different VCS fields for the same package: they will all be shown in the PTS web interface.

The information is meant to be useful for a user knowledgeable in the given Version Control System and willing to build the current version of a package from the VCS sources. Other uses of this information might include automatic building of the latest VCS version of the given package. To this end the location pointed to by the field should better be version agnostic and point to the main branch (for VCSs supporting such a concept). Also, the location pointed to should be accessible to the final user; fulfilling this requirement might imply pointing to an anonymous access of the repository instead of pointing to an SSH-accessible version of the same. ',
        'summary' => 'URL of the VCS repository',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'Vcs-Svn',
      {
        'description' => 'Value of this field should be a string identifying unequivocally the location of the Version Control System repository used to maintain the given package, if available. * identify the Version Control System; currently the following systems are supported by the package tracking system: arch, bzr (Bazaar), cvs, darcs, git, hg (Mercurial), mtn (Monotone), svn (Subversion). It is allowed to specify different VCS fields for the same package: they will all be shown in the PTS web interface.

The information is meant to be useful for a user knowledgeable in the given Version Control System and willing to build the current version of a package from the VCS sources. Other uses of this information might include automatic building of the latest VCS version of the given package. To this end the location pointed to by the field should better be version agnostic and point to the main branch (for VCSs supporting such a concept). Also, the location pointed to should be accessible to the final user; fulfilling this requirement might imply pointing to an anonymous access of the repository instead of pointing to an SSH-accessible version of the same. ',
        'summary' => 'URL of the VCS repository',
        'type' => 'leaf',
        'value_type' => 'uniline',
        'warn_if' => {
          'debian-uri' => {
            'code' => 'defined $_ and /debian.org/;',
            'fix' => '$_ = undef;',
            'msg' => 'URL is invalid, no support for this Vcs on Debian infrastructure anymore.'
          }
        }
      },
      'DM-Upload-Allowed',
      {
        'description' => 'If this field is present, then any Debian Maintainers listed in the Maintainer or Uploaders fields may upload the package directly to the Debian archive.  For more information see the "Debian Maintainer" page at the Debian Wiki - https://wiki.debian.org/DebianMaintainer',
        'match' => 'yes',
        'status' => 'deprecated',
        'summary' => 'The package may be uploaded by a Debian Maintainer',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'Homepage',
      {
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'Rules-Requires-Root',
      {
        'description' => 'Depending on the value of the Rules-Requires-Root field, the package builder (e.g. dpkg-buildpackage) may run the debian/rules target as an unprivileged user and provide a gain root command. This command allows the debian/rules target to run particular subcommands under (fake)root. Can be \'no\', \'binary-targets\' (default)), or a space separated list of keywords containing a forward slash (e.g. "/").

For details, see L<section 5.6.31.2 of Debian policy|https://www.debian.org/doc/debian-policy/ch-controlfields.html#rules-requires-root>',
        'help' => {
          '.+/' => 'Space separated list of keywords. These keywords must always contain a forward slash, which sets them apart from the other possible values of Rules-Requires-Root. When this list is provided, the builder must provide a gain root command (as defined in debian/rules and Rules-Requires-Root) or pretend that the value was set to binary-targets, and both the builder and the package’s debian/rules script must downgrade accordingly.',
          'binary-targets' => '(Default) Declares that the package will need the root (or fakeroot) when either of the binary, binary-arch or binary-indep targets are called. This is how every tool behaved before this field was defined.',
          'no' => 'Declares that neither root nor fakeroot is required. Package builders (e.g. dpkg-buildpackage) may choose to invoke any target in debian/rules with an unprivileged user.'
        },
        'summary' => 'Defines if access to root (or fakeroot) is required during build.',
        'type' => 'leaf',
        'value_type' => 'uniline',
        'warn_unless_match' => {
          '^no|binary-targets|([^\\P{PosixGraph}/]{2,}/\\p{PosixGraph}{2,}\\s*)+$' => {
            'msg' => 'Invalid value. See help or Debian Policy chapter 5.6.31.2 for more information'
          }
        }
      },
      'XS-Python-Version',
      {
        'status' => 'deprecated',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'X-Python-Version',
      {
        'description' => 'This field specifies the versions of Python (not versions of Python 3) supported by the source package.  When not specified, they default to all currently supported Python (or Python 3) versions. For more detail, See L<python policy|https://www.debian.org/doc/packaging-manuals/python-policy/ch-module_packages.html#s-specifying_versions>',
        'migrate_from' => {
          'formula' => 'my $old = $xspython ;
my $new ;
if ($old =~ /,/) {
   # list of versions
   my @list = sort split /\\s*,\\s*/, $old ; 
   $new = ">= ". (shift @list) . ", << " .  (pop @list) ;
}
elsif ($old =~ /-/) {
   my @list = sort grep { $_ ;} split /\\s*-\\s*/, $old ; 
   $new = ">= ". shift @list ;
   $new .= ", << ". pop @list if @list ;
}
else {
   $new = $old ;
}
$new ;',
          'use_eval' => '1',
          'variables' => {
            'xspython' => '- XS-Python-Version'
          }
        },
        'summary' => 'supported versions of Python ',
        'type' => 'leaf',
        'upstream_default' => 'all',
        'value_type' => 'uniline'
      },
      'X-Python3-Version',
      {
        'description' => 'This field specifies the versions of Python 3 supported by the package. For more detail, See L<python policy|https://www.debian.org/doc/packaging-manuals/python-policy/ch-module_packages.html#s-specifying_versions>',
        'summary' => 'supported versions of Python3 ',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'XS-Ruby-Versions',
      {
        'description' => 'indicate the versions of the interpreter
supported by the library',
        'level' => 'hidden',
        'type' => 'leaf',
        'value_type' => 'uniline',
        'warp' => {
          'follow' => {
            'maintainer' => '- Maintainer',
            'source' => '- Source'
          },
          'rules' => [
            '$maintainer =~ m!Debian Ruby!i or $source =~ /^ruby/',
            {
              'level' => 'normal'
            }
          ]
        }
      }
    ],
    'license' => 'LGPL2',
    'name' => 'Dpkg::Control::Source'
  }
]
;

