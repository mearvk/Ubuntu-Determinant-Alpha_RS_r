#!/usr/bin/perl

# This script tests docbook2X by converting existing man pages
# to DocBook XML using Eric S. Raymond's doclifter,
# and then running docbook2man and docbook2texi on the result.
# 
# It will automatically log any syntactical errors, but other sorts
# of errors (i.e. incorrect rendering) will have to be found with 
# manual insepection.
# 
# You need to have installed both docbook2X and doclifter
# to run this script.
# 
# The option --mandir=n tells the script to go convert all the 
# man pages in section n that are presently installed on your 
# system.  Warning: this will take a very long time.
#

use strict;
use Getopt::Long;

my $mandir_sect = '';
my $tag = '';

my $res = GetOptions ("tag|t=s" => \$tag,               # tag for log filenames
                      "mandir=s" => \$mandir_sect);     
die if !$res;

$tag .= '-' if $tag ne '';

my @source_man_files = @ARGV;
if($mandir_sect ne '') {
    @source_man_files = glob("/usr/share/man/man${mandir_sect}/*");
} elsif(@ARGV == 0) {
    die "Please specify some test man pages\n";
}

open(DOCLIFTER_FAIL_LOG, ">>${tag}doclifter-fail.log")
    or die "can't open DOCLIFTER_FAIL_LOG: $!";

open(MAN_FAIL_LOG, ">>${tag}man-fail.log")
    or die "can't open MAN_FAIL_LOG: $!";

open(TEXI_FAIL_LOG, ">>${tag}texi-fail.log")
    or die "can't open TEXI_FAIL_LOG: $!";

open(GOOD_LOG, ">>${tag}good.log")
    or die "can't open GOOD_LOG: $!";

open(STDERR, "| tee -a ${tag}errors.log");


foreach my $s (@source_man_files)
{
    my $b = $1 if $s =~ /([^\.\/]+\.[1-8][a-zA-Z]*)(\.gz)?$/;   # base name
    my $x = "${b}.xml";
    my $m = "${b}";
    my $i = "${b}.info";

    print STDERR "<<<<<<<<<<< $s >>>>>>>>>>>>>>>\n";
    
    my $e = system2("zcat -f $s | doclifter > $x");
    if($e == 2) {
        unlink $x;
        next;
    } elsif($e != 0) {
        print DOCLIFTER_FAIL_LOG "$s\n";
        next;
    }
    
    if(system2("docbook2man --to-stdout $x > $m") != 0) {
        print MAN_FAIL_LOG "$s\n";
    }

    if(system2("docbook2texi --info --to-stdout $x > $i") != 0) {
        print TEXI_FAIL_LOG "$s\n";
    }

    print GOOD_LOG "$s\n";
}

close(DOCLIFTER_FAIL_LOG);
close(MAN_FAIL_LOG);
close(TEXI_FAIL_LOG);
close(GOOD_LOG);

sub system2
{
    system(@_);
    if ($? == -1) {
        die "failed to execute: $!\n";
    }
    elsif ($? & 127) {
        printf "child died with signal %d, %s coredump\n",
            ($? & 127),  ($? & 128) ? 'with' : 'without';
        return -1;
    }
    else {
        return $? >> 8;
    }
}
