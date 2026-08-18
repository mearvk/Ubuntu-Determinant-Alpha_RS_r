package Debian::AptContents;

use strict;
use warnings;

our $VERSION = '0.116';

=head1 NAME

Debian::AptContents - parse/search through apt-file's Contents files

=head1 SYNOPSIS

    my $c = Debian::AptContents->new( { cache_dir => '~/.cache/dh-make-perl' } );
    my @pkgs = $c->find_file_packages('/usr/bin/foo');
    my $dep = $c->find_perl_module_package('Foo::Bar');

=head1 TODO

This needs to really work not only for Perl modules.

A module specific to Perl modules is needed by dh-make-perl, but it can
subclass Debian::AptContents, which needs to become more generic.

=cut

use base qw(Class::Accessor);
__PACKAGE__->mk_accessors(
    qw(
        homedir cache cache_dir cache_file contents_files verbose
        source dist
        )
);

use Config;
use Debian::Dependency;
use DhMakePerl::Utils qw(find_core_perl_dependency is_core_perl_package);
use File::Spec::Functions qw( catfile catdir splitpath );
use File::Path qw(make_path);
use IO::Uncompress::Gunzip;
use List::MoreUtils qw(uniq);
use Module::CoreList ();
use Storable;
use AptPkg::Config;

$AptPkg::Config::_config->init();

our $oldstable_perl = '5.14.2';

=head1 CONSTRUCTOR

=over

=item new

Constructs new instance of the class. Expects at least C<cache_dir> option.

=back

=head1 FIELDS

=over

=item cache_dir

(B<mandatory>) Directory where the object stores its cache.

=item homedir

Legacy option to specify the cache directory.

=item dist

Used for filtering on the C<distributon> part of the repository paths listed in
L<sources.list>. Default is empty, meaning no filtering.

=item contents_files

Arrayref of F<Contents> file names. Default is to let B<apt-file> find them.

=item cache_file

Path to the file with cached parsed information from all F<Contents> files.
Default is F<Contents.cache> under C<cache_dir>.

=item cache

Filled by C<read_cache>. Used by C<find_file_packages> and (obviously)
C<store_cache>

=item verbose

Verbosity level. 0 means silent, the bigger the more the jabber. Default is 1.

=back

=cut

sub new {
    my $class = shift;
    $class = ref($class) if ref($class);
    my $self = $class->SUPER::new(@_);

    # backwards compatibility
    $self->cache_dir( $self->homedir )
        if $self->homedir and not $self->cache_dir;

    # required options
    $self->cache_dir
        or die "No cache_dir given";

    # some defaults
    $self->contents_files( $self->get_contents_files )
        unless $self->contents_files;
    $self->cache_file( catfile( $self->cache_dir, 'Contents.cache' ) )
        unless $self->cache_file;
    $self->verbose(1) unless defined( $self->verbose );

    $self->read_cache();

    return $self;
}

=head1 OBJECT METHODS

=over

=item warning

Used internally. Given a verbosity level and a message, prints the message to
STDERR if the verbosity level is greater than or equal of the value of
C<verbose>.

=cut

sub warning {
    my ( $self, $level, $msg ) = @_;

    warn "$msg\n" if $self->verbose >= $level;
}

=item get_contents_files

Reads F<sources.list>, gives the repository paths to
C<repo_source_to_contents_paths> and returns an arrayref of file names of
Contents files.

=cut

sub get_contents_files {
    my $self = shift;

    my $archspec = `dpkg --print-architecture`;
    chomp($archspec);

    my @res;

    # stolen from apt-file, contents_file_paths()
    my @cmd = (
        'apt-get',  'indextargets',
        '--format', '$(CREATED_BY) $(ARCHITECTURE) $(SUITE) $(FILENAME)'
    );
    open( my $fd, '-|', @cmd )
        or die "Cannot execute apt-get indextargets: $!\n";
    while ( my $line = <$fd> ) {
        chomp($line);
        next unless $line =~ m/^Contents-deb/;
        my ( $index_name, $arch, $suite, $filename ) = split( ' ', $line, 4 );
        next unless $arch eq $archspec or $arch eq 'all';
        if ( $self->dist ) {
            next unless $suite eq $self->dist;
        }
        push @res, $filename;
    }
    close($fd);

    return [ uniq sort @res ];
}

=item read_cache

Reads the cached parsed F<Contents> files. If there are F<Contents> files with
more recent mtime than that of the cache (or if there is no cache at all),
parses all F<Contents> and stores the cache via C<store_cache> for later
invocation.

=cut

# distribute files so that the load (measured by file size) is distributed
# more or less equally
sub _distribute_files {
    my ( $self, $files, $cpus ) = @_;

    $cpus = scalar(@$files) if scalar(@$files) < $cpus;

    return $files unless $cpus > 1;

    my @data = map( { file => $_, size => -s $_ }, @$files );
    @data = sort { $b->{size} <=> $a->{size} } @data;

    my ( @slots, @slot_load );
    for(1..$cpus) {
        push @slots, [];
        push @slot_load, 0;
    }

    for my $item (@data) {
        my $lightest_slot = 0;
        my $lightest_slot_load = $slot_load[0];
        for my $slot ( 1 .. $#slots ) {
            next unless $slot_load[$slot] < $lightest_slot_load;

            $lightest_slot      = $slot;
            $lightest_slot_load = $slot_load[$slot];
        }

        push @{ $slots[$lightest_slot] }, $item->{file};
        $slot_load[$lightest_slot] += $item->{size};
    }

    if (0) {
        for my $slot (@slots) {
            warn "Slot package: \n";
            warn sprintf( "  %8d=%s\n", -s $_, $_ ) for @$slot;
        }
    }

    return @slots;
}

sub read_cache {
    my $self = shift;

    my $cache;

    if ( -r $self->cache_file ) {
        $cache = eval { Storable::retrieve( $self->cache_file ) };
        undef($cache) unless ref($cache) and ref($cache) eq 'HASH';
    }

    # see if the cache is stale
    if ( $cache and $cache->{stamp} and $cache->{contents_files} ) {
        undef($cache)
            unless join( '><', @{ $self->contents_files } ) eq
                join( '><', @{ $cache->{contents_files} } );

        # file lists are the same?
        # see if any of the files has changed since we
        # last read it
        if ($cache) {
            for ( @{ $self->contents_files } ) {
                if ( ( stat($_) )[9] > $cache->{stamp} ) {
                    undef($cache);
                    last;
                }
            }
        }
    }
    else {
        undef($cache);
    }

    unless ($cache) {
        if ( scalar @{ $self->contents_files } ) {
            $self->source('parsed files');
            $cache->{stamp}          = time;
            $cache->{contents_files} = [];
            $cache->{apt_contents}   = {};

            push @{ $cache->{contents_files} }, @{ $self->contents_files };

            {
                my $prefix;
                for my $f ( @{ $self->contents_files } ) {
                    if ( defined($prefix) ) {
                        chop($prefix)
                            while length($prefix)
                            and not $f =~ /^\Q$prefix\E/;
                    }
                    else {
                        $prefix = $f;
                    }
                }
                $self->warning(
                    1,
                    "Parsing Contents files:\n\t"
                        . join( "\n\t",
                        map { my $x = $_; $x =~ s{^\Q$prefix\E}{}; $x }
                            @{ $self->contents_files } )
                );
            }

            require IO::Pipe; require IO::Select;
            my $cpus = eval { require Sys::CPU; Sys::CPU::cpu_count() };
            unless ($cpus) {
                $self->warning( 1, "Sys::CPU not available");
                $self->warning( 1, "Using single parser process");
                $cpus = 1;
            }

            # parsing of Contents files goes to forked children. contents_files
            # is sorted by size, so that no child can have only long Contents.
            # the number of children is capped to the number of CPUs on the system
            my ( @kids, %kid_by_fh );
            for my $portion (
                $self->_distribute_files( $self->contents_files, $cpus ) )
            {
                push @kids, { files => $portion, lines => 0 };
            }

            my $sel = IO::Select->new;

            # start the children
            for my $kid (@kids) {
                my $pipe = IO::Pipe->new;
                if ( my $pid = fork() ) {    # parent
                    $pipe->reader;

                    $kid_by_fh{ $pipe->fileno } = $kid;
                    $kid->{io}                  = $pipe;
                    $kid->{pid}                 = $pid;
                    $sel->add( $pipe->fileno );
                }
                elsif ( defined($pid) ) {    # child
                    $pipe->writer;
                    my @cat_cmd = (
                        '/usr/lib/apt/apt-helper', 'cat-file',
                        @{ $kid->{files} }
                    );

                    open( my $f, "-|", @cat_cmd )
                        or die sprintf( "Error running '%s': %d\n",
                        join( ' ', @cat_cmd ), $! );

                    my $line;
                    while ( defined( $line = $f->getline ) ) {
                        my ( $file, $packages ) = split( /\s+/, $line );
                        next unless $file =~ s{
                            ^usr/
                            (?:share|lib)/
                            (?:perl\d+/            # perl5/
                            | perl/(?:\d[\d.]+)/   # or perl/5.10/
                            | \S+-\S+-\S+/perl\d+/(?:\d[\d.]+)/  # x86_64-linux-gnu/perl5/5.22/
                            )
                        }{}x;
                        $pipe->print("$file\t$packages\n");
                    }
                    close($f);
                    close($pipe);
                    exit(0);
                }
                else {
                    die "fork(): $!";
                }
            }

            # read children's output
            while ( $sel->count
                and my @ready = IO::Select->select( $sel, undef, $sel ) )
            {
                my ( $to_read, undef, $errs ) = @ready;

                for my $fh (@$to_read) {
                    my $kid = $kid_by_fh{$fh};
                    my $io = $kid->{io}; my $file = $kid->{file};
                    if ( defined( my $line = <$io> ) ) {
                        chomp($line);
                        $kid->{lines}++;
                        my ( $file, $packages ) = split( '\t', $line );
                        $cache->{apt_contents}{$file} =
                            exists $cache->{apt_contents}{$file}
                            ? $cache->{apt_contents}{$file} . ',' . $packages
                            : $packages;

                        # $packages is a comma-separated list of
                        # section/package items. We'll parse it when a file
                        # matches. Otherwise we'd parse thousands of entries,
                        # while checking only a couple
                    }
                    else {
                        warn sprintf( "child %d (%s) EOF after %d lines\n",
                            $kid->{pid}, $kid->{file}, $kid->{lines} )
                            if 0;
                        $sel->remove($fh);
                        close( $kid->{io} );
                        waitpid( $kid->{pid}, 0 );
                    }
                }

                for my $fh (@$errs) {
                    my $kid = $kid_by_fh{$fh};
                    $sel->remove($fh);
                    close( $kid->{io} );
                    waitpid( $kid->{pid}, 0 );
                    die sprintf( "child %d (%s) returned %d\n",
                        $kid->{pid}, join( ', ', @{ $kid->{files} } ), $? );
                }
            }

            if ( %{ $cache->{apt_contents} } ) {
                $self->cache($cache);
                $self->store_cache;
            }
        }
    }
    else {
        $self->source('cache');
        $self->warning( 1,
            "Using cached Contents from " . localtime( $cache->{stamp} ) );

        $self->cache($cache);
    }
}

=item store_cache

Writes the contents of the parsed C<cache> to the C<cache_file>.

Storable is used to stream the data. Along with the information from
F<Contents> files, a time stamp is stored.

=cut

sub store_cache {
    my $self = shift;

    my ( $vol, $dir, $file ) = splitpath( $self->cache_file );

    $dir = catdir( $vol, $dir );
    unless ( -d $dir ) {
        make_path( $dir )
            or die "Error creating directory '$dir': $!\n";
    }

    Storable::nstore( $self->cache, $self->cache_file . '-new' );
    rename( $self->cache_file . '-new', $self->cache_file );
}

=item find_file_packages

Returns a list of packages where the given file was found.

F<Contents> files store the package section together with package name. That is
stripped.

Returns an empty list of the file is not found in any package.

=cut

sub find_file_packages {
    my ( $self, $file ) = @_;

    my $packages = $self->cache->{apt_contents}{$file};

    return () unless $packages;

    my @packages = split( /,/, $packages );    # Contents contains a
                                               # comma-delimited list
                                               # of packages

    s{.+/}{} for @packages;                    # remove section. Greedy on purpose
                                               # otherwise it won't strip enough off Ubuntu's
                                               # usr/share/perl5/Config/Any.pm  universe/perl/libconfig-any-perl

    # in-core dependencies are given by find_core_perl_dependency
    @packages = grep { !is_core_perl_package($_) } @packages;

    return uniq @packages;
}

=item find_perl_module_package( $module, $version )

Given Perl module name (e.g. Foo::Bar), returns a L<Debian::Dependency> object
representing the required Debian package and version. If the module is only in perl core,
a suitable dependency on perl is returned.

For dual-lived modules, which are in perl and in a separate package, only
the latter is returned, as the perl package has versioned Provides for them.

=cut

sub find_perl_module_package {
    my ( $self, $module, $version ) = @_;

    # see if the module is included in perl core
    my $core_dep = find_core_perl_dependency( $module, $version );

    # try module packages
    my $module_file = $module;
    $module_file =~ s|::|/|g;

    my @matches = $self->find_file_packages("$module_file.pm");

    # rank non -perl packages lower
    @matches = sort {
        if    ( $a !~ /-perl$/ ) { return 1; }
        elsif ( $b !~ /-perl$/ ) { return -1; }
        else                     { return $a cmp $b; }    # or 0?
    } @matches;

    # we don't want perl packages here
    @matches = grep { !is_core_perl_package($_) } @matches;

    my $direct_dep;
    $direct_dep = Debian::Dependency->new(
          ( @matches > 1 )
        ? [ map ( { pkg => $_, rel => '>=', ver => $version }, @matches ) ]
        : ( $matches[0], $version )
    ) if @matches;

    if ($core_dep) {
        if ($direct_dep) {
            # both in core and in a package.
            return $direct_dep;
        }
        else {
            # only in core
            return $core_dep;
        }
    }
    else {
        # maybe in a package
        return $direct_dep;
    }
}

1;

=back

=head1 AUTHOR

=over 4

=item Damyan Ivanov <dmn@debian.org>

=item gregor herrmann <gregoa@debian.org>

=back

=head1 COPYRIGHT & LICENSE

=over 4

=item Copyright (C) 2008, 2009, 2010, 2017 Damyan Ivanov <dmn@debian.org>

=item Copyright (C) 2016, 2019 gregor herrmann <gregoa@debian.org>

=back

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License version 2 as published by the Free
Software Foundation.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program; if not, write to the Free Software Foundation, Inc., 51 Franklin
Street, Fifth Floor, Boston, MA 02110-1301 USA.

=cut
