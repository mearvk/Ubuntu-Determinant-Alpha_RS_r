use strict;
use warnings;

return [
  {
    'author' => [
      'Dominique Dumont'
    ],
    'copyright' => [
      '2010,2011 Dominique Dumont'
    ],
    'element' => [
      'source',
      {
        'config_class_name' => 'Dpkg::Control::Source',
        'summary' => 'package source description',
        'type' => 'node'
      },
      'binary',
      {
        'cargo' => {
          'config_class_name' => 'Dpkg::Control::Binary',
          'type' => 'node'
        },
        'index_type' => 'string',
        'ordered' => '1',
        'summary' => 'package binary description',
        'type' => 'hash'
      }
    ],
    'license' => 'LGPL2',
    'name' => 'Dpkg::Control',
    'rw_config' => {
      'auto_create' => '1',
      'backend' => 'Dpkg::Control',
      'config_dir' => 'debian',
      'file' => 'control'
    }
  }
]
;

