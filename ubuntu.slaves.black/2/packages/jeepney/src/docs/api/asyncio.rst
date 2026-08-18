Asyncio integration
===================

This supports D-Bus in applications built with
`asyncio <https://docs.python.org/3/library/asyncio.html>`_.
See :ref:`connections_and_routers` for more about the two interfaces.

.. module:: jeepney.io.asyncio

.. autofunction:: open_dbus_router

.. autoclass:: DBusRouter

   .. automethod:: send

   .. automethod:: send_and_get_reply

   .. automethod:: filter

.. autoclass:: Proxy

   .. seealso:: :ref:`msggen_proxies`

.. autofunction:: open_dbus_connection

.. autoclass:: DBusConnection

   .. automethod:: send

   .. automethod:: receive

   .. automethod:: close
