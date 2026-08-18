# -*- cperl -*-
use strict;
use warnings;
use 5.010;

use Test::More;                 # see done_testing()
use Test::Differences;
use YAML::XS;

use Dpkg::Copyright::Scanner qw/__to_copyright_structure __from_copyright_structure/;

# __pack_copyright tests
my $copyrights_yml = q!---
-
  - unknown
  - unknown
-
  - '2007-2011, Daniel Adler <dadler@uni-goettingen.de>'
  - ISC
-
  - '2007-2015, Daniel Adler <dadler@uni-goettingen.de>'
  - ISC
-
  - '2013, Daniel Adler <dadler@uni-goettingen.de>'
  - ISC
-
  - '2015, Daniel Adler <dadler@uni-goettingen.de>'
  - ISC
-
  - '2014, 2015, Masanori Mitsugi <mitsugi@linux.vnet.ibm.com>'
  - ISC
-
  - '2013-2015, Daniel Adler <dadler@uni-goettingen.de>'
  - ISC
...
!;

my $copyright_data = Load($copyrights_yml);

my @tests = (
    [
        'dir with one file',
        "---
data-impl:
  defgroup.h: 1
",
        $copyright_data,
        { '*' => '1', 'data-impl' => { '.' => 1 } },
        $copyright_data,

    ],

    [
        'dir with several files',
        "---
pan:
  data:
    article-cache.cc: 4
    article-cache.h: 4
    article.cc: 4
    article.h: 4
    cert-store.cc: 5
    cert-store.h: 5
    data.cc: 4
    data.h: 4
",
        $copyright_data,
 "---
'*': '4'
pan:
  '.': '4'
  data:
    '.': '4'
    cert-store.cc: '5'
    cert-store.h: '5'
",
        $copyright_data,
    ],
    [
        'dir with subdirs',
        "---
pan:
  data:
    article-cache.cc: 4
    article-cache.h: 4
    article.cc: 4
    article.h: 4
    cert-store.cc: 5
    cert-store.h: 5
    data.cc: 4
    data.h: 4
uulib:
  crc32.c: 2
  crc32.h: 1
  fptools.c: 1
  fptools.h: 1
  uucheck.c: 6
  uudeview.h: 6
  uuencode.c: 6
  uuint.h: 6
",
        $copyright_data,
        "---
'*': '4'
pan:
  '.': '4'
  data:
    '.': '4'
    cert-store.cc: '5'
    cert-store.h: '5'
uulib:
  '*': '6'
  crc32.c: '2'
  crc32.h: '1'
  fptools.c: '1'
  fptools.h: '1'
",
        $copyright_data,
    ],
    [
        'dir with README file',
        "---
pan:
  README: 4
  article-cache.cc: 4
  cert-store.cc: 5
  cert-store.h: 5
  cert-store2.cc: 5
  cert-store2.h: 5
",
        $copyright_data,
        {
            '*' => 4,
            pan => {
                '.' => 4,
                'cert-store.cc' => 5,
                'cert-store.h' => 5,
                'cert-store2.cc' => 5,
                'cert-store2.h' => 5,
            }
        } ,
        $copyright_data,
    ],
    [
        'dir with README file',
        "---
pan:
  README: 4
  article-cache.cc: 4
  cert-store.cc: 5
  cert-store.h: 5
  cert-store2.cc: 5
  cert-store2.h: 5
",
        $copyright_data,
        {
            '*' => 4,
            pan => {
                '.' => 4,
                'cert-store.cc' => 5,
                'cert-store.h' => 5,
                'cert-store2.cc' => 5,
                'cert-store2.h' => 5,
            }
        } ,
        $copyright_data,
    ],
    [
        'dir with README file and matching license file',
        "---
pan:
  README: 4
  LICENSE: 4
  article-cache.cc: 4
  cert-store.cc: 5
  cert-store.h: 5
  cert-store2.cc: 5
  cert-store2.h: 5
",
        $copyright_data,
        {
            '*' => 4,
            pan => {
                '.' => 4,
                'cert-store.cc' => 5,
                'cert-store.h' => 5,
                'cert-store2.cc' => 5,
                'cert-store2.h' => 5,
            }
        } ,
        $copyright_data,
    ],
);

my $new_copyright_data = Load($copyrights_yml);
push $new_copyright_data->@*, [
    "2014, 2015, Masanori Mitsugi <mitsugi\@linux.vnet.ibm.com>\n"
        . "2015, Daniel Adler <dadler\@uni-goettingen.de>",
    'ISC'
];

push @tests,
    [
        'dir with README file and not matching license file',
        "---
pan:
  README: 4
  LICENSE: 5
  article-cache.cc: 4
  cert-store.cc: 5
  cert-store.h: 5
  cert-store2.cc: 5
  cert-store2.h: 5
",
        $copyright_data,
        {
            '*' => 7,
            pan => {
                '.' => 7,
                README => 4,
                'article-cache.cc' => 4,
                'cert-store.cc' => 5,
                'cert-store.h' => 5,
                'cert-store2.cc' => 5,
                'cert-store2.h' => 5,
            }
        } ,
        $new_copyright_data,
    ];

=head 1
        "
---
'*': 0
pan:
  '*': 4
  data:
    cert-store.cc: 5
    cert-store.h: 5
    defgroup.h: 1
    parts.cc: 3
    parts.h: 3
  data-impl:
    defgroup.h: 1
  general:
    debug.cc: 1
    defgroup.h: 1
    e-util.cc: 8
    e-util.h: 8
  gui:
    action-manager.h: 1
    defgroup.h: 1
    e-action-combo-box.c: 18
    e-action-combo-box.h: 18
    e-charset-combo-box.c: 17
    e-charset-combo-box.h: 17
  icons:
    '*': 4
",
        [
            [ 0,'*'                                                             ],
            [ 4,'pan/*'                                                         ],
            [ 5,'pan/data/cert-store.cc','pan/data/cert-store.h'                ],
            [ 1,'pan/data/defgroup.h'                                           ],
            [ 3,'pan/data/parts.cc','pan/data/parts.h'                          ],
            [ 1,'pan/data-impl/defgroup.h'                                      ],
            [ 1,'pan/general/debug.cc','pan/general/defgroup.h'                 ],
            [ 8,'pan/general/e-util.cc','pan/general/e-util.h'                  ],
            [ 1,'pan/gui/action-manager.h','pan/gui/defgroup.h'                 ],
            [ 18,'pan/gui/e-action-combo-box.c','pan/gui/e-action-combo-box.h'  ],
            [ 17,'pan/gui/e-charset-combo-box.c','pan/gui/e-charset-combo-box.h'],
            [ 4,'pan/icons/*'                                                   ],
        ]
    ],

=cut


foreach my $t (@tests) {
    my ($label,$in,$copyright_in, $expect, $expected_copyright) = @$t;

    my @copyright_struct = map { __to_copyright_structure(@$_); } $copyright_in->@*;
    my $res = Dpkg::Copyright::Scanner::__squash_tree_of_copyright_ids(Load($in), \@copyright_struct);
    eq_or_diff( $res,  ref($expect) ? $expect : Load($expect),"__squash_tree_of_copyright_ids $label");
    my @copyright_out = map { [ __from_copyright_structure($_) ] } @copyright_struct;
    eq_or_diff( \@copyright_out, $expected_copyright, "__squash_tree_of_copyright_ids $label copyright check");
}


done_testing();
