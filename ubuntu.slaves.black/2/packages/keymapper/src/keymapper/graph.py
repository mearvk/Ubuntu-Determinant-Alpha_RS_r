# graph.py
# write a decision tree to a file, graphviz .dot format

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
import sys
import unicodedata
from keymapper.equiv import looks_like
from random import uniform

if sys.version_info[0] >= 3:
    text_type = str
else:
    text_type = unicode

colors = (
    "red",
    "green",
    "blue",
    "magenta",
    "black",
    "grey",
    "yellowgreen",
    "purple",
    "plum",
)
styles = ("solid", "dotted", "dashed")


def uname(sym):
    try:
        sym = unicodedata.normalize("NFC", sym)
        return unicodedata.name(text_type(sym)).lower()
    except ValueError:
        return "U+%4x" % ord(sym)
    except TypeError:
        return sym


# def uname(sym):
#     return ", ".join([_uname(s) for s in sym])


def symnums(syms):
    return ".".join([str(looks_like(s)) for s in syms])


class GraphReporter(Reporter):
    """Report the result as a graphviz .dot file"""

    def __init__(self, file=sys.stdout):
        self.file = file

    def init(self):
        print("digraph keyboard_tree {", file=self.file)
        print('graph [charset = "UTF-8"]', file=self.file)

    def exit(self):
        print("}", file=self.file)

    def step(self, stepnr):
        """Start a new step"""
        self.nr = stepnr

    def keymap(self, map):
        """This steps selects a unique keymap"""
        print(
            '"Step %d" [label="Map: %s", shape="box"]' % (self.nr, map.name),
            file=self.file,
        )

    def symbols(self, symbols):
        """Start a choice: display these symbols"""
        self.syms = [(s, c) for s, c in symbols]
        self.color = colors[int(uniform(0, len(colors)))]
        self.style = styles[int(uniform(0, len(styles)))]
        # copy, for we need it more than once

    def choice(self, code, nextstep):
        """Choice: This keycode leads to that step"""
        syms = []
        for s, c in self.syms:
            if code in c:
                syms.append(s)

        print(
            '"Step %d" [ color="%s", shape="box" ] ' % (self.nr, self.color),
            file=self.file,
        )
        print(
            '"Step %d" -> "S_%d_%s_%d" [ color="%s", style="%s", weight=2 ] '
            % (self.nr, self.nr, symnums(syms), code, self.color, self.style),
            file=self.file,
        )
        print(
            '"S_%d_%s_%d" -> "Step %d" [ color="%s", style="%s" ] '
            % (
                self.nr,
                symnums(syms),
                code,
                nextstep.step,
                self.color,
                self.style,
            ),
            file=self.file,
        )
        print(
            '"S_%d_%s_%d" [ label="%s -> %d", color="%s" ]'
            % (
                self.nr,
                symnums(syms),
                code,
                "\\n".join([uname(s) for s in syms]),
                code,
                self.color,
            ),
            file=self.file,
        )

    def ask(self, sym, no, yes):
        """Ask whether that symbol is visible"""
        self.color = colors[int(uniform(0, len(colors)))]
        self.style = styles[int(uniform(0, len(styles)))]

        print(
            '"Step %d" [ shape="box", label="Step %d\\nCheck for %s", color="%s" ]'
            % (
                self.nr,
                self.nr,
                "\\nor ".join([uname(s) for s in sym]),
                self.color,
            ),
            file=self.file,
        )
        if yes:
            print(
                '"Step %d" -> "AY-%d" -> "Step %d" [ color="%s", style="%s", weight=2 ]'
                % (self.nr, self.nr, yes.step, self.color, self.style),
                file=self.file,
            )
            print(
                '"AY-%d" [ label="Yes", color="%s" ]' % (self.nr, self.color),
                file=self.file,
            )
        if no:
            print(
                '"Step %d" -> "AN-%d" -> "Step %d" [ color="%s", style="%s", weight=2 ]'
                % (self.nr, self.nr, no.step, self.color, self.style),
                file=self.file,
            )
            print(
                '"AN-%d" [ label="No", color="%s" ]' % (self.nr, self.color),
                file=self.file,
            )

    def ask_no_alt(self, sym, no, yes):
        """Ask whether that symbol is visible on primary keys"""
        self.color = colors[int(uniform(0, len(colors)))]
        self.style = styles[int(uniform(0, len(styles)))]

        print(
            '"Step %d" [ shape="box", label="Step %d\\nCheck for %s\\n(no Alt*)", color="%s" ]'
            % (
                self.nr,
                self.nr,
                "\\nor ".join([uname(s) for s in sym]),
                self.color,
            ),
            file=self.file,
        )
        if yes:
            print(
                '"Step %d" -> "AY-%d" -> "Step %d" [ color="%s", style="%s", weight=2 ]'
                % (self.nr, self.nr, yes.step, self.color, self.style),
                file=self.file,
            )
            print(
                '"AY-%d" [ label="Yes", color="%s" ]' % (self.nr, self.color),
                file=self.file,
            )
        if no:
            print(
                '"Step %d" -> "AN-%d" -> "Step %d" [ color="%s", style="%s", weight=2 ]'
                % (self.nr, self.nr, no.step, self.color, self.style),
                file=self.file,
            )
            print(
                '"AN-%d" [ label="No", color="%s" ]' % (self.nr, self.color),
                file=self.file,
            )

    def finish(self):
        """Conclude this step"""
        pass
