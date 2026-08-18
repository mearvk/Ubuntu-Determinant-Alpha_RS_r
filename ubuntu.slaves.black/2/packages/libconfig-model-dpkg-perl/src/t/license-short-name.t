use strict;
use warnings;

use Config::Model;

use Config::Model::Tester::Setup qw/init_test setup_test_dir/;
use Path::Tiny;
use 5.10.0;

use Test::More;
use Test::Exception;
use Software::LicenseMoreUtils;
use Test::LongString;


my ($model, $trace, $opts) = init_test('rdhint','rdtrace');

{
    no warnings qw/once/;
    $::RD_HINT  = 1 if $opts->{rdhint};
    $::RD_TRACE = 1 if $opts->{rdtrace};
}

my $wr_dir = setup_test_dir();

$wr_dir->child("debian")->mkpath() ;

# instance to check one dependency at a time
my $root = $model->instance (
    root_class_name => 'Dpkg::Copyright',
    root_dir        => $wr_dir,
    instance_name   => "short-name-test",
)->config_root;

my $lic = $root->fetch_element('License');

my $gpl3_ex = "GPL-3+ with Font exception";
foreach my $name (qw/GPL-3+ GPL-2+ Artistic-2.0 BSD-3-clause Expat/, $gpl3_ex) {
    ok($lic->fetch_with_id($name),"fetch «$name» license object");
}

my $art_2_text = Software::LicenseMoreUtils->new_from_short_name({
    short_name =>'Artistic-2',
    holder => 'X. Ample'
})->summary_or_text;
chomp($art_2_text);
$art_2_text =~ s/\t/    /g;
$art_2_text =~ s!\n +\n!\n\n!g;
is_string($root->grab_value("License:Artistic-2 text"), $art_2_text, "check that license text was not reformatted");

# this license index is not a valid short name. But the check is done
# by short name object, not by this hash element
ok($lic->fetch_with_id("GPL-3+ with Font-exception-2.0"), "check license with bad font exception");

print $root->dump_tree if $trace;

my $short = $root->grab('Files:"etc/fonts/*" License short_name');
ok($short, "got short_name object");

foreach my $name ("GPL-3+",$gpl3_ex, "GPL-2+ or Artistic-2.0, and BSD-3-clause") {
    ok($short->store($name),"store «$name» short name");
}

my $andor = "BSD-3-clause and/or Expat";
is($short->has_warning,0,"short name triggers has no warning");
ok($short->store($andor),"store «$andor» short name");
ok($short->has_warning,"«$andor» short name triggered a warning");

throws_ok {
    $short->store("GPL-3+ with Font-exception-2.0");
} qr/does not match grammar from model/, "bad short name rejected when storing";

done_testing();
