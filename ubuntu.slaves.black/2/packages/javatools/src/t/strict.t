#!/usr/bin/perl -w

use strict;
use warnings;

use Test::More;
eval 'use Test::Strict';
plan skip_all => 'Test::Strict required to run this test' if $@;

my @FILES = qw(
  jh_compilefeatures
  jh_exec
  jh_generateorbitdir
  jh_installeclipse
  jh_installjavadoc
  jh_installlibs
  jh_linkjars
  jh_manifest
  jh_classpath
  jh_scanjavadoc
  jh_setupenvironment
);

for my $file (@FILES) {
    syntax_ok($file);
    strict_ok($file);
}

all_perl_files_ok('lib');
