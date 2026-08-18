package Config::Model::Backend::Dpkg::Patch;

use strict;
use warnings;
use Mouse;

extends 'Config::Model::Backend::Any';

with 'Config::Model::Backend::DpkgSyntax';
with 'Config::Model::Backend::DpkgStoreRole';

use 5.20.1;

use feature qw/postderef signatures/;
no warnings qw/experimental::postderef experimental::signatures/;

use Carp;
use Config::Model::Exception;
use Log::Log4perl qw(get_logger :levels);
use Path::Tiny;

my $logger = get_logger("Backend::Dpkg::Patch");

sub skip_open { return 1;}

# TODO: use a role provided by Config::Model
sub cfg_path ($self, %args) {
    my $cfg_dir   = $args{config_dir};
    my $dir
        = $args{root}   ? path($args{root})->child($cfg_dir)
        : ref($cfg_dir) ? $cfg_dir
        :                 path( $cfg_dir);
    return $dir;
}

sub read ($self, %args) { ## no critic (ProhibitBuiltinHomonyms)
    # args is:
    # object     => $obj,         # Config::Model::Node object
    # root       => './my_test',  # fake root directory, userd for tests
    # config_dir => /etc/foo',    # absolute path
    # file       => 'foo.conf',   # file name
    # file_path  => './my_test/etc/foo/foo.conf'
    # check      => yes|no|skip

    my $cfg_dir   = $args{config_dir};
    my $patch_dir = $self->cfg_path(%args);

    my $check     = $args{check};
    my $node      = $args{object};

    my $backend_arg = $self->instance->backend_arg;
    my $patch_name = $node->index_value || $backend_arg;

    my $patch_file = $patch_dir->child($patch_name) ;
    $self->{patch_file} = $patch_file;

    $logger->info("Parsing patch $patch_file");

    my ( $header, $diff ) = ( [],[] );
    my $target = $header;
    foreach my $l ( $patch_file->lines_utf8 ) {
        if ( $l =~ /^---/ ) {
            # beginning of quilt style patch
            $target = $diff;
        }
        elsif ( $l =~ /^===/ ) {
            # beginning of git diff style patch
            push @$diff, pop @$header if $target eq $header;    # get back the Index: line
            $target = $diff;
        }
        push @$target, $l;
    }
    chomp @$header;

    # remove last blank line (added back by writer)
    pop @$header if $header->@* and $header->[-1] =~ /^\s*$/;

    my $c = [] ;
    $logger->trace("header: @$header") ;
    my %stuff ;
    my $store_stuff = sub {
        my ($l,$nb) = @_;
        die "undef line nb" unless defined $nb;
        $stuff{$nb} = $l ;
    } ;

    if (@$header) {
        $c = eval { $self->parse_dpkg_lines( $patch_file, $header, $check, 0, $store_stuff ); };
        my $e = $@;
        if ( ref($e) and $e->isa('Config::Model::Exception::Syntax') ) {
            $e->parsed_file( $patch_file->stringify );
            $e->rethrow;
        }
        elsif (ref($e)) {
            $e->rethrow;
        }
        elsif ($e) {
            die $e;
        }

        Config::Model::Exception::Syntax->throw(
            message => "More than 2 sections in $patch_name header",
            parsed_file => $patch_file->stringify,
        )
          if @$c > 4; # $c contains [ line_nb, section_ref ]
    }

    my @description_text ;
    my $synopsis_in_subject = 0;
    while (@$c) {
        my ( $section_line, $section ) = splice @$c, 0, 2;
        foreach ( my $i = 0 ; $i < $#$section ; $i += 2 ) {
            my $key = $section->[$i];
            my $v_ref = $section->[ $i + 1 ];
            if ( my $found = $node->find_element( $key, case => 'any' ) ) {
                my $elt = $found ;
                my $to_store = $v_ref;
                if ($found eq 'Subject') {
                    # here Synopsis is Subject. DEP-3 does not allow multi line
                    # Subject. This will be cleaned up while storing the value
                    $to_store = [ $v_ref->@* ];
                    $synopsis_in_subject = 1;
                }
                elsif ($found eq 'Description') {
                    if ($synopsis_in_subject) {
                        push @description_text, $v_ref->@*;
                        next;
                    }
                    else {
                        # here Synopsis is the first line of
                        # Description.
                        $elt = 'Synopsis';
                        $to_store = [ shift $v_ref->@* ];
                        push @description_text, $v_ref->@*;
                    }
                }

                my $elt_obj = $node->fetch_element($elt);
                if ($node->element_type($elt) eq 'list') {
                    $self->store_section_list_element ( $logger, $elt_obj, $check, $to_store);
                }
                else {
                    $self->store_section_leaf_element ( $logger, $elt_obj, $check, $to_store);
                }
            }
            else {
                $stuff{$section_line} = "$key: ".join("\n", map {$_->[0]} $v_ref->@*)."\n";
            }
        }
    }

    my $k = 0;
    push @description_text,''; # force a newline between description and salvaged lines

    # add salvaged lines in the order they were found
    push @description_text, map { [$stuff{$_}, $_, ''] } sort { $a <=> $b ;} keys %stuff ;

    my $elt_obj = $node->fetch_element('Description');
    $self->store_section_leaf_element ( $logger, $elt_obj, $check, \@description_text);

    # at last, save the "meat" of the patch
    $node->fetch_element('diff')->store(join('',@$diff));

    return 1;
}

sub write ($self, %args) { ## no critic (ProhibitBuiltinHomonyms)
    # args is:
    # object     => $obj,         # Config::Model::Node object
    # root       => './my_test',  # fake root directory, userd for tests
    # config_dir => /etc/foo',    # absolute path
    # file       => 'foo.conf',   # file name
    # file_path  => './my_test/etc/foo/foo.conf'

    my $check     = $args{check};
    my $node      = $args{object};

    my $patch_file =     $self->{patch_file} ;
    $logger->info("Writing patch $patch_file");
    my $res = '';

    my $synopsis         = $node->fetch_element_value('Synopsis') || "";
    my $description_body = $node->fetch_element_value('Description') ;
    my $subject_body     = $node->fetch_element_value('Subject') ;

    # first: write Description or Subject (where the subject body is written
    # outside the structured text)
    my $outside_text = '';
    if ($subject_body) {
        $res .= "Subject: ";
        $res .= $self->write_dpkg_text($subject_body) ;
        $outside_text .= "$synopsis\n" if $synopsis;
        $outside_text .= "$description_body\n" if $description_body;
    }
    elsif ($description_body) {
        my $to_write = $synopsis . "\n" . $description_body ;
        $res .= "Description: ";
        $res .= $self->write_dpkg_text($to_write) ;
    }
    else {
        # no description body, write only synopsis in Description
        $res .= "Description: ";
        $res .= $self->write_dpkg_text($synopsis) ;
    }

    # second: write all headers
    foreach my $elt ( $node -> get_element_name ) {
        my $elt_obj = $node->fetch_element($elt) ;
        my $type = $node->element_type($elt) ;

        my @v = $type eq 'list' ? $elt_obj->fetch_all_values
              : $type eq 'leaf' ? ($elt_obj->fetch)
              : ();

        foreach my $v (@v) {
            # say "write $elt -> $v" ;
            next unless defined $v and $v;
            next if grep {$elt eq $_} qw/Description Subject Synopsis diff/;

            $res .= "$elt: ";
            $res .= $self->write_dpkg_text($v) ;
        }
    }

    # third: write long description outside of structured fields
    if ($outside_text) {
        $res .= "\n$outside_text\n";
    }

    $res .= $node->fetch_element_value('diff');

    $patch_file->spew_utf8($res);
    return 1;
}

1;

__END__

=head1 NAME

Config::Model::Backend::Dpkg::Patch - Read and write Debian Dpkg Patch information

=head1 SYNOPSIS

No synopsis. This class is dedicated to configuration class C<Dpkg::Patch>

=head1 DESCRIPTION

This module is used directly by L<Config::Model> to read or write the
content of Debian C<Patch> file.

All C<Patch> files keyword are read in a case-insensitive manner.

=head1 CONSTRUCTOR

=head2 new

Parameters: C<< node => $node_obj, name => 'Dpkg::Patch' >>

Inherited from L<Config::Model::Backend::Any>. The constructor will be
called by L<Config::Model::AutoRead>.

=head2 read

Read data from patch file.

=head2 write

Write data to patch file

=head1 AUTHOR

Dominique Dumont, (ddumont at cpan dot org)

=head1 SEE ALSO

L<Config::Model>, 
L<Config::Model::AutoRead>, 
L<Config::Model::Backend::Any>, 

=cut
