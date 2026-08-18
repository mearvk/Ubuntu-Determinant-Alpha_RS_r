#!/usr/bin/python3

# Copyright (c) 2005 by Matthias Urlichs <smurf@smurf.noris.de>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of Version 2 of the GNU General Public License as
# published by the Free Software Foundation. See the file COPYING.txt
# or (on Debian systems) /usr/share/common-licenses/GPL-2 for details.

"""\
This test script grabs a number of interesting key maps from
keymapper.fakemaps, generates a decision tree, saves that in an
in-memory file, and then runs each key map against the file's
interpreter to see if the correct map is returned.
"""

from __future__ import print_function

from keymapper.fakemaps import maps
from keymapper.tree import Tree, gen_report
from keymapper.file import FileReporter
from keymapper.graph import GraphReporter
from keymapper.script import Script
from keymapper.fakequery import FakeQuery

import io
import sys

import keymapper.tree

if sys.version_info[0] >= 3:
    # Force encoding to UTF-8 even in non-UTF-8 locales.
    sys.stdout = io.TextIOWrapper(
        sys.stdout.detach(), encoding="UTF-8", line_buffering=True
    )
    sys.stderr = io.TextIOWrapper(
        sys.stderr.detach(), encoding="UTF-8", line_buffering=True
    )
else:
    import codecs

    sys.stdout = codecs.getwriter("utf-8")(sys.stdout)
    sys.stderr = codecs.getwriter("utf-8")(sys.stderr)

keymapper.tree.trace = 1

keymaps = []
t = Tree()
for k in maps():
    t.add(k)
    print(k.dump())
    keymaps.append(k)
t.gen_tree()

buf = io.StringIO()
gen_report(t, FileReporter(buf))

with io.open("test.dot", "w", encoding="utf-8") as g:
    gen_report(t, GraphReporter(g))

# 'buf' now contains our script.

buf.seek(0, 0)
print(buf.read(), end="")

err = 0
for k in keymaps:
    buf.seek(0, 0)
    print("Testing keymap %s" % (k.dump(),))
    s = Script(buf)
    name = s.run(FakeQuery(k))
    if name != k.name:
        print("SCRIPT ERROR: %s != %s" % (name, k.name))
        err += 1
    else:
        print("... OK.")
    print()

if err:
    print("%d errors found!" % err)
    sys.exit(1)
else:
    print("Everything works.")
    sys.exit(0)
