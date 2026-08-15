#!/usr/bin/perl
# debhelper sequence file for cli-common-dev scripts

use warnings;
use strict;
use Debian::Debhelper::Dh_Lib;

insert_after("dh_auto_build", "dh_auto_build_nant");
insert_after("dh_auto_clean", "dh_auto_clean_nant");

remove_command("dh_auto_configure");
remove_command("dh_auto_build");
remove_command("dh_auto_test");
remove_command("dh_auto_clean");

1;
