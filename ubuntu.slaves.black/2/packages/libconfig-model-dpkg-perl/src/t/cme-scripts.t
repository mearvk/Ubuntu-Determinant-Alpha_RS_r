# -*- cperl -*-
use strict;
use warnings;
use utf8;
use 5.10.1;
use open ':std', ':encoding(utf8)';

use Encode;

use Path::Tiny;
use Term::ANSIColor 2.01 qw(colorstrip);

use Test::More;
use Test::File::Contents;

BEGIN {
    # dirty trick to create a Memoize cache so that test will use this instead
    # of getting values through the internet
    no warnings 'once';
    %Config::Model::Dpkg::Dependency::cache = (
       'libconfig-model-perl' => 'squeeze 1.205-1 wheezy 1.244-1 sid 1.247-1',
       'libconfig-model-tester-perl' => 'squeeze 1.205-1 wheezy 1.244-1 sid 1.247-1',
    );
    my $t = time ;
    do { $_ = "$t $_"} for grep {defined $_} values %Config::Model::Dpkg::Dependency::cache ;

    $Config::Model::Dpkg::Dependency::use_test_cache = 1;
}

use App::Cmd::Tester;
use App::Cme ;
use Config::Model qw/initialize_log4perl/;
use Config::Model::Dpkg::Dependency;


# work around a problem in IO::TieCombine (used by App::Cmd::Tester)
# to avoid messing up output of stderr of tested command (See
# ACHTUNG!! notes in IO::TieCombine doc)
$\ = '';

my $arg = shift || '';
my ( $log, $show ) = (0) x 2;

my $trace = $arg =~ /t/ ? 1 : 0;

Config::Model::Exception::Any->Trace(1) if $arg =~ /e/;

## testing exit status

# pseudo root where config files are written by config-model
my $run_dir = path('.')->absolute;
my $wr_root = $run_dir->child('wr_root/cme-scripts');

# cleanup before tests
$wr_root -> remove_tree;

my $script_path
    = $ENV{AUTOPKGTEST_TMP}
    ? path('/usr/share/perl5/Config/Model/scripts')
    : path('lib/Config/Model/scripts')->absolute;

subtest "bump_dependency" => sub {
    my $work_dir   = $wr_root->child("bump_dep_1");
    my $debian_dir = $work_dir->child("debian");
    $debian_dir->mkpath({mode => oct(755)});
    my $script = $script_path->child("bump-dependency-version");

    # put control data in place
    my $control_file = $debian_dir->child("control");
    $run_dir->child('t/examples/config-model-systemd/control')->copy($control_file);
    chdir $work_dir->stringify;

    my @test_cmd = (
        run => $script->stringify,
        qw/--no-commit -arg pkg=libconfig-model-perl -arg version=3.456/
    );
    my $ok = test_app( 'App::Cme' => \@test_cmd );

    is( $ok->exit_code, 0, 'all went well' ) or diag("Failed command @test_cmd: ", $ok->error);
    my $regexp = qr/libconfig-model-perl \(>= 3.456\) <!nocheck>/;
    like($ok->stderr.'', $regexp, 'check changes on stderr' );
    is($ok->stdout.'', '', 'check: no message on stdout' );

    file_contents_like 'debian/control', $regexp, "updated dependency in file";
};

subtest "update_my_copyright_year" => sub {
    my $work_dir   = $wr_root->child("update_c_year");
    my $debian_dir = $work_dir->child("debian");
    $debian_dir->mkpath({mode => oct(755)});
    my $script =  $script_path->child("update-my-copyright-year");

    $ENV{DEBFULLNAME} = "Dominique Dumont";

    my $cop_lines = $run_dir
        ->child('t/examples/config-model-systemd/copyright')
        ->slurp_utf8;

    my @l = localtime;
    my $current_year = $l[5]+1900 ;
    my $old_year = $current_year - 1;
    $cop_lines =~ s/OLDYEAR/$old_year/eg;
    $cop_lines =~ s/CURRENT_YEAR/$current_year/eg;

    # put copyright data in place
    $debian_dir->child("copyright")->spew_utf8($cop_lines);
    chdir $work_dir->stringify;

    my @test_cmd = (
        run => $script->stringify,
        qw/--no-commit/
    );
    my $ok = test_app( 'App::Cme' => \@test_cmd );

    is( $ok->exit_code, 0, 'all went well' ) or diag("Failed command @test_cmd: ", $ok->error);
    my $regexp = qr/libconfig-model-perl \(>= 3.456\) <!nocheck>/;
    is($ok->stdout.'', '', 'check: no message on stdout' );

    my $new_cop = <<"EOF";
Copyright: 2015-$current_year, Dominique Dumont
 2015, $current_year, Dominique Dumont
 $current_year, Dominique Dumont
 2014-$current_year, Dominique Dumont
 2015,$current_year, Dominique Dumont
 $old_year-$current_year, Dominique Dumont
 2010, 2015, $current_year, Dominique Dumont
 2015-2017, $old_year-$current_year, Dominique Dumont
EOF
    file_contents_like 'debian/copyright', qr/$new_cop/, "updated copyright in file";
};

done_testing;

