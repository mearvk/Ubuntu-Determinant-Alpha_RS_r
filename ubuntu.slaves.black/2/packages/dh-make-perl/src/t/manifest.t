#!/usr/bin/perl -w

use Test::More;

plan skip_all => "This is a release-time test" unless $ENV{RELEASE_TESTING};

eval 'use Test::DistManifest';
if ($@) {
  plan skip_all => 'Test::DistManifest required to test MANIFEST';
}

unless ( -e 'MANIFEST' ) {
    plan skip_all => 'MANIFEST testing skipped due to missing MANIFEST file';
}

manifest_ok();
