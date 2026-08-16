# vim:sw=4 et sta showmatch

# db2x_texixml - convert Texi-XML to Texinfo
#                (See docbook2X documentation for details)
#
# (C) 2000-2004 Steve Cheng <stevecheng@users.sourceforge.net>
#
# See the COPYING file in the docbook2X distribution 
# for the copyright status of this software.
#      
# Note: db2x_texixml.pl does not run by itself!
#       It must be configured by including a config.pl file
#       which is done when building docbook2X.
#       In addition, the non-standard module 
#       XML::Handler::SGMLSpl must be explicitly loaded
#       when docbook2X is not installed.

package main;
use strict;


#############################################################################
#
# Option parsing
#
#############################################################################

use Getopt::Long;
Getopt::Long::Configure('bundling');
my $cmdoptions = {
    'encoding' => 'us-ascii',
    'list-files' => 0,
    'to-stdout' => 0,
    'output-dir' => '',
    'info' => 0,
    'plaintext' => 0,
    'utf8trans-program' => $db2x_config{'utf8trans-program'},
    'utf8trans-map' => $db2x_config{'utf8trans-map-texi'},
    'iconv-program' => $db2x_config{'iconv-program'},
    'makeinfo-program' => $db2x_config{'makeinfo-program'},
};

sub options_help {
    print "Usage: $0 [OPTION]... [FILE]...\n";
    print <<'end';
Make Texinfo documents from Texi-XML

  --encoding=ENCODING   Character encoding for Texinfo files
                        Default is US-ASCII
  --list-files          Write list of output files to stdout
  --to-stdout           Write output to stdout instead of to files
  --output-dir          Directory to write the output files
                        Default is current working directory
  --info                Pipe output to makeinfo, creating Info files directly
  --plaintext           Pipe output to makeinfo, creating plain text files
  
  These options set the location of auxiliary programs:
  --utf8trans-program=PATH, --utf8trans-map=PATH, 
  --iconv-program=PATH, --makeinfo-program=PATH

  --help                Show this help and exit
  --version             Show version and exit

See the db2x_texixml(1) manual page and the docbook2X documentation for
more details.
end
    exit 0;
}

sub options_version
{
    print "db2x_texixml (part of docbook2X " . 
            $db2x_config{'docbook2X-version'} . ")\n";
    print <<'end';
$Revision: 1.49 $ $Date: 2006/04/20 03:02:31 $
<URL:http://docbook2x.sourceforge.net/>

Copyright (C) 2000-2004 Steve Cheng
This is free software; see the source for copying conditions.  There is NO
warranty; not even for MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
end
    exit 0;
}

$SIG{__WARN__} = sub { print STDERR "$0: " . $_[0]; };
if(!GetOptions($cmdoptions,
    'encoding=s',
    'list-files',
    'to-stdout',
    'output-dir=s',
    'info',
    'plaintext',
    'utf8trans-program=s',
    'utf8trans-map=s',
    'iconv-program=s',
    'makeinfo-program=s',
    'help', \&options_help,
    'version', \&options_version))
{
    print STDERR "Try \"$0 --help\" for more information.\n";
    exit 1;
}
$SIG{__WARN__} = undef;

#use XML::Handler::SGMLSpl;     # we link to this explicitly during building
my $texixmldata = { 'options' => $cmdoptions };
$texixml::templates = XML::Handler::SGMLSpl->new($texixmldata);
$texixml::templates->push_mode('file-unselected');
$texixml::templates->{namespaces}->{''}="http://docbook2x.sourceforge.net/xmlns/Texi-XML";
               



#############################################################################
#
# TexiWriter: output routines
#
#############################################################################

package TexiWriter;
require Exporter;
@TexiWriter::ISA = qw(Exporter);
@TexiWriter::EXPORT_OK = qw(texi_escape texi_arg_escape);

#
# Use TexiWriter on specified file
# Params: fh - an IO::Handle to send the output
#
sub new {
    my ($class, $fh) = @_;
    my $self = { fh => $fh, line_start => 1, output_buffers => [] };
    return bless($self, $class);
}

#
# Print text with whitespace folding
# (actually only newline folding)
# Usually need to escape text first
# Params: text - string to print
#
sub print_ws {
    my ($self, $text) = @_;
    
    foreach my $line (split(/(\n)/, $text)) {
        if($line eq "\n") {
            # Don't leave a blank line
            $self->{fh}->print("\n")
                unless $self->{line_start}++;
        } else {
            # Don't put any spaces at the beginning
            # of a line.  These cause makeinfo
            # to erroneously indent the text.
            $line =~ s/^[ \t]+// if $self->{line_start};

            # Collapse whitespace
            $line =~ tr/ \t/ /;

            if($line ne '') {
                $self->{fh}->print($line);
                $self->{line_start} = 0;
            }
        }
    }
}

#
# This is basically just a print, but
# with the special instruction that,
# if a '\n' is present at the beginning
# of the string, this means to start a new line,
# 
# i.e. if we are already at the beginning of the line
# we do not emit another '\n' and therefore create
# a blank line.
#
# This routine is useful for emitting "block" Texinfo
# commands that have to start at the beginning of the
# line. (Note: unlike RoffWriter's request method, 
# TexiWriter does not provide an explicit "do command" 
# method --- they are cumbersome and not necessary
# for the Texinfo format.)
#
# No escaping of the text is done.
# 
# Params: text - string to print
# 
sub output {
    my ($self, $text) = @_;

    if($text =~ s/^\n//) {
        $self->{fh}->print("\n") unless $self->{line_start}++;
    }

    return if $text eq '';

    $self->{fh}->print($text);
    $self->{line_start} = ($text =~ /\n$/);
}

#
# The following functions implement a simple stack
# of output buffers.  These are used to handle the arguments
# of a Texinfo @-command, when the content of the arguments
# is not immediately accessible in stream XML processing.
#
# The line-breaking semantics of regular output() are not implemented,
# because they do not make sense on strings.
#

sub output_buffer_push
{
    my ($self) = @_;
    unshift(@{$self->{output_buffers}}, "");
}

sub output_buffer_pop
{
    my ($self) = @_;
    return shift(@{$self->{output_buffers}});
}

sub savable_output {
    my ($self, $text) = @_;
    if(scalar(@{$self->{output_buffers}}) == 0) {
        return output($self, $text);
    } else {
        $self->{output_buffers}->[0] .= $text;
    }
}
        
    

#
# Print text without folding whitespace
# Usually need to escape text first
# Params: text - string to print
#
sub print {
    my ($self, $text) = @_;
    $self->{fh}->print($text);
    $self->{line_start} = ($text =~ /\n$/);
}

# Escape Texinfo syntax chars
#
sub texi_escape
{
    my $s = shift;
    $s =~ s/([\@\{\}])/\@$1/g;
    return $s;
}

sub texi_arg_escape 
{
    my $s = shift;
    $s =~ s/,/\@comma\{\}/g;
    return $s;
}

# Escape the ',' when output buffering is activated,
# because output buffering is typically used to handle
# arguments, and a literal ',' would be misinterpreted
# as an argument delimeter.

sub texi_arg_escape_conditional
{
    my ($self, $text) = @_;

    if(scalar(@{$self->{output_buffers}}) > 0) {
        $text =~ s/,/\@comma\{\}/g;
    }

    return $text;
}



#############################################################################
#
# Template rules
#
#############################################################################


package texixml;
import TexiWriter qw(texi_escape texi_arg_escape);

use IO::File;
use vars qw($templates);


    
    
##################################################
#
# A clean solution to the extra-newlines problem
#
##################################################

# In essence, texi_xml usually puts newlines only where you 
# expect a human editing a Texinfo file directly would.
# The heuristic works by checking if we are at the beginning
# of a line or not in our output ($texixml::newline_last),
# and if so, refrain from putting too many newlines
# (which would actually produce 2 or more blank lines).
#
# texi_xml also keeps track of what type of element (block, inline 
# or neither) it just processed, then makes line breaks only
# if it is required to separate them.
#
# This is not complete "whitespace collapsing", but since Texinfo
# is reasonably tolerant in its whitespace handling we don't need
# to have a model that collapses whitespace perfectly in every case.
# 
# 
sub block_start
{
    my ($self, $elem) = @_;

    if(scalar(@{$self->{tw}->{output_buffers}}) > 0) {
        die "$0: block_start called while saving output (this is a bug)";
    }

    $self->{tw}->output("\n\n")
        unless ($elem->in('listitem') and 
                $elem->parent->ext->{lastchild} eq '')
            or ($elem->in('entry') and
                $elem->parent->ext->{lastchild} eq '');
            # Don't put blank before the first block in 
            # varlistentries and entries of a multitable.

    $elem->parent->ext->{lastchild} = 'block';
}


sub mixed_inline_start
{
    my ($self, $node) = @_;
    
    if(scalar(@{$self->{tw}->{output_buffers}}) > 0) {
        return;
    }
    
    # Example:
    # <para>Warning<itemize>...</itemize>Do not indent this text
    # since it's part of the same paragraph</para>

    $self->{tw}->output("\n\n\@noindent\n") 
        if $node->parent->ext->{lastchild} eq 'block';

    $node->parent->ext->{lastchild} = 'inline';
}




##################################################
#
# Texinfo preamble and eof
#
##################################################

sub shell_quote
{
    join(' ', map { my $u = $_;
                    $u =~ s#([\$`"\\\n])#\\$1#g; 
                    '"' . $u . '"' } @_);
}

sub texi_openfile {
    my ($self, $basename) = @_;

    my $dir = $self->{options}->{'output-dir'};
    $dir =~ s/([^\/])$/$1\//;     # terminate with slash

    my $encoding = $self->{options}->{encoding};
    
    my $openstr = '';
        
    if(($encoding !~ /^utf|ucs/i or $encoding =~ s/\/\/TRANSLIT$//i)
        and $self->{options}->{'utf8trans-program'} ne '')
    {
        $openstr .= '| ' .
            shell_quote($self->{options}->{'utf8trans-program'}) . ' -- ' .
            shell_quote($self->{options}->{'utf8trans-map'}) . ' ';
    }
    
    if($encoding !~ /^utf-?8$/i
        and $self->{options}->{'iconv-program'} ne '')
    {
        $openstr .= '| ' .
            shell_quote($self->{options}->{'iconv-program'},
                        '-f', 'utf-8',
                        '-t', $encoding)
            . ' ';
    }

    if($self->{options}->{'plaintext'}) {
        my $filename = "${dir}${basename}.txt";
        $openstr .= '| ' . 
            shell_quote($self->{options}->{'makeinfo-program'}, 
                        '--no-headers');
        if(not $self->{options}->{'to-stdout'}) {
            print "$filename\n"
                if $self->{options}->{'list-files'};
            $openstr .= ' > ' . shell_quote($filename);
        }
    } elsif($self->{options}->{'info'}) {
        if(not $self->{options}->{'to-stdout'}) {
            $openstr .= '| ( cd ' 
                        . shell_quote($dir) . ' && exec ' 
                        . shell_quote($self->{options}->{'makeinfo-program'})
                        . ' )';
            print "${dir}${basename}.info\n"
                if $self->{options}->{'list-files'};
        } else {
            $openstr .= '| ' . shell_quote(
                                    $self->{options}->{'makeinfo-program'})
                             . ' -o -';
        }
    } else {
        my $filename = "${dir}${basename}.texi";
        if($openstr eq '') {
            if(not $self->{options}->{'to-stdout'}) {
                $openstr = $filename;
                # Trick from Perl FAQ to open file with arbitrary characters
                $openstr =~ s#^(\s)#./$1#;
                $openstr = ">${openstr}\0";
                print "$filename\n"
                    if $self->{options}->{'list-files'};
            } else {
                $openstr = '>-';
            }
        } else {
            $openstr .= '> ' . shell_quote($filename);
            print "$filename\n"
                if $self->{options}->{'list-files'};
        }
    }

    my $iof = new IO::File($openstr)
        or die "$0: error opening $openstr: $!\n";

    # Set output encoding to UTF-8 on Perl >=5.8.0
    # so it doesn't complain
    binmode($iof, ":utf8") unless $] < 5.008;

    return $iof;
}

$templates->add_rule('texinfoset<', 'file-unselected', sub {
    my ($self, $elem, $templates) = @_;
    $self->{node2id_map} = {};
    $self->{id2node_map} = {};
    $self->{id2file_map} = {};
    $self->{id_counter} = 1;
});
$templates->add_rule('texinfoset>', 'file-unselected', sub {});

$templates->add_rule('texinfo<', 'file-unselected', sub {
    my ($self, $elem, $templates) = @_;

    my $basename;
    if($elem->attr('file') ne '') {
        $basename = filename_escape($elem->attr('file'));
    } elsif($self->{inputfile} ne '-') {
        $basename = $self->{inputfile};
        # strip the path component, and extension
        $basename = $1 if $basename =~ /([^\/]+)$/;
        $basename =~ s/\.txml$//;
    } else {
        $basename = 'untitled';
    }

    $self->{fh} = texi_openfile($self, $basename);
    $self->{tw} = new TexiWriter($self->{fh});

    $self->{basename} = $basename;
    
    $self->{tw}->output("\\input texinfo\n");
    $self->{tw}->output("\n\@setfilename ${basename}.info\n");

    my $encoding = $self->{options}->{encoding};
    $encoding =~ s#//TRANSLIT$##i;
    $self->{tw}->output("\@documentencoding $encoding\n");

    $templates->pop_mode();
});

$templates->add_rule('texinfo>', 'file-unselected', sub {
    my ($self, $elem, $templates) = @_;
    
    $self->{tw}->output("\n\n\@bye\n");

    $self->{fh}->close
        or die $! ? "$0: error closing file/pipe: $!\n"
                  : "$0: program in pipeline exited with an error\n";

    $self->{fh} = undef;
    $self->{tw} = undef;
    
    $templates->push_mode('file-unselected');
});

$templates->add_rule('text()', 'file-unselected', \&illegal_text_handler);
$templates->add_rule('*<', 'file-unselected', \&illegal_element_handler);

sub illegal_text_handler {
    my ($self, $node, $templates) = @_;

    if($node->{Data} =~ /[^ \t\r\n]/) {
        $templates->warn_location($node, "character data is not allowed here");
    }
}
                    


##################################################
#
# Node name maps
#
##################################################

$templates->add_rule('nodenamemap<', 'file-unselected', sub {
    my ($self, $elem, $templates) = @_;
    $templates->push_mode('nodenamemap-mode');
});

$templates->add_rule('nodenamemap>', 'file-unselected', sub {
    my ($self, $elem, $templates) = @_;
    $templates->pop_mode();
});

$templates->add_rule('nodenamemapentry<', 'nodenamemap-mode', sub {
    my ($self, $elem, $templates) = @_;
    $elem->ext->{nodenames} = [];
});
    
$templates->add_rule('nodenamemapentry>', 'nodenamemap-mode', sub {
    my ($self, $elem, $templates) = @_;

    my $id = $elem->attr('id');
    my $f = filename_escape($elem->attr('file'));
    my $nodename;

    foreach my $s (@{$elem->ext->{nodenames}}) {
        if(not exists $self->{node2id_map}->{"${f}/$s"}) {
            $nodename = $s;
            last;
        }
    }

    if(not defined $nodename) {
        if(scalar(@{$elem->ext->{nodenames}}) > 0) {
            for(my $i = 1; ; $i++) {
                $nodename = $elem->ext->{nodenames}->[0] . 
                                ' <' . $i . '>';
                last if not 
                    exists $self->{node2id_map}->{"${f}/$nodename"};
            }
        } elsif(not exists $self->{node2id_map}->{
                    $f . '/' . ($nodename = nodename_escape($id))}) {
        } else {
            $nodename = 'untitled node <' . $self->{id_counter}++ . '>';
        }
    }

    $self->{node2id_map}->{"${f}/$nodename"} = $id;
    $self->{id2node_map}->{$id} = $nodename;
    $self->{id2file_map}->{$id} = $f;
});

$templates->add_rule('nodename<', 'nodenamemap-mode', sub {
    my ($self, $elem, $templates) = @_;
    $elem->ext->{nodename} = '';
});

$templates->add_rule('nodename>', 'nodenamemap-mode', sub {
    my ($self, $elem, $templates) = @_;
    my $nodenames = $elem->parent->ext->{nodenames};
    my $s = nodename_escape($elem->ext->{nodename});
    push(@$nodenames, $s) unless $s eq '';
});

$templates->add_rule('text()', 'nodenamemap-mode', sub {
    my ($self, $node, $templates) = @_;
    if($node->in('nodename')) {
        $node->parent->ext->{nodename} .= $node->{Data};
    } else {
        &illegal_text_handler;
    }
});

$templates->add_rule('*<', 'nodenamemap-mode', \&illegal_element_handler);;



sub get_nodename
{
    my ($self, $elem, $nodename_attr, $id_attr, $optional) = @_;
    if($nodename_attr ne '') {
        return nodename_escape($nodename_attr);
    } else {
        my $f = $self->{id2file_map}->{$id_attr};
        if($f ne '' and $f ne $self->{basename}) {
            # Error, we expect this node to be in the same
            # file.
            $templates->warn_location($elem, "fatal error: node belongs to a different file");
            die;
        }
    
        return undef if($optional and $id_attr eq '');
        
        if($id_attr eq '') {
            $templates->warn_location($elem, "fatal error: neither a node name nor an ID was specified");
            die;
        }
        if(not exists($self->{id2node_map}->{$id_attr})) {
            $templates->warn_location($elem, "ID \"${id_attr}\" does not exist");
            return nodename_escape($id_attr);
        }
        
        return $self->{id2node_map}->{$id_attr};
    }
}

sub get_nodename_filename
{
    my ($self, $elem, $nodename_attr, $file_attr, $id_attr, $optional) = @_;
    if($nodename_attr ne '' or $file_attr ne '') {
        return (nodename_escape($nodename_attr), filename_escape($file_attr));
    } else {
        return undef if $optional and $id_attr eq '';
        
        if($id_attr eq '') {
            $templates->warn_location($elem, "fatal error: neither a node name nor an ID was specified");
            die;
        }
        if(not exists($self->{id2node_map}->{$id_attr})) {
            $templates->warn_location($elem, "fatal error: ID \"${id_attr}\" does not exist");
            return (nodename_escape($id_attr), '')
        }
        
        return ($self->{id2node_map}->{$id_attr},
                $self->{id2file_map}->{$id_attr});
    }
}
            

    


##################################################
#
# Simple title pages
#
##################################################

$templates->add_rule('settitle<', sub {
    my ($self, $elem, $templates) = @_;
    $self->{tw}->output("\n\@settitle ");
    $templates->push_mode('single-line-mode');
});
$templates->add_rule('settitle>', sub {
    my ($self, $elem, $templates) = @_;
    $templates->pop_mode();
    $self->{tw}->output("\n");
});

$templates->add_rule('titlepage<', sub {
    my ($self, $elem, $templates) = @_;
    $self->{tw}->output("\n\@titlepage\n");
});
$templates->add_rule('titlepage>', sub {
    my ($self, $elem, $templates) = @_;
    $self->{tw}->output("\n\@end titlepage\n");
});
$templates->add_rule('title<', sub {
    my ($self, $elem, $templates) = @_;
    $self->{tw}->output("\n\@title ");
    $templates->push_mode('single-line-mode');
});
$templates->add_rule('title>', sub {
    my ($self, $elem, $templates) = @_;
    $templates->pop_mode();
    $self->{tw}->output("\n");
});
$templates->add_rule('subtitle<', sub {
    my ($self, $elem, $templates) = @_;
    $self->{tw}->output("\n\@subtitle ");
    $templates->push_mode('single-line-mode');
});
$templates->add_rule('subtitle>', sub {
    my ($self, $elem, $templates) = @_;
    $templates->pop_mode();
    $self->{tw}->output("\n");
});
$templates->add_rule('author<', sub {
    my ($self, $elem, $templates) = @_;
    $self->{tw}->output("\n\@author ");
    $templates->push_mode('single-line-mode');
});
$templates->add_rule('author>', sub {
    my ($self, $elem, $templates) = @_;
    $templates->pop_mode();
    $self->{tw}->output("\n");
});




##################################################
#
# Menus, nodes
#
##################################################

# Do escaping for nodenames:
# NOTE: stylesheets should do this if possible
# since there can be rare name clashes.
sub nodename_escape
{
    my $name = shift;
    for ($name) {
        tr/().,:/[]_;;/;
        tr/ \t\n/ /s;
        s/^ +//g;
        s/ +$//g;
    }
    return $name;
}

sub filename_escape
{
    my $s = shift;
    $s =~ tr/\//_/;
    return $s;
}


$templates->add_rule('node<', sub {
    my ($self, $elem, $templates) = @_;
    my $node = texi_escape(
                get_nodename($self, $elem, 
                    $elem->attr('name'), $elem->attr('id')));

    my $next = texi_escape(get_nodename($self, $elem,
            $elem->attr('next'), $elem->attr('nextid'), 'optional'));
    my $previous = texi_escape(get_nodename($self, $elem,
            $elem->attr('previous'), $elem->attr('previousid'), 'optional'));
    my $up = texi_escape(get_nodename($self, $elem,
            $elem->attr('up'), $elem->attr('upid'), 'optional'));

    if(defined($next) or defined($previous) or defined($up)) {
        if($node =~ /^[Tt]op$/ and $elem->attr('up') eq '') {
            $up = '(dir)';
        }

        $self->{tw}->output(
            "\n\n\@node ${node}, ${next}, ${previous}, ${up}\n");
    } else {
        $self->{tw}->output("\n\n\@node $node\n");
    }
});

$templates->add_rule('menu<', sub {
    my ($self, $elem, $templates) = @_;
    block_start($self, $elem);
    $self->{tw}->output("\@menu\n");
    $templates->push_mode('menu-mode');
});
$templates->add_rule('menu>', sub {
    my ($self, $elem, $templates) = @_;
    $templates->pop_mode();
    $self->{tw}->output("\n\@end menu\n");
});
$templates->add_rule('detailmenu<', 'menu-mode', sub {
    my ($self, $elem, $templates) = @_;
    block_start($self, $elem);
    $self->{tw}->output("\@detailmenu\n");
});
$templates->add_rule('detailmenu>', 'menu-mode', sub {
    my ($self, $elem, $templates) = @_;
    $self->{tw}->output("\n\@end detailmenu\n");
});
$templates->add_rule('menuline<', 'menu-mode', sub {
    my ($self, $elem, $templates) = @_;
    $templates->push_mode('menu-saved-text-mode');
    $self->{tw}->output_buffer_push();
});
$templates->add_rule('menuline>', 'menu-mode', sub {
    my ($self, $elem, $templates) = @_;
    $templates->pop_mode();

    my $s = $self->{tw}->output_buffer_pop();

    $self->{tw}->output($s . "\n");
    $self->{tw}->output("\n\n") if($s eq '');
});

$templates->add_rule('menuentry<', 'menu-mode', sub {});
$templates->add_rule('menuentry>', 'menu-mode', sub {
    my ($self, $elem, $templates) = @_;
    $self->{tw}->output("\n");
});

$templates->add_rule('menuentrytitle<', 'menu-mode', sub {
    my ($self, $elem, $templates) = @_;
    $templates->push_mode('menu-saved-text-mode');
    $self->{tw}->output_buffer_push();
});

$templates->add_rule('menuentrytitle>', 'menu-mode', sub {
    my ($self, $elem, $templates) = @_;
    $templates->pop_mode();

    my $entry = $self->{tw}->output_buffer_pop();
    
    # Since the contents of @menu is supposed to be "pre-formatted",
    # Texinfo will be picky about extra spaces.
    # Eliminate them here.
    $entry =~ tr/ / /s;
    $entry =~ s/^ //;


    # Although the menu entry is not constrained to the set
    # of characters allowed for node names, the use of ':'
    # to separate the parts of menu entry implies that it
    # is not an allowed character.
    $entry =~ tr/:/;/;

    my ($node,$file) = get_nodename_filename($self, $elem->parent,
                            $elem->parent->attr('node'),
                            $elem->parent->attr('file'),
                            $elem->parent->attr('idref'),
                            $elem->parent->in('directory'));
    $node = texi_escape($node);
    $file = texi_escape($file);

    # The eventual output
    my $s;
    
    $self->{tw}->output("\n");
    
    if($file ne '' and ($node eq '' or $file ne $self->{basename})) {
        $s = "* ${entry}: (${file})${node}.";
    } else {
        if($entry eq $node) {
            $s = "* ${entry}::";
        } else {
            $s = "* ${entry}: ${node}.";
        }
    }

    $self->{tw}->output($s);

    $elem->parent->ext->{'entry_length'} = length($s);
});

use Text::Wrap ();
$templates->add_rule('menuentrydescrip<', 'menu-mode', sub {
    my ($self, $elem, $templates) = @_;
    $templates->push_mode('menu-saved-text-mode');
    $self->{tw}->output_buffer_push();
});
$templates->add_rule('menuentrydescrip>', 'menu-mode', sub {
    my ($self, $elem, $templates) = @_;
    $templates->pop_mode();

    my $text = $self->{tw}->output_buffer_pop();
    
    # Since the contents of @menu is supposed to be "pre-formatted",
    # Texinfo will be picky about extra spaces.
    # Eliminate them here.
    $text =~ tr/ / /s;
    $text =~ s/^ //;
        
    my $entry_length = $elem->parent->ext->{'entry_length'};
    
    my $first_line_padding = 
        $entry_length<32 ? 32-$entry_length : 3;
    my $first_line_overflow = 0;

    my $start_column = 
        $entry_length + $first_line_padding + 2;
        
    if($start_column > 50) {
        $first_line_overflow = 1;
        $start_column = 50;
    }


    $Text::Wrap::columns = 78 - $start_column;
    
    my @lines = split(/(\n)/, Text::Wrap::wrap("", "", $text));

    if(!$first_line_overflow) {
        my $first_line = shift @lines;
        if($first_line) {
            $self->{tw}->output((' ' x $first_line_padding) . $first_line);
        }
    } else {
        $self->{tw}->output("\n");
    }

    foreach my $line (@lines) {
        if($line eq "\n") {
            $self->{tw}->output("\n");
        } else {
            $self->{tw}->output((' ' x $start_column) . $line);
        }
    }
});
    
$templates->add_rule('text()', 'menu-mode', \&illegal_text_handler);
$templates->add_rule('*<', 'menu-mode', \&illegal_element_handler);



##################################################
#
# Info directory
#
##################################################

$templates->add_rule('directory<', sub {
    my ($self, $elem, $templates) = @_;
    
    # If creating plain text files, suppress the directory.
    # Really, makeinfo ought to do this, but it doesn't.
    if($self->{options}->{'plaintext'}) {
        $templates->push_mode('directory-suppress');
        return;
    }

    if(defined $elem->attr('category')) {
        $self->{tw}->output("\n\@dircategory " . 
            texi_escape($elem->attr('category')) . "\n");
    }
    
    $self->{tw}->output("\n\@direntry\n");
    $templates->push_mode('menu-mode');
});
$templates->add_rule('directory>', sub {
    my ($self, $elem, $templates) = @_;
    $templates->pop_mode();

    return if $self->{options}->{'plaintext'};

    $templates->pop_mode();
    $self->{tw}->output("\n\@end direntry\n");
});

$templates->add_rule('text()', 'directory-suppress', sub {});
$templates->add_rule('*<', 'directory-suppress', sub {});

 
##################################################
#
# Internationalization
#
##################################################

$templates->add_rule('documentlanguage<', sub {
    my ($self, $elem, $templates) = @_;
    my $lstack = $self->{'language-stack'};

    if(defined $elem->attr('lang')) {
        $self->{tw}->output("\n\@documentlanguage " . $elem->attr('lang') . "\n");
        push(@$lstack, $elem->attr('lang'));
    } else {
        pop(@$lstack);
        $self->{tw}->output("\n\@documentlanguage " . $lstack->[-1] . "\n")
            if scalar(@$lstack);
    }
});




##################################################
#
# Inline elements
#
##################################################

sub inline_start_handler {
    my ($self, $elem, $templates) = @_;
    mixed_inline_start($self, $elem);
    $self->{tw}->savable_output('@'. $elem->name . '{');
}
sub inline_end_handler {
    my ($self, $elem, $templates) = @_;
    $self->{tw}->savable_output('}');
}

foreach my $gi
    (qw(code samp cite email dfn file sc acronym emph strong key kbd var 
        env command option
        i b r t 
        footnote)) 
{
    $templates->add_rule("${gi}<", \&inline_start_handler);
    $templates->add_rule("${gi}>", \&inline_end_handler);

    $templates->add_rule("${gi}<", 'single-line-mode', \&inline_start_handler);
    $templates->add_rule("${gi}>", 'single-line-mode', \&inline_end_handler);

    $templates->add_rule("${gi}<", 'saved-text-mode', \&inline_start_handler);
    $templates->add_rule("${gi}>", 'saved-text-mode', \&inline_end_handler);
    
    $templates->add_rule("${gi}<", 'verbatim-mode', sub {});
    $templates->add_rule("${gi}>", 'verbatim-mode', sub {});
    $templates->add_rule("${gi}<", 'menu-saved-text-mode', sub {});
    $templates->add_rule("${gi}>", 'menu-saved-text-mode', sub {});
}

sub anchor_start {
    my ($self, $elem, $templates) = @_;
    mixed_inline_start($self, $elem);
    $self->{tw}->savable_output('@anchor{' 
        . texi_escape(get_nodename($self, $elem,
                $elem->attr('node'), $elem->attr('id')))
        . '}');
}

$templates->add_rule('anchor<', \&anchor_start);
$templates->add_rule('anchor<', 'single-line-mode', \&anchor_start);
$templates->add_rule('anchor<', 'saved-text-mode', \&anchor_start);
$templates->add_rule('anchor<', 'menu-saved-text-mode', \&anchor_start);
$templates->add_rule('anchor<', 'verbatim-mode', \&anchor_start);

$templates->add_rule('*<', 'single-line-mode', \&illegal_element_handler);
$templates->add_rule('*<', 'saved-text-mode', \&illegal_element_handler);
$templates->add_rule('*<', 'menu-saved-text-mode', \&illegal_element_handler);


    
##################################################
#
# Cross references, links
#
##################################################

sub crossref_start_handler {
    my ($self, $elem, $templates) = @_;
    mixed_inline_start($self, $elem);
    $self->{tw}->output_buffer_push();
    $templates->push_mode('saved-text-mode');
}

sub crossref_end_handler {
    my ($self, $elem, $templates) = @_;
    $templates->pop_mode();

    # Syntax:
    # @ref{$node,$infolabel,$label,$file,$printmanual}
    # node - required
    # infolabel, label - optional
    # label is actually the inline content of this element
    # infofile, printmanual - optional

    my ($node, $file) = get_nodename_filename($self, $elem,
                            $elem->attr('node'),
                            $elem->attr('file'),
                            $elem->attr('idref'));
    
    my $infolabel = $elem->attr('infolabel');
    my $label = $self->{tw}->output_buffer_pop();

    # If the node and cross reference label turn out to be
    # the same, make the latter empty so info won't display it
    # twice.
    $label = '' if $node eq $label;
    $infolabel = '' if $node eq $infolabel;

    # Note: 
    # 1. Node names cannot contain commas anyway, so no 
    #    texi_arg_escape needed.
    # 2. label is not escaped here, because it already IS escaped.
    $node = texi_escape($node);
    $infolabel = texi_arg_escape(texi_escape($infolabel));
    $file = texi_arg_escape(texi_escape($file));
    
    my $printmanual = texi_arg_escape(
                        texi_escape($elem->attr('printmanual')));

    $self->{tw}->savable_output('@' . $elem->name . '{' . $node);

    if($file ne '' and $file ne $self->{basename}) {
        # Reference to another file
        $self->{tw}->savable_output(",$infolabel,$label,$file,$printmanual}");
    }
    else {
        # Same file
        if($label eq '' and $infolabel eq '') { 
            $self->{tw}->savable_output("}"); 
            return;
        } elsif($label eq '') { 
            $self->{tw}->savable_output(",$infolabel}"); 
        } else { 
            $self->{tw}->savable_output(",$infolabel,$label}"); 
        }
    }
}

foreach my $gi (qw(xref ref pxref)) {
    $templates->add_rule("${gi}<", \&crossref_start_handler);
    $templates->add_rule("${gi}>", \&crossref_end_handler);

    $templates->add_rule("${gi}<", 'single-line-mode', \&crossref_start_handler);
    $templates->add_rule("${gi}>", 'single-line-mode', \&crossref_end_handler);
    $templates->add_rule("${gi}<", 'saved-text-mode', \&crossref_start_handler);
    $templates->add_rule("${gi}>", 'saved-text-mode', \&crossref_end_handler);

    $templates->add_rule("${gi}<", 'verbatim-mode', sub {});
    $templates->add_rule("${gi}>", 'verbatim-mode', sub {});
    $templates->add_rule("${gi}<", 'menu-saved-text-mode', sub {});
    $templates->add_rule("${gi}>", 'menu-saved-text-mode', sub {});
}




##################################################
#
# URI references
#
##################################################

$templates->add_rule('uref<', sub {
    my ($self, $elem, $templates) = @_;
    mixed_inline_start($self, $elem);
    $self->{tw}->output_buffer_push();
    $templates->push_mode('saved-text-mode');
});

$templates->add_rule('uref>', sub {
    my ($self, $elem, $templates) = @_;
    $templates->pop_mode();
    
    my $url = texi_escape($elem->attr('url'));
    my $text = $self->{tw}->output_buffer_pop();

    if($text eq '') {
        $self->{tw}->savable_output("\@uref{$url}");
    } else {
        $self->{tw}->savable_output("\@uref{$url,$text}");
    }
});

# FIXME
$templates->add_rule("uref<", 'single-line-mode', sub {});
$templates->add_rule("uref>", 'single-line-mode', sub {});
$templates->add_rule("uref<", 'saved-text-mode', sub {});
$templates->add_rule("uref>", 'saved-text-mode', sub {});

$templates->add_rule("uref<", 'verbatim-mode', sub {});
$templates->add_rule("uref>", 'verbatim-mode', sub {});
$templates->add_rule("uref<", 'menu-saved-text-mode', sub {});
$templates->add_rule("uref>", 'menu-saved-text-mode', sub {});



##################################################
#
# Sectioning elements
#
##################################################

sub section_start_handler {
    my ($self, $elem, $templates) = @_;
    $elem->parent->ext->{'lastchild'} = 'block';
    $self->{tw}->output("\n\@" . $elem->name . ' ');
    $templates->push_mode('single-line-mode');
}

sub section_end_handler {
    my ($self, $elem, $templates) = @_;
    $templates->pop_mode();
    $self->{tw}->output("\n");
}

foreach my $gi
    (qw(chapter section subsection subsubsection
       majorheading chapheading heading subheading subsubheading
       top unnumbered unnumberedsec unnumberedsubsec unnumberedsubsubsec
       appendix appendixsec appendixsubsec appendixsubsubsec)) 
{
    $templates->add_rule("${gi}<", \&section_start_handler);
    $templates->add_rule("${gi}>", \&section_end_handler);
}




##################################################
#
# Paragraph
#
##################################################

$templates->add_rule('para<', sub {
    my ($self, $elem, $templates) = @_;
    block_start($self, $elem);
});
$templates->add_rule('para>', sub {
    my ($self, $elem, $templates) = @_;
    $self->{tw}->output("\n");
});
    
        


##################################################
#
# Verbatim displays
#
################################################

sub verbatim_block_start_handler 
{
    my ($self, $elem, $templates) = @_;
    block_start($self, $elem);
    $self->{tw}->output('@' . $elem->name . "\n");
    $templates->push_mode('verbatim-mode');
}
sub verbatim_block_end_handler
{
    my ($self, $elem, $templates) = @_;
    $templates->pop_mode();
    $self->{tw}->output("\n\@end " . $elem->name . "\n");
}


foreach my $gi
    (qw(example display format)) {
    $templates->add_rule("${gi}<", \&verbatim_block_start_handler);
    $templates->add_rule("${gi}>", \&verbatim_block_end_handler);
}

$templates->add_rule('*<', 'verbatim-mode', \&illegal_element_handler);

##################################################
#
# Quotation blocks
#
##################################################

sub quotation_block_start_handler {
    my ($self, $elem, $templates) = @_;
    block_start($self, $elem);
    $self->{tw}->output('@' . $elem->name . "\n");
}
sub quotation_block_end_handler {
    my ($self, $elem, $templates) = @_;
    $self->{tw}->output("\n\@end " . $elem->name . "\n");
}

foreach my $gi
    (qw(quotation cartouche flushleft flushright)) {
    $templates->add_rule("${gi}<", \&quotation_block_start_handler);
    $templates->add_rule("${gi}>", \&quotation_block_end_handler);
}




##################################################
#
# Lists
#
##################################################

$templates->add_rule('enumerate<', sub {
    my ($self, $elem, $templates) = @_;
    block_start($self, $elem);
    $self->{tw}->output("\@enumerate " . $elem->attr('begin') . "\n");
});

$templates->add_rule('enumerate>', sub {
    my ($self, $elem, $templates) = @_;
    $self->{tw}->output("\n\@end enumerate\n");
});

$templates->add_rule('itemize<', sub {
    my ($self, $elem, $templates) = @_;
    block_start($self, $elem);
    
    if($elem->attr('markchar') ne '') {
        $self->{tw}->output("\@itemize ") 
            . texi_escape($elem->attr('markchar')) 
            . "\n";
    } else {
        $self->{tw}->output("\@itemize \@w\n");
    }
});

$templates->add_rule('itemize>', sub {
    my ($self, $elem, $templates) = @_;
    $self->{tw}->output("\n\@end itemize\n");
});

$templates->add_rule('varlist<', sub {
    my ($self, $elem, $templates) = @_;
    block_start($self, $elem);
    $self->{tw}->output("\@table \@asis\n");
});
$templates->add_rule('varlist>', sub {
    my ($self, $elem, $templates) = @_;
    $self->{tw}->output("\n\@end table\n");
});

$templates->add_rule('varlistentry<', sub {
    my ($self, $elem, $templates) = @_;
    block_start($self, $elem);
});
$templates->add_rule('term<', sub {
    my ($self, $elem, $templates) = @_;
    if($elem->parent->ext->{numterms}++) {
        $self->{tw}->output("\@itemx ");
    } else {
        $self->{tw}->output("\@item ");
    }
    $templates->push_mode('single-line-mode');
});
$templates->add_rule('term>', sub {
    my ($self, $elem, $templates) = @_;
    $templates->pop_mode();
    $self->{tw}->output("\n");
});

$templates->add_rule('listitem<', sub {
    my ($self, $elem, $templates) = @_;

    # listitem is used in both varlistentry and plain lists,
    # but the @item markup is supplied by <term> in the former 
    # case already.
    if($elem->parent->name ne 'varlistentry') {
        block_start($self, $elem);
        $self->{tw}->output("\@item\n");
    }
});




##################################################
#
# Tables
#
#################################################

$templates->add_rule('multitable<', sub {
    my ($self, $elem, $templates) = @_;
    block_start($self, $elem);
    $elem->ext->{total_cols} = $elem->attr('cols');
    $elem->ext->{column_data} = [];
    $elem->ext->{colspec_current_colnum} = 0;
    $elem->ext->{colnames} = {};
    $elem->ext->{spannames} = {};
});

$templates->add_rule('colspec<', sub {
    my ($self, $elem, $templates) = @_;

    my $col;
    if($elem->attr('colnum')) {
        $col = $elem->attr('colnum');
    } else {
        $col = $elem->parent->ext->{colspec_current_colnum} + 1;
    }
    $elem->parent->ext->{colspec_current_colnum} = $col;

    if($elem->attr('colname') ne '') {
        $elem->parent->ext->{colnames}->{$elem->attr('colname')} = $col;
    }
    
    $elem->parent->ext->{column_data}->[$col-1] = 
        '' . $elem->attr('colwidth');
});

$templates->add_rule('spanspec<', sub {
    my ($self, $elem, $templates) = @_;

    $elem->parent->ext->{spannames}->{$elem->attr('spanname')}
        = [ $elem->attr('namest'), $elem->attr('nameend') ];
});

$templates->add_rule('tbody<', sub {
    my ($self, $elem, $templates) = @_;
    
    my $column_data = $elem->parent->ext->{column_data};
    my $totalcols = $elem->parent->ext->{total_cols};

    my @vspans = ();
    for(my $i = 0; $i < $totalcols; $i++) {
        push(@vspans, 0);
    }
    $elem->ext->{current_vspans} = \@vspans;
    
    my $proportsum = 0;
    for(my $i = 0; $i < $totalcols; $i++) {
        my $colwidth = $column_data->[$i];
        if($colwidth eq '') {
            $colwidth = $column_data->[$i] = '1*';
        }
        
        # Later we may support other types of width measure,
        # so proportional measures should be written
        # as "r*".
        $colwidth =~ s/\*\s*$//;
        $proportsum += $colwidth;
    }
   
    my $columnfractions = '';
    for(my $i = 0; $i < $totalcols; $i++) {
        my $colwidth = $column_data->[$i];
        $colwidth =~ s/\*\s*$//;
        $columnfractions .= $colwidth/$proportsum . ' ';
    }
    $columnfractions =~ s/ $//;
    
    $self->{tw}->output("\n\@multitable \@columnfractions $columnfractions\n");
});

$templates->add_rule('tbody>', sub {
    my ($self, $elem, $templates) = @_;
    $self->{tw}->output("\n\@end multitable\n");
});

$templates->add_rule('row<', sub {
    my ($self, $elem, $templates) = @_;
    $self->{tw}->output("\n\@item\n");

    $elem->ext->{current_colnum} = 0;
    tbl_advance_column($elem, $self->{tw}, 0, 1);
});
$templates->add_rule('row>', sub {
    my ($self, $elem, $templates) = @_;
    $self->{tw}->output("\n");
    my $vspans = $elem->parent->ext->{current_vspans};
    for(my $i = 0; $i < @$vspans; $i++) {
        $vspans->[$i]-- if $vspans->[$i] > 0;
    }
});

$templates->add_rule('entry<', sub {
    my ($self, $elem, $templates) = @_;

    my $tableext = $elem->parent->parent->parent->ext;
    my $namest; my $nameend;
    if($elem->attr('spanname')) {
        $namest = $tableext->{spannames}->{$elem->attr('spanname')}->[0];
        $nameend = $tableext->{spannames}->{$elem->attr('spanname')}->[1];
    } elsif($elem->attr('namest')) {
        $namest = $elem->attr('namest');
        $nameend = $elem->attr('nameend');
    }

    my $relative_advance = 1;
    my $colnum;
    if(defined $namest) {
        my $col_st = $colnum = $tableext->{colnames}->{$namest};
        my $col_end = $tableext->{colnames}->{$nameend};
        
        $relative_advance = $col_end - $col_st + 1;
    } 
    elsif($elem->attr('colname')) {
        $colnum = $tableext->{colnames}->{$elem->attr('colname')};
    }

    if(defined $colnum) {
        tbl_advance_column($elem->parent, $self->{tw}, $colnum);
    }
 
    $elem->ext->{relative_advance} = $relative_advance;

    if($elem->attr('morerows')) {
        if($elem->attr('morerows') !~ /^\d+$/) {
            warn_location($elem, "invalid morerows value --- ignoring\n");
        } else {
            for(my $i = 0; $i < $relative_advance; $i++) {
                $elem->parent->parent->ext->{current_vspans}->[
                    $elem->parent->ext->{current_colnum} - 1 + $i]
                        = $elem->attr('morerows') + 1;
            }
        }
    }
    
});

$templates->add_rule('entry>', sub {
    my ($self, $elem, $templates) = @_;
    tbl_advance_column($elem->parent, $self->{tw}, 
                       0, $elem->ext->{relative_advance});
});

sub tbl_advance_column
{
    my ($row, $tw, $new_colnum, $relative_advance) = @_;

    my $old_colnum = $row->ext->{current_colnum};
    my $total_cols = $row->parent->parent->ext->{total_cols};

    if($relative_advance) {
        my $vspans = $row->parent->ext->{current_vspans};
        for($new_colnum = $old_colnum + $relative_advance;
            $new_colnum <= $total_cols && ($vspans->[$new_colnum - 1] > 0);
            $new_colnum++)
        {}
    }
    elsif($new_colnum == -1) {
        $new_colnum = $total_cols + 1;
    }

    $row->ext->{current_colnum} = $new_colnum;

    $new_colnum = $total_cols if $new_colnum > $total_cols;
    $old_colnum = 1           if $old_colnum == 0;

    $tw->output('@tab ' x ($new_colnum - $old_colnum));
}

##################################################
#
# Graphics
#
##################################################

sub image_handler {
    my ($self, $elem, $templates) = @_;
    mixed_inline_start($self, $elem);
    
    my $filename = texi_escape($elem->attr('filename'));

    # The @image command has to have the basename and extension
    # separated, so do that.
    my $basename; my $extension;

    if($filename =~ /^(.+)(\.[^\.]+)$/) {
        $basename = $1;
        $extension = $2;
    } else {
        $basename = $filename;
        $extension = '';
    }

    if(defined $elem->attr('width') or
       defined $elem->attr('height'))
    {
        $self->{tw}->savable_output('@image{' . $basename . ',' . 
            texi_escape($elem->attr('width')) .
            ',' . 
            texi_escape($elem->attr('height')) .
            ',,' .
            $extension .
            '}');
    } 
    else {
        $self->{tw}->savable_output(
            '@image{' . $basename . ',,,,' . $extension . '}');
    }
}

$templates->add_rule('image<', \&image_handler);
$templates->add_rule('image<', 'single-line-mode', \&image_handler);
$templates->add_rule('image<', 'saved-text-mode', \&image_handler);
$templates->add_rule('image<', 'verbatim-mode', \&image_handler);
$templates->add_rule('image<', 'menu-saved-text-mode', sub {});




##################################################
#
# Vertical spacing
#
##################################################

$templates->add_rule('sp<', sub {
    my ($self, $elem, $templates) = @_;
    $self->{tw}->output("\n\@sp " . $elem->attr('lines') . "\n");
});
$templates->add_rule('page<', sub {
    my ($self, $elem, $templates) = @_;
    $self->{tw}->output("\n\@page\n");
});



##################################################
#
# Indices
#
##################################################

$templates->add_rule('indexterm<', sub {
    my ($self, $elem, $templates) = @_;

    # We allow indexterm at block level just like
    # DocBook.  When that happens, don't treat
    # it as an inline (hence no @noindent mantra).
    if($elem->parent->ext->{lastchild} ne 'block') {
        mixed_inline_start($self, $elem);
    }
    
    my $class = $elem->attr('class');
    $class = 'c' if $class eq 'cp';
    $class = 'f' if $class eq 'fn';
    $class = 'v' if $class eq 'vr';
    $class = 'k' if $class eq 'ky';
    $class = 'p' if $class eq 'pg';
    $class = 't' if $class eq 'tp';
    
    # @cindex has to start on a new line.
    # I don't know if we are in a middle of an inline
    # command (eg @{code}) that @cindex would work
    # and not disrupt the inline.  I'm just hoping it works.
    # If it doesn't, then it is a dumb limitation!
    
    $self->{tw}->output("\n\@" . $class . 'index ');

    # Are @-commands allowed for indexed terms?
    $templates->push_mode('single-line-mode');

});
$templates->add_rule('indexterm>', sub {
    my ($self, $elem, $templates) = @_;
    $templates->pop_mode();
    $self->{tw}->output("\n");
});

$templates->add_rule('printindex<', sub {
    my ($self, $elem, $templates) = @_;
    block_start($self, $elem);

    my $class = $elem->attr('class');
    $class = 'cp' if $class eq 'c';
    $class = 'fn' if $class eq 'f';
    $class = 'vr' if $class eq 'v';
    $class = 'ky' if $class eq 'k';
    $class = 'pg' if $class eq 'p';
    $class = 'tp' if $class eq 't';
    
    $self->{tw}->output("\n\@printindex " . $class . "\n");
});




##################################################
#
# Character data
#
##################################################

$templates->add_rule('text()', 'single-line-mode', sub {
    my ($self, $node, $templates) = @_;
    my $s = texi_escape($node->{Data});
    
    # Collapse spaces, no newlines.
    $s =~ tr/ \t\n/ /s;
    $s = $self->{tw}->texi_arg_escape_conditional($s);

    $self->{tw}->savable_output($s);
});

sub saved_text_mode_handler
{
    my ($self, $node, $templates) = @_;
    my $s = texi_escape($node->{Data});

    # Collapse spaces, no newlines.
    $s =~ tr/ \t\n/ /s;
    $s = $self->{tw}->texi_arg_escape_conditional($s);

    $self->{tw}->savable_output($s);
}

sub menu_saved_text_mode_handler
{
    my ($self, $node, $templates) = @_;
    my $s = texi_escape($node->{Data});

    # Collapse spaces, no newlines.
    $s =~ tr/ \t\n/ /s;

    $self->{tw}->savable_output($s);
}
$templates->add_rule('text()', 'saved-text-mode', 
    \&saved_text_mode_handler);

$templates->add_rule('text()', 'menu-saved-text-mode', 
    \&menu_saved_text_mode_handler);

$templates->add_rule('text()', 'menu-mode', sub {});

$templates->add_rule('text()', 'verbatim-mode', sub {
    my ($self, $node, $templates) = @_;
    my $s = texi_escape($node->{Data});

    $self->{tw}->print($s);
});

$templates->add_rule('text()', sub {
    my ($self, $node, $templates) = @_;
    
    my $s = texi_escape($node->{Data});
    
    mixed_inline_start($self, $node)
        unless $s =~ /^[ \t\r\n]+$/;
            # Whitespace used to separate element
            # in a non-mixed content model should
            # not cause any spurious breaks.

    $self->{tw}->print_ws($s);
});




##################################################
#
# Comments
#
##################################################

$templates->add_rule('comment<', sub {
    my ($self, $elem, $templates) = @_;
    $self->{tw}->output("\n");
    $self->{tw}->output_buffer_push();
    $templates->push_mode('comment-mode');
});

$templates->add_rule('comment>', sub {
    my ($self, $elem, $templates) = @_;
    $templates->pop_mode('comment-mode');
    
    foreach my $line (split(/\n/, $self->{tw}->output_buffer_pop())) {
        $self->{tw}->output("\@c $line\n");
    }
});

$templates->add_rule('text()', 'comment-mode', sub {
    my ($self, $node, $templates) = @_;
    my $s = $node->{Data};
    $self->{tw}->savable_output($s);
});




##################################################
#
# Processing instructions
#
##################################################

$templates->add_rule('processing-instruction()', sub {
    my ($self, $node, $templates) = @_;

    if($node->{Target} eq 'texinfo') {
        my $data = $node->{Data};
        $data =~ s/\&#xA;/\n/g;
        $data =~ s/\&#10;/\n/g;
        $self->{tw}->output($data);
    }
});




##################################################
#
# Catch unknown elements
#
##################################################

$templates->add_rule('*<', \&illegal_element_handler);
sub illegal_element_handler {
    my ($self, $node, $templates) = @_;
    $templates->warn_location($node, "element not allowed here");
};




#############################################################################
#
# Main 
#
#############################################################################

package main;

use XML::SAX::ParserFactory;

unshift(@ARGV, '-') unless @ARGV;
my $parser = XML::SAX::ParserFactory->parser(
        DocumentHandler => $texixml::templates);

foreach my $file (@ARGV)
{
    $texixmldata->{inputfile} = $file;
    if($file eq '-') {
        $parser->parse_file(\*STDIN);
    } else {
        $parser->parse_uri($file);
    }
}

