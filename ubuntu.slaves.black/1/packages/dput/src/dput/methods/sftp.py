# dput/methods/sftp.py
# Part of ‘dput’, a Debian package upload toolkit.
#
# This is free software, and you are welcome to redistribute it under
# certain conditions; see the end of this file for copyright
# information, grant of license, and disclaimer of warranty.


""" Implementation for SFTP upload method. """

import errno
import os
import os.path
import random
import sys
import socket
import subprocess
import time

from ..helper import dputhelper


class ProcessAsChannelAdapter(object):
    """ Wrap a process as a paramiko Channel. """

    def __init__(self, argv):
        # Need to use a socket for some unknown reason
        self.__socket, subproc_sock = socket.socketpair()
        self.__proc = subprocess.Popen(argv, stdin=subproc_sock,
                                       stdout=subproc_sock, bufsize=0)

    def get_name(self):
        """ Return a simple name for the adapter. """
        return "ProcessAsChannelAdapter"

    def send(self, data):
        """ Send a number of bytes to the subprocess. """
        return self.__socket.send(data)

    def recv(self, num_bytes):
        """ Receive a number of bytes from the subprocess. """
        try:
            return self.__socket.recv(num_bytes)
        except socket.error as e:
            if e.args[0] in (errno.EPIPE, errno.ECONNRESET, errno.ECONNABORTED,
                             errno.EBADF):
                # Connection has closed.  Paramiko expects an empty string in
                # this case, not an exception.
                return ''
            raise

    def close(self):
        """ Close and wait for process to finish. """
        self.__socket.close()
        self.__proc.terminate()
        self.__proc.wait()


def get_ssh_command_line(login, fqdn, port):
    """ Gather a command line for connection to a server. """
    return ["ssh",
            "-oForwardX11 no",
            "-oForwardAgent no",
            "-oPermitLocalCommand no",
            "-oClearAllForwardings yes",
            "-oProtocol 2",
            "-oNoHostAuthenticationForLocalhost yes",
            "-p", port,
            "-l", login,
            "-s", "--", fqdn, "sftp"]


def copy_file(sftp_client, local_path, remote_path, debug, progress):
    """ Upload a single file. """
    with open(local_path, 'rb') as fileobj:
        if progress:
            try:
                size = os.stat(local_path).st_size
            except Exception:
                size = -1
                if debug:
                    sys.stdout.write(
                        "D: Determining size of file '%s' failed\n"
                        % local_path)

            fileobj = dputhelper.FileWithProgress(fileobj, ptype=progress,
                                                  progressf=sys.stdout,
                                                  size=size)

        tmp_path = '%s.tmp.%.9f.%d.%d' % (remote_path, time.time(),
                                          os.getpid(),
                                          random.randint(0, 0x7FFFFFFF))
        try:
            with sftp_client.file(tmp_path, "w", bufsize=0) as remote_fileobj:
                while True:
                    data = fileobj.read(256 * 1024)
                    if not data:
                        break
                    remote_fileobj.write(data)

            sftp_client.rename(tmp_path, remote_path)
        except Exception as e:
            sftp_client.remove(tmp_path)
            raise e


def upload(fqdn, login, incoming, files, debug, compress, progress=0):
    """ Upload the files via SFTP.

        Requires paramiko for SFTP protocol, but uses the ssh binary
        for setting up the connection so we get proper prompts for
        authentication, unknown hosts and other stuff.

        """
    try:
        import paramiko.sftp_client
    except Exception as e:
        sys.stdout.write(
            "E: paramiko must be installed to use sftp transport.\n")
        sys.exit(1)

    if ':' in fqdn:
        fqdn, port = fqdn.rsplit(":", 1)
    else:
        port = "22"

    if not login or login == '*':
        login = os.getenv("USER")

    if not incoming.endswith("/"):
        incoming = "%s/" % incoming

    try:
        channel = ProcessAsChannelAdapter(get_ssh_command_line(login,
                                                               fqdn, port))
        sftp_client = paramiko.sftp_client.SFTPClient(channel)
    except Exception as e:
        sys.stdout.write("%s\nE: Error connecting to remote host.\n" % e)
        sys.exit(1)

    try:
        for local_path in files:
            path_to_package, base_filename = os.path.split(local_path)
            remote_path = os.path.join(incoming, base_filename)
            sys.stdout.write("  Uploading %s: " % base_filename)
            sys.stdout.flush()
            try:
                copy_file(sftp_client, local_path, remote_path,
                          debug, progress)
            except Exception as e:
                sys.stdout.write("\n%s\nE: Error uploading file.\n" % e)
                sys.exit(1)
            sys.stdout.write("done.\n")
    finally:
        channel.close()


# Copyright © 2006-2018 Canonical Ltd.
# Copyright © 2006 Robey Pointer <robey@lag.net>
#                  (parts of ProcessAsChannelAdapter)
#
# Authors: Cody A.W. Somerville <cody.somerville@canonical.com>
#          Julian Andres Klode <julian.klode@canonical.com>
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
