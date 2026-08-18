Design & Limitations
====================

There are two parts to Jeepney:

The **core** is all about creating D-Bus messages, serialising them to bytes,
and deserialising bytes into :class:`.Message` objects.
It aims to be a complete & reliable implementation of the D-Bus wire protocol.
It follows the idea of `"Sans-I/O" <https://sans-io.readthedocs.io/>`_,
implementing the D-Bus protocol independent of any means of sending or receiving
the data.

The second part is **I/O integration**. This supports the typical use case for
D-Bus - connecting to a message bus on a Unix socket - with various I/O
frameworks. There is one integration module for each framework, and they provide
similar interfaces (:ref:`connections_and_routers`), but differ as much as
necessary to fit in with the different frameworks - e.g. the Trio integration
uses channels where the asyncio integration uses queues.

Jeepney also allows for a similar split in code using it. If you want to wrap
the desktop notifications service, for instance, you can write (or generate) a
:ref:`message generator <msggen_proxies>` class for it.
The same message generator class can then be wrapped in a *proxy* for any of
Jeepney's I/O integrations.

Non-goals
---------

Jeepney does not (currently) aim for:

- Very high performance. Parsing binary messages in pure Python code is not
  the fastest way to do it, but for many use cases of D-Bus it's more than fast
  enough.
- Supporting all possible D-Bus transports. The I/O integration layer only works
  with Unix sockets, the most common way to use D-Bus. If you need to use
  another transport, you can still use :meth:`.Message.serialise` and
  :class:`.Parser`, and deal with sending & receiving data yourself.
- Supporting all authentication options. The :doc:`auth module <api/auth>`
  only provides what the I/O integration layer uses.
- High-level server APIs. Jeepney's API for D-Bus servers is on a low-level,
  sending and receiving messages, not registering handler methods. See
  `dbus-objects <https://github.com/FFY00/dbus-objects>`_ for a server API
  built on top of Jeepney.
- 'Magic' introspection. Some D-Bus libraries use introspection at runtime to
  discover available methods, but Jeepney does not. Instead, it uses
  introspection during development to write message generators (:doc:`bindgen`).

Alternatives
------------

* GTK applications can use `Gio.DBusConnection
  <https://lazka.github.io/pgi-docs/#Gio-2.0/classes/DBusConnection.html>`_
  or a higher-level wrapper like `dasbus <https://github.com/rhinstaller/dasbus>`_
  or `pydbus <https://github.com/LEW21/pydbus>`_.
  There are also GObject wrappers for specific D-Bus services, e.g.
  `secret storage <https://lazka.github.io/pgi-docs/#Secret-1>`__ and
  `desktop notifications <https://lazka.github.io/pgi-docs/#Notify-0.7>`__.
* PyQt applications can use the `Qt D-Bus module
  <https://doc.qt.io/qt-5/qtdbus-index.html>`_, although as of 2020, this is
  `not exposed by PySide <https://bugreports.qt.io/browse/PYSIDE-1319>`__.
* `dbus-python <https://dbus.freedesktop.org/doc/dbus-python/>`_ is a Python
  binding to the reference D-Bus implementation in C. It is very complete and
  well tested, but may be trickier to install and to integrate with event loops
  and async frameworks.

.. seealso::
   `D-Bus Python bindings on the Freedesktop wiki
   <https://www.freedesktop.org/wiki/Software/DBusBindings/#python>`_
