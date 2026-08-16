# dput/helper/dputhelper.py
# Part of ‘dput’, a Debian package upload toolkit.
#
# This is free software, and you are welcome to redistribute it under
# certain conditions; see the end of this file for copyright
# information, grant of license, and disclaimer of warranty.

""" Helper code for Dput. """

import io
import locale
import os
import subprocess
import sys
import time

import pkg_resources


class DputException(Exception):
    pass


class DputUploadFatalException(DputException):
    pass


EXIT_STATUS_SUCCESS = 0
EXIT_STATUS_FAILURE = 1
EXIT_STATUS_COMMAND_NOT_FOUND = 127


# This wrapper is intended as a migration target for the prior
# `spawnv` wrapper, and will produce the same output for now.
def check_call(args, *posargs, **kwargs):
    """ Wrap `subprocess.check_call` with error output. """
    command_file_path = args[0]
    try:
        subprocess.check_call(args, *posargs, **kwargs)
        exit_status = EXIT_STATUS_SUCCESS
    except subprocess.CalledProcessError as exc:
        exit_status = exc.returncode
        if exit_status == EXIT_STATUS_COMMAND_NOT_FOUND:
            sys.stderr.write(
                    "Error: Failed to execute '{path}'.\n"
                    "       "
                    "The file may not exist or not be executable.\n".format(
                        path=command_file_path))
        else:
            sys.stderr.write(
                    "Warning: The execution of '{path}' as\n"
                    "  '{command}'\n"
                    "  returned a nonzero exit code.\n".format(
                        path=command_file_path, command=" ".join(args)))
    return exit_status


class FileWithProgress:
    """ Mimics a file (passed as f, an open file), but with progress.

        FileWithProgress(f, args)

        args:
        * ptype = 1,2 is the type ("|/-\" or numeric), default 0 (no progress)
        * progressf = file to output progress to (default sys.stdout)
        * size = size of file (or -1, the default, to ignore)
                 for numeric output
        * step = stepsize (default 1024)

        """

    def __init__(self, f, ptype=0, progressf=sys.stdout, size=-1, step=1024):
        self.f = f
        self.count = 0
        self.lastupdate = 0
        self.ptype = ptype
        self.ppos = 0
        self.progresschars = ['|', '/', '-', '\\']
        self.progressf = progressf
        self.size = size
        self.step = step
        self.closed = 0

    def __getattr__(self, name):
        return getattr(self.f, name)

    def read(self, size=-1):
        a = self.f.read(size)
        self.count = self.count + len(a)
        if (self.count - self.lastupdate) > 1024:
            if self.ptype == 1:
                self.ppos = (self.ppos + 1) % len(self.progresschars)
                self.progressf.write(
                        (self.lastupdate != 0) * "\b" +
                        self.progresschars[self.ppos])
                self.progressf.flush()
                self.lastupdate = self.count
            elif self.ptype == 2:
                s = str(self.count // self.step) + "k"
                if self.size >= 0:
                    s += (
                            '/' + str((self.size + self.step - 1) // self.step)
                            + 'k')
                s += min(self.ppos - len(s), 0) * ' '
                self.progressf.write(self.ppos * "\b" + s)
                self.progressf.flush()
                self.ppos = len(s)
        return a

    def close(self):
        if not self.closed:
            self.f.close()
            self.closed = 1
            if self.ptype == 1:
                if self.lastupdate:
                    self.progressf.write("\b \b")
                    self.progressf.flush()
            elif self.ptype == 2:
                self.progressf.write(
                        self.ppos * "\b" + self.ppos * " " + self.ppos * "\b")
                self.progressf.flush()

    def __del__(self):
        self.close()


def make_text_stream(stream):
    """ Make a text stream from the specified stream.

        :param stream: An open file-like object.
        :return: A stream object providing text I/O.

        In the normal case, the specified stream is a stream providing
        bytes I/O. We create an `io.TextIOWrapper` with the
        appropriate encoding for the byte stream, and return that
        wrapper stream.

        The text encoding is determined by interrogating the file
        object. If the file object has no declared encoding, the
        default `locale.getpreferredencoding(False)` is used.

        If the stream is a `io.TextIOBase` instance, it is already
        providing text I/O. In this case, the stream is returned as
        is.

        """
    result = None

    if hasattr(stream, 'encoding'):
        encoding = stream.encoding
    else:
        encoding = locale.getpreferredencoding(False)

    if isinstance(stream, io.TextIOBase):
        result = stream
    else:
        result = io.TextIOWrapper(stream, encoding=encoding)

    return result


def get_progname(argv=None):
    """ Get the program name from the command line arguments.

        :param argv: Sequence of command-line arguments.
            Defaults to `sys.argv`.
        :return: The program name used to invoke this program.

        """
    if argv is None:
        argv = sys.argv
    progname = os.path.basename(argv[0])
    return progname


def get_distribution_version():
    """ Get the version string for this distribution. """
    distribution = pkg_resources.get_distribution("dput")
    return distribution.version


def getopt(args, shortopts, longopts):
    args = args[:]
    optlist = []
    while args and args[0].startswith('-'):
        if args[0] == '--':
            args = args[1:]
            break
        if args[0] == '-':
            break
        if args[0].startswith('--'):
            opt = args.pop(0)[2:]
            if '=' in opt:
                opt, optarg = opt.split('=', 1)
            else:
                optarg = None
            prefixmatch = [x for x in longopts if x.startswith(opt)]
            if len(prefixmatch) == 0:
                raise DputException('unknown option --%s' % opt)
            elif len(prefixmatch) > 1:
                raise DputException('non-unique prefix --%s' % opt)
            opt = prefixmatch[0]
            if opt.endswith('=='):
                opt = opt[:-2]
                optarg = optarg or ''
            elif opt.endswith('='):
                opt = opt[:-1]
                if not optarg:
                    if not args:
                        raise DputException(
                                'option --%s requires argument' % opt)
                    optarg = args.pop(0)
            else:
                if optarg is not None:
                    raise DputException(
                            'option --%s does not take arguments' % opt)
                optarg = ''
            optlist.append(('--' + opt, optarg))
        else:
            s = args.pop(0)[1:]
            while s:
                pos = shortopts.find(s[0])
                if pos == -1:
                    raise DputException('option -%s unknown' % s[0])
                if pos + 1 >= len(shortopts) or shortopts[pos + 1] != ':':
                    optlist.append(('-' + s[0], ''))
                    s = s[1:]
                elif len(s) > 1:
                    optlist.append(('-' + s[0], s[1:]))
                    s = ''
                elif args:
                    optlist.append(('-' + s, args.pop(0)))
                    s = ''
                else:
                    raise DputException('option -%s requires argument' % s)
    return optlist, args


# Copyright © 2015–2021 Ben Finney <bignose@debian.org>
# Copyright © 2009–2010 Y Giridhar Appaji Nag <appaji@debian.org>
# Copyright © 2007–2008 Thomas Viehmann <tv@beamnet.de>
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
