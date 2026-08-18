# file.py
# write a decision tree to a file, evaluation format

# Copyright (c) 2005 by Matthias Urlichs <smurf@smurf.noris.de>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of Version 2 of the GNU General Public License as
# published by the Free Software Foundation. See the file COPYING.txt
# or (on Debian systems) /usr/share/common-licenses/GPL-2 for details.

"""\
This module prints a decision tree, by writing all the steps to a file.
"""

from __future__ import print_function, unicode_literals

from keymapper.tree import Reporter
from unicodedata import normalize
import sys


def nsym(s):
    if len(s) != 1:
        return s
    elif ord(s) == 127:
        return "<del>"
    elif ord(s) == 32:
        return "<spc>"
    elif ord(s) == 10:
        return "<lf>"
    elif ord(s) == 13:
        return "<cr>"
    elif ord(s) == 8:
        return "<bs>"
    elif ord(s) == 9:
        return "<tab>"
    else:
        return s


class FileReporter(Reporter):
    """Report the result as a list of steps to a file"""

    def __init__(self, file=sys.stdout):
        self.file = file

    def step(self, stepnr):
        """Start a new step"""
        print("STEP %d" % stepnr, file=self.file)

    def keymap(self, map):
        """This steps selects a unique keymap"""
        print("MAP %s" % map.name, file=self.file)

    def symbols(self, symbols):
        """Start a choice: display these symbols"""
        for sym, c in symbols:
            print("PRESS %s" % nsym(normalize("NFC", sym)), file=self.file)

    def choice(self, code, nextstep):
        """Choice: This keycode leads to that step"""
        print("CODE %d %d" % (code, nextstep.step), file=self.file)

    def ask(self, sym, no, yes):
        """Ask whether that symbol is visible"""
        print(
            "FIND %s" % " ".join([nsym(normalize("NFC", s)) for s in sym]),
            file=self.file,
        )
        if yes:
            print("YES %s" % yes.step, file=self.file)
        if no:
            print("NO %s" % no.step, file=self.file)

    def ask_no_alt(self, sym, no, yes):
        """Ask whether that symbol is visible on primary keys"""
        print(
            "FINDP %s" % " ".join([nsym(normalize("NFC", s)) for s in sym]),
            file=self.file,
        )
        if yes:
            print("YES %s" % yes.step, file=self.file)
        if no:
            print("NO %s" % no.step, file=self.file)

    def finish(self):
        """Conclude this step"""
        pass
