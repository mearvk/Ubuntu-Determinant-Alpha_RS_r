# -*- coding: utf-8 -*-
"""Custom logging for Germinate."""

# Copyright (c) 2011, 2012 Canonical Ltd.
#
# Germinate is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; either version 2, or (at your option) any
# later version.
#
# Germinate is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Germinate; see the file COPYING.  If not, write to the Free
# Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
# 02110-1301, USA.

import logging
import sys


class GerminateFormatter(logging.Formatter):
    """Format messages in Germinate's preferred concise style."""

    def __init__(self):
        logging.Formatter.__init__(self)
        self.levels = {
            logging.DEBUG: '  ',
            logging.INFO: '* ',
            logging.WARNING: '! ',
            logging.ERROR: '? ',
        }

    def format(self, record):
        try:
            if record.progress:
                return record.getMessage()
        except AttributeError:
            pass

        try:
            return '%s%s' % (self.levels[record.levelno], record.getMessage())
        except KeyError:
            return record.getMessage()


def germinate_logging(level):
    """Configure logging as preferred by Germinate command-line tools."""
    logger = logging.getLogger('germinate')
    if not logger.handlers:
        logging.basicConfig()
        logger.setLevel(level)
        handler = logging.StreamHandler(sys.stdout)
        handler.setFormatter(GerminateFormatter())
        logger.addHandler(handler)
        logger.propagate = False
    return logger
