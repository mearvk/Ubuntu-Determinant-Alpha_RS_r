import trio

from jeepney import DBusAddress, new_method_call
from jeepney.bus_messages import message_bus, MatchRule
from jeepney.io.trio import open_dbus_router, Proxy

portal = DBusAddress(
    object_path='/org/freedesktop/portal/desktop',
    bus_name='org.freedesktop.portal.Desktop',
)
filechooser = portal.with_interface('org.freedesktop.portal.FileChooser')
token = 'file_choice_1'

async def choose_file():
    async with open_dbus_router() as router:
        sender_name = router.unique_name[1:].replace('.', '_')
        handle = f"/org/freedesktop/portal/desktop/request/{sender_name}/{token}"

        response_rule = MatchRule(
            type='signal', interface='org.freedesktop.portal.Request', path=handle
        )
        await Proxy(message_bus, router).AddMatch(response_rule)

        async with router.filter(response_rule) as responses:
            # https://flatpak.github.io/xdg-desktop-portal/portal-docs.html#gdbus-method-org-freedesktop-portal-FileChooser.OpenFile
            req = new_method_call(filechooser, 'OpenFile', 'ssa{sv}', (
                # Parent window, title, options
                '', 'Pick a file', {'handle_token': ('s', token)}
            ))
            await router.send_and_get_reply(req)

            response_signal_msg = await responses.receive()

        response, results = response_signal_msg.body
        if response == 0:
            # print(results)
            print("Chose file:", results['uris'][1][0])

if __name__ == '__main__':
    trio.run(choose_file)
