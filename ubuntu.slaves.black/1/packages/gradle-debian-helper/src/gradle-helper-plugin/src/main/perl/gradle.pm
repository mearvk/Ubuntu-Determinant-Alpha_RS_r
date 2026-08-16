# A debhelper build system class for handling Gradle based projects.
#
# Copyright: 2015, Emmanuel Bourg
# License: Apache-2.0

package Debian::Debhelper::Buildsystem::gradle;

use strict;
use Debian::Debhelper::Dh_Lib;
use Dpkg::Control;
use base 'Debian::Debhelper::Buildsystem';

sub DESCRIPTION {
	"Gradle (build.gradle)"
}

sub check_auto_buildable {
	my $this=shift;
	return (-e $this->get_sourcepath("build.gradle")) ? 1 : 0;
}

sub new {
	my $class=shift;
	my $this=$class->SUPER::new(@_);

	my $control = Dpkg::Control->new(type => CTRL_INFO_SRC);
	$control->load("$this->{cwd}/debian/control");

	@{$this->{gradle_cmd}} = ("gradle",
		"--info",
		"--console", "plain",
		"--offline",
		"--stacktrace",
		"--no-daemon",
		"--refresh-dependencies",
		"--gradle-user-home", ".gradle",
		"-Duser.home=.",
		"-Duser.name=debian",
		"-Ddebian.package=$control->{Source}",
		"-Dfile.encoding=UTF-8",
	#	"--init-script", "/usr/share/gradle-debian-helper/init.gradle",
		);	

	my $numthreads = $this->get_parallel();
	if ($numthreads == -1) {
		push(@{$this->{gradle_cmd}}, "--parallel");
	} elsif ($numthreads > 1) {
		push(@{$this->{gradle_cmd}}, "--parallel", "--max-workers=$numthreads");
	}

	return $this;
}

sub build {
	my $this=shift;

	if (!@_) {
		push(@_, "jar");
	}

	$this->_execute_gradle_task(@_);
}

sub test {
	my $this=shift;

	# Running tests automatically for debhelper compat levels > 12 only to prevent unexpected FTBFSes of old packages
	return if compat(12, 1);

	if (!@_) {
		push(@_, "test");
	}

	$this->_execute_gradle_task(@_);
}

sub clean {
	my $this=shift;

	$this->doit_in_builddir("sh", "-c", "find . -wholename .*build/tmp | xargs echo | sed -e 's^build/tmp^build^g' | xargs rm -Rf");
	$this->doit_in_builddir("sh", "-c", "find . -wholename .*build/debian | xargs echo | sed -e 's^build/tmp^build^g' | xargs rm -Rf");
	$this->doit_in_builddir("rm", "-Rf", "$this->{cwd}/.gradle", "$this->{cwd}/buildSrc/.gradle", ".m2");
}

# Private methods

sub _execute_gradle_task {
	my $this=shift;

	# Copy the init script under .gradle/init.d to work around a bug with the --init-script parameter (GRADLE-3197)
	$this->doit_in_builddir("mkdir", "-p", ".gradle/init.d");
	$this->doit_in_builddir("cp", "/usr/share/gradle-debian-helper/init.gradle", ".gradle/init.d/");

	# Add the hook to the classpath
	my $hookClasspath = "/usr/share/java/gradle-helper-hook.jar:/usr/share/java/maven-repo-helper.jar";
	$ENV{JAVA_OPTS} .= " -Xbootclasspath/a:$hookClasspath";
	$ENV{JAVA_OPTS} .= " -Dorg.gradle.jvmargs=-Xbootclasspath/a:$hookClasspath";

	$this->doit_in_builddir(@{$this->{gradle_cmd}}, @_);
}

1
