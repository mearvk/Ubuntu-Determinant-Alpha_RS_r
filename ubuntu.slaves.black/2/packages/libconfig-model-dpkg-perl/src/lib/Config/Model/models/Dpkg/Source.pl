use strict;
use warnings;

return [
  {
    'author' => [
      'Dominique Dumont'
    ],
    'class_description' => 'Model of files found under debian/source directory. 
See L<dpkg-source> for details.',
    'copyright' => [
      '2010,2011 Dominique Dumont'
    ],
    'element' => [
      'format',
      {
        'choice' => [
          '1.0',
          '2.0',
          '3.0 (native)',
          '3.0 (quilt)',
          '3.0 (custom)',
          '3.0 (git)',
          '3.0 (bzr)'
        ],
        'description' => 'Specifies the format of the source package. A missing format implies a \'1.0\' source format.',
        'help' => {
          '1.0' => 'A source package in this format consists either of a .orig.tar.gz associated to a .diff.gz or a single .tar.gz (in that case the package is said to be native).',
          '2.0' => 'was the first specification of a new-generation source package format. This format is not recommended for wide-spread usage, the format "3.0 (quilt)" replaces it.',
          '3.0 (bzr)' => 'This format is experimental. It generates a single tarball containing the bzr repository.
',
          '3.0 (custom)' => 'This format is particular. It doesn\'t represent a real source package format but can be used to create source packages with arbitrary files.
',
          '3.0 (git)' => 'This format is experimental. A source package in this format consists of a single bundle of a git repository .git to hold the source of a package. 
There may also be a .git shallow file listing revisions for a shallow git clone.',
          '3.0 (native)' => 'extension of the native package format as defined in the 1.0 format.',
          '3.0 (quilt)' => 'A source package in this format contains at least an original tarball (.orig.tar.ext where ext can be gz, bz2, lzma and xz) and a debian tarball (.debian.tar.ext). It can also contain additional original tarballs (.orig-component.tar.ext).'
        },
        'mandatory' => '1',
        'summary' => 'source package format',
        'type' => 'leaf',
        'value_type' => 'enum'
      },
      'options',
      {
        'config_class_name' => 'Dpkg::Source::Options',
        'description' => 'Source options as described in L<dpkg-source>',
        'type' => 'node'
      },
      'lintian-overrides',
      {
        'class' => 'Config::Model::Dpkg::Lintian::Overrides',
        'description' => 'Contains the lintian overrides parameters from all lintian overrides files contained in C<debian/*lintian-overrides>.

plain C<lintian-overrides> is contained in "." element.

Other files are contained in basename element.

For instance, C<debian/foo.lintian-overrides> is contained in C<foo> element.

Unknown L<lintian tags| https://lintian.debian.org/tags.html> trigger a warning.


',
        'type' => 'leaf',
        'value_type' => 'string'
      }
    ],
    'license' => 'LGPL2',
    'name' => 'Dpkg::Source',
    'rw_config' => {
      'auto_create' => '1',
      'backend' => 'PlainFile',
      'config_dir' => 'debian/source'
    }
  }
]
;

