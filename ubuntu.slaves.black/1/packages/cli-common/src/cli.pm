#!/usr/bin/perl
# debhelper sequence file for cli-common-dev scripts

use warnings;
use strict;
use Debian::Debhelper::Dh_Lib;

insert_after("dh_fixperms", "dh_clifixperms");

# have to use dh_installdeb as those scripts need to run for
# binary-arch and binary-indep packages
insert_before("dh_installdeb", "dh_clistrip");
insert_before("dh_installdeb", "dh_cligacpolicy");
insert_before("dh_installdeb", "dh_makeclilibs");
insert_before("dh_installdeb", "dh_installcligac");
insert_before("dh_installdeb", "dh_installcliframework");
insert_before("dh_installdeb", "dh_clideps");

1;
