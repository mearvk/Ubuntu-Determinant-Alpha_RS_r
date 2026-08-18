use strict;
use warnings;

return [
  {
    'accept' => [
      '.*',
      {
        'description' => 'Unexpected but possibly right debian source option.',
        'type' => 'leaf',
        'value_type' => 'uniline',
        'warn' => 'There\'s a missing element in Dpkg::Source::Option. Please log a bug against libconfig-model-dpkg-perl mentioning the missing element and its relevant documentation.'
      }
    ],
    'author' => [
      'Dominique Dumont <domi.dumont@free.fr>'
    ],
    'class_description' => 'list of long options that should be automatically prepended to the set of command line options of a dpkg-source -b or dpkg-source --print-format call. Options like --compression and --compression-level are well suited for this file.',
    'element' => [
      'diff-ignore',
      {
        'description' => 'perl regular expression to match files you want filtered out of the list of files for the diff.This is very helpful in cutting out extraneous files that get included in the diff, e.g. if you maintain your source in a revision control system and want to use a checkout to build a source package without including the additional files and directories that it will usually contain (e.g. CVS, .cvsignore, .svn/). The default regexp is already very exhaustive, but if you need to replace it, please note that by default it can match any part of a path, so if you want to match the begin of a filename or only full filenames, you will need to provide the necessary anchors (e.g. \'(^|/)\', \'($|/)\') yourself.',
        'summary' => 'perl regexp to filter out files for the diff',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'extend-diff-ignore',
      {
        'description' => 'The perl regular expression specified will extend the default regular expression associated to diff-ignore by concatenating "|regexp" to the default regexp. This option is convenient to exclude some auto-generated files from the automatic patch generation.',
        'summary' => 'Perl regexp to extend the diff-ignore setup',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'compression',
      {
        'choice' => [
          'gzip',
          'bzip2',
          'lzma',
          'xz'
        ],
        'description' => 'The default is xz for formats 2.0 and newer, and gzip for format 1.0. xz is only supported since dpkg-dev 1.15.5.',
        'summary' => 'Specify the compression to use for created tarballs and diff files.',
        'type' => 'leaf',
        'upstream_default' => 'xz',
        'value_type' => 'enum'
      },
      'compression-level',
      {
        'choice' => [
          1,
          2,
          3,
          4,
          5,
          6,
          7,
          8,
          9,
          'best',
          'fast'
        ],
        'description' => 'Default compression level is 9 for gzip and bzip2, 6 for xz and lzma.',
        'summary' => 'Compression level to use.',
        'type' => 'leaf',
        'value_type' => 'enum'
      }
    ],
    'license' => 'LGPL-2.1',
    'name' => 'Dpkg::Source::Options',
    'rw_config' => {
      'auto_create' => '1',
      'backend' => 'ShellVar',
      'config_dir' => 'debian/source',
      'file' => 'options'
    }
  }
]
;

