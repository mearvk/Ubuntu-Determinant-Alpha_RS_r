"""Make overlapping requests from several threads.

Use this alongside one of the _server.py examples
"""
import random
from threading import Thread

from jeepney import DBusAddress, new_method_call
from jeepney.io.threading import open_dbus_router

server = DBusAddress(
    "/io/gitlab/takluyver/jeepney/examples/Server",
    bus_name="io.gitlab.takluyver.jeepney.examples.Server",
)

def requests(router, i):
    for _ in range(5):
        n = random.randint(0, 5)
        # Construct a new D-Bus message. new_method_call takes the address, the
        # method name, the signature string, and a tuple of arguments.
        msg = new_method_call(server, 'slow_double', 'i', (n,))
        print(f"Thread {i} request:", n)

        # Send the message and wait for the reply
        reply = router.send_and_get_reply(msg)
        print(f'Thread {i} result:', reply.body[0])

with open_dbus_router() as router:
    threads = [Thread(target=requests, args=(router, i)) for i in range(6)]
    for t in threads:
        t.start()

    for t in threads:
        t.join()
