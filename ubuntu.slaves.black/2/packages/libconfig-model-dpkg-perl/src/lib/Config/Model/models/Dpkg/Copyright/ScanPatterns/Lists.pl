use strict;
use warnings;

return [
  {
    'element' => [
      'suffixes',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'description' => 'Files matching any of these suffixes will be scanned by L<licensecheck>. Do not specify the dot with the suffixes (e.g. enter "jpg" and not ".jpg"). Default suffixes of L<licensecheck> will also be used. See L<Dpkg::Copyright::Scanner/"Selecting or ignoring files to scan">',
        'type' => 'list'
      },
      'pattern',
      {
        'cargo' => {
          'type' => 'leaf',
          'value_type' => 'uniline'
        },
        'description' => 'Files matching any of these patterns will be scanned by L<licensecheck>. See L<Dpkg::Copyright::Scanner/"electing or ignoring files to scan">',
        'type' => 'list'
      }
    ],
    'name' => 'Dpkg::Copyright::ScanPatterns::Lists'
  }
]
;

