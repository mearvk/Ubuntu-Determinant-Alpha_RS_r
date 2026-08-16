# vim:sw=4 sta showmatch

use strict;
use vars qw($VERSION);
$VERSION = '0.8.6';




package XML::Handler::SGMLSpl::Node;

sub new {
    my ($class, $type, $saxhash, $parent) = @_;
    $saxhash->{type} = $type;
    $saxhash->{parent} = $parent;
    $saxhash->{ext} = {};
    return bless($saxhash, $class);
}

# Element name
sub name {
    my ($self) = @_;
    if($self->{type} eq 'element') {
	return $self->{LocalName};
    } else {
	return undef;
    }
}

sub attr {
    my ($self, $name) = @_;
    if($name !~ /^\{/) { $name = '{}' . $name; }
    return $self->{Attributes}->{$name}->{Value};
}

sub within {
    my ($self,$name) = @_;
    for ($self = $self->{parent}; $self; $self = $self->{parent}) {
	return $self if ($self->name eq $name);
    }

    return undef;
}

sub in {
    my ($self,$name) = @_;
    if ($self->{parent} and $self->{parent}->name eq $name) {
	return $self->{parent};
    } else {
	return undef;
    }
}

sub ext { return shift->{ext} }
sub parent { return shift->{parent} }

# one of document, element, text, processing-instruction, comment, whitespace
sub type { return shift->{type} }




package XML::Handler::SGMLSpl;

sub new {
    my ($class, $user_data) = @_;
    my $self = {
	rules => {},
	mode => [ '' ],
        namespaces => {},       # public
	user_data => $user_data
    };
    return bless($self, $class);
}

#
# Rule parsing
#

sub add_rule {
    my $sub = pop;
    my ($self, $pattern, $mode) = @_;
    $mode = '' if !defined($mode);

    # Init hashes if not there already
    if(!defined $self->{rules}->{$mode}) {
	$self->{rules}->{$mode} = {
	    t_elem_open	 => {},
	    t_elem_close => {},
	    t_sdata => {},
	};
    }

    if($pattern eq 'text()') {
        $self->{rules}->{$mode}->{t_text} = $sub;
    } elsif($pattern eq 'processing-instruction()') {
        $self->{rules}->{$mode}->{t_pi} = $sub;
    } elsif($pattern eq 'comment()') {
        $self->{rules}->{$mode}->{t_comment} = $sub;
    } elsif($pattern eq 'sdata()') {
        $self->{rules}->{$mode}->{t_sdata}->{''} = $sub;
    } elsif($pattern eq '/<') {
        $self->{rules}->{$mode}->{t_doc_start} = $sub;
    } elsif($pattern eq '/>') {
        $self->{rules}->{$mode}->{t_doc_end} = $sub;
    } elsif($pattern =~ /^(\{([^}]+)\}(.+))<$/) {
        $self->{rules}->{$mode}->{t_elem_open}->{$1} = $sub;
    } elsif($pattern =~ /^(\{([^}]+)\}(.+))>$/) {
        $self->{rules}->{$mode}->{t_elem_close}->{$1} = $sub;
    } elsif($pattern =~ /^(([^:]+):)?([^:]+)<$/) {
        my $x = '{' . $self->{namespaces}->{$2} . '}' . $3;
        $self->{rules}->{$mode}->{t_elem_open}->{$x} = $sub;
    } elsif($pattern =~ /^(([^:]+):)?([^:]+)>$/) {
        my $x = '{' . $self->{namespaces}->{$2} . '}' . $3;
        $self->{rules}->{$mode}->{t_elem_close}->{$x} = $sub;
    } elsif($pattern =~ /^\|(.+)\|$/) {
        $self->{rules}->{$mode}->{t_sdata}->{$1} = $sub;
    } else {
        die "Unknown pattern type!";
    }
}

#
# Modes
#

sub push_mode {
    my ($self, $mode) = @_;
    push(@{$self->{mode}}, $mode);
    return $self->{mode}->[-2];
}

sub mode {
    my ($self) = @_;
    return $self->{mode}->[-1];
}

sub pop_mode {
    my ($self) = @_;
    return pop(@{$self->{mode}});
}

#
# Locators
#

sub set_document_locator {
    my ($self, $arg) = @_;
    $self->{locator} = $arg->{Locator};
}

sub get_locator {
    my ($self) = @_;
    return $self->{locator};
}

#
# Helpful utility method: displays location,
# with optional node address
#

sub warn_location
{
    my $self = shift;
    my $msg = pop;
    my $node = shift;

    my $location = $self->get_locator && $self->get_locator->location();

    my ($sysid, $linenum) = ('-', '');
    if($location) {
	$sysid = $location->{SystemId};
	$linenum = $location->{LineNumber};
    }

    my $nodeinfo;
    if(defined $node) {
	if($node->type() eq 'element') {
	    $nodeinfo = $node->name;
	} elsif($node->type eq 'text') {
	    $nodeinfo = $node->parent->name;
	}
    }

    if(defined $nodeinfo) {
	warn "$0:${sysid}:${linenum}:${nodeinfo}: ${msg}\n";
    } else {
	warn "$0:${sysid}:${linenum}: ${msg}\n";
    }
}
    


 

#
# Standard handlers: not intended for user
#

sub start_document {
    my ($self) = @_;

    my $doc = XML::Handler::SGMLSpl::Node->new(
		'document', {}, undef);
    $self->{current_node} = $doc;
    
    &{($self->{rules}->{$self->mode}->{t_doc_start} || sub{})}
	($self->{user_data}, $doc, $self);
}

sub end_document {
    my ($self) = @_;

    my $doc = $self->{current_node};
    $self->{current_node} = undef;
    
    return &{($self->{rules}->{$self->mode}->{t_doc_end} || sub{})}
	($self->{user_data}, $doc, $self);
}

sub start_element {
    my ($self, $arg) = @_;

    my $elem = XML::Handler::SGMLSpl::Node->new(
		    'element', $arg, $self->{current_node});
		    
    $self->{current_node} = $elem;

    $elem->{_last_mode} = $self->mode;

    my $key = '{' . $arg->{NamespaceURI} . '}' . $arg->{LocalName};
    my $default_key = '{' . $arg->{NamespaceURI} . '}*';
    
    my $elemrules = $self->{rules}->{$self->mode}->{t_elem_open};
    &{($elemrules->{$key} || $elemrules->{$default_key} || sub{})}
       ($self->{user_data}, $elem, $self);
}
    
sub end_element {
    my ($self, $arg) = @_;

    my $elem = $self->{current_node};

    my $key = '{' . $arg->{NamespaceURI} . '}' . $arg->{LocalName};
    my $default_key = '{' . $arg->{NamespaceURI} . '}*';

    # We always enter the end element handler with the same mode
    # as we had entered the start element handler.
    # In most cases this is the more sane behavior, even though
    # it's inconsistent.

    my $elemrules = $self->{rules}->{$elem->{_last_mode}}->{t_elem_close};
    &{($elemrules->{$key} || $elemrules->{$default_key} || sub{})}
       ($self->{user_data}, $elem, $self);
       
    $self->{current_node} = $elem->parent;
}

sub characters {
    my ($self, $arg) = @_;

    my $textnode = XML::Handler::SGMLSpl::Node->new(
		    'text', $arg, $self->{current_node});
    
    &{($self->{rules}->{$self->mode}->{t_text} || sub{})}
	($self->{user_data}, $textnode, $self);
}

sub processing_instruction {
    my ($self, $arg) = @_;

    my $pi = XML::Handler::SGMLSpl::Node->new(
		    'processing-instruction', $arg, $self->{current_node});
    
    &{($self->{rules}->{$self->mode}->{t_pi} || sub{})}
	($self->{user_data}, $pi, $self);
}

sub ignorable_whitespace {
    my ($self, $arg) = @_;

    my $textnode = XML::Handler::SGMLSpl::Node->new(
		    'whitespace', $arg, $self->{current_node});
    
    &{($self->{rules}->{$self->mode}->{t_text} || sub{})}
	($self->{user_data}, $textnode, $self);
}

sub comment {
    my ($self, $arg) = @_;

    my $comment = XML::Handler::SGMLSpl::Node->new(
		    'comment', $arg, $self->{current_node});
    
    &{($self->{rules}->{$self->mode}->{t_comment} || sub{})}
	($self->{user_data}, $comment, $self);
}

#
# SDATA entities (SGML)
#

sub internal_entity_ref {
    my ($self, $arg) = @_;

    my $sdata = XML::Handler::SGMLSpl::Node->new(
		    'sdata', $arg, $self->{current_node});

    my $sdatarules = $self->{rules}->{$self->mode}->{t_sdata};
    &{($sdatarules->{$arg->{LocalName}} || $sdatarules->{''} || sub{})}
       ($self->{user_data}, $sdata, $self);
}

# FIXME: Write a man page.

# Autoload methods go after =cut, and are processed by the autosplit program.

1;
