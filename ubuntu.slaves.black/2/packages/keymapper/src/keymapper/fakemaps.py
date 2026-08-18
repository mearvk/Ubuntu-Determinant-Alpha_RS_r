# -*- coding: utf-8 -*-
# fakemaps.py
# invent fake keyboard maps for testing

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

import sys

from keymapper.keymap import Keymap, STD, SHIFT, ALT


if sys.version_info[0] >= 3:
    text_type = str
else:
    text_type = unicode


def gen_map(name, *keys):
    """synthesize a Keymap"""
    map = Keymap(name)
    for sym, code, mod in keys:
        map.add(text_type(sym), code, mod)
    return map


def maps():
    """return a list of nicely incompatible keyboards"""
    yield gen_map(
        "std",
        ("A", 1, STD),
        ("B", 2, STD),
        ("C", 3, STD),
        ("D", 4, STD),
        ("E", 5, STD),
    )

    # Swap two keys
    yield gen_map(
        "swapped",
        ("B", 1, STD),
        ("A", 2, STD),
        ("C", 3, STD),
        ("D", 4, STD),
        ("E", 5, STD),
    )

    # Remove a key
    yield gen_map(
        "removed", (u"α", 1, STD), ("B", 2, STD), ("C", 3, STD), ("D", 4, STD)
    )

    # Duplicate a key
    yield gen_map(
        "duped", ("A", 1, STD), ("B", 2, STD), ("C", 3, STD), ("A", 4, STD)
    )

    # Add a new key
    yield gen_map(
        "add_new",
        ("A", 1, STD),
        ("B", 2, STD),
        ("C", 3, STD),
        ("D", 4, STD),
        ("E", 5, STD),
        ("G", 11, STD),
    )

    # Add a key we know from somewhere
    yield gen_map(
        "add_known",
        ("A", 1, STD),
        ("B", 2, STD),
        ("C", 3, STD),
        ("D", 4, STD),
        ("E", 5, STD),
        ("F", 7, STD),
    )

    # Relabel a key
    yield gen_map(
        "relabel",
        ("A", 1, STD),
        ("B", 2, STD),
        ("C", 3, STD),
        ("D", 4, STD),
        ("F", 5, STD),
    )

    # Totally different keys
    yield gen_map(
        "diff_keys",
        ("aa", 1, STD),
        ("bb", 2, STD),
        ("cc", 3, STD),
        ("dd", 4, STD),
        ("ee", 5, STD),
    )

    # Totally different codes
    yield gen_map(
        "diff_codes",
        ("A", 6, STD),
        ("B", 7, STD),
        ("C", 8, STD),
        ("D", 9, STD),
        ("F", 10, STD),
    )

    # Small keyboard ;-)
    yield gen_map(
        "small",
        ("A", 1, STD),
        ("B", 1, SHIFT),
        ("C", 1, ALT),
        ("D", 2, STD),
        ("E", 2, ALT),
    )
