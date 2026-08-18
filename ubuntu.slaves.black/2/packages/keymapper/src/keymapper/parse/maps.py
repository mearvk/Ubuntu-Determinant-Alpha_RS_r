# maps.py
# read keyboard maps

# Copyright (c) 2005 by Matthias Urlichs <smurf@smurf.noris.de>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of Version 2 of the GNU General Public License as
# published by the Free Software Foundation. See the file COPYING.txt
# or (on Debian systems) /usr/share/common-licenses/GPL-2 for details.

"""\
This module exports 'maps()', which is a function that returns a list of
keyboard maps with various interesting features.

Among the tested variants are:
- addditional key, key missing
- swapped keys
- relabeled keys
- totally different keys
- totally different keycodes

"""

from __future__ import print_function

from keymapper.keymap import Keymap, STD, SHIFT, ALT, ALTSHIFT

import re


class MapInputError(RuntimeError):
    pass


class EmptyMapError(RuntimeError):
    pass


num = re.compile(r"^(\d+)")
word = re.compile(r"^(\S+)")
names = {
    "plain": STD,
    "shift": SHIFT,
    "altgr": ALT,
    "shift_altgr": ALTSHIFT,
    "shift_alt": ALTSHIFT,
    "altgr_alt": ALT,
    "alt": ALT,
    "shift_altgr_alt": ALTSHIFT,
}


def parse_map(name, f, with_alt=True):
    """read a Keymap"""
    map = Keymap(name, with_alt)
    l = f.read()
    if not l:
        raise EmptyMapError(name)

    line = 1
    pos = 1
    while l:
        m = num.match(l)
        if not m:
            raise MapInputError(name, line, pos)
        code = int(m.group(0))
        l = l[m.end(0) + 1 :]
        pos += m.end(0) + 1

        m = word.match(l)
        while m:
            mod = m.group(0)
            sym = l[m.end(0) + 1]
            end = l[m.end(0) + 2]
            l = l[m.end(0) + 3 :]
            pos += m.end(0) + 3

            try:
                map.add(sym, code, names[mod])
            except KeyError:
                print("Modifier '%s' unknown" % (mod,))
                pass
            if end == "\n":
                break

            m = word.match(l)

        line += 1
        pos = 1
    return map
