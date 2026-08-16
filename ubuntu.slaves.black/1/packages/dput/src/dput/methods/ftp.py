# dput/methods/ftp.py
# Part of ‘dput’, a Debian package upload toolkit.
#
# This is free software, and you are welcome to redistribute it under
# certain conditions; see the end of this file for copyright
# information, grant of license, and disclaimer of warranty.

""" Implementation for FTP upload method. """

import ftplib
import getpass
import os
import sys

from ..helper import dputhelper


def upload(
        fqdn, login, incoming, files_to_upload, debug, ftp_mode,
        progress=0, port=21):
    """ Upload the files via FTP.

        (Could need a bit more error-checking.)

        """

    try:
        ftp_connection = ftplib.FTP()
        ftp_connection.connect(fqdn, port)
        if debug:
            sys.stdout.write("D: FTP-Connection to host: %s\n" % fqdn)
    except ftplib.all_errors as e:
        sys.stdout.write(
                "Connection failed, aborting. Check your network\n"
                "%s\n" % e)
        sys.exit(1)
    prompt = login + "@" + fqdn + " password: "
    if login == 'anonymous':
        password = 'dput@packages.debian.org'
    else:
        password = getpass.getpass(prompt)
    try:
        ftp_connection.login(login, password)
    except ftplib.error_perm:
        sys.stdout.write("Wrong Password\n")
        sys.exit(1)
    except EOFError:
        sys.stdout.write("Server closed the connection\n")
        sys.exit(1)
    ftp_connection.set_pasv(ftp_mode == 1)
    try:
        ftp_connection.cwd(incoming)
    except ftplib.error_perm as e:
        if e.args and e.args[0][:3] == '550':
            sys.stdout.write("Directory to upload to does not exist.\n")
            sys.exit(1)
        else:
            raise
    if debug:
        sys.stdout.write("D: Directory to upload to: %s\n" % incoming)
    for file_path in files_to_upload:
        file_directory, file_name = os.path.split(file_path)
        try:
            if debug:
                sys.stdout.write("D: Uploading File: %s\n" % file_path)
            if progress:
                try:
                    size = os.stat(file_path).st_size
                except Exception:
                    size = -1
                    if debug:
                        sys.stdout.write(
                                "D: Determining size of file '%s' failed\n"
                                % file_path)
            f = open(file_path, 'rb')
            if progress:
                f = dputhelper.FileWithProgress(
                        f, ptype=progress,
                        progressf=sys.stdout,
                        size=size)
            sys.stdout.write("  Uploading %s: " % file_name)
            sys.stdout.flush()
            ftp_connection.storbinary(
                    'STOR ' + file_name,
                    f, 1024)
            f.close()
            sys.stdout.write("done.\n")
            sys.stdout.flush()
        except ftplib.all_errors as e:
            sys.stdout.write("%s\n" % e)
            if (
                    isinstance(e, ftplib.Error)
                    and e.args and e.args[0][:3] == '553'):
                sys.stdout.write(
                        "Leaving existing %s on the server and continuing\n"
                        % (file_name))
                sys.stdout.write(
                        "NOTE: This existing file may have been"
                        " previously uploaded partially.\n"
                        "For official Debian upload queues,"
                        " the dcut(1) utility can be\n"
                        "used to remove this file, and after"
                        " an acknowledgement mail is\n"
                        "received in response to dcut,"
                        " the upload can be re-initiated.\n")
                continue
            elif (
                    isinstance(e, ftplib.Error)
                    and e.args and e.args[0][:1] == '5'):
                sys.stdout.write(
                        "Note: This error might indicate a problem with"
                        " your passive_ftp setting.\n"
                        "Please consult dput.cf(5) for details on"
                        " this configuration option.\n")
            if debug:
                sys.stdout.write(
                        "D: Should exit silently now, but"
                        " will throw exception for debug.\n")
                raise
            sys.exit(1)
    try:
        ftp_connection.quit()
    except Exception as e:
        if debug:
            sys.stdout.write(
                    "D: Exception %s while attempting to quit ftp session.\n"
                    "D: Throwing an exception for debugging purposes.\n" % e)
            raise


# Copyright © 2015–2021 Ben Finney <bignose@debian.org>
# Copyright © 2008–2013 Y Giridhar Appaji Nag <appaji@debian.org>
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
