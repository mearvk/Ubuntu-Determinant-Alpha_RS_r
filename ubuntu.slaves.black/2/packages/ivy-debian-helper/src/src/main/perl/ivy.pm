# A debhelper build system class for handling Ivy based projects.
#
# Copyright: 2015, Emmanuel Bourg
# License: Apache-2.0

package Debian::Debhelper::Buildsystem::ivy;

use strict;
use base 'Debian::Debhelper::Buildsystem';
use Debian::Debhelper::Dh_Lib qw(%dh doit);

sub DESCRIPTION {
	"Ivy (build.xml)"
}

sub check_auto_buildable {
	my $this=shift;
	return (-e $this->get_sourcepath("build.xml")) ? 1 : 0;
}

sub new {
	my $class=shift;
	my $this=$class->SUPER::new(@_);
	
	$ENV{CLASSPATH} = "/usr/share/java/ivy.jar";
	@{$this->{ant_cmd}} = (
		"ant",
		"-Divy.settings.file=/usr/share/ivy-debian-helper/ivysettings.xml",
		"-Divy.default.ivy.user.dir=$this->{cwd}/.ivy2",
		);
	
	return $this;
}

sub build {
	my $this=shift;
	
	$this->doit_in_builddir(@{$this->{ant_cmd}}, @_);
}

sub clean {
	my $this=shift;

	$this->doit_in_builddir_noerror(@{$this->{ant_cmd}}, "clean");
	doit("rm", "-Rf", "$this->{cwd}/.ivy2");
}

1
