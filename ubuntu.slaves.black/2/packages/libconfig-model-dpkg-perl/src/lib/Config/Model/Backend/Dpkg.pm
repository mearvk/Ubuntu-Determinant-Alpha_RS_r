package Config::Model::Backend::Dpkg;

use Carp;
use Mouse;
use Config::Model::Exception;
use UNIVERSAL;
use Path::Tiny 0.054;
use File::Path;
use Log::Log4perl qw(get_logger :levels);
use 5.20.1;

use feature qw/postderef signatures/;
no warnings qw/experimental::postderef experimental::signatures/;

extends 'Config::Model::Backend::PlainFile';

with 'Config::Model::Role::FileHandler';

my $logger = get_logger("Backend::Dpkg::Root");
my $user_logger = get_logger('User');

my %hash_dispatch = (
    patches => \&read_patch_series,
    install => \&read_install_files,
    examples => \&read_examples_files,
    'lintian-overrides' => \&read_lintian_overrides,
);
around read_hash => sub ( $orig, $self, $obj, $elt, $file, $check, $args ) {

    $logger->info("around read_hash called for $elt ".$obj->location." file $file" );
    my $method = $hash_dispatch{$elt} // $orig;

    # $file was made from element name. This does not match the actual
    # files, so we drop it
    $self->$method( $obj, $elt, $check, $args );
};

sub read_examples_files ( $self, $hash, $elt, $check, $args ) {
    my $dir = $self->get_tuned_config_dir(%$args);

    return unless $dir->exists;

    $logger->info("Checking $elt directory ($dir) for ".$hash->location );
    foreach my $file ($dir->children(qr/\.examples$/)) {
        my $pkg =  $file->basename(qr/\.examples$/);
        $logger->info("examples: found $pkg examples file");
        # Just create the element. The read backend will kick in by itself
        $hash->fetch_with_id($pkg);
    }
    return;
}

sub read_install_files ( $self, $hash, $elt, $check, $args ) {
    my $dir = $self->get_tuned_config_dir(%$args);

    return unless $dir->exists;

    $logger->info("Checking $elt directory ($dir) for ".$hash->location );
    if ($dir->child('install')->exists) {
        $hash->fetch_with_id('.');
    }
    foreach my $file ($dir->children(qr/\.install$/)) {
        my $pkg =  $file->basename(qr/\.install$/);
        $logger->info("install: found $pkg install file");
        # Just create the element. The read backend will kick in by itself
        $hash->fetch_with_id($pkg);
    }
    foreach my $file ($dir->children(qr/\.install\./)) {
        my ($pkg, $arch) = split /\.install\./, $file->basename();
        $logger->info("install: found $pkg and $arch install file");
        $hash->fetch_with_id("$pkg/$arch");
    }
    foreach my $file ($dir->children(qr/^install\./)) {
        my ($arch) = ($file->basename() =~ s/^install\.//r) ;
        $logger->info("install: found $arch install file");
        $hash->fetch_with_id("./$arch");
    }
    return;
}

sub read_lintian_overrides ( $self, $hash, $elt, $check, $args ) {
    my $dir = $self->get_tuned_config_dir(%$args);

    return unless $dir->exists;

    $logger->info("Checking $elt directory ($dir) for ".$hash->location );

    my $plain_file = $dir->child('lintian-overrides');
    if ($plain_file->exists) {
        $hash->fetch_with_id('.')->store($plain_file->slurp_utf8);
    }

    foreach my $file ($dir->children(qr/\.lintian-overrides$/)) {
        my $pkg =  $file->basename(qr/\.lintian-overrides$/);
        $logger->info("found $pkg lintian-overrides file");
        $hash->fetch_with_id($pkg)->store($file->slurp_utf8);
    }
    return;
}

sub read_patch_series ( $self, $hash, $elt, $check, $args ) {
    my $patch_dir = $self->get_tuned_config_dir(%$args)->child("patches");
    $logger->info("Checking patches directory ($patch_dir)");

    return unless $patch_dir->is_dir;

    my $series_files = $patch_dir->child("series");

    return unless $series_files->is_file;

    $logger->info("Opening file $series_files");
    # trigger element creation to read patch file_path
    foreach my $pname ( $series_files->lines ) {
        chomp $pname;
		$pname =~ s/#.*//; # skip comment
        next unless $pname =~ /\w/;    # skip empty lines
        my $obj = $hash->fetch_with_id($pname);
        eval { $obj->init; };
        my $e = $@;
        if (ref($e) and $e ->isa('Config::Model::Exception::Syntax')) {
            if ( $args->{check} eq 'yes' ) {
                my $msg = $e ->message;
                $e->message($msg. ". Use -force option to override" );
                $e -> rethrow();
            }
            else {
                $user_logger->warn("Warning: Ignoring patch $pname: ", $e->message);
            }
            $hash->delete($pname);
        }
        elsif (ref($e)) {
            $e->rethrow ;
        }
        elsif ($e) {
            die $e;
        }
        elsif ($logger->is_info) {
            my $location = $obj->name;
            $logger->info("found patch $pname, stored in $location ($obj)");
        }
    }
    return;
}

my %write_hash_dispatch = (
    'lintian-overrides' => \&write_lintian_overrides,
);

sub write ($self, %args) { ## no critic (ProhibitBuiltinHomonyms)
    # args are:
    # object     => $obj,         # Config::Model::Node object
    # root       => './my_test',  # fake root directory, userd for tests
    # config_dir => /etc/foo',    # absolute path read
    # file       => 'foo.conf',   # file name
    # file_path  => './my_test/etc/foo/foo.conf'
    # check      => yes|no|skip

    my $check = $args{check} || 'yes';

    my $dir = $self->get_tuned_config_dir(%args);

    $dir->mkpath;
    my $node = $args{object};
    $logger->debug( "Dpkg write called on node ", $node->name );

    # write data from leaf element from the node
    foreach my $elt ( $node->get_element_name() ) {
        my $file = $dir->child($elt);

        my $obj = $args{object}->fetch_element( name => $elt );
        if (my $method = $write_hash_dispatch{$elt}) {
            $self->$method($dir,$obj);
            next;
        }
        my $type = $obj->get_type;
        my @v;
        my $skip = 0;

        if ( $type eq 'leaf' ) {
            my $lv = $obj->fetch( check => $args{check} );
            if ( defined $lv ) {
                $lv .= "\n" unless $obj->value_type eq 'string';
                push @v, $lv;
            }
        }
        elsif ( $type eq 'list' ) {
            @v = map { "$_\n" } $obj->fetch_all_values;
        }
        else {
            $skip = 1;
            $logger->debug("Dpkg write skipped $type $elt");
        }

        if (@v) {
            $logger->trace("Dpkg write opening $file to write");
            $file->spew_utf8(@v) ;
            $file->chmod("a+x") if $elt eq 'rules';
        }
        elsif ($args{auto_delete} and $file->is_file and not $skip) {
            $user_logger->warn("deleting $file");
            $file->remove;
        }
    }

    return 1;
}

sub write_lintian_overrides ($self, $dir, $hash) {
    foreach my $name ($hash->fetch_all_indexes) {
        my $file = $name eq '.' ? 'lintian-overrides'
            : $name.'.lintian-overrides';

        if (my $content = $hash->fetch_with_id($name)->fetch) {
            $logger->debug( "Dpkg writing $name in $dir");
            $dir->child($file)->spew_utf8($content);
        }
    }
    return;
}

no Mouse;
__PACKAGE__->meta->make_immutable;

1;

__END__

=head1 NAME

Config::Model::Backend::Dpkg - Read and write config as plain file

=head1 SYNOPSIS

 use Config::Model;
 use Log::Log4perl qw(:easy);
 Log::Log4perl->easy_init($WARN);

 my $model = Config::Model->new;

 my $inst = $model->create_config_class(
    name => "WithDpkg",
    element => [
        [qw/source new/] => { qw/type leaf value_type uniline/ },
    ],
    rw_config  => {
            backend => 'Dpkg',
            config_dir => 'debian',
    },
 );

 my $inst = $model->instance(root_class_name => 'WithDpkg' );
 my $root = $inst->config_root ;

 $root->load('source=foo new=yes' );

 $inst->write_back ;

Now C<debian> directory will contain 2 files: C<source> and C<new>
with C<foo> and C<yes> inside.

=head1 DESCRIPTION

This module is used directly by L<Config::Model> to read or write the
content of a Debian package files.  Each element of the Dpkg node is
written in a plain file.

This module supports currently only leaf and list elements.
In the case of C<list> element, each line of the file is a value of the list.

This class is based on  L<Config::Model::Backend::PlainFile> and overrides reading of
files in C<debian/patches> and C<debian/*install> files.

=head1 Methods

See L<Config::Model::Backend::PlainFile>.

=head1 AUTHOR

Dominique Dumont, (dod at debian dot org)

=head1 SEE ALSO

L<Config::Model>,
L<Config::Model::BackendMgr>,
L<Config::Model::Backend::Any>,
L<Config::Model::Backend::PlainFile>,

=cut
