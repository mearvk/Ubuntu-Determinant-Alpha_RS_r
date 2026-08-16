Eclipse Debian Helper
=====================

This project contains helper tools to ease the packaging of Eclipse related
projects. These projects often consist in a collection of bundles built with
Tycho. Since Tycho isn't fully usable in Debian yet this package provides
an alternative way of building the bundles using Ant.

Eclipse Debian Helper provides an Ant macro designed to build a bundle and
a debhelper buildsystem class to reduce the boiler plate in debian/rules.

By convention we assume a one to one mapping between bundles and Debian
packages. The package name is automatically derived from the bundle name.
For example the `org.eclipse.foo.bar`bundle is packaged as
`libeclipse-foo-bar-java`. Equinox packages are handled slightly differently,
`org.eclipse.equinox.foo` is mapped to `libequinox-foo-java`.

The binary packages carry the version of the bundle packaged. For example
if the project eclipse-platform-foo 4.9.2 contains the version 1.2.3 of the
bundle `org.eclipse.foo`, the version of the `libeclipse-foo-java` package
will be 1.2.3+eclipse4.9.2-1.


Usage
-----

1. Add a build dependency on eclipse-debian-helper in `debian/control`.
   The binary packages can use the `${bundle:Depends}` variable to auto
   fill the bundle dependencies from the same project only. Other
   dependencies aren't resolved automatically yet.

2. Start with the following template for the `debian/rules` file:

        #!/usr/bin/make -f
        
        include /usr/share/dpkg/pkg-info.mk
        
        %:
                dh $@ --buildsystem=eclipse_bundles
        
        override_dh_gencontrol:
                # Use the bundle versions as package versions
                awk 'system("dh_gencontrol -p"$$4" -- -v"$$2"+eclipse$(DEB_VERSION)")' debian/bundles.properties

3. Create a `debian/bundles` file listing the names of the bundles to build,
   one per line. For example:

        org.eclipse.foo
        org.eclipse.foo.bar
        org.eclipse.foo.baz

4. Create a `debian/build.xml` file importing `build-eclipse-bundle.xml`
   from `/usr/share/eclipse-debian-helper/` and implementing one target
   per bundle. The name of the target is the name of the bundle.
   The `<make-bundle>` macro provides an easy way to build the bundles.
   For example:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project>

  <include file="/usr/share/eclipse-debian-helper/build-eclipse-bundle.xml"/>

  <!-- Eclipse Foo -->
  <target name="org.eclipse.foo">
    <make-bundle name="org.eclipse.foo"/>
  </target>

  <!-- Eclipse Bar -->
  <target name="org.eclipse.bar" depends="org.eclipse.foo">
    <make-bundle name="org.eclipse.bar" depends="org.eclipse.foo">
      <pathelement path="/usr/share/java/equinox-common.jar"/>
    </make-bundle>
  </target>

</project>
```

   Dependencies between bundles of the same project can be specified with the
   `depends` attribute. Other dependencies can be specified by path like
   elements inside `<make-bundle>`, for example with `<fileset>`
   or `<pathelement>`.


Limitations
-----------

* Some bundles have a native part that has to be handled manually.
* The Maven poms installed don't specify the bundle dependencies.
