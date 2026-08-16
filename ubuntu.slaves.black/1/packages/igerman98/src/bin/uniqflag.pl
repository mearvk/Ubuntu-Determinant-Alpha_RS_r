#!/usr/bin/perl

# 2002-05-05 Björn Jacke <bjoern@j3e.de>
#
# this script combines flags of equal base words from ispell/myspell:
#
# lachen/D
# lachen/IX
#
# ... will be converted to:
#
# lachen/DIX
#
# this is needed for myspell delivered with OO.o 1.0 which does only
# regard the first occurence of a base word, so lachen/IX would be
# ignored.
#
# Attention:
#
# adjektive.txt:bewiesen/AU
# verben.txt:bewiesen/WX
#
# this would lead to words like "unbewies" :-|


$first=<STDIN>;
chomp($first);
($firstbase,$firstflags)=split("/",$first);
while (<STDIN>) {
	chomp;
	($base,$flags) = split "/";
	if ($base eq $firstbase) {
		print STDERR "Duplicate base word: $base, flags: $firstflags and $flags\n";
		for (split "",$flags) {
			$firstflags .= $_ unless ($firstflags =~ $_);
		}
	} else { # a really new word is here ...
		$firstflags = "/$firstflags" if ($firstflags);
		print "$firstbase$firstflags\n";
		$firstbase = $base;
		$firstflags = $flags;
	}
}
$firstflags = "/$firstflags" if ($firstflags);
print "$firstbase$firstflags";
