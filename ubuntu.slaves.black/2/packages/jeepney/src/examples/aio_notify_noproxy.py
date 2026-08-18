"""Send a desktop notification

See also aio_notify.py, which does the same with the higher-level Proxy API.
"""
import asyncio

from jeepney import DBusAddress, new_method_call
from jeepney.io.asyncio import open_dbus_router

notifications = DBusAddress('/org/freedesktop/Notifications',
                            bus_name='org.freedesktop.Notifications',
                            interface='org.freedesktop.Notifications')

async def send_notification():
    msg = new_method_call(notifications, 'Notify', 'susssasa{sv}i',
                            ('jeepney_test',  # App name
                             0,     # Not replacing any previous notification
                             '',    # Icon
                             'Hello, world!',  # Summary
                             'This is an example notification from Jeepney',
                             [], {},  # Actions, hints
                             -1,      # expire_timeout (-1 = default)
                            ))
    # Send the message and await the reply
    async with open_dbus_router() as router:
        reply = await router.send_and_get_reply(msg)
        print('Notification ID:', reply.body[0])

loop = asyncio.get_event_loop()
loop.run_until_complete(send_notification())
