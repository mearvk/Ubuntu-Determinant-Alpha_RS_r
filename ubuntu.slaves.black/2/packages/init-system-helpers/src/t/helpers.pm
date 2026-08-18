use strict;
use warnings;
use English;
use File::Temp qw(tempdir); # in core since perl 5.6.1
use File::Copy qw(cp);
use File::Path qw(make_path);

sub check_fakechroot_running() {
    my $content = `FAKECHROOT_DETECT=1 sh -c "echo This should not be printed"`;
    my $result = 0;
    if ($content =~ /^fakechroot [0-9.]+\n$/) {
        $result = 1;
    }
    return $result;
}

sub test_setup() {
    my $tmpdir = tempdir( CLEANUP => 1 );

    if ( !check_fakechroot_running ) {
	print STDERR "you have to run this script inside fakechroot and fakeroot:\n";
	print STDERR ("    fakechroot fakeroot perl $PROGRAM_NAME" . (join " ", @ARGV) . "\n");
	exit 1;
    }

    # Set up a chroot that contains everything necessary to run
    # deb-systemd-helper under fakechroot.
    mkdir "$tmpdir/dev";
    0 == system 'mknod', "$tmpdir/dev/null", 'c', '1', '3' or die "cannot mknod: $?";
    mkdir "$tmpdir/tmp";
    make_path("$tmpdir/usr/bin");
    make_path("$tmpdir/usr/lib/systemd/user");
    make_path("$tmpdir/lib/systemd/system/");
    make_path("$tmpdir/var/lib/systemd");
    make_path("$tmpdir/etc/systemd");
    cp "$FindBin::Bin/../script/deb-systemd-helper",
      "$tmpdir/usr/bin/deb-systemd-helper"
      or die "cannot copy: $!";

    # make sure that dpkg diversion messages are not translated
    local $ENV{LC_ALL} = 'C.UTF-8';
    # the chroot only needs to contain a working perl-base
    open my $fh, '-|', 'dpkg-query', '--listfiles', 'perl-base';

    while ( my $path = <$fh> ) {
        chomp $path;
        # filter out diversion messages in the same way that dpkg-repack does
        # https://git.dpkg.org/cgit/dpkg/dpkg-repack.git/tree/dpkg-repack#n238
        if ($path =~ /^package diverts others to: /) {
            next;
        }
        if ($path =~ /^diverted by [^ ]+ to: /) {
            next;
        }
        if ($path =~ /^locally diverted to: /) {
            next;
        }
        if ($path !~ /^\//) {
            die "path must start with a slash";
        }
        if ( -e "$tmpdir$path" ) {
            # ignore paths that were already created
            next;
        } elsif ( !-r $path ) {
            # if the host's path is not readable, assume it's a directory
            mkdir "$tmpdir$path" or die "cannot mkdir $path: $!";
        } elsif ( -l $path ) {
            symlink readlink($path), "$tmpdir$path";
        } elsif ( -d $path ) {
            mkdir "$tmpdir$path" or die "cannot mkdir $path: $!";
        } elsif ( -f $path ) {
            cp $path, "$tmpdir$path" or die "cannot cp $path: $!";
        } else {
            die "cannot handle $path";
        }
    }
    close $fh;

    $ENV{'SYSTEMCTL_INSTALL_CLIENT_SIDE'} = '1';

    # we run the chroot call in a child process because we need the parent
    # process remaining un-chrooted or otherwise it cannot clean-up the
    # temporary directory on exit
    my $pid = fork() // die "cannot fork: $!";
    if ( $pid == 0 ) {
        chroot $tmpdir or die "cannot chroot: $!";
        chdir "/"      or die "cannot chdir to /: $!";
        return;
    }
    waitpid($pid, 0);

    exit $?;
}

# reads in a whole file
sub slurp {
    open my $fh, '<', shift;
    local $/;
    <$fh>;
}

sub state_file_entries {
    my ($path) = @_;
    my $bytes = slurp($path);
    return split("\n", $bytes);
}

my $dsh = "/usr/bin/deb-systemd-helper";
$ENV{'DPKG_MAINTSCRIPT_PACKAGE'} = 'deb-systemd-helper-test';

sub dsh {
    return system($dsh, @_);
}

sub _unit_check {
    my ($cmd, $cb, $verb, $unit, %opts) = @_;

    my $retval = dsh($opts{'user'} ? '--user' : '--system', $cmd, $unit);

    isnt($retval, -1, 'deb-systemd-helper could be executed');
    ok(!($retval & 127), 'deb-systemd-helper did not exit due to a signal');
    $cb->($retval >> 8, 0, "random unit file '$unit' $verb $cmd");
}

sub is_enabled { _unit_check('is-enabled', \&is, 'is', @_) }
sub isnt_enabled { _unit_check('is-enabled', \&isnt, 'isnt', @_) }

sub is_debian_installed { _unit_check('debian-installed', \&is, 'is', @_) }
sub isnt_debian_installed { _unit_check('debian-installed', \&isnt, 'isnt', @_) }

1;
