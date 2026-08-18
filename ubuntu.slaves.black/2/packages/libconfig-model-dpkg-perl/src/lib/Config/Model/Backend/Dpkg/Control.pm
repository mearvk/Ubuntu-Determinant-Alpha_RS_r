package Config::Model::Backend::Dpkg::Control ;
use strict;
use warnings;

use 5.20.1;
use Mouse ;
use feature qw/postderef signatures/;
no warnings qw/experimental::postderef experimental::signatures/;

extends 'Config::Model::Backend::Any';

with 'Config::Model::Backend::DpkgSyntax';
with 'Config::Model::Backend::DpkgStoreRole';

use Carp;
use Config::Model::Exception ;
use File::Path;
use Log::Log4perl qw(get_logger :levels);

use Config::Model::Dpkg::Dependency;

my $logger = get_logger("Backend::Dpkg::Control") ;

sub read ($self, %args) { ## no critic (ProhibitBuiltinHomonyms)
    # args is:
    # object     => $obj,         # Config::Model::Node object 
    # root       => './my_test',  # fake root directory, userd for tests
    # config_dir => /etc/foo',    # absolute path 
    # file       => 'foo.conf',   # file name
    # file_path  => './my_test/etc/foo/foo.conf' 
    # check      => yes|no|skip

    my $fp = $args{file_path};

    return 0 unless defined $fp and $fp->is_file ;

    $logger->info("Parsing $fp");
    # load dpkgctrl file
    my $c = $self -> parse_dpkg_file ($fp, $args{check}, 1 ) ;

    # fix Debian #735000: ask for infos for all packages not in cache in one go.
    $self->fill_package_cache ($c);

    my $root = $args{object} ;
    my $check = $args{check} ;
    my $file;
    
    $logger->debug("Reading control source info");

    # first section is source package, following sections are binary package
    my $node = $root->fetch_element(name => 'source', check => $check) ;
    $self->read_sections ($node, shift @$c, shift @$c, $check);

    $logger->debug("Reading binary package names");
    # we assume that package name is the first item in the section data

    while (@$c ) {
        my ($section_line,$section) = splice @$c,0,2 ;
        my $package_name;
        my @section_comment;
      SECTION_LOOP:
        foreach (my $i = 0; $i < $#$section; $i += 2) {
            if ($section->[$i] =~ /^package$/i) {
                # skip comment lines (plain scalar) before looking for
                # package name (stored in first elt of array ref)
                foreach my $section_data ( $section->[ $i+1 ]->@* ) {
                    if (ref $section_data) {
                        $package_name = $section_data->[0];
                        splice @$section,$i,2 ;
                        last SECTION_LOOP;
                    }
                    else {
                        push @section_comment, $section_data;
                    }
                }
            }
        }

        if (not defined $package_name) {
            my $msg = "Cannot find package_name in section beginning at line $section_line";
            Config::Model::Exception::Syntax
                  -> throw (object => $root,  error => $msg, parsed_line => $section_line) ;
        }

        $node = $root->grab("binary:$package_name") ;
        $node->annotation(@section_comment) if @section_comment;
        $self->read_sections ($node, $section_line, $section, $args{check});
    }
    return 1 ;
}

sub fill_package_cache ($self, $c) {

    # scan data to find package name and query madison for info for all packages in a single call
    my %packages; # use a hash to eliminate duplicates
    foreach my $s (@$c) {
        next unless ref $s eq 'ARRAY' ;
        my %section = @$s ; # don't care about order

        foreach my $found (keys %section) {
            if ($found =~ /Depends|Suggests|Recommends|Enhances|Breaks|Conflicts|Replaces/) {
                # $section{found} array is [ [ dep, line_nb, altered_value , comment ], ..]
                map { $packages{$_} = 1 }
                    grep { not /\$/ } # skip debhelper variables
                    map {
                        my $l = $_;
                        chomp $l;
                        $l =~ s/\[.*\]//g; # remove arch details
                        $l =~ s/<.*>//;    # remove build profile
                        $l =~ s/\(.*\)//;  # remove version details
                        $l =~ s/\s//g;
                        $l =~ s/,\s*$//;   # remove trailing comma
                        $l =~ s/:\w+//;    # remove arch qualifier
                        $l;
                    }
                    grep { $_ }      # skip empty data
                    map { split /\s*[,|]\s*/ , $_->[0] } # extract dependency info from array ref
                    grep { ref $_ } # skip empty section
                    $section{$found}->@*;
            }
        }
    }
    my @pkgs = keys %packages;
    Config::Model::Dpkg::Dependency::cache_info_from_madison ($self->node->instance,@pkgs);
    return;
}

sub read_sections {
    my $self = shift ;
    my $node = shift;
    my $section_line = shift ;
    my $section = shift;
    my $check = shift || 'yes';

    my %sections ;
    for (my $i=0; $i < @$section ; $i += 2 ) {
        my $key = $section->[$i];
        my $lc_key = lc($key); # key are not key sensitive
        $sections{$lc_key} = [ $key , $section->[$i+1] ]; 
    }

    foreach my $key ($node->get_element_name) {
        my $ref = delete $sections{lc($key)} ;
        next unless defined $ref ;
        $self->store_section_element_in_tree ($node,$check, @$ref);
    }
    
    # leftover sections should be either accepted or rejected
    foreach my $lc_key (keys %sections) {
        my $ref = delete $sections{$lc_key} ;
        $self->store_section_element_in_tree ($node,$check, @$ref);
    }
    return;
}

#
# New subroutine "store_section_element_in_tree" extracted - Mon Jul  4 13:35:50 2011.
#
sub store_section_element_in_tree {
    my $self  = shift;
    my $node  = shift;
    my $check = shift;
    my $key   = shift;
    my $v_ref = shift;

    $logger->info( "reading key '$key' from control file (for node "
          . $node->location
          . ")" );

    # control parameters are case insensitive. Falling back on $key
    # means $key is unknown. fetch_element will trigger a meaningful
    # error message
    my $found = $node->find_element( $key, case => 'any' ) || $key;

    # v_ref is a list of (@comment , [ value, $line_nb ,$note ] )

    my $elt_obj = $node->fetch_element( name => $found, check => $check );
    my $type = $node->element_type($found);

    if ( $type eq 'list' ) {
        $self->store_section_list_element ( $logger,  $elt_obj, $check, $v_ref);
    }
    elsif ($found eq 'Description' and $elt_obj) {
        my @comment = grep { not ref($_) } $v_ref->@*;
        my ($synopsis_ref, @desc_ref) = grep { ref($_) } $v_ref->@*;
        # comment is attached to synopsis to write it back at the same place.
        $self->store_section_leaf_element ( $logger, $node->fetch_element('Synopsis'), $check, [@comment, $synopsis_ref]);
        $self->store_section_leaf_element ( $logger, $node->fetch_element('Description'), $check, \@desc_ref);
    }
    elsif ($elt_obj ) {
        $self->store_section_leaf_element ( $logger, $elt_obj, $check, $v_ref);
    }
    else {
        # try anyway to trigger an error message
        my $unexpected_obj = $node->fetch_element($key);
        $self->store_section_leaf_element ( $logger, $unexpected_obj, $check, $v_ref);
    }
    return;
}


sub write ($self, %args) { ## no critic (ProhibitBuiltinHomonyms)
    # args is:
    # object     => $obj,         # Config::Model::Node object 
    # root       => './my_test',  # fake root directory, userd for tests
    # config_dir => /etc/foo',    # absolute path 
    # file       => 'foo.conf',   # file name
    # file_path  => './my_test/etc/foo/foo.conf' 

    my $node = $args{object} ;
    my @sections = [ $self-> package_spec($node->fetch_element('source')) ];

    my $binary_hash = $node->fetch_element('binary') ;
    foreach my $binary_name ( $binary_hash -> fetch_all_indexes ) {
        my $node = $binary_hash->fetch_with_id($binary_name);
        my @section_lines = ();
        my $c = $node->annotation ;
        push @section_lines, map {'#'.$_} split /\n/,$c if $c ;
        push @section_lines , Package => $binary_name , $self->package_spec($node) ;

        push @sections, \@section_lines ;
    }

    my $res = $self->write_dpkg_file(\@sections,",\n" ) ;
    $args{file_path}->spew_utf8($res);

    return 1;
}

sub _re_order ($list, $move_after) {
    my $i = 0;
    while ( $i < $move_after->@* ) {
        my $k = $move_after->[$i++];
        my $v = $move_after->[$i++];
        my ($ik, $iv);
        my $j = 0;
        map { $ik = $j if $_ eq $k; $iv = $j if $_ eq $v; $j++ } @$list;
        next unless defined $ik and defined $iv;
        splice @$list, $ik, 1; # remove $k from list
        splice @$list, $iv, 0, $k; # add back $k after $v
    }
    return;
}

my @move_after = (
    'Standards-Version' => 'Built-Using',
);

sub package_spec ( $self, $node ) {
    # can't use a static list as element can be created by user (with
    # the accept condition)
    my @list = $node->get_element_name;
    _re_order(\@list, \@move_after);
    return $self->node_to_section($node, \@list)
}


1;

__END__

=head1 NAME

Config::Model::Backend::Dpkg::Control - Read and write Debian Dpkg control information

=head1 SYNOPSIS

No synopsis. This class is dedicated to configuration class C<Dpkg::Control>

=head1 DESCRIPTION

This module is used directly by L<Config::Model> to read or write the
content of Debian C<control> file.

All C<control> files keyword are read in a case-insensitive manner.

=head1 CONSTRUCTOR

=head2 new

Parameters: C<< node => $node_obj, name => 'Dpkg::Control' >>

Inherited from L<Config::Model::Backend::Any>. The constructor will be
called by L<Config::Model::AutoRead>.

=head2 read

Read control file and return 1.

=head2 write

Write data to control file and return 1.

=head1 AUTHOR

Dominique Dumont, (ddumont at cpan dot org)

=head1 SEE ALSO

L<Config::Model>, 
L<Config::Model::AutoRead>, 
L<Config::Model::Backend::Any>, 

=cut
