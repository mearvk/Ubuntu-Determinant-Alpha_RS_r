"""Do not copy this example!

This is a deliberately broken example to test how D-Bus behaves when messages
are sent faster than they are handled. See other files in this folder for
useful examples of sending D-Bus messages nicely.
"""
import threading
import time

from jeepney import DBusAddress, new_method_call
from jeepney.integrate.blocking import connect_and_authenticate

server = DBusAddress(
    "/io/gitlab/takluyver/jeepney/examples/Server",
    bus_name="io.gitlab.takluyver.jeepney.examples.Server",
)

connection = connect_and_authenticate(bus='SESSION')
sending = True

def sender():
    i = 0
    while sending:
        i += 1
        n = i #random.randint(0, 5)
        # Construct a new D-Bus message. new_method_call takes the address, the
        # method name, the signature string, and a tuple of arguments.
        msg = new_method_call(server, 'slow_double', 'is', (n, 'a' * 1024 * 300))
        print(f"Request {i}: {n}")

        connection.send(msg)
        time.sleep(0.1)

send_thread = threading.Thread(target=sender)
send_thread.start()

def receiver():
    while True:
        msg = connection.receive()
        print('Result:', msg.body[0])

# recv_thread = threading.Thread(target=receiver)
# recv_thread.start()

try:
    receiver()
except KeyboardInterrupt:
    pass

sending = False
send_thread.join()
connection.close()
