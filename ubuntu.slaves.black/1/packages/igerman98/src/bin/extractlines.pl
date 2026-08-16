#!/usr/bin/perl
#
# Björn Jacke <bjoern@j3e.de>
#
# this script takes a sorted list of line numbers in a file as first argument
# and a file to extract this linenumbers from as second argument.

open(LINEFILE, "< $ARGV[0]") or die "Can't open lines file $ARGV[1]: $!\n";
open(GREPFILE, "< $ARGV[1]") or die "Can't open to-grep file $ARGV[2]: $!\n";

my $linecounter=0;
my $next_line=0;
while (<LINEFILE>) {
	$next_line=$_;
	while (<GREPFILE>) {
		$linecounter++;
		print "$_" and last if ($linecounter == $next_line);
	}
}
