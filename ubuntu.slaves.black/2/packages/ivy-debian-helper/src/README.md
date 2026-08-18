Ivy Debian Helper
-----------------

This project contains helper tools to ease the packaging of Ivy based projects in Debian.
It consists in:

 * an Ivy plugin resolving the dependencies against the system Maven repository (`/usr/share/maven-repo`).
   The resolver uses the same Maven rule files that maven-debian-helper and maven-repo-helper employ
   (`debian/maven.rules`, `debian/maven.ignoreRules`).

 * a debhelper class initializing the plugin and running Ant+Ivy in offline mode.


Usage
-----

1. Add a build dependency on ivy-debian-helper in `debian/control`

2. Use a `debian/rules` file with:

       %:
               dh $@ --buildsystem=ivy

3. Create `debian/maven.rules` and/or `debian.maven.ignoreRules` with the dependency rules


Limitations
-----------

* Transitive dependencies with a non generic version (neither 'debian' nor '.x')
  must be added to `debian/maven.rules` in order to preserve the version
  (with a rule like: `org.foo bar * * * *`)
