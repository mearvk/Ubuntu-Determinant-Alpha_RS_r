use strict;
use warnings;

return [
  {
    'element' => [
      'check',
      {
        'config_class_name' => 'Dpkg::Copyright::ScanPatterns::Lists',
        'description' => 'Files matching any of these patterns will be scanned by L<licensecheck>. See L<Dpkg::Copyright::Scanner/"electing or ignoring files to scan">',
        'type' => 'node'
      },
      'ignore',
      {
        'config_class_name' => 'Dpkg::Copyright::ScanPatterns::Lists',
        'description' => 'Files matching any of these patterns will be ignored by L<licensecheck>. See L<Dpkg::Copyright::Scanner/"electing or ignoring files to scan">',
        'type' => 'node'
      }
    ],
    'name' => 'Dpkg::Copyright::ScanPatterns',
    'rw_config' => {
      'auto_create' => '1',
      'auto_delete' => '1',
      'backend' => 'Yaml',
      'config_dir' => 'debian',
      'file' => 'copyright-scan-patterns.yml'
    }
  }
]
;

