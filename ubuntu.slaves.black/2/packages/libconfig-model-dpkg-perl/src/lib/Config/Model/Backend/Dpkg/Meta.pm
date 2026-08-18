package Config::Model::Backend::Dpkg::Meta;

use strict;
use warnings;
use Mouse;

extends 'Config::Model::Backend::Any';
with 'Config::Model::Role::FileHandler';

use 5.20.1;

use feature qw/postderef signatures/;
no warnings qw/experimental::postderef experimental::signatures/;

use Carp;
use Config::Model::Exception;
use Log::Log4perl qw(get_logger :levels);
use IO::File;
use YAML::XS qw/LoadFile DumpFile/;
use Path::Tiny;
use List::Util qw/reduce/;

$YAML::XS::LoadBlessed = 0;

my $logger = get_logger("Backend.Dpkg.Meta");
my $user_logger = get_logger('User');

# simplified version of YAML backend with provision to read from old
# location

# legacy locations
my %locations = (
    '~/' => '.dpkg-meta.yml',
    '~/.local/share/' => '.dpkg-meta.yml'
);

# correct location
my $xdg_config_dir = $ENV{XDG_CONFIG_HOME} || '~/.config';
$xdg_config_dir .= '/' unless $xdg_config_dir =~ m!/$!;
my $correct_dir = $xdg_config_dir . 'config-model';
my $correct_file = $locations{$correct_dir} = 'dpkg-meta.yml';

has 'config_file' => (
    is => 'rw',
);

sub _get_cfg_dir {
    my ($self,$root, $location_dir) = @_;
    my $dir = $self->get_tuned_config_dir(
        config_dir => $location_dir,
        root => $root
    );
    my $file =  $dir->child($locations{$location_dir});
    return $file;
}

sub read ($self, %args) { ## no critic (ProhibitBuiltinHomonyms)
    # args is:
    # object     => $obj,         # Config::Model::Node object
    # root       => './my_test',  # fake root directory, userd for tests
    # check      => yes|no|skip

    my $file = reduce { $a->stat->mtime > $b->stat->mtime ? $a : $b;}
        grep { $_->exists; }
        map { $self->_get_cfg_dir($args{root}, $_) }
        keys %locations;

    return 0 unless $file;    # no file to read

    my $correct_loc =  $self->_get_cfg_dir($args{root}, $correct_dir);
    if ($file ne $correct_loc) {
        my $new_loc =  $self->_get_cfg_dir($args{root}, $correct_dir);
        $logger->info("Reading data from legacy file $file");
        # This will trigger a write of my_config data even if no value
        # was changed in my_config
        $self->node->notify_change(
            note => "Moving my_config data from legacy file ($file) to $new_loc",
            really => 1,
        );
    }

    # load yaml file
    my $cf = $self->config_file(path($file));
    $logger->debug("Loading Dpkg Meta file $cf");

    # convert to perl data
    my $perl_data = LoadFile($cf->stringify) ;
    if ( not defined $perl_data ) {
        $logger->info("No data found in YAML file $cf");
        return 1;
    }

    # load perl data in tree
    $self->node->load_data( data => $perl_data, check => $args{check} || 'yes' );
    return 1;
}

sub write ($self, %args) { ## no critic (ProhibitBuiltinHomonyms)
    # args is:
    # object     => $obj,         # Config::Model::Node object
    # root       => './my_test',  # fake root directory, userd for tests
    # check      => yes|no|skip

    my $perl_data = $self->node->dump_as_data( full_dump => $args{full_dump} // 0);

    my $correct_loc =  $self->_get_cfg_dir($args{root}, $correct_dir);

    if (keys %$perl_data) {
        # write file in correct location
        $logger->debug("Writing dpkg my_config file " . $correct_loc);
        $correct_loc->parent->mkpath;
        DumpFile($correct_loc->stringify, $perl_data);
    }
    elsif ($correct_loc->is_file) {
        $logger->debug("No data in dpkg my_config: Removing file " . $correct_loc);
        $correct_loc->remove;
    }

    if ($self->config_file and $self->config_file ne $correct_loc) {
        $logger->info("Removing legacy dpkg my_config file ". $self->config_file);
        $self->config_file->remove;
    }

    return 1;
}

1;

# ABSTRACT: Read and write dpkg my_config data

__END__

=head1 NAME

Config::Model::Backend::Dpkg::Meta - R/W backend for my_config data

=head1 SYNOPSIS

No synopsis. Internal class for cme dpkg

=head1 DESCRIPTION

This module is used directly by L<Config::Model> to read or write the
content of Dpkg my_config parameter written with YAML syntax.

This file handles the move from legacy config files (C<~/.dpkg-meta.yml> and 
C<~/.local/share/.dpkg-meta.yml>) to C<$ENV{XDG_CONFIG_HOME}/config-model/dpkg-meta.yml>
or C<~/.config/config-model/dpkg-meta.yml>.

This module uses L<YAML::XS>.

=head1 AUTHOR

Dominique Dumont, (ddumont at cpan dot org)

=head1 SEE ALSO

L<Config::Model>, L<Config::Model::BackendMgr>, L<Config::Model::Backend::Any>

=cut
