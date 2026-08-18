Blocking I/O with threads
=========================

This allows using a D-Bus connection from multiple threads.
The router also launches a separate thread to receive incoming messages.
See :ref:`connections_and_routers` for more about the two interfaces.

.. module:: jeepney.io.threading

.. autofunction:: open_dbus_router

.. autoclass:: DBusRouter

   .. automethod:: send

   .. automethod:: send_and_get_reply

   .. automethod:: filter

   .. automethod:: close

      Leaving the ``with`` block will also close the router.

.. autoclass:: Proxy

   .. seealso:: :ref:`msggen_proxies`

.. autofunction:: open_dbus_connection

.. autoclass:: DBusConnection

   .. automethod:: send

   .. automethod:: receive

   .. automethod:: close

