# -*- cperl -*-
use strict;
use warnings;
use 5.010;

use Test::More;   # see done_testing()
use Test::Differences;
use YAML::XS;
use Dpkg::Copyright::Scanner qw/__from_copyright_structure __to_copyright_structure/;

use feature qw/postderef signatures/;
no warnings qw/experimental::postderef experimental::signatures/;

require_ok( 'Dpkg::Copyright::Scanner' );


# __pack_copyright tests
my @tests = (
    [
        'dir with squashable copyright',
        q!---
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
!,
        [undef,7,7,7,7,undef,7],
        [ [ '2007-2015, Daniel Adler <dadler@uni-goettingen.de>', 'ISC'] ]
    ],
    [
        'dir with slight diff in copyright',
        q!---
# id 0 is not used
-
  - unknown
  - unknown
-
  - '2008-2017, GNUstep Application Project'
  - 'LPGL-2+'
-
  - '2005-2016 GNUstep Application Project'
  - 'LPGL-2+'
...
!,
        [ undef, 3, 3 ],
        [ ['2005-2017, GNUstep Application Project', 'LPGL-2+' ] ]
    ],
);

foreach my $t (@tests) {
    my ($label,$in,$expected_indexes, $expected_data) = @$t;
    my $copyrights_data = Load($in);
    my @copyrights_by_id = map { __to_copyright_structure($_->@*); } $copyrights_data->@*;
    my $info = Dpkg::Copyright::Scanner::__squash_copyrights_years(\@copyrights_by_id);
    eq_or_diff(
        $info,
        ref($expected_indexes) ? $expected_indexes : Load($expected_indexes),
        "__squash_copyrights_years $label"
    );

    # check coaslesced entries
    my @expected_additions = map { __to_copyright_structure($_->@*); } $expected_data->@*;
    my @new_indexes = @copyrights_by_id[ scalar $copyrights_data->@* .. $#copyrights_by_id ] ;
    eq_or_diff(
        \@new_indexes,
        \@expected_additions,
        "__squash_copyrights_years $label checked new copyright entries"
    )
}


done_testing();
