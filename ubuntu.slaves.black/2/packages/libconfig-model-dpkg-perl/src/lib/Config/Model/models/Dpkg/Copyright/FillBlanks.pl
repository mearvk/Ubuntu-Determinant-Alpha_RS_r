use strict;
use warnings;

return [
  {
    'element' => [
      'path',
      {
        'cargo' => {
          'config_class_name' => 'Dpkg::Copyright::FillBlanks::Pattern',
          'type' => 'node'
        },
        'description' => 'Patterns are matched from the beginning a path. I.e. C<share/websockify/> pattern will match C<share/websockify/foo.rb> but will not match C<web/share/websockify/foo.rb>. See L<Dpkg::Copyright::Scanner/"Filling the blanks"> for more details.',
        'index_type' => 'string',
        'summary' => 'Perl pattern to match file path',
        'type' => 'hash'
      }
    ],
    'name' => 'Dpkg::Copyright::FillBlanks',
    'rw_config' => {
      'auto_create' => '1',
      'auto_delete' => '1',
      'backend' => 'Yaml',
      'config_dir' => 'debian',
      'file' => 'fill.copyright.blanks.yml'
    }
  }
]
;

