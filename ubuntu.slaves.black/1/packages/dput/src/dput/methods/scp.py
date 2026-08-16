# dput/methods/scp.py
# Part of ‘dput’, a Debian package upload toolkit.
#
# This is free software, and you are welcome to redistribute it under
# certain conditions; see the end of this file for copyright
# information, grant of license, and disclaimer of warranty.

""" Implementation for SCP upload method. """

import os
import stat
import sys

from ..helper import dputhelper


def upload(
        fqdn, login, incoming, files_to_upload, debug, compress,
        ssh_config_options=[], progress=0):
    """ Upload the files with scp in a batch. """

    remote_file_paths = []

    for file_path in files_to_upload:
        file_name = os.path.basename(file_path)
        remote_file_path = os.path.join(incoming, file_name)
        remote_file_paths.append(remote_file_path)

    command = ['scp', '-p']
    if compress:
        command.append('-C')
    for anopt in ssh_config_options:
        command += ['-o', anopt]
    # TV-Note: Are these / Should these be escaped?
    command += files_to_upload
    if login and login != '*':
        login_spec = '%s@' % login
    else:
        login_spec = ''
    command.append('%s%s:%s' % (login_spec, fqdn, incoming))
    change_mode = 0
    for file_path in files_to_upload:
        if not stat.S_IMODE(os.lstat(file_path)[stat.ST_MODE]) == 0o644:
            change_mode = 1
    if debug:
        sys.stdout.write(
                "D: Uploading with scp to %s%s:%s\n"
                % (login_spec, fqdn, incoming))
        sys.stdout.write("D: %s\n" % command)
    if dputhelper.check_call(command) != dputhelper.EXIT_STATUS_SUCCESS:
        sys.stdout.write("Error while uploading.\n")
        sys.exit(1)
    if change_mode:
        fix_command = ['ssh']
        for anopt in ssh_config_options:
            fix_command += ['-o', anopt]
        fix_command += [
                '%s%s' % (login_spec, fqdn), 'chmod', '0644'
                ] + remote_file_paths
        if debug:
            sys.stdout.write("D: Fixing some permissions\n")
            sys.stdout.write("D: %s\n" % fix_command)
        exit_status = dputhelper.check_call(fix_command)
        if exit_status != dputhelper.EXIT_STATUS_SUCCESS:
            sys.stdout.write("Error while fixing permissions.\n")
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
