"""Example accessing the SecretStorage DBus interface with blocking APIs

https://freedesktop.org/wiki/Specifications/secret-storage-spec/secrets-api-0.1.html#ref-dbus-api
"""

from jeepney import new_method_call, DBusAddress, Properties
from jeepney.io.blocking import open_dbus_connection

secrets = DBusAddress('/org/freedesktop/secrets',
                           bus_name= 'org.freedesktop.secrets',
                           interface='org.freedesktop.Secret.Service')

login_keyring = DBusAddress('/org/freedesktop/secrets/collection/login',
                           bus_name= 'org.freedesktop.secrets',
                           interface='org.freedesktop.Secret.Collection')

list_items = new_method_call(login_keyring, 'SearchItems', 'a{ss}',
                             ([],))


conn = open_dbus_connection(bus='SESSION')

resp = conn.send_and_get_reply(Properties(secrets).get('Collections'))
print('Collections:', resp.body[0][1])

print('\nItems in login collection:')
all_items = conn.send_and_get_reply(list_items).body[0]
for obj_path in all_items:
    item = DBusAddress(obj_path, 'org.freedesktop.secrets',
                      interface='org.freedesktop.Secret.Item')
    props_resp = conn.send_and_get_reply(Properties(item).get_all())
    props = dict(props_resp.body[0])
    state = '(locked)' if props['Locked'][1] else ''
    print(props['Label'][1], state)

conn.close()
