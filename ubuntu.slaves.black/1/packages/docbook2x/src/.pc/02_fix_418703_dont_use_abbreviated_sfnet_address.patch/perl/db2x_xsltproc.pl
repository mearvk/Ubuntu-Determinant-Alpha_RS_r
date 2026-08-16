# vim:sw=4 sta et showmatch

# docbook2X.pl - script to invoke XSLT processor for docbook2X
#                (See docbook2X documentation for details)
#
# (C) 2003-2004 Steve Cheng <stevecheng@users.sourceforge.net>
#
# See the COPYING file in the docbook2X distribution
# for the copyright status of this software.
#
# Note: db2x_xsltproc.pl does not run by itself!
#       It must be configured by including a config.pl file
#       which is done when building docbook2X.

use strict;

use Getopt::Long;
Getopt::Long::Configure('gnu_getopt');
my $options = {
    'output' => '',
    'xinclude' => '0',
    'sgml' => '0',
    'catalogs' => [],
    'network' => '0',
    'stylesheet' => '',
    'param' => {},
    'string-param' => {},
    'debug' => 0,
    'nesting-limit' => 0,
    'profile' => 0,
    'xslt-processor' => $db2x_config{'xslt-processor'},
};
# Hack, this allows us to easily test the docbook2X distribution
# with different processors without re-running configure
if(exists $ENV{DB2X_XSLT_PROCESSOR}) {
    $options->{'xslt-processor'} = $ENV{DB2X_XSLT_PROCESSOR};
}


sub options_help {
    print "Usage: $0 [options] xml-document\n";
    print <<'end';
XSLT processor invocation wrapper

  -v, --version           display version information and exit
  -h, --help              display this usage information
  -o, --output FILE       send output to file instead of stdout
  -I, --xinclude          do XInclude processing
  -S, --sgml              input document is SGML rather than XML
  -C, --catalogs FILES    use additional catalogs
  -N, --network           allow fetching resources over network
  -s, --stylesheet FILE   specify different stylesheet to use
  -p, --param NAME=VALUE  add or modify a parameter to stylesheet
                          VALUE is an XPath expression
  -g, --string-param NAME=VALUE
                          same as -p, but VALUE is treated as a string
  -d, --debug             display log of transformation
  -D, --nesting-limit     change maximum nesting depth of templates
  -P, --profile           display profiling information
  -X, --xslt-processor    specify a XSLT processor to use;
                          possible choices are: libxslt, saxon, xalan-j

See the db2x_xsltproc(1) manual page and the docbook2X documentation for
more details.
end
    exit 0;
}

sub options_version
{
    print "db2x_xsltproc (part of docbook2X " . 
        $db2x_config{'docbook2X-version'} . ")\n";
    print <<'end';
$Revision: 1.5 $ $Date: 2004/08/18 14:21:52 $
<URL:http://docbook2x.sourceforge.net/>

Copyright (C) 2004 Steve Cheng
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
end
    exit 0;
}

$SIG{__WARN__} = sub { print STDERR "$0: " . $_[0]; };
if(!GetOptions($options,
    'output|o=s',
    'xinclude|I',
    'sgml|S',
    'catalogs|C=s',
    'network|N',
    'stylesheet|s=s',
    'param|p=s',
    'string-param|stringparam|g=s',
    'debug|d',
    'nesting-limit|D=i',
    'profile|P',
    'xslt-processor|X=s',
    
    'help', \&options_help,
    'version', \&options_version))
{
    print STDERR "Try \"$0 --help\" for more information.\n";
    exit 1;
}
$SIG{__WARN__} = undef;

sub check_options
{
    my ($options, @argv) = @_;
    
    if($options->{'stylesheet'} eq 'texi') {
        $options->{'stylesheet'} = 
            "http://docbook2x.sf.net/latest/xslt/texi/docbook.xsl";
    } elsif($options->{'stylesheet'} eq 'man') {
        $options->{'stylesheet'} = 
            "http://docbook2x.sf.net/latest/xslt/man/docbook.xsl";
    }

    if(scalar(@argv) != 1) {
        print STDERR "$0: you must specify exactly one source document\n";
        exit 1;
    }
}
 
check_options($options, @ARGV);

if($options->{'xslt-processor'} eq 'libxslt') {
    check_executable($db2x_config{'xsltproc-program'});
    invoke_libxslt($options, @ARGV);
} elsif($options->{'xslt-processor'} eq 'saxon') {
    check_executable($db2x_config{'java-program'});
    check_jars($db2x_config{'saxon-jars'}, $db2x_config{'resolver-jars'});
    invoke_saxon($options, @ARGV);
} elsif($options->{'xslt-processor'} eq 'xalan-j') {
    check_executable($db2x_config{'java-program'});
    check_jars($db2x_config{'xalan-jars'}, $db2x_config{'resolver-jars'});
    invoke_xalan_j($options, @ARGV);
} else {
    print STDERR "$0: XSLT processor \"" . 
            $options->{'xslt-processor'} . "\" not supported\n";
    exit 2;
}

sub check_executable {
    foreach my $exe (@_) {
        if($exe eq '') {
            print STDERR "$0: selected XSLT processor not installed\n";
            print STDERR "$0: cannot use this XSLT processor --- try another one.\n";
            exit 2;
        }
    
        if(!-x $exe) {
            print STDERR "$0: could not execute $exe\n";
            print STDERR "$0: cannot use this XSLT processor --- try another one.\n";
            exit 2;
        }
    }
}

sub check_jars {
    foreach my $jar_path (@_) {
        if($jar_path eq '') {
            print STDERR "$0: selected XSLT processor not installed\n";
            print STDERR "$0: cannot use this XSLT processor --- try another one.\n";
            exit 2;
        }
    
        if(0 < grep { $_ ne '' and !-r $_ } (split(/:/, $jar_path))) {
            print STDERR "$0: could not read JAR file $_\n";
            print STDERR "$0: cannot use this XSLT processor --- try another one.\n";
            exit 2;
        }
    }
}

sub invoke_libxslt {
    my ($options, @argv) = @_;

    my @args;

    push(@args, '--xinclude') if $options->{xinclude};
    push(@args, '--nonet') if !$options->{network};
    push(@args, '--debug') if $options->{debug};
    push(@args, '--profile') if $options->{profile};
    push(@args, '--maxdepth', $options->{'nesting-limit'})
        if $options->{'nesting-limit'} > 0;
    push(@args, '--output', $options->{'output'})
        if $options->{'output'} ne '';

    foreach my $k (keys(%{$options->{param}})) {
        push(@args, '--param', $k, $options->{param}->{$k});
    }
    foreach my $k (keys(%{$options->{'string-param'}})) {
        push(@args, '--stringparam', 
                $k, $options->{'string-param'}->{$k});
    }

    push(@args, $options->{'stylesheet'});

    unshift(@args, $db2x_config{'xsltproc-program'});

    if(exists $ENV{XML_CATALOG_FILES}) {
        $ENV{XML_CATALOG_FILES} =~ tr/:/ /;
    } else {
        $ENV{XML_CATALOG_FILES} = "/etc/xml/catalog";
    }

    $ENV{XML_CATALOG_FILES} = 
            join(' ', @{$options->{catalogs}}) . ' ' .
            $ENV{XML_CATALOG_FILES} . ' ' .
            $db2x_config{'stylesheets-catalog'};

    if(!$options->{sgml}) {
        push(@args, @argv);
        print STDERR join(' ', @args) . "\n" if $options->{'debug'};
        exec { $args[0] } (@args);
    } else {
        push(@args, '-');
        exec shell_quote($db2x_config{'sgml2xml-isoent-program'}) . ' ' .
                shell_quote(@argv) . ' | ' . 
                shell_quote(@args);
    }
}

sub setup_java_catalogs
{
    my ($options) = @_;
    
    my $cat;
    if(exists $ENV{XML_CATALOG_FILES}) {
        $cat = $ENV{XML_CATALOG_FILES};
        $cat =~ tr/:/;/;
    } else {
        $cat = '/etc/xml/catalog';
    }

    $cat = join(';', @{$options->{catalogs}}) . ';' .
            $cat . ';' .
            $db2x_config{'stylesheets-catalog'};

    return $cat;
}


sub invoke_saxon
{
    my ($options, @argv) = @_;

    my @args;
    my $error = 0;

    if($options->{xinclude}) {
        print STDERR "$0: --xinclude not supported by SAXON processor\n";
        exit 2;
    }
    if(keys(%{$options->{param}}) > 0) {
        print STDERR "$0: --param not supported by SAXON processor\n";
        print STDERR "$0: (perhaps use --string-param instead?)\n";
        exit 2;
    }
    
    foreach my $opt (qw(debug nesting-limit profile))
    {
        print STDERR "$0: --$opt not supported by SAXON processor --- ignoring\n"
            if $options->{$opt};
    }

    push(@args, '-classpath', join(':', 
            $db2x_config{'resolver-jars'}, $db2x_config{'saxon-jars'}));

    push(@args, '-Dxml.catalog.files=' . setup_java_catalogs($options)); 
    push(@args, qw(-Dxml.catalog.staticCatalog=yes
                   -Dxml.catalog.verbosity=1
                   -Dxml.catalog.prefer=public));
    
    push(@args, 'com.icl.saxon.StyleSheet');
    push(@args, qw(-x org.apache.xml.resolver.tools.ResolvingXMLReader
                   -y org.apache.xml.resolver.tools.ResolvingXMLReader
                   -r org.apache.xml.resolver.tools.CatalogResolver
                   -l
                   -u));

    push(@args, '-o', $options->{'output'})
        if $options->{'output'} ne '';

    my $xmldoc = $argv[0];
    $xmldoc = '-' if $options->{sgml};
    # Grr... SAXON barfs at '-' for reading from stdin
    $xmldoc = '/dev/stdin' if $xmldoc eq '-';
    
    if($options->{'stylesheet'} ne '') {
        push(@args, $xmldoc);
        push(@args, $options->{'stylesheet'});
    } else {
        push(@args, '-a');
        push(@args, $xmldoc);
    }

    foreach my $k (keys(%{$options->{'string-param'}})) {
        push(@args, $k . '=' . $options->{'string-param'}->{$k});
    }

    unshift(@args, $db2x_config{'java-program'});

    if(!$options->{sgml}) {
        print STDERR join(' ', @args) . "\n" if $options->{'debug'};
        exec { $args[0] } (@args);
    } else {
        exec shell_quote($db2x_config{'sgml2xml-isoent-program'}) . ' ' .
                shell_quote(@argv) . ' | ' . 
                shell_quote(@args);
    }
}

sub invoke_xalan_j
{
    my ($options, @argv) = @_;

    my @args;
    my $error = 0;

    if($options->{xinclude}) {
        print STDERR "$0: --xinclude not supported by Xalan-Java processor\n";
        exit 2;
    }
    if(keys(%{$options->{param}}) > 0) {
        print STDERR "$0: --param not supported by Xalan-Java processor\n";
        print STDERR "$0: (perhaps use --string-param instead?)\n";
        exit 2;
    }
    
    foreach my $opt (qw(debug profile))
    {
        print STDERR "$0: --$opt not supported by Xalan-Java processor --- ignoring\n"
            if $options->{$opt};
    }

    # Workaround: see 
    # http://sources.redhat.com/ml/docbook-apps/2004-q1/msg00065.html
    my $xalan_jar_dir = $db2x_config{'xalan-jars'};
    $xalan_jar_dir =~ s/:.*//; $xalan_jar_dir =~ s/([^\/]+)$//;
    my $resolver_jar_dir = $db2x_config{'resolver-jars'};
    $xalan_jar_dir =~ s/:.*//; $resolver_jar_dir =~ s/([^\/]+)$//;
    push(@args, "-Djava.endorsed.dirs=$xalan_jar_dir:$resolver_jar_dir");
    push(@args, '-classpath', join(':', 
            $db2x_config{'resolver-jars'}, $db2x_config{'xalan-jars'}));

    push(@args, '-Dxml.catalog.files=' . setup_java_catalogs($options)); 
    push(@args, qw(-Dxml.catalog.staticCatalog=yes
                   -Dxml.catalog.verbosity=1
                   -Dxml.catalog.prefer=public));

    push(@args, 'org.apache.xalan.xslt.Process');
    push(@args, qw(-EntityResolver org.apache.xml.resolver.tools.CatalogResolver
                   -URIResolver org.apache.xml.resolver.tools.CatalogResolver
                   -L));

    push(@args, '-RL', $options->{'nesting-limit'})
        if $options->{'nesting-limit'} > 0;
    push(@args, '-out', $options->{'output'})
        if $options->{'output'} ne '';
    push(@args, '-xsl', $options->{'stylesheet'})
        if $options->{'stylesheet'} ne '';

    foreach my $k (keys(%{$options->{'string-param'}})) {
        push(@args, '-param', $k, $options->{'string-param'}->{$k});
    }

    unshift(@args, $db2x_config{'java-program'});


    if(!$options->{sgml}) {
        push(@args, '-in', @argv);
        print STDERR join(' ', @args) . "\n" if $options->{'debug'} ;
        exec { $args[0] } (@args);
    } else {
        push(@args, qw(-in -));
        exec shell_quote($db2x_config{'sgml2xml-isoent-program'}) . ' ' .
                shell_quote(@argv) . ' | ' . 
                shell_quote(@args);
    }
}

sub shell_quote
{
    join(' ', map { my $u = $_;
                    $u =~ s#([\$`"\\\n])#\\$1#g;
                    '"' . $u . '"' } @_);
}

