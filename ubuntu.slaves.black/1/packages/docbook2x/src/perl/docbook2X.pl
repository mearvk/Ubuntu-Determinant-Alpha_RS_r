# vim:sw=4 sta et showmatch
 
# docbook2X.pl - script to invoke man page or Texinfo conversion
#                (See docbook2X documentation for details)
#
# (C) 2003-2004 Steve Cheng <stevecheng@users.sourceforge.net>
#
# See the COPYING file in the docbook2X distribution
# for the copyright status of this software.
#
# Note: docbook2X.pl does not run by itself!
#       It must be configured by including a config.pl file
#       which is done when building docbook2X.

use strict;

my @xsltproc_opts;
my @xml_opts;

while(my $opt = shift @ARGV)
{
    if($opt eq '--help') {
        print_help();
        exit(0);
    } 
    elsif($opt eq '--version') {
        print_version();
        exit(0);
    } 
    elsif($opt =~ /^--((sym-?|so-?|no-?)links|no-groff-extensions|compatible|list-files|to-stdout|info|plaintext)$/) {
        push @xml_opts, $opt;
    }
    elsif($opt =~ /^--(encoding|utf8trans-(program|map)|iconv-program)/) {
        push @xml_opts, $opt;
        push @xml_opts, shift(@ARGV) if $opt !~ /=/;
    }
    elsif($opt eq '--output') {
        # This option is ineffectual.
        shift @ARGV if $opt !~ /=/;     # Get rid of filename argument also
    }
    elsif($opt eq '-o') {
        # Same as --output.
        shift @ARGV;
    }
    else {
        push @xsltproc_opts, $opt;
    }
}

if(!grep /^-s|--stylesheet$/, @xsltproc_opts) {
    unshift @xsltproc_opts, ('-s', $CONVERSION_TYPE);
}

unshift @xsltproc_opts, $db2x_config{'db2x_xsltproc-program'};

if($CONVERSION_TYPE eq 'texi') {
    unshift @xml_opts, $db2x_config{'db2x_texixml-program'};
} elsif($CONVERSION_TYPE eq 'man') {
    unshift @xml_opts, $db2x_config{'db2x_manxml-program'};
}

exec(
    shell_quote(@xsltproc_opts) . 
    ' | ' . 
    shell_quote(@xml_opts));
     

sub shell_quote
{
    join(' ', map { my $u = $_;
                    $u =~ s#([\$`"\\\n])#\\$1#g;
                    '"' . $u . '"' } @_);
}





sub print_help {
    print "Usage: $0 [OPTION]... XML-FILE\n";

    if($CONVERSION_TYPE eq 'texi') {
        print "Convert DocBook XML documents to Texinfo\n\n";
    } elsif($CONVERSION_TYPE eq 'man') {
        print "Convert DocBook XML documents to man pages\n\n";
    }
    print "See docbook2X(1) for more details about this program.\n";
}

sub print_version
{
    print "$0 (part of docbook2X " .
            $db2x_config{'docbook2X-version'} . ")\n";
    print <<'end';
$Revision: 1.12 $ $Date: 2006/04/14 17:29:04 $
<URL:http://docbook2x.sourceforge.net/>

Copyright (C) 2003-2004 Steve Cheng
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
end
}

