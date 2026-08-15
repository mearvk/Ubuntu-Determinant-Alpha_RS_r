#!/usr/bin/ruby -w

=begin
    Documentation generator for dhelp

    Copyright (C) 2005-2007  Esteban Manchado Velázquez

    This program is free software; you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation; either version 2 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
=end

# Keep the (non-existent) indentation in next line (the "PREFIX" one)
PREFIX = '/usr'
DEFAULT_INDEX_ROOT = "#{PREFIX}/share/doc/HTML"

# Set default file format as UTF-8, without printing a warning
old_verbose, $VERBOSE = $VERBOSE, false
Encoding.default_external = "UTF-8"
$VERBOSE = old_verbose

require 'dhelp'
require 'dhelp/exporter/html'
include Dhelp

require 'optparse'
require 'find'
require 'yaml'


# Configuration class
class DhelpConf
  def initialize(path)
    @conf = YAML::load_file(path)
    @conf["search_directories"] ||= DEFAULT_SEARCH_DIRS
  end

  def to_hash
    @conf
  end

  def method_missing(meth)
    @conf[meth.to_s]
  end
end


# dhelp_parse application class
class DhelpParseApp

  DHELP_CONF_FILE     = "/etc/dhelp.conf"
  DOC_DIR             = '/usr/share/doc'
  DOC_BASE_DHELP_DIR  = '/var/lib/doc-base/dhelp'
  DEFAULT_SEARCH_DIRS = [DOC_DIR, DOC_BASE_DHELP_DIR]

  VERSION   = "0.2.1"
  AUTHOR    = "Esteban Manchado Velázquez"
  COPYRIGHT = "Copyright (C) 2005-2007, Esteban Manchado Velázquez"

  MSG_USAGE = 'Usage: dhelp_parse [-a | -d]... [DOCBASE_FILE]...
   or: dhelp_parse [-r | -i]
Add/remove doc-base documents to/from Debian Online Help database
or index them fully or incrementally.'

  MSG_DOC_ADD = 'add documents registered in the given doc-base file(s)'
  MSG_DOC_RMV = 'remove documents registered in the given doc-base file(s)'
  MSG_INDEX   = 'perform incremental indexing of pending registered docs'
  MSG_REBUILD = 'perform full re-indexing of all registered docs'
  MSG_VERBOSE = 'be more verbose when adding/deleting registered documents'

  MSG_VERSION = "dhelp_parse #{VERSION}
#{COPYRIGHT}
License GPLv2+: GNU GPL version 2 or later <http://gnu.org/licenses/gpl.html>.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Written by #{AUTHOR}."

  def initialize
    @action  = nil
    @verbose = false
    optparse = OptionParser.new do |opts|
      opts.banner = "%s\n\n" % MSG_USAGE

      opts.on('-a FILE[...]', MSG_DOC_ADD) { |files|
        @action = :add
        files = [files] if files.is_a? String
        @doc_base_files = files
      }
      opts.on('-d FILE[...]', MSG_DOC_RMV) { |files|
        @action = :delete
        files = [files] if files.is_a? String
        @doc_base_files = files
      }
      opts.on('-i', MSG_INDEX) { @action = :index }
      opts.on('-r', MSG_REBUILD) { @action = :reindex }
      opts.on('-v', MSG_VERBOSE) { @verbose = true }

      opts.on('-h', '--help', 'display this help and exit') {
        puts opts
        exit 0
      }
      opts.separator('')
      opts.on('--version', 'output version information and exit') {
        puts MSG_VERSION
        exit 0
      }
    end
    optparse.summary_width = 16
    optparse.parse!
    
    if @action == nil
      $stderr.puts optparse
      exit 1
    end
  end

  def packaged_configured?
    File.exist? '/var/lib/dhelp/configured'
  end

  # Adds the documents supplied in command-line to the pool.
  def add_documents(pool)
    @doc_base_files.each do |doc_base_file|
      if File.readable?(doc_base_file)
        if @verbose
          puts "Parsing document #{doc_base_file}"
        end
        doc_base_doc = Dhelp::DocBaseDocument.new(doc_base_file)
        if @verbose
          puts "Registering document #{doc_base_file}"
        end
        pool.register(doc_base_doc)
      else
        # Don't stop on single file errors; allow others with no error
        # to be successfully registered.
        $stderr.puts "Can't read doc-base file '#{doc_base_file}'"
      end
    end
  end

  # Rebuilds the HTML indices to be in sync with pool's state.
  def rebuild_html_index(pool)
    if @verbose
      puts "Rebuilding documentation index at #{DEFAULT_INDEX_ROOT}"
    end
    exporter = Dhelp::Exporter::Html.new(pool, :dir => DEFAULT_INDEX_ROOT)
    exporter.export()
  end

  # Starts the indexer to index the pending-documents-for-indexing list
  def do_deferred_indexing(user_opts = {})
    opts = {}
    if user_opts.has_key? :incremental
      opts[:incremental] = user_opts[:incremental]
    end
    if @verbose
      puts "Indexing documents contained in pending list"
    end
    indexer = Dhelp::Indexer.new(opts)
    indexer.index
  end

  def main
    begin
      if packaged_configured?
        conf = DhelpConf.new(DHELP_CONF_FILE)
      else
        $stderr.puts "Deferring until dhelp is configured"
        exit 0
      end
    rescue Errno::ENOENT
      $stderr.puts "Can't read configuration file #{DHELP_CONF_FILE}"
      exit 1
    end

    # List of directories to look for doc-base documents
    doc_base_dirs = conf.search_directories.map {|d| File.expand_path(d)}
    pool = Dhelp::DhelpDocumentPool.new(:doc_base_dir => doc_base_dirs)

    case @action
    when :add
      add_documents(pool)
    when :delete
      @doc_base_files.each do |doc_base_file|
        if @verbose
          puts "Deregistering document #{doc_base_file}"
        end
        pool.deregister(doc_base_file)
      end
    when :index
      # Index incrementally, to update with registered so-far documents.
      # This is the normal mode of operation, called by the dpkg trigger
      # after the end of each installation run.
      do_deferred_indexing
      return 0
    when :reindex
      # Recreate the pool, without doing a full indexing.
      pool.rebuild(false)
    end

    # Always executed
    # We cannot defer this, unless a persistence mechanism between 
    # subsequent invocations of this binary is setup.
    rebuild_html_index(pool)
  rescue => e
    puts "#{e.class}: #{e} (#{e.backtrace.join("\n")})"
  end
end

DhelpParseApp.new.main
