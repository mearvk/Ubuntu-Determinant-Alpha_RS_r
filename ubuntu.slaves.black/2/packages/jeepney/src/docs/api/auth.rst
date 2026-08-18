Authentication
==============

.. note::

   If you use any of Jeepney's I/O integrations, authentication is built
   in. You only need these functions if you're working outside that.

If you are setting up a socket for D-Bus, you will need to do `SASL
<https://en.wikipedia.org/wiki/Simple_Authentication_and_Security_Layer>`_
authentication before starting to send and receive D-Bus messages.
This text based protocol is completely different to D-Bus itself.

Only a small fraction of SASL is implemented here, primarily what Jeepney's
integration layer uses. If you're doing something different, you may need to
implement other messages yourself.

.. module:: jeepney.auth

.. autofunction:: make_auth_external

.. autofunction:: make_auth_anonymous

.. data:: BEGIN

   Send this just before switching to the D-Bus protocol.

.. autoclass:: Authenticator

   .. versionchanged:: 0.7

      This class was renamed from ``SASLParser`` and substantially changed.

   .. attribute:: authenticated

      Initially False, changes to True when authentication has succeeded.

   .. attribute:: error

      ``None``, or the raw bytes of an error message if authentication failed.

   .. automethod:: data_to_send

   .. automethod:: feed

.. autoexception:: AuthenticationError

.. autoexception:: FDNegotiationError

Typical flow
------------

1. Send the data from :meth:`Authenticator.data_to_send` (or
   ``for req_data in authenticator``).
2. Receive data from the server, pass to :meth:`Authenticator.feed`.
3. Repeat 1 & 2 until :attr:`Authenticator.authenticated` is True,  or the for
   loop exits.
4. Send :data:`BEGIN`.
5. Start sending & receiving D-Bus messages.
