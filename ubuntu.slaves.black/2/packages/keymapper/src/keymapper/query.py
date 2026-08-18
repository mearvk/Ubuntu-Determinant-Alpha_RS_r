# query.py
# Abstract class for answering inquiries

# Copyright (c) 2005 by Matthias Urlichs <smurf@smurf.noris.de>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of Version 2 of the GNU General Public License as
# published by the Free Software Foundation. See the file COPYING.txt
# or (on Debian systems) /usr/share/common-licenses/GPL-2 for details.

"""\
Interface description for asking he user about a keyboard.

We ask two kinds of questions:

- Press any one of [list of symbols]!
  The keyboard is expected to have at least one of them.
  "None of the above" is not an acceptable answer.

- Does your keyboard show [symbol]?
  The user can answer "yes" or "no".

"""

from __future__ import print_function


class Query(object):
    """A keyboard inquiry.

    Presumably we need to switch the keyboard to raw mode or something.
    """

    def __init__(self):
        pass

    def start(self):
        """Startup the questions."""
        pass

    def press(self, syms):
        """Ask the user to press one of these keys"""
        raise NotImplementedError

    def ask(self, sym):
        """Ask the user if this key exists"""
        raise NotImplementedError

    def message(self, msg):
        """Tell the user something."""
        print(msg)

    def done(self):
        """Shutdown the questions."""
        pass
