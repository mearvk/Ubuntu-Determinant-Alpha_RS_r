"""Demonstrate receiving a file descriptor

Start this, and then run one of the _send_fd.py scripts to send requests.
"""
from datetime import datetime

import trio

from jeepney import MessageType, HeaderFields, new_method_return, new_error
from jeepney.bus_messages import message_bus
from jeepney.io.trio import (
    open_dbus_connection, Proxy,
)

SERVER_NAME = "io.gitlab.takluyver.jeepney.examples.FDWriter"

async def serve(conn, i):
    while True:
        msg = await conn.receive()

        if msg.header.message_type != MessageType.method_call:
            print("Received non-method-call message:", msg)
            continue

        method = msg.header.fields[HeaderFields.member]
        print(f"Task {i}: Message {msg.header.serial} calls {method}")

        if method == 'write_data':
            # body contains a FileDescriptor object, which we can convert to a file:
            fd, = msg.body
            with fd.to_file('w') as f:
                f.write(f'Timestamp: {datetime.now()}, server task {i}')
            # Leaving the with block will close the fd in this process

            rep = new_method_return(msg, '')  # Empty reply to say we're done
        else:
            rep = new_error(msg, SERVER_NAME + '.Error.NoMethod')

        await conn.send(rep)

async def main():
    conn = await open_dbus_connection(enable_fds=True)
    # Request an additional name on the message bus
    async with conn.router() as router:
        bus_proxy = Proxy(message_bus, router)
        with trio.fail_after(2):
            reply, = await bus_proxy.RequestName(SERVER_NAME)
            if reply == 1:
                # 1 == DBUS_REQUEST_NAME_REPLY_PRIMARY_OWNER
                print("Got name", SERVER_NAME)

    async with trio.open_nursery() as nursery:
        for i in range(4):
            nursery.start_soon(serve, conn, i)

trio.run(main)

