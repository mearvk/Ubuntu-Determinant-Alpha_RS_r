#!/usr/bin/env python3

import sys
import os.path
from distutils.core import setup

for line in open(os.path.join(os.path.dirname(sys.argv[0]),'update-apt-xapian-index')):
    if line.startswith('VERSION='):
        version = eval(line.split('=')[-1])

setup(name='apt-xapian-index',
      version=version,
      description='Xapian index of Debian packages',
#      long_description=''
      author=['Enrico Zini'],
      author_email=['enrico@debian.org'],
      url='http://www.enricozini.org/sw/apt-xapian-index/',
      ## install_requires = [
      ##     "debian", "apt", "xapian",
      ## ],
      license='GPL',
      platforms='any',
      packages=['axi'],
#     py_modules=[''],
      scripts=['update-apt-xapian-index', 'axi-cache'],
     )
