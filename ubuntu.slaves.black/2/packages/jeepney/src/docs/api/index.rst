API reference
=============

.. toctree::
   :maxdepth: 2

   core
   common_msgs
   auth
   fds

.. toctree::
   :maxdepth: 2
   :caption: I/O integrations

   blocking
   threading
   trio
   asyncio
   io_exceptions

There is also a deprecated ``jeepney.io.tornado`` integration. Recent versions
of Tornado are built on asyncio, so you can use the asyncio integration with
Tornado applications.
