from jeepney import DBusAddress, new_method_call
from jeepney.io.blocking import open_dbus_connection

notifications = DBusAddress('/org/freedesktop/Notifications',
                            bus_name='org.freedesktop.Notifications',
                            interface='org.freedesktop.Notifications')

connection = open_dbus_connection(bus='SESSION')

# Construct a new D-Bus message. new_method_call takes the address, the
# method name, the signature string, and a tuple of arguments.
msg = new_method_call(notifications, 'Notify', 'susssasa{sv}i',
                      ('jeepney_test',  # App name
                       0,   # Not replacing any previous notification
                       '',  # Icon
                       'Hello, world!',  # Summary
                       'This is an example notification from Jeepney',
                       [], {},  # Actions, hints
                       -1,      # expire_timeout (-1 = default)
                      ))

# Send the message and wait for the reply
reply = connection.send_and_get_reply(msg)
print('Notification ID:', reply.body[0])

connection.close()
