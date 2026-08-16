#!/usr/bin/perl
eval 'exec /usr/bin/perl -S $0 ${1+"$@"}'
	if $running_under_some_shell;

while ($ARGV[0] =~ /^-/) {
	$_ = shift;
	last if /^--/;
	if (/^-n/) {
	$nflag++;
	next;
	}
	die "I don't recognize this switch: $_\\n";
}
$printit++ unless $nflag;

$\ = "\n";	# automatically add newline on print

while (<>) {
	chop;
	s/a"/ä/g;
	s/A"/Ä/g;
	s/o"/ö/g;
	s/O"/Ö/g;
	s/u"/ü/g;
	s/U"/Ü/g;
	s/sS/ß/g;
	print if $printit;
}
