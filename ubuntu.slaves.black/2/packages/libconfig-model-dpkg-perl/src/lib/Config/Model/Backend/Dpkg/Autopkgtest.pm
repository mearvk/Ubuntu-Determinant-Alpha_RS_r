package Config::Model::Backend::Dpkg::Autopkgtest;

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
use IO::File;

my $logger = get_logger("Backend::Dpkg::Autopkgtest");
my $user_logger = get_logger('User');

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

    $self->parse_control_file($fp, $args{object}, $args{check});

    return 1;
}

sub parse_control_file ($self, $control_file, $node, $check) {
    $logger->info("Parsing $control_file");
    # load autopkgtest control file
    my $c = $self -> parse_dpkg_file ($control_file, $check, 1 ) ;

    my $test_list = $node->fetch_element('control');
    my $test_nb = 0;

    while (@$c ) {
        my ($section_line,$section) = splice @$c,0,2 ;
        my $test_obj = $test_list->fetch_with_id($test_nb++);

        foreach ( my $i = 0 ; $i < $#$section ; $i += 2 ) {
            my $key = $section->[$i];
            my $section_data = $section->[ $i + 1 ];
            if ( my $elt = $test_obj->find_element( $key, case => 'any' ) ) {
                my $elt_obj = $test_obj->fetch_element($elt);
                if ($test_obj->element_type($elt) eq 'list') {
                    $self->store_section_list_element ( $logger, $elt_obj, $check, $section_data);
                }
                else {
                    $self->store_section_leaf_element ( $logger, $elt_obj, $check, $section_data);
                }
            }
            else {
                $user_logger->warn("Unknown parameter found in $control_file: $key");
            }
        }
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

    $self->write_control_file($args{object}, $args{file_path});

    return 1;
}

sub write_control_file ($self, $node, $control_file) {
    my @sections;

    my $test_list = $node->fetch_element('control');
    foreach my $test_nb ( $test_list -> fetch_all_indexes ) {
        push @sections, [ $self->node_to_section($test_list->fetch_with_id($test_nb)) ];
    }

    my $res = $self->write_dpkg_file(\@sections,", " ) ;

    $control_file->spew_utf8($res);

    return;
}

1;

__END__

=head1 NAME

Config::Model::Backend::Dpkg::Autopkgtest - Read and write Debian Dpkg Autopkgtest information

=head1 SYNOPSIS

No synopsis. This class is dedicated to configuration class C<Dpkg::Autopkgtest>

=head1 DESCRIPTION

This module is used directly by L<Config::Model> to read or write the
content of Debian C<Autopkgtest> file.

All C<Autopkgtest> files keyword are read in a case-insensitive manner.

=head1 CONSTRUCTOR

=head2 new

Parameters: C<< node => $node_obj, name => 'Dpkg::Autopkgtest' >>

Inherited from L<Config::Model::Backend::Any>. The constructor will be
called by L<Config::Model::AutoRead>.

=head2 read

Read data from Autopkgtest files.

When a file is read, C<read()> returns 1.

=head2 write

Write data to Autopkgtest files.

C<write()> returns 1.

=head1 AUTHOR

Dominique Dumont, (ddumont at cpan dot org)

=head1 SEE ALSO

L<Config::Model>, 
L<Config::Model::AutoRead>, 
L<Config::Model::Backend::Any>, 

=cut
