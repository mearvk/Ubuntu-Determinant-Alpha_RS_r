#! /usr/bin/python3
#
# dput/dput.py
# Part of ‘dput’, a Debian package upload toolkit.
#
# This is free software, and you are welcome to redistribute it under
# certain conditions; see the end of this file for copyright
# information, grant of license, and disclaimer of warranty.

""" dput — Debian package upload tool. """

import configparser
import email.parser
from hashlib import (
        md5,
        sha1,
        )
import importlib
import os
import os.path
import pkgutil
import pwd
import re
import signal
import stat
import string
import subprocess
import sys
import textwrap
import types

from . import crypto
from .helper import dputhelper


app_library_path = os.path.dirname(__file__)

debug = 0


def import_upload_functions():
    """ Import upload method modules and make them available. """
    upload_methods = {}

    package_name = "methods"
    modules_path = os.path.join(app_library_path, package_name)
    modules_found = [
            name for (__, name, ispkg) in
            pkgutil.iter_modules([modules_path])
            if not ispkg]
    if debug:
        sys.stdout.write("D: modules_found: %r\n" % modules_found)
    for module_name in modules_found:
        module = importlib.import_module("{package}.{module}".format(
                package=".".join(["dput", package_name]),
                module=module_name))
        if debug:
            sys.stdout.write("D: Module: %s (%r)\n" % (module_name, module))
        method_name = module_name
        if debug:
            sys.stdout.write("D: Method name: %s\n" % method_name)

        upload_methods[method_name] = module.upload

    return upload_methods


def parse_changes(changes_file):
    """ Parse the changes file. """
    check = changes_file.read(5)
    if check != '-----':
        changes_file.seek(0)
    else:
        # found a PGP header, gonna ditch the next 3 lines
        # eat the rest of the line
        changes_file.readline()
        # Hash: SHA1
        changes_file.readline()
        # empty line
        changes_file.readline()
    if not changes_file.readline().find('Format') != -1:
        changes_file.readline()
    changes_text = changes_file.read()
    changes = email.parser.HeaderParser().parsestr(changes_text)
    if 'files' not in changes:
        raise KeyError("No Files field in upload control file")
    for file_spec in changes['files'].strip().split('\n'):
        if len(file_spec.split()) != 5:
            sys.stderr.write(
                    "Invalid Files line in .changes:\n  %s\n" % file_spec)
            sys.exit(1)
    return changes


def read_configs(extra_config, debug):
    """ Read configuration settings from config files.

        :param extra_config: Filesystem path of config file to read.
        :param debug: If true, enable debugging output.
        :return: The resulting `ConfigParser` instance.

        Read config files in this order:
        * If specified on the command line, only read `extra_config`.
        * Otherwise, read ‘/etc/dput.cf’ then ‘~/.dput.cf’.
        The config parser will layer values.

        """
    config = configparser.ConfigParser()

    config.set('DEFAULT', 'login', 'username')
    config.set('DEFAULT', 'method', 'scp')
    config.set('DEFAULT', 'hash', 'md5')
    config.set('DEFAULT', 'allow_unsigned_uploads', '0')
    config.set('DEFAULT', 'allow_dcut', '0')
    config.set('DEFAULT', 'distributions', '')
    config.set('DEFAULT', 'allowed_distributions', '')
    config.set('DEFAULT', 'run_lintian', '0')
    config.set('DEFAULT', 'run_dinstall', '0')
    config.set('DEFAULT', 'check_version', '0')
    config.set('DEFAULT', 'scp_compress', '0')
    config.set('DEFAULT', 'default_host_main', '')
    config.set('DEFAULT', 'post_upload_command', '')
    config.set('DEFAULT', 'pre_upload_command', '')
    config.set('DEFAULT', 'ssh_config_options', '')
    config.set('DEFAULT', 'passive_ftp', '1')
    config.set('DEFAULT', 'progress_indicator', '0')
    config.set('DEFAULT', 'delayed', '')

    if extra_config:
        config_file_paths = (extra_config,)
    else:
        config_file_paths = ('/etc/dput.cf', os.path.expanduser("~/.dput.cf"))
    config_file = None
    for config_file_path in config_file_paths:
        try:
            config_file = open(config_file_path)
        except IOError as e:
            if debug:
                sys.stderr.write(
                        "%s: %s, skipping\n" % (e.strerror, config_file_path))
            continue
        if debug:
            sys.stdout.write(
                    "D: Parsing Configuration File %s\n" % config_file_path)
        try:
            config.read_file(config_file)
        except configparser.ParsingError as e:
            sys.stderr.write("Error parsing config file:\n%s\n" % str(e))
            sys.exit(1)
        config_file.close()
    if config_file is None:
        sys.stderr.write(
                "Error: Could not open any configfile, tried %s\n"
                % (', '.join(config_file_paths)))
        sys.exit(1)
    # only check for fqdn and incoming dir, rest have reasonable defaults
    error = 0
    for section in config.sections():
        if config.get(section, 'method') == 'local':
            config.set(section, 'fqdn', 'localhost')
        if (
                not config.has_option(section, 'fqdn') and
                config.get(section, 'method') != 'local'):
            sys.stderr.write(
                    "Config error: %s must have a fqdn set\n" % section)
            error = 1
        if not config.has_option(section, 'incoming'):
            sys.stderr.write(
                    "Config error: %s must have an incoming directory set\n"
                    % section)
            error = 1
    if error:
        sys.exit(1)

    return config


hexStr = string.hexdigits


def hexify_string(string):
    """ Convert a string of bytes to hexadecimal text representation. """
    char = ''
    ord_func = ord if isinstance(string, str) else int
    for c in string:
        char += hexStr[(ord_func(c) >> 4) & 0xF] + hexStr[ord_func(c) & 0xF]
    return char


def checksum_test(filename, hash_name):
    """ Get the hex string for the hash of a file's content.

        :param filename: Path to the file to read.
        :param hash_name: Name of the hash to use.
        :return: The computed hash value, as hexadecimal text.

        Currently supports md5, sha1. ripemd may come in the future.

        """
    try:
        file_to_test = open(filename, 'rb')
    except IOError:
        sys.stdout.write("Can't open %s\n" % filename)
        sys.exit(1)

    if hash_name == 'md5':
        hash_type = md5
    else:
        hash_type = sha1

    check_obj = hash_type()

    while 1:
        data = file_to_test.read(65536)
        if len(data) == 0:
            break
        check_obj.update(data)

    file_to_test.close()
    checksum = hexify_string(check_obj.digest())

    return checksum


def check_upload_variant(changes, debug):
    """ Check if this is a binary_upload only or not. """
    binary_upload = 0
    if 'architecture' in changes:
        arch = changes['architecture']
        if debug:
            sys.stdout.write("D: Architecture: %s\n" % arch)
        if arch.find('source') < 0:
            if debug:
                sys.stdout.write("D: Doing a binary upload only.\n")
            binary_upload = 1
    return binary_upload


def verify_signature(
        host, changes_file_path, dsc_file_path,
        config, check_only, allow_unsigned_uploads, binary_upload,
        debug):
    """ Check the signature on the two files given via function call.

        :param host: Configuration host name.
        :param changes_file_path: Filesystem path of upload control file.
        :param dsc_file_path: Filesystem path of source control file.
        :param config: `ConfigParser` instance for this application.
        :param check_only: If true, no upload is requested.
        :param allow_unsigned_uploads: If true, allow an unsigned upload.
        :param binary_upload: If true, this upload excludes source.
        :param debug: If true, enable debugging output.
        :return: ``None``.

        """

    def assert_good_signature_or_exit(path):
        """ Assert the signature on the file at `path` is good. """
        try:
            with open(path) as infile:
                crypto.check_file_signature(infile)
        except Exception as exc:
            if isinstance(exc, crypto.gpg.errors.GPGMEError):
                sys.stdout.write("{}\n".format(exc))
                sys.exit(1)
            else:
                raise

    if debug:
        sys.stdout.write(
                "D: upload control file: {}\n".format(changes_file_path))
        sys.stdout.write(
                "D: source control file: {}\n".format(dsc_file_path))
    if ((check_only or config.getboolean(host, 'allow_unsigned_uploads') == 0)
            and not allow_unsigned_uploads):
        sys.stdout.write("Checking signature on .changes\n")
        assert_good_signature_or_exit(changes_file_path)
        if not binary_upload:
            sys.stdout.write("Checking signature on .dsc\n")
            assert_good_signature_or_exit(dsc_file_path)


def source_check(changes, debug):
    """ Check if a source tarball has to be included in the package or not. """
    include_orig = include_tar = 0
    if 'version' in changes:
        version = changes['version']
        if debug:
            sys.stdout.write("D: Package Version: %s\n" % version)
        # versions with a dash in them are for non-native only
        if version.find('-') == -1:
            # debian native
            include_tar = 1
        else:
            if version.find(':') > 0:
                if debug:
                    sys.stdout.write("D: Epoch found\n")
                epoch, version = version.split(':', 1)
            pos = version.rfind('-')
            upstream_version = version[0:pos]
            debian_version = version[pos + 1:]
            if debug:
                sys.stdout.write(
                        "D: Upstream Version: %s\n" % upstream_version)
                sys.stdout.write("D: Debian Version: %s\n" % debian_version)
            if (
                    debian_version == '0.1' or debian_version == '1'
                    or debian_version == '1.1' or debian_version == '0ubuntu1'):
                include_orig = 1
            else:
                include_tar = 1
    return (include_orig, include_tar)


def verify_files(
        changes_file_directory, changes_file_name, host,
        config, check_only, check_version, allow_unsigned_uploads,
        debug):
    """ Run some tests on the files to verify that they are in good shape.

        :param changes_file_directory: Directory path of the upload
            control file.
        :param changes_file_name: Filename of the upload control file.
        :param host: Configuration host name.
        :param config: `ConfigParser` instance for this application.
        :param check_only: If true, no upload is requested.
        :param check_version: If true, check the package version
            before upload.
        :param allow_unsigned_uploads: If true, allow an unsigned upload.
        :param debug: If true, enable debugging output.
        :return: A collection of filesystem paths of all files to upload.

        """
    file_seen = include_orig_tar_gz = include_tar_gz = binary_only = 0
    files_to_upload = []

    changes_file_path = os.path.join(changes_file_directory, changes_file_name)

    if debug:
        sys.stdout.write(
                "D: Validating contents of changes file %s\n"
                % changes_file_path)
    try:
        changes_file = open(changes_file_path, 'r')
    except IOError:
        sys.stdout.write("Can't open %s\n" % changes_file_path)
        sys.exit(1)
    changes = parse_changes(changes_file)
    changes_file.close

    # Find out if it's a binary only upload or not
    binary_upload = check_upload_variant(changes, debug)

    if binary_upload:
        dsc_file_path = ''
    else:
        dsc_file_path = None
        for file_spec in changes['files'].strip().split('\n'):
            # Filename only.
            file_name = file_spec.split()[4]
            if file_name.find('.dsc') != -1:
                if debug:
                    sys.stdout.write("D: dsc-File: %s\n" % file_name)
                dsc_file_path = os.path.join(changes_file_directory, file_name)
        if not dsc_file_path:
            sys.stderr.write("Error: no dsc file found in sourceful upload\n")
            sys.exit(1)

    # Run the check to verify that the package has been tested.
    try:
        if config.getboolean(host, 'check_version') == 1 or check_version:
            version_check(changes_file_directory, changes, debug)
    except configparser.NoSectionError as e:
        sys.stderr.write("Error in config file:\n%s\n" % str(e))
        sys.exit(1)

    # Verify the signature of the maintainer
    verify_signature(
            host, changes_file_path, dsc_file_path,
            config, check_only, allow_unsigned_uploads, binary_upload,
            debug)

    # Check the sources
    (include_orig_tar_gz, include_tar_gz) = source_check(changes, debug)

    # Check md5sum and the size
    file_list = changes['files'].strip().split('\n')
    hash_name = config.get('DEFAULT', 'hash')
    for file_spec in file_list:
        (check_sum, size, section, priority, file_name) = file_spec.split()
        file_path = os.path.join(changes_file_directory, file_name)
        if debug:
            sys.stdout.write("D: File to upload: %s\n" % file_path)
        if checksum_test(file_path, hash_name) != check_sum:
            if debug:
                sys.stdout.write(
                        "D: Checksum from .changes: %s\n" % check_sum)
                sys.stdout.write(
                        "D: Generated Checksum: %s\n" %
                        checksum_test(file_path, hash_name))
            sys.stdout.write(
                    "Checksum doesn't match for %s\n" % file_path)
            sys.exit(1)
        else:
            if debug:
                sys.stdout.write(
                        "D: Checksum for %s is fine\n" % file_path)
        if os.stat(file_path)[stat.ST_SIZE] != int(size):
            if debug:
                sys.stdout.write("D: size from .changes: %s\n" % size)
                sys.stdout.write(
                        "D: calculated size: %s\n"
                        % os.stat(file_path)[stat.ST_SIZE])
            sys.stdout.write(
                    "size doesn't match for %s\n" % file_path)

        files_to_upload.append(file_path)

    # Check filenames.
    for file_path in files_to_upload:
        if file_path[-12:] == '.orig.tar.gz' and not include_orig_tar_gz:
            if debug:
                sys.stdout.write("D: Filename: %s\n" % file_path)
                sys.stdout.write("D: Suffix: %s\n\n" % file_path[-12:])
            sys.stdout.write(
                    "Package includes an .orig.tar.gz file although"
                    " the debian revision suggests\n"
                    "that it might not be required."
                    " Multiple uploads of the .orig.tar.gz may be\n"
                    "rejected by the upload queue management software.\n")
        elif (
                file_path[-7:] == '.tar.gz' and not include_tar_gz
                and not include_orig_tar_gz):
            if debug:
                sys.stdout.write("D: Filename: %s\n" % file_path)
                sys.stdout.write("D: Suffix: %s\n" % file_path[-7:])
            sys.stdout.write(
                    "Package includes a .tar.gz file although"
                    " the version suggests that it might\n"
                    "not be required."
                    " Multiple uploads of the .tar.gz may be rejected by the\n"
                    "upload queue management software.\n")

    distribution = changes.get('distribution')
    allowed_distributions = config.get(host, 'allowed_distributions')
    if distribution and allowed_distributions:
        if debug:
            sys.stdout.write(
                    "D: Checking: distribution %s matches %s\n"
                    % (distribution, allowed_distributions))
        if not re.match(allowed_distributions, distribution):
            raise dputhelper.DputUploadFatalException(
                    "Error: uploading files for distribution %s to %s"
                    " not allowed."
                    % (distribution, host))

    if debug:
        sys.stdout.write("D: File to upload: %s\n" % changes_file_path)
    files_to_upload.append(changes_file_path)

    return files_to_upload


def print_config(config, debug):
    """ Print the configuration and exit. """
    sys.stdout.write("\n")
    config.write(sys.stdout)
    sys.stdout.write("\n")


def create_upload_file(
        changes_file_name, host, fqdn,
        changes_file_directory, files_to_upload,
        debug):
    """ Write the log file for the upload.

        :param changes_file_name: File name of package to upload.
        :param host: Configuration host name.
        :param fqdn: Fully-qualified domain name of the remote host.
        :param changes_file_directory: Directory path of the upload
            control file.
        :param debug: If true, enable debugging output.
        :return: ``None``.

        The upload log file is named ‘basename.hostname.upload’, where
        “basename” is the package file name without suffix, and
        “hostname” is the name of the host as specified in the
        configuration file.

        For example, uploading ‘foo_1.2.3-1_xyz.deb’ to host ‘bar’
        will be logged to ‘foo_1.2.3-1_xyz.bar.upload’.

        The upload log file is written to the
        directory containing the upload control file.

        """
    # only need first part
    changes_file_name_base = os.path.splitext(changes_file_name)[0]
    log_file_path = os.path.join(
        changes_file_directory,
        changes_file_name_base + '.' + host + '.upload')
    if debug:
        sys.stdout.write("D: Writing logfile: %s\n" % log_file_path)
    try:
        if os.access(log_file_path, os.R_OK):
            log_file = open(log_file_path, 'a')
        else:
            log_file = open(log_file_path, 'w')
    except IOError:
        sys.stderr.write("Could not write %s\n" % log_file_path)
        sys.exit(1)

    for file_path in files_to_upload:
        log_entry = (
                'Successfully uploaded ' + os.path.basename(file_path) +
                ' to ' + fqdn + ' for ' + host + '.\n')
        log_file.write(log_entry)
    log_file.close()


def run_lintian_test(changes_file):
    """ Run lintian on the changes file and stop if it finds errors. """

    if os.access(changes_file, os.R_OK):
        if os.access("/usr/bin/lintian", os.R_OK):
            old_signal = signal.signal(signal.SIGPIPE, signal.SIG_DFL)
            sys.stdout.write("Package is now being checked with lintian.\n")
            if dputhelper.check_call(
                    ['lintian', '-i', changes_file]
                    ) != dputhelper.EXIT_STATUS_SUCCESS:
                sys.stdout.write(
                        "\n"
                        "Lintian says this package is not compliant"
                        " with the current policy.\n"
                        "Please check the current policy and your package.\n"
                        "Also see lintian documentation about overrides.\n")
                sys.exit(1)
            else:
                signal.signal(signal.SIGPIPE, old_signal)
                return 0
        else:
            sys.stdout.write(
                    "lintian is not installed, skipping package test.\n")
    else:
        sys.stdout.write("Can't read %s\n" % changes_file)
        sys.exit(1)


def guess_upload_host(changes_file_directory, changes_file_name, config):
    """ Guess the host where the package should be uploaded to.

        :param changes_file_directory: Directory path of the upload
            control file.
        :param changes_file_name: Filename of the upload control file.
        :param config: `ConfigParser` instance for this application.
        :return: The hostname determined for this upload.

        This is based on information from the upload control
        (‘*.changes’) file.

        """
    non_us = 0
    distribution = ""
    dist_re = re.compile(r'^Distribution: (.*)')

    changes_file_path = os.path.join(changes_file_directory, changes_file_name)

    try:
        changes_file = open(changes_file_path, 'r')
    except IOError:
        sys.stdout.write("Can't open %s\n" % changes_file_path)
        sys.exit(1)
    lines = changes_file.readlines()
    for line in lines:
        match = dist_re.search(line)
        if match:
            distribution = match.group(1)

    # Try to guess a host based on the Distribution: field
    if distribution:
        for section in config.sections():
            host_dists = config.get(section, 'distributions')
            if not host_dists:
                continue
            for host_dist in host_dists.split(','):
                if distribution == host_dist.strip():
                    if debug:
                        sys.stdout.write(
                                "D: guessing host %s"
                                " based on distribution %s\n"
                                % (section, host_dist))
                    return section

    if len(config.get('DEFAULT', 'default_host_main')) != 0:
        sys.stdout.write(
                "Trying to upload package to %s\n"
                % config.get('DEFAULT', 'default_host_main'))
        return config.get('DEFAULT', 'default_host_main')
    else:
        sys.stdout.write(
                "Trying to upload package to ftp-master"
                " (ftp.upload.debian.org)\n")
        return "ftp-master"


def dinstall_caller(filename, host, fqdn, login, incoming, debug):
    """ Run ‘dinstall’ for the package on the remote host.

        :param filename: Debian package filename to install.
        :param host: Configuration host name.
        :param fqdn: Fully-qualified domain name of the remote host.
        :param login: Username for login to the remote host.
        :param incoming: Filesystem path on remote host for incoming
            packages.
        :param debug: If true, enable debugging output.
        :return: ``None``.

        Run ‘dinstall’ on the remote host in test mode, and present
        the output to the user.

        This is so the user can see if the package would be installed
        or not.

        """
    command = [
            'ssh', '%s@%s' % (login, fqdn),
            'cd', '%s' % incoming,
            ';', 'dinstall', '-n', '%s' % filename]
    if debug:
        sys.stdout.write(
                "D: Logging into %s@%s:%s\n" % (login, host, incoming))
        sys.stdout.write("D: dinstall -n %s\n" % filename)
    if dputhelper.check_call(command) != dputhelper.EXIT_STATUS_SUCCESS:
        sys.stdout.write(
                "Error occured while trying to connect, or while"
                " attempting to run dinstall.\n")
        sys.exit(1)


def version_check(path, changes, debug):
    """ Check if the caller has installed the package also on his system.

        This is for testing purposes before uploading it. If not, we
        reject the upload.

        """
    packages_to_check = []

    # Get arch
    dpkg_proc = subprocess.Popen(
            'dpkg --print-architecture',
            stdout=subprocess.PIPE, stderr=subprocess.PIPE,
            shell=True, close_fds=True)
    dpkg_stdout = dputhelper.make_text_stream(dpkg_proc.stdout)
    dpkg_stderr = dputhelper.make_text_stream(dpkg_proc.stderr)
    dpkg_output = dpkg_stdout.read()
    dpkg_architecture = dpkg_output.strip()
    dpkg_stdout.close()
    dpkg_stderr_output = dpkg_stderr.read()
    dpkg_stderr.close()
    if debug and dpkg_stderr_output:
        sys.stdout.write(
                "D: dpkg-architecture stderr output:"
                " %r\n" % dpkg_stderr_output)
    if debug:
        sys.stdout.write(
                "D: detected architecture: '%s'\n" % dpkg_architecture)

    # Get filenames of deb files:
    for file_spec in changes['files'].strip().split('\n'):
        file_name = os.path.join(path, file_spec.split()[4])
        if file_name.endswith('.deb'):
            if debug:
                sys.stdout.write("D: Debian Package: %s\n" % file_name)
            dpkg_proc = subprocess.Popen(
                    'dpkg --field %s' % file_name,
                    stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                    shell=True, close_fds=True)
            dpkg_stdout = dputhelper.make_text_stream(dpkg_proc.stdout)
            dpkg_stderr = dputhelper.make_text_stream(dpkg_proc.stderr)
            dpkg_output = dpkg_stdout.read()
            dpkg_stdout.close()
            dpkg_fields = email.parser.HeaderParser().parsestr(dpkg_output)
            dpkg_stderr_output = dpkg_stderr.read()
            dpkg_stderr.close()
            if debug and dpkg_stderr_output:
                sys.stdout.write(
                        "D: dpkg stderr output:"
                        " %r\n" % dpkg_stderr_output)
            if (
                    dpkg_architecture
                    and dpkg_fields['architecture'] not in [
                        'all', dpkg_architecture]):
                if debug:
                    sys.stdout.write(
                            "D: not install-checking %s due to arch mismatch\n"
                            % file_name)
            else:
                package_name = dpkg_fields['package']
                version_number = dpkg_fields['version']
                if debug:
                    sys.stdout.write(
                            "D: Package to Check: %s\n" % package_name)
                if debug:
                    sys.stdout.write(
                            "D: Version to Check: %s\n" % version_number)
                packages_to_check.append((package_name, version_number))

    for package_name, version_to_check in packages_to_check:
        if debug:
            sys.stdout.write("D: Name of Package: %s\n" % package_name)
        dpkg_proc = subprocess.Popen(
                'dpkg -s %s' % package_name,
                stdout=subprocess.PIPE, stderr=subprocess.PIPE,
                shell=True, close_fds=True)
        dpkg_stdout = dputhelper.make_text_stream(dpkg_proc.stdout)
        dpkg_stderr = dputhelper.make_text_stream(dpkg_proc.stderr)
        dpkg_output = dpkg_stdout.read()
        dpkg_stdout.close()
        dpkg_fields = email.parser.HeaderParser().parsestr(dpkg_output)
        dpkg_stderr_output = dpkg_stderr.read()
        dpkg_stderr.close()
        if debug and dpkg_stderr_output:
            sys.stdout.write(
                    "D: dpkg stderr output:"
                    " %r\n" % dpkg_stderr_output)
        if 'version' in dpkg_fields:
            installed_version = dpkg_fields['version']
            if debug:
                sys.stdout.write(
                        "D: Installed-Version: %s\n" % installed_version)
            if debug:
                sys.stdout.write(
                        "D: Check-Version: %s\n" % version_to_check)
            if installed_version != version_to_check:
                sys.stdout.write(
                        "Package to upload is not installed, but it appears"
                        " you have an older version installed.\n")
        else:
            sys.stdout.write(
                    "Uninstalled Package. Test it before uploading it.\n")
            sys.exit(1)


def execute_command(command, position, debug=False):
    """ Run a command that the user-defined in the config_file.

        :param command: Command line to execute.
        :param position: Position of the command: 'pre' or 'post'.
        :param debug: If true, enable debugging output.
        :return: ``None``.

        """
    if debug:
        sys.stdout.write("D: Command: %s\n" % command)
    if subprocess.call(command, shell=True):
        raise dputhelper.DputUploadFatalException(
                "Error: %s upload command failed." % position)


def check_upload_logfile(
        changes_file_path, host, fqdn,
        check_only, run_lintian, force_upload, debug):
    """ Check if the user already put this package on the specified host.

        :param changes_file_path: Filesystem path of upload control file.
        :param host: Configuration host name.
        :param fqdn: Fully-qualified domain name of the remote host.
        :param check_only: If true, no upload is requested.
        :param run_lintian: If true, a Lintian invocation is requested.
        :param force_upload: If true, don't check the upload log file.
        :param debug: If true, enable debugging output.
        :return: ``None``.

        """
    uploaded = 0
    upload_logfile_path = changes_file_path[:-8] + '.' + host + '.upload'
    if not check_only and not force_upload:
        if not os.path.exists(upload_logfile_path):
            return
        try:
            upload_logfile = open(upload_logfile_path)
        except IOError:
            sys.stdout.write("Couldn't open %s\n" % upload_logfile_path)
            sys.exit(1)
        for line in upload_logfile.readlines():
            if line.find(fqdn) != -1:
                uploaded = 1
        if uploaded:
            sys.stdout.write(
                    "Package has already been uploaded to %s on %s\n"
                    % (host, fqdn))
            sys.stdout.write("Nothing more to do for %s\n" % changes_file_path)
            sys.exit(0)


def make_usage_message():
    """ Make the program usage help message. """
    text = textwrap.dedent("""\
        Usage: dput [options] [host] <package(s).changes>
         Supported options (see man page for long forms):
           -c: Config file to parse.
           -d: Enable debug messages.
           -D: Run dinstall after upload.
           -e: Upload to a delayed queue. Takes an argument from 0 to 15.
           -f: Force an upload.
           -h: Display this help message.
           -H: Display a list of hosts from the config file.
           -l: Run lintian before upload.
           -U: Do not write a .upload file after uploading.
           -o: Only check the package.
           -p: Print the configuration.
           -P: Use passive mode for ftp uploads.
           -s: Simulate the upload only.
           -u: Don't check GnuPG signature.
           -v: Display version information.
           -V: Check the package version and then upload it.
        """)
    return text


def parse_commandline(argv):
    """
    Parse the command-line arguments to option values.

    :param argv: The command-line arguments, as a sequence of text
        strings.
    :return: A 2-tuple (`options`, `args`), where `options` is the
        collection of option values; `args` is the remaining arguments
        after removing all options.

    The `options` collection is a `SimpleNamespace` instance, with
    each value represented as a named attribute.
    """
    global debug

    options = types.SimpleNamespace()
    for (name, value) in parse_commandline.options_defaults.items():
        setattr(options, name, value)

    progname = dputhelper.get_progname(argv)
    version = dputhelper.get_distribution_version()

    # Parse Command Line Options.
    try:
        (opts, args) = dputhelper.getopt(
                argv[1:],
                'c:dDe:fhHlUopPsuvV', [
                    'debug', 'dinstall', 'check-only',
                    'check-version', 'config=', 'force', 'help',
                    'host-list', 'lintian', 'no-upload-log',
                    'passive', 'print', 'simulate', 'unchecked',
                    'delayed=', 'version'])
    except dputhelper.DputException as exc:
        sys.stderr.write(str(exc) + "\n")
        sys.exit(os.EX_USAGE)

    for option, arg in opts:
        if option in ('-h', '--help'):
            sys.stdout.write(make_usage_message())
            sys.exit(os.EX_OK)
        elif option in ('-v', '--version'):
            sys.stdout.write("{progname} {version}\n".format(
                    progname=progname, version=version))
            sys.exit(os.EX_OK)
        elif option in ('-d', '--debug'):
            debug = True
            options.debug = True
        elif option in ('-D', '--dinstall'):
            options.run_dinstall = True
        elif option in ('-c', '--config'):
            options.config_file_path = arg
        elif option in ('-f', '--force'):
            options.force_upload = True
        elif option in ('-H', '--host-list'):
            options.config_host_list = True
        elif option in ('-l', '--lintian'):
            options.run_lintian = True
        elif option in ('-U', '--no-upload-log'):
            options.upload_log = False
        elif option in ('-o', '--check-only'):
            options.check_only = True
        elif option in ('-p', '--print'):
            options.config_print = True
        elif option in ('-P', '--passive'):
            options.ftp_passive_mode = True
        elif option in ('-s', '--simulate'):
            options.simulate = True
        elif option in ('-u', '--unchecked'):
            options.allow_unsigned_uploads = True
        elif option in ('-e', '--delayed'):
            if arg in map(str, range(16)):
                options.delay_upload = arg
            else:
                sys.stdout.write(
                        "Incorrect delayed argument,"
                        " dput only understands 0 to 15.\n")
                sys.exit(os.EX_USAGE)
        elif option in ('-V', '--check_version'):
            options.check_version = True

    if len(args) == 0:
        sys.stdout.write(
                "No package or host has been provided, see dput -h\n")
        sys.exit(os.EX_USAGE)

    return (options, args)


parse_commandline.options_defaults = {
    'debug': debug,
    'check_version': False,
    'config_print': False,
    'force_upload': False,
    'run_lintian': False,
    'config_host_list': False,
    'ftp_passive_mode': False,
    'preferred_host': "",
    'config_file_path': "",
    'run_dinstall': False,
    'upload_log': True,
    'check_only': False,
    'allow_unsigned_uploads': False,
    'delay_upload': None,
    'simulate': False,
}


def main():
    """ Mainline function for this program. """

    progname = dputhelper.get_progname()
    version = dputhelper.get_distribution_version()

    # Emit the program version in the debug output.
    if debug:
        sys.stdout.write(
                "D: {progname} {version}\n".format(
                    progname=progname, version=version))

    try:
        (options, args) = parse_commandline(sys.argv)
    except SystemExit as exc:
        return exc.code

    # Try to get the login from the enviroment
    if 'USER' in os.environ:
        login = os.environ['USER']
        if options.debug:
            sys.stdout.write("D: Login: %s\n" % login)
    else:
        sys.stdout.write("$USER not set, will use login information.\n")
        # Else use the current username
        login = pwd.getpwuid(os.getuid())[0]
        if options.debug:
            sys.stdout.write("D: User-ID: %s\n" % os.getuid())
            sys.stdout.write("D: Login: %s\n" % login)

    # Start Config File Parsing.
    config = read_configs(options.config_file_path, options.debug)

    if options.config_print:
        print_config(config, options.debug)
        sys.exit(os.EX_OK)

    if options.config_host_list:
        sys.stdout.write(
                "\n"
                "Default Method: %s\n"
                "\n" % config.get('DEFAULT', 'method'))
        for section in config.sections():
            distributions = ""
            if config.get(section, 'distributions'):
                distributions = (
                        ", distributions: %s" %
                        config.get(section, 'distributions'))
            sys.stdout.write(
                    "%s => %s  (Upload method: %s%s)\n" % (
                        section,
                        config.get(section, 'fqdn'),
                        config.get(section, 'method'),
                        distributions))
        sys.stdout.write("\n")
        sys.exit(os.EX_OK)

    # Process further command line options.
    if len(args) == 1 and not options.check_only:
        changes_file_paths = args[0:]
    else:
        if ':' in args[0]:
            sys.stdout.write("D: Splitting host argument out of  %s.\n" % args[0])
            args[0], host_argument = args[0].split(":", 1)
        else:
            host_argument = ""

        if config.has_section(args[0]):
            sys.stdout.write("D: Setting host argument.\n")
            config.set(args[0], args[0], host_argument)
        else:
            # Let the code below handle this as it is sometimes okay (ie. -o)
            pass

        if not options.check_only:
            if options.debug:
                sys.stdout.write(
                        "D: Checking if a host was named"
                        " on the command line.\n")
            if config.has_section(args[0]):
                if options.debug:
                    sys.stdout.write("D: Host %s found in config.\n" % args[0])
                # Host was also named, so only the rest will be a list
                # of packages to upload.
                options.preferred_host = args[0]
                changes_file_paths = args[1:]
            elif (
                    not config.has_section(args[0])
                    and not args[0].endswith('.changes')):
                sys.stderr.write("No host %s found in config.\n" % args[0])
                sys.exit(1)
            else:
                if options.debug:
                    sys.stdout.write("D: No host named on command line.\n")
                # Only packages have been named on the command line.
                options.preferred_host = ""
                changes_file_paths = args[0:]
        else:
            if options.debug:
                sys.stdout.write("D: Checking for the package name.\n")
            if config.has_section(args[0]):
                sys.stdout.write("D: Host %s found in config.\n" % args[0])
                options.preferred_host = args[0]
                changes_file_paths = args[1:]
            elif len(args) > 1:
                sys.stderr.write("No host %s found in config.\n" % args[0])
                if options.debug:
                    sys.stdout.write("D: No host named on command line.\n")
                changes_file_paths = args[1:]
            else:
                sys.stderr.write("No host %s found in config.\n" % args[0])
                if options.debug:
                    sys.stdout.write("D: No host named on command line.\n")
                changes_file_paths = args[0:]

    upload_methods = import_upload_functions()

    # Run the same checks for all packages that have been given on
    # the command line
    for changes_file_path in changes_file_paths:
        # Check that a .changes file was given on the command line
        # and no matching .upload file exists.
        if changes_file_path[-8:] != '.changes':
            sys.stdout.write(
                    "Not a .changes file.\n"
                    "Please select a .changes file to upload.\n")
            sys.stdout.write("Tried to upload: %s\n" % changes_file_path)
            sys.exit(1)

        # Construct the package name for further usage.
        changes_file_directory, changes_file_name = os.path.split(
                changes_file_path)
        if changes_file_directory == '':
            changes_file_directory = os.getcwd()

        # Define the host to upload to.
        if options.preferred_host:
            host = options.preferred_host
        else:
            host = guess_upload_host(
                    changes_file_directory, changes_file_name, config)
        if config.get(host, 'method') == 'local':
            fqdn = 'localhost'
        else:
            fqdn = config.get(host, 'fqdn')

        if not config.has_section(host):
            sys.stdout.write("E: No host %s found in config" % host)
            sys.exit(1)

        # Check if we already did this upload or not.
        check_upload_logfile(
                changes_file_path, host, fqdn,
                options.check_only,
                options.run_lintian,
                options.force_upload,
                options.debug)

        # Run the change file tests.
        files_to_upload = verify_files(
                changes_file_directory, changes_file_name, host,
                config,
                options.check_only,
                options.check_version,
                options.allow_unsigned_uploads,
                options.debug)

        # Run the lintian test if the user asked us to do so.
        if (
                options.run_lintian or
                config.getboolean(host, 'run_lintian') == 1):
            run_lintian_test(
                    os.path.join(changes_file_directory, changes_file_name))
        elif options.check_only:
            sys.stdout.write(
                    "Warning: The option -o does not automatically include \n"
                    "a lintian run any more. Please use the option -ol if \n"
                    "you want to include running lintian in your checking.\n")

        # Don't upload, skip to the next item.
        if options.check_only:
            sys.stdout.write("Package checked by dput.\n")
            continue

        # Pre-Upload Commands
        if len(config.get(host, 'pre_upload_command')) != 0:
            position = 'pre'
            command = config.get(host, 'pre_upload_command')
            execute_command(command, position, options.debug)

        # Check the upload methods that we have as default and per host
        if options.debug:
            sys.stdout.write(
                    "D: Default Method: %s\n"
                    % config.get('DEFAULT', 'method'))
        if config.get('DEFAULT', 'method') not in upload_methods:
            sys.stdout.write(
                    "Unknown upload method: %s\n"
                    % config.get('DEFAULT', 'method'))
            sys.exit(1)
        if options.debug:
            sys.stdout.write(
                    "D: Host Method: %s\n" % config.get(host, 'method'))
        if config.get(host, 'method') not in upload_methods:
            sys.stdout.write(
                    "Unknown upload method: %s\n"
                    % config.get(host, 'method'))
            sys.exit(1)

        # Inspect the Config and set appropriate upload method
        if not config.get(host, 'method'):
            method = config.get('DEFAULT', 'method')
        else:
            method = config.get(host, 'method')

        # Check now the login and redefine it if needed
        if (
                len(config.get(host, 'login')) != 0 and
                config.get(host, 'login') != 'username'):
            login = config.get(host, 'login')
            if options.debug:
                sys.stdout.write(
                        "D: Login %s from section %s used\n" % (login, host))
        elif (
                len(config.get('DEFAULT', 'login')) != 0 and
                config.get('DEFAULT', 'login') != 'username'):
            login = config.get('DEFAULT', 'login')
            if options.debug:
                sys.stdout.write("D: Default login %s used\n" % login)
        else:
            if options.debug:
                sys.stdout.write(
                        "D: Neither host %s nor default login used. Using %s\n"
                        % (host, login))

        incoming = config.get(host, 'incoming')

        if options.delay_upload is None:
            # Command-line ‘--delayed’ option was not specified.
            options.delay_upload = config.get(host, 'delayed')
            if not options.delay_upload:
                options.delay_upload = config.get('DEFAULT', 'delayed')

        if options.delay_upload:
            if int(options.delay_upload) == 0:
                sys.stdout.write("Uploading to DELAYED/0-day.\n")
            if incoming[-1] == '/':
                first_char = ''
            else:
                first_char = '/'
            incoming += first_char + 'DELAYED/' + options.delay_upload + '-day'
            delayed = ' [DELAYED/' + options.delay_upload + ']'
        else:
            delayed = ''

        # Do the actual upload
        if not options.simulate:
            sys.stdout.write(
                    "Uploading to %s%s (via %s to %s):\n"
                    % (host, delayed, method, fqdn))
            if options.debug:
                sys.stdout.write("D: FQDN: %s\n" % fqdn)
                sys.stdout.write("D: Login: %s\n" % login)
                sys.stdout.write("D: Incoming: %s\n" % incoming)
            progress = config.getint(host, 'progress_indicator')
            if not os.isatty(1):
                progress = 0
            if method == 'ftp':
                if ':' in fqdn:
                    fqdn, port_text = fqdn.rsplit(":", 1)
                    port = int(port_text)
                else:
                    port = 21
                ftp_mode = config.getboolean(host, 'passive_ftp')
                if options.ftp_passive_mode:
                    ftp_mode = 1
                if options.debug:
                    sys.stdout.write("D: FTP port: %s\n" % port)
                    if ftp_mode == 1:
                        sys.stdout.write("D: Using passive ftp\n")
                    else:
                        sys.stdout.write("D: Using active ftp\n")
                upload_methods[method](
                        fqdn, login, incoming,
                        files_to_upload, options.debug, ftp_mode,
                        progress=progress, port=port)
            elif method == 'scp':
                if options.debug and config.getboolean(host, 'scp_compress'):
                    sys.stdout.write("D: Setting compression for scp\n")
                scp_compress = config.getboolean(host, 'scp_compress')
                ssh_config_options = [
                        y for y in (
                            x.strip() for x in
                            config.get(host, 'ssh_config_options').split('\n'))
                        if y]
                if options.debug:
                    sys.stdout.write(
                            "D: ssh config options:"
                            "\n  "
                            + "\n  ".join(ssh_config_options)
                            + "\n")
                upload_methods[method](
                        fqdn, login, incoming,
                        files_to_upload, options.debug, scp_compress,
                        ssh_config_options)
            else:
                upload_methods[method](
                        fqdn, login, incoming,
                        files_to_upload, options.debug, 0, progress=progress)
        # Or just simulate it.
        else:
            for file_path in files_to_upload:
                sys.stdout.write(
                        "Uploading with %s: %s to %s:%s\n"
                        % (method, file_path, fqdn, incoming))

        # Create the logfile after the package has
        # been put into the archive.
        if not options.simulate:
            if options.upload_log:
                create_upload_file(
                        changes_file_name, host, fqdn, changes_file_directory,
                        files_to_upload, options.debug)
            sys.stdout.write("Successfully uploaded packages.\n")
        else:
            sys.stdout.write("Simulated upload.\n")

        # Run dinstall if the user asked us to do so.
        if options.debug:
            sys.stdout.write("D: run_dinstall: %s\n" % options.run_dinstall)
            sys.stdout.write(
                    "D: Host Config: %s\n"
                    % config.getboolean(host, 'run_dinstall'))
        if (
                config.getboolean(host, 'run_dinstall') == 1
                or options.run_dinstall):
            if not options.simulate:
                dinstall_caller(
                        changes_file_name, host, fqdn, login, incoming,
                        options.debug)
            else:
                sys.stdout.write("Will run dinstall now.\n")

        # Post-Upload Command
        if len(config.get(host, 'post_upload_command')) != 0:
            position = 'post'
            command = config.get(host, 'post_upload_command')
            execute_command(command, position, options.debug)

    return


# Copyright © 2015–2021 Ben Finney <bignose@debian.org>
# Copyright © 2008–2013 Y Giridhar Appaji Nag <appaji@debian.org>
# Copyright © 2006–2008 Thomas Viehmann <tv@beamnet.de>
# Copyright © 2000–2005 Christian Kurz <shorty@debian.org>
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
