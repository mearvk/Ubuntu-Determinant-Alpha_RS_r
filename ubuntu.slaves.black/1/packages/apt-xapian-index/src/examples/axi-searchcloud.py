#!/usr/bin/python3

# axi-searchasyoutype - Search-as-you-type demo
#
# Copyright (C) 2008  Matteo Zandi, Enrico Zini <enrico@debian.org>
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

# Note: this program needs python-gtkhtml2 to work

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

import gtk, pygtk

# Import the rest here so we don't need dependencies to be installed only to
# print commandline help
import os, math
import xapian
from aptxapianindex import *
from debian import deb822
import gtkhtml2

# Instantiate a xapian.Database object for read only access to the index
db = xapian.Database(XAPIANDB)

# Instantiate the APT cache as well
cache = apt.Cache()

# Facet name -> Short description
facets = dict()
# Tag name -> Short description
tags = dict()
for p in deb822.Deb822.iter_paragraphs(open("/var/lib/debtags/vocabulary", "r")):
    if "Description" not in p: continue
    desc = p["Description"].split("\n", 1)[0]
    if "Tag" in p:
        tags[p["Tag"]] = desc
    elif "Facet" in p:
        facets[p["Facet"]] = desc

def SimpleOrQuery(input_terms):
    """
    Simple OR Query
    
    terms is an array of words
    """

    if len(input_terms) == 0:
        # No text given: abort
        return []

    # To understand the following code, keep in mind that we do
    # search-as-you-type, so the last word may be partially typed.

    if len(input_terms[-1]) == 1:
        # If the last term has only one character, we ignore it waiting for
        # the user to type more.  A better implementation can set up a
        # timer to disable this some time after the user stopped typing, to
        # give meaningful results to searches like "programming in c"
        input_terms = input_terms[:-1]
        if len(input_terms) == 0:
            return [], []

    # Convert the words into terms for the query
    terms = termsForSimpleQuery(input_terms)

    # Since the last word can be partially typed, we add all words that
    # begin with the last one.
    terms.extend([x.term.decode('utf-8') for x in db.allterms(input_terms[-1])])

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
        return [], []
    enquire.set_cutoff(0, topWeight * 0.7)

    # Select the first 30 documents as the key ones to use to compute relevant
    # terms
    packages = []
    rset = xapian.RSet()
    for m in enquire.get_mset(0, 30):
        rset.add_document(m.docid)
        name = m.document.get_data()
        score = m.percent
        try:
            pkg = cache[name]
        except KeyError:
            continue

        # pkg.candidate may be none
        try:
            shortdesc = pkg.candidate.summary
        except AttributeError:
            continue

        packages.append((score, name, shortdesc))

    class Filter(xapian.ExpandDecider):
        def __call__(self, term):
            #return term[0].islower() or term[:2] == "XT"
            return term[:2] == "XT"

    def format(k):
        if k in tags:
            facet = k.split("::", 1)[0]
            if facet in facets:
                return "<i>%s: %s</i>" % (facets[facet], tags[k])
            else:
                return "<i>%s</i>" % tags[k]
        else:
            return k

    taglist = []
    maxscore = None
    for res in enquire.get_eset(15, rset, Filter()):
        # Normalise the score in the interval [0, 1]
        weight = math.log(res.weight)
        if maxscore == None: maxscore = weight
        tag = res.term.decode('utf-8')[2:]
        taglist.append(
            (tag, format(tag), float(weight) / maxscore)
        )
    taglist.sort(key=lambda x:x[0])

    if len(taglist) == 0:
        return [], []

    return packages, taglist

def mark_text_up(result_list):
    # 0-100 score, key (facet::tag), description
    document = gtkhtml2.Document()
    document.clear()
    document.open_stream("text/html")
    document.write_stream("""<html><head>
<style type="text/css">
a { text-decoration: none; color: black; }
</style>
</head><body>""")
    for tag, desc, score in result_list:
        document.write_stream('<a href="%s" style="font-size: %d%%">%s</a> ' % (tag, score*150, desc))
    document.write_stream("</body></html>")
    document.close_stream()
    return document

class Demo:
    def __init__(self):
        w = gtk.Window()
        w.connect('destroy', gtk.main_quit)
        w.set_default_size(400, 400)
     
        self.model = gtk.ListStore(int, str, str)

        treeview = gtk.TreeView()
        treeview.show()
        treeview.set_model(self.model)

        cell_pct = gtk.CellRendererText()
        column_pct = gtk.TreeViewColumn ("Percent", cell_pct, text=0)
        column_pct.set_sort_column_id(0)
        treeview.append_column(column_pct)

        cell_name = gtk.CellRendererText()
        column_name = gtk.TreeViewColumn ("Name", cell_name, text=1)
        column_name.set_sort_column_id(0)
        treeview.append_column(column_name)
     
        cell_desc = gtk.CellRendererText()
        column_desc = gtk.TreeViewColumn ("Name", cell_desc, text=2)
        column_desc.set_sort_column_id(0)
        treeview.append_column(column_desc)
     
    	document = gtkhtml2.Document()
    	document.clear()
    	document.open_stream("text/html")
    	document.write_stream("<html><body>Welcome, enter some text to start!</body></html>")
    	document.close_stream()
        self.view = gtkhtml2.View()
        self.view.set_document(document)

        scrolledwin = gtk.ScrolledWindow()
        scrolledwin.show()
        scrolledwin.set_policy(gtk.POLICY_NEVER, gtk.POLICY_AUTOMATIC)
        scrolledwin.add(treeview)
        
        vbox = gtk.VBox(False, 0)
        vbox.pack_start(scrolledwin, True, True, 0)
        vbox.pack_start(self.view, True, True, 0)

        self.entry = gtk.Entry()
        self.entry.connect('changed', self.on_entry_changed)
        vbox.pack_start(self.entry, False, True, 0)

        w.add(vbox)
        w.show_all()
        gtk.main()

    def on_entry_changed(self, widget, *args):        
        packageslist, tags = SimpleOrQuery(widget.get_text().split())
        
        self.model.clear()
        for item in packageslist:
            self.model.append(item)
        
        doc = mark_text_up(tags)
        doc.connect('link_clicked', self.on_link_clicked)
        self.view.set_document(doc)      

    def on_link_clicked(self, document, link):
    	self.entry.set_text(link + " " + self.entry.get_text().lstrip())

if __name__ == "__main__":
    demo = Demo()
