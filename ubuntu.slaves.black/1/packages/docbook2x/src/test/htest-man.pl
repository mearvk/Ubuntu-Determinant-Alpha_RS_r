#!/usr/bin/perl

# Heuristic tests (necessary conditions) for a man page to be good.
#
# This script checks for:
# 1. the file ends in a newline 
#    (detects some cases where a man-page got cut off from a processing error)
# 2. no consecutive blank lines except in verbatim environments
# 3. whitespace is collapsed except in verbatim environments
#
# Synopsis:
#  htest-man.pl [man-page files...]
#
# Potential errors in the given files will be logged to standard output.
# The return status will be non-zero whenever they occur.

use strict;

unshift(@ARGV, '-') unless @ARGV;

my $has_error = 0;

foreach my $ARGV (@ARGV) {

  my $has_name = 0;
  my $has_description = 0;
  my $in_verbatim = 0;
  my $last_line_is_blank = 0;
  my $line_num = 0;
  my $newline_exists = 1;

  open(IN, $ARGV);

  while (<IN>) {
    $line_num++;

    if(chomp == 0) {
      print STDERR "$0:$ARGV:${line_num}: no newline at end of file\n";
      $has_error = 1;
    }

    $in_verbatim = 1  if /^.nf\s*$/;
    $in_verbatim = 0  if /^.fi\s*$/;

    # FIXME this doesn't work for non-English-language pages
    $has_name++        if /^.SH\s+NAME$/;
    $has_description++ if /^.SH\s+DESCRIPTION$/;

    unless($in_verbatim) {
      my $line_is_blank = ($_ =~ /^(.PP)?\s*$/);
      if($line_is_blank and $last_line_is_blank) {
        print STDERR "$0:$ARGV:${line_num}: duplicate blank line\n";
        $has_error = 1;
      }
      $last_line_is_blank = $line_is_blank or 
                              ($_ =~ /^(.SH|.SS|.TP)(\s.*)?$/);
    }

    unless($in_verbatim) {
      if(/[ \t]{2,}/) {
        print STDERR "$0:$ARGV:${line_num}: non-collapsed whitespace\n";
        $has_error = 1;
      }
    }

  }

  if($has_name == 0) {
    print STDERR "$0:$ARGV:${line_num}: no NAME section found\n";
    $has_error = 1;
  } elsif($has_name > 1) {
    print STDERR "$0:$ARGV:${line_num}: too many NAME sections found\n";
    $has_error = 1;
  }
  
  if($has_description == 0) {
    print STDERR "$0:$ARGV:${line_num}: no DESCRIPTION section found\n";
    $has_error = 1;
  } elsif($has_description > 1) {
    print STDERR "$0:$ARGV:${line_num}: too many DESCRIPTION sections found\n";
    $has_error = 1;
  }
}

exit $has_error;

