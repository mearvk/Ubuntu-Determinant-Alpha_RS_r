package Config::Model::Backend::Dpkg::DebHelperFile;

use strict;
use warnings;
use Mouse;

extends 'Config::Model::Backend::PlainFile';

use 5.20.1;

use feature qw/postderef signatures/;
no warnings qw/experimental::postderef experimental::signatures/;

use Carp;
use Config::Model::Exception;
use Log::Log4perl qw(get_logger);
use IO::File;
use Path::Tiny;

my $logger = get_logger("Backend.Dpkg.DebHelperFile");
my $user_logger = get_logger('User');

sub get_file_name {
    my ($self, %args) = @_;

    my $obj = $args{object}->fetch_element( name => $args{elt} );
    my $dh_file_type =  $args{file} ? $obj->compute_string($args{file}) : $args{elt};

    my $key = $obj->parent->index_value;
    return $key eq '.'  ? $dh_file_type
        :  $key =~ m!^\./! ? $key =~ s!\./!$dh_file_type.!r
        :  $key =~ m!/! ? $key =~ s!/!.$dh_file_type.!r
        :                 "$key.$dh_file_type";
}

1;

# ABSTRACT: Read and write DebHelper files

__END__

=head1 NAME

Config::Model::Backend::Dpkg::DebHelperFile - R/W backend for DebHelper files

=head1 SYNOPSIS

No synopsis. Internal class for cme dpkg

=head1 DESCRIPTION

This backend module is used directly by L<Config::Model> to read or
write the content of Debian DebHelper files like C<debian/install>,
C<debian/package.postinst> and any variation thereof.

The backend must be declared with:

 'backend' => 'Dpkg::DebHelperFile',
 'config_dir' => 'debian',
 'file' => 'install'

The C<file> parameter specifies the "main" name of the dh file, for
instance "install", "postinst" ... This parameter can also be used to
specify a file name that take into account the path in the tree using
C<&index()> and C<&element()> functions from
L<Config::Model::Role::ComputeFunction>.

The backend will then be able to load files like C<install>,
C<pkg.install>, C<pkg.postinst.amd64>...

This backend is derived from L<Config::Model::Backend::PlainFile>

=head1 AUTHOR

Dominique Dumont, (dod at debian.org)

=head1 SEE ALSO

L<Config::Model>, L<Config::Model::Backend::PlainFile>, L<Config::Model::Backend::Any>, L<debhelper(7)>

=cut

