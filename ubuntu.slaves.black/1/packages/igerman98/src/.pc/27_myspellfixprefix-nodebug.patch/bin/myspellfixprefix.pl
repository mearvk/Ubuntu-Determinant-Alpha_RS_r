#!/usr/bin/perl -w

# 2002-05-05 Björn Jacke <bjoern@j3e.de>
#
# script to expand prefixes of capital words to work around a myspell
# bug which would otherwise create words like "unTier" instead of "Untier"
#
# 2005-11-12 Bjoern Jacke <bjoern@j3e.de>
# Comment: hunspell can do decapitalization for this.

while (<STDIN>) {
	chomp;
	if (m/^[A-ZÄÖÜ].*\/.*[GUV]/) {
		print STDERR "Capital prefixes will be expanded: $_\n";
		
		($start,$rest) = split("",$_,2);
		$start =~  tr/A-ZÄÖÜ/a-zäöü/;
		$rest =~ s/(\/.*)U/$1/;
		$rest =~ s/(\/.*)V/$1/;
		$rest =~ s/(\/.*)G/$1/;
		$rest =~ s/\/$//;
		
		if (m/\/.*U/) {
			s/(\/.*)U/$1/;
			print "Un$start$rest\n";
		}
		if (m/\/.*V/) {
			s/(\/.*)V/$1/;
			print "Ver$start$rest\n";
		}
	}
	chop if (m/\/$/);
	print "$_\n";
}
