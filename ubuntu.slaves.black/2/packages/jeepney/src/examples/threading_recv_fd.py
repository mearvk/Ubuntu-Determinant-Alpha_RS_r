"""Demonstrate receiving a file descriptor

Start this, and then run one of the _send_fd.py scripts to send requests.
"""
from datetime import datetime
import signal
from threading import Thread

from jeepney import MessageType, HeaderFields, new_method_return, new_error
from jeepney.bus_messages import message_bus
from jeepney.io.threading import (
    open_dbus_connection, DBusRouter, Proxy, ReceiveStopped,
)

SERVER_NAME = "io.gitlab.takluyver.jeepney.examples.FDWriter"

def serve(conn, i):
    while True:
        try:
            msg = conn.receive()
        except ReceiveStopped:
            return

        if msg.header.message_type != MessageType.method_call:
            print("Received non-method-call message:", msg)

        method = msg.header.fields[HeaderFields.member]
        print(f"Thread {i}: Message {msg.header.serial} calls {method}")

        if method == 'write_data':
            # body contains a FileDescriptor object, which we can convert to a file:
            fd, = msg.body
            with fd.to_file('w') as f:
                f.write(f'Timestamp: {datetime.now()}, server thread {i}')
            # Leaving the with block will close the fd in this process

            rep = new_method_return(msg, '')  # Empty reply to say we're done
        else:
            rep = new_error(msg, SERVER_NAME + '.Error.NoMethod')

        conn.send(rep)


with open_dbus_connection(enable_fds=True) as conn:
    # Request an additional name on the message bus
    with DBusRouter(conn) as router:
        bus_proxy = Proxy(message_bus, router, timeout=10)
        if bus_proxy.RequestName(SERVER_NAME) == (1,):
            # 1 == DBUS_REQUEST_NAME_REPLY_PRIMARY_OWNER
            print("Got name", SERVER_NAME)

    threads = [Thread(target=serve, args=(conn, i)) for i in range(4)]
    for t in threads:
        t.start()

    try:
        signal.pause()  # Wait for Ctrl-C
    except KeyboardInterrupt:
        pass

    conn.interrupt()
    for t in threads:
        t.join()

