#!/usr/bin/perl
# debhelper sequence file for dh_elpa script

use warnings;
use strict;
use Debian::Debhelper::Dh_Lib;
use Dpkg::Version;
use Module::Metadata;
use Config::Tiny;

insert_after("dh_install", "dh_elpa");

# check dh_make_perl version is new enough for dh_elpa_test
my $info = Module::Metadata->new_from_module("Debian::Control");
my $version = Dpkg::Version->new($info->version());

my $options;
$options = Config::Tiny->read( "debian/elpa-test" )
  if ( -f "debian/elpa-test" );

if ( $version >= "0.90"
     && !defined $options->{_}->{ "disable" }
     && !defined $ENV{ 'DH_ELPA_TEST_DISABLE' }
   ) {
    insert_after("dh_auto_test", "dh_elpa_test");
    remove_command("dh_auto_test");
}

1;
