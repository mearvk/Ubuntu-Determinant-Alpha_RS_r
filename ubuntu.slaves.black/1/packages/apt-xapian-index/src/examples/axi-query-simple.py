#!/usr/bin/python3

# axi-query-simple - apt-cache search replacement using apt-xapian-index
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

(options, args) = parser.parse_args()


# Import the rest here so we don't need dependencies to be installed only to
# print commandline help
import os
import xapian
import warnings

# This tells python-apt that we've seen the warning about the API not being
# stable yet, and we don't want to see every time we run the program
warnings.filterwarnings("ignore","apt API not stable yet")
import apt
warnings.resetwarnings()

# Setup configuration
XAPIANDBPATH = os.environ.get("AXI_DB_PATH", "/var/lib/apt-xapian-index")
XAPIANDB = XAPIANDBPATH + "/index"

# Instantiate a xapian.Database object for read only access to the index
db = xapian.Database(XAPIANDB)

# Stemmer function to generate stemmed search keywords
stemmer = xapian.Stem("english")

# Build the terms that will go in the query
terms = []
for word in args:
    if word.islower() and word.find("::") != -1:
        # If it's lowercase and it contains '::', then we consider it a Debtags
        # tag.  A better way could be to look up arguments in
        # /var/lib/debtags/vocabulary
        #
        # According to /var/lib/apt-xapian-index/README, Debtags tags are
        # indexed with the 'XT' prefix.
        terms.append("XT"+word)
    else:
        # If it is not a Debtags tag, then we consider it a normal keyword.
        word = word.lower()
        terms.append(word)
        # If the word has a stemmed version, add it to the query.
        # /var/lib/apt-xapian-index/README tells us that stemmed terms have a
        # 'Z' prefix.
        stem = stemmer(word)
        if stem != word:
            terms.append("Z"+stem)

# OR the terms together into a Xapian query.
#
# One may ask, why OR and not AND?  The reason is that, contrarily to
# apt-cache, Xapian scores results according to how well they matched.
#
# Matches that math all the terms will score higher than the others, so if we
# build an OR query what we really have is an AND query that gracefully
# degenerates to closer matches when they run out of perfect results.
#
# This allows stemmed searches to work nicely: if you look for 'editing', then
# the query will be 'editing OR Zedit'.  Packages with the word 'editing' will
# match both and score higher, and packages with the word 'edited' will still
# match 'Zedit' and be included in the results.
query = xapian.Query(xapian.Query.OP_OR, terms)

# Perform the query
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
