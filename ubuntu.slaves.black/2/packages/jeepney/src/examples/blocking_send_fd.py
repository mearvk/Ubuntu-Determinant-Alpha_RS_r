"""Demonstrate sending a file descriptor

Start one of the _recv_fd.py scripts first, then run this.

Make a writable temporary file, send its file descriptor. The other process
writes into it before replying. This process can read what was written.
This works even though the temp file may never have a name on the filesystem
for the other process to open it.
"""
from tempfile import TemporaryFile

from jeepney import DBusAddress, new_method_call
from jeepney.io.blocking import open_dbus_connection

server = DBusAddress(
    "/io/gitlab/takluyver/jeepney/examples/FDWriter",
    bus_name="io.gitlab.takluyver.jeepney.examples.FDWriter",
)

with open_dbus_connection(enable_fds=True) as connection:
    with TemporaryFile() as tf:
        # TemporaryFile() has a .fileno() method, so it can be passed as the
        # data for a file descriptor (h for handle).
        msg = new_method_call(server, 'write_data', 'h', (tf,))
        print("Sending:", tf)

        reply = connection.send_and_get_reply(msg)

        # Retrieve what the other process has written
        tf.seek(0)
        print("File contents:", tf.read())
