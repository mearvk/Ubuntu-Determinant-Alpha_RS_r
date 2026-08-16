# test/test_dcut.py
# Part of ‘dput’, a Debian package upload toolkit.
#
# This is free software, and you are welcome to redistribute it under
# certain conditions; see the end of this file for copyright
# information, grant of license, and disclaimer of warranty.

""" Unit tests for ‘dcut’ module. """

import doctest
import io
import itertools
import os
import shutil
import subprocess
import sys
import tempfile
import textwrap
import unittest.mock

import pkg_resources
import testscenarios
import testtools

import dput.dcut
from dput.helper import dputhelper

from . import test_dput_main
from .helper import (
        ARG_ANY,
        ARG_MORE,
        EXIT_STATUS_FAILURE,
        EXIT_STATUS_SUCCESS,
        FakeSystemExit,
        FileDouble,
        PasswdEntry,
        SubprocessDouble,
        patch_os_environ,
        patch_os_getpid,
        patch_os_getuid,
        patch_os_rmdir,
        patch_os_unlink,
        patch_pwd_getpwuid,
        patch_shutil_rmtree,
        patch_subprocess_call,
        patch_subprocess_check_call,
        patch_subprocess_popen,
        patch_sys_argv,
        patch_system_interfaces,
        patch_tempfile_mkdtemp,
        patch_time_time,
        setup_file_double_behaviour,
        setup_subprocess_double_behaviour,
        )
from .test_changesfile import (
        make_changes_file_scenarios,
        set_changes_file_scenario,
        )
from .test_configfile import (
        set_config,
        )
from .test_dputhelper import (
        patch_getopt,
        patch_pkg_resources_get_distribution,
        )


dummy_pwent = PasswdEntry(
        pw_name="lorem",
        pw_passwd="!",
        pw_uid=1,
        pw_gid=1,
        pw_gecos="Lorem Ipsum,spam,eggs,beans",
        pw_dir=tempfile.mktemp(),
        pw_shell=tempfile.mktemp())


def patch_getoptions(testcase):
    """ Patch the `getoptions` function for this test case. """
    default_options = {
            'debug': False,
            'simulate': False,
            'config': None,
            'host': "foo",
            'passive': False,
            'changes': None,
            'filetoupload': None,
            'filetocreate': None,
            }

    if not hasattr(testcase, 'getoptions_opts'):
        testcase.getoptions_opts = {}
    if not hasattr(testcase, 'getoptions_args'):
        testcase.getoptions_args = []

    def fake_getoptions():
        options = dict(default_options)
        options.update(testcase.getoptions_opts)
        arguments = list(testcase.getoptions_args)
        result = (options, arguments)
        return result

    func_patcher = unittest.mock.patch.object(
            dput.dcut, "getoptions", autospec=True,
            side_effect=fake_getoptions)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


def get_upload_method_func(testcase):
    """ Get the specified upload method. """
    host = testcase.test_host
    method_name = testcase.runtime_config_parser.get(host, 'method')
    method_func = testcase.upload_methods[method_name]
    return method_func


class make_usage_message_TestCase(testtools.TestCase):
    """ Test cases for `make_usage_message` function. """

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()

        patch_sys_argv(self)

    def test_returns_text_with_program_name(self):
        """ Should return text with expected program name. """
        result = dput.dcut.make_usage_message()
        expected_result = textwrap.dedent("""\
                Usage: {progname} ...
                ...
                """).format(progname=self.progname)
        self.expectThat(
                result,
                testtools.matchers.DocTestMatches(
                    expected_result, flags=doctest.ELLIPSIS))


class getoptions_TestCase(testtools.TestCase):
    """ Base for test cases for `getoptions` function. """

    default_options = NotImplemented

    scenarios = NotImplemented

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()
        patch_system_interfaces(self)

        patch_os_environ(self)
        patch_os_getuid(self)
        patch_pwd_getpwuid(self)
        patch_sys_argv(self)

        self.patch_etc_mailname()
        setup_file_double_behaviour(
                self, [self.mailname_file_double])

        self.set_hostname_subprocess_double()
        patch_subprocess_popen(self)

        self.patch_getopt()
        if hasattr(self, 'expected_options'):
            self.set_expected_result()

        self.patch_distribution()
        self.patch_make_usage_message()

    def patch_etc_mailname(self):
        """ Patch the ‘/etc/mailname’ file. """
        path = "/etc/mailname"
        if hasattr(self, 'mailname_fake_file'):
            double = FileDouble(path, self.mailname_fake_file)
        else:
            double = FileDouble(path, io.StringIO())
        if hasattr(self, 'mailname_file_open_scenario_name'):
            double.set_open_scenario(self.mailname_file_open_scenario_name)
        self.mailname_file_double = double

    def set_hostname_subprocess_double(self):
        """ Set the test double for the ‘hostname’ subprocess. """
        path = "/bin/hostname"
        argv = (path, "--fqdn")
        double = SubprocessDouble(path, argv=argv)
        double.register_for_testcase(self)

        double.set_subprocess_popen_scenario('success')
        double.set_stdout_content(getattr(self, 'hostname_stdout_content', ""))

        self.hostname_subprocess_double = double

    def patch_getopt(self):
        """ Patch the `dputhelper.getopt` function. """
        if not hasattr(self, 'getopt_opts'):
            self.getopt_opts = []
        else:
            self.getopt_opts = list(self.getopt_opts)
        if not hasattr(self, 'getopt_args'):
            self.getopt_args = []
        else:
            self.getopt_args = list(self.getopt_args)

        patch_getopt(self)

    def set_expected_result(self):
        """ Set the expected result value. """
        if not hasattr(self, 'expected_arguments'):
            self.expected_arguments = []
        expected_options = self.default_options.copy()
        expected_options.update(self.expected_options)
        self.expected_result = (expected_options, self.expected_arguments)

    def patch_distribution(self):
        """ Patch the Python distribution for this test case. """
        self.fake_distribution = unittest.mock.MagicMock(
                pkg_resources.Distribution)
        if hasattr(self, 'dcut_version'):
            self.fake_distribution.version = self.dcut_version
        patch_pkg_resources_get_distribution(self)

    def patch_make_usage_message(self):
        """ Patch the `make_usage_message` function. """
        if hasattr(self, 'dcut_usage_message'):
            text = self.dcut_usage_message
        else:
            text = self.getUniqueString()
        func_patcher = unittest.mock.patch.object(
                dput.dcut, "make_usage_message", autospec=True,
                return_value=text)
        func_patcher.start()
        self.addCleanup(func_patcher.stop)


class getoptions_UploaderTestCase(
        testscenarios.WithScenarios,
        getoptions_TestCase):
    """ Test cases for `getoptions` function, determining uploader. """

    environ_scenarios = [
            ('environ-none', {
                'os_environ': {},
                }),
            ('environ-email-not-delimited', {
                'os_environ': {'EMAIL': "quux@example.org"},
                'expected_environ_uploader': "<quux@example.org>",
                }),
            ('environ-email-delimited', {
                'os_environ': {'EMAIL': "<quux@example.org>"},
                'expected_environ_uploader': "<quux@example.org>",
                }),
            ('environ-debemail-not-delimited', {
                'os_environ': {'DEBEMAIL': "flup@example.org"},
                'expected_environ_uploader': "<flup@example.org>",
                }),
            ('environ-debemail-delimited', {
                'os_environ': {'DEBEMAIL': "<flup@example.org>"},
                'expected_environ_uploader': "<flup@example.org>",
                }),
            ('environ-both-email-and-debfullname', {
                'os_environ': {
                    'EMAIL': "quux@example.org",
                    'DEBFULLNAME': "Lorem Ipsum",
                    },
                'expected_environ_uploader': "Lorem Ipsum <quux@example.org>",
                }),
            ('environ-both-debemail-and-debfullname', {
                'os_environ': {
                    'DEBEMAIL': "flup@example.org",
                    'DEBFULLNAME': "Lorem Ipsum",
                    },
                'expected_environ_uploader': "Lorem Ipsum <flup@example.org>",
                }),
            ('environ-both-email-and-debemail', {
                'os_environ': {
                    'EMAIL': "quux@example.org",
                    'DEBEMAIL': "flup@example.org",
                    },
                'expected_environ_uploader': "<flup@example.org>",
                }),
            ('environ-both-email-and-debemail-and-debfullname', {
                'os_environ': {
                    'EMAIL': "quux@example.org",
                    'DEBEMAIL': "flup@example.org",
                    'DEBFULLNAME': "Lorem Ipsum",
                    },
                'expected_environ_uploader': "Lorem Ipsum <flup@example.org>",
                }),
            ]

    system_scenarios = [
            ('domain-from-mailname-file', {
                'mailname_fake_file': io.StringIO("consecteur.example.org"),
                'pwd_getpwuid_return_value': dummy_pwent._replace(
                        pw_name="grue",
                        pw_gecos="Dolor Sit Amet,spam,beans,eggs"),
                'expected_debug_chatter': textwrap.dedent("""\
                        D: Guessing uploader
                        """),
                'expected_system_uploader':
                    "Dolor Sit Amet <grue@consecteur.example.org>",
                }),
            ('domain-from-hostname-command', {
                'mailname_file_open_scenario_name': "read_denied",
                'hostname_stdout_content': "consecteur.example.org\n",
                'pwd_getpwuid_return_value': dummy_pwent._replace(
                        pw_name="grue",
                        pw_gecos="Dolor Sit Amet,spam,beans,eggs"),
                'expected_debug_chatter': textwrap.dedent("""\
                        D: Guessing uploader
                        D: Guessing uploader: /etc/mailname was a failure
                        """),
                'expected_system_uploader':
                    "Dolor Sit Amet <grue@consecteur.example.org>",
                }),
            ('domain-failure', {
                'mailname_file_open_scenario_name': "read_denied",
                'hostname_stdout_content': "",
                'pwd_getpwuid_return_value': dummy_pwent._replace(
                        pw_name="grue",
                        pw_gecos="Dolor Sit Amet,spam,beans,eggs"),
                'expected_debug_chatter': textwrap.dedent("""\
                        D: Guessing uploader
                        D: Guessing uploader: /etc/mailname was a failure
                        D: Couldn't guess uploader
                        """),
                }),
            ]

    scenarios = testscenarios.multiply_scenarios(
            environ_scenarios, system_scenarios)

    def setUp(self, *args, **kwargs):
        """ Set up test fixtures. """
        super().setUp(*args, **kwargs)

        self.set_expected_uploader()

    def set_expected_uploader(self):
        """ Set the expected uploader value for this test case. """
        for attrib_name in [
                'expected_command_line_uploader',
                'expected_environ_uploader',
                'expected_system_uploader']:
            if hasattr(self, attrib_name):
                self.expected_uploader = getattr(self, attrib_name)
                break

    def test_emits_debug_message_for_uploader_discovery(self):
        """ Should emit debug message for uploader discovery. """
        sys.argv.insert(1, "--debug")
        dput.dcut.getoptions()
        expected_output_lines = [
                "D: trying to get maintainer email from environment"]
        if hasattr(self, 'expected_environ_uploader'):
            guess_line_template = "D: Uploader from env: {uploader}"
        else:
            expected_output_lines.extend(
                self.expected_debug_chatter.split("\n")[:-1])
            if hasattr(self, 'expected_system_uploader'):
                guess_line_template = "D: Guessed uploader: {uploader}"
        if hasattr(self, 'expected_uploader'):
            expected_output_lines.append(guess_line_template.format(
                    uploader=self.expected_uploader))
        expected_output = "\n".join(expected_output_lines)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_emits_no_debug_message_for_uploader_discovery(self):
        """ Should emit no debug message for uploader discovery. """
        if "--debug" in sys.argv:
            sys.argv.remove("--debug")
        dput.dcut.getoptions()
        expected_output_lines = []
        expected_output = "\n".join(expected_output_lines)
        self.assertEqual(expected_output, sys.stdout.getvalue())


class getoptions_ParseCommandLineTestCase(
        testscenarios.WithScenarios,
        getoptions_TestCase):
    """ Test cases for `getoptions` function, parsing command line. """

    dcut_usage_message = "Lorem ipsum, dolor sit amet."

    progname = "lorem"
    dcut_version = "ipsum"

    config_file_path = tempfile.mktemp()
    changes_file_path = tempfile.mktemp()
    output_file_path = tempfile.mktemp()
    upload_file_path = tempfile.mktemp()

    default_options = dict()
    default_options.update(
            (key, None) for key in [
                'config', 'host', 'uploader', 'keyid',
                'filetocreate', 'filetoupload', 'changes'])
    default_options.update(
            (key, False) for key in ['debug', 'simulate', 'passive'])

    option_scenarios = [
            ('no-options', {
                'getopt_opts': [],
                }),
            ('option-bogus', {
                'getopt_opts': [("--b0gUs", "BOGUS")],
                'expected_stderr_output': (
                    "{progname} internal error:"
                    " Option --b0gUs, argument BOGUS unknown").format(
                        progname=progname),
                'expected_exit_status': EXIT_STATUS_FAILURE,
                }),
            ('option-help', {
                'getopt_opts': [("--help", None)],
                'expected_stdout_output': dcut_usage_message,
                'expected_exit_status': EXIT_STATUS_SUCCESS,
                }),
            ('option-version', {
                'getopt_opts': [("--version", None)],
                'expected_stdout_output': " ".join(
                    [progname, dcut_version]),
                'expected_exit_status': EXIT_STATUS_SUCCESS,
                }),
            ('option-filetoupload-and-environ-uploader', {
                'os_environ': {
                    'DEBEMAIL': "flup@example.org",
                    'DEBFULLNAME': "Lorem Ipsum",
                    },
                'getopt_opts': [
                    ("--upload", upload_file_path),
                    ],
                'expected_options': {
                    'uploader': "Lorem Ipsum <flup@example.org>",
                    'filetoupload': upload_file_path,
                    },
                'expected_arguments': [],
                }),
            ('option-changes-and-environ-uploader', {
                'os_environ': {
                    'DEBEMAIL': "flup@example.org",
                    'DEBFULLNAME': "Lorem Ipsum",
                    },
                'getopt_opts': [
                    ("--input", changes_file_path),
                    ],
                'expected_options': {
                    'uploader': "Lorem Ipsum <flup@example.org>",
                    'changes': changes_file_path,
                    },
                'expected_arguments': [],
                }),
            ('option-filetoupload-and-option-maintaineraddress', {
                'getopt_opts': [
                    ("--upload", upload_file_path),
                    ("--maintaineraddress", "Lorem Ipsum <flup@example.org>"),
                    ],
                'expected_options': {
                    'uploader': "Lorem Ipsum <flup@example.org>",
                    'filetoupload': upload_file_path,
                    },
                'expected_arguments': [],
                }),
            ('option-changes-and-option-maintaineraddress', {
                'getopt_opts': [
                    ("--input", changes_file_path),
                    ("--maintaineraddress", "Lorem Ipsum <flup@example.org>"),
                    ],
                'expected_options': {
                    'uploader': "Lorem Ipsum <flup@example.org>",
                    'changes': changes_file_path,
                    },
                'expected_arguments': [],
                }),
            ('option-filetoupload-with-no-uploader', {
                'getopt_opts': [("--upload", upload_file_path)],
                'expected_stderr_output': "command file cannot be created",
                'expected_exit_status': EXIT_STATUS_FAILURE,
                }),
            ('option-changes-with-no-uploader', {
                'getopt_opts': [("--input", changes_file_path)],
                'expected_stderr_output': "command file cannot be created",
                'expected_exit_status': EXIT_STATUS_FAILURE,
                }),
            ('option-several', {
                'getopt_opts': [
                    ("--debug", None),
                    ("--simulate", None),
                    ("--config", config_file_path),
                    ("--maintaineraddress", "Lorem Ipsum <flup@example.org>"),
                    ("--keyid", "DEADBEEF"),
                    ("--passive", None),
                    ("--output", output_file_path),
                    ("--host", "quux.example.com"),
                    ],
                'expected_options': {
                    'debug': True,
                    'simulate': True,
                    'config': config_file_path,
                    'uploader': "Lorem Ipsum <flup@example.org>",
                    'keyid': "DEADBEEF",
                    'passive': True,
                    'filetocreate': output_file_path,
                    'host': "quux.example.com",
                    },
                'expected_arguments': [],
                }),
            ]

    scenarios = option_scenarios

    def test_emits_debug_message_for_program_version(self):
        """ Should emit debug message for program version. """
        sys.argv.insert(1, "--debug")
        expected_progname = self.progname
        expected_version = self.dcut_version
        try:
            dput.dcut.getoptions()
        except FakeSystemExit:
            pass
        expected_output = textwrap.dedent("""\
                D: {progname} {version}
                """).format(
                    progname=expected_progname,
                    version=expected_version)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_calls_getopt_with_expected_args(self):
        """ Should call `getopt` with expected arguments. """
        try:
            dput.dcut.getoptions()
        except FakeSystemExit:
            pass
        dputhelper.getopt.assert_called_with(
                self.sys_argv[1:], unittest.mock.ANY, unittest.mock.ANY)

    def test_emits_debug_message_for_each_option(self):
        """ Should emit a debug message for each option processed. """
        sys.argv.insert(1, "--debug")
        try:
            dput.dcut.getoptions()
        except FakeSystemExit:
            pass
        expected_output_lines = [
                "D: processing arg \"{opt}\", option \"{arg}\"".format(
                    opt=option, arg=option_argument)
                for (option, option_argument) in self.getopt_args]
        expected_output = "\n".join(expected_output_lines)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_emits_expected_message(self):
        """ Should emit message with expected content. """
        try:
            dput.dcut.getoptions()
        except FakeSystemExit:
            pass
        if hasattr(self, 'expected_stdout_output'):
            self.assertIn(self.expected_stdout_output, sys.stdout.getvalue())
        if hasattr(self, 'expected_stderr_output'):
            self.assertIn(self.expected_stderr_output, sys.stderr.getvalue())

    def test_calls_sys_exit_with_expected_exit_status(self):
        """ Should call `sys.exit` with expected exit status. """
        if not hasattr(self, 'expected_exit_status'):
            dput.dcut.getoptions()
        else:
            with testtools.ExpectedException(FakeSystemExit):
                dput.dcut.getoptions()
            sys.exit.assert_called_with(self.expected_exit_status)

    def test_returns_expected_values(self):
        """ Should return expected values. """
        if not hasattr(self, 'expected_result'):
            self.skipTest("No return result expected")
        result = dput.dcut.getoptions()
        self.assertEqual(self.expected_result, result)


class getoptions_DetermineHostTestCase(
        testscenarios.WithScenarios,
        getoptions_TestCase):
    """ Test cases for `getoptions` function, determine host name. """

    system_scenarios = [
            ('domain-from-mailname-file', {
                'mailname_fake_file': io.StringIO("consecteur.example.org"),
                }),
            ]

    default_options = getattr(
            getoptions_ParseCommandLineTestCase, 'default_options')

    command_scenarios = [
            ('no-opts no-args', {
                'getopt_opts': [],
                'getopt_args': [],
                'expected_options': {
                    'host': None,
                    },
                }),
            ('no-opts command-first-arg', {
                'getopt_opts': [],
                'getopt_args': ["cancel"],
                'expected_options': {
                    'host': None,
                    },
                'expected_arguments': ["cancel"],
                }),
            ('no-opts host-first-arg', {
                'getopt_opts': [],
                'getopt_args': ["quux.example.com", "cancel"],
                'expected_options': {
                    'host': "quux.example.com",
                    },
                'expected_arguments': ["cancel"],
                'expected_debug_output': textwrap.dedent("""\
                    D: first argument "quux.example.com" treated as host
                    """),
                }),
            ('option-host host-first-arg', {
                'getopt_opts': [("--host", "quux.example.com")],
                'getopt_args': ["decoy.example.net", "cancel"],
                'expected_options': {
                    'host': "quux.example.com",
                    },
                'expected_arguments': ["decoy.example.net", "cancel"],
                }),
            ]

    scenarios = testscenarios.multiply_scenarios(
            system_scenarios, command_scenarios)

    def test_emits_expected_debug_message(self):
        """ Should emit the expected debug message. """
        if not hasattr(self, 'expected_debug_output'):
            self.expected_debug_output = ""
        self.getopt_opts = list(
                self.getopt_opts + [("--debug", None)])
        dput.dcut.getoptions()
        self.assertIn(self.expected_debug_output, sys.stdout.getvalue())

    def test_returns_expected_values(self):
        """ Should return expected values. """
        if not hasattr(self, 'expected_result'):
            self.skipTest("No return result expected")
        (options, arguments) = dput.dcut.getoptions()
        self.assertEqual(self.expected_options['host'], options['host'])
        self.assertEqual(self.expected_arguments, arguments)


class parse_queuecommands_TestCase(testtools.TestCase):
    """ Base for test cases for `parse_queuecommands` function. """

    scenarios = NotImplemented

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()
        patch_system_interfaces(self)

        self.set_test_args()

    def set_test_args(self):
        """ Set the arguments for the test call to the function. """
        default_options = {
                'debug': False,
                }
        self.test_args = dict(
                arguments=getattr(self, 'arguments', []),
                options=getattr(self, 'options', default_options),
                config=object(),
                )


class parse_queuecommands_SuccessTestCase(
        testscenarios.WithScenarios,
        parse_queuecommands_TestCase):
    """ Success test cases for `parse_queuecommands` function. """

    scenarios = [
            ('one-command-rm', {
                'arguments': ["rm", "lorem.deb"],
                'expected_commands': [
                    "rm --searchdirs lorem.deb",
                    ],
                }),
            ('one-command-rm nosearchdirs', {
                'arguments': ["rm", "--nosearchdirs", "lorem.deb"],
                'expected_commands': [
                    "rm lorem.deb",
                    ],
                }),
            ('one-command-cancel', {
                'arguments': ["cancel", "lorem.deb"],
                'expected_commands': [
                    "cancel lorem.deb",
                    ],
                }),
            ('one-command-cancel nosearchdirs', {
                'arguments': ["cancel", "--nosearchdirs", "lorem.deb"],
                'expected_commands': [
                    "cancel --nosearchdirs lorem.deb",
                    ],
                }),
            ('one-command-reschedule', {
                'arguments': ["reschedule", "lorem.deb"],
                'expected_commands': [
                    "reschedule lorem.deb",
                    ],
                }),
            ('one-command-reschedule nosearchdirs', {
                'arguments': ["reschedule", "--nosearchdirs", "lorem.deb"],
                'expected_commands': [
                    "reschedule --nosearchdirs lorem.deb",
                    ],
                }),
            ('three-commands comma-separated', {
                'arguments': [
                    "rm", "foo", ",",
                    "cancel", "bar", ",",
                    "reschedule", "baz"],
                'expected_commands': [
                    "rm --searchdirs foo ",
                    "cancel bar ",
                    "reschedule baz",
                    ],
                }),
            ('three-commands semicolon-separated', {
                'arguments': [
                    "rm", "foo", ";",
                    "cancel", "bar", ";",
                    "reschedule", "baz"],
                'expected_commands': [
                    "rm --searchdirs foo ",
                    "cancel bar ",
                    "reschedule baz",
                    ],
                }),
            ]

    def test_emits_debug_message_for_each_command(self):
        """ Should emit a debug message for each command. """
        self.test_args['options'] = dict(self.test_args['options'])
        self.test_args['options']['debug'] = True
        dput.dcut.parse_queuecommands(**self.test_args)
        expected_output = "\n".join(
                "D: Successfully parsed command \"{command}\"".format(
                    command=command)
                for command in self.expected_commands)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_returns_expected_commands(self):
        """ Should return expected commands value. """
        result = dput.dcut.parse_queuecommands(**self.test_args)
        self.assertEqual(self.expected_commands, result)


class parse_queuecommands_ErrorTestCase(
        testscenarios.WithScenarios,
        parse_queuecommands_TestCase):
    """ Error test cases for `parse_queuecommands` function. """

    scenarios = [
            ('no-arguments', {
                'arguments': [],
                'expected_debug_output': textwrap.dedent("""\
                        Error: no arguments given, see dcut -h
                        """),
                'expected_exit_status': EXIT_STATUS_FAILURE,
                }),
            ('first-command-bogus', {
                'arguments': ["b0gUs", "spam", "eggs"],
                'expected_debug_output': textwrap.dedent("""\
                        Error: Could not parse commands at "b0gUs"
                        """),
                'expected_exit_status': EXIT_STATUS_FAILURE,
                }),
            ('third-command-bogus', {
                'arguments': ["rm", "foo", ",", "cancel", "bar", ",", "b0gUs"],
                'expected_debug_output': textwrap.dedent("""\
                        Error: Could not parse commands at "b0gUs"
                        """),
                'expected_exit_status': EXIT_STATUS_FAILURE,
                }),
            ]

    def test_emits_expected_error_message(self):
        """ Should emit expected error message. """
        try:
            dput.dcut.parse_queuecommands(**self.test_args)
        except FakeSystemExit:
            pass
        self.assertIn(self.expected_debug_output, sys.stderr.getvalue())

    def test_calls_sys_exit_with_exit_status(self):
        """ Should call `sys.exit` with expected exit status. """
        with testtools.ExpectedException(FakeSystemExit):
            dput.dcut.parse_queuecommands(**self.test_args)
        sys.exit.assert_called_with(self.expected_exit_status)


class create_commands_TestCase(
        testtools.TestCase):
    """ Test cases for `create_commands` function. """

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()
        patch_system_interfaces(self)

        self.changes_file_scenarios = make_changes_file_scenarios()
        set_changes_file_scenario(self, 'no-format')
        setup_file_double_behaviour(self)

        self.set_expected_commands()

        self.set_options()

        test_dput_main.patch_parse_changes(self)
        dput.dput.parse_changes.return_value = self.changes_file_scenario[
                'expected_result']

        self.set_test_args()

    def set_options(self):
        """ Set the options mapping to pass to the function. """
        self.options = {
                'debug': False,
                'changes': self.changes_file_double.path,
                }

    def set_test_args(self):
        """ Set the arguments for the test call to the function. """
        self.test_args = dict(
                options=dict(self.options),
                config=object(),
                parse_changes=dput.dput.parse_changes,
                )

    def set_expected_commands(self):
        """ Set the expected commands for this test case. """
        files_to_remove = [os.path.basename(self.changes_file_double.path)]
        files_from_changes = self.changes_file_scenario[
                'expected_result']['files']
        for line in files_from_changes.split("\n"):
            files_to_remove.append(line.split(" ")[4])
        self.expected_commands = [
                "rm --searchdirs {path}".format(path=path)
                for path in files_to_remove]

    def test_emits_debug_message_for_changes_file(self):
        """ Should emit debug message for changes file. """
        self.options['debug'] = True
        self.set_test_args()
        dput.dcut.create_commands(**self.test_args)
        expected_output = textwrap.dedent("""\
                D: Parsing changes file ({path}) for files to remove
                """).format(path=self.changes_file_double.path)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_emits_error_message_when_changes_file_open_error(self):
        """ Should emit error message when changes file raises error. """
        self.changes_file_double.set_open_scenario('read_denied')
        try:
            dput.dcut.create_commands(**self.test_args)
        except FakeSystemExit:
            pass
        expected_output = textwrap.dedent("""\
                Can't open changes file: {path}
                """).format(path=self.changes_file_double.path)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_calls_sys_exit_when_changes_file_open_error(self):
        """ Should call `sys.exit` when changes file raises error. """
        self.changes_file_double.set_open_scenario('read_denied')
        with testtools.ExpectedException(FakeSystemExit):
            dput.dcut.create_commands(**self.test_args)
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)

    def test_returns_expected_result(self):
        """ Should return expected result. """
        result = dput.dcut.create_commands(**self.test_args)
        self.assertEqual(self.expected_commands, result)


class write_commands_TestCase(
        testscenarios.WithScenarios,
        testtools.TestCase):
    """ Test cases for `write_commands` function. """

    default_options = {
            'filetocreate': None,
            }

    path_scenarios = [
            ('default-path', {}),
            ('filetocreate', {
                'option_filetocreate': str("ipsum.commands"),
                'expected_result': "ipsum.commands",
                }),
            ('no-tempdir', {
                'tempdir': None,
                }),
            ]

    commands_scenarios = [
            ('commands-none', {
                'commands': [],
                }),
            ('commands-one', {
                'commands': ["foo"],
                }),
            ('commands-three', {
                'commands': ["foo", "bar", "baz"],
                }),
            ]

    keyid_scenarios = [
            ('keyid-none', {}),
            ('keyid-set', {
                'option_keyid': "DEADBEEF",
                }),
            ]

    scenarios = testscenarios.multiply_scenarios(
            path_scenarios, commands_scenarios, keyid_scenarios)

    for (scenario_name, scenario) in scenarios:
        default_options = getattr(
                getoptions_ParseCommandLineTestCase, 'default_options')
        options = dict(default_options)
        options.update({
                'uploader': str("Lorem Ipsum <flup@example.org>"),
                })
        scenario['uploader_filename_part'] = str(
                "Lorem_Ipsum__flup_example_org_")
        if 'option_filetocreate' in scenario:
            options['filetocreate'] = scenario['option_filetocreate']
        if 'option_keyid' in scenario:
            options['keyid'] = scenario['option_keyid']
        scenario['options'] = options
        if 'tempdir' not in scenario:
            scenario['tempdir'] = tempfile.mktemp()
    del scenario_name, scenario
    del default_options, options

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()
        patch_system_interfaces(self)

        patch_os_getpid(self)
        os.getpid.return_value = self.getUniqueInteger()

        self.time_return_value = self.getUniqueInteger()
        patch_time_time(self, itertools.repeat(self.time_return_value))

        patch_sys_argv(self)
        self.set_commands_file_double()
        setup_file_double_behaviour(self)
        self.set_expected_result()

        self.set_commands()

        self.set_test_args()

        patch_subprocess_popen(self)
        patch_subprocess_check_call(self)
        self.set_debsign_subprocess_double()
        setup_subprocess_double_behaviour(self)

    def set_options(self):
        """ Set the options mapping to pass to the function. """

    def set_test_args(self):
        """ Set the arguments for the test call to the function. """
        self.test_args = dict(
                commands=list(self.commands),
                options=dict(self.options),
                config=object(),
                tempdir=self.tempdir,
                )

    def make_commands_filename(self):
        """ Make the filename for the commands output file. """
        expected_progname = self.progname
        filename = "{progname}.{uploadpart}.{time:d}.{pid:d}.commands".format(
                progname=expected_progname,
                uploadpart=self.uploader_filename_part,
                time=self.time_return_value,
                pid=os.getpid.return_value)
        return filename

    def set_commands_file_double(self):
        """ Set the commands file double for this test case. """
        if self.options['filetocreate']:
            path = self.options['filetocreate']
        else:
            output_filename = self.make_commands_filename()
            if self.tempdir:
                path = os.path.join(self.tempdir, output_filename)
            else:
                path = output_filename
        double = FileDouble(path)
        double.register_for_testcase(self)
        self.commands_file_double = double

    def set_expected_result(self):
        """ Set the `expected_result` for this test case. """
        self.expected_result = self.commands_file_double.path

    def set_commands(self):
        """ Set the commands to use for this test case. """
        if not hasattr(self, 'commands'):
            self.commands = []

    def make_expected_content(self):
        """ Make the expected content for the output file. """
        uploader_value = self.options['uploader']
        if self.commands:
            commands_value = "\n".join(
                    " {command}".format(command=command)
                    for command in self.commands)
        else:
            commands_value = " "
        commands_value += "\n"
        text = textwrap.dedent("""\
                Uploader: {uploader}
                Commands:
                {commands}
                """).format(uploader=uploader_value, commands=commands_value)
        return text

    def set_debsign_subprocess_double(self):
        """ Set the ‘debsign’ subprocess double for this test case. """
        path = "/usr/bin/debsign"
        argv = [os.path.basename(path), ARG_MORE]
        double = SubprocessDouble(path, argv)
        double.register_for_testcase(self)
        self.debsign_subprocess_double = double

    def make_expected_debsign_argv(self):
        """ Make the expected command-line arguments for ‘debsign’. """
        argv = [
                str("debsign"),
                str("-m{uploader}").format(uploader=self.options['uploader']),
                ]
        if self.options['keyid']:
            argv.append(
                    "-k{keyid}".format(keyid=self.options['keyid']))
        argv.append(self.commands_file_double.path)

        return argv

    def test_returns_expected_file_path(self):
        """ Should return expected file path. """
        result = dput.dcut.write_commands(**self.test_args)
        self.assertEqual(self.expected_result, result)

    def test_output_file_has_expected_content(self):
        """ Should have expected content in output file. """
        with unittest.mock.patch.object(
                self.commands_file_double.fake_file, "close", autospec=True):
            dput.dcut.write_commands(**self.test_args)
        expected_value = self.make_expected_content()
        self.assertEqual(
                expected_value, self.commands_file_double.fake_file.getvalue())

    def test_emits_debug_message_for_debsign(self):
        """ Should emit debug message for ‘debsign’ command. """
        self.options['debug'] = True
        self.test_args['options'] = self.options
        dput.dcut.write_commands(**self.test_args)
        debsign_argv = self.make_expected_debsign_argv()
        expected_output = textwrap.dedent("""\
                D: calling debsign: {argv}
                """).format(argv=debsign_argv)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_calls_subprocess_check_call_with_expected_args(self):
        """ Should call `subprocess.check_call` with expected args. """
        debsign_argv = self.make_expected_debsign_argv()
        expected_args = [debsign_argv]
        dput.dcut.write_commands(**self.test_args)
        subprocess.check_call.assert_called_with(*expected_args)

    def test_emits_error_message_when_debsign_failure(self):
        """ Should emit error message when ‘debsign’ command failure. """
        self.debsign_subprocess_double.set_subprocess_check_call_scenario(
                'failure')
        try:
            dput.dcut.write_commands(**self.test_args)
        except FakeSystemExit:
            pass
        expected_output = textwrap.dedent("""\
                Error: debsign failed.
                """)
        self.assertIn(expected_output, sys.stderr.getvalue())

    def test_calls_sys_exit_when_debsign_failure(self):
        """ Should call `sys.exit` when ‘debsign’ command failure. """
        self.debsign_subprocess_double.set_subprocess_check_call_scenario(
                'failure')
        with testtools.ExpectedException(FakeSystemExit):
            dput.dcut.write_commands(**self.test_args)
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)


class upload_TestCase(test_dput_main.main_TestCase):
    """ Base for test cases for `upload_stolen_from_dput_main` function. """

    function_to_test = staticmethod(dput.dcut.upload_stolen_from_dput_main)

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()

        self.set_cat_subprocess_double()
        patch_subprocess_call(self)
        patch_tempfile_mkdtemp(self)
        patch_os_rmdir(self)

        patch_getoptions(self)

    def set_cat_subprocess_double(self):
        """ Set the ‘cat’ subprocess double for this test case. """
        path = "/bin/cat"
        argv = [os.path.basename(path), ARG_ANY]
        double = SubprocessDouble(path, argv)
        double.register_for_testcase(self)
        double.set_subprocess_call_scenario('success')
        self.cat_subprocess_double = double

    def set_test_args(self):
        """ Set the arguments for the test call to the function. """
        self.test_args = dict(
                host=self.test_host,
                upload_methods=self.upload_methods,
                config=self.runtime_config_parser,
                debug=False,
                simulate=False,
                files_to_upload=self.files_to_upload,
                ftp_passive_mode=False,
                )

        if hasattr(self, 'test_args_extra'):
            self.test_args.update(self.test_args_extra)

    def get_upload_method_func(self):
        """ Get the specified upload method. """
        method_name = self.runtime_config_parser.get(self.test_host, 'method')
        method_func = self.upload_methods[method_name]
        return method_func


class upload_DebugMessageTestCase(upload_TestCase):
    """ Test cases for `upload_stolen_from_dput_main` debug messages. """

    def test_emits_debug_message_for_discovered_methods(self):
        """ Should emit debug message for discovered upload methods. """
        self.test_args['debug'] = True
        self.function_to_test(**self.test_args)
        expected_output = textwrap.dedent("""\
                D: Default Method: {default_method}
                D: Host Method: {host_method}
                """).format(
                    default_method=self.runtime_config_parser.get(
                        'DEFAULT', 'method'),
                    host_method=self.runtime_config_parser.get(
                        self.test_host, 'method'))
        self.assertIn(expected_output, sys.stdout.getvalue())


class upload_UnknownUploadMethodTestCase(
        testscenarios.WithScenarios,
        upload_TestCase):
    """ Test cases for `upload_stolen_from_dput_main`, unknown method. """

    scenarios = [
            ('bogus-default-method', {
                'config_extras': {
                    'default': {
                        'method': "b0gUs",
                        },
                    },
                'expected_output': "Unknown upload method: b0gUs",
                'expected_exit_status': EXIT_STATUS_FAILURE,
                }),
            ('bogus-host-method', {
                'config_extras': {
                    'host': {
                        'method': "b0gUs",
                        },
                    },
                'expected_output': "Unknown upload method: b0gUs",
                'expected_exit_status': EXIT_STATUS_FAILURE,
                }),
            ]

    def test_emits_error_message_when_unknown_method(self):
        """ Should emit error message when unknown upload method. """
        try:
            self.function_to_test(**self.test_args)
        except FakeSystemExit:
            pass
        self.assertIn(self.expected_output, sys.stderr.getvalue())

    def test_calls_sys_exit_when_unknown_method(self):
        """ Should call `sys.exit` when unknown upload method. """
        with testtools.ExpectedException(FakeSystemExit):
            self.function_to_test(**self.test_args)
        sys.exit.assert_called_with(self.expected_exit_status)


class upload_DiscoverLoginTestCase(
        testscenarios.WithScenarios,
        upload_TestCase):
    """ Test cases for `upload_stolen_from_dput_main` discovery of login. """

    fallback_login_scenarios = [
            ('login-from-environ', {
                'os_environ': {
                    'USER': "login-from-environ",
                    },
                'expected_fallback_login': "login-from-environ",
                'expected_system_uid_debug_message': "",
                }),
            ('login-from-pwd', {
                'os_getuid_return_value': 42,
                'pwd_getpwuid_return_value': PasswdEntry(
                        *(["login-from-pwd"] + [object()] * 6)),
                'expected_fallback_login': "login-from-pwd",
                'expected_system_uid_debug_message': "D: User-ID: 42",
                }),
            ]

    config_login_scenarios = [
            ('config-default-login', {
                'config_extras': {
                    'default': {
                        'login': "login-from-config-default",
                        },
                    },
                'expected_login': "login-from-config-default",
                'expected_output_template':
                    "D: Login to use: {login}",
                }),
            ('config-host-login', {
                'config_extras': {
                    'host': {
                        'login': "login-from-config-host",
                        },
                    },
                'expected_login': "login-from-config-host",
                'expected_output_template':
                    "D: Login to use: {login}",
                }),
            ('config-default-login sentinel', {
                'config_extras': {
                    'default': {
                        'login': "username",
                        },
                    },
                'expected_output_template': (
                    "D: Neither host {host} nor default login used."
                    " Using {login}"),
                }),
            ('config-host-login sentinel', {
                'config_extras': {
                    'host': {
                        'login': "username",
                        },
                    },
                'expected_output_template': (
                    "D: Neither host {host} nor default login used."
                    " Using {login}"),
                }),
            ]

    scenarios = testscenarios.multiply_scenarios(
            fallback_login_scenarios, config_login_scenarios)
    for (scenario_name, scenario) in scenarios:
        if 'expected_login' not in scenario:
            scenario['expected_login'] = scenario['expected_fallback_login']
    del scenario_name, scenario

    def test_emits_debug_message_for_system_uid(self):
        """ Should emit a debug message for the system UID. """
        if self.expected_login != self.expected_fallback_login:
            self.skipTest("No fallback in this scenario")
        self.test_args['debug'] = True
        self.function_to_test(**self.test_args)
        expected_output = self.expected_system_uid_debug_message.format(
                uid=self.os_getuid_return_value)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_emits_debug_message_for_discovered_login(self):
        """ Should emit a debug message for the discovered login. """
        self.test_args['debug'] = True
        self.function_to_test(**self.test_args)
        expected_output = self.expected_output_template.format(
                login=self.expected_login, host=self.test_host)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_calls_upload_method_with_expected_login(self):
        """ Should call upload method function with expected login arg. """
        upload_method_func = get_upload_method_func(self)
        self.function_to_test(**self.test_args)
        upload_method_func.assert_called_with(
                unittest.mock.ANY, self.expected_login,
                unittest.mock.ANY, unittest.mock.ANY,
                unittest.mock.ANY, unittest.mock.ANY)


class upload_SimulateTestCase(
        testscenarios.WithScenarios,
        upload_TestCase):
    """ Test cases for `upload_stolen_from_dput_main`, ‘simulate’ option. """

    scenarios = [
            ('simulate', {
                'config_default_login': "login-from-config-default",
                'test_args_extra': {
                    'simulate': True,
                    },
                }),
            ('simulate files-one', {
                'config_default_login': "login-from-config-default",
                'test_args_extra': {
                    'simulate': True,
                    },
                'files_to_upload': [tempfile.mktemp()],
                }),
            ('simulate files-three', {
                'config_default_login': "login-from-config-default",
                'test_args_extra': {
                    'simulate': True,
                    },
                'files_to_upload': [tempfile.mktemp() for __ in range(3)],
                }),
            ]

    def test_omits_upload_method(self):
        """ Should omit call to upload method function. """
        upload_method_func = get_upload_method_func(self)
        self.function_to_test(**self.test_args)
        self.assertFalse(upload_method_func.called)

    def test_emits_message_for_each_file_to_upload(self):
        """ Should emit a message for each file to upload. """
        self.function_to_test(**self.test_args)
        method = self.runtime_config_parser.get(self.test_host, 'method')
        fqdn = self.runtime_config_parser.get(self.test_host, 'fqdn')
        incoming = self.runtime_config_parser.get(self.test_host, 'incoming')
        expected_output = "\n".join(
                "Uploading with {method}: {path} to {fqdn}:{incoming}".format(
                    method=method, path=path,
                    fqdn=fqdn, incoming=incoming)
                for path in self.files_to_upload)
        self.assertIn(expected_output, sys.stderr.getvalue())

    def test_calls_cat_for_each_file_to_upload(self):
        """ Should call ‘cat’ for each file to upload. """
        self.function_to_test(**self.test_args)
        for path in self.files_to_upload:
            expected_call = unittest.mock.call(
                    "cat {path}".format(path=path),
                    shell=True)
            self.expectThat(
                    subprocess.call.mock_calls,
                    testtools.matchers.Contains(expected_call))


class upload_UploadMethodTestCase(
        testscenarios.WithScenarios,
        upload_TestCase):
    """ Test cases for `upload_stolen_from_dput_main`, invoking method. """

    method_scenarios = [
            ('method-local', {
                'config_method': "local",
                'config_progress_indicator': 23,
                'expected_args': (
                    "localhost", unittest.mock.ANY, unittest.mock.ANY,
                    unittest.mock.ANY, unittest.mock.ANY,
                    0),
                }),
            ('method-ftp', {
                'config_method': "ftp",
                'config_fqdn': "foo.example.com",
                'config_passive_ftp': False,
                'config_progress_indicator': 23,
                'expected_args': (
                    "foo.example.com", unittest.mock.ANY, unittest.mock.ANY,
                    unittest.mock.ANY, unittest.mock.ANY,
                    False),
                'expected_stdout_output': "",
                }),
            ('method-ftp port-custom', {
                'config_method': "ftp",
                'config_fqdn': "foo.example.com:42",
                'config_passive_ftp': False,
                'config_progress_indicator': 23,
                'expected_args': (
                    "foo.example.com:42", unittest.mock.ANY, unittest.mock.ANY,
                    unittest.mock.ANY, unittest.mock.ANY,
                    False),
                'expected_stdout_output': "",
                }),
            ('method-ftp config-passive-mode', {
                'config_method': "ftp",
                'config_fqdn': "foo.example.com",
                'config_passive_ftp': True,
                'config_progress_indicator': 23,
                'expected_args': (
                    "foo.example.com", unittest.mock.ANY, unittest.mock.ANY,
                    unittest.mock.ANY, unittest.mock.ANY,
                    True),
                'expected_stdout_output': "",
                }),
            ('method-ftp config-passive-mode arg-ftp-active-mode', {
                'config_method': "ftp",
                'config_fqdn': "foo.example.com",
                'config_passive_ftp': True,
                'config_progress_indicator': 23,
                'test_args_extra': {
                    'ftp_passive_mode': False,
                    },
                'expected_args': (
                    "foo.example.com", unittest.mock.ANY, unittest.mock.ANY,
                    unittest.mock.ANY, unittest.mock.ANY,
                    True),
                'expected_stdout_output': "D: Using active ftp",
                }),
            ('method-ftp arg-ftp-passive-mode', {
                'config_method': "ftp",
                'config_fqdn': "foo.example.com",
                'config_progress_indicator': 23,
                'test_args_extra': {
                    'ftp_passive_mode': True,
                    },
                'expected_args': (
                    "foo.example.com", unittest.mock.ANY, unittest.mock.ANY,
                    unittest.mock.ANY, unittest.mock.ANY,
                    True),
                'expected_stdout_output': "D: Using passive ftp",
                }),
            ('method-ftp config-passive-mode arg-ftp-passive-mode', {
                'config_method': "ftp",
                'config_fqdn': "foo.example.com",
                'config_passive_ftp': True,
                'config_progress_indicator': 23,
                'test_args_extra': {
                    'ftp_passive_mode': True,
                    },
                'expected_args': (
                    "foo.example.com", unittest.mock.ANY, unittest.mock.ANY,
                    unittest.mock.ANY, unittest.mock.ANY,
                    True),
                'expected_stdout_output': "D: Using passive ftp",
                }),
            ('method-scp', {
                'config_method': "scp",
                'config_fqdn': "foo.example.com",
                'expected_args': (
                    "foo.example.com", unittest.mock.ANY, unittest.mock.ANY,
                    unittest.mock.ANY, unittest.mock.ANY,
                    False, []),
                'expected_stdout_output': "",
                }),
            ('method-scp scp-compress', {
                'config_method': "scp",
                'config_fqdn': "foo.example.com",
                'config_extras': {
                    'host': {
                        'scp_compress': "True",
                        'ssh_config_options': "spam eggs beans",
                        },
                    },
                'expected_args': (
                    "foo.example.com", unittest.mock.ANY, unittest.mock.ANY,
                    unittest.mock.ANY, unittest.mock.ANY,
                    True, ["spam eggs beans"]),
                'expected_stdout_output': "D: Setting compression for scp",
                }),
            ]

    login_scenarios = [
            ('default-login', {
                'config_default_login': "login-from-config-default",
                }),
            ]

    commands_scenarios = [
            ('commands-from-changes', {
                'getoptions_args': ["foo", "bar", "baz"],
                'getoptions_opts': {
                    'filetocreate': None,
                    'filetoupload': tempfile.mktemp() + "commands",
                    },
                }),
            ('commands-from-changes', {
                'getoptions_args': ["foo", "bar", "baz"],
                'getoptions_opts': {
                    'filetocreate': None,
                    'filetoupload': None,
                    'changes': tempfile.mktemp(),
                    },
                }),
            ('commands-from-arguments', {
                'getoptions_args': ["foo", "bar", "baz"],
                'getoptions_opts': {
                    'filetocreate': None,
                    'filetoupload': None,
                    'changes': None,
                    },
                }),
            ]

    files_scenarios = [
            ('files-none', {
                'files_to_remove': [],
                }),
            ('files-one', {
                'files_to_remove': [tempfile.mktemp()],
                }),
            ('files-three', {
                'files_to_remove': [tempfile.mktemp() for __ in range(3)],
                }),
            ]

    scenarios = testscenarios.multiply_scenarios(
            method_scenarios, login_scenarios,
            commands_scenarios, files_scenarios)

    def test_emits_expected_debug_message(self):
        """ Should emit expected debug message. """
        self.test_args['debug'] = True
        self.function_to_test(**self.test_args)
        if hasattr(self, 'expected_stdout_output'):
            self.assertIn(self.expected_stdout_output, sys.stdout.getvalue())

    def test_calls_upload_method_with_expected_args(self):
        """ Should call upload method function with expected args. """
        upload_method_func = get_upload_method_func(self)
        self.function_to_test(**self.test_args)
        upload_method_func.assert_called_with(*self.expected_args)


class dcut_TestCase(testtools.TestCase):
    """ Base for test cases for `dput` function. """

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()
        patch_system_interfaces(self)

        patch_tempfile_mkdtemp(self)
        patch_os_unlink(self)
        patch_os_rmdir(self)
        patch_shutil_rmtree(self)

        set_config(
                self,
                getattr(self, 'config_scenario_name', 'exist-simple'))
        test_dput_main.patch_runtime_config_options(self)

        self.set_test_args()

        patch_getoptions(self)
        test_dput_main.patch_parse_changes(self)
        test_dput_main.patch_read_configs(self)
        test_dput_main.set_upload_methods(self)
        test_dput_main.patch_import_upload_functions(self)

        self.patch_parse_queuecommands()
        self.patch_create_commands()
        self.patch_write_commands()
        self.patch_upload_stolen_from_dput_main()

    def set_test_args(self):
        """ Set the arguments for the test call to the function. """
        self.test_args = dict()

    def patch_parse_queuecommands(self):
        """ Patch the `parse_queuecommands` function for this test case. """
        func_patcher = unittest.mock.patch.object(
                dput.dcut, "parse_queuecommands", autospec=True)
        func_patcher.start()
        self.addCleanup(func_patcher.stop)

    def patch_create_commands(self):
        """ Patch the `create_commands` function for this test case. """
        func_patcher = unittest.mock.patch.object(
                dput.dcut, "create_commands", autospec=True)
        func_patcher.start()
        self.addCleanup(func_patcher.stop)

    def patch_write_commands(self):
        """ Patch the `write_commands` function for this test case. """
        func_patcher = unittest.mock.patch.object(
                dput.dcut, "write_commands", autospec=True)
        func_patcher.start()
        self.addCleanup(func_patcher.stop)

    def patch_upload_stolen_from_dput_main(self):
        """ Patch `upload_stolen_from_dput_main` for this test case. """
        func_patcher = unittest.mock.patch.object(
                dput.dcut, "upload_stolen_from_dput_main", autospec=True)
        func_patcher.start()
        self.addCleanup(func_patcher.stop)


class dcut_DebugMessageTestCase(dcut_TestCase):
    """ Test cases for `dcut` debug messages. """

    def test_emits_debug_message_for_read_configs(self):
        """ Should emit debug message for `read_configs` call. """
        self.getoptions_opts['debug'] = True
        dput.dcut.dcut(**self.test_args)
        expected_output = textwrap.dedent("""\
                D: calling dput.read_configs
                """)
        self.assertIn(expected_output, sys.stdout.getvalue())


class dcut_ConfigFileTestCase(
        testscenarios.WithScenarios,
        dcut_TestCase):
    """ Test cases for `main` specification of configuration file. """

    scenarios = [
            ('default', {
                'expected_args': (None, unittest.mock.ANY),
                }),
            ('config-from-command-line', {
                'getoptions_opts': {
                    'config': "lorem.conf",
                    },
                'expected_args': ("lorem.conf", unittest.mock.ANY),
                }),
            ]

    def test_calls_read_configs_with_expected_args(self):
        """ Should call `read_configs` with expected arguments. """
        dput.dcut.dcut(**self.test_args)
        dput.dput.read_configs.assert_called_with(*self.expected_args)


class dcut_OptionsErrorTestCase(
        testscenarios.WithScenarios,
        dcut_TestCase):
    """ Test cases for `dcut` function, startup options cause error. """

    scenarios = [
            ('no-host-discovered', {
                'config_default_default_host_main': None,
                'getoptions_opts': {
                    'host': None,
                    },
                'expected_output': (
                    "Error: No host specified"
                    " and no default found in config"),
                'expected_exit_status': EXIT_STATUS_FAILURE,
                }),
            ('host-not-in-config', {
                'config_scenario_name': "exist-minimal",
                'expected_output': "No host foo found in config",
                'expected_exit_status': EXIT_STATUS_FAILURE,
                }),
            ('no-allow-dcut', {
                'config_allow_dcut': False,
                'expected_output': (
                    "Error: dcut is not supported for this upload queue."),
                'expected_exit_status': EXIT_STATUS_FAILURE,
                }),
            ('filetoupload arguments', {
                'getoptions_opts': {
                    'filetoupload': tempfile.mktemp() + ".commands",
                    },
                'getoptions_args': ["lorem", "ipsum", "dolor", "sit", "amet"],
                'expected_output': (
                    "Error: cannot take commands"
                    " when uploading existing file"),
                'expected_exit_status': EXIT_STATUS_FAILURE,
                }),
            ]

    def test_emits_expected_error_message(self):
        """ Should emit expected error message. """
        try:
            dput.dcut.dcut(**self.test_args)
        except FakeSystemExit:
            pass
        self.assertIn(self.expected_output, sys.stdout.getvalue())

    def test_calls_sys_exit_with_failure_exit_status(self):
        """ Should call `sys.exit` with failure exit status. """
        with testtools.ExpectedException(FakeSystemExit):
            dput.dcut.dcut(**self.test_args)
        sys.exit.assert_called_with(self.expected_exit_status)


class dcut_NamedHostTestCase(
        testscenarios.WithScenarios,
        dcut_TestCase):
    """ Test cases for `dcut` function, named host processing. """

    scenarios = [
            ('host-from-command-line', {
                'config_scenario_name': "exist-simple-host-three",
                'config_default_default_host_main': "quux",
                'getoptions_opts': {
                    'host': "bar",
                    },
                'expected_host': "bar",
                'expected_debug_output': "",
                }),
            ('host-from-config-default', {
                'config_scenario_name': "exist-simple-host-three",
                'config_default_default_host_main': "bar",
                'getoptions_opts': {
                    'host': None,
                    },
                'expected_host': "bar",
                'expected_debug_output': textwrap.dedent("""\
                    D: Using host "bar" (default_host_main)
                    """),
                }),
            ('host-from-hardcoded-default', {
                'config_scenario_name': "exist-default-distribution-only",
                'config_default_default_host_main': "",
                'getoptions_opts': {
                    'host': None,
                    },
                'expected_host': "ftp-master",
                'expected_debug_output': textwrap.dedent("""\
                    D: Using host "" (default_host_main)
                    D: Using host "ftp-master" (hardcoded)
                    """),
                }),
            ]

    def test_emits_debug_message_for_discovered_host(self):
        """ Should emit debug message for discovered host values. """
        self.getoptions_opts['debug'] = True
        dput.dcut.dcut(**self.test_args)
        self.assertIn(self.expected_debug_output, sys.stdout.getvalue())

    def test_calls_write_commands_with_expected_host_option(self):
        """ Should call `write_commands` with expected `host` option. """
        dput.dcut.dcut(**self.test_args)
        self.assertEqual(1, len(dput.dcut.write_commands.mock_calls))
        (__, call_args, call_kwargs) = dput.dcut.write_commands.mock_calls[0]
        (__, options, __, __) = call_args
        self.assertEqual(self.expected_host, options['host'])


class dcut_FileToUploadNameTestCase(
        testscenarios.WithScenarios,
        dcut_TestCase):
    """ Test cases for `dcut` function, file to upload with bad name. """

    scenarios = [
            ('filetoupload suffix-normal', {
                'getoptions_args': [],
                'getoptions_opts': {
                    'filetoupload': tempfile.mktemp() + ".commands",
                    },
                'unwanted_output': "Error",
                }),
            ('filetoupload suffix-unexpected', {
                'getoptions_args': [],
                'getoptions_opts': {
                    'filetoupload': tempfile.mktemp(),
                    },
                'expected_output': (
                    "Error: I'm insisting on the .commands extension"),
                }),
            ]

    def test_emits_error_message_for_bad_filename(self):
        """ Should emit error message for bad filename. """
        dput.dcut.dcut(**self.test_args)
        if getattr(self, 'expected_output', None):
            self.assertIn(self.expected_output, sys.stdout.getvalue())
        else:
            self.assertNotIn(self.unwanted_output, sys.stdout.getvalue())


class dcut_ParseChangesTestCase(
        testscenarios.WithScenarios,
        dcut_TestCase):
    """ Test cases for `dcut` function, parse upload control file. """

    scenarios = [
            ('changes-file with-filetoupload with-filetocreate', {
                'getoptions_opts': {
                    'filetoupload': tempfile.mktemp(),
                    'filetocreate': tempfile.mktemp(),
                    'changes': tempfile.mktemp(),
                    },
                'expect_create_commands': False,
                'expect_write_commands': False,
                'expected_tempdir': None,
                }),
            ('changes-file no-filetoupload with-filetocreate', {
                'getoptions_opts': {
                    'filetoupload': None,
                    'filetocreate': tempfile.mktemp(),
                    'changes': tempfile.mktemp(),
                    },
                'expect_create_commands': True,
                'expect_write_commands': True,
                'expected_tempdir': None,
                }),
            ('changes-file with-filetoupload no-filetocreate', {
                'getoptions_opts': {
                    'filetoupload': tempfile.mktemp(),
                    'filetocreate': None,
                    'changes': tempfile.mktemp(),
                    },
                'expect_create_commands': False,
                'expect_write_commands': False,
                'expected_tempdir': None,
                }),
            ('changes-file no-filetoupload no-filetocreate', {
                'getoptions_opts': {
                    'filetoupload': None,
                    'filetocreate': None,
                    'changes': tempfile.mktemp(),
                    },
                'expect_create_commands': True,
                'expect_write_commands': True,
                }),
            ]

    def test_calls_create_commands_with_expected_args(self):
        """ Should call `create_commands` as expected. """
        dput.dcut.dcut(**self.test_args)
        (expected_options, __) = dput.dcut.getoptions()
        expected_config = self.runtime_config_parser
        expected_parse_changes = dput.dput.parse_changes
        if self.expect_create_commands:
            dput.dcut.create_commands.assert_called_with(
                    expected_options, expected_config, expected_parse_changes)
        else:
            self.assertFalse(dput.dcut.create_commands.called)

    def test_calls_write_commands_with_expected_args(self):
        """ Should call `write_commands` as expected. """
        expected_commands = dput.dcut.create_commands.return_value
        dput.dcut.dcut(**self.test_args)
        (expected_options, __) = dput.dcut.getoptions()
        expected_config = self.runtime_config_parser
        expected_tempdir = getattr(
                self, 'expected_tempdir',
                self.tempfile_mkdtemp_file_double.path)
        if self.expect_write_commands:
            dput.dcut.write_commands.assert_called_with(
                    expected_commands, expected_options, expected_config,
                    expected_tempdir)
        else:
            self.assertFalse(dput.dcut.write_commands.called)


class dcut_ParseCommandsFromArgumentsTestCase(
        testscenarios.WithScenarios,
        dcut_TestCase):
    """ Test cases for `dcut` function, parse commands from arguments. """

    scenarios = [
            ('no-changes-file with-filetoupload with-filetocreate', {
                'getoptions_opts': {
                    'filetoupload': tempfile.mktemp(),
                    'filetocreate': tempfile.mktemp(),
                    'changes': None,
                    },
                'expect_parse_queuecommands': False,
                'expect_write_commands': False,
                'expected_tempdir': None,
                }),
            ('no-changes-file no-filetoupload with-filetocreate', {
                'getoptions_opts': {
                    'filetoupload': None,
                    'filetocreate': tempfile.mktemp(),
                    'changes': None,
                    },
                'expect_parse_queuecommands': True,
                'expect_write_commands': True,
                'expected_tempdir': None,
                }),
            ('no-changes-file with-filetoupload no-filetocreate', {
                'getoptions_opts': {
                    'filetoupload': tempfile.mktemp(),
                    'filetocreate': None,
                    'changes': None,
                    },
                'expect_parse_queuecommands': False,
                'expect_write_commands': False,
                'expected_tempdir': None,
                }),
            ('no-changes-file no-filetoupload no-filetocreate', {
                'getoptions_opts': {
                    'filetoupload': None,
                    'filetocreate': None,
                    'changes': None,
                    },
                'expect_parse_queuecommands': True,
                'expect_write_commands': True,
                }),
            ]

    def test_calls_parse_queuecommands_with_expected_args(self):
        """ Should call `parse_queuecommands` with expected args. """
        dput.dcut.dcut(**self.test_args)
        (expected_options, expected_arguments) = dput.dcut.getoptions()
        expected_config = self.runtime_config_parser
        if self.expect_parse_queuecommands:
            dput.dcut.parse_queuecommands.assert_called_with(
                    expected_arguments, expected_options, expected_config)
        else:
            self.assertFalse(dput.dcut.parse_queuecommands.called)

    def test_calls_write_commands_with_expected_args(self):
        """ Should call `write_commands` with expected args. """
        expected_commands = dput.dcut.parse_queuecommands.return_value
        dput.dcut.dcut(**self.test_args)
        (expected_options, __) = dput.dcut.getoptions()
        expected_config = self.runtime_config_parser
        expected_tempdir = getattr(
                self, 'expected_tempdir',
                self.tempfile_mkdtemp_file_double.path)
        if self.expect_write_commands:
            dput.dcut.write_commands.assert_called_with(
                    expected_commands, expected_options, expected_config,
                    expected_tempdir)
        else:
            self.assertFalse(dput.dcut.write_commands.called)


class dcut_WriteQueueCommandsTestCase(
        testscenarios.WithScenarios,
        dcut_TestCase):
    """ Test cases for `dcut` function, cleanup from exception. """

    scenarios = [
            ('changes-file with-filetoupload with-filetocreate', {
                'getoptions_opts': {
                    'filetoupload': tempfile.mktemp(),
                    'filetocreate': tempfile.mktemp(),
                    'changes': tempfile.mktemp(),
                    },
                'expected_tempdir': None,
                }),
            ('changes-file no-filetoupload with-filetocreate', {
                'getoptions_opts': {
                    'filetoupload': None,
                    'filetocreate': tempfile.mktemp(),
                    'changes': tempfile.mktemp(),
                    },
                'expected_tempdir': None,
                }),
            ('changes-file with-filetoupload no-filetocreate', {
                'getoptions_opts': {
                    'filetoupload': tempfile.mktemp(),
                    'filetocreate': None,
                    'changes': tempfile.mktemp(),
                    },
                'expected_tempdir': None,
                }),
            ('changes-file no-filetoupload no-filetocreate', {
                'getoptions_opts': {
                    'filetoupload': None,
                    'filetocreate': None,
                    'changes': tempfile.mktemp(),
                    },
                }),
            ]


class dcut_CleanupTestCase(
        testscenarios.WithScenarios,
        dcut_TestCase):
    """ Test cases for `dcut` function, cleanup from exception. """

    commands_scenarios = [
            ('commands-from-arguments', {
                'getoptions_args': ["foo", "bar", "baz"],
                'getoptions_opts': {
                    'filetocreate': None,
                    'filetoupload': None,
                    'changes': None,
                    },
                }),
            ]

    files_scenarios = upload_UploadMethodTestCase.files_scenarios

    scenarios = testscenarios.multiply_scenarios(
            commands_scenarios, files_scenarios)

    def test_removes_temporary_directory(self):
        """ Should remove directory `tempdir` at end. """
        dput.dcut.dcut(**self.test_args)
        shutil.rmtree.assert_called_with(
                self.tempfile_mkdtemp_file_double.path)

    def test_removes_temporary_directory_when_upload_raises_exception(self):
        """ Should remove directory `tempdir` when exception raised. """
        upload_method_func = get_upload_method_func(self)
        upload_error = RuntimeError("Bad stuff happened")
        upload_method_func.side_effect = upload_error
        try:
            dput.dcut.dcut(**self.test_args)
        except self.upload_error.__class__:
            pass
        shutil.rmtree.assert_called_with(
                self.tempfile_mkdtemp_file_double.path)


# Copyright © 2015–2021 Ben Finney <bignose@debian.org>
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
