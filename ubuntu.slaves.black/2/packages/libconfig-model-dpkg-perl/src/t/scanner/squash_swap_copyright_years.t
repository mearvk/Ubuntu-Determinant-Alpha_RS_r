# -*- cperl -*-
use strict;
use warnings;
use 5.010;

use Test::More;   # see done_testing()
use Test::Differences;
use YAML::XS;

require_ok( 'Dpkg::Copyright::Scanner' );
import Dpkg::Copyright::Scanner qw/__to_copyright_structure/;

# __pack_copyright tests
my @tests = (
    [
        'dir with squashable copyright',
        "---
pan:
  data:
    article-cache.cc: 4
    article-cache.h: 4
    article.cc: 6
    article.h: 6
    cert-store.cc: 5
    data.cc: 4
    data.h: 4
",
        "---
pan:
  data:
    article-cache.cc: 4
    article-cache.h: 4
    article.cc: 10
    article.h: 10
    cert-store.cc: 10
    data.cc: 4
    data.h: 4
"    ],
);

my @copyright_by_id = map { __to_copyright_structure(@$_) } (
    [ '2002, foo' , 'GPL' ],
    [ '2003, bar1', 'GPL' ],
    [ '2003, bar2', 'GPL' ],
    [ '2003, bar3', 'GPL' ],
    [ '2003, bar4', 'GPL' ],
    [ '2003, bar5', 'GPL' ],
    [ '2003, bar5', 'GPL' ],
    [ '2003, bar7', 'GPL' ],
    [ '2003, bar8', 'GPL' ],
    [ '2003, bar9', 'GPL' ]
);



foreach my $t (@tests) {
    my ($label,$in,$expect) = @$t;
    my $h = Load($in);
    my $info = Dpkg::Copyright::Scanner::__squash_copyrights_years(\@copyright_by_id);
    Dpkg::Copyright::Scanner::__swap_merged_ids($h, $info);
    eq_or_diff(
        $h,
        ref($expect) ? $expect : Load($expect),
        "__squash_copyrights_years $label"
    );
}


done_testing();
