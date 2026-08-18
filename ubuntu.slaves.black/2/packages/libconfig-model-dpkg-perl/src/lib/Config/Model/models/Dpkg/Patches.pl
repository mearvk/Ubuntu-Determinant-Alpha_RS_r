use strict;
use warnings;

return [
  {
    'author' => [
      'Dominique Dumont'
    ],
    'class_description' => 'Model of Debian package patch files of type quilt (3.0). I.e. patch files located in debian/patches',
    'copyright' => [
      '2010,2011 Dominique Dumont'
    ],
    'element' => [
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
      }
    ],
    'license' => 'LGPL2',
    'name' => 'Dpkg::Patches',
    'rw_config' => {
      'auto_create' => '1',
      'backend' => 'Dpkg',
      'config_dir' => 'debian',
      'file' => 'clean'
    }
  }
]
;

