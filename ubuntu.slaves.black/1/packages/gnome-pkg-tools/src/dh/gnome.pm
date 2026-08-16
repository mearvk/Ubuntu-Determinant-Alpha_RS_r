#!/usr/bin/perl

use warnings;
use strict;
use Debian::Debhelper::Dh_Lib;

insert_before("dh_icons", "dh_gnome");
insert_before("dh_compress", "dh_translations");
insert_after("dh_link", "dh_scour");
insert_before("dh_clean", "dh_gnome_clean");

1;
