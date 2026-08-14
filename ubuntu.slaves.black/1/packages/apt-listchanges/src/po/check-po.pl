#!/usr/bin/perl

use strict;
use warnings;

# A simple perl script that checks if non-fuzzy translations in the passed po file:
# - have the same number of %s or %(something)s, and similar texts;
# - have balanced quote chars around the above texts.
# For simplicity the script uses Test::More module for comparisons.

use Test::More;
my $state=1; # 0 -start, 1 - skip, 2 - in msgid, 3 in msgstr
my $msgid="";
my $msgstr="";
$#ARGV == 0 or die "Usage $0 file.po\n";
my $file=$ARGV[0];

open (F, '<', $file) or die "Cannot open $file for reading: $!\n";


sub get_quotetype($$)
{
  my $front = shift;
  my $s = shift;
  my $c = "";
  if ($front and $s =~ /^\\"/)  { $c = 'quot'; }
  elsif ($front and $s =~ /^[\'\`]/) { $c = "apos"; }
  elsif ((not $front) and $s =~ /\\"$/) { $c = 'quot'; }
  elsif ((not $front) and $s =~ /[\'\`]$/) { $c = "apos"; }

  return $c;
}
sub get($)
{
  $_ = shift;
  my $line = $_;
  my $items = { 'nl' => 0 + scalar(s/\\n/ /g) };
  while (/%(\([^\)]+\))?[sdf]/) {
    ++$items->{$&};
    $_ = $';

    is_deeply(get_quotetype(0,$`), get_quotetype(1, $_), "Testing quote type $file:$.")
       || diag explain "msg: $line\n\n";
  }
  return $items;
}

sub check($$)
{
  my $msgid = shift;
  my $msgstr = shift;

  my $it1 = get($msgid);
  my $it2 = get($msgstr);
  is_deeply($it1, $it2, "Testing $file:$.") || diag explain "msgid: $msgid\nmsgstr: $msgstr\n\n";
}

while (<F>)
{
  if (/^\s*$/)
  {
    $state = 0;
    check($msgid, $msgstr) if $msgstr;
    $msgid = $msgstr = ""
  }
  $state=1 if /^#.*fuzzy/;
  next if $state == 1;
  next if /^#/;
  $state=2 if s/^msgid //;
  $state=3 if s/^msgstr //;
  s/^\s*"//;
  s/"\s*$//;
  $msgid .= $_ if $state == 2;	
  $msgstr .= $_ if $state == 3;	
}

check($msgid, $msgstr) if $msgstr;

done_testing();
