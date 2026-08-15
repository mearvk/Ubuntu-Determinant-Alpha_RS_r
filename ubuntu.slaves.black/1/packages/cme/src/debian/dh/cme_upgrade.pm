#!/usr/bin/perl

# (c) Dominique Dumont <dod@debian.org>

# This Debhelper addon will insert configuration upgrade instructions
# in Debian package. This upgrade will be performed by Config::Model

use warnings;
use strict;
use Debian::Debhelper::Dh_Lib;

# see /usr/share/doc/debhelper/PROGRAMMING.gz
insert_before("dh_install", "dh_cme_upgrade");


1;
