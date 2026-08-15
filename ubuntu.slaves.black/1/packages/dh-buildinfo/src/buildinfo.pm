#!/usr/bin/perl
# debhelper addon script for dh-buildinfo
# written in 2016 by Daniel Stender <stender@debian.org>

use warnings;
use strict;
use Debian::Debhelper::Dh_Lib;

insert_after("dh_installdocs", "dh_buildinfo");

1
