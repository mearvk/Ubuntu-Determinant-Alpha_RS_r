"""Simple client for the server in blocking_server.py
"""
import random
from time import sleep

from jeepney import DBusAddress, new_method_call
from jeepney.io.blocking import open_dbus_connection

server = DBusAddress(
    "/io/gitlab/takluyver/jeepney/examples/Server",
    bus_name="io.gitlab.takluyver.jeepney.examples.Server",
)

with open_dbus_connection() as connection:
    for i in range(10):
        n = random.randint(0, 5)
        # Construct a new D-Bus message. new_method_call takes the address, the
        # method name, the signature string, and a tuple of arguments.
        msg = new_method_call(server, 'double', 'i', (n,))
        print("Request:", n)

        # Send the message and wait for the reply
        reply = connection.send_and_get_reply(msg)
        print('Result:', reply.body[0])
        sleep(1)
