# -*- cperl -*-
use warnings;
use strict;

BEGIN {
    # dirty trick to create a Memoize cache so that test will use this instead
    # of getting values through the internet
    no warnings 'once';
    %Config::Model::Dpkg::Dependency::cache = (
        'libarchive-extract-perl' => 'squeeze 0.65-1 jessie 0.68-1 sid 0.68-1',
        'perl-modules' => 'lenny 5.10.0-19lenny3 squeeze 5.10.1-17 sid 5.10.1-17 experimental 5.12.0-2 experimental 5.12.2-2',
        'perl' => 'squeeze 5.10.1-17 wheezy 5.14.2-21 jessie 5.18.1-3 sid 5.18.1-4',
        'debhelper' => 'etch 5.0.42 backports/etch 7.0.15~bpo40+2 lenny 7.0.15 backports/lenny 8.0.0~bpo50+2 squeeze 8.0.0 wheezy 8.1.2 sid 8.1.2',
        'libcpan-meta-perl' => 'squeeze 2.101670-1 wheezy 2.110580-1 sid 2.110580-1',
        'libmodule-build-perl' => 'squeeze 0.360700-1 wheezy 0.380000-1 jessie 0.400700-1 sid 0.400700-1',
        'xserver-xorg-input-evdev' => 'etch 1:1.1.2-6 lenny 1:2.0.8-1 squeeze 1:2.3.2-6 wheezy 1:2.3.2-6 sid 1:2.6.0-2 experimental 1:2.6.0-3',
        'lcdproc' => 'etch 0.4.5-1.1 lenny 0.4.5-1.1 squeeze 0.5.2-3 wheezy 0.5.2-3.1 sid 0.5.2-3.1',
        'libsdl1.2' => '', # only source
        'libmodule-metadata-perl' => 'wheezy 1.000009-1+deb7u1 jessie 1.000024-1 jessie-kfreebsd 1.000024-1 stretch 1.000024-1 sid 1.000024-1',
        'libextutils-parsexs-perl' => 'squeeze 2.220600-1 wheezy 3.150000-1 jessie-kfreebsd 3.240000-1 jessie 3.240000-1 stretch 3.240000-1 sid 3.240000-1',
        'libtest-simple-perl' => 'etch 0.62-1 lenny 0.80-1 backports/lenny 0.94-1~bpo50+1 squeeze 0.94-1 wheezy 0.98-1 sid 0.98-1',
        'dpkg' => 'squeeze 1.15 wheezy 1.16 sid 1.16',
        'libclass-isa-perl' => 'oldoldstable 0.36-3 oldstable 0.36-5 stable 0.36-5 testing 0.36-5 unstable 0.36-5 oldstable-kfreebsd 0.36-5',
        makedev => 'squeeze 2.3.1-89 wheezy 2.3.1-92 jessie 2.3.1-92 sid 2.3.1-93',
        udev => 'squeeze 164-3 wheezy 175-7.2 jessie 175-7.2 sid 175-7.2',
        'dh-autoreconf' => 'squeeze 2 wheezy 7 sid 7',
        'pkg-config' => 'oldoldstable 0.28-1 oldstable 0.29-4+b1 testing 0.29-6 unstable 0.29-6 stable 0.29-6',
        'autotools-dev' => 'squeeze 20100122.1 wheezy 20120608.1 jessie 20140911.1 sid 20140911.1',

        foobar => undef, # used to test that unknown package trigger a warning, real cache should not contain undef
        'libuv0.10-dev' => 'oldoldoldstable 0.10.28-6',
    );
    my $t = time ;
    do { $_ = "$t $_"} for grep {defined $_} values %Config::Model::Dpkg::Dependency::cache ;
}

use ExtUtils::testlib;
use Test::More ;
use Test::Memory::Cycle;
use Test::Differences;
use Config::Model ;
use Config::Model::Value ;
use Config::Model::Tester::Setup ;
use Log::Log4perl qw(:easy);
use Test::Log::Log4perl;
use Test::Warn ;
use Storable qw/dclone/;
use 5.10.0;

use feature qw/postderef signatures/;
no warnings qw/experimental::postderef experimental::signatures/;


my ($model, $trace) = init_test();
Test::Log::Log4perl->ignore_priority("info");

{
    no warnings qw/once/;

    $Config::Model::Dpkg::Dependency::use_test_cache = 1;

    if (@ARGV) {
        $::RD_HINT  = 1 if $ARGV[0] =~ /rdt?h/;
        $::RD_TRACE = 1 if $ARGV[0] =~ /rdh?t/;
    }
}

# extract installed version of debhelper
my $str = `/usr/bin/dpkg -l debhelper`;
my ($dh_version) = ($str =~ /ii\s+debhelper\s+(\d+)/);

my $control_text = <<'EOD' ;
Source: libdist-zilla-plugins-cjm-perl
Section: perl
Priority: optional
Build-Depends: debhelper, libsdl1.2, dpkg
Build-Depends-Indep: libcpan-meta-perl, perl (>= 5.10) | libmodule-build-perl,
Maintainer: Debian Perl Group <pkg-perl-maintainers@lists.alioth.debian.org>
Uploaders: Dominique Dumont <dominique.dumont@some.com>
Standards-Version: 4.1.2
Homepage: http://search.cpan.org/dist/Dist-Zilla-Plugins-CJM/

Package: libdist-zilla-plugins-cjm-perl
Architecture: all
Depends: ${misc:Depends}, ${perl:Depends}, libcpan-meta-perl ,
 perl (>= 5.10.1), dpkg (>= 0.01), perl-modules,  dpkg (<< ${source:Version}.1~)
Conflicts: libuv0.10-dev
Description: collection of CJM's plugins for Dist::Zilla
 Collection of Dist::Zilla plugins. This package features the 
 following [snip]
EOD

# pseudo root where config files are written by config-model
my $wr_dir = setup_test_dir();

my $deb = $wr_dir->child("debian");
$deb->mkpath;
my $control_file = $deb->child('control');
$control_file->spew($control_text) ;

# instance to check one dependency at a time
my $unit = $model->instance (
    root_class_name => 'Dpkg::Control',
    root_dir        => $wr_dir,
    instance_name   => "unittest",
);

my $wt = Test::Log::Log4perl->get_logger('User');

Test::Log::Log4perl->start();
my @expected_warnings =  (
    qr/source Standards-Version/,
    qr/is unknown/, qr/unnecessary/,
    qr/unnecessary/, ( qr/Dual dependency/),
    (qr/unnecessary/) x 2,
    qr/applied on too old package/,
);
map { $wt->warn($_); } @expected_warnings;
$unit->config_root->init ;
Test::Log::Log4perl->end("test BDI warn on unittest instance");

my $c_unit = $unit->config_root ;
my $dep_value = $c_unit->grab("binary:dummy Depends:0");

my @struct_2_dep = (
    [{}] => undef,
    [{ name => 'foo' }] => 'foo',
    [{ name => 'foo' }, { name => 'bar'}] => 'foo | bar',
    [{ name =>  'foo', dep => [ '>=' , '2.15']}] => 'foo (>= 2.15)',
    [{ name =>  'foo', dep => [ '>=' , '2.15'], arch => ['linux-i386', 'hurd']}]
    => 'foo (>= 2.15) [linux-i386 hurd]',
    [{ name =>  'foo', arch => ['linux-i386', 'hurd']}] => 'foo [linux-i386 hurd]',
    [{ name =>  'udev', arch => [ 'linux-any']},{ name => 'makedev', arch => [ 'linux-any']}]
    => 'udev [linux-any] | makedev [linux-any]',
    [{name => 'foo', profile => [ ['stage1', 'cross'] ]}]
    => 'foo <stage1 cross>',
    [{name => 'foo', profile => [ ['stage1', 'cross'], ['stage1'] ]}]
    => 'foo <stage1 cross> <stage1>',
    [{name => 'foo', profile => [ ['stage1', 'cross'], ['pkg.foo-src.yada-yada'] ]}]
    => 'foo <stage1 cross> <pkg.foo-src.yada-yada>',
);

while (@struct_2_dep) {
    my $data = shift @struct_2_dep ;
    my $str = shift @struct_2_dep ;
    is(
        $dep_value->struct_to_dep(@$data),
        $str,
        'test struct_to_dep -> "'. ( $str // '<undef>' ) . '"'
    ) ;
}

Test::Log::Log4perl->start();
$wt->warn(qr/better written/);
$dep_value->store('perl') ;
Test::Log::Log4perl->end("test warn on perl dep");

is($dep_value->fetch, 'perl', "check stored dependency value") ;

Test::Log::Log4perl->start();
$wt->warn( qr/unnecessary/ );
$dep_value->store('perl (  >= 5.6.0)') ;
Test::Log::Log4perl->end("test warn on perl dep with old version");

my ($res) = $dep_value->check_versioned_dep( {name => 'perl', dep => ['>=','5.6.0']} );
is( $res, 0, "check perl (>= 5.6.0) dependency: no older version");

# test that obsolete break type dependencies are removed (#871422)
($res) = $dep_value->check_versioned_dep(  {name => 'lcdproc', dep => [qw/<< 0.4.2/] } );
is( $res, 0, "check lcdproc (<< 0.4.2) dependency: removed");


# $dep_value->store('libcpan-meta-perl') ;
# exit ;
my @chain_tests = (
    # tag name for display, test data, expected result: 1 (good dep) or 0
    'libcpan-meta-perl'
        => [ { name => 'libcpan-meta-perl'}]
        => 1,

    'libcpan-meta-perl (>= 2.101550)'
        => [ { name => 'libcpan-meta-perl', dep => [qw/>= 2.101550/]}]
        => 1,

    'libmodule-build-perl perl 5.10' => [
        { name => 'perl', dep => [qw/>= 5.10/]},
        { name => 'libmodule-build-perl'}
    ] => 0,

    'libmodule-build-perl perl-modules 5.10' => [
        { name => 'perl-modules', dep => [qw/>= 5.10/]},
        { name => 'libmodule-build-perl'}
    ] => 0,

    # test Debian #719225
    'libarchive-extract-perl >= 0.68' => [
        { name => 'libarchive-extract-perl', dep => [qw/>= 0.68/]} ,
        { name => 'perl', dep => [qw/<< 5.17.9/]}
    ] => 0,

    'libarchive-extract-perl' => [
        { name => 'perl', dep => [qw/>= 5.17.9/] },
        { name => 'libarchive-extract-perl'}
    ] => 0,

    'module part of core perl forever' => [
        { name => 'libtest-simple-perl' }
    ] => 1,

    'triple alternate, perl at end' => [
        { name => 'libtest-simple-perl', dep => [qw/>= 1.001010/] },
        { name => 'libtest-use-ok-perl'},
        { name => 'perl', dep => [qw/>= 5.21.6/] }
    ] => 0,
  );

while (@chain_tests) {
    my ($tag,$dep,$expect) = splice @chain_tests,0,3;
    my @expect = grep { $_->{name} !~ /^perl/ } $dep->@*;
    my $ret = $dep_value->check_depend_chain (1, $dep);
    is($ret, $expect, "check dual life of $tag") ;
    eq_or_diff ($dep,\@expect,"check fixed value of alternate dep $tag");
}


my $inst = $model->instance (
    root_class_name => 'Dpkg::Control',
    root_dir        => $wr_dir,
    instance_name   => "deptest",
);

$inst->config_root->init ;

ok($inst,"Read $control_file and created instance") ;

my $control = $inst -> config_root ;

if ($trace) {
    my $dump =  $control->dump_tree ();
    print $dump ;
}

my $perl_dep = $control->grab("binary:libdist-zilla-plugins-cjm-perl Depends:3");
is($perl_dep->fetch,"perl (>= 5.10.1)","check dependency value from config tree");

$res = $perl_dep->check_versioned_dep({name => 'perl', dep => ['>=','5.28.1']}) ;
is($res,1,"check perl (>= 5.28.1) dependency: has older version");

($res) = $perl_dep->check_versioned_dep({ name =>'perl', dep =>['>=','5.6.0']}) ;
is($res,0,"check perl (>= 5.6.0) dependency: no older version");

subtest "check conflicts removal" => sub{
    my $conflict = $control->grab("binary:libdist-zilla-plugins-cjm-perl Conflicts:0");
    is($conflict->fetch,"libuv0.10-dev","check conflicts value from config tree");

    my @msgs;
    my %dep_info = ( name => 'libuv0.10-dev' );
    # check
    my $res = $conflict->check_or_fix_too_old_pkg(0, \%dep_info,undef, \@msgs ) ;
    is($res,1,"check libuv0.10-dev conflict: too old");
    like($conflict->warning_msg, qr/too old package/,"check warning message");

    # and fix
    $res = $conflict->check_or_fix_too_old_pkg(1, \%dep_info,undef, \@msgs ) ;
    is($res,1,"fix libuv0.10-dev conflict: too old");
    like($msgs[0], qr/too old package/,"check fix message");
    is(scalar %dep_info, 0, "conflict relation was removed by fix");
};

my $dpkg_dep = $control->grab("source Build-Depends:2");
is($dpkg_dep->fetch,"dpkg",'check dpkg value') ;
# test fixes
is($dpkg_dep->has_fixes,1, "test presence of fixes");
$dpkg_dep->apply_fixes;
is($dpkg_dep->has_fixes,0, "test that fixes are gone");

is($dpkg_dep->fetch,undef,'check fixed dpkg value') ;

$dpkg_dep = $control->grab("binary:libdist-zilla-plugins-cjm-perl Depends:4");
is($dpkg_dep->fetch,"dpkg (>= 0.01)",'check dpkg value with unnecessary versioned dep') ;
# test fixes
is($dpkg_dep->has_fixes,1, "test presence of fixes");
$dpkg_dep->apply_fixes;
is($dpkg_dep->has_fixes,0, "test that fixes are gone");
is($dpkg_dep->fetch,undef,'check fixed dpkg value') ;

Test::Log::Log4perl->start();
$wt->warn(    qr/unnecessary greater-than versioned/);
$perl_dep->store("perl ( >= 5.6.0 )") ;
Test::Log::Log4perl->end("check perl (>= 5.6.0) store: no older version warning");


my @msgs = $perl_dep->warning_msg ;
is(scalar @msgs,1,"check nb of warning with store with old version");
like($msgs[0],qr/unnecessary greater-than versioned dependency/,"check store with old version");

$control->load(q{binary:libdist-zilla-plugins-cjm-perl Depends:4="perl [!i386] | perl [amd64] "}) ;
ok( 1, "check_depend on arch stuff rule");

$control->load(
    "binary:libdist-zilla-plugins-cjm-perl ".
    q{Depends:5="xserver-xorg-input-evdev [alpha amd64 arm armeb armel hppa i386 ia64 lpia m32r m68k mips mipsel powerpc sparc]"}
);
ok( 1, "check_depend on xorg arch stuff rule");

$control->load(q{binary:libdist-zilla-plugins-cjm-perl Depends:6="lcdproc (= ${binary:Version})"});
ok( 1, "check_depend on lcdproc where version is a variable");

$control->load(q{binary:libdist-zilla-plugins-cjm-perl Depends:7="udev [linux-any] | makedev [linux-any]"});
ok( 1, "check_depend on lcdproc with 2 alternate deps with arch restriction");

# reset change tracker
$inst-> clear_changes ;

# test fixes
is($perl_dep->has_fixes,1, "test presence of fixes");
$perl_dep->apply_fixes;
is($perl_dep->fetch,'${perl:Depends}',"check fixed dependency value");
is(
    $control->grab_value("binary:libdist-zilla-plugins-cjm-perl Depends:7"),
    'udev [linux-any] | makedev [linux-any]',
    "test fixed alternate deps with arch restriction"
);
is($perl_dep->has_fixes,0, "test that fixes are gone");
is($perl_dep->has_warning,0,"check that warnings are gone");

is($inst->c_count, 2,"check that fixes are tracked with notify changes") ;
print scalar $inst->list_changes,"\n" if $trace ;

$control->load(q{binary:libdist-zilla-plugins-cjm-perl Depends:.push(mailx,foobar,dh-sequence-something)});
is($control->grab('binary:libdist-zilla-plugins-cjm-perl Depends:8')->has_warning,
    0, "check that _known_ virtual package don't trigger a warning");
is($control->grab('binary:libdist-zilla-plugins-cjm-perl Depends:9')->has_warning,
    1, "check that _unknown_ package do trigger a warning");
is($control->grab('binary:libdist-zilla-plugins-cjm-perl Depends:10')->has_warning,
    0, "check that _calculated_ virtual package don't trigger a warning");

# test dep list sort
{
    my $dep_list = $control->grab("binary:libdist-zilla-plugins-cjm-perl Depends");
    my @all = $dep_list->fetch_all_values;
    my @var = sort grep { /^\$/ } @all;
    my @others = sort grep { ! /^\$/ } @all;
    $dep_list->sort;
    eq_or_diff( [ $dep_list->fetch_all_values ], [@var, @others],"test sorted list content");
    # test against bug where sort behaved like reverse...
    $dep_list->sort;
    eq_or_diff( [ $dep_list->fetch_all_values ], [@var, @others],"test again sorted list content");
}


my $perl_bdi = $control->grab("source Build-Depends-Indep:1");

my $bdi_val ;
# since warnings were already issued during config_root->init, we don;t
# get warnings here;
Test::Log::Log4perl->start();
 $bdi_val = $perl_bdi->fetch ; 
Test::Log::Log4perl->end("check that no BDI warn are shown");

is($bdi_val,"perl (>= 5.10) | libmodule-build-perl","check B-D-I dependency value from config tree");
my $msgs = $perl_bdi->warning_msg ;
print "bdi warning: $msgs" if $trace ;
like($msgs,qr/Dual dependency on perl module should be removed/,"check store with old version: trap perl | libmodule");
like($msgs,qr/unnecessary greater-than versioned dependency/,"check store with old version: trap version");

$inst-> clear_changes ;

# test fixes
is($perl_bdi->has_fixes,2, "test presence of fixes");

{
    local $Config::Model::Value::nowarning = 1 ;
    $perl_bdi->apply_fixes;
    ok(1,"apply_fixes done");
}

is($perl_bdi->has_fixes,0, "test that fixes are gone");
is($perl_bdi->has_warning,0,"check that warnings are gone");

is($perl_bdi->fetch,"libmodule-build-perl","check fixed B-D-I dependency value");

print scalar $inst->list_changes,"\n" if $trace ;
is($inst->c_count, 1,"check that fixes are tracked with notify changes") ;

# test that obsolete break type dependencies are removed (#871422)
Test::Log::Log4perl->start();
$wt->warn(qr/unnecessary older-than versioned dependency/);
my $bin_breaks = $control->grab("binary:lcdproc-breaker Breaks");;
 $bin_breaks->fetch_with_id(0)->store('lcdproc (<< 0.4.2)');
Test::Log::Log4perl->end("Breaks with obsolete version triggers a warning");

# test fixes
is($bin_breaks->fetch_with_id(0)->has_fixes,1, "test presence of fixes");

{
    local $Config::Model::Value::nowarning = 1 ;
    $control->grab("binary:lcdproc-breaker")->apply_fixes;
    ok(1,"apply_fixes on Breaks done");
}
is($bin_breaks->has_fixes,0, "test that fixes are gone");
is($bin_breaks->has_warning,0,"check that warnings are gone");

is($bin_breaks->fetch_with_id(0)->fetch,undef ,"check fixed Breaks dependency value");

# the control object which is tested here was loaded with control data
# from line 90. Hence the generated URL must match the package name specified there
my $expected_warn_canonical = qr/URL is not the canonical one for repositories hosted on Debian infrastructure/;
my $expected_warn_invalid   = qr/URL is invalid, no support for this Vcs on Debian infrastructure anymore/;
my @vcs_tests = (
    [ 'Vcs-Browser', 'https://anonscm.debian.org/cgit/pkg-perl/packages/libdist-zilla-plugins-cjm-perl.git',
      'https://salsa.debian.org/perl-team/modules/packages/libdist-zilla-plugins-cjm-perl', $expected_warn_canonical ],
    [ 'Vcs-Arch',    'http://foo.debian.org/arch/arch/',undef, $expected_warn_invalid ],
    [ 'Vcs-Bzr',     'http://baz.debian.org/',undef, $expected_warn_invalid ],
    [ 'Vcs-Cvs',     'svn@cvs.alioth.debian.org:/cvsroot/',undef, $expected_warn_invalid ],
    [ 'Vcs-Git',     'http://salsa.debian.org/perl-team/modules/packages/libdist-zilla-plugins-cjm-perl.git','https://salsa.debian.org/perl-team/modules/packages/libdist-zilla-plugins-cjm-perl.git', qr/unencrypted/, $expected_warn_canonical ],
    [ 'Vcs-Git',     'git://salsa.debian.org/perl-team/modules/packages/libdist-zilla-plugins-cjm-perl.git','https://salsa.debian.org/perl-team/modules/packages/libdist-zilla-plugins-cjm-perl.git', qr/unencrypted/, $expected_warn_canonical ],
    [ 'Vcs-Hg',      'http://foo.debian.org/hg/foo',undef, $expected_warn_invalid ],
    [ 'Vcs-Svn',     'svn://foo.debian.org/svn/foo',undef, $expected_warn_invalid ],
);

foreach my $vt (@vcs_tests) {
    my ($elt, $urla, $urlb, @expected_warn) = @$vt;
    my $vcs = $control->grab("source $elt") ;

    Test::Log::Log4perl->start();
    map { $wt->warn($_); } @expected_warn;
    $vcs->store($urla) ;
    Test::Log::Log4perl->end("old URL triggers a warning on $elt");


    {
        local $Config::Model::Value::nowarning = 1 ;
        $vcs->apply_fixes;
        ok(1,"apply_fixes on $elt URL done");
    }
    is($vcs->fetch, $urlb,"fixed $elt URL (was $urla)") ;
}

sub new_instance {
    my $name = shift || die "missing instance name";

    # instance to check one dependency at a time
    my $unit = $model->instance (
        root_class_name => 'Dpkg',
        root_dir        => $wr_dir->child($name),
        instance_name   => $name,
    );
}

subtest "test debhelper compat interaction" => sub {
    # instance to check one dependency at a time
    my $unit = new_instance("compat-test");

    my $root = $unit->config_root;
    say $root->dump_tree if $trace;

    $root->load("compat=8 control source Build-Depends:0=debhelper");

    my $dh_obj = $root->grab("control source Build-Depends:0");

    # apply fixes
    $dh_obj->apply_fixes;
    $dh_obj->check(silent => 1);
    is(scalar $dh_obj->warning_msg,'',"no warnings afer fix");

    # bump debhelper
    $root->load("compat=9");

    # apply fixes again
    $dh_obj->apply_fixes;

    is($dh_obj->fetch,"debhelper-compat (= $dh_version)","test fixed debhelper value after compat change");
};

# need to get last debhelper version
subtest "test debhelper migration" => sub {
    my $unit = new_instance("debhelper-migration-test");
    my $root = $unit->config_root;
    $root->load('control source Standards-Version=4.1.1 ');
    my $bd0_path = 'control source Build-Depends:0';

    my $dhc_ok = "debhelper-compat (= $dh_version)";

    if (not $dh_version) {
        die "debhelper package is not installed";
    }

    my @tests = (
        [ undef, { name => "debhelper" } ],
        [ 8 , { name => "debhelper", dep => [ '>=', 8 ]} ],
        [ 8 , { name => "debhelper", dep => [ '>=', 7 ]} ],
        [ 10 , { name => "debhelper", dep => [ '>=', 10 ]} ],
    );

    my $compat = $root->grab('compat');
    my $bd0 = $root->grab($bd0_path);

    # check only debhelper dependency transformation
    foreach my $t (@tests) {
        my ($c, $dep) = $t->@*;
        if (defined $c) { $compat->store($c) } else { $compat->clear; }
        my $msgs = [];
        my $str = sprintf ("compat: %s dependency: '%s'", map { $_ // 'undef' } ($c, $bd0->struct_to_dep($dep)));
        $bd0->check_debhelper_version(1, $dep, $msgs);
        is($bd0->struct_to_dep($dep),$dhc_ok,"check dependency value from $str");
    }

    # perform more complete test
    $bd0->store("debhelper ( >= 8 )");
    $root->apply_fixes;
    is($bd0->fetch, $dhc_ok, "check dependency after apply_fixes");
};

subtest "test debhelper in Depends" => sub {
    my $unit = new_instance("debhelper-in-build-depend");
    my $root = $unit->config_root;
    $root->load('control source Standards-Version=4.1.1 ');
    my $dep_path = 'control binary:blah Depends:0';

    $root->load("$dep_path=debhelper");
    $root->apply_fixes;
    is($root->grab_value($dep_path), 'debhelper', "debhelper value in Depends is not changed");
};



# need to get last debhelper version
subtest "test debhelper-compat" => sub {
    my $unit = new_instance("debhelper-compat-test");
    my $root = $unit->config_root;
    $root->load('control source Standards-Version=4.1.1 ');
    my $bd0_path = 'control source Build-Depends:0';

    my $dhc_ok = { name => "debhelper-compat", dep => [ '=', $dh_version ]};
    my $dhc_ok_1 = { name => "debhelper-compat", dep => [ '=', $dh_version - 1]};

    if (not $dh_version) {
        die "debhelper package is not installed";
    }

    my @tests = (
        { name => "debhelper-compat" } ,
        { name => "debhelper-compat", dep => [ '=', 9 ]},
        $dhc_ok_1,
        $dhc_ok
    );

    my $bd0 = $root->grab($bd0_path);

    # check only debhelper dependency transformation
    foreach my $dep (@tests) {
        my $msgs = [];
        my $str = sprintf ("dependency: '%s'", $bd0->struct_to_dep($dep) // 'undef');
        $bd0->check_debhelper_compat_version(1, $dep, $msgs);
        my $expected = $dep->{dep}[1] == $dh_version - 1 ? $dhc_ok_1 : $dhc_ok;
        is_deeply($dep,$expected,"check dependency value from $str");
    }

    # perform more complete test
    $root->load("compat=8");
    $bd0->store("debhelper-compat ( = 8 )");
    $root->apply_fixes;
    is($bd0->fetch, $bd0->struct_to_dep($dhc_ok), "check dependency after apply_fixes");
    is($root->grab_value('compat'), undef, "check that compat is removed");
};

subtest "cleanup of autotools dependency" => sub {
    my $unit = new_instance("autotools-dependency-cleanup");
    my $root = $unit->config_root;
    $unit->initial_load_start;
    my $source_path = 'control source';
    my $source = $root->grab($source_path);
    $source->load(
        'Standards-Version=4.1.1 '
            . 'Build-Depends:0="dh-autoreconf" '
            . 'Build-Depends:1="pkg-config" '
            . 'Build-Depends:2="autotools-dev (>= 20180224.1)" '
            . 'Build-Depends:3="debhelper-compat (= 12)"'
        );
    $unit->initial_load_stop;

    # needs_check is set by warp, but the actual check is not yet done
    is($source->grab("Build-Depends:0")->has_warning,0,"no warning yet on dh-autoreconf");

    # check and fetch
    Test::Log::Log4perl->start();
    $wt->warn(qr/dependency "dh-autoreconf" is not necessary with debhelper > 10/);
    is($source->grab_value("Build-Depends:0"),"dh-autoreconf", "check dependency value");
    Test::Log::Log4perl->end("triggers a warning");

    # the warning is here
    is($source->grab("Build-Depends:0")->has_warning,1,"check warning of dh-autoreconf");

    $root->apply_fixes;

    is($source->grab_value("Build-Depends:0"),undef, "check dependency value");

    is_deeply(
        [$source->grab("Build-Depends")->fetch_all_values],
        ['pkg-config',"debhelper-compat (= 13)"],
        "check purged dependencies"
    );
};

memory_cycle_ok($model, "memory cycles");

done_testing;
