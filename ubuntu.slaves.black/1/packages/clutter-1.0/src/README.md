Clutter
=======

Notice
------

Clutter is in deep maintenance mode; only micro releases addressing bug fixes
are planned from now on. Additionally, the API and features are frozen.

The planned replacement for Clutter is GTK 4.0.

If you are fixing a bug in [Mutter](https://gitlab.gnome.org/GNOME/mutter) then
please open a merge request against the internal copy of Clutter inside that
project.

What is Clutter?
----------------

Clutter is an open source software library for creating fast, compelling,
portable, and dynamic graphical user interfaces.

Requirements
------------

Clutter currently requires:

  * [GLib](https://gitlab.gnome.org/GNOME/glib)
  * [JSON-GLib](https://gitlab.gnome.org/GNOME/json-glib)
  * [Atk](https://gitlab.gnome.org/GNOME/atk)
  * [Cairo](http://cairographics.org)
  * [Pango](https://gitlab.gnome.org/GNOME/pango)
  * [Cogl](https://gitlab.gnome.org/GNOME/cogl)

On X11, Clutter depends on the following extensions:

  * XComposite
  * XDamage
  * XExt
  * XInput 2.x
  * XKB

If you are building the API reference you will also need:

  * [GTK-Doc](https://gitlab.gnome.org/GNOME/gtk-doc)

If you are building the additional documentation you will also need:

  * xsltproc
  * jw (optional, for generating PDFs)

If you are building the Introspection data you will also need:

  * [GObject-Introspection](https://gitlab.gnome.org/GNOME/gobject-introspection)

Resources
---------

The official Clutter website is:

  - https://www.clutter-project.org/

The API references for the latest stable release are available at:

  - https://developer.gnome.org/clutter/stable/

The Clutter Cookbook is available at:

  - https://developer.gnome.org/clutter-cookbook/

New releases of Clutter are available at:

  - https://download.gnome.org/sources/clutter/

To subscribe to the Clutter mailing lists and read the archives, use the
Mailman web interface available at:

  - https://mail.gnome.org/mailman/listinfo/clutter-list

New bugs should be filed on GitLab:

  - https://gitlab.gnome.org/GNOME/clutter/issues/new

Clutter is licensed under the terms of the GNU Lesser General Public
License, version 2.1 or (at your option) later: see the `COPYING` file
for more information.

Building and Installation
-------------------------

To build Clutter from a release tarball, the usual autotool triad should
be followed:

```sh
  $ ./configure
  $ make
  # make install
```

To build Clutter from a Git clone, run the `autogen.sh` script instead
of the configure one. The `autogen.sh` script will run the configure script
for you, unless the `NOCONFIGURE` environment variable is set to a non-empty
value.

See also the [BuildingClutter][building-clutter] page on the wiki.

Versioning
----------

Clutter uses the common "Linux kernel" versioning system, where
even-numbered minor versions are stable and odd-numbered minor
versions are development snapshots.

Different major versions break both API and ABI but are parallel
installable. The same major version with differing minor version is
expected to be ABI compatible with other minor versions; differing
micro versions are meant just for bug fixing. On odd minor versions
the newly added API might still change.

The micro version indicates the origin of the release: even micro
numbers are only used for released archives; odd micro numbers are
only used on the Git repository.

Bugs
----

Bugs should be reported here:

  - https://gitlab.gnome.org/GNOME/clutter/issues/new 

In the report you should include:

  * what system you're running Clutter on;
  * which version of Clutter you are using;
  * which version of GLib and OpenGL (or OpenGL ES) you are using;
  * which video card and which drivers you are using, including output of
    glxinfo and xdpyinfo (if applicable);
  * how to reproduce the bug.

If you cannot reproduce the bug with one of the tests that come with Clutter
source code, you should include a small test case displaying the bad
behaviour.

If the bug exposes a crash, the exact text printed out and a stack trace
obtained using gdb are greatly appreciated.

Licensing
---------

Clutter is released under the terms of the GNU Lesser General Public
License, either version 2.1 or, at your option, any later version. See
the [COPYING](./COPYING) file for further information.

[building-clutter]: https://wiki.gnome.org/Projects/Clutter/Building
