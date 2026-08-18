use strict;
use warnings;

return [
  {
    'element' => [
      'preinst',
      {
        'description' => 'For details, see L<Debian Policy|https://www.debian.org/doc/debian-policy/#document-ch-maintainerscripts>',
        'summary' => 'script called before a package is unpacked',
        'type' => 'leaf',
        'value_type' => 'string'
      },
      'postinst',
      {
        'description' => 'For details, see L<Debian Policy|https://www.debian.org/doc/debian-policy/#document-ch-maintainerscripts>',
        'summary' => 'script called after a package is unpacked',
        'type' => 'leaf',
        'value_type' => 'string'
      },
      'prerm',
      {
        'description' => 'For details, see L<Debian Policy|https://www.debian.org/doc/debian-policy/#document-ch-maintainerscripts>',
        'summary' => 'script called before a package is removed',
        'type' => 'leaf',
        'value_type' => 'string'
      },
      'postrm',
      {
        'description' => 'For details, see L<Debian Policy|https://www.debian.org/doc/debian-policy/#document-ch-maintainerscripts>',
        'summary' => 'script called after a package is removed',
        'type' => 'leaf',
        'value_type' => 'string'
      }
    ],
    'name' => 'Dpkg::PackageScripts',
    'rw_config' => {
      'auto_create' => '1',
      'auto_delete' => '1',
      'backend' => 'Dpkg::DebHelperFile',
      'config_dir' => 'debian',
      'file' => '&element',
      'file_mode' => 'a+x'
    }
  }
]
;

