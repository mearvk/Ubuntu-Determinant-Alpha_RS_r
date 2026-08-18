# -*- cperl -*-

use ExtUtils::testlib;
use Test::More ;
use Test::Memory::Cycle;
use Config::Model ;
use Config::Model::Tester::Setup qw/init_test setup_test_dir/;
use Path::Tiny;
use Software::LicenseMoreUtils;
use Test::LongString;
use 5.10.0;

use warnings;
use strict;


my ($model, $trace) = init_test();

my $wr_dir = setup_test_dir();

$wr_dir->child("debian")->mkpath() ;

my $art_2_text = Software::LicenseMoreUtils->new_from_short_name({
    short_name =>'Artistic-2',
    holder => 'X. Ample'
})->summary_or_text;
$art_2_text =~ s/\t/    /g;
$art_2_text =~ s!\n +\n!\n\n!g;
chomp($art_2_text);

# instance to check one dependency at a time
my $inst = $model->instance (
    root_class_name => 'Dpkg::Copyright',
    root_dir        => $wr_dir,
    instance_name   => "create_test",
);

my $unit = $inst->config_root;

subtest 'Creation of debian/copyright' => sub {
    is($unit->instance->initial_load,0,"initial load is done");

    my $moarvm = path('t/scanner/examples/moarvm.in') ;
    $unit->update(in => $moarvm, quiet => 1);

    my $art2_obj = $unit->grab("License:Artistic-2.0 text");

    # should be undef
    my $default = $art2_obj->fetch() ;
    is_string($default,$art_2_text,"check license text brought by Software::License");
    is($art2_obj->fetch(mode => 'custom'),undef,'check lic text');
    is($art2_obj->fetch_custom,undef,'check lic text');

    # store identical text
    $unit->instance->initial_load_start;
    $art2_obj->store($default);
    $unit->instance->initial_load_stop;
    # custom text should still be undef
    is($art2_obj->fetch_custom,undef,'check lic text');

    $inst->write_back;
};

subtest 'Check "and/or" statement' => sub {
    my $inst = $model->instance (
        root_class_name => 'Dpkg::Copyright',
        root_dir        => $wr_dir,
        instance_name   => "readtest",
    );

    my $unit = $inst->config_root;

    # write a dummy license
    $unit->load(q!License:Dummy text="dummy license text"!);
    # and a dummy entry
    $unit->load(q!Files:"dummy.c" Copyright="2021 Dod" License short_name="Expat and/or Dummy"!);

    my @unused;
    $unit->grab("License")->check_unused_licenses([], \@unused);
    # check fix for a bug where Dummy license was not seen as a used
    # license in the short name above (because of the 'and/or' and the
    # fact that Dummy is only used there
    is(scalar @unused, 0, "all licenses are used");

    # check fix for a bug where Dummy license was removed because it
    # was only used above and was not seen as a used license in the
    # short name above.
    # This triggered a failure to write back copyright.
    $unit->apply_fixes;

    $inst->write_back;
};

subtest 'Read and check debian/copyright' => sub {

    my $inst = $model->instance (
        root_class_name => 'Dpkg::Copyright',
        root_dir        => $wr_dir,
        instance_name   => "readtest",
    );

    my $unit = $inst->config_root;

    my $art2_obj = $unit->grab("License:Artistic-2.0 text");

    # should be undef
    my $default = $art2_obj->fetch() ;
    is_string($default,$art_2_text,"check license text brought by Software::License");
    is($art2_obj->fetch_custom,undef,'check lic text');

    is(
        $unit->grab_value(q!Files:"dummy.c" License short_name!,),
        "Expat and/or Dummy",
        "check that 'and/or' statement"
    );
};

memory_cycle_ok($model, "memory cycles");

done_testing;
