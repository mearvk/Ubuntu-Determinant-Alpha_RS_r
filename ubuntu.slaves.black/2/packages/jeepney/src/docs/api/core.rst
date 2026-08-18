Core API
========

.. module:: jeepney

Message constructors
--------------------

.. autofunction:: new_method_call

.. autofunction:: new_method_return

.. autofunction:: new_error

.. autofunction:: new_signal

.. autoclass:: DBusAddress

.. autoclass:: MessageGenerator

   .. seealso:: :doc:`/bindgen`

Parsing
-------

.. autoclass:: Parser

   .. automethod:: add_data

   .. automethod:: get_next_message

Message objects
---------------

.. autoclass:: Message

   .. attribute:: header

      A :class:`Header` object

   .. attribute:: body

      A tuple of the data in this message. The number and types of the elements
      depend on the message's signature:

      ===========    ==========  ===========
      D-Bus type     D-Bus code  Python type
      ===========    ==========  ===========
      BYTE            ``y``      int
      BOOLEAN         ``b``      bool
      INT16           ``n``      int
      UINT16          ``q``      int
      INT32           ``i``      int
      UINT32          ``u``      int
      INT64           ``x``      int
      UINT64          ``t``      int
      DOUBLE          ``d``      float
      STRING          ``s``      str
      OBJECT_PATH     ``o``      str
      SIGNATURE       ``g``      str
      ARRAY           ``a``      list
      STRUCT          ``()``     tuple
      VARIANT         ``v``      2-tuple ``(signature, value)``
      DICT_ENTRY      ``{}``     dict (for array of dict entries)
      UNIX_FD         ``h``      See :ref:`send_recv_fds`
      ===========    ==========  ===========

   .. automethod:: serialise

.. autoclass:: Header

   .. attribute:: endianness

      :class:`Endianness` object, affecting message serialisation.

   .. attribute:: message_type

      :class:`MessageType` object.

   .. attribute:: flags

      :class:`MessageFlag` object.

   .. attribute:: protocol_version

      Currently always 1.

   .. attribute:: body_length

      The length of the raw message body in bytes.

   .. attribute:: serial

      Sender's serial number for this message. This is not necessarily set
      for outgoing messages - see :meth:`Message.serialise`.

   .. attribute:: fields

      Mapping of :class:`HeaderFields` values to the relevant Python objects.

Exceptions
----------

.. autoexception:: SizeLimitError

.. autoexception:: DBusErrorResponse

   .. attribute:: name

      The error name from the remote end.

   .. attribute:: body

      Any data fields contained in the error message.

Enums & Flags
-------------

.. class:: Endianness

   .. autoattribute:: little

   .. autoattribute:: big

.. class:: HeaderFields

   .. autoattribute:: path

   .. autoattribute:: interface

   .. autoattribute:: member

   .. autoattribute:: error_name

   .. autoattribute:: reply_serial

   .. autoattribute:: destination

   .. autoattribute:: sender

   .. autoattribute:: signature

   .. autoattribute:: unix_fds

.. class:: MessageFlag

   .. autoattribute:: no_reply_expected

      On a method call message, indicates that a reply should not be sent.

   .. autoattribute:: no_auto_start

      D-Bus includes a mechanism to start a service on demand to handle
      messages. If this flag is set, it will avoid that, only handling the
      message if the target is already running.

   .. autoattribute:: allow_interactive_authorization

      Signals that the recipient may prompt the user for elevated privileges
      to handle the request. The D-Bus specification has more details.

.. class:: MessageType

   .. autoattribute:: method_call

   .. autoattribute:: method_return

   .. autoattribute:: error

   .. autoattribute:: signal

Matching messages
-----------------

.. autoclass:: MatchRule

   MatchRule objects are used both for filtering messages internally, and for
   setting up subscriptions in the message bus.

   .. automethod:: add_arg_condition

   .. automethod:: matches

   .. automethod:: serialise
