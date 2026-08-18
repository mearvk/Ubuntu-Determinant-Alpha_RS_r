# keymap.py
# represent a key map

# Copyright (c) 2005 by Matthias Urlichs <smurf@smurf.noris.de>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of Version 2 of the GNU General Public License as
# published by the Free Software Foundation. See the file COPYING.txt
# or (on Debian systems) /usr/share/common-licenses/GPL-2 for details.

"""\
This module contains the 'Keymap' class, which represents a particular
keyboard mapping.
"""

from __future__ import print_function, division

from functools import reduce
from unicodedata import normalize

from keymapper.equiv import looks_like, get_sym, chartype

# This code implements a bitmask and associated bit values.
modlist = (
    "shift",
    "altgr",
    "control",
    "alt",
    "shiftl",
    "shiftr",
    "controll",
    "controlr",
    "capsshift",
)

bitmods = {}
modmods = {}

modbits = {}
n = 1
for f in modlist:
    modbits[f] = n
    n = n * 2
del n
del modlist


class Modifier(object):
    """Encapsulate shift/alt/control/... state"""

    def __str__(self):
        if self.mods:
            return "+".join(self.mods)
        else:
            return "plain"

    def __repr__(self):
        return "M<%s>" % (self.__str__(),)

    def _calc_prio(self):
        """Figure out the priority of a modifier"""
        if not self.mods:
            return 100
        if len(self.mods) == 1 and "shift" in self.mods:
            return 0

        pri = 0
        mods = self.mods
        for mod, val in (("altgr", 800), ("alt", 1000), ("control", 1500)):
            if mod in self.mods:
                pri -= val
                mods = mods - frozenset((mod,))

        if "shift" in mods:
            pri *= 1.5
            mods = mods - frozenset(("shift",))
        pri *= 1 + (len(mods) // 3)
        return pri

    def _get_prio(self):
        """read the priority"""
        if not hasattr(self, "_prio"):
            self._prio = self._calc_prio()
        return self._prio

    pri = property(_get_prio)

    def __new__(cls, mods=None, bits=None):
        """Return an existing modifier (pseudo-Singleton)"""
        if bits is None:
            if mods is None:
                raise NameError
        elif mods is not None:
            raise NameError
        else:
            try:
                return bitmods[bits]
            except KeyError:  # not found: calculate modifier list
                mods = []
                for f, n in modbits.items():
                    if bits & n:
                        mods.append(f)

        mods = frozenset(mods)
        try:
            return modmods[mods]
        except KeyError:
            m = object.__new__(cls)
            if bits is None:
                bits = 0
                for mod in mods:
                    bits |= modbits[mod.lower()]
            m.bits = bits
            m.mods = mods
            modmods[mods] = m
            bitmods[bits] = m
            return m

    def __init__(self, *a, **k):
        pass


STD = Modifier(mods=())
SHIFT = Modifier(mods=("shift",))
ALT = Modifier(mods=("alt",))
ALTSHIFT = Modifier(mods=("alt", "shift"))

# class CodeKnown(Exception):
#     """Trying to add a code+modifier entry to a keymap that's already known"""
#     pass


class SymSet(set):
    """Add and compare with NFC"""

    def __contains__(self, sym):
        return set.__contains__(self, normalize("NFC", sym.lower()))

    def add(self, sym):
        return set.add(self, normalize("NFC", sym.lower()))


class Keymap(object):
    """encapsulates a named symbol <=> keycode+modifiers mapping"""

    def __init__(self, name, with_alt=True):
        self.name = name
        self.sym2code = {}  # sym => (code,modifier) list
        self.sym2cod = {}  # sym => code list
        self.sym2cod_no_alt = {}  # sym => code list
        self.code2sym = {}  # <=
        self.submap_cache = {}
        self.seen = SymSet()  # symbols actually seen
        self.stdseen = SymSet()  # symbols reachable without modifier keys
        self.with_alt = with_alt

    def __str__(self):
        return "Map<%s>" % (self.name,)

    __repr__ = __str__

    def __len__(self):
        return len(self.sym2cod)

    def add(self, sym, code, mod=STD):
        """add a single key mapping to this keymap"""
        if sym == "" or sym is None:
            return
        if len(sym) == 1:
            cat = chartype(sym)
            if cat == "Z" or cat == "C" or cat == "U":
                return  # zero-width, control, unassigned
        if not self.with_alt:
            if mod != STD and mod != SHIFT:
                return
        self.seen.add(sym)
        if mod == STD:
            self.stdseen.add(sym)
        sym = looks_like(sym)
        if sym in self.sym2cod:
            if code not in self.sym2cod[sym]:
                self.sym2cod[sym].append(code)
        else:
            self.sym2cod[sym] = [code]

        if mod in (STD, SHIFT):
            if sym in self.sym2cod_no_alt:
                if code not in self.sym2cod_no_alt[sym]:
                    self.sym2cod_no_alt[sym].append(code)
            else:
                self.sym2cod_no_alt[sym] = [code]

        if mod == STD:
            if code not in self.code2sym:
                self.code2sym[code] = []
            self.code2sym[code].append(sym)

        code = (code, mod)
        if sym in self.sym2code:
            if code not in self.sym2code[sym]:
                self.sym2code[sym].append(code)
            return
        self.sym2code[sym] = [code]

    def symbols(self):
        """Return a list of known symbols"""
        return self.sym2code.keys()

    def symbols_no_alt(self):
        """Return a list of known symbols on non-alt keys"""
        for k, l in self.sym2code.items():
            for c, m in l:
                if m == STD or m == SHIFT:
                    yield k
                    break

    def priority(self, sym):
        """Return how likely it is that this symbol is actually shown
        on the physical keyboard"""
        if not self.sym2code[sym]:
            pass
        # Disambiguate. The 500 is here to make the values non-negative.
        return 500 - sym + reduce(max, [k[1].pri for k in self.sym2code[sym]])

    def dump(self):
        """Show my mapping (sym => code)"""
        return (
            self.name
            + ": "
            + ",".join(
                [
                    "%s:%s"
                    % (
                        "".join(
                            [
                                self.vis(sy)
                                for sy in get_sym(s)
                                if sy in self.seen
                            ]
                        ),
                        "+".join([str(x) for x in c]),
                    )
                    for s, c in sorted(self.sym2cod.items())
                ]
            )
        )

    def rdump1(self, syms):
        """Helper for rdump"""
        seen = {}
        res = []
        for sym in syms:
            if sym in seen:
                continue
            seen[sym] = 1
            for s in get_sym(sym):
                if s not in self.stdseen:
                    continue
                res.append(self.vis(s))
        return res

    def rdump(self):
        """Show my reverse mapping (code => sym)"""
        return (
            self.name
            + ": "
            + " ".join(
                [
                    "%s:%s" % (c, ",".join(self.rdump1(s)))
                    for c, s in sorted(self.code2sym.items())
                ]
            )
        )

    def vis(self, s):
        if len(s) == 1 and ord(s) < 128:
            return repr(s)[1:]
        else:
            return "'" + s + "'"

    def is_submap(self, m):
        """Check if self is a submap of m."""
        if self is m:
            return False
        try:
            return self.submap_cache[m]
        except KeyError:
            for s, cs in self.sym2cod.items():
                if s not in m.sym2cod:
                    self.submap_cache[m] = False
                    return False
                cm = m.sym2cod[s]
                for c in cs:
                    if c not in cm:
                        self.submap_cache[m] = False
                        return False

            self.submap_cache[m] = True
            print("%s is a submap of %s" % (self, m))
            return True
