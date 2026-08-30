#!/bin/sh
# Copyright (C) 2009, 2015 Ruben Molina <ruben.molina@udea.edu.co>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this package; if not, write to the Free Software
# Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301 USA
#
# On Debian systems, the complete text of the GNU General
# Public License can be found in `/usr/share/common-licenses/GPL'.


# The *.orig.tar.gz was created with 3 files from jargsrc.tar.gz
#    wget http://catb.org/~esr/jargon/jargsrc.tar.gz
#    tar zxvf jargsrc.tar.gz jargon.xml jargon.xsl jargon-text.xsl
#    chmod 644 jargon.xml jargon.xsl jargon-text.xsl


# 'xml-->html-->txt' conversion extracted from jargon-text Debian package,
# Copyright 1999,2001,2005 Paul Martin <pm@debian.org> and distributed under
# the GNU General Public Licence GPL (v2 or later).

echo " [+] generating XML for web target"
  # esr wrote xmlif, but jargon.xml uses the old syntax
  PERLOPTS='s/<\?(if|else|fi)\b/<?xmlif \1/'
  perl -pe "$PERLOPTS" < jargon.xml | xmlif condition='web' > jargon-web.xml

echo " [+] converting XML to HTML"
  xmlto -m jargon-text.xsl html-nochunks jargon-web.xml 2> /dev/null

echo " [+] fixing apostrophes"
  # Change acute accents to apostrophes. iso_8859-15 shows them badly
  sed -i "s/\o264/'/" jargon-web.html

echo " [+] dumping plain-text version"
  W3MOPTS="-dump"
  w3m $W3MOPTS jargon-web.html > jargon.txt


extract() { # usage: extract 'first string' 'second string'
# returns: lines between the first occurrences of both strings on jargon.txt
# "first string" line *included* and "second string" line *excluded*
F='jargon.txt'
N1=$(grep --line-number --max-count=1 "$1" $F | cut --delimiter=':' --fields=1)
N2=$(grep --line-number --max-count=1 "$2" $F | cut --delimiter=':' --fields=1)
sed --quiet --expression="$N1,$((N2-1))p" 'jargon.txt'
}

echo " [+] extracting chronology table to be used as ChangeLog"
  extract 'Here is a chronology' 'Version numbering' > 'ChangeLog'

echo " [+] extracting public domain notice to be included on dict headers"
  extract 'public domain' 'common heritage' > 'extracted'

echo " [+] extracting headwords/definitions"
#extract '^:(TM):' '^:zorkmid:' >> 'extracted'
extract '^:(TM):' 'Part.III' >> 'extracted'

echo " [+] removing references to 'Crunchly saga' cartoons"
  C=$(grep 'Crunchly saga' extracted | wc -l)
  for i in $(seq $C)
  do
    N3=$(grep 'Crunchly saga' --max-count=1 --line-number 'extracted' | cut --delimiter=':' --fields=1)
    sed --expression="$N3,$((N3+2))d" 'extracted' > 'cleaned'
    mv 'cleaned' 'extracted'
  done

echo " [+] formatting dictionary database"
  dictfmt -j -s "The Jargon File (version 4.4.7, 29 Dec 2003)" --without-time \
	-u "http://catb.org/~esr/jargon/jargsrc.tar.gz" \
	--utf8 --allchars --columns 79 'jargon' < 'extracted'

echo " [+] compressing dictionary"
  touch --date="$BUILD_DATE" jargon.dict
  dictzip 'jargon.dict'

