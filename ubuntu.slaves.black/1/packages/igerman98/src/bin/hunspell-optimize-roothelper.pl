#!/usr/bin/perl -w
#
# 2007 by Bjoern Jacke <bjoern@j3e.de>

# for the very special case where two homonyms exist in a sorted list and one
# of them has flags beginning with "h". Then we join the two homonyms and
# remove the h flag.

# This works with STDIN/STDOUT only.

my ($root,$prevroot,$flags,$prevflags,$flags_match_h,$prevflags_match_h,$flags_match_o,$prevflags_match_o) = "";
while (<STDIN>) {
	chomp;
	($prevroot,$prevflags,$prevflags_match_h,$prevflags_match_o) = ($root,$flags,$flags_match_h,$flags_match_o);
	#$root = $flags = $_;
	#$root =~ s/\/.*//;
	($root,$flags) = split("/");
	$flags="" unless ($flags);
	$root="" unless ($root);
	$flags_match_h = $flags_match_o = 0;
	if ($flags) {
		$flags_match_h = $flags =~ m/h/;
		$flags_match_o = ($flags =~ m/o/) or ($flags =~ m/^[A-ZÖÜÄ]/);
	}
	if (($root eq $prevroot) and (($flags_match_h) or ($prevflags_match_h)) and not ($flags_match_o or $prevflags_match_o)){
		if ($flags_match_h) {
			$flags =~ s/h//;
#			print STDERR "root $root: removed h\n"
		} elsif ($prevflags_match_h) {
			$prevflags =~ s/h//;
		} else {
			die "should not match neither flags_match_h nor prevflags_match_h!";
		}
#		print STDERR "OLD: $flags\n";
		$flags = $prevflags.$flags;
#		print STDERR "NEW: $flags\n";
	} else {
		if($prevroot) {
			print "$prevroot",$prevflags?"/$prevflags":"","\n";
		}
	}
}
print "$root",$flags?"/$flags":"","\n";
