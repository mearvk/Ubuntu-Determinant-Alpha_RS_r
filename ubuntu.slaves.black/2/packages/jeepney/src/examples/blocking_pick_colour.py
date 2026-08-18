"""Pick a colour on your screen, show its details in the terminal

This probably only works on Gnome desktops, as it uses a Gnome D-Bus interface.
This is just an example, so broad support is less important than simplicity.
"""
from jeepney.io.blocking import open_dbus_connection, Proxy
from jeepney.wrappers import MessageGenerator, new_method_call

# This class was auto-generated with:
# python3 -m jeepney.bindgen --name org.gnome.Shell.Screenshot --path /org/gnome/Shell/Screenshot
class Screenshot(MessageGenerator):
    interface = 'org.gnome.Shell.Screenshot'

    def __init__(self, object_path='/org/gnome/Shell/Screenshot',
                 bus_name='org.gnome.Shell.Screenshot'):
        super().__init__(object_path=object_path, bus_name=bus_name)

    def Screenshot(self, include_cursor, flash, filename):
        return new_method_call(self, 'Screenshot', 'bbs',
                               (include_cursor, flash, filename))

    def ScreenshotWindow(self, include_frame, include_cursor, flash, filename):
        return new_method_call(self, 'ScreenshotWindow', 'bbbs',
                               (include_frame, include_cursor, flash, filename))

    def ScreenshotArea(self, x, y, width, height, flash, filename):
        return new_method_call(self, 'ScreenshotArea', 'iiiibs',
                               (x, y, width, height, flash, filename))

    def PickColor(self):
        return new_method_call(self, 'PickColor')

    def FlashArea(self, x, y, width, height):
        return new_method_call(self, 'FlashArea', 'iiii',
                               (x, y, width, height))

    def SelectArea(self):
        return new_method_call(self, 'SelectArea')


with open_dbus_connection() as conn:
    screenshot = Proxy(Screenshot(), conn)
    res_dict, = screenshot.PickColor()

# We get RGB as floats (0-1), and convert to integers (0-255)
rf, gf, bf = res_dict['color'][1]
ri, gi, bi = round(rf * 255), round(gf * 255), round(bf * 255)

print(f"RGB (0-1)  : ({rf:.5f}, {gf:.5f}, {bf:.5f})")
print(f"RGB (0-255): {ri, gi, bi}")
print(f"Hex code   : #{ri:02X}{gi:02X}{bi:02X}")
print(f"Preview    : \x1b[48;2;{ri};{gi};{bi}m            \x1b[0m")
# The line above assumes our terminal supports 24-bit colour:
# https://en.wikipedia.org/wiki/ANSI_escape_code#24-bit
