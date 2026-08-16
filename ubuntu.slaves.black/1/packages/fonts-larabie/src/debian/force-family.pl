#!/usr/bin/perl
#
# Perl script parsing a defoma hint file and enforcing the fonts to
# use the foundry "LarabieFonts" and Priority to 10
#
while(<STDIN>) {
	next if (/^\s*Foundry\s*=/);  # Ignore existant foundries
	next if (/^\s*Priority\s*=/); # Ignore existant priorities
	if (/^\s*end\s*(\n|$)/) {
		print "  Priority = 10\n";
		print "  Foundry = LarabieFonts\n";
	}
	print $_;
}
