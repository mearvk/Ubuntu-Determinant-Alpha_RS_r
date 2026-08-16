#!/usr/bin/perl

# This script tests docbook2X by mass-converting a set of XML DocBook
# documents to man pages and Texinfo documents.  The author
# uses this script on Doclifter-generated refentry documents.
#
# This script differs from ../doclifter/test.pl 
# in that it does not invoke doclifter directly
# (newer versions of doclifter has a mass conversion command,
# manlifter).  It also works much faster, as xsltproc and
# db2x_manxml/db2x_texixml are only loaded once for each
# set of documents.
# 
# It will automatically log any syntactical errors, but other sorts
# of errors (i.e. incorrect rendering) will have to be found with 
# manual insepection.  Timings of the conversion process 
# are also printed out.
# 
# To use this script, the following programs need to be installed:
#  * perl
#  * libxslt (xsltproc) XSLT processor
#  * xmllint from libxml2
#  * makeinfo from Texinfo package
#  * groff from GNU Troff package
#
# IMPORTANT:
# If the executables of docbook2X are not in the directory tree
# that this script lives, then you have to modify the paths below
# before running this script.
# 

use FindBin qw($RealBin);
my $db2x_home = "${RealBin}/../../";

# build directory if not the same as source dir.
my $db2x_build = $db2x_home; 

use strict;
use Getopt::Long;

my $mandir_sect = '';
my $tag = '';
my $type = 'man';
my $components = 'dxu';

Getopt::Long::Configure ("bundling");
my $res = GetOptions ("tag|t=s" => \$tag,         # tag for log filenames
                      "s=s" => \$type,
                      "c=s" => \$components);
die if !$res;

$tag = 'TEST' if $tag eq '';

open(STDERR, "| tee -a $tag.log");

my @dirs = @ARGV;

# Current timings; see process_timings subroutine
my $current_cutm = 0;
my $current_cstm = 0;

foreach my $dir (@dirs)
{
  $dir =~ s/\/$//;
#  my @sources = glob("$dir/*.xml");

  if($type eq 'man') {
  
    if($components =~ /d/) {
      # DocBook to Man-XML step
      my $cmd = "xsltproc --stringparam doctype-system ${db2x_home}dtd/Man-XML --stringparam path $dir ${db2x_home}test/mass/sep-man.xsl $dir/*.xml";
      my $err = system3($cmd);
      if($err) { next; }
    }
    if($components =~ /D/) {
      $ENV{db2x_dtd} = "${db2x_home}dtd/Man-XML";
      my $cmd = "xsltproc --stringparam lowercase-file 1 ${db2x_home}xslt/man/docbook.xsl $dir/*.xml | ${db2x_home}test/mass/collect-manpageset.sed > $dir/$tag.Mxml";
      my $err = system3($cmd);
      if($err) { next; }
    }

    if($components =~ /v/) {
      my $cmd = "xmllint --stream --valid $dir/*.mxml";
      my $err = system3($cmd);
      if($err) { next; }
    }
    if($components =~ /V/) {
      my $cmd = "xmllint --stream --valid $dir/$tag.Mxml";
      my $err = system3($cmd);
      if($err) { next; }
    }

    if($components =~ /x/) {
      # Man-XML to man pages step
      my $cmd = "${db2x_build}perl/db2x_manxml --list-files --output-dir=$dir --encoding=utf-8 $dir/*.mxml";
      my $err = system3($cmd);
      if($err) { next; }
    }
    if($components =~ /X/) {
      # Man-XML to man pages step
      my $cmd = "${db2x_build}perl/db2x_manxml --list-files --output-dir=$dir --encoding=utf-8 $dir/$tag.Mxml";
      my $err = system3($cmd);
      if($err) { next; }
    }
    
    if($components =~ /y/) {
      # DocBook to Man-XML step
      my $cmd = "xsltproc --stringparam output-dir $dir ${db2x_home}xslt/backend/db2x_manxml.xsl $dir/*.mxml";
      my $err = system3($cmd);
      if($err) { next; }
    }
    if($components =~ /Y/) {
      # DocBook to Man-XML step
      my $cmd = "xsltproc --stringparam output-dir $dir ${db2x_home}xslt/backend/db2x_manxml.xsl $dir/$tag.Mxml";
      my $err = system3($cmd);
      if($err) { next; }
    }
      
    if($components =~ /u/) {
      # utf8trans step
      my $cmd = "${db2x_build}utf8trans/utf8trans -m ${db2x_home}charmaps/roff.charmap $dir/*.[1-9]*";
      my $err = system3($cmd);
      if($err) { next; }
    }

    if($components =~ /g/) {
      # Test by running through groff
      my $cmd = "groff -t -Tutf8 -w all -man $dir/*.[1-9]* >$dir/$tag.g";
      my $err = system3($cmd);
      if($err) { next; }
    }
    
    if($components =~ /h/) {
      # Test by running through ../htest-man.pl
      my $cmd = "perl ${db2x_home}test/htest-man.pl $dir/*.[1-9]*";
      my $err = system3($cmd);
      if($err) { next; }
    }

  }

  elsif($type eq 'texi') {

    if($components =~ /d/) {
      # DocBook to Texi-XML step
      my $cmd = "xsltproc --stringparam doctype-system ${db2x_home}dtd/Texi-XML --stringparam path $dir ${db2x_home}test/mass/sep-texi.xsl $dir/*.xml";
      my $err = system3($cmd);
      if($err) { next; }
    }
    
    if($components =~ /v/) {
      my $cmd = "xmllint --stream --valid $dir/*.txml";
      my $err = system3($cmd);
      if($err) { next; }
    }

    if($components =~ /x/) {
      # Texi-XML to Info step
      my $cmd = "${db2x_build}perl/db2x_texixml --list-files --output-dir=$dir --encoding=utf-8//TRANSLIT $dir/*.txml";
      my $err = system3($cmd);
      if($err) { next; }
    }

    if($components =~ /u/) {
      # utf8trans step
      my $cmd = "${db2x_build}utf8trans/utf8trans -m ${db2x_home}charmaps/texi.charmap $dir/*.texi";
      my $err = system3($cmd);
      if($err) { next; }
    }
    
    if($components =~ /g/) {
      # Test by running through makeinfo
      my $cmd = "cd $dir && makeinfo --no-split *.texi";
      my $err = system3($cmd);
      if($err) { next; }
    }
  }

}

sub system3
{
  my $cmd = shift @_;
  print STDERR "<<< starting executing $cmd >>>\n";
  my $err = system2($cmd);
  my ($cutm,$cstm) = process_timings();
  print STDERR " user ${cutm}s, system ${cstm}s\n";
  if($err) {
    print STDERR "<<< error executing $cmd >>>\n\n";
  } else {
    print STDERR "<<< finished executing $cmd >>>\n\n";
  }
  return $err;
}


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

sub process_timings()
{
  # utm means "user time"
  # stm means "system time", etc.
  # 
  my ($utm,$stm,$new_cutm,$new_cstm) = times;

  my $last_cutm = $new_cutm - $current_cutm;
  my $last_cstm = $new_cstm - $current_cstm;

  $current_cutm = $new_cutm;
  $current_cstm = $new_cstm;

  return ($last_cutm, $last_cstm);
}

