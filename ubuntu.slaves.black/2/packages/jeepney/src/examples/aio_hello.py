import asyncio

from jeepney.io.asyncio import open_dbus_connection

async def hello():
    conn = await open_dbus_connection(bus='SESSION')
    print('My ID is:', conn.unique_name)
    
asyncio.run(hello())
