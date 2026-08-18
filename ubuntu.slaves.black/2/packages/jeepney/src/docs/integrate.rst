Connecting to DBus and sending messages
=======================================

Jeepney can be used with several different frameworks:

- Blocking I/O
- Multi-threading with the `threading <https://docs.python.org/3/library/threading.html>`_ module
- `Trio <https://trio.readthedocs.io/en/stable/>`_
- `asyncio <https://docs.python.org/3/library/asyncio.html>`_
- `Tornado <http://www.tornadoweb.org/en/stable/>`_ (Deprecated as the asyncio
  integration should work with Tornado)

For each of these, there is a module in ``jeepney.io`` providing the
integration layer.

Here's an example of sending a desktop notification, using blocking I/O:

.. literalinclude:: /../examples/blocking_notify.py

And here is the same thing using asyncio:

.. literalinclude:: /../examples/aio_notify_noproxy.py

See the `examples folder <https://gitlab.com/takluyver/jeepney/-/tree/master/examples>`_
in Jeepney's source repository for more examples.

.. _connections_and_routers:

Connections and Routers
-----------------------

Each integration (except blocking I/O) can create *connections* and *routers*.

**Routers** are useful for calling methods in other processes.
Routers let you send a request and wait for a reply, using a
:ref:`proxy <msggen_proxies>` or with ``router.send_and_get_reply()``.
You can also filter incoming messages into queues, e.g. to wait for a specific
signal. But if messages arrive faster than they are processed, these queues fill
up, and messages may be dropped.

**Connections** are simpler: they let you send and receive messages, but
``conn.receive()`` will give you the next message read, whatever that is.
You'd use this to write a server which responds to incoming messages.
A connection will never discard an incoming message.

.. note::

   For blocking, single-threaded I/O, the connection doubles as a router.
   Incoming messages while you're waiting for a reply will be filtered,
   and you can also filter the next message by calling ``conn.recv_messages()``.

   Routers for the other integrations receive messages in a background task.

.. _msggen_proxies:

Message generators and proxies
------------------------------

If you're calling a number of different methods, you can make a *message
generator* class containing their definitions. Jeepney includes a tool to
generate these classes automatically—see :doc:`bindgen`.

Message generators define how to construct messages. *Proxies* are wrappers
around message generators which send a message and get the reply back.

Let's rewrite the example above to use a message generator and a proxy:

.. literalinclude:: /../examples/aio_notify.py

This is more code for the simple use case here, but in a larger application
collecting the message definitions together like this could make it clearer.

.. _send_recv_fds:

Sending & receiving file descriptors
------------------------------------

.. versionadded:: 0.7

D-Bus allows sending file descriptors - references to open files, sockets, etc.
To use this, use the blocking, multi-threading or Trio integration and enable it
(``enable_fds=True``) when connecting to D-Bus. If you enable FD support but the
message bus can't or won't support it, :exc:`.FDNegotiationError` will be raised.

To send a file descriptor, pass any object with a ``.fileno()`` method, such as
an open file or socket, or a suitable integer. The file descriptor must not be
closed before the message is sent.

A received file descriptor will be returned as a :class:`.FileDescriptor` object
to help avoid leaking FDs. This can easily be converted to
a file object (:meth:`~.FileDescriptor.to_file`),
a socket (:meth:`~.FileDescriptor.to_socket`)
or a plain integer (:meth:`~.FileDescriptor.to_raw_fd`).

.. code-block:: python

    # Send a file descriptor for a temp file (normally not visible in any folder)
    with TemporaryFile() as tf:
        msg = new_method_call(server, 'write_data', 'h', (tf,))
        await router.send_and_get_reply(msg)

    # Receive a file descriptor, use it as a writable file
    msg = await conn.receive()
    fd, = msg.body
    with fd.to_file('w') as f:
        f.write(f'Timestamp: {datetime.now()}')

The snippets above are based on the Trio integration. See the
`examples directory <https://gitlab.com/takluyver/jeepney/-/tree/master/examples>`__
in the Jeepney repository for complete, working examples.
