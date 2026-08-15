#!/usr/bin/ruby

require 'dhelp'
require 'fileutils'

SUPPORTED_FORMATS = %w(html text pdf postscript dvi)

if ARGV.size == 0
    $stderr.puts "index_package_doc.rb: index documentation contained in packages"
    $stderr.puts "SYNTAX: index_package_doc.rb <package1> [<package2> ...]"
    $stderr.puts "I need a list of packages to index"
    exit 1
end

doc_base_files = ARGV.map {|p| `dpkg -L #{p}`.split(/\s/)}.
                      flatten.
                      find_all {|line| line =~ /\/usr\/share\/doc-base\//}

doc_list = doc_base_files.map {|d| Dhelp::DocBaseDocument.new(d)}
index_paths = []
doc_list.each do |doc|
  doc.formats.each do |format|
    next unless SUPPORTED_FORMATS.include? format.format.downcase
    format.files.each do |glob_path|
      files = Dir.glob(glob_path)
      index_paths += files.select {|f| File.file? f}
    end
  end
end

puts <<EOF
Indexing the following doc-base files
-------------------------------------
#{doc_base_files.join("\n")}
EOF

# If the index doesn't exist, we have to force non-incremental indexing
options = {}
index_file = '/var/lib/dhelp/documents.index'
if File.exist? index_file and File.size(index_file) == 0
    FileUtils.rm_f index_file
end
unless File.exist? index_file
  options[:incremental] = false
end

idx = Dhelp::Indexer.new
idx.index(index_paths, options)
