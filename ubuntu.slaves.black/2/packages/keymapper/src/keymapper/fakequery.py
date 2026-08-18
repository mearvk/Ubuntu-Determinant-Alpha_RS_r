# fakequery.py
# answer a question by looking at a keymap

# Copyright (c) 2005 by Matthias Urlichs <smurf@smurf.noris.de>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of Version 2 of the GNU General Public License as
# published by the Free Software Foundation. See the file COPYING.txt
# or (on Debian systems) /usr/share/common-licenses/GPL-2 for details.

"""\
This module answers questions by looking them up in the supplied keymap.
"""

from __future__ import print_function

import sys

from keymapper.query import Query
from keymapper.equiv import looks_like, get_sym


if sys.version_info[0] >= 3:
    text_type = str
else:
    text_type = unicode


class FakeQuery(Query):
    """A fake keyboard inquiry which actually looks at a keymap.

    Used for testing.
    """

    def __init__(self, map, verbose=1):
        Query.__init__(self)
        self.map = map
        self.verbose = verbose

    def press(self, syms):
        if self.verbose:
            print("* Press one of '" + "' '".join(syms) + "' !")
        like = []
        for s in syms:
            s = looks_like(s)
            for ss in get_sym(s):
                if ss not in like and ss in self.map.seen:
                    like.append(ss)
        if self.verbose:
            print("I have '" + "' '".join(like) + "'.")
        codes = []
        for sym in like:
            code = self.map.sym2code[looks_like(sym)]
            for code in code:
                code = code[0]
                if self.verbose:
                    print("I can press %s => %d" % (sym, code))
                if code not in codes:
                    codes.append(code)
        return codes

    def ask(self, syms):
        if self.verbose:
            print("* Do I see '" + "' or '".join(syms) + "' ?")
        for sym in syms:
            if (
                looks_like(text_type(sym)) in self.map.sym2code
                and sym in self.map.seen
            ):
                if self.verbose:
                    print("Yes")
                return True
        if self.verbose:
            print("No")
        return False

    def message(self, msg):
        if self.verbose:
            print(msg)
