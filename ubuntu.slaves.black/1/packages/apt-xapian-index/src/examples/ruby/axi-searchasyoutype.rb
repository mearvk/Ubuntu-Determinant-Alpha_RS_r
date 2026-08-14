#!/usr/bin/env ruby
#
# axi-searchasyoutype - Search-as-you-type demo
#
# Copyright (C) 2007  Enrico Zini <enrico@debian.org>
# Copyright (C) 2008  Daniel Brumbaugh Keeney
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
#
#############################
#
# INCOMPLETE, does not work
#
#############################
require 'optparse'

type = nil
OptionParser.new do |opts|

  opts.program_name = 'axi-query-pkgtype.rb'
  opts.version = '0.1'
  opts.release = '1203587714'

  opts.banner =
    "Query the Apt Xapian index.  Command line arguments can be keywords or Debtags tags"


  opts.on '-t', '--type TYPE', "package type, one of 'game', 'gui', 'cmdline' or 'editor'" do |v|
    type = v.to_sym
  end

  opts.on_tail("-h", "--help", "Show this message") do
    puts opts
    exit
  end

end.parse! rescue ( puts 'try axi-query-pkgtype.rb --help'; exit 2 )

args = ARGV.collect do |i| i.dup; end


# Import the rest here so we don't need dependencies to be installed only to
# print commandline help
require 'xapian'
require 'aptxapianindex'
require 'curses'


# Instantiate a xapian.Database object for read only access to the index
db = Xapian::Database.new(XAPIANDB)

# Show the results of a query while we type it
class Results

  def initialize stdscr
    maxy, maxx = stdscr.getmaxyx
    size = maxy-1
    # splitline = /\s+/
    win = curses.newwin(size, maxx, 0, 0)
    win.clear
  end

  def noresults(suggestion = "type more")
    win.clear
    win.addstr(0, 0, "No results, " + suggestion, curses.A_BOLD)
    win.refresh
  end

  # Show the results of the search done using the given line of text
  def update(line)
    line = line.lower.strip
    if line.length == 0
      # No text given: abort
      noresults
      return nil
    end

    # Split the line in words
    args = splitline.split(line)

    if args.length == 0
      # No text given: abort
      noresults
      return nil
    end

    # To understand the following code, keep in mind that we do
    # search-as-you-type, so the last word may be partially typed.

    if args[-1].length == 1
      # If the last term has only one character, we ignore it waiting for
      # the user to type more.  A better implementation can set up a
      # timer to disable this some time after the user stopped typing, to
      # give meaningful results to searches like "programming in c"
      args = args[0..-2]
      if args.length == 0
        self.noresults
        return nil
      end
    end

    # Convert the words into terms for the query
    terms = terms_for_simple_query(args)

    # Since the last word can be partially typed, we add all words that
    # begin with the last one.
    terms.extend(db.allterms(args[-1]).collect do |x| x.term; end)

    # Build the query
    query = Xapian::Query.new(Xapian::Query::OP_OR, terms)

    # Add the simple user filter, if requested.  This is to show that even
    # when we do search-as-you-type, everything works as usual
    query = addSimpleFilterToQuery(query, type)

    # Perform the query
    enquire = Xapian::Enquire.new(db)
    enquire.query = query

    # This does the adaptive cutoff trick on the query results (see
    # axi-query-adaptivecutoff.py)
    mset = enquire.mset(0, 1)
    begin
      top_weight = mset[0].weight
    rescue IndexError
      noresults 'change your query'
      return nil
    end
    enquire.set_cutoff(0, top_weight * 0.7)

    # Retrieve as many results as we can show
    mset = enquire.mset(0, self.size - 1)

    # Redraw the window
    self.win.clear

    # Header
    self.win.addstr(0, 0, "%i results found." % mset.matches_estimated, curses.A_BOLD)

    # Results
    mset.each_pair do |y, m|
      # /var/lib/apt-xapian-index/README tells us that the Xapian document data
      # is the package name.
      name = m.document.data

      # Print the match, together with the short description
      self.win.addstr(y+1, 0, "%i%% %s - %s" % [m.percent, name, pkg.summary])
    end

    self.win.refresh
  end
end

# Build the base query as seen in axi-query-simple.py
class Input

  def initialize stdscr, results
    maxy, maxx = stdscr.getmaxyx
    results = results
    win = curses.newwin(1, maxx, maxy-1, 0)
    win.bkgdset(' ', curses.A_REVERSE)
    win.clear
    win.addstr(0, 0, "> ", curses.A_REVERSE)
    line = ""
  end

  def mainloop
    old = ""
    loop do
      c = win.getch
      break if c == 10 or c == 27
      if c == 127
        control = true
        unless line.empty?
          line = line[0..-2]
        end
      else
        line << chr(c)
      end
      win.clear
      win.addstr(0, 0, "> " + self.line, curses.A_REVERSE)
      win.refresh
      unless line == old
        results.update(self.line)
        old = line
      end
    end
  end
end

def main(stdscr)
  results = Results.new(stdscr)
  input = Input(stdscr, results)
  stdscr.refresh
  input.mainloop
end
main nil
# curses.wrapper(main)
