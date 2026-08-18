use strict;
use warnings;

return [
  {
    'author' => [
      'Dominique Dumont'
    ],
    'class_description' => 'Represents a license that can be applied to the whole package. This element can be omitted.',
    'copyright' => [
      '2010',
      '2011 Dominique Dumont'
    ],
    'element' => [
      'short_name',
      {
        'description' => 'The Copyright and License fields in the header paragraph may complement but do not replace the files paragraphs. They can be used to summarise the contributions and redistribution terms for the whole package, for instance when a work combines a permissive and a copyleft license, or to document a compilation copyright and license. It is possible to use only License in the header paragraph, but Copyright alone makes no sense.',
        'grammar' => 'check:<rulevar: local $ok = 1 >
check: license(?) alternate(s?) <reject: $text or not $ok >
alternate: comma(?) oper license
comma: \',\'
oper: \'and\' | \'or\'
license: /[^\\s,]+/i
   { # PRD action to check if the license text is provided
     my $abbrev = $item[1] ;
     my $elt = $arg[0]->grab(step => "!Dpkg::Copyright License", mode => \'strict\', type => \'hash\') ;
     if ($elt->defined($abbrev) or $arg[0]->grab("- full_license")->fetch) {
        $ok &&= 1;
     }
     else {
        $ok = 0 ;
        my @known_licenses = $elt->fetch_all_indexes;
        my $expected
          = @known_licenses ? "Expected one of the current stand-alone License paragraphs: @known_licenses."
                            : "Did not find any stand-alone License paragraph.";
       ${$arg[1]} .= "license $abbrev is not declared in a stand-alone License paragraph. $expected";
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
        'type' => 'leaf',
        'value_type' => 'uniline',
        'warp' => {
          'rules' => [
            '&location !~ /Global/',
            {
              'mandatory' => '1'
            }
          ]
        }
      },
      'full_license',
      {
        'description' => 'if left blank here, the file must include a stand-alone License section matching each license short name listed on the first line (see the Standalone License Section section). Otherwise, this field should either include the full text of the license(s) or include a pointer to the license file under /usr/share/common-licenses. This field should include all text needed in order to fulfill both Debian Policy requirement for including a copy of the software distribution license, and any license requirements to include warranty disclaimers or other notices with the binary package.
',
        'type' => 'leaf',
        'value_type' => 'string'
      }
    ],
    'license' => 'LGPL2',
    'name' => 'Dpkg::Copyright::GlobalLicense'
  }
]
;

