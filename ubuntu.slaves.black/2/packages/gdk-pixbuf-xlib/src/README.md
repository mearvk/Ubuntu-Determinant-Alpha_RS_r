GdkPixbuf-Xlib
==============

GdkPixbuf-Xlib contains the deprecated API for integrating GdkPixbuf with
Xlib data types.

This library was originally shipped by [GdkPixbuf][gdk-pixbuf], and has
since been moved out of the original repository.

No newly written code should ever use this library.

If your existing code depends on gdk-pixbuf-xlib, then you're strongly
encouraged to port away from it.

### Building and installing

You should use Meson to configure GdkPixbuf-Xlib's build:

```sh
$ meson _build .
$ cd _build
$ ninja
$ sudo ninja install
```

You can use Meson's `--prefix` argument to control the installation prefix
at configuration time.

You can also use `meson configure` from within the build directory to
check the current build configuration, and change its options.

#### Build options

You can specify the following options in the command line to `meson`:

 * `-Dgtk_doc=true` - Build the API reference documentation.  This
   requires `gtk-doc` to be installed.

For a complete list of build-time options, see the file
[`meson_options.txt`](meson_options.txt).  You can read about Meson
options in general [in the Meson manual](http://mesonbuild.com/Build-options.html).

## License

GdkPixbuf is released under the terms of the GNU Lesser General Public
License version 2.1, or, at your option, any later version. See the
[COPYING](./COPYING) file for further details.
