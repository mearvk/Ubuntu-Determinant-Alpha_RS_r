#!/usr/bin/env python3

"""Setup script for 'yapps'"""

from distutils.core import setup

description = "Keyboard mapping generator"
long_description = """
This program generates a keyboard decision tree from a number of
keyboard map files.
"""

setup(
    name="keymapper",
    version="0.2",
    description=description,
    long_description=long_description,
    author="Matthias Urlichs",
    author_email="smurf@smurf.noris.de",
    maintainer="Matthias Urlichs",
    maintainer_email="smurf@smurf.noris.de",
    url="http://smurf.noris.de/code/",
    license="GPL",
    platforms=["POSIX"],
    keywords=["Keymap"],
    packages=["keymapper", "keymapper.parse"],
    scripts=["gen_keymap"],
)
