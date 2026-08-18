# equiv.py
# find equivalent glyphs

# Copyright (c) 2005 by Matthias Urlichs <smurf@smurf.noris.de>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of Version 2 of the GNU General Public License as
# published by the Free Software Foundation. See the file COPYING.txt
# or (on Debian systems) /usr/share/common-licenses/GPL-2 for details.

"""\
This module exports a 'looks_like()' function. it accepts a Unicode
symbol and returns a list of symbols which look the same, in either
upper or lower case.

It also exports a chartype() function which returns the first letter
of the Unicode category (e.g., 'C' for control characters, or 'Z' for
spacing).

"""

import io
from os.path import exists
from unicodedata import normalize, category

equivfile = "/usr/share/misc/keysym.equiv"
if exists("data/equivs") and exists("gen_keymap"):
    equivfile = "data/equivs"

map = {}
cache = {}
syms = []

charhash = {}


def chartype(c):
    if c in charhash:
        return charhash[c]
    charhash[c] = h = category(c)[0]
    return h


def read_map():
    with io.open(equivfile, "r", encoding="utf-8") as equiv:
        for l in equiv:
            r = []
            for c in l.strip():
                cc = normalize("NFC", c.lower())
                if cc not in r:
                    r.append(cc)
                cc = normalize("NFC", c.upper())
                if cc not in r:
                    r.append(cc)
            found = 1
            while found:
                found = 0
                for c in r:
                    if c in map:
                        for cc in map[c]:
                            if cc not in r:
                                found = 1
                                r.append(cc)
            r.sort()
            r = tuple(r)
            for c in r:
                map[c] = r
                cache[c] = len(syms)
            syms.append(r)


def looks_like(sym):
    """Return a symbol number for something looking like sym"""

    if not map:
        read_map()

    if sym in cache:
        return cache[sym]

    s = normalize("NFC", sym.lower())
    if s in cache:
        s = cache[s]
        cache[sym] = s
        return s

    if s in map:
        res = map[s]
    else:
        res = [s]
    for c in res:
        if c in cache:
            res = cache[c]
            cache[sym] = res
            return res

    syms.append(res)
    res = len(syms) - 1
    cache[sym] = res
    if sym != s:
        cache[s] = res
    return res


def get_sym(pos):
    """Return the symbols at that position"""
    return syms[pos]
