#! /usr/bin/python3
#
# dput/dcut.py
# Part of ‘dput’, a Debian package upload toolkit.
#
# This is free software, and you are welcome to redistribute it under
# certain conditions; see the end of this file for copyright
# information, grant of license, and disclaimer of warranty.

""" dcut — Debian command upload tool. """

import os
import pwd
import shutil
import string
import subprocess
import sys
import tempfile
import textwrap
import time

from . import dput
from .helper import dputhelper


validcommands = ('rm', 'cancel', 'reschedule')


def make_usage_message():
    """ Make the program usage help message. """
    text = textwrap.dedent("""\
        Usage: %s [options] [host] command [, command]
         Supported options (see man page for long forms):
           -c file Config file to parse.
           -d      Enable debug messages.
           -h      Display this help message.
           -s      Simulate the commands file creation only.
           -v      Display version information.
           -m maintaineraddress
                   Use maintainer information in "Uploader:" field.
           -k keyid
                   Use this keyid for signing.
           -O file Write commands to file.
           -U file Upload specified commands file (presently no checks).
           -i changes
                   Upload a commands file to remove files listed in .changes.
         Supported commands: mv, rm
           (No paths or command-line options allowed on ftp-master.)
        """) % (dputhelper.get_progname(sys.argv))
    return text


def get_uploader_from_system(options):
    """ Get the system value for the ‘uploader’ option. """
    uploader = None

    # check environment for maintainer
    if options['debug']:
        sys.stdout.write(
                "D: trying to get maintainer email from environment\n")

    if 'DEBEMAIL' in os.environ:
        if os.environ['DEBEMAIL'].find('<') < 0:
            uploader = os.environ.get("DEBFULLNAME", '')
            if uploader:
                uploader += ' '
            uploader += '<%s>' % (os.environ['DEBEMAIL'])
        else:
            uploader = os.environ['DEBEMAIL']
        if options['debug']:
            sys.stdout.write(
                    "D: Uploader from env: %s\n" % (uploader))
    elif 'EMAIL' in os.environ:
        if os.environ['EMAIL'].find('<') < 0:
            uploader = os.environ.get("DEBFULLNAME", '')
            if uploader:
                uploader += ' '
            uploader += '<%s>' % (os.environ['EMAIL'])
        else:
            uploader = os.environ['EMAIL']
        if options['debug']:
            sys.stdout.write(
                    "D: Uploader from env: %s\n" % (uploader))
    else:
        if options['debug']:
            sys.stdout.write("D: Guessing uploader\n")
        pwrec = pwd.getpwuid(os.getuid())
        username = pwrec[0]
        fullname = pwrec[4].split(',')[0]
        try:
            hostname = open('/etc/mailname').read().strip()
        except IOError:
            hostname = ''
        if not hostname:
            if options['debug']:
                sys.stdout.write(
                        "D: Guessing uploader: /etc/mailname was a failure\n")
            hostname_subprocess = subprocess.Popen(
                    "/bin/hostname --fqdn",
                    shell=True, stdout=subprocess.PIPE)
            hostname_stdout = dputhelper.make_text_stream(
                    hostname_subprocess.stdout)
            hostname = hostname_stdout.read().strip()
        if hostname:
            uploader = (
                    "%s <%s@%s>" % (fullname, username, hostname))
            if options['debug']:
                sys.stdout.write(
                        "D: Guessed uploader: %s\n" % (uploader))
        else:
            if options['debug']:
                sys.stdout.write("D: Couldn't guess uploader\n")

    return uploader


def getoptions():
    # seed some defaults
    options = {
            'debug': 0, 'simulate': 0, 'config': None, 'host': None,
            'uploader': None, 'keyid': None, 'passive': 0,
            'filetocreate': None, 'filetoupload': None, 'changes': None}
    progname = dputhelper.get_progname(sys.argv)
    version = dputhelper.get_distribution_version()

    # enable debugging very early
    if ('-d' in sys.argv[1:] or '--debug' in sys.argv[1:]):
        options['debug'] = 1
        sys.stdout.write("D: %s %s\n" % (progname, version))

    # parse command line arguments
    (opts, arguments) = dputhelper.getopt(
            sys.argv[1:],
            'c:dDhsvm:k:PU:O:i:', [
                'config=', 'debug',
                'help', 'simulate', 'version', 'host=',
                'maintainteraddress=', 'keyid=',
                'passive', 'upload=', 'output=', 'input='
                ])

    for (option, arg) in opts:
        if options['debug']:
            sys.stdout.write(
                    'D: processing arg "%s", option "%s"\n' % (option, arg))
        if option in ('-h', '--help'):
            sys.stdout.write(make_usage_message())
            sys.exit(os.EX_OK)
        elif option in ('-v', '--version'):
            sys.stdout.write("%s %s\n" % (progname, version))
            sys.exit(os.EX_OK)
        elif option in ('-d', '--debug'):
            options['debug'] = 1
        elif option in ('-c', '--config'):
            options['config'] = arg
        elif option in ('-m', '--maintaineraddress'):
            options['uploader'] = arg
        elif option in ('-k', '--keyid'):
            options['keyid'] = arg
        elif option in ('-s', '--simulate'):
            options['simulate'] = 1
        elif option in ('-P', '--passive'):
            options['passive'] = 1
        elif option in ('-U', '--upload'):
            options['filetoupload'] = arg
        elif option in ('-O', '--output'):
            options['filetocreate'] = arg
        elif option == '--host':
            options['host'] = arg
        elif option in ('-i', '--input'):
            options['changes'] = arg
        else:
            sys.stderr.write(
                    "%s internal error: Option %s, argument %s unknown\n"
                    % (progname, option, arg))
            sys.exit(1)

    if not options['host'] and arguments and arguments[0] not in validcommands:
        options['host'] = arguments[0]
        if options['debug']:
            sys.stdout.write(
                    'D: first argument "%s" treated as host\n'
                    % (options['host']))
        del arguments[0]

    if not options['uploader']:
        options['uploader'] = get_uploader_from_system(options)

    # we don't create command files without uploader
    if (
            not options['uploader']
            and (options['filetoupload'] or options['changes'])):
        sys.stderr.write(
                "%s error: command file cannot be created"
                " without maintainer email\n"
                % progname)
        sys.stderr.write(
                '%s        please set $DEBEMAIL, $EMAIL'
                ' or use the "-m" option\n'
                % (len(progname) * ' '))
        sys.exit(1)

    return options, arguments


def parse_queuecommands(arguments, options, config):
    commands = []
    # want to consume a copy of arguments
    arguments = arguments[:]
    arguments.append(0)
    curarg = []
    while arguments:
        if arguments[0] in validcommands:
            curarg = [arguments[0]]
            if arguments[0] == 'rm':
                if len(arguments) > 1 and arguments[1] == '--nosearchdirs':
                    del arguments[1]
                else:
                    curarg.append('--searchdirs')
        else:
            if not curarg and arguments[0] != 0:
                sys.stderr.write(
                        'Error: Could not parse commands at "%s"\n'
                        % (arguments[0]))
                sys.exit(1)
            if str(arguments[0])[-1] in (',', ';', 0):
                curarg.append(arguments[0][0:-1])
                arguments[0] = ','
            if arguments[0] in (',', ';', 0) and curarg:
                # TV-TODO: syntax check for #args etc.
                if options['debug']:
                    sys.stdout.write(
                            'D: Successfully parsed command "%s"\n'
                            % (' '.join(curarg)))
                commands.append(' '.join(curarg))
                curarg = []
            else:
                # TV-TODO: maybe syntax check the arguments here
                curarg.append(arguments[0])
        del arguments[0]
    if not commands:
        sys.stderr.write("Error: no arguments given, see dcut -h\n")
        sys.exit(1)
    return commands


def write_commands(commands, options, config, tempdir):
    """ Write a file of commands for the upload queue daemon.

        :param commands: Commands to write, as a sequence of text
            strings.
        :param options: Program configuration, as a mapping of options
            `{name: value}`.
        :param config: `ConfigParser` instance for this application.
        :param tempdir: Filesystem path to directory for temporary files.
        :return: Filesystem path of file which was written.

        Write the specified sequence of commands to a file, in the
        format required for the Debian upload queue management daemon.

        Once writing is finished, the file is signed using the
        'debsign' command.

        If not specified in the configuration option 'filetocreate', a
        default filename is generated. In either case, the resulting
        filename is returned.

        """
    progname = dputhelper.get_progname(sys.argv)
    if options['filetocreate']:
        filename = options['filetocreate']
    else:
        translationorig = (
                str('').join(map(chr, range(256)))
                + string.ascii_letters + string.digits)
        translationdest = 256 * '_' + string.ascii_letters + string.digits
        translationmap = str.maketrans(translationorig, translationdest)
        uploadpartforname = options['uploader'].translate(translationmap)
        filename = (
                progname + '.%s.%d.%d.commands' %
                (uploadpartforname, int(time.time()), os.getpid()))
        if tempdir:
            filename = os.path.join(tempdir, filename)
    f = open(filename, "w")
    f.write("Uploader: %s\n" % options['uploader'])
    f.write("Commands:\n %s\n\n" % ('\n '.join(commands)))
    f.close()
    debsign_cmdline = ['debsign']
    debsign_cmdline.append('-m%s' % options['uploader'])
    if options['keyid']:
        debsign_cmdline.append('-k%s' % options['keyid'])
    debsign_cmdline.append('%s' % filename)
    if options['debug']:
        sys.stdout.write("D: calling debsign: %s\n" % debsign_cmdline)
    try:
        subprocess.check_call(debsign_cmdline)
    except subprocess.CalledProcessError:
        sys.stderr.write("Error: debsign failed.\n")
        sys.exit(1)
    return filename


def upload_stolen_from_dput_main(
        host, upload_methods, config, debug, simulate,
        files_to_upload, ftp_passive_mode):
    """ Upload files to the host.

        :param host: Configuration host name.
        :param upload_methods: Mapping of {method_name: callable}.
        :param config: `ConfigParser` instance for this application.
        :param debug: If true, enable debugging output.
        :param simulate: If true, simulate the upload only.
        :param files_to_upload: Collection of file names to upload.
        :param ftp_passive_mode: If true, enable FTP passive mode.
        :return: ``None``.

        Upload the specified files to the host, using the method and
        credentials from the configuration for the host.

        """
    # Messy, yes. But it isn't referenced by the upload method anyway.
    if config.get(host, 'method') == 'local':
        fqdn = 'localhost'
    else:
        fqdn = config.get(host, 'fqdn')

    # Check the upload methods that we have as default and per host
    if debug:
        sys.stdout.write(
                "D: Default Method: %s\n" % config.get('DEFAULT', 'method'))
    if config.get('DEFAULT', 'method') not in upload_methods:
        sys.stderr.write(
                "Unknown upload method: %s\n"
                % config.get('DEFAULT', 'method'))
        sys.exit(1)
    if debug:
        sys.stdout.write("D: Host Method: %s\n" % config.get(host, 'method'))
    if config.get(host, 'method') not in upload_methods:
        sys.stderr.write(
                "Unknown upload method: %s\n" % config.get(host, 'method'))
        sys.exit(1)

    # Inspect the Config and set appropriate upload method
    if not config.get(host, 'method'):
        method = config.get('DEFAULT', 'method')
    else:
        method = config.get(host, 'method')

    # Check now the login and redefine it if needed
    if (
            config.has_option(host, 'login')
            and config.get(host, 'login') != 'username'):
        login = config.get(host, 'login')
    elif (
            config.has_option('DEFAULT', 'login')
            and config.get('DEFAULT', 'login') != 'username'):
        login = config.get('DEFAULT', 'login')
    else:
        # Try to get the login from the enviroment
        if 'USER' in os.environ:
            login = os.environ['USER']
        else:
            sys.stdout.write("$USER not set, will use login information.\n")
            # Else use the current username
            login = pwd.getpwuid(os.getuid())[0]
            if debug:
                sys.stdout.write("D: User-ID: %s\n" % os.getuid())
        if debug:
            sys.stdout.write(
                    "D: Neither host %s nor default login used. Using %s\n"
                    % (host, login))
    if debug:
        sys.stdout.write("D: Login to use: %s\n" % login)

    incoming = config.get(host, 'incoming')
    # Do the actual upload
    if not simulate:
        if debug:
            sys.stdout.write("D: FQDN: %s\n" % fqdn)
            sys.stdout.write("D: Login: %s\n" % login)
            sys.stdout.write("D: Incoming: %s\n" % incoming)
        if method == 'ftp':
            ftp_mode = config.getboolean(host, 'passive_ftp')
            if ftp_passive_mode == 1:
                ftp_mode = 1
            if ftp_mode == 1:
                if debug:
                    if ftp_passive_mode == 1:
                        sys.stdout.write("D: Using passive ftp\n")
                    else:
                        sys.stdout.write("D: Using active ftp\n")
            upload_methods[method](
                    fqdn, login, incoming,
                    files_to_upload, debug, ftp_mode)
        elif method == 'scp':
            if debug and config.getboolean(host, 'scp_compress'):
                sys.stdout.write("D: Setting compression for scp\n")
            scp_compress = config.getboolean(host, 'scp_compress')
            ssh_config_options = [
                    y for y in (
                        x.strip() for x in
                        config.get(host, 'ssh_config_options').split('\n'))
                    if y]
            upload_methods[method](
                    fqdn, login, incoming,
                    files_to_upload, debug, scp_compress, ssh_config_options)
        else:
            upload_methods[method](
                    fqdn, login, incoming,
                    files_to_upload, debug, 0)
    # Or just simulate it.
    else:
        for file_path in files_to_upload:
            sys.stderr.write(
                    "Uploading with %s: %s to %s:%s\n"
                    % (method, file_path, fqdn, incoming))
            subprocess.call("cat %s" % file_path, shell=True)


def dcut():
    options, arguments = getoptions()
    if options['debug']:
        sys.stdout.write('D: calling dput.read_configs\n')
    config = dput.read_configs(options['config'], options['debug'])
    if (
            not options['host']
            and config.has_option('DEFAULT', 'default_host_main')):
        options['host'] = config.get('DEFAULT', 'default_host_main')
        if options['debug']:
            sys.stdout.write(
                    'D: Using host "%s" (default_host_main)\n'
                    % (options['host']))
        if not options['host']:
            options['host'] = 'ftp-master'
            if options['debug']:
                sys.stdout.write(
                        'D: Using host "%s" (hardcoded)\n'
                        % (options['host']))
    tempdir = None
    filename = None
    progname = dputhelper.get_progname(sys.argv)
    try:
        if not (options['filetoupload'] or options['filetocreate']):
            tempdir = tempfile.mkdtemp(prefix=progname + '.')
        if not options['filetocreate']:
            if not options['host']:
                sys.stdout.write(
                        "Error: No host specified"
                        " and no default found in config\n")
                sys.exit(1)
            if not config.has_section(options['host']):
                sys.stdout.write(
                        "No host %s found in config\n" % (options['host']))
                sys.exit(1)
            else:
                if config.has_option(options['host'], 'allow_dcut'):
                    dcut_allowed = config.getboolean(
                            options['host'], 'allow_dcut')
                else:
                    dcut_allowed = config.getboolean('DEFAULT', 'allow_dcut')
                if not dcut_allowed:
                    sys.stdout.write(
                            'Error: dcut is not supported'
                            ' for this upload queue.\n')
                    sys.exit(1)
        if options['filetoupload']:
            if arguments:
                sys.stdout.write(
                        'Error: cannot take commands'
                        ' when uploading existing file,\n'
                        '       "%s" found\n' % (' '.join(arguments)))
                sys.exit(1)
            commands = None
            filename = options['filetoupload']
            if not filename.endswith(".commands"):
                sys.stdout.write(
                        'Error: I\'m insisting on the .commands extension,'
                        ' which\n'
                        '       "%s" doesnt seem to have.\n' % filename)
            # TV-TODO: check file to be readable?
        elif options['changes']:
            parse_changes = dput.parse_changes
            removecommands = create_commands(options, config, parse_changes)
            filename = write_commands(removecommands, options, config, tempdir)
        else:
            commands = parse_queuecommands(arguments, options, config)
            filename = write_commands(commands, options, config, tempdir)
        if not options['filetocreate']:
            dput.import_upload_functions()
            upload_methods = dput.import_upload_functions()
            upload_stolen_from_dput_main(
                    options['host'], upload_methods, config,
                    options['debug'], options['simulate'],
                    [filename], options['passive'])
    finally:
        # we use sys.exit, so we need to clean up here
        if tempdir:
            shutil.rmtree(tempdir)


def create_commands(options, config, parse_changes):
    """ Get the removal commands from a package changes file.

        Parse the specified ‘foo.changes’ file and returns commands to
        remove files named in it.

        """
    changes_file_path = options['changes']
    if options['debug']:
        sys.stdout.write(
                "D: Parsing changes file (%s) for files to remove\n"
                % changes_file_path)
    try:
        changes_file = open(changes_file_path, 'r')
    except IOError:
        sys.stdout.write("Can't open changes file: %s\n" % changes_file_path)
        sys.exit(1)
    changes = parse_changes(changes_file)
    changes_file.close
    removecommands = ['rm --searchdirs ' + os.path.basename(changes_file_path)]
    for file_spec in changes['files'].strip().split('\n'):
        # Filename only.
        file_path = file_spec.split()[4]
        rm = 'rm --searchdirs ' + file_path
        if options['debug']:
            sys.stdout.write("D: Will remove %s with '%s'\n" % (file_path, rm))
        removecommands.append(rm)
    return removecommands


# Copyright © 2015–2021 Ben Finney <bignose@debian.org>
# Copyright © 2008–2013 Y Giridhar Appaji Nag <appaji@debian.org>
# Copyright © 2004–2009 Thomas Viehmann <tv@beamnet.de>
# Copyright © 2000–2004 Christian Kurz <shorty@debian.org>
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
# See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.


# Local variables:
# coding: utf-8
# mode: python
# End:
# vim: fileencoding=utf-8 filetype=python :
