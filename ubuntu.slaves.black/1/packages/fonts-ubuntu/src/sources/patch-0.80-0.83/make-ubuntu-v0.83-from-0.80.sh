#!/bin/sh
TTF_VERSION="0.83"
TTF_FILES="Ubuntu-R.ttf Ubuntu-RI.ttf Ubuntu-B.ttf Ubuntu-BI.ttf Ubuntu-L.ttf Ubuntu-LI.ttf Ubuntu-M.ttf Ubuntu-MI.ttf Ubuntu-C.ttf"

# setup a virtualenv and run script
 virtualenv ./env
source env/bin/activate
pip install git+https://github.com/behdad/fonttools.git
python ubuntu0.8fix.py "$TTF_VERSION" $TTF_FILES
deactivate
rm -r env
echo "Please sign new fonts using dmote"