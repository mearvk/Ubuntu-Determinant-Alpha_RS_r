import sys

sys.excepthook =  sys.__excepthook__

import trio

from jeepney import MessageGenerator, new_method_call
from jeepney.io.trio import open_dbus_router, Proxy

# ---- Message generator, created by jeepney.bindgen ----
class Notifications(MessageGenerator):
    interface = 'org.freedesktop.Notifications'

    def __init__(self, object_path='/org/freedesktop/Notifications',
                 bus_name='org.freedesktop.Notifications'):
        super().__init__(object_path=object_path, bus_name=bus_name)

    def Notify(self, arg_0, arg_1, arg_2, arg_3, arg_4, arg_5, arg_6, arg_7):
        return new_method_call(self, 'Notify', 'susssasa{sv}i',
                               (arg_0, arg_1, arg_2, arg_3, arg_4, arg_5, arg_6, arg_7))

    def CloseNotification(self, arg_0):
        return new_method_call(self, 'CloseNotification', 'u',
                               (arg_0,))

    def GetCapabilities(self):
        return new_method_call(self, 'GetCapabilities')

    def GetServerInformation(self):
        return new_method_call(self, 'GetServerInformation')
# ---- End auto generated code ----


async def send_notification():
    async with open_dbus_router(bus='SESSION') as req:
        proxy = Proxy(Notifications(), req)

        resp = await proxy.Notify('jeepney_test',  # App name
                              0,      # Not replacing any previous notification
                              '',     # Icon
                              'Hello, world!',  # Summary
                              'This is an example notification from Jeepney & Trio',
                              [], {},  # Actions, hints
                              -1,      # expire_timeout (-1 = default)
                             )
        print('Notification ID:', resp[0])

if __name__ == '__main__':
    trio.run(send_notification)
