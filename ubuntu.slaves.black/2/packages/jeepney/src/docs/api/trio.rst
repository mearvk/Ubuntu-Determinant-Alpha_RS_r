Trio integration
================

This supports D-Bus in applications built with
`Trio <https://trio.readthedocs.io/en/stable/>`_.
See :ref:`connections_and_routers` for more about the two interfaces.

.. module:: jeepney.io.trio

.. autofunction:: open_dbus_router

.. autoclass:: DBusRouter

   .. automethod:: send

   .. automethod:: send_and_get_reply

   .. automethod:: filter

   .. automethod:: aclose

      Leaving the ``async with`` block will also close the router.

.. autoclass:: Proxy

   .. seealso:: :ref:`msggen_proxies`

.. autofunction:: open_dbus_connection

.. autoclass:: DBusConnection

   .. automethod:: send

   .. automethod:: receive

   .. automethod:: router

   .. automethod:: aclose
