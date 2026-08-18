package Config::Model::Dpkg::Control::Source::StandardVersion ;

use 5.10.1;

use Mouse;
extends 'Config::Model::Value';

use Sort::Versions;
use feature qw/postderef signatures/;
no warnings qw/experimental::postderef experimental::signatures/;
use Carp;

# lintian 2.105.0, #968000
chomp( my $std_ver = qx| /usr/share/lintian/private/latest-policy-version | );
$std_ver =~ s|^(\d+\.\d+\.\d+)(?:\.\d+)?$|$1|;
croak "Failed to get last Standards-Version" unless defined $std_ver;

sub _fetch_std {
    goto &_fetch_std_no_check;
}

sub _fetch_std_no_check {
    return $std_ver;
}

sub compare_with_last_version ($self, $to_check) {
    return versioncmp($to_check, $self->_fetch_std_no_check);
}

__PACKAGE__->meta->make_immutable;

1;

=head1 NAME

Config::Model::Dpkg::Control::Source::StandardVersion - Standard-Version model

=head1 SYNOPSIS

 Internal use for DPkg model

=head1 DESCRIPTION

This class is derived from L<Config::Model::Value>. Its purpose is to
provide a default value for C<Standard-Version> parameter using Lintian library.

=head1 METHODS

=head2 compare_with_last_version

Compare passed version with the latest version of
C<Standards-Version>. This last version is retrieved from C<lintian>
package. The comparison is done with L<Sort::Versions>.

This methods return -1, 0 or 1 depending if the passed version is
older, equal or newer than latest version of C<Standards-Version>

Example:

 $self->compare_with_last_version('3.9.1'); # returns -1

=head1 AUTHOR

Dominique Dumont, ddumont [AT] cpan [DOT] org

=head1 SEE ALSO

L<Config::Model>,
L<Config::Model::Value>,
