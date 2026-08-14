#!/usr/bin/python3

# axi-query-pkgtype - Like axi-query-simple.py, but with a simple
#                     result filter
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

from __future__ import print_function

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

parser = Parser(usage="usage: %prog [options]",
                version="%prog "+ VERSION,
                description="Query the Apt Xapian index.  Command line arguments can be keywords or Debtags tags")
parser.add_option("-t", "--type", help="package type, one of 'game', 'gui', 'cmdline' or 'editor'")

(options, args) = parser.parse_args()


# Import the rest here so we don't need dependencies to be installed only to
# print commandline help
import os
import xapian
import warnings
from aptxapianindex import *

# This tells python-apt that we've seen the warning about the API not being
# stable yet, and we don't want to see every time we run the program
warnings.filterwarnings("ignore","apt API not stable yet")
import apt
warnings.resetwarnings()

# This is our little database of simple Debtags filters we provide: the name
# entered by the user in "--type" maps to a piece of Xapian query
filterdb = dict(
    # We can do simple AND queries...
    game = xapian.Query(xapian.Query.OP_AND, ('XTuse::gameplaying', 'XTrole::program')),
    # Or we can do complicate binary expressions...
    gui = xapian.Query(xapian.Query.OP_AND, xapian.Query('XTrole::program'),
                xapian.Query(xapian.Query.OP_OR, 'XTinterface::x11', 'XTinterface::3d')),
    cmdline = xapian.Query(xapian.Query.OP_AND, 'XTrole::program', 'XTinterface::commandline'),
    editor = xapian.Query(xapian.Query.OP_AND, 'XTrole::program', 'XTuse::editing'))
    # Feel free to invent more

# Instantiate a xapian.Database object for read only access to the index
db = xapian.Database(XAPIANDB)

# Build the base query as seen in axi-query-simple.py
query = xapian.Query(xapian.Query.OP_OR, termsForSimpleQuery(args))

# See if the user wants to use one of the result filters
if options.type:
    if options.type in filterdb:
        # If a filter was requested, AND it with the query
        query = xapian.Query(xapian.Query.OP_AND, query, filterdb[options.type])
    else:
        print("Invalid filter type.  Try one of", ", ".join(sorted(filterdb)), file=sys.stderr)
        sys.exit(1)


# Perform the query, all the rest is as in axi-query-simple.py
enquire = xapian.Enquire(db)
enquire.set_query(query)

# Display the top 20 results, sorted by how well they match
cache = apt.Cache()
matches = enquire.get_mset(0, 20)
print("%i results found." % matches.get_matches_estimated())
print("Results 1-%i:" % matches.size())
for m in matches:
    # /var/lib/apt-xapian-index/README tells us that the Xapian document data
    # is the package name.
    name = m.document.get_data()

    # Get the package record out of the Apt cache, so we can retrieve the short
    # description
    pkg = cache[name]

    if pkg.candidate:
    # Print the match, together with the short description
        print("%i%% %s - %s" % (m.percent, name, pkg.candidate.summary))

sys.exit(0)
