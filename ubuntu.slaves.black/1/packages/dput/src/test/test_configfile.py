# test/test_configfile.py
# Part of ‘dput’, a Debian package upload toolkit.
#
# This is free software, and you are welcome to redistribute it under
# certain conditions; see the end of this file for copyright
# information, grant of license, and disclaimer of warranty.

""" Unit tests for config file behaviour. """

import builtins
import configparser
import doctest
import io
import os
import os.path
import sys
import tempfile
import textwrap
import unittest.mock

import testtools
import testtools.matchers

import dput.dput

from .helper import (
        EXIT_STATUS_FAILURE,
        FakeSystemExit,
        FileDouble,
        patch_system_interfaces,
        setup_file_double_behaviour,
        )


def make_config_from_stream(stream):
    """ Make a ConfigParser parsed configuration from the stream content.

        :param stream: Text stream content of a config file.
        :return: The resulting config if the content parses correctly,
            or ``None``.

        """
    config = configparser.ConfigParser(
            defaults={
                'allow_unsigned_uploads': "false",
                },
            )

    config_file = io.StringIO(stream)
    try:
        config.read_file(config_file)
    except configparser.ParsingError:
        config = None

    return config


def make_config_file_scenarios():
    """ Make a collection of scenarios for testing with config files.

        :return: A collection of scenarios for tests involving config files.

        The collection is a mapping from scenario name to a dictionary of
        scenario attributes.

        """

    runtime_config_file_path = tempfile.mktemp()
    global_config_file_path = os.path.join(os.path.sep, "etc", "dput.cf")
    user_config_file_path = os.path.join(os.path.expanduser("~"), ".dput.cf")

    fake_file_empty = io.StringIO()
    fake_file_bogus = io.StringIO("b0gUs")
    fake_file_minimal = io.StringIO(textwrap.dedent("""\
            [DEFAULT]
            """))
    fake_file_simple = io.StringIO(textwrap.dedent("""\
            [DEFAULT]
            hash = md5
            [foo]
            method = ftp
            fqdn = quux.example.com
            incoming = quux
            check_version = false
            allow_unsigned_uploads = false
            allowed_distributions =
            run_dinstall = false
            """))
    fake_file_simple_host_three = io.StringIO(textwrap.dedent("""\
            [DEFAULT]
            hash = md5
            [foo]
            method = ftp
            fqdn = quux.example.com
            incoming = quux
            check_version = false
            allow_unsigned_uploads = false
            allowed_distributions =
            run_dinstall = false
            [bar]
            fqdn = xyzzy.example.com
            incoming = xyzzy
            [baz]
            fqdn = chmrr.example.com
            incoming = chmrr
            """))
    fake_file_method_local = io.StringIO(textwrap.dedent("""\
            [foo]
            method = local
            incoming = quux
            """))
    fake_file_missing_fqdn = io.StringIO(textwrap.dedent("""\
            [foo]
            method = ftp
            incoming = quux
            """))
    fake_file_missing_incoming = io.StringIO(textwrap.dedent("""\
            [foo]
            method = ftp
            fqdn = quux.example.com
            """))
    fake_file_default_not_unsigned = io.StringIO(textwrap.dedent("""\
            [DEFAULT]
            allow_unsigned_uploads = false
            [foo]
            method = ftp
            fqdn = quux.example.com
            """))
    fake_file_default_distribution_only = io.StringIO(textwrap.dedent("""\
            [DEFAULT]
            default_host_main = consecteur
            [ftp-master]
            method = ftp
            fqdn = quux.example.com
            """))
    fake_file_distribution_none = io.StringIO(textwrap.dedent("""\
            [foo]
            method = ftp
            fqdn = quux.example.com
            distributions =
            """))
    fake_file_distribution_one = io.StringIO(textwrap.dedent("""\
            [foo]
            method = ftp
            fqdn = quux.example.com
            distributions = spam
            """))
    fake_file_distribution_three = io.StringIO(textwrap.dedent("""\
            [foo]
            method = ftp
            fqdn = quux.example.com
            distributions = spam,eggs,beans
            """))

    default_scenario_params = {
            'runtime': {
                'file_double_params': dict(
                    path=runtime_config_file_path,
                    fake_file=fake_file_minimal),
                'open_scenario_name': 'okay',
                },
            'global': {
                'file_double_params': dict(
                    path=global_config_file_path,
                    fake_file=fake_file_minimal),
                'open_scenario_name': 'okay',
                },
            'user': {
                'file_double_params': dict(
                    path=user_config_file_path,
                    fake_file=fake_file_minimal),
                'open_scenario_name': 'okay',
                },
            }

    scenarios = {
            'default': {
                'configs_by_name': {
                    'runtime': None,
                    },
                },
            'not-exist': {
                'configs_by_name': {
                    'runtime': {
                        'open_scenario_name': 'nonexist',
                        },
                    },
                },
            'exist-read-denied': {
                'configs_by_name': {
                    'runtime': {
                        'open_scenario_name': 'read_denied',
                        },
                    },
                },
            'exist-empty': {
                'configs_by_name': {
                    'runtime': {
                        'file_double_params': dict(
                            path=runtime_config_file_path,
                            fake_file=fake_file_empty),
                        },
                    },
                },
            'exist-invalid': {
                'configs_by_name': {
                    'runtime': {
                        'file_double_params': dict(
                            path=runtime_config_file_path,
                            fake_file=fake_file_bogus),
                        },
                    },
                },
            'exist-minimal': {},
            'exist-simple': {
                'configs_by_name': {
                    'runtime': {
                        'file_double_params': dict(
                            path=runtime_config_file_path,
                            fake_file=fake_file_simple),
                        'test_section': "foo",
                        },
                    },
                },
            'exist-simple-host-three': {
                'configs_by_name': {
                    'runtime': {
                        'file_double_params': dict(
                            path=runtime_config_file_path,
                            fake_file=fake_file_simple_host_three),
                        'test_section': "foo",
                        },
                    },
                },
            'exist-method-local': {
                'configs_by_name': {
                    'runtime': {
                        'file_double_params': dict(
                            path=runtime_config_file_path,
                            fake_file=fake_file_method_local),
                        'test_section': "foo",
                        },
                    },
                },
            'exist-missing-fqdn': {
                'configs_by_name': {
                    'runtime': {
                        'file_double_params': dict(
                            path=runtime_config_file_path,
                            fake_file=fake_file_missing_fqdn),
                        'test_section': "foo",
                        },
                    },
                },
            'exist-missing-incoming': {
                'configs_by_name': {
                    'runtime': {
                        'file_double_params': dict(
                            path=runtime_config_file_path,
                            fake_file=fake_file_missing_incoming),
                        'test_section': "foo",
                        },
                    },
                },
            'exist-default-not-unsigned': {
                'configs_by_name': {
                    'runtime': {
                        'file_double_params': dict(
                            path=runtime_config_file_path,
                            fake_file=fake_file_default_not_unsigned),
                        'test_section': "foo",
                        },
                    },
                },
            'exist-default-distribution-only': {
                'configs_by_name': {
                    'runtime': {
                        'file_double_params': dict(
                            path=runtime_config_file_path,
                            fake_file=fake_file_default_distribution_only),
                        'test_section': "foo",
                        },
                    },
                },
            'exist-distribution-none': {
                'configs_by_name': {
                    'runtime': {
                        'file_double_params': dict(
                            path=runtime_config_file_path,
                            fake_file=fake_file_distribution_none),
                        'test_section': "foo",
                        },
                    },
                },
            'exist-distribution-one': {
                'configs_by_name': {
                    'runtime': {
                        'file_double_params': dict(
                            path=runtime_config_file_path,
                            fake_file=fake_file_distribution_one),
                        'test_section': "foo",
                        },
                    },
                },
            'exist-distribution-three': {
                'configs_by_name': {
                    'runtime': {
                        'file_double_params': dict(
                            path=runtime_config_file_path,
                            fake_file=fake_file_distribution_three),
                        'test_section': "foo",
                        },
                    },
                },
            'global-config-not-exist': {
                'configs_by_name': {
                    'global': {
                        'open_scenario_name': 'nonexist',
                        },
                    'runtime': None,
                    },
                },
            'global-config-read-denied': {
                'configs_by_name': {
                    'global': {
                        'open_scenario_name': 'read_denied',
                        },
                    'runtime': None,
                    },
                },
            'user-config-not-exist': {
                'configs_by_name': {
                    'user': {
                        'open_scenario_name': 'nonexist',
                        },
                    'runtime': None,
                    },
                },
            'all-not-exist': {
                'configs_by_name': {
                    'global': {
                        'open_scenario_name': 'nonexist',
                        },
                    'user': {
                        'open_scenario_name': 'nonexist',
                        },
                    'runtime': None,
                    },
                },
            }

    for scenario in scenarios.values():
        scenario['empty_file'] = fake_file_empty
        if 'configs_by_name' not in scenario:
            scenario['configs_by_name'] = {}
        for (config_name, default_params) in default_scenario_params.items():
            if config_name not in scenario['configs_by_name']:
                params = default_params
            elif scenario['configs_by_name'][config_name] is None:
                continue
            else:
                params = default_params.copy()
                params.update(scenario['configs_by_name'][config_name])
            params['file_double'] = FileDouble(**params['file_double_params'])
            params['file_double'].set_open_scenario(
                    params['open_scenario_name'])
            params['config'] = make_config_from_stream(
                    params['file_double'].fake_file.getvalue())
            scenario['configs_by_name'][config_name] = params

    return scenarios


def get_file_doubles_from_config_file_scenarios(scenarios):
    """ Get the `FileDouble` instances from config file scenarios.

        :param scenarios: Collection of config file scenarios.
        :return: Collection of `FileDouble` instances.

        """
    doubles = set()
    for scenario in scenarios:
        configs_by_name = scenario['configs_by_name']
        doubles.update(
                configs_by_name[config_name]['file_double']
                for config_name in ['global', 'user', 'runtime']
                if configs_by_name[config_name] is not None)

    return doubles


def setup_config_file_fixtures(testcase):
    """ Set up fixtures for config file doubles. """

    scenarios = make_config_file_scenarios()
    testcase.config_file_scenarios = scenarios

    setup_file_double_behaviour(
            testcase,
            get_file_doubles_from_config_file_scenarios(scenarios.values()))


def set_config(testcase, name):
    """ Set the config scenario for a specific test case. """
    scenarios = make_config_file_scenarios()
    testcase.config_scenario = scenarios[name]


def patch_runtime_config_options(testcase):
    """ Patch specific options in the runtime config. """
    config_params_by_name = testcase.config_scenario['configs_by_name']
    runtime_config_params = config_params_by_name['runtime']
    testcase.runtime_config_parser = runtime_config_params['config']

    def maybe_set_option(
            parser, section_name, option_name, value, default=""):
        if value is not None:
            if value is NotImplemented:
                # No specified value. Set a default.
                value = default
            parser.set(section_name, option_name, str(value))
        else:
            # Specifically requested *no* value for the option.
            parser.remove_option(section_name, option_name)

    if testcase.runtime_config_parser is not None:
        testcase.test_host = runtime_config_params.get(
                'test_section', None)

        maybe_set_option(
                testcase.runtime_config_parser,
                'DEFAULT', 'method',
                getattr(testcase, 'config_default_method', "ftp"))
        maybe_set_option(
                testcase.runtime_config_parser,
                'DEFAULT', 'login',
                getattr(testcase, 'config_default_login', "username"))
        maybe_set_option(
                testcase.runtime_config_parser,
                'DEFAULT', 'scp_compress',
                str(getattr(testcase, 'config_default_scp_compress', False)))
        maybe_set_option(
                testcase.runtime_config_parser,
                'DEFAULT', 'ssh_config_options',
                getattr(testcase, 'config_default_ssh_config_options', ""))
        maybe_set_option(
                testcase.runtime_config_parser,
                'DEFAULT', 'distributions',
                getattr(testcase, 'config_default_distributions', ""))
        maybe_set_option(
                testcase.runtime_config_parser,
                'DEFAULT', 'incoming',
                getattr(testcase, 'config_default_incoming', "quux"))
        maybe_set_option(
                testcase.runtime_config_parser,
                'DEFAULT', 'allow_dcut',
                str(getattr(testcase, 'config_default_allow_dcut', True)))

        config_default_default_host_main = getattr(
                testcase, 'config_default_default_host_main', NotImplemented)
        maybe_set_option(
                testcase.runtime_config_parser,
                'DEFAULT', 'default_host_main',
                config_default_default_host_main,
                default="")
        config_default_delayed = getattr(
                testcase, 'config_default_delayed', NotImplemented)
        maybe_set_option(
                testcase.runtime_config_parser,
                'DEFAULT', 'delayed', config_default_delayed,
                default=7)

        for section_name in testcase.runtime_config_parser.sections():
            maybe_set_option(
                    testcase.runtime_config_parser,
                    section_name, 'method',
                    getattr(testcase, 'config_method', "ftp"))
            maybe_set_option(
                    testcase.runtime_config_parser,
                    section_name, 'fqdn',
                    getattr(testcase, 'config_fqdn', "quux.example.com"))
            maybe_set_option(
                    testcase.runtime_config_parser,
                    section_name, 'passive_ftp',
                    str(getattr(testcase, 'config_passive_ftp', False)))
            maybe_set_option(
                    testcase.runtime_config_parser,
                    section_name, 'run_lintian',
                    str(getattr(testcase, 'config_run_lintian', False)))
            maybe_set_option(
                    testcase.runtime_config_parser,
                    section_name, 'run_dinstall',
                    str(getattr(testcase, 'config_run_dinstall', False)))
            maybe_set_option(
                    testcase.runtime_config_parser,
                    section_name, 'pre_upload_command',
                    getattr(testcase, 'config_pre_upload_command', ""))
            maybe_set_option(
                    testcase.runtime_config_parser,
                    section_name, 'post_upload_command',
                    getattr(testcase, 'config_post_upload_command', ""))
            maybe_set_option(
                    testcase.runtime_config_parser,
                    section_name, 'progress_indicator',
                    str(getattr(testcase, 'config_progress_indicator', 0)))
            maybe_set_option(
                    testcase.runtime_config_parser,
                    section_name, 'allow_dcut',
                    str(getattr(testcase, 'config_allow_dcut', True)))
            if hasattr(testcase, 'config_incoming'):
                testcase.runtime_config_parser.set(
                        section_name, 'incoming', testcase.config_incoming)
            config_delayed = getattr(
                    testcase, 'config_delayed', NotImplemented)
            maybe_set_option(
                    testcase.runtime_config_parser,
                    section_name, 'delayed', config_delayed,
                    default=9)

        for (section_type, options) in (
                getattr(testcase, 'config_extras', {}).items()):
            section_name = {
                    'default': "DEFAULT",
                    'host': testcase.test_host,
                    }[section_type]
            for (option_name, option_value) in options.items():
                maybe_set_option(
                        testcase.runtime_config_parser,
                        section_name, option_name, option_value)


class read_configs_TestCase(testtools.TestCase):
    """ Test cases for `read_config` function. """

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()
        patch_system_interfaces(self)
        setup_config_file_fixtures(self)

        self.test_configparser = configparser.ConfigParser()
        self.mock_configparser_class = unittest.mock.Mock(
                'ConfigParser',
                return_value=self.test_configparser)

        patcher_class_configparser = unittest.mock.patch.object(
                configparser, "ConfigParser",
                new=self.mock_configparser_class)
        patcher_class_configparser.start()
        self.addCleanup(patcher_class_configparser.stop)

        self.set_config_file_scenario('exist-minimal')
        self.set_test_args()

    def set_config_file_scenario(self, name):
        """ Set the configuration file scenario for this test case. """
        self.config_file_scenario = self.config_file_scenarios[name]
        self.configs_by_name = self.config_file_scenario['configs_by_name']
        for config_params in self.configs_by_name.values():
            if config_params is not None:
                config_params['file_double'].register_for_testcase(self)

    def get_path_for_runtime_config_file(self):
        """ Get the path to specify for runtime config file. """
        path = ""
        runtime_config_params = self.configs_by_name['runtime']
        if runtime_config_params is not None:
            runtime_config_file_double = runtime_config_params['file_double']
            path = runtime_config_file_double.path
        return path

    def set_test_args(self):
        """ Set the arguments for the test call to the function. """
        runtime_config_file_path = self.get_path_for_runtime_config_file()
        self.test_args = dict(
                extra_config=runtime_config_file_path,
                debug=False,
                )

    def test_creates_new_parser(self):
        """ Should invoke the `ConfigParser` constructor. """
        dput.dput.read_configs(**self.test_args)
        configparser.ConfigParser.assert_called_with()

    def test_returns_expected_configparser(self):
        """ Should return expected `ConfigParser` instance. """
        result = dput.dput.read_configs(**self.test_args)
        self.assertEqual(self.test_configparser, result)

    def test_sets_default_option_values(self):
        """ Should set values for options, in section 'DEFAULT'. """
        option_names = set([
                'login',
                'method',
                'hash',
                'allow_unsigned_uploads',
                'allow_dcut',
                'distributions',
                'allowed_distributions',
                'run_lintian',
                'run_dinstall',
                'check_version',
                'scp_compress',
                'default_host_main',
                'post_upload_command',
                'pre_upload_command',
                'ssh_config_options',
                'passive_ftp',
                'progress_indicator',
                'delayed',
                ])
        result = dput.dput.read_configs(**self.test_args)
        self.assertTrue(option_names.issubset(set(result.defaults().keys())))

    def test_opens_default_config_files(self):
        """ Should open the default config files. """
        self.set_config_file_scenario('default')
        self.set_test_args()
        dput.dput.read_configs(**self.test_args)
        expected_calls = [
                unittest.mock.call(
                    self.configs_by_name[config_name]['file_double'].path)
                for config_name in ['global', 'user']]
        builtins.open.assert_has_calls(expected_calls)

    def test_opens_specified_config_file(self):
        """ Should open the specified config file. """
        dput.dput.read_configs(**self.test_args)
        builtins.open.assert_called_with(
                self.configs_by_name['runtime']['file_double'].path)

    def test_emits_debug_message_on_opening_config_file(self):
        """ Should emit a debug message when opening the config file. """
        self.test_args['debug'] = True
        config_file_double = self.configs_by_name['runtime']['file_double']
        dput.dput.read_configs(**self.test_args)
        expected_output = textwrap.dedent("""\
                D: Parsing Configuration File {path}
                """).format(path=config_file_double.path)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_emits_no_skip_message_when_debug_false(self):
        """ Should not emit a “skipping” message when `debug` is false. """
        self.set_config_file_scenario('global-config-not-exist')
        self.set_test_args()
        config_file_double = self.configs_by_name['global']['file_double']
        self.test_args['debug'] = False
        dput.dput.read_configs(**self.test_args)
        expected_calls = [
                unittest.mock.call(config_file_double.path)]
        unwanted_output = "skipping"
        builtins.open.assert_has_calls(expected_calls)
        self.assertNotIn(unwanted_output, sys.stderr.getvalue())

    def test_skips_file_if_not_exist(self):
        """ Should skip a config file if it doesn't exist. """
        self.set_config_file_scenario('global-config-not-exist')
        self.set_test_args()
        config_file_double = self.configs_by_name['global']['file_double']
        self.test_args['debug'] = True
        dput.dput.read_configs(**self.test_args)
        expected_calls = [
                unittest.mock.call(config_file_double.path)]
        expected_output = textwrap.dedent("""\
                No such file ...: {path}, skipping
                """).format(path=config_file_double.path)
        builtins.open.assert_has_calls(expected_calls)
        self.assertThat(
                sys.stderr.getvalue(),
                testtools.matchers.DocTestMatches(
                    expected_output, flags=doctest.ELLIPSIS))

    def test_skips_file_if_permission_denied(self):
        """ Should skip a config file if read permission is denied.. """
        self.set_config_file_scenario('global-config-read-denied')
        self.set_test_args()
        config_file_double = self.configs_by_name['global']['file_double']
        self.test_args['debug'] = True
        dput.dput.read_configs(**self.test_args)
        expected_calls = [
                unittest.mock.call(config_file_double.path)]
        expected_output = textwrap.dedent("""\
                Read denied on ...: {path}, skipping
                """).format(path=config_file_double.path)
        builtins.open.assert_has_calls(expected_calls)
        self.assertThat(
                sys.stderr.getvalue(),
                testtools.matchers.DocTestMatches(
                    expected_output, flags=doctest.ELLIPSIS))

    def test_calls_sys_exit_if_no_config_files(self):
        """ Should call `sys.exit` if unable to open any config files. """
        self.set_config_file_scenario('all-not-exist')
        self.set_test_args()
        with testtools.ExpectedException(FakeSystemExit):
            dput.dput.read_configs(**self.test_args)
        expected_output = textwrap.dedent("""\
                Error: Could not open any configfile, tried ...
                """)
        self.assertThat(
                sys.stderr.getvalue(),
                testtools.matchers.DocTestMatches(
                    expected_output, flags=doctest.ELLIPSIS))
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)

    def test_calls_sys_exit_if_config_parsing_error(self):
        """ Should call `sys.exit` if a parsing error occurs. """
        self.set_config_file_scenario('exist-invalid')
        self.set_test_args()
        self.test_args['debug'] = True
        with testtools.ExpectedException(FakeSystemExit):
            dput.dput.read_configs(**self.test_args)
        expected_output = textwrap.dedent("""\
                Error parsing config file:
                ...
                """)
        self.assertThat(
                sys.stderr.getvalue(),
                testtools.matchers.DocTestMatches(
                    expected_output, flags=doctest.ELLIPSIS))
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)

    def test_sets_fqdn_option_if_local_method(self):
        """ Should set “fqdn” option for “local” method. """
        self.set_config_file_scenario('exist-method-local')
        self.set_test_args()
        result = dput.dput.read_configs(**self.test_args)
        runtime_config_params = self.configs_by_name['runtime']
        test_section = runtime_config_params['test_section']
        self.assertTrue(result.has_option(test_section, "fqdn"))

    def test_exits_with_error_if_missing_fqdn(self):
        """ Should exit with error if config is missing 'fqdn'. """
        self.set_config_file_scenario('exist-missing-fqdn')
        self.set_test_args()
        with testtools.ExpectedException(FakeSystemExit):
            dput.dput.read_configs(**self.test_args)
        expected_output = textwrap.dedent("""\
                Config error: {host} must have a fqdn set
                """).format(host="foo")
        self.assertIn(expected_output, sys.stderr.getvalue())
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)

    def test_exits_with_error_if_missing_incoming(self):
        """ Should exit with error if config is missing 'incoming'. """
        self.set_config_file_scenario('exist-missing-incoming')
        self.set_test_args()
        with testtools.ExpectedException(FakeSystemExit):
            dput.dput.read_configs(**self.test_args)
        expected_output = textwrap.dedent("""\
                Config error: {host} must have an incoming directory set
                """).format(host="foo")
        self.assertIn(expected_output, sys.stderr.getvalue())
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)


class print_config_TestCase(testtools.TestCase):
    """ Test cases for `print_config` function. """

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()
        patch_system_interfaces(self)

    def test_invokes_config_write_to_stdout(self):
        """ Should invoke config's `write` method with `sys.stdout`. """
        test_config = make_config_from_stream("")
        mock_config = unittest.mock.Mock(test_config)
        dput.dput.print_config(mock_config, debug=False)
        mock_config.write.assert_called_with(sys.stdout)


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
