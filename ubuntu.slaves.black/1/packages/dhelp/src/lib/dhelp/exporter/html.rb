require 'dhelp/exporter/base'
require 'dhelp/exporter/cgimap'
require 'erb'
require 'fileutils'
require 'gettext'

module Dhelp::Exporter

  FORMAT_NAMES = {:html             => 'HTML',
                  :pdf              => 'PDF',
                  :postscript       => 'PostScript',
                  :"debiandoc-sgml" => 'DebianDoc-SGML',
                  :dvi              => 'DVI'}
  EXPORTED_FILELIST = "/var/lib/dhelp/exported.list"

  class Html < Base

    attr_reader :section_template, :index_template
    attr_writer :section_template, :index_template

    def initialize(doc_pool, options={})
      super(doc_pool, options)
      @section_template = template_dir + "/section.rhtml"
      @index_template = template_dir + "/index.rhtml"
      @generated_files = []
    end

    def recreate_export_dir(create_mode)
      # Drop previously exported files if they exist.
      old_files = []
      if File.exist?(EXPORTED_FILELIST)
        old_files = File.readlines(EXPORTED_FILELIST, :chomp => true)
      end
      old_files.reverse_each{ |entry|
        if entry.end_with?('/')
          begin
            FileUtils.rmdir(entry)
          rescue SystemCallError
            $stderr.puts "Warning: Fail to remove #{entry}, ignoring"
          end
        else
          FileUtils.rm_f(entry)
        end
      }

      FileUtils.chdir(export_dir)
      # Create README file
      File.open("README", "w") do |f|
        f.puts <<EOREADME
Don't put files in this directory!
dhelp will delete *all* files in this directory when creating a new index.

Esteban Manchado Velázquez (zoso@debian.org)
EOREADME
      end
      @generated_files.push(File.join(export_dir, "README"))
    end

    def make_page(template, page_dir, page_filename)
      page_path = File.join(page_dir, page_filename)

      tmpl = ERB.new(File.read(template))
      html = tmpl.result(binding)

      unless File.directory?(page_dir)
        FileUtils.mkdir_p(page_dir, :mode => 0755)
        @generated_files.push(page_dir + "/")
      end
      File.open(page_path, "w") do |f|
        f.print html
      end
      File.chmod 0644, page_path
      @generated_files.push(page_path)
    end

    def export()
      recreate_export_dir(0755)

      # Variables for the template
      @section_tree = doc_pool.section_tree

      # Generate section pages from the tree

      @section_tree.each_pair do |section, contents|
        # section first
        export_section_page(section, contents[:documents])
        # then subsections
        contents[:subsections].each_pair do |subsection, subcontents|
          export_section_page(File.join(section,subsection), subcontents[:documents])
        end
      end

      # Write special "section page" for all the docs

      all_docs = []
      @section_tree.each_pair do |section, contents|
        all_docs += contents[:documents]
        all_docs += contents[:subsections].map {|ss, ssc| ssc[:documents]}.flatten
      end
      export_section_page("All", all_docs)

      # Create general index file, now that the sections are already there

      make_page(index_template, export_dir, "index.html")

      # Save names of newly created files.

      File.open(EXPORTED_FILELIST, "w") do |out|
        out.puts(@generated_files)
      end

    rescue Errno::EACCES # => e
      $stderr.puts "Don't have permissions to regenerate the HTML help"
      exit 1
    end

    def export_section_page(section, itemlist)

      # Variables for the template
      @section_title = Dhelp.capitalize_section(section)
      @supported_formats = Dhelp::SUPPORTED_FORMATS
      @item_list         = itemlist.sort{ |a,b|
        a.title.downcase <=> b.title.downcase
      }
      @doc_path_prefix   = "../" * (section.split('/').size + 1) # count "HTML/"
        
      # Create section index file
      make_page(section_template, section_dir, "index.html")
    end

    # Returns the correct name for each format
    def format_name(format)
      Dhelp::Exporter::FORMAT_NAMES[format.downcase.to_sym] || format.capitalize
    end

    # Returns a suitable URL for the given path
    def resource_url(path)
      path.sub(/\/usr\/share\/doc\//, @doc_path_prefix)
    end

    def section_dir()
      return File.join(@export_dir, @section_title)
    end

  end   # class Html
end   # module Dhelp::Exporter
