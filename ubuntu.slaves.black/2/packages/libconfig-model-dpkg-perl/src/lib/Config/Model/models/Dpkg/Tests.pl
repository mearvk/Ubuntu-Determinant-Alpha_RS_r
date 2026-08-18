use strict;
use warnings;

return [
  {
    'element' => [
      'control',
      {
        'cargo' => {
          'config_class_name' => 'Dpkg::Tests::Control',
          'type' => 'node'
        },
        'type' => 'list'
      }
    ],
    'name' => 'Dpkg::Tests',
    'rw_config' => {
      'auto_create' => '1',
      'auto_delete' => '1',
      'backend' => 'Dpkg::Autopkgtest',
      'config_dir' => 'debian/tests',
      'file' => 'control'
    }
  }
]
;

