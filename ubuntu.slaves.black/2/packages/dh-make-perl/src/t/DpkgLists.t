#!/usr/bin/perl -w

use strict;
use warnings;

use Config;
use Test::More tests => 7;

BEGIN {
    use_ok 'Debian::DpkgLists';
};

my $m = 'Debian::DpkgLists';

my $perl_api = $Config{PERL_API_REVISION}.'.'.$Config{PERL_API_VERSION};

my $pkg_perl_modules = "perl-modules-$perl_api";
my $pkg_libperl = "libperl$perl_api";

my $split_perl_base = ( $perl_api ge '5.22' );

diag "Perl API is $perl_api";

is_deeply( [ $m->scan_full_path('/usr/bin/perl') ],
    ['perl-base'], '/usr/bin/perl is in perl-base' );

my @found = $m->scan_partial_path('/bin/perl');
ok( grep( 'perl-base', @found ), 'partial /bin/perl is in perl-base' );

@found = $m->scan_pattern(qr{/bin/perl$});
ok( grep( 'perl-base', @found ), 'qr{/bin/perl$} is in perl-base' );

is_deeply(
    [ $m->scan_perl_mod('Errno') ],
    $split_perl_base ? [$pkg_libperl, 'perl-base'] : ['perl-base'],
    "Errno is in $pkg_libperl or perl-base (or only perl-base for perl < 5.22)"
);

is_deeply(
    [ $m->scan_perl_mod('IO::Socket::UNIX') ],
    $split_perl_base ? [$pkg_libperl, 'perl-base'] : ['perl-base'],
    "IO::Socket::UNIX is in $pkg_libperl or perl-base (or only perl-base for perl < 5.22)"
);

is_deeply(
    [ $m->scan_perl_mod('utf8') ],
    $split_perl_base ? ['perl-base', $pkg_perl_modules] : ['perl-base'],
    "utf8 is in perl-base or $pkg_perl_modules (or only perl-base for perl < 5.22)"
);
