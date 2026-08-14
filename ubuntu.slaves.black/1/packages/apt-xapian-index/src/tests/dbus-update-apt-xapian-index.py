#!/usr/bin/python3

from __future__ import print_function

import dbus
import os
import glib
import dbus.mainloop.glib
dbus.mainloop.glib.DBusGMainLoop(set_as_default=True)

def finished(res):
    print("finished: ", res)

def progress(percent):
    print("progress: ", percent)

system_bus = dbus.SystemBus()

axi = dbus.Interface(system_bus.get_object("org.debian.AptXapianIndex","/"),
                     "org.debian.AptXapianIndex")
axi.connect_to_signal("UpdateFinished", finished)
axi.connect_to_signal("UpdateProgress", progress)
# force, update_only
axi.update_async(True, True)

glib.MainLoop().run()

