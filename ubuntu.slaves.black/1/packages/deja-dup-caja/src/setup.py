#!/usr/bin/env python

# Deja Dup Caja 0.0.9 - http://launchpad.net/deja-dup-caja
# Copyright (C) 2015-2019 Marcos Alvarez Costales https://launchpad.net/~costales
# Copyright (C) 2015 Ubuntu MATE             https://ubuntu-mate.org/
#
# Deja Dup Caja is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# Deja Dup Caja is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Deja Dup Caja; if not, see http://www.gnu.org/licenses
# for more information.


import os, sys, glob, DistUtilsExtra.auto

# Create data files
data = [('/usr/share/caja-python/extensions', ['caja-extension/dejadup.py'])]

# Setup stage
DistUtilsExtra.auto.setup(
    name         = "deja-dup-caja",
    version      = "0.0.9",
    description  = "Backup/Restore your files from Caja File Browser",
    author       = "Marcos Alvarez Costales https://launchpad.net/~costales",
    author_email = "https://launchpad.net/~costales",
    url          = "https://launchpad.net/deja-dup-caja",
    license      = "GPL3",
    )

