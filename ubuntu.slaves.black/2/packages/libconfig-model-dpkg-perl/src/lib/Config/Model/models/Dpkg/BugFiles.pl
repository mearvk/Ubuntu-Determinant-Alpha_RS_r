use strict;
use warnings;

return [
  {
    'element' => [
      'bug-control',
      {
        'config_class_name' => 'Dpkg::BugFiles::Control',
        'description' => 'contains some directions for the bug reporting tool. See L<dh_bugfiles(1)|https://manpages.debian.org/jessie/debhelper/dh_bugfiles.1> man page.',
        'type' => 'node'
      },
      'bug-script',
      {
        'description' => 'script to be run by the bug reporting program for generating a bug report template. See L<dh_bugfiles(1)|https://manpages.debian.org/jessie/debhelper/dh_bugfiles.1> man page.',
        'type' => 'leaf',
        'value_type' => 'string'
      },
      'bug-presubj',
      {
        'description' => 'The contents of this file are displayed to the user by the bug reporting tool before allowing the user to write a bug report on the package to the Debian Bug Tracking System. See L<dh_bugfiles(1)|https://manpages.debian.org/jessie/debhelper/dh_bugfiles.1> man page.',
        'type' => 'leaf',
        'value_type' => 'string'
      }
    ],
    'name' => 'Dpkg::BugFiles',
    'rw_config' => {
      'auto_create' => '1',
      'auto_delete' => '1',
      'backend' => 'PlainFile',
      'config_dir' => 'debian',
      'file' => '&index(-).&element'
    }
  }
]
;

