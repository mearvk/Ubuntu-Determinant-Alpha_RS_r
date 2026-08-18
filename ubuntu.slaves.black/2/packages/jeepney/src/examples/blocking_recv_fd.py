"""Demonstrate receiving a file descriptor

Start this, and then run one of the _send_fd.py scripts to send requests.
"""
from datetime import datetime

from jeepney import MessageType, HeaderFields, new_method_return, new_error
from jeepney.bus_messages import message_bus
from jeepney.io.blocking import open_dbus_connection

SERVER_NAME = "io.gitlab.takluyver.jeepney.examples.FDWriter"

with open_dbus_connection(enable_fds=True) as connection:
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

        if method == 'write_data':
            # body contains a FileDescriptor object, which we can convert to a file:
            fd, = msg.body
            with fd.to_file('w') as f:
                f.write(f'Timestamp: {datetime.now()}')
            # Leaving the with block will close the fd in this process

            rep = new_method_return(msg, '')  # Empty reply to say we're done
        else:
            rep = new_error(msg, SERVER_NAME + '.Error.NoMethod')

        connection.send_message(rep)

