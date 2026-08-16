require 'gem2deb/rake/testtask'

skiplist = File.read("debian/ruby-tests.skip").split
ENV["TESTOPTS"] = skiplist.map { |item| "--ignore-name='#{item}'" }.join(" ")

load File.join(File.dirname(__FILE__), "..", "Rakefile")
