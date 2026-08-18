# -*- cperl -*-
use strict;
use warnings;
use 5.010;

use Test::More;   # see done_testing()
use Path::Tiny;
use Test::File::Contents;

use Dpkg::Copyright::Scanner qw/print_copyright/;


# global tests
my $dir = path('t/scanner/examples/') ;
my $temp = Path::Tiny->tempfile ;
my $suffix_re = qr/\.(in|d)$/;

foreach my $in (sort $dir->children($suffix_re)) {
    my $test_name = $in->basename($suffix_re);
    next if @ARGV and not grep { $test_name =~ /$_/; } @ARGV;
    note("scanning $test_name");
    my $out_name =  $test_name. '.out';
    my $out = $dir->child($out_name);
    my %from = $in->is_dir ? ( from_dir => $in ) : ( in => $in );
    print_copyright( %from, out => $temp , quiet => 1);

    files_eq_or_diff($out, $temp, "check $test_name copyright");
}


done_testing();
