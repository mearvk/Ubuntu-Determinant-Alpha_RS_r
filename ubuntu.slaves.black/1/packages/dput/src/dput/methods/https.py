# dput/methods/http.py
# Part of ‘dput’, a Debian package upload toolkit.
#
# This is free software, and you are welcome to redistribute it under
# certain conditions; see the end of this file for copyright
# information, grant of license, and disclaimer of warranty.

""" Implementation for HTTP upload method. """

from http.client import HTTPSConnection

from . import http


def upload(
        fqdn, login, incoming, files_to_upload, debug, dummy,
        progress=0, protocol="https", connection_class=HTTPSConnection):
    return http.upload(
            fqdn, login, incoming, files_to_upload, debug, dummy,
            progress, protocol=protocol, connection_class=connection_class)


# Copyright © 2015–2021 Ben Finney <bignose@debian.org>
# Copyright © 2007 Thomas Viehmann <tv@beamnet.de>
#
# This is free software: you may copy, modify, and/or distribute this work
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; version 3 of that license or any later version.
# No warranty expressed or implied. See the file ‘LICENSE.GPL-3’ for details.


# Local variables:
# coding: utf-8
# mode: python
# End:
# vim: fileencoding=utf-8 filetype=python :
