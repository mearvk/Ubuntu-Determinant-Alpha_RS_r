"""A simple server built on Jeepney's blocking integration.

Start this, and then run blocking_server_client.py to send requests to it.
"""
import signal
from threading import Thread
import time

from jeepney import MessageType, HeaderFields, new_method_return, new_error
from jeepney.bus_messages import message_bus
from jeepney.io.threading import (
    open_dbus_connection, DBusRouter, Proxy, ReceiveStopped,
)

SERVER_NAME = "io.gitlab.takluyver.jeepney.examples.Server"

def slow_double(n):
    # Simulate something slow which releases the GIL so other threads can run
    time.sleep(5)
    return n * 2

def double(n):
    return n * 2

def divide(n, d):
    return n / d


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

        # Dispatch to different methods
        if method == 'slow_double':
            res = slow_double(msg.body[0])
            print(f"Delayed reply to {msg.header.serial}: {res}")
            rep = new_method_return(msg, 'i', (res,))

        elif method == 'double':
            res = double(msg.body[0])
            rep = new_method_return(msg, 'i', (res,))

        elif method == 'divide':
            try:
                res = divide(*msg.body)
            except ZeroDivisionError:
                rep = new_error(msg, SERVER_NAME + ".Error.DivideByZero")
            else:
                rep = new_method_return(msg, 'd', (res,))

        else:
            rep = new_error(msg, SERVER_NAME + '.Error.NoMethod')

        conn.send(rep)


with open_dbus_connection() as conn:
    print("My unique name is:", conn.unique_name)

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

