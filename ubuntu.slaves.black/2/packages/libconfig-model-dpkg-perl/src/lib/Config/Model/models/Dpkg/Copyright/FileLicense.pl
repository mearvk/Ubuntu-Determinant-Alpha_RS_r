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
      'full_license',
      {
        'description' => 'if left blank here, the file must include a stand-alone License section matching each license short name listed on the first line (see the Standalone License Section section). Otherwise, this field should either include the full text of the license(s) or include a pointer to the license file under /usr/share/common-licenses. This field should include all text needed in order to fulfill both Debian Policy requirement for including a copy of the software distribution license, and any license requirements to include warranty disclaimers or other notices with the binary package.
',
        'type' => 'leaf',
        'value_type' => 'string',
        'warn_if_match' => {
          'fill license' => {
            'msg' => 'License contains copyright scanner boilerplate. Please update this field with the actual license text'
          }
        }
      },
      'short_name',
      {
        'description' => 'abbreviated name for the license. If empty, it is given the default 
value \'other\'. Only one license per file can use this default value; if there is more 
than one license present in the package without a standard short name, an arbitrary 
short name may be assigned for these licenses. These arbitrary names are only guaranteed 
to be unique within a single copyright file.

The name given must match a License described in License element in root node
',
        'grammar' => 'check: <rulevar: local $found = 0> <rulevar: local $ok = 1 >
check: license alternate(s?) <reject: $text or not $found or not $ok >
alternate: comma(?) license_association license
comma: \',\'
license_association: \'and/or\' | \'and\' | \'or\'
abbrev: /[^\\s,]+/
license_exception: \'with\' abbrev \'exception\' { join(\' \',@item[1..3]); }
license: abbrev license_exception(?)
   { # PRD action to check if the license text is provided
     my $short_name = $item[1] ;
	 $short_name .= \' \'.$item[2][0] if $item[2][0] ;
     $found++ ;
     my $elt = $arg[0]->grab(step => "!Dpkg::Copyright License", mode => \'strict\', type => \'hash\') ;
     if ($elt->defined($short_name) or $arg[0]->grab("- full_license")->fetch) {
        $ok &&= 1;
     }
     else {
     	 $ok = 0 ;
         my @known_licenses = $elt->fetch_all_indexes;
         my $expected = @known_licenses ? "Expected one of the current stand-alone License paragraphs: @known_licenses."
             : "Did not find any stand-alone License paragraph.";
         ${$arg[1]} .= "license \'$short_name\' is not declared in a stand-alone License paragraph. $expected" ;
         return undef;
     }
   } ',
        'help' => {
          'Apache' => 'Apache license. For versions, consult the Apache_Software_Foundation.',
          'Artistic' => 'Artistic license. For versions, consult the Perl_Foundation',
          'BSD-2-clause' => 'Berkeley software distribution license, 2-clause version',
          'BSD-3-clause' => 'Berkeley software distribution license, 3-clause version',
          'BSD-4-clause' => 'Berkeley software distribution license, 4-clause version',
          'CC-BY' => 'Creative Commons Attribution license',
          'CC-BY-NC' => 'Creative Commons Attribution Non-Commercial',
          'CC-BY-NC-ND' => 'Creative Commons Attribution Non-Commercial No Derivatives',
          'CC-BY-NC-SA' => 'Creative Commons Attribution Non-Commercial Share Alike',
          'CC-BY-ND' => 'Creative Commons Attribution No Derivatives',
          'CC-BY-SA' => 'Creative Commons Attribution Share Alike license',
          'CC0' => 'Creative Commons Universal waiver',
          'CDDL' => 'Common Development and Distribution License. For versions, consult Sun Microsystems.',
          'CPL' => 'IBM Common Public License. For versions, consult the IBM_Common_Public License_(CPL)_Frequently_asked_questions.',
          'EFL' => 'The Eiffel Forum License. For versions, consult the Open_Source_Initiative',
          'Expat' => 'The Expat license',
          'FreeBSD' => 'FreeBSD Project license',
          'GFDL' => 'GNU Free Documentation License',
          'GFDL-NIV' => 'GNU Free Documentation License, with no invariant sections',
          'GPL' => 'GNU General Public License',
          'ISC' => 'Internet_Software_Consortium\'s license, sometimes also known as the OpenBSD License',
          'LGPL' => 'GNU Lesser General Public License, (GNU Library General Public License for versions lower than 2.1)',
          'LPPL' => 'LaTeX Project Public License',
          'MPL' => 'Mozilla Public License. For versions, consult Mozilla.org',
          'Perl' => 'Perl license (equates to "GPL-1+ or Artistic-1")',
          'Python-CNRI' => 'Python Software Foundation license. For versions, consult the Python_Software Foundation',
          'QPL' => 'Q Public License',
          'W3C' => 'W3C Software License. For more information, consult the W3C IntellectualRights FAQ and the 20021231 W3C_Software_notice_and_license',
          'ZLIB' => 'zlib/libpng_license',
          'Zope' => 'Zope Public License. For versions, consult Zope.org'
        },
        'migrate_from' => {
          'formula' => '$replace{$alias}',
          'replace' => {
            'Perl' => 'Artistic or GPL-1+'
          },
          'variables' => {
            'alias' => '- - License-Alias'
          }
        },
        'type' => 'leaf',
        'value_type' => 'uniline',
        'warn_if_match' => {
          '(^|\\s)BSD-?[234](\\s|$)' => {
            'fix' => '# need to test if target exists before moving element
my $old = $_;
s/BSD-?(\\d)/BSD-$1-clause/;
my $lic = $self->grab(\'- - - License\');
# no check to avoid unused license warning (which is not yet moved)
my $text = $self->grab_value(steps => \'- full_license\', check => \'no\');
# likewise because check occurs before actual move
$lic->move($old,$_, check => \'no\') unless $text or $lic->defined($_);
',
            'msg' => 'Please use BSD-x-clause name, like BSD-3-clause'
          },
          '(^|\\s)MIT(\\s|$)' => {
            'fix' => '# need to test if target exists before moving element
my $lic = $self->grab(\'- - - License\');
# no check to avoid unused license warning (which is not yet moved)
my $text = $self->grab_value(steps => \'- full_license\', check => \'no\');
# likewise because check occurs before actual move
$lic->move($_,\'Expat\', check => \'no\') unless $text or $lic->defined(\'Expat\') ;
$_ = \'Expat\';
',
            'msg' => 'There are many versions of the MIT license. Please use Expat instead, when it matches. See L<Debian copyright format|https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/#license-specification> and L<wikipedia|https://en.wikipedia.org/wiki/MIT_License#Various_versions>for details.'
          },
          'UNKNOWN' => {
            'msg' => 'Unknown license: please add correct value or remove the File entry.'
          },
          'and/or' => {
            'msg' => 'licensecheck found an ambiguous license statement. Please:
- check the source code to find the actual license association
- override this value using "override-license" parameter in "debian/fill-copyright-blank.yml" file.
See "Filling the blanks" section in Dpkg::Copyright::Scanner(3pm) man page for details '
          }
        },
        'warp' => {
          'rules' => [
            '&location !~ /Global/',
            {
              'mandatory' => '1'
            }
          ]
        }
      }
    ],
    'license' => 'LGPL2',
    'name' => 'Dpkg::Copyright::FileLicense'
  }
]
;

