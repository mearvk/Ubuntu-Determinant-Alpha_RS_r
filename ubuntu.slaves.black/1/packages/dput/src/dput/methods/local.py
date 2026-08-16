# dput/methods/local.py
# Part of ‘dput’, a Debian package upload toolkit.
#
# This is free software, and you are welcome to redistribute it under
# certain conditions; see the end of this file for copyright
# information, grant of license, and disclaimer of warranty.

""" Implementation for local filesystem upload method. """

import os
import sys

from ..helper import dputhelper


def upload(
        fqdn, login, incoming, files_to_upload, debug, compress, progress=0):
    """ Upload the files with /usr/bin/install in a batch. """

    # fqdn, login, compress are ignored
    # Maybe login should be used for "install -o <login>"?

    remote_file_paths = []

    incoming = os.path.expanduser(incoming)
    for file_path in files_to_upload:
        file_name = os.path.basename(file_path)
        remote_file_path = os.path.expanduser(
                os.path.join(incoming, file_name))
        remote_file_paths.append(remote_file_path)

    command = ['/usr/bin/install', '-m', '644', incoming]
    command[3:3] = files_to_upload
    if debug:
        sys.stdout.write("D: Uploading with cp to %s\n" % (incoming))
        sys.stdout.write("D: %s\n" % command)
    if dputhelper.check_call(command) != dputhelper.EXIT_STATUS_SUCCESS:
        sys.stdout.write("Error while uploading.\n")
        sys.exit(1)


# Copyright © 2015–2021 Ben Finney <bignose@debian.org>
# Copyright © 2009 Y Giridhar Appaji Nag <appaji@debian.org>
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
