File descriptor support
=======================

.. currentmodule:: jeepney

.. autoclass:: FileDescriptor

   .. automethod:: to_file

      .. note::
         If the descriptor does not refer to a regular file, or it doesn't have
         the right access mode, you may get strange behaviour or errors while
         using it.

         You can use :func:`os.stat` and the :mod:`stat` module to check the
         type of object the descriptor refers to, and :func:`fcntl.fcntl`
         to check the access mode, e.g.::

             stat.S_ISREG(os.stat(fd.fileno()).st_mode)  # Regular file?

             status_flags = fcntl.fcntl(fd, fcntl.F_GETFL)
             (status_flags & os.O_ACCMODE) == os.O_RDONLY  # Read-only?

   .. automethod:: to_socket

   .. automethod:: to_raw_fd

   .. automethod:: fileno

   .. automethod:: close

.. autoexception:: NoFDError
