#!/usr/bin/perl
use strict;
use warnings;
use Debian::Debhelper::Dh_Lib;

insert_before('dh_gencontrol', 'dh_golang');

1
