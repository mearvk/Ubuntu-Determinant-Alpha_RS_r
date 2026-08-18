"""Demonstrate sending a file descriptor

Start one of the _recv_fd.py scripts first, then run this.

Make a writable temporary file, send its file descriptor. The other process
writes into it before replying. This process can read what was written.
This works even though the temp file may never have a name on the filesystem
for the other process to open it.
"""
from tempfile import TemporaryFile

import trio

from jeepney import DBusAddress, new_method_call
from jeepney.io.trio import open_dbus_router

server = DBusAddress(
    "/io/gitlab/takluyver/jeepney/examples/FDWriter",
    bus_name="io.gitlab.takluyver.jeepney.examples.FDWriter",
)

async def requests(router, i):
    for _ in range(4):
        with TemporaryFile() as tf:
            # Construct a new D-Bus message. new_method_call takes the address, the
            # method name, the signature string, and a tuple of arguments.
            msg = new_method_call(server, 'write_data', 'h', (tf,))
            print(f"Client task {i} sending", tf)

            # Send the message and wait for the reply
            await router.send_and_get_reply(msg)

            # Retrieve what the other process has written
            tf.seek(0)
            print(f"Client task {i} reads:", tf.read())

        await trio.sleep(0.5)

async def main():
    async with open_dbus_router(enable_fds=True) as router:
        async with trio.open_nursery() as nursery:
            for i in range(5):
                nursery.start_soon(requests, router, i)

trio.run(main)
