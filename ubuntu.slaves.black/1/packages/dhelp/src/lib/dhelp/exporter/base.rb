require 'fileutils'
require 'gettext'

module Dhelp::Exporter

  DEFAULT_EXPORT_DIR   = "#{PREFIX}/share/doc/HTML"
  DEFAULT_TEMPLATE_DIR = "#{PREFIX}/share/dhelp/templates"

  class Base

    attr_reader :doc_pool, :export_dir, :template_dir
    attr_writer :doc_pool, :export_dir, :template_dir

    def initialize(doc_pool, options={})
      @doc_pool = doc_pool
      @export_dir = options[:dir] || DEFAULT_EXPORT_DIR
      @template_dir = options[:templates] || DEFAULT_TEMPLATE_DIR
      # Set-up gettext environment
      GetText.set_output_charset("UTF-8")
      GetText.bindtextdomain('dhelp')
    end

    def export()
      raise NotImplementedError
    end

    # Proxy, to avoid problems with binding and ERB templates (bindtextdomain
    # doesn't work on the templates when called from the main program)
    def _(msg)
      GetText._(msg)
    end

  end   # class Base

end   # module Exporter
