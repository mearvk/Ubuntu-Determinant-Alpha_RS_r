Generating D-Bus wrappers
=========================

D-Bus includes a mechanism to introspect remote objects and discover the methods
they define. Jeepney can use this to generate classes defining the messages to
send. Use it like this::

    python3 -m jeepney.bindgen --name org.freedesktop.Notifications \
            --path /org/freedesktop/Notifications

This command will produce the class in the example under :ref:`msggen_proxies`.

You specify *name*—which D-Bus service you're talking to—and *path*—an
object in that service. Jeepney will generate a wrapper for each interface that
object has, except for some standard ones like the introspection interface
itself.

You are welcome to edit the generated code, e.g. to add docstrings or give
parameters meaningful names. Names like ``arg_1`` are created when
introspection doesn't provide a name.
