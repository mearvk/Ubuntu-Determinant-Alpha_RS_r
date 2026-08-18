use strict;
use warnings;

return [
  {
    'class_description' => 'Contains the list of files to be installed by L<dh_install>',
    'element' => [
      'content',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline',
          'warn_if_match' => {
            '(^|\\s)/' => {
              'fix' => 's!(^|\\s)/!$1!g',
              'msg' => 'path should not begin with \'/\''
            }
          }
        },
        'description' => 'a file or files to install. The end of the line tells the directory it
should be installed in. The name of the files (or directories) to
install should be given relative to the current directory, while the
installation directory is given relative to the package build
directory. You may use wildcards in the names of the files to install
(in v3 mode and above).

Note that if you list exactly one filename or wildcard-pattern, with
no explicit destination, then dh_install will automatically guess the
destination to use, the same as if the --autodest option were used.

See L<debhelper(7)> and L<dh_install> for more details.
',
        'duplicates' => 'warn',
        'type' => 'list'
      }
    ],
    'name' => 'Dpkg::Install',
    'rw_config' => {
      'auto_create' => '1',
      'auto_delete' => '1',
      'backend' => 'Dpkg::DebHelperFile',
      'config_dir' => 'debian',
      'file' => '&element(-)'
    }
  }
]
;

