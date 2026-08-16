Gradle Debian Helper
--------------------

This project contains helper tools to ease the packaging of Gradle based projects in Debian.
It consists in:
 * a Gradle plugin that does the following:
     * Resolve the dependencies against the system Maven repository
       (/usr/share/maven-repo). The resolver uses the same Maven rule files that
       maven-debian-helper and maven-repo-helper employ (debian/maven.rules,
       debian/maven.ignoreRules).
     * Generate Maven POMs for being read by maven-repo-helper
     * Let javadoc link to the local Javadoc of default-jdk
 * a build listener displaying a message periodically to prevent the builders from killing Gradle on slow architectures.
 * a debhelper class detecting Gradle build files, initializing the plugin and running Gradle in offline mode.


Usage
-----

1. Add a build dependency on gradle-debian-helper in debian/control

2. Use a debian/rules file with:

    %:
            dh $@ --buildsystem=gradle

3. Create debian/maven.rules and/or debian.maven.ignoreRules with the dependency rules

4. For building only some subprojects and ignoring the others,
   pass Gradle parameters to dh_auto_build:

    override_dh_auto_build:
            dh_auto_build -- :project1:jar :project2:jar

5. For running tests, override dh_auto_test and call dh_auto_build:

    override_dh_auto_test:
            dh_auto_build -- check


Limitations
-----------

* Dependencies with a version range are not handled (e.g. org.foo:bar:1.0+)
* Transitive dependencies with a non generic version (neither 'debian' nor '.x')
  must be added to debian/maven.rules in order to preserve the version
  (with a rule like: org.foo bar * * * *)
