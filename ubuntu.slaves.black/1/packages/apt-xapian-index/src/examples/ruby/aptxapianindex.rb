# This program is free software. It comes without any warranty, to
# the extent permitted by applicable law. You can redistribute it
# and/or modify it under the terms of the Do What The Fuck You Want
# To Public License, Version 2, as published by Sam Hocevar. See
# http://sam.zoy.org/wtfpl/COPYING for more details.

# Setup configuration
# This tells python-apt that we've seen the warning about the API not being
# stable yet, and we don't want to see every time we run the program

require 'xapian'

# Setup configuration
XAPIANDBPATH = '/var/lib/apt-xapian-index'
XAPIANDB = XAPIANDBPATH + '/index'
XAPIANDBVALUES = XAPIANDBPATH + '/values'

# This is our little database of simple Debtags filters we provide: the name
# entered by the user in "--type" maps to a piece of Xapian query
FILTER_DB = {

  # We can do simple AND queries...
  :game => Xapian::Query.new(Xapian::Query::OP_AND, ['XTuse::gameplaying', 'XTrole::program']),

  # Or we can do complicate binary expressions...
  :gui => Xapian::Query.new(
    Xapian::Query::OP_AND, Xapian::Query.new('XTrole::program'),
    Xapian::Query.new(Xapian::Query::OP_OR, 'XTinterface::x11', 'XTinterface::3d')),

  :cmdline => Xapian::Query.new(Xapian::Query::OP_AND, 'XTrole::program', 'XTinterface::commandline'),

  :editor => Xapian::Query.new(Xapian::Query::OP_AND, 'XTrole::program', 'XTuse::editing')

  # Feel free to invent more
}

=begin
    Given a list of user-supplied keywords, build the list of terms that will
    go in a simple Xapian query.

    If a term is lowercase and contains '::', then it's considered to be a
    Debtags tag.
=end
def terms_for_simple_query keywords
  stemmer = Xapian::Stem.new("english")
  terms = []
  keywords.each do |word|
    if not word.downcase! and word['::']
      # FIXME: A better way could be to look up arguments in
      # /var/lib/debtags/vocabulary
      #
      # According to /var/lib/apt-xapian-index/README, Debtags tags are
      # indexed with the 'XT' prefix.
      terms << ( "XT" << word )
    else
      # If it is not a Debtags tag, then we consider it a normal keyword.
      terms << word
      # If the word has a stemmed version, add it to the query.
      # /var/lib/apt-xapian-index/README tells us that stemmed terms have a
      # 'Z' prefix.
      stem = stemmer.call(word)

      terms << ( 'Z' << stem ) unless stem == word
    end
  end
  terms
end

=begin
    If filtername is not None, lookup the simple filter database for the name
    and add its filter to the query.  Returns the enhanced query.
=end
def add_simple_filter_to_query query, filtername
  # See if the user wants to use one of the result filters
  if filtername
    if FILTER_DB.include? filtername
      # If a filter was requested, AND it with the query
      Xapian::Query.new(Xapian::Query::OP_AND, FILTER_DB[filtername], query)
    else
      raise RuntimeError("Invalid filter type.  Try one of %s" % FILTER_DB.keys.join(', '))
    end
  else
    query
  end
end

# Show a Xapian result mset as a list of packages and their short descriptions
def show_mset mset
  # Display the top 20 results, sorted by how well they match
  puts "%i results found." % mset.matches_estimated
  puts "Results 1-%i:" % mset.size
  mset.matches.each do |m|
    # /var/lib/apt-xapian-index/README tells us that the Xapian document data
    # is the package name.
    name = m.document.data

    # Print the match, together with the short description
    puts "%i%% %s - %s" % [m.percent, name, 'summary not available']
  end
end

# Read the "/etc/services"-style database of value indices
def read_value_db pathname
  begin
    rmcomments = /\s*(#.*)?$/
    splitter = /\s+/
    values = {}
    File.open pathname, 'r' do |io|
      while line = io.gets
        # Remove comments and trailing spaces
        line = rmcomments.sub("", line)
        # Skip empty lines
        next if line.empty?
        # Split the line
        fields = splitter.split(line)
        if fields.length < 2
          stderr.puts "Ignoring line %s:%d: only 1 value found when I need at least the value name and number" % [pathname, io.lineno + 1]
          next
        end
        # Parse the number
        begin
          number = fields[1].to_i
        rescue NoMethodError
          $stderr.puts "Ignoring line %s:%d: the second column (\"%s\") must be a number" % [pathname, io.lineno + 1, fields[1]]
          next
        end
        values[fields[0]] = number
        fields[2..-1].each do |a|
          values[a] = number
        end
      end
    end
  rescue => e
    # If we can't read the database, fallback to defaults
    $stderr.puts "Cannot read %s: %s.  Using a minimal default configuration" % [pathname, e]
    values = {
      :installedsize => 1,
      :packagesize => 2
    }
  end
  values
end
