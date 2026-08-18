package Debian::DpkgCross;
use File::HomeDir;
use File::Basename;
use File::Temp qw/tempfile tempdir/;
use POSIX qw(locale_h);
use Locale::gettext;
use Config::Auto;
use Cwd;
use Carp;
use warnings;
use strict;

require Exporter;

use vars qw (@ISA @EXPORT @EXPORT_OK $conffile $private_conffile
$progname %archtable %std_tools
%pkgvars %allcrossroots $arch $default_arch $deb_host_gnu_type
$crossbase $crossprefix $crossdir $crossbin $crosslib $crossroot
$crossinc $crosslib64 $crosslib32 $crosslibhf $crosslibn32 $crosslibo32
$crosslibsf $crosslibx32 $package $mode $tool_ %config
@keepdeps %allcrossroots @removedeps $maintainer $arch_dir
$compilerpath %debug_data);
@ISA       = qw(Exporter);
@EXPORT    = qw( read_config setup get_architecture create_tmpdir
convert_path get_config get_version rewrite_pkg_name dump_debug_data
check_arch convert_filename detect_arch _g );

=pod

=head1 Name

Debian::DpkgCross - Package of dpkg-cross commonly used functions

The 2.x series of dpkg-cross is seeking to achieve its own removal
by incorporating as much cross-building support as possible into
dpkg itself. The number, scope and range of functions supported
by this package is therefore only going to decrease. Any newly-written
code using this package will need to keep up with changes in dpkg.
Developers are recommended to join the debian-dpkg and debian-embedded
mailing lists and keep their code under review.

=head1 Copyright and License

 Copyright (C) 2004  Nikita Youshchenko <yoush@cs.msu.su>
 Copyright (C) 2004  Raphael Bossek <bossekr@debian.org>
 Copyright (c) 2007-2009  Neil Williams <codehelp@debian.org>

 This program is free software; you can redistribute it and/or modify
 it under the terms of the GNU General Public License as published by
 the Free Software Foundation; either version 2 of the License, or
 (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.

 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301, USA.

=head1 Bugs

Please report bugs via the Debian Bug Tracking System.

=head1 Support

All enquiries to the C<<debian-embedded@lists.debian.org>> mailing list.

=cut

# Determine if the system wide or user defined cross-compile configuration
# have to be read.
$conffile = "debian/cross-compile";
%debug_data=();
my $home = File::HomeDir->my_home;
# handle a missing $home value.
$home = cwd if (!defined($home));
$private_conffile = "${home}/.dpkg-cross/cross-compile";

# Name of the calling application.
$progname = basename($0);

# Conversion table for Debian GNU/Linux architecture name ('$arch') to GNU
# type. This lists additional arch names that are not already supported by
# dpkg-architecture.
# Need to support uclibc formats and remove those that differ from dpkg.
# Migrated into the conf directory and allow anything the user
# specifies in files in that directory. Use Config::Auto.

$arch_dir = '/etc/dpkg-cross/archtable.d/';
%archtable = ();
my @pathfiles=();
foreach my $file (@pathfiles) {
	next if (-d "${arch_dir}$file");
	my $conf = Config::Auto::parse("${arch_dir}$file", format => "colon");
	foreach my $p (sort keys (%$conf)) {
		$p =~ s/'//g;
		if (not defined ($conf->{$p})) {
			carp sprintf(_g("syntax error for %s in %s\n"), $p, "${arch_dir}$file");
			next;
		}
		my $line = (ref($conf->{$p}) eq 'ARRAY') ?
			join (' ', @{$conf->{$p}}) : $conf->{$p};
		$line =~ s/\#.*$//;
		$line =~ s/'//g;
		$line =~ s/"//g;
		$archtable{$p} = $line;
	}
}
undef @pathfiles;

=head1 MAKEFLAGS

See bug #437507 Even if the other flags are needed CC, GCC and
other compiler names should *NOT* be overridden in $ENV{'MAKEFLAGS'}
because this prevents packages compiling and running build tools
using CC_FOR_BUILD.
CDBS packages need to declare an empty override variable in
debian/rules:

 DEB_CONFIGURE_SCRIPT_ENV=

Depending on progress with dpkg cross-building support, the
remaining overrides may also be removed. Do not rely on these
being set.

=cut

%std_tools = (
	AS => "as",
	LD => "ld",
	AR => "ar",
	NM => "nm",
	RANLIB => "ranlib",
	RC => "windres");

$debug_data{'std_tools'} = \%std_tools;

# Contains '$crossroot' definitions by '$arch' readed from configuration.
# '$crossroot' is set by setup() if '$arch' is known from this hash table.
%allcrossroots = ();

=head1 read_config

Read '$conffile' and save the definition in global variables all
recognised variables.

'$crossroot' will be set by setup(). Until setup() is called all
"crossroot-<arch>" settings are stored within '%allcrossroots'.

All package variables are stored within '%conf'.

No variables are skipped.

return: none

=cut

sub read_config {
	my $conf = Config::Auto::parse("$conffile");
	@keepdeps = ();
	@removedeps = ();
	$default_arch = $conf->{'default_arch'};
	$crossbase = $conf->{'crossbase'};
	$crossprefix = $conf->{'crossprefix'};
	$crossdir = $conf->{'crossdir'};
	$crossbin = $conf->{'crossbin'};
	$crosslib = $conf->{'crosslib'};
	$crosslib64 = $conf->{'crosslib64'};
	$crosslib32 = $conf->{'crosslib32'};
	$crosslibhf = $conf->{'crosslibhf'};
	$crosslibn32 = $conf->{'crosslibn32'};
	$crosslibo32 = $conf->{'crosslibo32'};
	$crosslibsf = $conf->{'crosslibsf'};
	$crosslibx32 = $conf->{'crosslibx32'};
	$crossinc = $conf->{'crossinc'};
	$maintainer = $conf->{'maintainer'};
	$compilerpath = $conf->{'compilerpath'};
	my $kd = $conf->{'keepdeps'};
	push @keepdeps, @$kd if (defined $kd);
	my $rd = $conf->{'removedeps'};
	push @removedeps, @$rd if (defined $rd);

	# set defaults from the old cross-compile file
	# with one new one - a regexp for gcc-.*-base which
	# only ever contains a README anyway.
	my @defremove = qw/gcc binutils gpm cpp debianutils x11-common
	libpam-runtime xlibs-data debconf tzdata gcc-.*-base /;
	push @removedeps, @defremove;

	# the key is actually crossroots-${archtype}
	foreach my $acr (keys %$conf) {
		if ($acr =~ /^crossroot-(\S+)$/) {
			my $k = "crossroot-$1";
			$allcrossroots{$1} = $conf->{"$crossroot"};
		}
	}
	if (-f "$private_conffile") {
		# also check $private_conffile and merge
		$conf = Config::Auto::parse("$private_conffile");
		$default_arch ||= $conf->{'default_arch'};
		$crossbase ||= $conf->{'crossbase'};
		$crossprefix ||= $conf->{'crossprefix'};
		$crossdir ||= $conf->{'crossdir'};
		$crossbin ||= $conf->{'crossbin'};
		$crosslib ||= $conf->{'crosslib'};
		$crosslib64 ||= $conf->{'crosslib64'};
		$crosslib32 ||= $conf->{'crosslib32'};
		$crosslibhf ||= $conf->{'crosslibhf'};
		$crosslibn32 ||= $conf->{'crosslibn32'};
		$crosslibo32 ||= $conf->{'crosslibo32'};
		$crosslibsf ||= $conf->{'crosslibsf'};
		$crosslibx32 ||= $conf->{'crosslibx32'};
		$crossinc ||= $conf->{'crossinc'};
		$maintainer ||= $conf->{'maintainer'};
		$compilerpath ||= $conf->{'compilerpath'};
		$kd = $conf->{'keepdeps'};
		push @keepdeps, @$kd if(defined $kd);
		$rd = $conf->{'removedeps'};
		push @removedeps, @$rd if (defined $rd);
		# the key is actually crossroots-${archtype}
		foreach my $acr (keys %$conf) {
			if ($acr =~ /^crossroot-(\S+)$/) {
				my $k = "crossroot-$1";
				$allcrossroots{$1} = $conf->{"$crossroot"};
			}
		}
	}
}

=head1 get_config

Return the current configuration from read_config
as a hash reference.

=cut

sub get_config {
	return \%config;
}

=head1 get_version

Return the current DpkgCross version string used by all
dpkg-cross scripts.

=cut

sub get_version {
	my $query = "2.6.18";
	(defined $query) ? return $query : return "2.5.5";
}

=head1 dump_debug_data

Return a hashtable of assorted debug data collated
during the current run that can be processed using
Data::Dumper.

=cut

sub dump_debug_data {
	return \%debug_data;
}

=head1 rewrite_pkg_name

Converts a package name into the dpkg-cross package name.

$1 - the package name to check and convert if needed
return - the cross-package name

=cut

sub rewrite_pkg_name {
	my $name = shift;

	$name .= "-$arch-cross" if $name !~ /-\Q$arch\E-cross$/;
	return $name;
}

=head1 convert_filename($)

Converts an original .deb filename into the dpkg-cross .deb filename or
converts a dpkg-cross .deb filename into the original .deb filename.

returns undef on error

=cut

sub convert_filename {
	my $name = shift;
	return undef if (!defined($name));
	return undef if ($name !~ /\.deb$/);
	my ($ret, $a);
	my @parts = split (/_/, $name);
	return undef if (!@parts);
	if ($parts[0] =~ /\-([a-z0-9_]+)\-cross$/) {
		# return the original name
		$a = $1;
		my $b = $parts[0];
		$b =~ s/\-$a\-cross//;
		return undef if (!defined check_arch($a));
		$ret = $b . "_" . $parts[1] . "_" . $a . ".deb";
	} else {
		# return the cross name
		return undef if (!defined($parts[2]));
		$a = $parts[2];
		$a =~ s/\.deb//;
		return undef if (!defined check_arch($a));
		my $pkg = $parts[0] . "-${a}-cross";
		$ret = "${pkg}_" . $parts[1] . "_all.deb";
	}
	return $ret;
}

=head1 get_architecture

Returns the current architecture.

return: Current architecture or empty if not set.

=cut

sub get_architecture {
	$debug_data{'default_arch'} = $default_arch;
	$debug_data{'arch'} = $arch;
	$debug_data{'env_arch'} = $ENV{'ARCH'};
	$debug_data{'env_cross_arch'} = $ENV{'DPKGCROSSARCH'};
	return $ENV{'DPKGCROSSARCH'} || $ENV{'ARCH'} || $arch || $default_arch;
}

=head1 check_arch($arch)

Checks that the supplied $arch is (or can be converted to)
a DEB_HOST_GNU_TYPE that can be supported by dpkg-cross.

returns the DPKG_HOST_GNU_TYPE or undef

=cut

sub check_arch {
	my $check = shift;
	# if no arch defined, return the special value: 'None'
	# which mimics the debconf handling.
	return "None" unless (defined $check);
	my $deb_host_gnu_type;
	chomp($deb_host_gnu_type = `CC="" dpkg-architecture -f -a$check -qDEB_HOST_GNU_TYPE 2> /dev/null`);
	$deb_host_gnu_type ||= $archtable{$check};
	$arch = $check if (defined($deb_host_gnu_type));
	return $deb_host_gnu_type;
}

=head1 setup

Set global variables '$arch', '$crossbase', '$crossbin', '$crosslib32',
'$crossdir', '$crossinc', '$crosslib', '$crosslib64', '$crossprefix',
'$compilerpath' and '$deb_host_gnu_type' to defaults and substitute
them with variables from '%conf' and '$arch'.

return: none

=cut

sub setup {
	my ($var_, $os_, $scope_);
	# Set '$arch' to defaults if not already specified.
	$arch = &get_architecture();
	die sprintf(_g("%s: Architecture is not specified.\n"), $progname) unless ($arch);
	$deb_host_gnu_type = `CC="" dpkg-architecture -f -a$arch -qDEB_HOST_GNU_TYPE 2> /dev/null`;
	chomp($deb_host_gnu_type);
	$deb_host_gnu_type ||= $archtable{$arch};

	# Finalize, no subst possible crossbase.
	$crossbase ||= "/usr";

	# Set defaults for internal vars, if not set ...
	$crossprefix ||= $ENV{'CROSSPREFIX'} || "${deb_host_gnu_type}-";
	$crossdir ||= "\$(CROSSBASE)/${deb_host_gnu_type}";
	$crossbin ||= "\$(CROSSDIR)/bin";

	if (exists $allcrossroots{$arch}) {
		$crosslib  ||= "\$(CROSSROOT)/lib";
		$crossinc  ||= "\$(CROSSROOT)/usr/include";
		$crossroot = $allcrossroots{$arch};
	} else {
		$crosslib  ||= "\$(CROSSDIR)/lib";
		$crossinc  ||= "\$(CROSSDIR)/include";
	}

	$crosslib64 ||= $crosslib . "64";
	$crosslib32 ||= $crosslib . "32";
	$crosslibhf ||= $crosslib . "hf";
	$crosslibn32 ||= $crosslib . "n32";
	$crosslibo32 ||= $crosslib . "o32";
	$crosslibsf ||= $crosslib . "sf";
	$crosslibx32 ||= $crosslib . "x32";
	$config{'crossbase'} = $crossbase;
	$config{'crossprefix'} = $crossprefix;
	$config{'crossdir'} = $crossdir;
	$config{'crossbin'} = $crossbin;
	$config{'crosslib'} = $crosslib;
	$config{'crosslib64'} = $crosslib64;
	$config{'crosslib32'} = $crosslib32;
	$config{'crosslibhf'} = $crosslibhf;
	$config{'crosslibn32'} = $crosslibn32;
	$config{'crosslibo32'} = $crosslibo32;
	$config{'crosslibsf'} = $crosslibsf;
	$config{'crosslibx32'} = $crosslibx32;
	$config{'crossinc'} = $crossinc;
	$config{'crossroot'} = $crossroot;

	# substitute references in the variables.
	foreach my $key (keys %config) {
		next if $key eq "crossbase" or $key eq "maintainer";
		my $val = $config{$key};
		next if (!defined($val));
		$val =~ s/\$\(CROSSDIR\)/$crossdir/;
		$val =~ s/\$\(CROSSBASE\)/$crossbase/;
		$config{$key} = $val;
	}
	# read the evaluated versions
	$crossbase = $config{'crossbase'};
	$crossprefix = $config{'crossprefix'};
	$crossdir = $config{'crossdir'};
	$crossbin = $config{'crossbin'};
	$crosslib = $config{'crosslib'};
	$crosslib64 = $config{'crosslib64'};
	$crosslib32 = $config{'crosslib32'};
	$crosslibhf = $config{'crosslibhf'};
	$crosslibn32 = $config{'crosslibn32'};
	$crosslibo32 = $config{'crosslibo32'};
	$crosslibsf = $config{'crosslibsf'};
	$crosslibx32 = $config{'crosslibx32'};
	$crossinc = $config{'crossinc'};
}

=head1 create_tmpdir($basename)

Safely create a temporary directory

 $1: Directory basename (random suffix will be added)

return: Full directory pathname, undef if failed

=cut

sub create_tmpdir {
	my $name = shift;
	my $pd = $ENV{'TMPDIR'} && -d $ENV{'TMPDIR'}
		? $ENV{'TMPDIR'}
		: '/tmp';
	return undef unless -d $pd;
	my $dir;

	eval { $dir = tempdir("$name.XXXXXXXX", DIR => $pd) };
	print("$@"), return undef if $@;

	return $dir;
}

=head1 convert_path($multiarch, $path)

Convert path, substituting '$crossinc', '$crosslib', '$crosslib64',
'$crosslib32', '$crossdir', allowing for multiarch paths. This function will 
be used while building foreign binary packages or converting GCC options.

 $1: Multiarch sub-directory to strip
 $2: Directory (and file) to convert.

return: Converted path.

=cut

sub convert_path {
	my $multiarch = $_[0];
        my $path = &simplify_path ($_[1]);
	if ($path =~ /^\/usr\/include\/($multiarch)?/) {
		$path = "$crossinc/$'";
	} elsif ($path =~ /^(\/usr)?\/lib\/($multiarch)?/) {
		$path = "$crosslib/$'";
	} elsif ($path =~ /^(\/usr)?\/lib64\/($multiarch)?/) {
		$path = "$crosslib64/$'";
	} elsif ($path =~ /^(\/usr)?\/lib32\/($multiarch)?/) {
		$path = "$crosslib32/$'";
	} elsif ($path =~ m:^(/emul/ia32-linux/(usr/)?lib/($multiarch)?):) {
		$path = "$crosslib32/$'";
	} elsif ($path =~ /^(\/usr)?\/libhf\/($multiarch)?/) {
		$path = "$crosslibhf/$'";
	} elsif ($path =~ /^(\/usr)?\/libn32\/($multiarch)?/) {
		$path = "$crosslibn32/$'";
	} elsif ($path =~ /^(\/usr)?\/libo32\/($multiarch)?/) {
		$path = "$crosslibo32/$'";
	} elsif ($path =~ /^(\/usr)?\/libsf\/($multiarch)?/) {
		$path = "$crosslibsf/$'";
	} elsif ($path =~ /^(\/usr)?\/libx32\/($multiarch)?/) {
		$path = "$crosslibx32/$'";
	} elsif ($path =~ /^\/usr\/\w+-\w+(-\w+(-\w+)?)?\//) {
		# leave alone
	} else {
		$path =~ s/^\/usr/$crossdir/;
	}
	return $path
}

=head1 simplify_path($path)

Simplify path. Remove duplicate slashes, "./", "dir/..", etc

$1: Path to simplify.

return: Simplified path.

=cut

sub simplify_path {
	my $path = $_[0];
	# This will remove duplicate slashes
	$path =~ s/\/+/\//g;
	# This will remove ./
	while ($path =~ s/(^|\/)\.\//$1/) {}
	$path =~ s/(.)\/\.$/$1/;
	# This will remove /.. at the beginning
	while ($path =~ s/^\/\.\.(.)/$1/) {}
	# Previous REs could keep standalone /. or /..
	$path =~ s/^\/\.(\.)?$/\//;
	# Remove dir/..
	# First split path into leading ../.. (if any) and the rest
	# Then remove XXX/.. substring while it exists in the later part
	my ($pref, $suff);
	if ($path =~ /^(\.\.(\/\.\.)*)(\/.*)$/) {
		($pref, $suff) = ($1, $3);
	} else {
		($pref, $suff) = ("", $path);
	}
	while ($suff =~ s/(^|\/)[^\/]+\/\.\.(\/|$)/$1/) {}
	$path = $pref . $suff;
	# Replace possibly generated empty string by "."
	$path =~ s/^$/./;
	# Remove possible '/' at end
	$path =~ s/([^\/])[\/]$/$1/;

	return $path;
}

sub _g {
	return gettext(shift);
}

1;
