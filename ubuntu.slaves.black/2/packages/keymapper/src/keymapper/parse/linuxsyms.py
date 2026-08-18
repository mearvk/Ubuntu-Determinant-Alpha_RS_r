# keymapper/parse/linuxsyms.py
# translate symbols to unicode (and back)

# Copyright (c) 2005 by Matthias Urlichs <smurf@smurf.noris.de>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of Version 2 of the GNU General Public License as
# published by the Free Software Foundation. See the file COPYING.txt
# or (on Debian systems) /usr/share/common-licenses/GPL-2 for details.

"""
translate symbols to unicode (and back).
"""

from __future__ import print_function

from os.path import exists

symfile = "/usr/share/misc/keymap.syms"
if exists("data/symbols") and exists("gen_keymap"):
    symfile = "data/symbols"

map = {}
alias = {}


class RecursiveAlias(Exception):
    pass


class SymbolNotFound(Exception):
    pass


def read_table():
    """Read the table of symbols"""
    f = open(symfile)
    for l in f:
        l = l.strip()
        comment = l.find("#")
        if comment > -1:
            l = l[:comment]
        l = l.strip()
        if l == "":
            continue

        if l[0] == "=":
            a, n = l[2:].split()
            if n in alias:
                raise RecursiveAlias(n)
            if a in map:
                raise RecursiveAlias(a)
            alias[a] = n
        elif l[0] == "-":
            for n in l[2:].split():
                map[n] = ""
        else:  # assume keysym
            c, n = l.split(None, 1)
            c = eval("0x" + c, {}, {})
            c = eval("u'\\u%04x'" % c, {}, {})
            for nn in n.split():
                map[nn] = c


def lookup_symbol(name):
    """Translate name => unicode"""
    if not map:
        read_table()
        # print(name, end="")

    if (
        name.startswith("Meta_")
        or name.startswith("Alt_")
        or name.startswith("Hyper_")
    ):
        return None

    while name in alias:
        name = alias[name]

    try:
        s = map[name]
        # print(s)
        return s
    except KeyError:
        raise SymbolNotFound(name)
