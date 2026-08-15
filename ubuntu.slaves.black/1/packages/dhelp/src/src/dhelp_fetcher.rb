#!/usr/bin/ruby -w

require 'cgi'
require 'erb'
require 'gettext'
require 'zlib'

require 'dhelp'

MIMETYPES_FILE = '/etc/mime.types'
ERROR_TEMPLATE = '/usr/share/dhelp/templates/fetcher_error.rhtml'


def error(message)
  print "Content-Type: text/html\n\n"

  tmpl = ERB.new(File.read(ERROR_TEMPLATE))
  @message = message
  puts tmpl.result(binding)
  exit 1
end


def _(message)
  GetText.bindtextdomain('dhelp')
  GetText._(message)
end


def content_type(path)
  path =~ /\.([^.]+)$/
  ext = $1
  # Search in the mime.types file
  File.readlines(MIMETYPES_FILE).each do |line|
    line =~ /^(\S+)\s+(.*)/
    mime, exts = $1, ($2 || "").split(/\s+/)
    return mime if exts.include? ext
  end
  return "text/plain"
end



cgi = CGI.new
file = cgi.params['file'].first

# Search for the file in the doc-base database
if file.kind_of? String
  db = Dhelp::DocDirDatabase.open
  begin
    doc_id, title = db.info_for_path(File.dirname(file))
  rescue Dhelp::KeyNotFoundError
    error("I can't find #{file} in the doc-base documentation")
  end

  if not File.readable? file
    error("I can't read file '#{file}'. Maybe the package containing it was uninstalled?")
  end


  # Everything is fine, return the document

  # HTML pages are handled as redirections if they're visible (to avoid
  # problems with relative links)
  if file =~ Regexp.new('/usr/share(/doc/.*\\.html?)$')
    url = $1
    cgi.out("Status" => 302,
            "Location" => url) { "" }
    exit 0
  end

  # If it's compressed, uncompress first
  if file =~ /\.gz$/
    print "Content-Type: #{content_type(file.sub(/\.gz$/, ''))}\n\n"
    Zlib::GzipReader.open(file) {|gz|
      print gz.read
    }
  else
    print "Content-Type: #{content_type(file)}\n\n"
    print File.read(file)
  end
else
  error("You have to specify a parameter 'file'")
end
