# -*- cperl -*-

use 5.10.0;

use ExtUtils::testlib;
use Test::More ;
use Test::Memory::Cycle;
use Config::Model ;
use Config::Model::Tester::Setup qw/init_test setup_test_dir/;
use Path::Tiny ;
use Test::Log::Log4perl;

use warnings;
use strict;

Test::Log::Log4perl->ignore_priority("info");

my ($model, $trace) = init_test();

# pseudo root where config files are written by config-model
my $wr_root = setup_test_dir();

# cleanup before tests

my $dpkg = $model->instance(
    root_class_name => 'Dpkg',
    root_dir        => $wr_root,
);

my $root = $dpkg->config_root ;
$dpkg->initial_load_stop;

my $opt = 'config\..*|configure|.*Makefile.in|aclocal.m4|\.pc' ;

# load mandatory values otherwise the exits on error during next test
$root->load("control source Maintainer=foo\@bar.com");

my @test = (
    [ "clean=foo,bar,baz",           'clean',         "foo\nbar\nbaz\n" ],
    [ 'source format="3.0 (quilt)"', 'source/format', "3.0 (quilt)\n" ],
    [
        qq!source options extend-diff-ignore="$opt"!, 'source/options',
        qq!extend-diff-ignore="$opt"\n!
    ],
);

my %files ;
foreach my $t (@test) {
    my ($load, $file, $content) = @$t ;
	$files{$file} = $content if $file;

	print "loading: $load\n" if $trace ;
	$root->load($load) ;

	$dpkg->write_back ;

	foreach my $f (keys %files) {
	    my $test_file = $wr_root->child('debian')->child($f) ;
	    ok($test_file->is_file ,"check that $f exists") ;
		my @lines = grep { ! /^#/ and /\w/ } $test_file->lines ;
		is(join('',@lines),$files{$f},"check $f content") ;
	}
}


Test::Log::Log4perl->start( );
my $ts = $root->grab_value("control source Testsuite");
Test::Log::Log4perl->end("check that undefined Testsuite does not warn for random maintainer");

my $tlogger = Test::Log::Log4perl->get_logger('User');

$ts = $root->grab("control source Testsuite");
foreach my $target (qw(elpa nodejs octave pif paf go dkms pouf perl python r ruby)) {
    if ($target =~ /^p\w+f$/) {
        Test::Log::Log4perl->start( );
        $tlogger->warn( qr/Unknown/ );
        $ts->store("autopkgtest-pkg-$target");
        Test::Log::Log4perl->end("checking that Testsuite is not accepted for autopkgtest-pkg-$target");
    }
    else {
        Test::Log::Log4perl->start( );
        $ts->store("autopkgtest-pkg-$target");
        Test::Log::Log4perl->end("checking that Testsuite is accepted for autopkgtest-pkg-$target");
    }
}


Test::Log::Log4perl->start( );
$tlogger->warn( qr/unknown value/i );
$root->load('control source Testsuite=autopkgtest-foobar');
Test::Log::Log4perl->end("check that a warning is emitted for unknown Testsuite value");

my @teams = (
    'Debian Perl Group <pkg-perl-maintainers@lists.alioth.debian.org>',
    'Debian Go Packaging Team <pkg-go-maintainers@lists.alioth.debian.org>',
    'Debian Ruby Extras Maintainers <pkg-ruby-extras-maintainers@lists.alioth.debian.org>',
);

foreach my $team (@teams) {
    # reset testsuite values, maintainer cannot be null, so use John Doe instead
    # of a packaging team that triggers a special behavior
    $root->load('control source Maintainer="John Doe <john@doe.com>" Testsuite~') ;
    my ($str) = ($team =~ /pkg-(perl|ruby|go)/);
    my $target =  "autopkgtest-pkg-$str";

    $root->load(qq!control source Maintainer="$team"!);
    is($root->grab_value("control source Testsuite"), undef, 'check Testsuite default value');
    $root->grab('control source Testsuite')->apply_fixes;

    is($root->grab_value("control source Testsuite"), $target, "check Testsuite $str output");
}

# perl vs ruby, requires that loop above does not finish with perl team
Test::Log::Log4perl->start( );
$tlogger->warn(qr/maintainer team/i);
$root->load('control source Testsuite=autopkgtest-pkg-perl');
Test::Log::Log4perl->end("check that a warning is emitted for Testsuite value mismatch");

$root->grab('control source Testsuite')->apply_fixes;
is($root->grab_value("control source Testsuite"), "autopkgtest-pkg-ruby",
    "check invalid Testsuite is replaced with team flavour");

# check that undef Testsuite does not trigger a warning if debian/test/control is present
# see #876856
my $tsc = $wr_root->child('debian/tests/control');
$tsc->parent->mkpath;
$tsc->spew("blah-blah");
Test::Log::Log4perl->start( );
$root->load("control source Testsuite~");
Test::Log::Log4perl->end('check that undefined Testsuite does not warn for random maintainer');

my $lic_text = $root->grab(steps => "copyright License:FooBar text", check => 'no');
is($lic_text->fetch, undef, "test unknown lic text") ;

say "store lic_text" if $trace ;
$lic_text->store("yada yada");

say "test stored lic_text" if $trace ;
is($lic_text->fetch, 'yada yada', "test specified lic text") ;

my $lic_gpl = $root->grab(step => "copyright License:GPL-1 text", check => 'no');
like($lic_gpl->fetch,qr!/usr/share/common-licenses/GPL-1!
     , "retrieved license text summary") ;


# test that a future standard-version does not trigger a warning. This
# may happen when updating a package while an old version of lintian
# is installed. See #932409

Test::Log::Log4perl->start( );
$tlogger->warn( qr/newer than lintian/i );
$root->load('control source Standards-Version=1000.1.1');
$root->apply_fixes;
is($root->grab_value('control source Standards-Version'), '1000.1.1',"Future standards version is not changed");
Test::Log::Log4perl->end("check that a warning is emitted for unknown Testsuite value");


memory_cycle_ok($model, "check memory cycles");

done_testing();
