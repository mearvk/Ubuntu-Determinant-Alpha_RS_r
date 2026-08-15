#! /usr/bin/perl
# Copyright: © 2012 Enrico Tassi <gareuselesinge@debian.org>
# License: MIT/X
# Strongly based on the ruby build systems. Thanks Lucas!

use warnings;
use strict;
use Debian::Debhelper::Dh_Lib;

add_command("dh_auto_test","autopkgtest");
add_command_options("dh_compress", "-X.lua");
insert_after("dh_install", "dh_lua");

1
