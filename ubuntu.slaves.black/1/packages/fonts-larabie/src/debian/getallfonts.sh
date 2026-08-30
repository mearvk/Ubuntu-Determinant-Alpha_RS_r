#!/bin/sh
echo Getting a new list of fonts from www.larabiefonts.com...
echo -n > fonts.url.lst
for letter in a b c d e f g h i j k l m n o p q r s t u v w x y z;
do
	wget http://www.larabiefonts.com/fonts/$letter/ -O - | \
		grep -e '\.zip' | \
		sed -e 's/^.*".\([^"]\)\([^"]*\.zip\).*$/http:\/\/www.larabiefonts.com\/fonts\/\1\/\1\2/' | \
		grep -v icons\/ >> fonts.url.lst
done
echo Getting new fonts and examples.
wget -N -i fonts.url.lst
echo There should be `grep \.zip fonts.url.lst | wc -l` fonts in this directory.
echo There are `ls *.zip | wc -l` fonts here.
rm fonts.url.lst
