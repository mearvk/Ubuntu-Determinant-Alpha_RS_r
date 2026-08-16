#!/usr/bin/perl

# Based on gen-fonts-dir.pl from package tipa packaged for Debian by 
# Rafael Laboissiere <rafael@debian.org>  Sun, 17 Nov 2002 15:07:57 +0100.
#
# Hacked to support .pfa files and add newline at end-of-file by
# Jonas Smedegaard <dr@jones.dk>  Fri, 13 Dec 2002 21:50:53 +0100.
#
# Hacked(!) to support sub-hints.

($fontdir, $linkdir, $scale, $hints) = @ARGV;

open (HINTS, "< $hints");
undef $/;
@dir = ();
map {
  m{/([^/]+)\.(pf[ab])};
  $file = $1;
  $file_ext = $2;
  if (/X-FontName = (.*)/) {
    $xfnt = $1;
    push @dir, "$file.$file_ext\t$xfnt";
#    $xfnt =~ s/silipa-1/adobe-fontspecific/;
#    push @dir, "$file.$file_ext\t$xfnt";
  }
  if (/X-FontName1 = (.*)/) {
    $xfnt = $1;
    push @dir, "$file.$file_ext\t$xfnt";
#    $xfnt =~ s/silipa-1/adobe-fontspecific/;
#    push @dir, "$file.$file_ext\t$xfnt";
  }
  if (/X-FontName2 = (.*)/) {
    $xfnt = $1;
    push @dir, "$file.$file_ext\t$xfnt";
#    $xfnt =~ s/silipa-1/adobe-fontspecific/;
#    push @dir, "$file.$file_ext\t$xfnt";
  }
  if (/X-FontName3 = (.*)/) {
    $xfnt = $1;
    push @dir, "$file.$file_ext\t$xfnt";
#    $xfnt =~ s/silipa-1/adobe-fontspecific/;
#    push @dir, "$file.$file_ext\t$xfnt";
  }
  if (/X-FontName4 = (.*)/) {
    $xfnt = $1;
    push @dir, "$file.$file_ext\t$xfnt";
#    $xfnt =~ s/silipa-1/adobe-fontspecific/;
#    push @dir, "$file.$file_ext\t$xfnt";
  }
  foreach $ext ("$file_ext", "afm") {
    system ("ln -fs $fontdir/$file.$ext $linkdir/$file.$ext\n");
  }
} split ("end\nbegin", <HINTS>);
close HINTS;

open (SCALE, ">$scale");
print SCALE scalar @dir, "\n", join ("\n", @dir);
print SCALE "\n";
close SCALE;
