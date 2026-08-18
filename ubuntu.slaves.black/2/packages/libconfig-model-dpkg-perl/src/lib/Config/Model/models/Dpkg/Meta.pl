use strict;
use warnings;

return [
  {
    'author' => [
      'Dominique Dumont'
    ],
    'class_description' => 'This class contains parameters to tune the behavior of the Dpkg model. For instance, user can specify rules to update e-mail addresses.',
    'copyright' => [
      '2010,2011 Dominique Dumont'
    ],
    'element' => [
      'fullname',
      {
        'compute' => {
          'allow_override' => '1',
          'formula' => '$ENV{DEBFULLNAME}',
          'use_eval' => '1'
        },
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'email',
      {
        'compute' => {
          'allow_override' => '1',
          'formula' => '$ENV{DEBEMAIL} ;',
          'use_eval' => '1'
        },
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'email-updates',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'description' => 'Specify old email as key. The value is the new e-mail address that will be substituted',
        'index_type' => 'string',
        'summary' => 'email update hash',
        'type' => 'hash'
      },
      'dependency-filter',
      {
        'status' => 'deprecated',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'group-dependency-filter',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'index_type' => 'string',
        'status' => 'deprecated',
        'type' => 'hash'
      },
      'package-dependency-filter',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'index_type' => 'string',
        'status' => 'deprecated',
        'type' => 'hash'
      }
    ],
    'license' => 'LGPL2',
    'name' => 'Dpkg::Meta',
    'rw_config' => {
      'auto_create' => '1',
      'backend' => 'Dpkg::Meta'
    }
  }
]
;

