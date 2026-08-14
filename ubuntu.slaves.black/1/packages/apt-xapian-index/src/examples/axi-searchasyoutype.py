#!/usr/bin/python3

# axi-searchasyoutype - Search-as-you-type demo
#
# Copyright (C) 2007  Enrico Zini <enrico@debian.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

from optparse import OptionParser
import sys

VERSION="0.1"

# Let's start with a simple command line parser with help
class Parser(OptionParser):
    def __init__(self, *args, **kwargs):
        OptionParser.__init__(self, *args, **kwargs)

    def error(self, msg):
        sys.stderr.write("%s: error: %s\n\n" % (self.get_prog_name(), msg))
        self.print_help(sys.stderr)
        sys.exit(2)

parser = Parser(usage="usage: %prog [options] keywords",
                version="%prog "+ VERSION,
                description="Query the Apt Xapian index.  Command line arguments can be keywords or Debtags tags")
parser.add_option("-t", "--type", help="package type, one of 'game', 'gui', 'cmdline' or 'editor'")

(options, args) = parser.parse_args()


# Import the rest here so we don't need dependencies to be installed only to
# print commandline help
import os
import xapian
from aptxapianindex import *


# Instantiate a xapian.Database object for read only access to the index
db = xapian.Database(XAPIANDB)

# Instantiate the APT cache as well
cache = apt.Cache()

import curses
import curses.wrapper
import re

class Results:
    """
    Show the results of a query while we type it
    """
    def __init__(self, stdscr):
        maxy, maxx = stdscr.getmaxyx()
        self.size = maxy-1
        self.splitline = re.compile(r'\s+')
        self.win = curses.newwin(self.size, maxx, 0, 0)
        self.win.clear()

    def noresults(self, suggestion = "type more"):
        self.win.clear()
        self.win.addstr(0, 0, "No results, " + suggestion, curses.A_BOLD)
        self.win.refresh()

    def update(self, line):
        """
        Show the results of the search done using the given line of text
        """
        line = line.lower().strip()
        if len(line) == 0:
            # No text given: abort
            self.noresults()
            return

        # Split the line in words
        args = self.splitline.split(line)

        if len(args) == 0:
            # No text given: abort
            self.noresults()
            return

        # To understand the following code, keep in mind that we do
        # search-as-you-type, so the last word may be partially typed.

        if len(args[-1]) == 1:
            # If the last term has only one character, we ignore it waiting for
            # the user to type more.  A better implementation can set up a
            # timer to disable this some time after the user stopped typing, to
            # give meaningful results to searches like "programming in c"
            args = args[:-1]
            if len(args) == 0:
                self.noresults()
                return

        # Convert the words into terms for the query
        terms = termsForSimpleQuery(args)

        # Since the last word can be partially typed, we add all words that
        # begin with the last one.
        terms.extend([x.term.decode('utf-8') for x in db.allterms(args[-1])])

        # Build the query
        query = xapian.Query(xapian.Query.OP_OR, terms)

        # Add the simple user filter, if requested.  This is to show that even
        # when we do search-as-you-type, everything works as usual
        query = addSimpleFilterToQuery(query, options.type)

        # Perform the query
        enquire = xapian.Enquire(db)
        enquire.set_query(query)

        # This does the adaptive cutoff trick on the query results (see
        # axi-query-adaptivecutoff.py) 
        mset = enquire.get_mset(0, 1)
        try:
            topWeight = mset[0].weight
        except IndexError:
            self.noresults("change your query")
            return
        enquire.set_cutoff(0, topWeight * 0.7)

        # Retrieve as many results as we can show
        mset = enquire.get_mset(0, self.size - 1)

        # Redraw the window
        self.win.clear()

        # Header
        self.win.addstr(0, 0, "%i results found." % mset.get_matches_estimated(), curses.A_BOLD)

        # Results
        for y, m in enumerate(mset):
            # /var/lib/apt-xapian-index/README tells us that the Xapian document data
            # is the package name.
            name = m.document.get_data()

            # Get the package record out of the Apt cache, so we can retrieve the short
            # description
            pkg = cache[name]

            if pkg.candidate:
                # Print the match, together with the short description
                self.win.addstr(y+1, 0, "%i%% %s - %s" % (m.percent, name, pkg.candidate.summary))

        self.win.refresh()

# Build the base query as seen in axi-query-simple.py

class Input:
    def __init__(self, stdscr, results):
        maxy, maxx = stdscr.getmaxyx()
        self.results = results
        self.win = curses.newwin(1, maxx, maxy-1, 0)
        self.win.bkgdset(' ', curses.A_REVERSE)
        self.win.clear()
        self.win.addstr(0, 0, "> ", curses.A_REVERSE)
        self.line = ""

    def mainloop(self):
        old = ""
        while True:
            c = self.win.getch()
            if c == 10 or c == 27:
                break
            elif c == 127:
                control = True
                if len(self.line) > 0:
                    self.line = self.line[:-1]
            else:
                self.line += chr(c)
            self.win.clear()
            self.win.addstr(0, 0, "> " + self.line, curses.A_REVERSE)
            self.win.refresh()
            if self.line != old:
                self.results.update(self.line)
                old = self.line

def main(stdscr):
    results = Results(stdscr)
    input = Input(stdscr, results)
    stdscr.refresh()
    input.mainloop()

curses.wrapper(main)

sys.exit(0)
