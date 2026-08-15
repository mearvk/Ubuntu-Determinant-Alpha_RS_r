# Copyright: © 2012 Enrico Tassi <gareuselesinge@debian.org>
# License: MIT/X
# Strongly based on the ruby build systems. Thanks Lucas!

package Debian::Debhelper::Buildsystem::lua;

use strict;
use base 'Debian::Debhelper::Buildsystem';

my $DH_LUA_MAKEFILE="/usr/share/dh-lua/make/dh-lua.Makefile.multiple";

sub DESCRIPTION { "Lua" }

sub check_auto_buildable { return 0 }

sub new {
	my $class=shift;
	my $this=$class->SUPER::new(@_);
	$this->enforce_in_source_building();
	return $this;
}

sub configure {
	my $this=shift;
	$this->doit_in_sourcedir("make", "--no-print-directory", "-f", $DH_LUA_MAKEFILE, "configure", @_);
}

sub build {
	my $this=shift;
	$this->doit_in_sourcedir("make", "--no-print-directory", "-f", $DH_LUA_MAKEFILE, "build", @_);
}

sub test {
	my $this=shift;
	if (defined($ENV{ADTTMP})) {
		$this->doit_in_sourcedir("make", "--no-print-directory", "-f", $DH_LUA_MAKEFILE, "autopkgtest", @_);
	} else {
		$this->doit_in_sourcedir("make", "--no-print-directory", "-f", $DH_LUA_MAKEFILE, "test", @_);
	}
}

sub install {
	my $this=shift;
	$this->doit_in_sourcedir("make", "--no-print-directory", "-f", $DH_LUA_MAKEFILE, "install", @_);
}

sub clean {
	my $this=shift;
	$this->doit_in_sourcedir("make", "--no-print-directory", "-f", $DH_LUA_MAKEFILE, "clean", @_);
}

1
