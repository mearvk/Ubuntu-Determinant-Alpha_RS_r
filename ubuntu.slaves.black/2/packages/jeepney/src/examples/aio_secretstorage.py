"""Example accessing the SecretStorage DBus interface with asyncio APIs

https://freedesktop.org/wiki/Specifications/secret-storage-spec/secrets-api-0.1.html#ref-dbus-api
"""
import asyncio

from jeepney import new_method_call, DBusAddress, Properties
from jeepney.io.asyncio import open_dbus_router

secrets = DBusAddress('/org/freedesktop/secrets',
                      bus_name= 'org.freedesktop.secrets',
                      interface='org.freedesktop.Secret.Service')

login_keyring = DBusAddress('/org/freedesktop/secrets/collection/login',
                            bus_name= 'org.freedesktop.secrets',
                            interface='org.freedesktop.Secret.Collection')

search_msg = new_method_call(
    login_keyring, 'SearchItems', 'a{ss}', ({'user': 'tk2e15',},)
)

async def query_secrets():
    async with open_dbus_router() as router:
        get_collections_msg = Properties(secrets).get('Collections')
        resp = await router.send_and_get_reply(get_collections_msg)
        print('Collections:', resp.body[0][1])

        resp = await router.send_and_get_reply(search_msg)
        print('Search res:', resp.body)


asyncio.run(query_secrets())

