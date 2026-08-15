=begin
    Ruby support library for dynamic text on dhelp templates creation.

    Copyright (C) 2012 Georgios M. Zarkadas <gz@member.fsf.org>

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

require 'dhelp'
require 'gettext'
require 'debian'

module Dhelp::Exporter

  # our unmatched constant
  NONE      = ''

  # Maps of items to package names.
  CGI_MAP   = {'info2www'  => 'info2www',
               'man2html'  => 'man2html'}

  # Content of cgi-scripts links.
  INFO2WWW  = "info pages"
  MAN2HTML  = "man pages"

  class BaseMap

    def initialize(use_map={})
      @item_map = use_map
      # Set-up gettext environment
      GetText.set_output_charset("UTF-8")
      GetText.bindtextdomain('dhelp')
    end

    # The alltime-wanted nice shortcut alias
    def _(message)
      return GetText._(message)
    end

    # Return the status of the package associated to this item.
    def package_status(item)
      pkg = @item_map[item] || NONE
      if pkg == NONE
        return pkg
      end
      Debian::Dpkg.status(pkg).each_package{ |deb|
        if deb.package == pkg
          return deb.status
        end
      }
    end

    @@pkgs_status = {}
    
    # Return true if the package associated to this item is installed.
    def installed?(item)
      return @@pkgs_status[item] if @@pkgs_status[item] != nil
      
      @@pkgs_status[item] = package_status(item) == "installed"
      return @@pkgs_status[item]
    end

  end   # class BaseMap

  # Provides links texts of optional cgi-scripts components
  # based on the status of the associated packages.
  class CgiMap < BaseMap

    def initialize(use_map=CGI_MAP)
      super(use_map)
    end

    # Return the info2www link text
    def info2www_link()
      if installed?("info2www")
        return "<a href=\"/cgi-bin/info2www\">" + _(INFO2WWW) + "</a>"
      else
        return "<span class=\"disabled\">" + _(INFO2WWW) + "</span>"
      end
    end

    # Return the man2thml link text
    def man2html_link()
      if installed?("man2html")

        # From debian wheezy's man2html and onwards
        # the script is inside a 'man' subdirectory.

        if File.exist?("/usr/lib/cgi-bin/man/man2html")
          return "<a href=\"/cgi-bin/man/man2html\">" + _(MAN2HTML) + "</a>"
        else
          return "<a href=\"/cgi-bin/man2html\">" + _(MAN2HTML) + "</a>"
        end
      else
        return "<span class=\"disabled\">" + _(MAN2HTML) + "</span>"
      end
    end

  end   # class CgiMap

end   # module Dhelp::Exporter
