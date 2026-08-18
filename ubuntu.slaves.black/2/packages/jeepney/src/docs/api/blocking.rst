Blocking I/O
============

This is a good option for simple scripts, where you don't need to do anything
else while waiting for a D-Bus reply. If you will use D-Bus for multiple
threads, or you want a nicer way to wait for signals, see :doc:`threading`.

.. module:: jeepney.io.blocking

.. autofunction:: open_dbus_connection

.. autoclass:: DBusConnection

   .. automethod:: send

   .. automethod:: receive

   .. automethod:: send_and_get_reply

   .. automethod:: recv_messages

   .. automethod:: filter

   .. automethod:: recv_until_filtered

   .. automethod:: close

      Using ``with open_dbus_connection()`` will also close the connection on
      exiting the block.

.. autoclass:: Proxy

   .. seealso:: :ref:`msggen_proxies`
