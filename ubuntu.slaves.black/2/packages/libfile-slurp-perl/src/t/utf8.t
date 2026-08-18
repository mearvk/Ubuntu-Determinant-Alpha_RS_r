#!/usr/bin/perl
use Test::More;
use strict;
use File::Slurp;
use Encode qw/encode_utf8/;
use Digest::MD5 qw/md5_hex/;
use Devel::Peek;

BEGIN {
	plan skip_all => "Newer Perl doesn't like sysread with utf8 binmode"
			if $] >= 5.024000;
}

my $digest = 'e30ffef9b0c5623bc1ddd1ba73302f14';

my $utf8 = read_file("t/utf8.data", binmode => ":utf8");
my $latin = read_file("t/utf8.data");

ok(  Encode::is_utf8($utf8),  "Reading the data file with binmode options results in UTF8 encoded string");
ok(! Encode::is_utf8($latin), "Reading the data file without options correctly results in unencoded string");

my $ctx1 = new Digest::MD5;
   $ctx1->add(encode_utf8($utf8));  # encode_utf8 is needed, see http://search.cpan.org/dist/Digest-MD5/MD5.pm

ok($ctx1->hexdigest eq $digest, "The data from the data file we just read came through intact");


###
# Write to a tempfile and rest
###

my $fn_utf8  = "/tmp/file-slurp-utf8.txt";

write_file($fn_utf8, { binmode => ":utf8" }, $utf8);

open my $fh_utf8, "$fn_utf8" or die "Could not open $fn_utf8: $!\n";
my $ctx2 = new Digest::MD5;
   $ctx2->addfile($fh_utf8);

ok($ctx2->hexdigest eq $digest, "The data is written correctly with binmode options");

unlink($fn_utf8);

done_testing;
