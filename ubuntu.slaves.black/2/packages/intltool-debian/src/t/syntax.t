#!/usr/bin/perl -w

use strict;
use Test::More;

my @scripts = qw/intltool-extract intltool-merge intltool-update/;
plan tests => scalar @scripts;

for (@scripts) {
    my @out = grep !/syntax OK/, qx($^X -wc intltool-bin/$_ 2>&1);
    note(@out) if @out;
    ok( !$?, "$^X -wc $_ exited successfully" );
}
