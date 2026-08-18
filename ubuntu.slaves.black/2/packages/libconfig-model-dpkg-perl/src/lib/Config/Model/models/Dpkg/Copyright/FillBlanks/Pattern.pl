use strict;
use warnings;

return [
  {
    'element' => [
      'copyright',
      {
        'type' => 'leaf',
        'value_type' => 'string'
      },
      'override-copyright',
      {
        'description' => 'C<override-copyright> key is used to ignore the copyright information coming from the source and provide the correct information. Use this as last resort for instance when the encoding of the owner is not ascii or utf-8. Note that a warning will be shown each time a copyright is overridden.',
        'type' => 'leaf',
        'value_type' => 'string'
      },
      'license',
      {
        'description' => 'license keyword, either similar to the one provided by L<licensecheck> or license short name as required by Debian copyright specification.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'override-license',
      {
        'description' => 'C<override-license> key is used to ignore the license information coming from the source and provide the correct information. Use this as last resort when extracted license is corrupted and fill a bug against libconfig-model-dpkg-perl to get this issue fixed. Note that a warning will be shown each time a license is overridden.',
        'type' => 'leaf',
        'value_type' => 'string'
      },
      'skip',
      {
        'description' => 'skip the files like a file without any information.',
        'type' => 'leaf',
        'upstream_default' => '0',
        'value_type' => 'boolean'
      },
      'comment',
      {
        'description' => 'This field is provided for bookkeeping and is not used by "cme update dpkg-copyright"',
        'type' => 'leaf',
        'value_type' => 'string'
      }
    ],
    'name' => 'Dpkg::Copyright::FillBlanks::Pattern'
  }
]
;

