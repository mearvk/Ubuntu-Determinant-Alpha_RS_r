# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What The Fuck You Want
# To Public License, Version 2, as published by Sam Hocevar. See
# http://sam.zoy.org/wtfpl/COPYING for more details.

from __future__ import print_function

import os, re
import xapian

import warnings
# Setup configuration
# This tells python-apt that we've seen the warning about the API not being
# stable yet, and we don't want to see every time we run the program
warnings.filterwarnings("ignore","apt API not stable yet")
import apt
warnings.resetwarnings()


# Setup configuration
XAPIANDBPATH = os.environ.get("AXI_DB_PATH", "/var/lib/apt-xapian-index")
XAPIANDB = XAPIANDBPATH + "/index"
XAPIANDBVALUES = XAPIANDBPATH + "/values"

# This is our little database of simple Debtags filters we provide: the name
# entered by the user in "--type" maps to a piece of Xapian query
filterdb = dict(
    # We can do simple AND queries...
    game = xapian.Query(xapian.Query.OP_AND, ('XTuse::gameplaying', 'XTrole::program')),
    # Or we can do complicate binary expressions...
    gui = xapian.Query(xapian.Query.OP_AND, xapian.Query('XTrole::program'),
                xapian.Query(xapian.Query.OP_OR, 'XTinterface::x11', 'XTinterface::3d')),
    cmdline = xapian.Query(xapian.Query.OP_AND, 'XTrole::program', 'XTinterface::commandline'),
    editor = xapian.Query(xapian.Query.OP_AND, 'XTrole::program', 'XTuse::editing')
    # Feel free to invent more
)

def termsForSimpleQuery(keywords):
    """
    Given a list of user-supplied keywords, build the list of terms that will
    go in a simple Xapian query.

    If a term is lowercase and contains '::', then it's considered to be a
    Debtags tag.
    """
    stemmer = xapian.Stem("english")
    terms = []
    for word in keywords:
        if word.islower() and word.find("::") != -1:
            # FIXME: A better way could be to look up arguments in
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
    return terms

def addSimpleFilterToQuery(query, filtername):
    """
    If filtername is not None, lookup the simple filter database for the name
    and add its filter to the query.  Returns the enhanced query.
    """
    # See if the user wants to use one of the result filters
    if filtername:
        if filtername in filterdb:
            # If a filter was requested, AND it with the query
            return xapian.Query(xapian.Query.OP_AND, filterdb[filtername], query)
        else:
            raise RuntimeError("Invalid filter type.  Try one of " + ", ".join(sorted(filterdb)))
    else:
        return query

def show_mset(mset):
    """
    Show a Xapian result mset as a list of packages and their short descriptions
    """
    # Display the top 20 results, sorted by how well they match
    cache = apt.Cache()
    print("%i results found." % mset.get_matches_estimated())
    print("Results 1-%i:" % mset.size())
    for m in mset:
        # /var/lib/apt-xapian-index/README tells us that the Xapian document data
        # is the package name.
        name = m.document.get_data()

        # Get the package record out of the Apt cache, so we can retrieve the short
        # description
        pkg = cache[name]

        # Print the match, together with the short description
        if pkg.candidate:
            print("%i%% %s - %s" % (m.percent, name, pkg.candidate.summary))

def readValueDB(pathname):
    """
    Read the "/etc/services"-style database of value indices
    """
    try:
        rmcomments = re.compile("\s*(#.*)?$")
        splitter = re.compile("\s+")
        values = {}
        for idx, line in enumerate(open(pathname)):
            # Remove comments and trailing spaces
            line = rmcomments.sub("", line)
            # Skip empty lines
            if len(line) == 0: continue
            # Split the line
            fields = splitter.split(line)
            if len(fields) < 2:
                print("Ignoring line %s:%d: only 1 value found when I need at least the value name and number" % (pathname, idx+1), file=sys.stderr)
                continue
            # Parse the number
            try:
                number = int(fields[1])
            except ValueError:
                print("Ignoring line %s:%d: the second column (\"%s\") must be a number" % (pathname, idx+1, fields[1]), file=sys.stderr)
                continue
            values[fields[0]] = number
            for alias in fields[2:]:
                values[alias] = number
    except OSError as e:
        # If we can't read the database, fallback to defaults
        print("Cannot read %s: %s.  Using a minimal default configuration" % (pathname, e), file=sys.stderr)
        values = dict(
            installedsize = 1,
            packagesize = 2
        )
    return values
