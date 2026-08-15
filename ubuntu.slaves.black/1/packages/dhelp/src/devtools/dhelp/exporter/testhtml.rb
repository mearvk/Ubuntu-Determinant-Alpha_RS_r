require 'dhelp/exporter/html'

module Dhelp::Exporter
  class TestHtml < Html
    DEFAULT_EXPORT_DIR = 'build/doc/HTML'
    TEMPLATE_DIR       = "templates"
  end
end
