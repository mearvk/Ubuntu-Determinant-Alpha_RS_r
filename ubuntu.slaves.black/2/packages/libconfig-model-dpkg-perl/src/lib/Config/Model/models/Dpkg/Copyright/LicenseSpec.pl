use strict;
use warnings;

return [
  {
    'accept' => [
      '.*',
      {
        'description' => 'license short_name. Example: GPL-1 LPL-2.1+',
        'type' => 'leaf',
        'value_type' => 'string'
      }
    ],
    'author' => [
      'Dominique Dumont'
    ],
    'class_description' => 'Stand-alone license paragraph. This paragraph is used to describe licenses which are used somewhere else in the Files paragraph.',
    'copyright' => [
      '2010',
      '2011 Dominique Dumont'
    ],
    'element' => [
      'text',
      {
        'compute' => {
          'allow_override' => '1',
          'formula' => 'require Software::LicenseMoreUtils ;
my $lic = &index( - ) ;
my $h = { short_name => $lic, holder => \'X. Ample\' } ;
my $text;

if (defined $lic and $lic) {
   # no need to fail if short_name is unknown
   eval {
       $text = Software::LicenseMoreUtils->new_from_short_name($h)->summary_or_text ;
   } ;
   if ($text) {
       # need to cleanup text to mimic cleanup done when copyright
       # data is read from file
       chomp($text);
       # cleanup tabs, not allowed by copyright spec
       $text =~ s!\\t!    !g;
       # cleanup empty lines (which are also cleaned up when writing file,
       # but this messes tests up)
       $text =~ s!\\n +\\n!\\n\\n!g;
   }
# FIXME: find a way to warn user if a license is unknown only when
# text is not set by another mean... may loop bad if not careful
#   if ($@ and ! $self->value_object->{data}) {
#       print "Cannot find license text for $lic\\n" ;
#   }
}

$text;',
          'undef_is' => '\'\'',
          'use_eval' => '1'
        },
        'description' => 'Full license text.',
        'type' => 'leaf',
        'value_type' => 'string',
        'warn_if_match' => {
          'can \\s+be\\s+found\\+in\\s+.?/usr/share/common-licenses/BSD' => {
            'fix' => '$_ = undef; # back to default value',
            'msg' => 'The copyright text refers to /usr/share/common-licenses/BSD which should no longer be used'
          },
          'fill license' => {
            'msg' => 'License contains copyright scanner boilerplate. Please update this field with the actual license text'
          }
        }
      }
    ],
    'license' => 'LGPL2',
    'name' => 'Dpkg::Copyright::LicenseSpec'
  }
]
;

