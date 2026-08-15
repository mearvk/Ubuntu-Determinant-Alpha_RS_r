#!/usr/bin/perl -w

use strict;
use Debian::Debhelper::Dh_Lib;

insert_after("dh_install", "dh_fortran_mod");

1;
