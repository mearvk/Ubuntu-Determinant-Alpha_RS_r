#!perl

use Test::More;

use DhMakePerl;

use FindBin qw($Bin);
use Dpkg::Changelog::Debian;

plan skip_all => "'no 'debian/changelog' found"
    unless -f "$Bin/../debian/changelog";

plan tests => 1;

my $cl = Dpkg::Changelog::Debian->new( range => { "count" => 1 } );
$cl->load("$Bin/../debian/changelog");

my $pkg_ver = $cl->[0]->get_version();
$pkg_ver =~ s/~.+//;        # ignore !foo suffix
$pkg_ver =~ s/\+.+$//;      # ignore +xxx suffix (e.g. +salsaci or +reallyxxx)
$pkg_ver =~ s/-[^-]+$//;    # ignore debian revision
is( $pkg_ver, $DhMakePerl::VERSION, 'Debian package version matches module version' );
