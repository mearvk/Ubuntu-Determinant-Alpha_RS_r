use strict;
use warnings;

return [
  {
    'element' => [
      'Upstream-Name',
      {
        'compute' => {
          'allow_override' => '1',
          'formula' => '$watch ? $source_name : undef;',
          'use_eval' => '1',
          'variables' => {
            'source_name' => '! control source Source',
            'watch' => '! watch'
          }
        }
      }
    ],
    'name' => 'Dpkg::Copyright'
  }
]
;

