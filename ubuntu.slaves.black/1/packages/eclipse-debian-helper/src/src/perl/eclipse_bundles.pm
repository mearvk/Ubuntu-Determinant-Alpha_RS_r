# A debhelper build system class for handling Eclipse bundles projects.
#
# Copyright: © 2018 Emmanuel Bourg
# License: Apache-2.0

package Debian::Debhelper::Buildsystem::eclipse_bundles;

use strict;
use warnings;
use File::Basename;
use parent qw(Debian::Debhelper::Buildsystem);
use Debian::Debhelper::Dh_Lib qw(%dh addsubstvar);

sub DESCRIPTION {
	"Eclipse bundles"
}

sub check_auto_buildable {
	return 0;
}

sub new {
	my $class=shift;
	my $this=$class->SUPER::new(@_);
	$this->enforce_in_source_building();

	# Load the list of bundles to build from debian/bundles
	my $bundles = `grep -v '#' debian/bundles | xargs`;
	chomp $bundles;
	@{$this->{bundles}} = split(/ /, $bundles);

	if (-d "$this->{bundles}[0]") {
		$this->{bundledir} = ".";
	} elsif (-d "bundles/$this->{bundles}[0]") {
		$this->{bundledir} = "bundles";
	} else {
		die "Couldn't locate the base directory of the bundles";
	}

	return $this;
}

sub build {
	my $this=shift;
	my $d_ant_prop = $this->get_sourcepath('debian/ant.properties');
	my @args;
	if ( -f $d_ant_prop ) {
		push(@args, '-propertyfile', $d_ant_prop);
	}

	push(@args, "-Dbasedir", ".");
	push(@args, "-Dbundledir", $this->{bundledir});
	push(@args, "-f", "debian/build.xml");
	for my $bundle (@{$this->{bundles}}) {
		push(@args, basename($bundle));
	}

	# Set the username to improve the reproducibility
	push(@args, "-Duser.name", "debian");

	$this->doit_in_sourcedir("ant", @args, @_);
}

sub install {
	my $this=shift;

	my $file = "debian/bundles.properties";
	if (!-e $file) {
		return;
	}
	open(my $data, '<', $file) or die "Could not open '$file' $!\n";
	while (my $line = <$data>) {
		# Parse the line
		chomp $line;
		my @fields = split(/\s/ , $line);
		my $bundle       = $fields[0];
		my $version      = $fields[1];
		my $shortname    = $fields[2];
		my $package      = $fields[3];
		my $dependencies = $fields[4];
		my $basedir      = $fields[5];

		# Install the Maven artifacts
		$this->doit_in_builddir("mh_installpom", "-p$package", "--no-parent", "-e$version", "$basedir/$bundle/target/pom.xml");
		$this->doit_in_builddir("mh_installjar", "-p$package", "--java-lib", "-e$version", "--usj-name=$shortname", "$basedir/$bundle/target/pom.xml", "$basedir/$bundle/target/$bundle.jar");

		# Specify the bundle dependencies in the substvars file
		addsubstvar($package, "bundle:Depends", $dependencies);

		# Add a symlink in /usr/lib/eclipse/plugins/ for plugins
		open(PROJECT_FILE, "$basedir/$bundle/.project");
		if (grep{/org.eclipse.pde.PluginNature/} <PROJECT_FILE>) {
			$this->doit_in_builddir("dh_link", "-p$package", "/usr/share/java/$shortname.jar", "/usr/lib/eclipse/plugins/${bundle}_${version}.jar");
		}
		close PROJECT_FILE;
	}
}

sub clean {
	my $this=shift;

	$this->doit_in_builddir("rm", "-Rf", "debian/bundles.properties");
	for my $bundle (@{$this->{bundles}}) {
		$this->doit_in_builddir("rm", "-Rf", "$this->{bundledir}/$bundle/target");
	}

	$this->doit_in_builddir("mh_clean");
}

1
