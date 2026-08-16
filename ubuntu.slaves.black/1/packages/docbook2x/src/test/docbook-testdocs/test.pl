#!/usr/bin/perl

# This script tests docbook2X using the DocBook test document
# suite from http://docbook.sourceforge.net/.
#
# Obtain the test suite, and copy all the *.xml files
# from the tests/ directory of the tarball to this directory.
# Then run this script.
#

use strict;
use Getopt::Long;

my $tag = '';
my $res = GetOptions ("tag|t=s" => \$tag);            # tag for log filenames
die if !$res;

my @source_xml_files = @ARGV;

if(@ARGV == 0) {
    @source_xml_files = glob("*.xml");
}

open(TEXI_FAIL_LOG, ">>${tag}texi-fail.log")
    or die "can't open TEXI_FAIL_LOG: $!";

open(GOOD_LOG, ">>${tag}good.log")
    or die "can't open GOOD_LOG: $!";

open(STDERR, "| tee -a ${tag}errors.log");

foreach my $s (@source_xml_files)
{
    my $b = $1 if $s =~ /([^\/]+)\.xml$/;
    my $i = "${b}.info";

    if($b =~ /^set\./) {
        # Ignore tests with the "set" element with DocBook;
        # they generate multiple files which will confuse
        # our processing
        next;
    }

    print STDERR "<<<<<<<<<<< $s >>>>>>>>>>>>>>>\n";
    
    if(system2("docbook2texi -g directory-description='nothing'" 
               . " --info --to-stdout $s > $i") != 0) {
        print TEXI_FAIL_LOG "$s\n";
    }

    print GOOD_LOG "$s\n";
}

close(DOCLIFTER_FAIL_LOG);
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
