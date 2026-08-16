# test/test_dput_main.py
# Part of ‘dput’, a Debian package upload toolkit.
#
# This is free software, and you are welcome to redistribute it under
# certain conditions; see the end of this file for copyright
# information, grant of license, and disclaimer of warranty.

""" Unit tests for ‘dput’ module `main` function. """

import doctest
import os
import sys
import tempfile
import textwrap
import types
import unittest.mock

import pkg_resources
import testscenarios
import testtools
import testtools.matchers

import dput.dput
from dput.helper import dputhelper

from .helper import (
        EXIT_STATUS_FAILURE,
        EXIT_STATUS_SUCCESS,
        FakeSystemExit,
        PasswdEntry,
        patch_os_environ,
        patch_os_getuid,
        patch_pwd_getpwuid,
        patch_sys_argv,
        patch_system_interfaces,
        )
from .test_changesfile import (
        make_changes_file_path,
        set_changes_file_scenario,
        setup_changes_file_fixtures,
        )
from .test_configfile import (
        patch_runtime_config_options,
        set_config,
        )
from .test_dputhelper import (
        patch_getopt,
        patch_pkg_resources_get_distribution,
        )


def patch_parse_changes(testcase):
    """ Patch the `parse_changes` function for the test case. """
    func_patcher = unittest.mock.patch.object(
            dput.dput, "parse_changes", autospec=True)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


def patch_read_configs(testcase):
    """ Patch the `read_configs` function for the test case. """
    def fake_read_configs(*args, **kwargs):
        return testcase.runtime_config_parser

    func_patcher = unittest.mock.patch.object(
            dput.dput, "read_configs", autospec=True,
            side_effect=fake_read_configs)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


def patch_print_config(testcase):
    """ Patch the `print_config` function for the test case. """
    func_patcher = unittest.mock.patch.object(
            dput.dput, "print_config", autospec=True)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


def set_upload_methods(testcase):
    """ Set the `upload_methods` value for the test case. """
    if not hasattr(testcase, 'upload_methods'):
        upload_methods = dput.dput.import_upload_functions()
        testcase.upload_methods = {
                name: unittest.mock.MagicMock(upload_methods[name])
                for name in upload_methods}


def patch_import_upload_functions(testcase):
    """ Patch the `import_upload_functions` function for the test case. """
    func_patcher = unittest.mock.patch.object(
            dput.dput, "import_upload_functions", autospec=True,
            return_value=testcase.upload_methods)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


class make_usage_message_TestCase(testtools.TestCase):
    """ Test cases for `make_usage_message` function. """

    def test_returns_text_with_program_name(self):
        """ Should return text with expected program name. """
        result = dput.dput.make_usage_message()
        expected_result = textwrap.dedent("""\
                Usage: dput ...
                ...
                """)
        self.expectThat(
                result,
                testtools.matchers.DocTestMatches(
                    expected_result, flags=doctest.ELLIPSIS))


class parse_commandline_BaseTestCase(
        testtools.TestCase):
    """ Base class for test cases for function `parse_commandline`. """

    function_to_test = staticmethod(dput.dput.parse_commandline)

    progname = "lorem"
    dput_version = "ipsum"
    dput_usage_message = "Lorem ipsum, dolor sit amet."

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()
        patch_system_interfaces(self)

        setup_changes_file_fixtures(self)
        set_changes_file_scenario(self, 'exist-minimal')
        self.set_files_to_upload()

        self.patch_make_usage_message()
        self.patch_distribution()

        self.options_defaults = dict(self.function_to_test.options_defaults)
        self.patch_getopt()

        if not hasattr(self, 'test_argv'):
            self.test_argv = self.make_test_argv()
        self.test_args = dict(
                argv=self.test_argv,
                )
        self.set_expected_options_mapping()
        self.set_expected_args()

    def set_files_to_upload(self):
        """ Set the `files_to_upload` collection for this test case. """
        if not hasattr(self, 'files_to_upload'):
            self.files_to_upload = []

    def make_test_argv(self):
        """ Make the `argv` value for this test case. """
        test_argv = [self.progname] + [
                fake_file.path for fake_file in self.files_to_upload]
        return test_argv

    def patch_make_usage_message(self):
        """ Patch the `make_usage_message` function. """
        if not hasattr(self, 'dput_usage_message'):
            self.dput_usage_message = self.getUniqueString()
        func_patcher = unittest.mock.patch.object(
                dput.dput, "make_usage_message", autospec=True,
                return_value=self.dput_usage_message)
        func_patcher.start()
        self.addCleanup(func_patcher.stop)

    def patch_distribution(self):
        """ Patch the Python distribution for this test case. """
        self.fake_distribution = unittest.mock.MagicMock(
                pkg_resources.Distribution)
        if hasattr(self, 'dput_version'):
            self.fake_distribution.version = self.dput_version
        patch_pkg_resources_get_distribution(self)

    def set_expected_args(self):
        """ Set the `expected_args` collection for this test case. """
        if not hasattr(self, 'expected_args'):
            self.expected_args = self.getopt_args

    def set_expected_options_mapping(self):
        """ Set the `expected_options_mapping` for this test case. """
        if not hasattr(self, 'expected_options_mapping'):
            self.expected_options_mapping = self.options_defaults

    def patch_getopt(self):
        """ Patch the `dputhelper.getopt` function. """
        if not hasattr(self, 'getopt_opts'):
            self.getopt_opts = []
        if not hasattr(self, 'getopt_args'):
            self.getopt_args = [self.changes_file_double.path]

        patch_getopt(self)


class parse_commandline_TestCase(
        testscenarios.WithScenarios,
        parse_commandline_BaseTestCase):
    """ Test cases for function `parse_commandline`. """

    scenarios = [
            ('host-named files-three options-none', {
                'test_argv': ["lorem"] + [
                    make_changes_file_path(tempfile.mktemp())
                    for __ in range(3)],
                }),
            ]

    def test_calls_getopt_with_expected_args(self):
        """ Should call `getopt` with expected arguments. """
        self.function_to_test(**self.test_args)
        dputhelper.getopt.assert_called_with(
                self.test_argv[1:],
                unittest.mock.ANY, unittest.mock.ANY)

    def test_returns_expected_values(self):
        """ Should return expected 2-tuple of (`options`, `args`). """
        (options, args) = self.function_to_test(**self.test_args)
        options_mapping = {
                name: getattr(options, name)
                for name in dir(options)
                if not name.startswith('_')}
        self.assertEqual(self.expected_options_mapping, options_mapping)
        self.assertEqual(self.expected_args, args)

    @unittest.mock.patch.object(dput.dput, 'debug', new=object())
    def test_sets_debug_flag_when_debug_option(self):
        """ Should set `debug` when ‘--debug’ option. """
        self.getopt_opts = [("--debug", None)]
        self.function_to_test(**self.test_args)
        self.assertEqual(dput.dput.debug, True)


class parse_commandline_ErrorTestCase(parse_commandline_BaseTestCase):
    """ Test cases for `parse_commandline`, error conditions. """

    def test_calls_sys_exit_when_no_nonoption_args(self):
        """ Should call `sys.exit` when no non-option args. """
        self.getopt_args = []
        with testtools.ExpectedException(FakeSystemExit):
            self.function_to_test(**self.test_args)
        sys.exit.assert_called_with(os.EX_USAGE)

    def test_calls_sys_exit_when_unknown_option(self):
        """ Should call `sys.exit` when an unknown option. """
        self.getopt_args.insert(1, "--b0gUs")
        dputhelper.getopt.side_effect = dputhelper.DputException
        with testtools.ExpectedException(FakeSystemExit):
            self.function_to_test(**self.test_args)
        sys.exit.assert_called_with(os.EX_USAGE)

    def test_emits_error_when_invalid_delayed_value(self):
        """ Should emit error message when ‘--delayed’ invalid. """
        self.getopt_opts = [("--delayed", "b0gUs")]
        try:
            self.function_to_test(**self.test_args)
        except FakeSystemExit:
            pass
        expected_output = textwrap.dedent("""\
                Incorrect delayed argument, ...
                """)
        self.assertThat(
                sys.stdout.getvalue(),
                testtools.matchers.DocTestMatches(
                    expected_output, doctest.ELLIPSIS))

    def test_calls_sys_exit_when_invalid_delayed_value(self):
        """ Should call `sys.exit` when ‘--delayed’ invalid. """
        self.getopt_opts = [("--delayed", "b0gUs")]
        with testtools.ExpectedException(FakeSystemExit):
            self.function_to_test(**self.test_args)
        sys.exit.assert_called_with(os.EX_USAGE)


class parse_commandline_PrintAndEndTestCase(parse_commandline_BaseTestCase):
    """ Test cases for `parse_commandline` that print and end. """

    def test_emits_usage_message_when_option_help(self):
        """ Should emit usage message when ‘--help’ option. """
        self.getopt_opts = [("--help", None)]
        try:
            self.function_to_test(**self.test_args)
        except FakeSystemExit:
            pass
        expected_output = self.dput_usage_message
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_calls_sys_exit_when_option_help(self):
        """ Should call `sys.exit` when ‘--help’ option. """
        self.getopt_opts = [("--help", None)]
        with testtools.ExpectedException(FakeSystemExit):
            self.function_to_test(**self.test_args)
        sys.exit.assert_called_with(EXIT_STATUS_SUCCESS)

    def test_emits_version_message_when_option_version(self):
        """ Should emit version message when ‘--version’ option. """
        self.getopt_opts = [("--version", None)]
        try:
            self.function_to_test(**self.test_args)
        except FakeSystemExit:
            pass
        expected_progname = self.progname
        expected_version = self.fake_distribution.version
        expected_output = "{progname} {version}".format(
                progname=expected_progname, version=expected_version)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_calls_sys_exit_when_option_version(self):
        """ Should call `sys.exit` when ‘--version’ option. """
        self.getopt_opts = [("--version", None)]
        with testtools.ExpectedException(FakeSystemExit):
            self.function_to_test(**self.test_args)
        sys.exit.assert_called_with(EXIT_STATUS_SUCCESS)


class main_TestCase(
        testtools.TestCase):
    """ Base for test cases for `main` function. """

    function_to_test = staticmethod(dput.dput.main)

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()
        patch_system_interfaces(self)

        set_config(
                self,
                getattr(self, 'config_scenario_name', 'exist-simple'))
        patch_runtime_config_options(self)

        setup_changes_file_fixtures(self)
        set_changes_file_scenario(self, 'exist-minimal')

        self.patch_os_isatty()
        patch_os_environ(self)
        patch_os_getuid(self)
        patch_pwd_getpwuid(self)
        patch_sys_argv(self)

        self.set_files_to_upload()
        set_upload_methods(self)

        self.set_test_args()

        self.patch_make_usage_message()
        self.patch_distribution()

        self.options_defaults = dict(
                dput.dput.parse_commandline.options_defaults)
        self.patch_parse_commandline()
        patch_read_configs(self)
        patch_print_config(self)
        patch_import_upload_functions(self)
        self.patch_guess_upload_host()
        self.patch_check_upload_logfile()
        self.patch_verify_files()
        self.patch_run_lintian_test()
        self.patch_execute_command()
        self.patch_create_upload_file()
        self.patch_dinstall_caller()

    def patch_os_isatty(self):
        """ Patch the `os.isatty` function. """
        if not hasattr(self, 'os_isatty_return_value'):
            self.os_isatty_return_value = False
        func_patcher = unittest.mock.patch.object(
                os, "isatty", autospec=True,
                return_value=self.os_isatty_return_value)
        func_patcher.start()
        self.addCleanup(func_patcher.stop)

    def set_files_to_upload(self):
        """ Set the `files_to_upload` collection for this instance. """
        if not hasattr(self, 'files_to_upload'):
            self.files_to_upload = []

    def set_test_args(self):
        """ Set the arguments for the test call to the function. """
        self.test_args = dict()

    def patch_make_usage_message(self):
        """ Patch the `make_usage_message` function. """
        if not hasattr(self, 'dput_usage_message'):
            self.dput_usage_message = self.getUniqueString()
        func_patcher = unittest.mock.patch.object(
                dput.dput, "make_usage_message", autospec=True,
                return_value=self.dput_usage_message)
        func_patcher.start()
        self.addCleanup(func_patcher.stop)

    def patch_distribution(self):
        """ Patch the Python distribution for this test case. """
        self.fake_distribution = unittest.mock.MagicMock(
                pkg_resources.Distribution)
        if hasattr(self, 'dput_version'):
            self.fake_distribution.version = self.dput_version
        patch_pkg_resources_get_distribution(self)

    def set_fake_options(self, options_mapping=None):
        """ Set the `fake_options` object, updated with `options_mapping`. """
        self.fake_options = types.SimpleNamespace()
        for (name, value) in self.options_defaults.items():
            setattr(self.fake_options, name, value)
        if options_mapping is None:
            options_mapping = self.fake_options_mapping
        for (name, value) in options_mapping.items():
            setattr(self.fake_options, name, value)

    def patch_parse_commandline(self):
        """ Patch the `parse_commandline` function. """
        if not hasattr(self, 'fake_options_mapping'):
            self.fake_options_mapping = {}
        self.set_fake_options(self.fake_options_mapping)
        if not hasattr(self, 'fake_args'):
            self.fake_args = [self.changes_file_double.path]

        def fake_parse_commandline(*args, **kwargs):
            return (self.fake_options, self.fake_args)

        func_patcher = unittest.mock.patch.object(
                dput.dput, "parse_commandline",
                side_effect=fake_parse_commandline)
        func_patcher.start()
        self.addCleanup(func_patcher.stop)

    def patch_guess_upload_host(self):
        """ Patch the `guess_upload_host` function. """
        if not hasattr(self, 'guess_upload_host_return_value'):
            self.guess_upload_host_return_value = self.test_host
        func_patcher = unittest.mock.patch.object(
                dput.dput, "guess_upload_host", autospec=True,
                return_value=self.guess_upload_host_return_value)
        func_patcher.start()
        self.addCleanup(func_patcher.stop)

    def patch_check_upload_logfile(self):
        """ Patch the `check_upload_logfile` function. """
        func_patcher = unittest.mock.patch.object(
                dput.dput, "check_upload_logfile", autospec=True)
        func_patcher.start()
        self.addCleanup(func_patcher.stop)

    def patch_verify_files(self):
        """ Patch the `verify_files` function. """
        func_patcher = unittest.mock.patch.object(
                dput.dput, "verify_files", autospec=True,
                return_value=self.files_to_upload)
        func_patcher.start()
        self.addCleanup(func_patcher.stop)

    def patch_run_lintian_test(self):
        """ Patch the `run_lintian_test` function. """
        func_patcher = unittest.mock.patch.object(
                dput.dput, "run_lintian_test", autospec=True)
        func_patcher.start()
        self.addCleanup(func_patcher.stop)

    def patch_execute_command(self):
        """ Patch the `execute_command` function. """
        func_patcher = unittest.mock.patch.object(
                dput.dput, "execute_command", autospec=True)
        func_patcher.start()
        self.addCleanup(func_patcher.stop)

    def patch_create_upload_file(self):
        """ Patch the `create_upload_file` function. """
        func_patcher = unittest.mock.patch.object(
                dput.dput, "create_upload_file", autospec=True)
        func_patcher.start()
        self.addCleanup(func_patcher.stop)

    def patch_dinstall_caller(self):
        """ Patch the `dinstall_caller` function. """
        func_patcher = unittest.mock.patch.object(
                dput.dput, "dinstall_caller", autospec=True)
        func_patcher.start()
        self.addCleanup(func_patcher.stop)


class main_CommandLineProcessingTestCase(main_TestCase):
    """ Test cases for `main` command-line processing. """

    sys_argv = ["lorem"] + [
            make_changes_file_path(tempfile.mktemp())
            for __ in range(3)]

    def test_calls_parse_commandline_with_expected_args(self):
        """ Should call `parse_commandline` with expected arguments. """
        self.function_to_test(**self.test_args)
        dput.dput.parse_commandline.assert_called_with(self.sys_argv)

    def test_returns_exit_status_when_systemexit(self):
        """ Should return exit status from `SystemExit` exception. """
        exit_status = self.getUniqueInteger()
        dput.dput.parse_commandline.side_effect = SystemExit(exit_status)
        result = self.function_to_test(**self.test_args)
        self.assertEqual(result, exit_status)


class main_DebugMessageTestCase(main_TestCase):
    """ Test cases for `main` debug messages. """

    progname = "lorem"
    dput_version = "ipsum"

    @unittest.mock.patch.object(dput.dput, 'debug', new=True)
    def test_emits_debug_message_with_dput_version(self):
        """ Should emit debug message showing Dput version string. """
        self.fake_options.debug = True
        self.function_to_test(**self.test_args)
        expected_progname = self.progname
        expected_version = self.fake_distribution.version
        expected_output = textwrap.dedent("""\
                D: {progname} {version}
                """).format(
                    progname=expected_progname,
                    version=expected_version)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_emits_debug_message_for_discovered_methods(self):
        """ Should emit debug message for discovered upload methods. """
        self.fake_options.debug = True
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


class main_DefaultFunctionCallTestCase(main_TestCase):
    """ Test cases for `main` defaults calling other functions. """

    def test_calls_import_upload_functions_with_expected_args(self):
        """ Should call `import_upload_functions` with expected arguments. """
        self.function_to_test(**self.test_args)
        dput.dput.import_upload_functions.assert_called_with()


class main_ConfigFileTestCase(
        testscenarios.WithScenarios,
        main_TestCase):
    """ Test cases for `main` specification of configuration file. """

    scenarios = [
            ('default', {
                'expected_args': ("", unittest.mock.ANY),
                }),
            ('config-from-command-line', {
                'fake_options_mapping': {
                    'config_file_path': "lorem.conf",
                    },
                'expected_args': ("lorem.conf", unittest.mock.ANY),
                }),
            ]

    def test_calls_read_configs_with_expected_args(self):
        """ Should call `read_configs` with expected arguments. """
        self.function_to_test(**self.test_args)
        dput.dput.read_configs.assert_called_with(*self.expected_args)


class main_PrintAndEndTestCase(main_TestCase):
    """ Test cases for `main` that print and end. """

    progname = "lorem"
    dput_version = "ipsum"
    dput_usage_message = "Lorem ipsum, dolor sit amet."

    def test_print_config_when_option_print(self):
        """ Should call `print_config` when ‘--print’. """
        self.fake_options_mapping.update({'config_print': True})
        self.set_fake_options()
        try:
            self.function_to_test(**self.test_args)
        except FakeSystemExit:
            pass
        dput.dput.print_config.assert_called_with(
                self.runtime_config_parser, dput.dput.debug)

    def test_print_config_then_sys_exit_when_option_print(self):
        """ Should call `print_config`, then `sys.exit`, when ‘--print’. """
        self.fake_options_mapping.update({'config_print': True})
        self.set_fake_options()
        with testtools.ExpectedException(FakeSystemExit):
            self.function_to_test(**self.test_args)
        sys.exit.assert_called_with(EXIT_STATUS_SUCCESS)

    def test_calls_sys_exit_when_option_host_list(self):
        """ Should call `sys.exit` when option ‘--host-list’. """
        self.fake_options_mapping.update({'config_host_list': True})
        self.set_fake_options()
        with testtools.ExpectedException(FakeSystemExit):
            self.function_to_test(**self.test_args)
        sys.exit.assert_called_with(EXIT_STATUS_SUCCESS)


class main_DiscoverLoginTestCase(
        testscenarios.WithScenarios,
        main_TestCase):
    """ Test cases for `main` discovery of login name. """

    fallback_login_scenarios = [
            ('login-from-environ', {
                'os_environ': {
                    'USER': "login-from-environ",
                    },
                'expected_fallback_login': "login-from-environ",
                }),
            ('login-from-pwd', {
                'pwd_getpwuid_return_value': PasswdEntry(
                        *(["login-from-pwd"] + [object()] * 6)),
                'expected_fallback_login': "login-from-pwd",
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
                    "D: Login {login} from section {host} used",
                }),
            ('config-host-login', {
                'config_extras': {
                    'host': {
                        'login': "login-from-config-host",
                        },
                    },
                'expected_login': "login-from-config-host",
                'expected_output_template':
                    "D: Login {login} from section {host} used",
                }),
            ('config-default-login sentinel', {
                'config_extras': {
                    'default': {
                        'login': "username",
                        },
                    },
                'expected_output_template':
                    "D: Neither host {host} nor default login used.",
                }),
            ('config-host-login sentinel', {
                'config_extras': {
                    'host': {
                        'login': "username",
                        },
                    },
                'expected_output_template':
                    "D: Neither host {host} nor default login used.",
                }),
            ]

    scenarios = testscenarios.multiply_scenarios(
            fallback_login_scenarios, config_login_scenarios)
    for (scenario_name, scenario) in scenarios:
        if 'expected_login' not in scenario:
            scenario['expected_login'] = scenario['expected_fallback_login']
    del scenario_name, scenario

    def test_emits_debug_message_for_fallback_login(self):
        """ Should emit a debug message for the fallback login. """
        self.fake_options.debug = True
        self.function_to_test(**self.test_args)
        expected_output = textwrap.dedent("""\
                D: Login: {fallback_login}
                """).format(fallback_login=self.expected_fallback_login)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_emits_debug_message_for_discovered_login(self):
        """ Should emit a debug message for the discovered login. """
        self.fake_options.debug = True
        self.function_to_test(**self.test_args)
        expected_output = self.expected_output_template.format(
                login=self.expected_login, host=self.test_host)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_calls_upload_method_with_expected_login(self):
        """ Should call upload method function with expected login arg. """
        expected_method_name = self.runtime_config_parser.get(
                self.test_host, 'method')
        expected_method_func = self.upload_methods[expected_method_name]
        self.function_to_test(**self.test_args)
        expected_method_func.assert_called_with(
                unittest.mock.ANY, self.expected_login,
                unittest.mock.ANY, unittest.mock.ANY,
                unittest.mock.ANY, unittest.mock.ANY,
                progress=unittest.mock.ANY, port=unittest.mock.ANY)


class main_HostListTestCase(
        testscenarios.WithScenarios,
        main_TestCase):
    """ Test cases for `main` with ‘--host-list’ option. """

    scenarios = [
            ('default', {}),
            ('config-distribution-one', {
                'config_scenario_name': "exist-distribution-one",
                }),
            ('config-distribution-three', {
                'config_scenario_name': "exist-distribution-three",
                }),
            ]

    def test_iterate_config_sections_when_option_host_list(self):
        """ Should iteratively emit config sections when ‘--host-list’. """
        self.fake_options_mapping.update({'config_host_list': True})
        self.set_fake_options()
        try:
            self.function_to_test(**self.test_args)
        except FakeSystemExit:
            pass
        expected_output_lines = ["..."] + [
                "{section} => {fqdn}  (Upload method: {method}...)".format(
                    section=section_name,
                    fqdn=self.runtime_config_parser.get(section_name, 'fqdn'),
                    method=self.runtime_config_parser.get(
                        section_name, 'method'),
                    )
                for section_name in self.runtime_config_parser.sections()
                ] + ["..."]
        expected_output = "\n".join(expected_output_lines)
        self.assertThat(
                sys.stdout.getvalue(),
                testtools.matchers.DocTestMatches(
                    expected_output, doctest.ELLIPSIS))


class main_NamedHost_TestCase(
        testscenarios.WithScenarios,
        main_TestCase):
    """ Test cases for `main` function, named host processing. """

    scenarios = [
            ('host-from-command-line', {
                'config_scenario_name': "exist-simple-host-three",
                'fake_args': ["bar", "lorem.changes", "ipsum.changes"],
                'expected_host': "bar",
                'expected_debug_output': "D: Host bar found in config",
                }),
            ('host-from-command-line check-only', {
                'config_scenario_name': "exist-simple-host-three",
                'fake_options_mapping': {'check_only': True},
                'fake_args': ["bar", "lorem.changes", "ipsum.changes"],
                'expected_host': "bar",
                'expected_debug_output': "D: Host bar found in config",
                }),
            ('host-from-command-line force-upload', {
                'config_scenario_name': "exist-simple-host-three",
                'fake_options_mapping': {'force_upload': True},
                'fake_args': ["bar", "lorem.changes", "ipsum.changes"],
                'expected_host': "bar",
                'expected_debug_output': "D: Host bar found in config",
                }),
            ('only-changes-filenames', {
                'config_scenario_name': "exist-simple-host-three",
                'fake_args': ["lorem.changes", "ipsum.changes"],
                'expected_host': "foo",
                'expected_debug_output': "D: No host named on command line.",
                }),
            ('only-changes-filenames check-only', {
                'config_scenario_name': "exist-simple-host-three",
                'fake_options_mapping': {
                    'debug': True,
                    'check_only': True,
                },
                'fake_args': ["lorem.changes", "ipsum.changes"],
                'expected_host': "foo",
                'expected_debug_output': "D: No host named on command line.",
                'follow_the_goddamned_branches': True,
                }),
            ]

    def test_emits_expected_debug_message(self):
        """ Should emit expected debug message. """
        self.fake_options.debug = True
        try:
            self.function_to_test(**self.test_args)
        except FakeSystemExit:
            pass
        expected_output = self.expected_debug_output.format(
                host=self.expected_host)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_check_upload_logfile_called_with_expected_host(self):
        """ Should call `check_upload_logfile` with expected host. """
        try:
            self.function_to_test(**self.test_args)
        except FakeSystemExit:
            pass
        expected_fqdn = self.runtime_config_parser.get(self.test_host, 'fqdn')
        expected_args = (
                unittest.mock.ANY, self.expected_host, expected_fqdn,
                unittest.mock.ANY, unittest.mock.ANY,
                unittest.mock.ANY, unittest.mock.ANY)
        dput.dput.check_upload_logfile.assert_called_with(*expected_args)

    def test_verify_files_called_with_expected_host(self):
        """ Should call `verify_files` with expected host. """
        try:
            self.function_to_test(**self.test_args)
        except FakeSystemExit:
            pass
        expected_args = (
                unittest.mock.ANY, unittest.mock.ANY, self.expected_host,
                unittest.mock.ANY, unittest.mock.ANY,
                unittest.mock.ANY, unittest.mock.ANY, unittest.mock.ANY)
        dput.dput.verify_files.assert_called_with(*expected_args)


class main_NamedHostNotInConfigTestCase(
        testscenarios.WithScenarios,
        main_TestCase):
    """ Test cases for `main` function, named host not in config. """

    scenarios = [
            ('host-from-command-line', {
                'config_scenario_name': "exist-simple-host-three",
                'fake_args': ["b0gUs", "lorem.changes", "ipsum.changes"],
                'expected_stderr_output': "No host b0gUs found in config.",
                'expected_exception': FakeSystemExit,
                'expected_exit_status': EXIT_STATUS_FAILURE,
                }),
            ('host-from-command-line check-only', {
                'config_scenario_name': "exist-simple-host-three",
                'fake_options_mapping': {'check_only': True},
                'fake_args': ["b0gUs", "lorem.changes", "ipsum.changes"],
                'expected_stderr_output': "No host b0gUs found in config.",
                }),
            ]

    def test_emits_expected_debug_message(self):
        """ Should emit expected debug message. """
        self.fake_options.debug = True
        try:
            self.function_to_test(**self.test_args)
        except FakeSystemExit:
            pass
        if hasattr(self, 'expected_stdout_output'):
            self.assertIn(self.expected_stdout_output, sys.stdout.getvalue())
        if hasattr(self, 'expected_stderr_output'):
            self.assertIn(self.expected_stderr_output, sys.stderr.getvalue())

    def test_calls_sys_exit_when_host_not_in_config(self):
        """ Should call `sys.exit` when named host not in config. """
        if not hasattr(self, 'expected_exception'):
            self.skipTest("No expected exception for this scenario")
        with testtools.ExpectedException(self.expected_exception):
            self.function_to_test(**self.test_args)
        sys.exit.assert_called_with(self.expected_exit_status)


class main_check_upload_logfile_CallTestCase(
        testscenarios.WithScenarios,
        main_TestCase):
    """ Test cases for `main` function calling `check_upload_logfile`. """

    scenarios = [
            ('default', {}),
            ('command-line-option-check-only', {
                'fake_options_mapping': {'check_only': True},
                'expected_check_only': True,
                }),
            ('command-line-option-lintian', {
                'fake_options_mapping': {'run_lintian': True},
                'expected_lintian': True,
                }),
            ('command-line-option-force', {
                'fake_options_mapping': {'force_upload': True},
                'expected_force_upload': True,
                }),
            ('command-line-options-three', {
                'fake_options_mapping': {
                    'force_upload': True,
                    'run_lintian': True,
                    'check_only': True,
                    },
                'expected_check_only': True,
                'expected_lintian': True,
                'expected_force_upload': True,
                }),
            ]

    def test_calls_check_upload_logfile_with_expected_args(self):
        """ Should invoke `check_upload_logfile` with expected args. """
        self.function_to_test(**self.test_args)
        expected_args = (
                self.changes_file_double.path, self.test_host,
                self.runtime_config_parser.get(self.test_host, 'fqdn'),
                getattr(self, 'expected_check_only', False),
                getattr(self, 'expected_lintian', False),
                getattr(self, 'expected_force_upload', False),
                unittest.mock.ANY)
        dput.dput.check_upload_logfile.assert_called_with(*expected_args)


class main_verify_files_CallTestCase(
        testscenarios.WithScenarios,
        main_TestCase):
    """ Test cases for `main` function calling `verify_files`. """

    scenarios = [
            ('default', {}),
            ('command-line-option-check-only', {
                'fake_options_mapping': {'check_only': True},
                'expected_check_only': True,
                }),
            ('command-line-option-check-version', {
                'fake_options_mapping': {'check_version': True},
                'expected_check_version': True,
                }),
            ('command-line-option-unchecked', {
                'fake_options_mapping': {'allow_unsigned_uploads': True},
                'expected_allow_unsigned_uploads': True,
                }),
            ('command-line-options-three', {
                'fake_options_mapping': {
                    'check_only': True,
                    'check_version': True,
                    'allow_unsigned_uploads': True,
                    },
                'expected_check_only': True,
                'expected_check_version': True,
                'expected_allow_unsigned_uploads': True,
                }),
            ]

    def test_calls_verify_files_with_expected_args(self):
        """ Should invoke `verify_files` with expected args. """
        self.function_to_test(**self.test_args)
        expected_args = (
                os.path.dirname(self.changes_file_double.path),
                os.path.basename(self.changes_file_double.path),
                self.test_host,
                self.runtime_config_parser,
                getattr(self, 'expected_check_only', False),
                getattr(self, 'expected_check_version', False),
                getattr(self, 'expected_allow_unsigned_uploads', False),
                unittest.mock.ANY)
        dput.dput.verify_files.assert_called_with(*expected_args)


class main_run_lintian_test_CallTestCase(
        testscenarios.WithScenarios,
        main_TestCase):
    """ Test cases for `main` function calling `run_lintian_test`. """

    scenarios = [
            ('option-from-command-line', {
                'fake_options_mapping': {'run_lintian': True},
                }),
            ('option-from-config', {
                'config_run_lintian': True,
                }),
            ]

    def test_calls_run_lintian_test_with_expected_args(self):
        """ Should invoke `run_lintian_test` with expected args. """
        self.function_to_test(**self.test_args)
        expected_args = (self.changes_file_double.path,)
        dput.dput.run_lintian_test.assert_called_with(*expected_args)


class main_run_lintian_test_NoCallTestCase(
        testscenarios.WithScenarios,
        main_TestCase):
    """ Test cases for `main` function omitting `run_lintian_test`. """

    def test_emits_warning_message_when_check_only(self):
        """ Should emit warning message when `--check-only`. """
        self.fake_options_mapping.update({'check_only': True})
        self.set_fake_options()
        self.function_to_test(**self.test_args)
        expected_output = (
                "Warning: The option -o does not automatically include \n"
                "a lintian run any more. Please use the option -ol if \n"
                "you want to include running lintian in your checking.")
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_omits_run_lintian_test(self):
        """ Should invoke `run_lintian_test` with specified args. """
        self.function_to_test(**self.test_args)
        self.assertFalse(dput.dput.run_lintian_test.called)


class main_UploadHookCommandsTestCase(main_TestCase):
    """ Test cases for `main` function upload hook commands. """

    def test_calls_execute_command_with_pre_upload_command(self):
        """ Should invoke `execute_command` when `pre_upload_command`. """
        test_command = self.getUniqueString()
        self.runtime_config_parser.set(
                self.test_host, 'pre_upload_command', test_command)
        self.function_to_test(**self.test_args)
        expected_command = test_command
        dput.dput.execute_command.assert_called_with(
                expected_command, "pre", unittest.mock.ANY)

    def test_calls_execute_command_with_post_upload_command(self):
        """ Should invoke `execute_command` when `post_upload_command`. """
        test_command = self.getUniqueString()
        self.runtime_config_parser.set(
                self.test_host, 'post_upload_command', test_command)
        self.function_to_test(**self.test_args)
        expected_command = test_command
        dput.dput.execute_command.assert_called_with(
                expected_command, "post", unittest.mock.ANY)


class main_SimulateTestCase(
        testscenarios.WithScenarios,
        main_TestCase):
    """ Test cases for `main` function when ‘--simulate’ option. """

    scenarios = [
            ('simulate', {
                'fake_options_mapping': {'simulate': True},
                }),
            ('simulate three-files', {
                'fake_options_mapping': {'simulate': True},
                'files_to_upload': [tempfile.mktemp() for __ in range(3)],
                }),
            ('simulate dinstall', {
                'config_run_dinstall': True,
                'fake_options_mapping': {'simulate': True},
                }),
            ]

    def test_omits_upload_method(self):
        """ Should omit call to upload method function. """
        expected_method_name = self.runtime_config_parser.get(
                self.test_host, 'method')
        expected_method_func = self.upload_methods[expected_method_name]
        self.function_to_test(**self.test_args)
        self.assertFalse(expected_method_func.called)

    def test_omits_create_upload_file(self):
        """ Should omit call to `create_upload_file` function. """
        self.function_to_test(**self.test_args)
        self.assertFalse(dput.dput.create_upload_file.called)

    def test_omits_dinstall_caller(self):
        """ Should omit call to `create_upload_log` function. """
        self.function_to_test(**self.test_args)
        self.assertFalse(dput.dput.dinstall_caller.called)


class main_DelayedQueueTestCase(
        testscenarios.WithScenarios,
        main_TestCase):
    """ Test cases for `main` function, delayed queue processing. """

    delayed_scenarios = [
            ('default-delayed', {
                'config_default_delayed': "",
                'config_delayed': None,
                'expected_delay': None,
                }),
            ('config-default-option-delayed-0', {
                'config_default_delayed': "0",
                'config_delayed': None,
                'expected_output': "Uploading to DELAYED/0-day.",
                'expected_delay': "0-day",
                }),
            ('config-default-option-delayed-5', {
                'config_default_delayed': "5",
                'config_delayed': None,
                'expected_delay': "5-day",
                }),
            ('config-option-delayed-0', {
                'config_delayed': "0",
                'expected_output': "Uploading to DELAYED/0-day.",
                'expected_delay': "0-day",
                }),
            ('config-option-delayed-5', {
                'config_delayed': "5",
                'expected_delay': "5-day",
                }),
            ('command-line-option-delayed-0', {
                'fake_options_mapping': {'delay_upload': "0"},
                'expected_output': "Uploading to DELAYED/0-day.",
                'expected_delay': "0-day",
                }),
            ('command-line-option-delayed-5', {
                'fake_options_mapping': {'delay_upload': "5"},
                'expected_delay': "5-day",
                }),
            ('different-options-config-and-command-line', {
                'config_delayed': "13",
                'fake_options_mapping': {'delay_upload': "5"},
                'expected_delay': "5-day",
                }),
            ]

    incoming_scenarios = [
            ('default-incoming', {
                'expected_incoming_host': "quux",
                }),
            ('config-option-incoming-with-trailing-slash', {
                'config_incoming': "xyzzy/",
                'expected_incoming_host': "xyzzy/",
                }),
            ('config-option-incoming-no-trailing-slash', {
                'config_incoming': "xyzzy",
                'expected_incoming_host': "xyzzy",
                }),
            ]

    scenarios = testscenarios.multiply_scenarios(
            delayed_scenarios, incoming_scenarios)

    def test_emits_expected_queue_message(self):
        """ Should emit expected message for the upload queue. """
        self.function_to_test(**self.test_args)
        expected_output = getattr(self, 'expected_output', "")
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_calls_upload_method_with_expected_incoming_value(self):
        """ Should call the upload method with expected `incoming` value. """
        expected_method_name = self.runtime_config_parser.get(
                self.test_host, 'method')
        expected_method_func = self.upload_methods[expected_method_name]
        expected_incoming = self.expected_incoming_host
        if self.expected_delay is not None:
            expected_incoming = os.path.join(
                    self.expected_incoming_host,
                    "DELAYED", self.expected_delay)
        self.function_to_test(**self.test_args)
        expected_method_func.assert_called_with(
                unittest.mock.ANY, unittest.mock.ANY, expected_incoming,
                unittest.mock.ANY, unittest.mock.ANY, unittest.mock.ANY,
                progress=unittest.mock.ANY, port=unittest.mock.ANY)


class main_UnknownUploadMethodTestCase(
        testscenarios.WithScenarios,
        main_TestCase):
    """ Test cases for `main` function when unknown upload method. """

    scenarios = [
            ('bogus-default-method', {
                'config_extras': {
                    'default': {
                        'method': "b0gUs",
                        },
                    },
                'expected_output': "Unknown upload method: b0gUs",
                }),
            ('bogus-host-method', {
                'config_extras': {
                    'host': {
                        'method': "b0gUs",
                        },
                    },
                'expected_output': "Unknown upload method: b0gUs",
                }),
            ]

    def test_emits_error_message_when_unknown_method(self):
        """ Should emit error message when unknown upload method. """
        try:
            self.function_to_test(**self.test_args)
        except FakeSystemExit:
            pass
        self.assertIn(self.expected_output, sys.stdout.getvalue())

    def test_calls_sys_exit_when_unknown_method(self):
        """ Should call `sys.exit` when unknown upload method. """
        with testtools.ExpectedException(FakeSystemExit):
            self.function_to_test(**self.test_args)
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)


class main_UploadMethodTestCase(
        testscenarios.WithScenarios,
        main_TestCase):
    """ Test cases for `main` function, invoking upload method. """

    method_scenarios = [
            ('method-local', {
                'config_method': "local",
                'config_progress_indicator': 23,
                'expected_args': (
                    "localhost", unittest.mock.ANY, unittest.mock.ANY,
                    unittest.mock.ANY, unittest.mock.ANY,
                    0),
                'expected_kwargs': {'progress': 23},
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
                'expected_kwargs': {'progress': 23, 'port': 21},
                'expected_stdout_output': "D: Using active ftp",
                }),
            ('method-ftp port-custom', {
                'config_method': "ftp",
                'config_fqdn': "foo.example.com:42",
                'config_passive_ftp': False,
                'config_progress_indicator': 23,
                'expected_args': (
                    "foo.example.com", unittest.mock.ANY, unittest.mock.ANY,
                    unittest.mock.ANY, unittest.mock.ANY,
                    False),
                'expected_kwargs': {'progress': 23, 'port': 42},
                'expected_stdout_output': "D: Using active ftp",
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
                'expected_kwargs': {'progress': 23, 'port': 21},
                'expected_stdout_output': "D: Using passive ftp",
                }),
            ('method-ftp command-line-passive-mode', {
                'config_method': "ftp",
                'config_fqdn': "foo.example.com",
                'config_progress_indicator': 23,
                'fake_options_mapping': {'ftp_passive_mode': True},
                'expected_args': (
                    "foo.example.com", unittest.mock.ANY, unittest.mock.ANY,
                    unittest.mock.ANY, unittest.mock.ANY,
                    True),
                'expected_kwargs': {'progress': 23, 'port': 21},
                'expected_stdout_output': "D: Using passive ftp",
                }),
            ('method-scp', {
                'config_method': "scp",
                'config_fqdn': "foo.example.com",
                'expected_args': (
                    "foo.example.com", unittest.mock.ANY, unittest.mock.ANY,
                    unittest.mock.ANY, unittest.mock.ANY,
                    False, []),
                'expected_kwargs': {},
                'expected_stdout_output': "D: ssh config options:",
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
                'expected_kwargs': {},
                'expected_stdout_output': (
                    "D: Setting compression for scp\n"
                    "D: ssh config options:\n  spam eggs beans"),
                }),
            ]

    isatty_scenarios = [
            ('isatty-true', {
                'os_isatty_return_value': True,
                }),
            ('isatty-false', {
                'os_isatty_return_value': False,
                'progress_indicator_override': 0,
                }),
            ]

    scenarios = testscenarios.multiply_scenarios(
            method_scenarios, isatty_scenarios)

    for (scenario_name, scenario) in scenarios:
        if (
                'progress' in scenario['expected_kwargs']
                and 'progress_indicator_override' in scenario
                ):
            expected_kwargs = scenario['expected_kwargs'].copy()
            expected_kwargs['progress'] = scenario[
                    'progress_indicator_override']
            scenario['expected_kwargs'] = expected_kwargs
            del expected_kwargs
    del scenario_name, scenario

    def test_emits_expected_debug_message(self):
        """ Should emit expected debug message. """
        self.fake_options.debug = True
        self.function_to_test(**self.test_args)
        if hasattr(self, 'expected_stdout_output'):
            self.assertIn(self.expected_stdout_output, sys.stdout.getvalue())

    def test_calls_upload_method_with_expected_args(self):
        """ Should call upload method function with expected args. """
        expected_method_name = self.runtime_config_parser.get(
                self.test_host, 'method')
        expected_method_func = self.upload_methods[expected_method_name]
        self.function_to_test(**self.test_args)
        expected_method_func.assert_called_with(
                *self.expected_args, **self.expected_kwargs)


class main_UploadLogTestCase(
        testscenarios.WithScenarios,
        main_TestCase):
    """ Test cases for `main` function, creating upload log file. """

    scenarios = [
            ('default', {
                'expect_call': True,
                }),
            ('command-line-disable-option', {
                'fake_options_mapping': {'upload_log': False},
                'expect_call': False,
                }),
            ('command-line-simulate-option', {
                'fake_options_mapping': {'simulate': True},
                'expect_call': False,
                }),
            ]

    def test_calls_create_upload_file_if_specified(self):
        """ Should call `create_upload_file` if specified. """
        self.function_to_test(**self.test_args)
        if self.expect_call:
            expected_args = (
                    os.path.basename(self.changes_file_double.path),
                    self.test_host,
                    self.runtime_config_parser.get(self.test_host, 'fqdn'),
                    os.path.dirname(self.changes_file_double.path),
                    self.files_to_upload,
                    unittest.mock.ANY)
            dput.dput.create_upload_file.assert_called_with(*expected_args)
        else:
            self.assertFalse(dput.dput.create_upload_file.called)


class main_DinstallTestCase(
        testscenarios.WithScenarios,
        main_TestCase):
    """ Test cases for `main` function, invoking ‘dinstall’ command. """

    scenarios = [
            ('option-from-command-line', {
                'fake_options_mapping': {'run_dinstall': True},
                'expected_output': "D: run_dinstall: True",
                }),
            ('option-from-config', {
                'config_run_dinstall': True,
                'expected_output': "D: Host Config: True",
                }),
            ]

    def test_emits_debug_message_for_options(self):
        """ Should emit debug message for options. """
        self.fake_options.debug = True
        self.function_to_test(**self.test_args)
        self.assertIn(self.expected_output, sys.stdout.getvalue())

    def test_calls_dinstall_caller_with_expected_args(self):
        """ Should call `dinstall_caller` with expected args. """
        expected_args = (
                os.path.basename(self.changes_file_double.path),
                self.test_host,
                self.runtime_config_parser.get(self.test_host, 'fqdn'),
                unittest.mock.ANY, unittest.mock.ANY, unittest.mock.ANY)
        self.function_to_test(**self.test_args)
        dput.dput.dinstall_caller.assert_called_with(*expected_args)


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
