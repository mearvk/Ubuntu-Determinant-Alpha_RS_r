# test/test_dput.py
# Part of ‘dput’, a Debian package upload toolkit.
#
# This is free software, and you are welcome to redistribute it under
# certain conditions; see the end of this file for copyright
# information, grant of license, and disclaimer of warranty.

""" Unit tests for ‘dput’ module. """

import builtins
import doctest
import hashlib
import io
import os
import os.path
import signal
import subprocess
import sys
import tempfile
import textwrap
import unittest.mock

import gpg
import testscenarios
import testtools
import testtools.matchers

import dput.crypto
import dput.dput
from dput.helper import dputhelper

from .helper import (
        ARG_ANY,
        EXIT_STATUS_FAILURE,
        FakeSystemExit,
        FileDouble,
        SubprocessDouble,
        make_fake_file_scenarios,
        make_unique_slug,
        patch_os_access,
        patch_os_path_exists,
        patch_signal_signal,
        patch_subprocess_call,
        patch_subprocess_check_call,
        patch_subprocess_popen,
        patch_system_interfaces,
        set_fake_file_scenario,
        setup_fake_file_fixtures,
        setup_file_double_behaviour,
        )
from .test_changesfile import (
        make_changes_document,
        make_changes_file_scenarios,
        make_upload_files_params,
        set_changes_file_scenario,
        set_fake_upload_file_paths,
        setup_changes_file_fixtures,
        setup_upload_file_fixtures,
        )
from .test_configfile import (
        patch_runtime_config_options,
        set_config,
        )


class hexify_string_TestCase(
        testscenarios.WithScenarios,
        testtools.TestCase):
    """ Success test cases for `hexify_string` function. """

    scenarios = [
            ('empty', {
                'input_bytes': b"",
                'expected_result': str(""),
                }),
            ('nul', {
                'input_bytes': b"\x00",
                'expected_result': str("00"),
                }),
            ('ASCII text', {
                'input_bytes': (
                    b"Lorem ipsum dolor sit amet"
                    ),
                'expected_result': str(
                    "4c6f72656d20697073756d20646f6c6f722073697420616d6574"),
                }),
            ('UTF-8 encoded text', {
                'input_bytes': b"::".join(text.encode('utf-8') for text in [
                    "السّلام عليكم",
                    "⠓⠑⠇⠇⠕",
                    "你好",
                    "Hello",
                    "Γειά σας",
                    "שלום",
                    "नमस्ते",
                    "こんにちは",
                    "안녕하세요",
                    "Здра́вствуйте",
                    "வணக்கம்",
                    ]),
                'expected_result': str("3a3a").join([
                    "d8a7d984d8b3d991d984d8a7d98520d8b9d984d98ad983d985",
                    "e2a093e2a091e2a087e2a087e2a095",
                    "e4bda0e5a5bd",
                    "48656c6c6f",
                    "ce93ceb5ceb9ceac20cf83ceb1cf82",
                    "d7a9d79cd795d79d",
                    "e0a4a8e0a4aee0a4b8e0a58de0a4a4e0a587",
                    "e38193e38293e381abe381a1e381af",
                    "ec9588eb8595ed9598ec84b8ec9a94",
                    "d097d0b4d180d0b0cc81d0b2d181d182d0b2d183d0b9d182d0b5",
                    "e0aeb5e0aea3e0ae95e0af8de0ae95e0aeaee0af8d",
                    ]),
                }),
            ]

    def test_returns_expected_result_for_input(self):
        """ Should return expected result for input. """
        result = dput.dput.hexify_string(self.input_bytes)
        self.assertEqual(self.expected_result, result)


class checksum_test_TestCase(
        testscenarios.WithScenarios,
        testtools.TestCase):
    """ Base for test cases for `checksum_test` function. """

    scenarios = NotImplemented

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()
        patch_system_interfaces(self)

        setup_fake_file_fixtures(self)
        set_fake_file_scenario(self, self.fake_file_scenario_name)

        file_content = self.file_double.fake_file.getvalue().encode('utf-8')
        self.file_double.fake_file = io.BytesIO(file_content)

        self.set_test_args()

    def set_test_args(self):
        """ Set the arguments for the test call to the function. """
        self.test_args = dict(
                filename=self.file_double.path,
                hash_name=self.hash_name,
                )


class checksum_test_SuccessTestCase(checksum_test_TestCase):
    """ Success test cases for `checksum_test` function. """

    hash_scenarios = [
            ('md5', {
                'hash_name': "md5",
                'test_hash_func': hashlib.md5,
                }),
            ('sha1', {
                'hash_name': "sha1",
                'test_hash_func': hashlib.sha1,
                }),
            ]

    fake_file_scenarios = list(
            (name, scenario)
            for (name, scenario) in make_fake_file_scenarios().items()
            if not name.startswith('error'))

    scenarios = testscenarios.multiply_scenarios(
            hash_scenarios, fake_file_scenarios)

    def test_returns_expected_result_for_input(self):
        """ Should return expected result for specified inputs. """
        expected_hash = self.test_hash_func(
                self.file_double.fake_file.getvalue())
        expected_result = expected_hash.hexdigest()
        result = dput.dput.checksum_test(**self.test_args)
        self.assertEqual(expected_result, result)


class checksum_test_ErrorTestCase(checksum_test_TestCase):
    """ Error test cases for `checksum_test` function. """

    hash_scenarios = [
            ('md5', {
                'hash_name': "md5",
                }),
            ]

    fake_file_scenarios = list(
            (name, scenario)
            for (name, scenario) in make_fake_file_scenarios().items()
            if name.startswith('error'))

    scenarios = testscenarios.multiply_scenarios(
            hash_scenarios, fake_file_scenarios)

    def test_calls_sys_exit_if_error_reading_file(self):
        """ Should call `sys.exit` if unable to read the file. """
        set_fake_file_scenario(self, 'error-read-denied')
        with testtools.ExpectedException(FakeSystemExit):
            dput.dput.checksum_test(**self.test_args)
        expected_output = textwrap.dedent("""\
                Can't open {path}
                """).format(path=self.file_double.path)
        self.assertIn(expected_output, sys.stdout.getvalue())
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)


class verify_signature_TestCase(
        testscenarios.WithScenarios,
        testtools.TestCase):
    """ Base for test cases for `verify_signature` function. """

    scenarios = NotImplemented

    default_args = dict(
            host="foo",
            check_only=False,
            allow_unsigned_uploads=False,
            binary_upload=False,
            debug=None,
            )

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()
        patch_system_interfaces(self)

        set_config(
                self,
                getattr(self, 'config_scenario_name', 'exist-simple'))
        patch_runtime_config_options(self)

        self.set_changes_file_scenario('okay')
        self.set_dsc_file_scenario('okay')
        self.set_test_args()

        setup_fake_file_fixtures(self)
        set_fake_file_scenario(self, 'exist-minimal')

        self.patch_check_file_signature()

    def patch_check_file_signature(self):
        """ Patch the `check_file_signature` function for this test case. """
        func_patcher = unittest.mock.patch.object(
                dput.crypto, "check_file_signature", autospec=True)
        func_patcher.start()
        self.addCleanup(func_patcher.stop)

    def set_changes_file_scenario(self, name):
        """ Set the changes file scenario for this test case. """
        file_double = FileDouble(tempfile.mktemp())
        file_double.set_open_scenario(name)
        file_double.register_for_testcase(self)
        self.changes_file_double = file_double

    def set_dsc_file_scenario(self, name):
        """ Set the source control file scenario for this test case. """
        file_double = FileDouble(tempfile.mktemp())
        file_double.set_open_scenario(name)
        file_double.register_for_testcase(self)
        self.dsc_file_double = file_double

    def set_test_args(self):
        """ Set test args for this test case. """
        extra_args = getattr(self, 'extra_args', {})
        self.test_args = self.default_args.copy()
        self.test_args['config'] = self.runtime_config_parser
        self.test_args['changes_file_path'] = self.changes_file_double.path
        self.test_args['dsc_file_path'] = self.dsc_file_double.path
        self.test_args.update(extra_args)


class verify_signature_DebugMessageTestCase(verify_signature_TestCase):
    """ Test cases for `verify_signature` debug messages. """

    scenarios = [
            ('default', {}),
            ]

    def test_emits_debug_message_showing_files(self):
        """ Should emit a debug message for the specified files. """
        self.test_args['debug'] = True
        dput.dput.verify_signature(**self.test_args)
        expected_output = textwrap.dedent("""\
                D: upload control file: {changes_path}
                D: source control file: {dsc_path}
                """).format(
                    changes_path=self.test_args['changes_file_path'],
                    dsc_path=self.test_args['dsc_file_path'])
        self.assertIn(expected_output, sys.stdout.getvalue())


class verify_signature_ChecksTestCase(verify_signature_TestCase):
    """ Test cases for `verify_signature` checks. """

    scenarios = [
            ('default', {
                'expected_checks': ['changes', 'dsc'],
                }),
            ('source unsigned', {
                'extra_args': {
                    'binary_upload': False,
                    'allow_unsigned_uploads': True,
                    },
                'expected_checks': [],
                }),
            ('source check-only', {
                'extra_args': {
                    'binary_upload': False,
                    'check_only': True,
                    },
                'expected_checks': ['changes', 'dsc'],
                }),
            ('source allow_unsigned_uploads', {
                'extra_args': {
                    'binary_upload': False,
                    },
                'config_scenario_name': 'exist-default-not-unsigned',
                'expected_checks': ['changes', 'dsc'],
                }),
            ('binary unsigned', {
                'extra_args': {
                    'binary_upload': True,
                    'allow_unsigned_uploads': True,
                    },
                'expected_checks': [],
                }),
            ('binary check-only', {
                'extra_args': {
                    'binary_upload': True,
                    'check_only': True,
                    },
                'expected_checks': ['changes'],
                }),
            ('binary allow_unsigned_uploads', {
                'extra_args': {
                    'binary_upload': True,
                    },
                'config_scenario_name': 'exist-default-not-unsigned',
                'expected_checks': ['changes'],
                }),
            ]

    def test_checks_changes_signature_only_when_expected(self):
        """ Should only check the changes document signature if expected. """
        dput.dput.verify_signature(**self.test_args)
        check_call = unittest.mock.call(self.changes_file_double.fake_file)
        if 'changes' in self.expected_checks:
            self.assertIn(
                    check_call,
                    dput.crypto.check_file_signature.call_args_list)
        else:
            self.assertNotIn(
                    check_call,
                    dput.crypto.check_file_signature.call_args_list)

    def test_calls_sys_exit_when_check_file_signature_raises_gpg_error(self):
        """ Should `sys.exit` when `check_file_signature` raises GPG error. """
        if not self.expected_checks:
            self.skipTest("No signature checks requested")
        dput.crypto.check_file_signature.side_effect = gpg.errors.GPGMEError(0)
        with testtools.ExpectedException(FakeSystemExit):
            dput.dput.verify_signature(**self.test_args)
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)

    def test_raises_same_error_when_check_file_signature_raises_error(self):
        """
        Should re-raise `check_file_signature` error when not a GPG error.
        """
        if not self.expected_checks:
            self.skipTest("No signature checks requested")
        test_error = RuntimeError("whoops")
        dput.crypto.check_file_signature.side_effect = test_error
        with testtools.ExpectedException(type(test_error)):
            dput.dput.verify_signature(**self.test_args)

    def test_checks_dsc_signature_only_when_expected(self):
        """ Should only check the ‘dsc’ document signature if expected. """
        dput.dput.verify_signature(**self.test_args)
        check_call = unittest.mock.call(self.dsc_file_double.fake_file)
        if 'dsc' in self.expected_checks:
            self.assertIn(
                    check_call,
                    dput.crypto.check_file_signature.call_args_list)
        else:
            self.assertNotIn(
                    check_call,
                    dput.crypto.check_file_signature.call_args_list)


class create_upload_file_TestCase(
        testscenarios.WithScenarios,
        testtools.TestCase):
    """ Test cases for `create_upload_file` function. """

    scenarios = [
            ('simple', {}),
            ('local', {
                'test_host': "foo",
                'test_fqdn': "localhost",
                }),
            ('log file exists', {
                'fake_file_scenario_name': 'exist-empty',
                'file_access_scenario_name': 'okay',
                'expected_open_mode': 'a',
                }),
            ]

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()
        patch_system_interfaces(self)

        if not hasattr(self, 'test_host'):
            self.test_host = make_unique_slug(self)
            self.test_fqdn = make_unique_slug(self)

        setup_changes_file_fixtures(self)
        set_changes_file_scenario(
                self,
                getattr(self, 'changes_file_scenario_name', 'exist-minimal'))

        set_fake_upload_file_paths(self)
        self.set_test_args()

        setup_fake_file_fixtures(self)
        self.set_fake_file_scenario(
                getattr(self, 'fake_file_scenario_name', 'not-found'))
        if not hasattr(self, 'expected_open_mode'):
            self.expected_open_mode = 'w'

        self.set_upload_log_file_double()
        self.set_upload_log_file_params()

        patch_os_access(self)

    def set_test_args(self):
        """ Set the arguments for the test call to the function. """
        changes_file_name = os.path.basename(self.changes_file_double.path)
        self.package_file_name = (
                os.path.splitext(changes_file_name)[0] + ".source")
        self.test_args = dict(
                changes_file_name=self.package_file_name,
                host=self.test_host,
                fqdn=self.test_fqdn,
                changes_file_directory=os.path.dirname(
                    self.changes_file_double.path),
                files_to_upload=self.fake_upload_file_paths,
                debug=False,
                )

    def set_upload_log_file_double(self):
        """ Set the fake upload log file. """
        changes_file_name = os.path.basename(self.changes_file_double.path)
        changes_file_name_base = os.path.splitext(changes_file_name)[0]
        upload_log_file_name = "{base}.{host}.upload".format(
                base=changes_file_name_base, host=self.test_host)
        self.file_double.path = os.path.join(
                os.path.dirname(self.changes_file_double.path),
                upload_log_file_name)
        self.upload_log_file_double = self.file_double
        self.upload_log_file_double.set_os_access_scenario(
                getattr(
                    self, 'file_access_scenario_name', 'not_exist'))
        self.upload_log_file_double.register_for_testcase(self)

    def set_upload_log_file_params(self):
        """ Set the parameters for the upload log file. """
        self.upload_log_file_double.set_open_scenario('nonexist')

    def set_fake_file_scenario(self, name):
        """ Set the output file scenario for this test case. """
        self.fake_file_scenario = self.fake_file_scenarios[name]
        self.file_double = self.fake_file_scenario['file_double']

    def test_emits_upload_log_debug_message(self):
        """ Should emit debug message for creation of upload log file. """
        self.test_args['debug'] = True
        dput.dput.create_upload_file(**self.test_args)
        expected_output = textwrap.dedent("""\
                D: Writing logfile: {path}
                """).format(path=self.upload_log_file_double.path)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_opens_log_file_with_expected_mode(self):
        """ Should open log file with expected write mode. """
        dput.dput.create_upload_file(**self.test_args)
        builtins.open.assert_called_with(
                self.upload_log_file_double.path, self.expected_open_mode)

    def test_writes_expected_message_for_each_file(self):
        """ Should write log message for each upload file path. """
        with unittest.mock.patch.object(
                self.upload_log_file_double.fake_file, "close", autospec=True):
            dput.dput.create_upload_file(**self.test_args)
        expected_host = self.test_host
        expected_fqdn = self.test_fqdn
        for file_path in self.fake_upload_file_paths:
            expected_message = (
                    "Successfully uploaded {filename}"
                    " to {fqdn} for {host}.\n").format(
                        filename=os.path.basename(file_path),
                        fqdn=expected_fqdn, host=expected_host)
            self.expectThat(
                    self.upload_log_file_double.fake_file.getvalue(),
                    testtools.matchers.Contains(expected_message))

    def test_calls_sys_exit_if_write_denied(self):
        """ Should call `sys.exit` if write permission denied. """
        self.upload_log_file_double.set_os_access_scenario('read_only')
        self.upload_log_file_double.set_open_scenario('write_denied')
        with testtools.ExpectedException(FakeSystemExit):
            dput.dput.create_upload_file(**self.test_args)
        expected_output = textwrap.dedent("""\
                Could not write {path}
                """).format(path=self.upload_log_file_double.path)
        self.assertIn(expected_output, sys.stderr.getvalue())
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)


class run_lintian_test_TestCase(testtools.TestCase):
    """ Test cases for `run_lintian_test` function. """

    scenarios = [
            ('simple', {}),
            ]

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()
        patch_system_interfaces(self)

        patch_signal_signal(self)
        patch_os_access(self)

        setup_changes_file_fixtures(self)
        set_changes_file_scenario(
                self,
                getattr(self, 'changes_file_scenario_name', 'exist-minimal'))

        self.set_test_args()

        self.patch_lintian_program_file()
        self.lintian_program_file_double.set_os_access_scenario('okay')

        patch_subprocess_check_call(self)
        self.set_lintian_subprocess_double()

    def set_test_args(self):
        """ Set the arguments for the test call to the function. """
        self.test_args = dict(
                changes_file=self.changes_file_double.path,
                )

    def patch_lintian_program_file(self):
        """ Patch the Lintian program file for this test case. """
        file_path = '/usr/bin/lintian'
        file_double = FileDouble(file_path)
        file_double.register_for_testcase(self)
        self.lintian_program_file_double = file_double

    def set_lintian_subprocess_double(self):
        """ Set the test double for the Lintian subprocess. """
        argv = [
                os.path.basename(self.lintian_program_file_double.path),
                "-i", ARG_ANY]
        double = SubprocessDouble(
                self.lintian_program_file_double.path, argv=argv)
        double.register_for_testcase(self)
        double.set_subprocess_check_call_scenario('not_found')
        self.lintian_subprocess_double = double

    def test_calls_sys_exit_if_read_denied(self):
        """ Should call `sys.exit` if read permission denied. """
        self.changes_file_double.set_os_access_scenario('denied')
        self.changes_file_double.set_open_scenario('read_denied')
        with testtools.ExpectedException(FakeSystemExit):
            dput.dput.run_lintian_test(**self.test_args)
        expected_output = textwrap.dedent("""\
                Can't read {path}
                """).format(path=self.changes_file_double.path)
        self.assertIn(expected_output, sys.stdout.getvalue())
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)

    def test_emits_message_when_lintian_access_denied(self):
        """ Should emit an explanatory message when Lintian access denied. """
        self.lintian_program_file_double.set_os_access_scenario('denied')
        dput.dput.run_lintian_test(**self.test_args)
        expected_output = textwrap.dedent("""\
                lintian is not installed, skipping package test.
                """)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_omits_check_call_when_lintian_access_denied(self):
        """ Should omit `subprocess.check_call` when Lintian access denied. """
        self.lintian_program_file_double.set_os_access_scenario('denied')
        dput.dput.run_lintian_test(**self.test_args)
        self.assertFalse(subprocess.check_call.called)

    def test_sets_default_signal_handler_for_pipe_signal(self):
        """ Should set default signal handler for PIPE signal. """
        with testtools.ExpectedException(FakeSystemExit):
            dput.dput.run_lintian_test(**self.test_args)
        signal.signal.assert_called_with(signal.SIGPIPE, signal.SIG_DFL)

    def test_calls_check_call_with_expected_args(self):
        """ Should call `subprocess.check_call` with expected arguments. """
        lintian_command_argv = [
                os.path.basename(self.lintian_program_file_double.path),
                "-i", self.changes_file_double.path]
        with testtools.ExpectedException(FakeSystemExit):
            dput.dput.run_lintian_test(**self.test_args)
        subprocess.check_call.assert_called_with(lintian_command_argv)

    def test_resets_signal_handler_for_pipe_signal_when_lintian_success(self):
        """ Should reset signal handler for PIPE when Lintian succeeds. """
        fake_orig_pipe_signal = self.getUniqueInteger()
        signal.signal.return_value = fake_orig_pipe_signal
        subprocess_double = self.lintian_subprocess_double
        subprocess_double.set_subprocess_check_call_scenario('success')
        dput.dput.run_lintian_test(**self.test_args)
        expected_calls = [
                unittest.mock.call(signal.SIGPIPE, signal.SIG_DFL),
                unittest.mock.call(signal.SIGPIPE, fake_orig_pipe_signal),
                ]
        signal.signal.assert_has_calls(expected_calls)

    def test_calls_sys_exit_when_lintian_failure(self):
        """ Should call `sys.exit` when Lintian reports failure. """
        with testtools.ExpectedException(FakeSystemExit):
            dput.dput.run_lintian_test(**self.test_args)
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)

    def test_emits_message_when_lintian_failure(self):
        """ Should emit explanatory message when Lintian reports failure. """
        with testtools.ExpectedException(FakeSystemExit):
            dput.dput.run_lintian_test(**self.test_args)
        expected_output = textwrap.dedent("""\
                ...
                Lintian says this package is not compliant with ...
                ...
                """)
        self.assertThat(
                sys.stdout.getvalue(),
                testtools.matchers.DocTestMatches(
                    expected_output, doctest.ELLIPSIS))


class dinstall_caller_TestCase(
        testtools.TestCase):
    """ Test cases for `dinstall_caller` function. """

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()
        patch_system_interfaces(self)

        patch_subprocess_check_call(self)

        self.set_test_args()

        self.patch_ssh_program_file()
        self.set_subprocess_double()
        self.set_expected_command_argv()

    def patch_ssh_program_file(self):
        """ Patch the SSH program file for this test case. """
        file_path = '/usr/bin/ssh'
        file_double = FileDouble(file_path)
        file_double.register_for_testcase(self)
        self.ssh_program_file_double = file_double

    def set_subprocess_double(self):
        """ Set the test double for the subprocess. """
        argv = [
                os.path.basename(self.ssh_program_file_double.path),
                ARG_ANY,
                "cd", ARG_ANY,
                ";",
                "dinstall", "-n", ARG_ANY]
        double = SubprocessDouble(self.ssh_program_file_double.path, argv=argv)
        double.register_for_testcase(self)
        double.set_subprocess_check_call_scenario('success')
        self.ssh_subprocess_double = double

    def set_test_args(self):
        """ Set the arguments for the test call to the function. """
        self.test_args = dict(
                filename=tempfile.mktemp(),
                host=make_unique_slug(self),
                fqdn=make_unique_slug(self),
                login=make_unique_slug(self),
                incoming=tempfile.mktemp(),
                debug=False,
                )

    def set_expected_command_argv(self):
        """ Set the expected argv for the command. """
        expected_fqdn = self.test_args['fqdn']
        self.expected_host_spec = "{user}@{host}".format(
                user=self.test_args['login'], host=expected_fqdn)
        self.expected_command_argv = [
                os.path.basename(self.ssh_program_file_double.path),
                self.expected_host_spec,
                "cd", self.test_args['incoming'], ";",
                "dinstall", "-n", self.test_args['filename'],
                ]

    def test_calls_check_call_with_expected_args(self):
        """ Should call `subprocess.check_call` with expected arguments. """
        dput.dput.dinstall_caller(**self.test_args)
        subprocess.check_call.assert_called_with(self.expected_command_argv)

    def test_emits_remote_command_debug_message(self):
        """ Should emit a debug message for the remote command. """
        self.test_args['debug'] = True
        dput.dput.dinstall_caller(**self.test_args)
        expected_output = textwrap.dedent("""\
                D: Logging into {user}@{host}:{incoming_path}
                D: dinstall -n {file_path}
                """).format(
                    user=self.test_args['login'], host=self.test_args['host'],
                    incoming_path=self.test_args['incoming'],
                    file_path=self.test_args['filename'])
        self.assertThat(
                sys.stdout.getvalue(),
                testtools.matchers.DocTestMatches(
                    expected_output, doctest.ELLIPSIS))

    def test_calls_sys_exit_when_dinstall_failure(self):
        """ Should call `sys.exit` when Dinstall reports failure. """
        self.ssh_subprocess_double.set_subprocess_check_call_scenario(
                'failure')
        with testtools.ExpectedException(FakeSystemExit):
            dput.dput.dinstall_caller(**self.test_args)
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)

    def test_emits_message_when_dinstall_failure(self):
        """ Should emit explanatory message when Dinstall reports failure. """
        self.ssh_subprocess_double.set_subprocess_check_call_scenario(
                'failure')
        with testtools.ExpectedException(FakeSystemExit):
            dput.dput.dinstall_caller(**self.test_args)
        expected_output = textwrap.dedent("""\
                Error occured while trying to connect, or while attempting ...
                """)
        self.assertThat(
                sys.stdout.getvalue(),
                testtools.matchers.DocTestMatches(
                    expected_output, doctest.ELLIPSIS))


class execute_command_TestCase(
        testtools.TestCase):
    """ Test cases for `execute_command` function. """

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()
        patch_system_interfaces(self)

        self.test_position = make_unique_slug(self)
        self.set_program_file_double()
        self.test_command = self.getUniqueString()

        self.set_test_args()

        patch_subprocess_call(self)
        self.set_upload_command_scenario('simple')

    def set_program_file_double(self):
        """ Set the file double for the command program. """
        self.upload_command_program_file_double = FileDouble()

    def set_test_args(self):
        """ Set the arguments for the test call to the function. """
        self.test_args = dict(
                command=self.test_command,
                position=self.test_position,
                debug=False,
                )

    def set_upload_command_scenario(self, name):
        """ Set the scenario for the upload command behaviour. """
        double = SubprocessDouble(
                self.upload_command_program_file_double.path,
                argv=self.test_command.split())
        double.register_for_testcase(self)
        double.set_subprocess_call_scenario('success')
        self.upload_command_subprocess_double = double

    def test_emits_debug_message_for_command(self):
        """ Should emit a debug message for the specified command. """
        self.test_args['debug'] = True
        dput.dput.execute_command(**self.test_args)
        expected_output = textwrap.dedent("""\
                D: Command: {command}
                """).format(command=self.test_command)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_calls_subprocess_call_with_expected_args(self):
        """ Should call `subprocess.call` with expected arguments. """
        dput.dput.execute_command(**self.test_args)
        subprocess.call.assert_called_with(self.test_command, shell=True)

    def test_raises_error_when_command_failure(self):
        """ Should raise error when command exits with failure. """
        double = self.upload_command_subprocess_double
        double.set_subprocess_call_scenario('failure')
        with testtools.ExpectedException(dputhelper.DputUploadFatalException):
            dput.dput.execute_command(**self.test_args)

    def test_raises_error_when_command_not_found(self):
        """ Should raise error when command not found. """
        double = self.upload_command_subprocess_double
        double.set_subprocess_call_scenario('not_found')
        with testtools.ExpectedException(dputhelper.DputUploadFatalException):
            dput.dput.execute_command(**self.test_args)


class version_check_TestCase(
        testscenarios.WithScenarios,
        testtools.TestCase):
    """ Base for test cases for `version_check` function. """

    package_file_scenarios = [
            ('package-arch {arch}'.format(arch=arch), {
                'file_double': FileDouble(),
                'field_output': textwrap.dedent("""\
                    Architecture: {arch}
                    """).format(arch=arch),
                })
            for arch in ["all", "foo", "bar", "baz"]]

    version_scenarios = [
            ('version none', {
                'upload_version': "lorem",
                }),
            ('version equal', {
                'upload_version': "lorem",
                'installed_version': "lorem",
                }),
            ('version unequal', {
                'upload_version': "lorem",
                'installed_version': "ipsum",
                }),
            ]

    scenarios = NotImplemented

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()
        patch_system_interfaces(self)

        self.patch_dpkg_program_file()

        if not hasattr(self, 'test_architectures'):
            self.test_architectures = []

        setup_changes_file_fixtures(self)
        self.set_changes_file_scenario('no-format')

        self.set_upload_files()
        self.set_changes_document()

        self.set_test_args()

        patch_subprocess_popen(self)
        self.set_dpkg_print_architecture_scenario('simple')
        self.set_dpkg_field_scenario('simple')
        self.set_dpkg_status_scenario('simple')

    def set_changes_file_scenario(self, name):
        """ Set the package changes document based on scenario name. """
        scenarios = make_changes_file_scenarios()
        scenario = dict(scenarios)[name]
        self.changes_file_double = scenario['file_double']

    def set_upload_files(self):
        """ Set the files marked for upload in this scenario. """
        package_file_suffix = ".deb"
        file_suffix_by_arch = {
                arch: "_{arch}{suffix}".format(
                    arch=arch, suffix=package_file_suffix)
                for arch in self.test_architectures}
        self.additional_file_suffixes = list(file_suffix_by_arch.values())

        setup_upload_file_fixtures(self)

        registry = FileDouble.get_registry_for_testcase(self)
        for path in self.fake_upload_file_paths:
            for (arch, suffix) in file_suffix_by_arch.items():
                if path.endswith(suffix):
                    file_double = registry[path]
                    package_file_scenario = dict(self.package_file_scenarios)[
                            "package-arch {arch}".format(arch=arch)]
                    package_file_scenario['file_double'] = file_double

    def set_changes_document(self):
        """ Set the changes document for this test case. """
        upload_params_by_name = make_upload_files_params(
                self.fake_checksum_by_file, self.fake_size_by_file)
        self.changes_document = make_changes_document(
                fields={
                    'architecture': " ".join(self.test_architectures),
                    },
                upload_params_by_name=upload_params_by_name)

    def set_test_args(self):
        """ Set the arguments for the test call to the function. """
        self.test_args = dict(
                path=os.path.dirname(self.changes_file_double.path),
                changes=self.changes_document,
                debug=False,
                )

    def patch_dpkg_program_file(self):
        """ Patch the Dpkg program file for this test case. """
        file_path = '/usr/bin/dpkg'
        file_double = FileDouble(file_path)
        file_double.register_for_testcase(self)
        self.dpkg_program_file_double = file_double

    def set_dpkg_print_architecture_scenario(self, name):
        """ Set the scenario for ‘dpkg --print-architecture’ behaviour. """
        argv = (
                os.path.basename(self.dpkg_program_file_double.path),
                "--print-architecture")
        double = SubprocessDouble(
                self.dpkg_program_file_double.path, argv=argv)
        double.register_for_testcase(self)
        double.set_subprocess_popen_scenario('success')
        double.set_stdout_content(self.host_architecture)
        self.dpkg_print_architecture_subprocess_double = double

    def set_dpkg_field_scenario(self, name):
        """ Set the scenario for ‘dpkg --field’ behaviour. """
        for arch in self.test_architectures:
            package_file_scenario = dict(self.package_file_scenarios)[
                    'package-arch {arch}'.format(arch=arch)]
            upload_file_path = package_file_scenario['file_double'].path
            argv = (
                    os.path.basename(self.dpkg_program_file_double.path),
                    "--field", upload_file_path)
            double = SubprocessDouble(
                    self.dpkg_program_file_double.path, argv=argv)
            double.register_for_testcase(self)
            double.set_subprocess_popen_scenario('success')

            package_file_scenario['package_name'] = make_unique_slug(self)
            package_file_scenario['package_version'] = self.upload_version
            field_output = package_file_scenario['field_output']
            field_output += textwrap.dedent("""\
                    Package: {name}
                    Version: {version}
                    """).format(
                        name=package_file_scenario['package_name'],
                        version=package_file_scenario['package_version'])
            double.set_stdout_content(field_output)

    def set_dpkg_status_scenario(self, name):
        """ Set the scenario for ‘dpkg -s’ behaviour. """
        for arch in self.test_architectures:
            package_file_scenario = dict(self.package_file_scenarios)[
                    'package-arch {arch}'.format(arch=arch)]
            argv = (
                    os.path.basename(self.dpkg_program_file_double.path),
                    "-s", package_file_scenario['package_name'])
            double = SubprocessDouble(
                    self.dpkg_program_file_double.path, argv=argv)
            double.register_for_testcase(self)
            double.set_subprocess_popen_scenario('success')

            version_field = ""
            if hasattr(self, 'installed_version'):
                version_field = "Version: {version}\n".format(
                        version=self.installed_version)
            status_output = textwrap.dedent("""\
                    {version}""").format(version=version_field)
            double.set_stdout_content(status_output)

    def get_subprocess_doubles_matching_argv_prefix(self, argv_prefix):
        """ Get subprocess doubles for this test case matching the argv. """
        subprocess_registry = SubprocessDouble.get_registry_for_testcase(self)
        subprocess_doubles = [
                double for double in subprocess_registry.values()
                if double.argv[:len(argv_prefix)] == argv_prefix
                ]
        return subprocess_doubles


class version_check_ArchitectureMatchTestCase(version_check_TestCase):
    """ Test cases for `version_check` when host architecture matches. """

    host_architecture_scenarios = [
            ('host-arch foo', {
                'host_architecture': "foo",
                }),
            ]

    package_architecture_scenarios = [
            ('one binary', {
                'test_architectures': ["foo"],
                }),
            ('three binaries', {
                'test_architectures': ["foo", "bar", "baz"],
                }),
            ('all-arch binary', {
                'test_architectures': ["all"],
                }),
            ]

    scenarios = testscenarios.multiply_scenarios(
            host_architecture_scenarios,
            package_architecture_scenarios,
            version_check_TestCase.version_scenarios)

    def test_emits_debug_message_showing_architecture(self):
        """ Should emit a debug message for the specified architecture. """
        test_architecture = self.getUniqueString()
        subprocess_double = self.dpkg_print_architecture_subprocess_double
        subprocess_double.set_stdout_content(
                "{arch}\n".format(arch=test_architecture))
        self.test_args['debug'] = True
        try:
            dput.dput.version_check(**self.test_args)
        except FakeSystemExit:
            pass
        expected_output = textwrap.dedent("""\
                D: detected architecture: '{arch}'
                """).format(arch=test_architecture)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_omits_stderr_output_message_when_not_debug(self):
        """ Should omit any debug messages for `stderr` output. """
        doubles = self.get_subprocess_doubles_matching_argv_prefix(
                    ("dpkg", "--print-architecture"))
        if self.test_architectures:
            doubles.extend(
                    self.get_subprocess_doubles_matching_argv_prefix(
                        ("dpkg", "--field")))
            doubles.extend(
                    self.get_subprocess_doubles_matching_argv_prefix(
                        ("dpkg", "-s")))
        for double in doubles:
            double.set_stderr_content(self.getUniqueString())
        self.test_args['debug'] = False
        try:
            dput.dput.version_check(**self.test_args)
        except FakeSystemExit:
            pass
        message_snippet = " stderr output:"
        self.assertNotIn(message_snippet, sys.stdout.getvalue())

    def test_emits_debug_message_for_architecture_stderr_output(self):
        """ Should emit debug message for Dpkg architecture `stderr`. """
        subprocess_double = self.dpkg_print_architecture_subprocess_double
        test_output = self.getUniqueString()
        subprocess_double.set_stderr_content(test_output)
        self.test_args['debug'] = True
        try:
            dput.dput.version_check(**self.test_args)
        except FakeSystemExit:
            pass
        expected_output = textwrap.dedent("""\
                D: dpkg-architecture stderr output: {output!r}
                """).format(output=test_output)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_emits_debug_message_for_field_stderr_output(self):
        """ Should emit debug message for Dpkg fields `stderr`. """
        test_output = self.getUniqueString()
        for double in self.get_subprocess_doubles_matching_argv_prefix(
                ("dpkg", "--field")):
            double.set_stderr_content(test_output)
        self.test_args['debug'] = True
        try:
            dput.dput.version_check(**self.test_args)
        except FakeSystemExit:
            pass
        expected_output = textwrap.dedent("""\
                D: dpkg stderr output: {output!r}
                """).format(output=test_output)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_emits_debug_message_for_status_stderr_output(self):
        """ Should emit debug message for Dpkg status `stderr`. """
        test_output = self.getUniqueString()
        for double in self.get_subprocess_doubles_matching_argv_prefix(
                ("dpkg", "-s")):
            double.set_stderr_content(test_output)
        self.test_args['debug'] = True
        try:
            dput.dput.version_check(**self.test_args)
        except FakeSystemExit:
            pass
        expected_output = textwrap.dedent("""\
                D: dpkg stderr output: {output!r}
                """).format(output=test_output)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_emits_expected_debug_message_for_installed_version(self):
        """ Should emit debug message for package installed version. """
        self.test_args['debug'] = True
        message_lead = "D: Installed-Version:"
        if hasattr(self, 'installed_version'):
            dput.dput.version_check(**self.test_args)
            expected_output = "{lead} {version}".format(
                    lead=message_lead, version=self.installed_version)
            self.assertIn(expected_output, sys.stdout.getvalue())
        else:
            with testtools.ExpectedException(FakeSystemExit):
                dput.dput.version_check(**self.test_args)
            self.assertNotIn(message_lead, sys.stdout.getvalue())

    def test_emits_expected_debug_message_for_upload_version(self):
        """ Should emit debug message for package upload version. """
        self.test_args['debug'] = True
        message_lead = "D: Check-Version:"
        if hasattr(self, 'installed_version'):
            dput.dput.version_check(**self.test_args)
            expected_output = "{lead} {version}".format(
                    lead=message_lead, version=self.upload_version)
            self.assertIn(expected_output, sys.stdout.getvalue())
        else:
            with testtools.ExpectedException(FakeSystemExit):
                dput.dput.version_check(**self.test_args)
            self.assertNotIn(message_lead, sys.stdout.getvalue())


class version_check_ArchitectureMismatchTestCase(version_check_TestCase):
    """ Test cases for `version_check` when no match to host architecture. """

    host_architecture_scenarios = [
            ('host-arch spam', {
                'host_architecture': "spam",
                }),
            ]

    package_architecture_scenarios = [
            ('one binary', {
                'test_architectures': ["foo"],
                }),
            ]

    scenarios = testscenarios.multiply_scenarios(
            host_architecture_scenarios,
            package_architecture_scenarios,
            version_check_TestCase.version_scenarios)

    def test_emits_debug_message_stating_arch_mismatch(self):
        """ Should emit a debug message stating the architecture mismatch. """
        self.test_args['debug'] = True
        dput.dput.version_check(**self.test_args)
        file_scenarios = dict(self.package_file_scenarios)
        for arch in self.test_architectures:
            file_scenario_name = "package-arch {arch}".format(arch=arch)
            file_scenario = file_scenarios[file_scenario_name]
            file_double = file_scenario['file_double']
            expected_output = textwrap.dedent("""\
                    D: not install-checking {path} due to arch mismatch
                    """).format(path=file_double.path)
            self.expectThat(
                    sys.stdout.getvalue(),
                    testtools.matchers.Contains(expected_output))


class version_check_PackageNotInstalledTestCase(version_check_TestCase):
    """ Test cases for `version_check` when package is not installed. """

    host_architecture_scenarios = [
            ('host-arch foo', {
                'host_architecture': "foo",
                }),
            ]

    package_architecture_scenarios = [
            ('one binary', {
                'test_architectures': ["foo"],
                }),
            ]

    version_scenarios = [
            ('version none', {
                'upload_version': "lorem",
                }),
            ]

    scenarios = testscenarios.multiply_scenarios(
            host_architecture_scenarios,
            package_architecture_scenarios,
            version_scenarios)

    def test_emits_message_stating_package_not_installed(self):
        """ Should emit message stating package is not installed. """
        with testtools.ExpectedException(FakeSystemExit):
            dput.dput.version_check(**self.test_args)
        expected_output = textwrap.dedent("""\
                Uninstalled Package. Test it before uploading it.
                """)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_calls_sys_exit_with_error_status(self):
        """ Should call `sys.exit` with exit status indicating error. """
        with testtools.ExpectedException(FakeSystemExit):
            dput.dput.version_check(**self.test_args)
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)


class check_upload_logfile_TestCase(
        testscenarios.WithScenarios,
        testtools.TestCase):
    """ Base for test cases for `check_upload_logfile` function. """

    scenarios = NotImplemented

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()
        patch_system_interfaces(self)

        set_config(self, 'exist-simple')
        patch_runtime_config_options(self)

        setup_changes_file_fixtures(self)
        self.set_changes_file_scenario('no-format')

        self.set_test_args()

        patch_os_path_exists(self)

        self.set_upload_log_file_double()

        setup_file_double_behaviour(
                self,
                [self.changes_file_double, self.upload_log_file_double])

    def set_changes_file_scenario(self, name):
        """ Set the package changes file based on scenario name. """
        scenarios = make_changes_file_scenarios()
        scenario = dict(scenarios)[name]
        self.changes_file_double = scenario['file_double']

    def set_test_args(self):
        """ Set the arguments for the test call to the function. """
        self.test_args = dict(
                changes_file_path=self.changes_file_double.path,
                host=self.test_host,
                fqdn=self.runtime_config_parser.get(self.test_host, 'fqdn'),
                check_only=False,
                run_lintian=False,
                force_upload=False,
                debug=False,
                )
        custom_args = getattr(self, 'custom_args', {})
        self.test_args.update(custom_args)

    def set_upload_log_file_double(self):
        """ Set the upload log file double. """
        (file_dir_path, changes_file_name) = os.path.split(
                self.changes_file_double.path)
        (file_basename, __) = os.path.splitext(changes_file_name)
        file_name = "{basename}.{host}.upload".format(
                basename=file_basename, host=self.test_host)
        file_path = os.path.join(file_dir_path, file_name)

        double = FileDouble(file_path)
        double.set_os_path_exists_scenario(
                getattr(self, 'path_exists_scenario_name', 'exist'))
        double.set_open_scenario(
                getattr(self, 'open_scenario_name', 'okay'))

        file_content = getattr(self, 'log_content', "")
        double.fake_file = io.StringIO(file_content)

        self.upload_log_file_double = double


class check_upload_logfile_SuccessTestCase(check_upload_logfile_TestCase):
    """ Success test cases for `check_upload_logfile` function. """

    scenarios = [
            ('simple', {}),
            ('not_exist', {
                'path_exists_scenario_name': 'not_exist',
                'open_scenario_name': 'nonexist',
                }),
            ('check_only', {
                'custom_args': {
                    'check_only': True,
                    },
                }),
            ('force_upload', {
                'custom_args': {
                    'force_upload': True,
                    },
                }),
            ('check_only and force_upload', {
                'custom_args': {
                    'check_only': True,
                    'force_upload': True,
                    },
                }),
            ('method-ftp not-uploaded', {
                'config_method': "ftp",
                'config_fqdn': "quux.example.com",
                'log_content': "foo lorem-ipsum bar\n",
                }),
            ('method-local not-uploaded', {
                'config_method': "local",
                'log_content': "foo lorem-ipsum bar\n",
                }),
            ]

    for (scenario_name, scenario) in scenarios:
        scenario['expected_result'] = None
    del scenario_name, scenario

    def test_returns_expected_result(self):
        """ Should return expected result for the scenario. """
        try:
            result = dput.dput.check_upload_logfile(**self.test_args)
        except FakeSystemExit:
            pass
        self.assertEqual(self.expected_result, result)


class check_upload_logfile_ExitTestCase(check_upload_logfile_TestCase):
    """ Exit test cases for `check_upload_logfile` function. """

    scenarios = [
            ('uploaded', {
                'config_method': "ftp",
                'config_fqdn': "quux.example.com",
                'log_content': "foo quux.example.com bar\n",
                'expected_exit_status': 0,
                }),
            ]

    def test_calls_sys_exit_with_expected_exit_status(self):
        """ Should call `sys.exit` with expected exit status. """
        with testtools.ExpectedException(FakeSystemExit):
            dput.dput.check_upload_logfile(**self.test_args)
        sys.exit.assert_called_with(self.expected_exit_status)


class check_upload_logfile_ErrorTestCase(check_upload_logfile_TestCase):
    """ Error test cases for `check_upload_logfile` function. """

    log_file_scenarios = [
            ('denied', {
                'path_exists_scenario_name': 'exist',
                'open_scenario_name': 'read_denied',
                'expected_exit_status': 1,
                }),
            ]

    scenarios = log_file_scenarios

    def test_calls_sys_exit_with_expected_exit_status(self):
        """ Should call `sys.exit` with expected exit status. """
        with testtools.ExpectedException(FakeSystemExit):
            dput.dput.check_upload_logfile(**self.test_args)
        sys.exit.assert_called_with(self.expected_exit_status)


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
