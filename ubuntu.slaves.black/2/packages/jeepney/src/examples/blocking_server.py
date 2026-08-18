"""A simple server built on Jeepney's blocking integration.

Start this, and then run blocking_server_client.py to send requests to it.
"""
import time

from jeepney import MessageType, HeaderFields, new_method_return, new_error
from jeepney.bus_messages import message_bus
from jeepney.io.blocking import open_dbus_connection

SERVER_NAME = "io.gitlab.takluyver.jeepney.examples.Server"

def slow_double(n):
    time.sleep(5)
    return n * 2

def double(n):
    return n * 2

def divide(n, d):
    return n / d

with open_dbus_connection() as connection:
    print("My unique name is:", connection.unique_name)

    # Request an additional name on the message bus
    rep = connection.send_and_get_reply(message_bus.RequestName(SERVER_NAME))
    if rep.body[0] == 1:  # DBUS_REQUEST_NAME_REPLY_PRIMARY_OWNER
        print("Got name", SERVER_NAME)

    while True:
        msg = connection.receive()
        if msg.header.message_type != MessageType.method_call:
            print("Received non-method-call message:", msg)

        method = msg.header.fields[HeaderFields.member]
        print(f"Message {msg.header.serial} calls {method}")

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

        connection.send_message(rep)

