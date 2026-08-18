# -*- cperl -*-

use ExtUtils::testlib;
use Test::More ;
use Test::Memory::Cycle;
use Config::Model ;
use Config::Model::Tester::Setup qw/init_test setup_test_dir/;
use Path::Tiny;
use 5.10.0;

use warnings;
use strict;


my ($model, $trace) = init_test();

my $wr_dir = setup_test_dir();

$wr_dir->child("debian")->mkpath() ;

# instance to check one dependency at a time
my $unit = $model->instance (
    root_class_name => 'Dpkg::Copyright',
    root_dir        => $wr_dir,
    instance_name   => "unittest",
)->config_root;

is($unit->instance->initial_load,0,"initial load is done");

my $pan = path('t/scanner/examples/pan.in') ;
$unit->update(in => $pan, quiet => 1);

my $gpl_text = $unit->grab("License:GPL-2 text");

# should be undef
my $default = $gpl_text->fetch() ;
like($default,qr/GNU/,"check license text brought by Software::License");
is($gpl_text->fetch(mode => 'custom'),undef,'check lic text');
is($gpl_text->fetch_custom,undef,'check lic text');

# store identical text
$unit->instance->initial_load_start;
$gpl_text->store($default);
$unit->instance->initial_load_stop;
# custom text should still be undef
is($gpl_text->fetch_custom,undef,'check lic text');

# re-test with a debian/pan.copyright-tweak file
# re-check som

memory_cycle_ok($model, "memory cycles");

done_testing;
