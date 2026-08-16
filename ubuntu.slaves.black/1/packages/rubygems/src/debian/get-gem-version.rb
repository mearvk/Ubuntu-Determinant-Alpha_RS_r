#!/usr/bin/ruby

if ARGV.length != 1
  puts 'Usage: get-gem-version.rb <gemspec_file>'
  exit 1
end

gemspec_file = ARGV[0]
gemspec = Gem::Specification::load(gemspec_file)
puts gemspec.version
