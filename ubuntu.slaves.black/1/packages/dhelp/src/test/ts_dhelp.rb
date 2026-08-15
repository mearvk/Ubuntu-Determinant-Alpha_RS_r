=begin
Testsuite for the Ruby parts of dhelp

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

Dir.entries('test').find_all {|e| e =~ /^tc_.*\.rb/}.each do |e|
   require "test/#{e}"
end

class TS_Dhelp
   def self.suite
      suite = Test::Unit::TestSuite.new
      ObjectSpace.each_object(Class) do |o|
         next unless o.name =~ /^TC_/
         suite << o.suite
      end
      return suite
   end
end
