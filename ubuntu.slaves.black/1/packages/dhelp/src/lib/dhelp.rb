=begin
    Ruby support library for dhelp database access

    Copyright (C) 2005  Esteban Manchado Velázquez

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

require 'dbm'
require 'pathname'
require 'fileutils'

# Dhelp-related classes
module Dhelp
  SUPPORTED_FORMATS = %w(html text pdf postscript dvi)
  DOC_DIR_DATABASE  = '/var/lib/dhelp/doc-base_dirs'
  DOC_INDEX_FILE    = '/var/lib/dhelp/documents.index'
  DOC_INDEX_CONFIG  = '/usr/share/dhelp/config/swish++.conf'
  DOC_PENDING_FILE  = '/var/lib/dhelp/pending.list'

  # Exception for indexer errors (when calling index++)
  class Exception < RuntimeError; end   # Base class Dhelp::Exception
  class RegisterDocsError < Exception; end
  class IndexerError < Exception; end
  class KeyNotFoundError < Exception; end
  class InvalidOptionError < Exception; end


  def Dhelp.check_options(opts, supported_options)
    unsupported_options = opts.keys - supported_options
    unless unsupported_options.empty?
      raise InvalidOptionError, "Invalid option(s): '#{unsupported_options.join(", ")}'. Supported options: #{supported_options.join(", ")}"
    end
  end


  CORRECT_CAPITALIZATION = {"ocaml" => "OCaml"}
  # Correctly capitalize a section
  def Dhelp.capitalize_section(section)
    section.split("/").
            map {|s| CORRECT_CAPITALIZATION[s.downcase] || s.capitalize}.
            join("/")
  end


  # C struct wrapper: it allows to map a C struct in an easy to use Ruby class.
  # For each C struct you want to support, you create a Ruby class with calls
  # to the class methods "pack_fmt" and "field_list". See Array#pack
  # documentation for the "pack_fmt" parameter. "field_list" is just a list of
  # struct field names (positional according to the "pack_fmt").
  #
  #  class SomeStructClass < CStructWrapper
  #    pack_fmt    'Z100'
  #    field_list  %w(dir)
  #  end
  class CStructWrapper

    # Class methods

    # Get/Set the pack format
    def self.pack_fmt(fmt = nil)
      @fmt = fmt if fmt
      @fmt
    end

    # Get/Set the field list. It can be set as an array, or as several
    # parameters
    def self.field_list(*args)
      case args.size
      when 0
        # Just get the value, do nothing
      when 1
        first = args.first
        @field_list = first.kind_of?(Array) ? first : [first]
      else
        @field_list = args
      end
      @field_list.map {|f| f.to_sym}
    end

    # Instance methods

    def initialize(data)
      case data
      when String
        @data = data
      when Hash
        @data = keys.map {|f| data[f]}.pack(pack_fmt)
      else
        raise ArgumentError, "Argument must be either String or Hash"
      end
    end

    # Handy shortcut methods
    def keys;     self.class.field_list; end
    def pack_fmt; self.class.pack_fmt;   end

    def get_field(f)
      i = keys.index(f.to_sym)
      if i
        @data.unpack(pack_fmt)[i]
      else
        raise ArgumentError, "Unknown field '#{f}'"
      end
    end

    # Returns a Hash object with all the C struct fields
    def to_hash
      h = {}
      keys.each do |f|
        h[f] = get_field(f)
      end
      h
    end

    # Returns the data in C format
    def to_raw_data
      @data
    end

    # Catches missing methods, to get the field values
    def method_missing(meth, *args)
      if keys.include? meth.to_sym
        get_field(meth)
      else
        super
      end
    end
  end



  # doc-base document format representation (consists of "format", "files" and
  # optionally "index")
  class DocBaseDocumentFormat
    attr_reader :format

    def initialize(format, index, files)
      @format, @index, @files = format, index, files
    end

    def index
      @index.to_s != "" ? @index : Dir.glob(files.first).first
    end

    def files
      @files.to_s.strip.split(/\s+/)
    end

    def all_files
      if @index.to_s != ""
        files + [@index]
      else
        files
      end
    end
  end


  # doc-base registered document
  class DocBaseDocument
    attr_reader :path, :document, :title, :author, :formats

    def initialize(path)
      @path         = path
      @document, @title, @author, @abstract, @section = ""
      @formats      = []
      @format, @index, @files = ""
      state         = :main_block
      last_property = nil
      File.readlines(@path).each do |line|
        case line
        when /^(\w+):\s*(.*)/
          prop, contents = $1, $2.to_s
          state = :format_block if state == :noblock
          instance_var_name = "@#{prop.downcase}"
          instance_variable_set(instance_var_name,
                                instance_variable_get(instance_var_name).to_s + contents)
          last_property = prop
        when /^\s*$/
          if state == :format_block
            @formats << DocBaseDocumentFormat.new(@format, @index, @files)
            @format = @index = @files = nil
          end
          state = :noblock
        else
          instance_var_name = "@#{last_property.downcase}"
          instance_variable_set(instance_var_name,
                                instance_variable_get(instance_var_name) + line.chomp)
        end
      end

      if state == :format_block
        @formats << DocBaseDocumentFormat.new(@format, @index, @files)
      end
    end

    def section
      Dhelp.capitalize_section(@section)
    end

    def abstract
      # Could be nil
      @abstract.to_s.strip
    end

    # Convenience method to return all files in all supported formats
    def files
      formats.find_all {|d| SUPPORTED_FORMATS.include? d.format}.map {|d| d.files}
    end
  end


  # DocDirDatabase key C struct wrapper
  class DocDirDatabaseKey < CStructWrapper
    pack_fmt    'Z100'
    field_list  %w(dir)
  end


  # DocDirDatabase value C struct wrapper
  class DocDirDatabaseValue < CStructWrapper
    pack_fmt    'Z50 Z1000'
    field_list  %w(doc_id title)
  end


  # Database for doc-base directories. It contains base directories associated
  # with the corresponding doc-base doc id and the document title.
  class DocDirDatabase < DBM
    def self.open(flags   = DBM::READER,
                  name    = DOC_DIR_DATABASE,
                  options = {},
                  mode    = 0644)
      super(name, mode, flags)
    end

    # Traverse entire BD, passing directory, doc_id and title of each item to
    # the block
    def each
      each_pair do |k,v|
        value = DocDirDatabaseValue.new(v)
        yield DocDirDatabaseKey.new(k).dir, value.doc_id, value.title
      end
    end

    # Writes an association between the given directory and the doc-base
    # document id and its title
    def add(dir, doc_id, title)
      key = DocDirDatabaseKey.new(:dir => dir)
      value = DocDirDatabaseValue.new(:doc_id => doc_id, :title => title)
      self[key.to_raw_data] = value.to_raw_data
    end

    def include?(dir)
      key = DocDirDatabaseKey.new(:dir => dir)
      return has_key?(key.to_raw_data)
    end

    # Returns an array with two elements, doc_id and title, for the registered
    # doc-base document in the given directory
    def info_for_path(dir)
      key = DocDirDatabaseKey.new(:dir => dir)
      raw_value = self[key.to_raw_data]
      if raw_value.nil?
        raise KeyNotFoundError, "Can't find information for path #{dir}"
      end
      value = DocDirDatabaseValue.new(raw_value)
      [value.doc_id, value.title]
    end
  end




  # Pool of doc-base files. It looks for doc-base files in a list of
  # directories (by default /usr/share/doc-base), and allows to iterate over a
  # collection of DocBaseDocument objects
  class DocBaseDocumentPool
    def initialize(opts={})
      @opts = {:dirs => ['/usr/share/doc-base']}.merge(opts)
      Dhelp.check_options(@opts, [:dirs])
    end

    # Iterates over the documents, passing a DocBaseDocument object to the
    # block.
    def each
      @opts[:dirs].each do |dir|
        Dir.entries(dir).each do |entry|
          path = File.join(dir, entry)
          next if entry[0..0] == '.' or File.directory? path
          yield DocBaseDocument.new(path)
        end
      end
    end

    # Iterates over the sections, passing both the section name and the list of
    # documents in that section to the block. The sections are ordered
    # alphabetically, but sending all subsections first.
    def each_section
      item_list = {}
      each do |doc|
        item_list[doc.section] ||= []
        item_list[doc.section] << doc
      end

      ordered_sections = item_list.keys.sort {|a,b|
        # Order subsections first
        case tmp = a.scan('/').size <=> b.scan('/').size
        when 0
          a <=> b
        else
          tmp * -1
        end
      }
      ordered_sections.each do |sec|
        yield sec, item_list[sec].sort {|a,b| a.title <=> b.title}
      end
    end
  end



  # DhelpDocumentPool - represents the pool of "dhelp-registered" documents.
  # Every new doc-base file has to be registered with this class for dhelp to
  # know everything about them.
  class DhelpDocumentPool
    def initialize(user_opts={})
      @opts = {:doc_dir_database    => DOC_DIR_DATABASE,
               :index_file          => DOC_INDEX_FILE,
               :indexer_config_file => DOC_INDEX_CONFIG,
               :pending_file        => DOC_PENDING_FILE}.merge(user_opts)
      Dhelp.check_options(@opts, [:index_file,
                                  :indexer_config_file,
                                  :pending_file,
                                  :doc_base_dir,
                                  :doc_dir_database])
      doc_base_pool_options = {}
      if @opts.has_key? :doc_base_dir
        dbd = @opts[:doc_base_dir]
        doc_base_pool_options[:dirs] = dbd.kind_of?(Array) ? dbd : [dbd]
      end
      @doc_base_document_pool = DocBaseDocumentPool.new(doc_base_pool_options)
      @doc_dir_database       = @opts[:doc_dir_database]
      @skip_list = []
    end

    # Registers a document (DocBaseDocument) in the pool
    def register(doc_base_doc)
      _register_docs([doc_base_doc])
    end

    # Deregisters a document
    def deregister(doc_base_doc)
      @skip_list << doc_base_doc
    end

    # Rebuilds the whole pool, making sure everything is consistent
    # If doindex = true (the default) full indexing is also performed,
    # to achieve compatibility with the cron jobs shipped by versions
    # 0.6.14 and 0.6.19 of the package, 
    # If doindex = false, the pending file is not cleaned and indexing
    # is not performed, to make dhelp_parse/doc-base calls efficient.
    def rebuild(doindex=true)
      if doindex
        _clean_pending_file
      end
      @skip_list = []
      # DocBaseDocumentPool works as an iterable document list
      _register_docs(@doc_base_document_pool, :regenerate_index => true)
      if doindex
        indexer = Indexer.new({:incremental  => false,
                               :index_file   => @opts[:index_file],
                               :config_file  => @opts[:indexer_config_file],
                               :pending_file => @opts[:pending_file]})
        indexer.index
      end
    end

    # Returns the DocBaseDocument objects that haven't been deregistered
    def each
      @doc_base_document_pool.each do |doc_base|
        yield doc_base unless @skip_list.include? doc_base.path
      end
    end

    # Returns a Hash containing the sections (keys) and list of documents per
    # section and subsections (values). The format is like this:
    #
    # pool.section_tree # => {"App"  => {:documents   => [ ... ],
    #                                    :subsections => {"Tools" => {...}}},
    #                         "Text" => {:documents   => [ ... ]}}
    def section_tree
      root = {}
      each do |doc|
        section_name = doc.section
        section_hash = root
        # Create parent sections if needed
        if section_name =~ /(.+?)\/(.+)/
          parent, subsection = $1, $2
          root[parent] ||= {:documents   => [],
                            :subsections => {}}
          section_name = subsection
          section_hash = root[parent][:subsections]
        end
        section_hash[section_name] ||= {:documents   => [],
                                        :subsections => {}}
        section_hash[section_name][:documents] << doc
      end
      root
    end

    private

    # Deletes the currently pending documents list to ensure that stale 
    # contents do not pollute the index with extraneous files when rebuild
    # is invoked.
    def _clean_pending_file
      begin
        File.delete(@opts[:pending_file])
      rescue Errno::ENOENT
        return
      rescue SystemCallError => e
        # On any other system errors, report but allow to continue
        # (else we may risk not-indexing current pending documents)
        puts "Warning: system returned error code #{e.errno} " +
          "while deleting #{@opts[:pending_file]}"
      end
    end 

    # Registers a list of doc-base documents as part of Dhelp
    def _register_docs(doc_list, user_opts={})
      register_opts = {:regenerate_index => false}.merge(user_opts)
      if register_opts[:regenerate_index]
        doc_dir_db = DocDirDatabase.open(DBM::NEWDB, @doc_dir_database)
      else
        doc_dir_db = DocDirDatabase.open(DBM::WRCREAT, @doc_dir_database)
      end
      index_paths = []
      doc_list.each do |doc|
        doc.formats.each do |format|
          next unless SUPPORTED_FORMATS.include? format.format.downcase
          format.all_files.each do |glob_path|
            # Dirnames can be globs too (like /usr/share/doc/foo/*/*.html)
            dirs  = Dir.glob(File.dirname(glob_path))
            files = Dir.glob(glob_path)
            # Add an entry with a reference to the document title, if it wasn't
            # already there. Also, if we register anything here, it's a new
            # document, so we collect the files for indexing.
            new_document = false
            dirs.each do |dir|
              next unless File.directory? dir
              if not doc_dir_db.include? dir
                doc_dir_db.add(dir, doc.document, doc.title)
                new_document = true
              end
            end
            # Collect the files
            if new_document or register_opts[:regenerate_index]
              index_paths += files.select {|f| File.file? f}
            end
          end
        end
      end
      doc_dir_db.close

      # Now append index_paths to index-pending registered docs file
      unless index_paths.empty?
        err_msg = ""
        begin
          File.open(@opts[:pending_file], "a+") do |f|
            index_paths.each do |ip|
              f.puts ip
            end
          end
        rescue IOError => e
          err_msg = "I/O error (#{e})"
        rescue SystemCallError => e
          err_msg = "System call error #{e.errno}"
        end
        unless err_msg == ""
          raise RegisterDocsError, 
            "#{err_msg} while appending #{index_paths.join(', ')}," +
            " to pending list #{register_opts[:pending_file]}"
        end
      end
    end
  end



  # Indexer class. So far it only takes care of doc-base documents.
  class Indexer
    def initialize(user_opts={})
      @opts = {:incremental  => true,
               :index_file   => DOC_INDEX_FILE,
               :config_file  => DOC_INDEX_CONFIG,
               :indexpp_cmd  => "/usr/bin/index++",
               :pending_file => DOC_PENDING_FILE}.merge(user_opts)
      Dhelp.check_options(@opts, [:incremental,
                                  :index_file,
                                  :config_file,
                                  :indexpp_cmd,
                                  :pending_file])
    end

    # Returns the value of incremental option
    def incremental; @opts[:incremental]; end

    # Returns the index file
    def index_file; @opts[:index_file]; end

    # Returns the config file
    def config_file; @opts[:config_file]; end

    # Returns the index++ binary path
    def indexpp_cmd; @opts[:indexpp_cmd]; end

    # Returns the index++ command-line options
    def indexpp_options
      "--config-file #{config_file} --index-file #{index_file}" +
        " --follow-links" +
        (incremental ? " --incremental" : "")
    end

    # Returns the pending-documents-list-for-indexing file
    def pending_file; @opts[:pending_file]; end

    # Returns the pending-documents-list-for-indexing contents as an array
    def read_pending_file
      # Don't use File.exist? to avoid races; use exceptions instead
      begin
        IO.readlines(pending_file)
      rescue Errno::ENOENT
        []
      rescue IOError, SystemCallError
        raise IndexerError, "Error during reading index-pending list: " +
          "#{pending_file}"
      end
    end

    # Deletes the currently pending documents list
    def clean_pending_file
      begin
        File.delete(pending_file)
      rescue Errno::ENOENT
        return
      rescue SystemCallError => e
        # On any other system errors, report but allow to continue
        # (else we may risk not-indexing current pending documents)
        puts "Warning: system returned error code #{e.errno} " +
          "while deleting #{pending_file}"
      end
    end 

    # Returns true if already indexing
    def is_indexing?
      i_file = (incremental ? "#{index_file}.new" : index_file)
      File.exist?(i_file) and File.size(i_file) == 0
    end

    # Index the list of given dirs/files with index++. Directories are indexed
    # recursively.  There is only one valid key for the user_opts hash:
    # :incremental, which adds the contents of the given paths to the index,
    # instead of replacing it with the indexed contents of paths.
    def index(paths=[], user_opts={})
      if user_opts.has_key? :incremental
        @opts[:incremental] = user_opts[:incremental]
      end
      cmd = "#{indexpp_cmd} #{indexpp_options} -"

      # If the index doesn't exist yet and we're doing incremental,
      # switch to non-incremental mode and create it.  That way we will
      # have at least a partial index until the next rebuild cron job.
      if incremental and not File.exist?(index_file)
        @opts[:incremental] = false
        cmd = "#{indexpp_cmd} #{indexpp_options} -"
      end

      # If it's already indexing, just exit
      if is_indexing?
        return
      end

      # Add to paths the list of currently pending documents
      paths[paths.length, 0] = read_pending_file
      # Delete the pending file here. Else any filenames added during the
      # time we are indexing (by a subsequent invocation of dpkg) may be 
      # lost if we keep the file around and delete it later.
      clean_pending_file

      # Finally, invoke the indexer to create the index.
      begin
        File.popen(cmd, "w") do |f|
          paths.each do |dir|
            f.puts dir
          end
        end
      rescue Errno::EPIPE
        raise IndexerError, "Broken pipe indexing #{paths.to_a.join(', ')}, using #{cmd}"
      end

      if $? != 0
        raise IndexerError, "Couldn't index #{paths.to_a.join(', ')} using #{cmd}"
      end

      # When using incremental indexing (default), a new index is created (with
      # the extension ".new")
      if incremental
        FileUtils.mv "#{index_file}.new", index_file
      end
    end


    # DEPRECATED METHOD, ONLY FOR COMPATIBILITY WITH NON-UP-TO-DATE cron FILES
    def reindex_all
      # Made a no-op, to avoid reverse-depends on DhelpDocumentPool
      # The cron files in question are either pre-sarge or in intermediate
      # dhelp versions which now only live on CDs; it's time to upgrade...

      puts "This dhelp method is not supported anymore." +
        " Please upgrade your cron file to one of the newer versions."
    end
  end
end
