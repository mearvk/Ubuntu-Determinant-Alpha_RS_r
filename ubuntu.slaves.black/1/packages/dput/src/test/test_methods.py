# test/test_methods.py
# Part of ‘dput’, a Debian package upload toolkit.
#
# This is free software, and you are welcome to redistribute it under
# certain conditions; see the end of this file for copyright
# information, grant of license, and disclaimer of warranty.

""" Unit tests for upload method behaviour. """

import collections
import doctest
import ftplib
import getpass
import http.client
import importlib
import io
import itertools
import os
import os.path
import pkgutil
import stat
import subprocess
import sys
import tempfile
import textwrap
import unittest.mock
import urllib.parse
import urllib.request

import testscenarios
import testtools

import dput.dput
import dput.helper.dputhelper
import dput.methods
import dput.methods.ftp
import dput.methods.http
import dput.methods.https
import dput.methods.local
import dput.methods.rsync
import dput.methods.scp

from .helper import (
        ARG_ANY,
        EXIT_STATUS_FAILURE,
        EXIT_STATUS_SUCCESS,
        FakeSystemExit,
        FileDouble,
        SubprocessDouble,
        make_fake_fqdn,
        patch_os_lstat,
        patch_os_stat,
        patch_subprocess_check_call,
        patch_system_interfaces,
        setup_file_double_behaviour,
        )
from .test_dputhelper import (
        patch_filewithprogress,
        )


class import_upload_functions_TestCase(
        testscenarios.WithScenarios,
        testtools.TestCase):
    """ Test cases for `import_upload_functions` function. """

    scenarios = [
            ('empty', {
                'module_names': [],
                }),
            ('one', {
                'module_names': ["foo"],
                }),
            ('three', {
                'module_names': ["foo", "bar", "baz"],
                }),
            ]

    for (scenario_name, scenario) in scenarios:
        modules_by_name = collections.OrderedDict()
        iter_modules_result = []
        for module_name in scenario['module_names']:
            module = unittest.mock.Mock()
            module.__name__ = module_name
            module.upload = unittest.mock.Mock()
            modules_by_name[module_name] = module
            module_entry = (module, module_name, False)
            iter_modules_result.append(module_entry)
        scenario['modules_by_name'] = modules_by_name
        scenario['iter_modules_result'] = iter_modules_result
    del scenario_name, scenario

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()
        patch_system_interfaces(self)

        self.patch_import_functions()

    def patch_import_functions(self):
        """ Patch import functions used by the function. """
        self.patch_pkgutil_iter_modules()
        self.patch_importlib_import_module()

    def patch_pkgutil_iter_modules(self):
        """ Patch `pkgutil.iter_modules` function for this test case. """
        func_patcher = unittest.mock.patch.object(
                pkgutil, "iter_modules", autospec=True)
        func_patcher.start()
        self.addCleanup(func_patcher.stop)
        pkgutil.iter_modules.return_value = self.iter_modules_result

    def patch_importlib_import_module(self):
        """ Patch `importlib.import_module` function for this test case. """
        func_patcher = unittest.mock.patch.object(
                importlib, "import_module", autospec=True)
        func_patcher.start()
        self.addCleanup(func_patcher.stop)

        def fake_import_module(full_name):
            module_name = full_name.split(".")[-1]
            module = self.modules_by_name[module_name]
            return module

        importlib.import_module.side_effect = fake_import_module

    @unittest.mock.patch.object(dput.dput, 'debug', new=True)
    def test_emits_debug_message_for_modules_found(self):
        """ Should emit a debug message for the modules found. """
        expected_message = "D: modules_found: {names!r}".format(
                names=self.module_names)
        dput.dput.import_upload_functions()
        self.assertIn(expected_message, sys.stdout.getvalue())

    @unittest.mock.patch.object(dput.dput, 'debug', new=True)
    def test_emits_debug_message_for_each_import(self):
        """ Should emit a debug message for each module imported. """
        dput.dput.import_upload_functions()
        for (module_name, module) in self.modules_by_name.items():
            expected_message = "D: Module: {name} ({module!r})".format(
                    name=module_name, module=module)
            self.assertIn(expected_message, sys.stdout.getvalue())

    @unittest.mock.patch.object(dput.dput, 'debug', new=True)
    def test_emits_debug_message_for_each_upload_method(self):
        """ Should emit a debug message for each upload method. """
        dput.dput.import_upload_functions()
        for module_name in self.module_names:
            expected_message = "D: Method name: {name}".format(
                    name=module_name)
            self.assertIn(expected_message, sys.stdout.getvalue())

    def test_returns_expected_function_mapping(self):
        """ Should return expected mapping of upload functions. """
        result = dput.dput.import_upload_functions()
        expected_result = {
                name: self.modules_by_name[name].upload
                for name in self.module_names}
        self.assertEqual(expected_result, result)


def patch_getpass_getpass(testcase):
    """ Patch the `getpass.getpass` function for the test case. """
    func_patcher = unittest.mock.patch.object(
            getpass, "getpass", autospec=True)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


class upload_TestCase(
        testscenarios.WithScenarios,
        testtools.TestCase):
    """ Base for test cases for method modules `upload` functions. """

    files_scenarios = [
            ('file-list-empty', {
                'paths_to_upload': [],
                }),
            ('file-list-one', {
                'paths_to_upload': [tempfile.mktemp()],
                }),
            ('file-list-three', {
                'paths_to_upload': [tempfile.mktemp() for __ in range(3)],
                }),
            ]

    check_call_scenarios = [
            ('check-call-success', {
                'check_call_scenario_name': 'success',
                }),
            ('check-call-failure', {
                'check_call_scenario_name': 'failure',
                'check_call_error': subprocess.CalledProcessError,
                }),
            ]

    check_call_success_scenarios = [
            (name, params) for (name, params) in check_call_scenarios
            if 'check_call_error' not in params]

    incoming_scenarios = [
            ('incoming-simple', {
                'incoming_path': tempfile.mktemp(),
                }),
            ('incoming-no-leading-slash', {
                'incoming_path': tempfile.mktemp().lstrip("/"),
                }),
            ('incoming-has-trailing-slash', {
                'incoming_path': tempfile.mktemp() + "/",
                }),
            ]

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()
        patch_system_interfaces(self)

        patch_subprocess_check_call(self)

        patch_os_stat(self)
        self.set_file_doubles()
        setup_file_double_behaviour(self)

        patch_filewithprogress(self)

        self.set_test_args()

    def set_file_doubles(self):
        """ Set the file doubles for this test case. """
        for path in self.paths_to_upload:
            fake_file = getattr(self, 'fake_file', None)
            double = FileDouble(path, fake_file)
            double.set_os_stat_scenario(
                    getattr(self, 'os_stat_scenario_name', "okay"))
            double.register_for_testcase(self)

            func_patcher = unittest.mock.patch.object(
                    double.fake_file, "close", autospec=True)
            func_patcher.start()
            self.addCleanup(func_patcher.stop)

    def set_test_args(self):
        """ Set the arguments for the test call to the function. """
        raise NotImplementedError

    def get_command_args_from_latest_check_call(self):
        """ Get command line arguments from latest `subprocess.check_call`. """
        latest_call = subprocess.check_call.call_args
        (args, kwargs) = latest_call
        command_args = args[0]
        return command_args


class local_upload_TestCase(upload_TestCase):
    """ Test cases for `methods.local.upload` function. """

    scenarios = testscenarios.multiply_scenarios(
            upload_TestCase.incoming_scenarios,
            upload_TestCase.files_scenarios,
            upload_TestCase.check_call_success_scenarios)

    command_file_path = os.path.join("/usr/bin", "install")

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()

        self.set_subprocess_double()

    def set_test_args(self):
        """ Set the arguments for the test call to the function. """
        self.test_args = dict(
                fqdn=object(),
                login=object(),
                incoming=self.incoming_path,
                files_to_upload=self.paths_to_upload,
                debug=None,
                compress=object(),
                progress=object(),
                )

    def set_subprocess_double(self):
        """ Set the test double for the subprocess. """
        argv = [self.command_file_path, "-m", ARG_ANY, ARG_ANY]
        double = SubprocessDouble(self.command_file_path, argv=argv)
        double.register_for_testcase(self)
        double.set_subprocess_check_call_scenario(
                self.check_call_scenario_name)
        self.subprocess_double = double

    def test_calls_check_call_with_install_command(self):
        """ Should call `subprocess.check_call` to invoke ‘install’. """
        dput.methods.local.upload(**self.test_args)
        command_args = self.get_command_args_from_latest_check_call()
        expected_command = self.command_file_path
        self.assertEqual(expected_command, command_args[0])

    def test_calls_check_call_with_mode_option_in_command(self):
        """ Should call `subprocess.check_call`, invoke command with mode. """
        dput.methods.local.upload(**self.test_args)
        command_args = self.get_command_args_from_latest_check_call()
        expected_mode = (
                stat.S_IRUSR | stat.S_IWUSR
                | stat.S_IRGRP
                | stat.S_IROTH)
        expected_mode_text = "{mode:04o}".format(mode=expected_mode)[-3:]
        expected_option_args = ["-m", expected_mode_text]
        self.assertEqual(expected_option_args, command_args[1:3])

    def test_calls_check_call_with_file_paths_in_command(self):
        """ Should call `subprocess.check_call` with file paths in command. """
        dput.methods.local.upload(**self.test_args)
        command_args = self.get_command_args_from_latest_check_call()
        self.assertEqual(self.paths_to_upload, command_args[3:-1])

    def test_calls_check_call_with_incoming_path_as_final_arg(self):
        """ Should call `subprocess.check_call` with incoming path. """
        dput.methods.local.upload(**self.test_args)
        command_args = self.get_command_args_from_latest_check_call()
        self.assertEqual(self.incoming_path, command_args[-1])

    def test_emits_debug_message_for_upload_command(self):
        """ Should emit a debug message for the upload command. """
        self.test_args['debug'] = True
        dput.methods.local.upload(**self.test_args)
        expected_message = textwrap.dedent("""\
                D: Uploading with cp to {dir_path}
                D: ...
                """).format(dir_path=self.incoming_path)
        self.assertThat(
                sys.stdout.getvalue(),
                testtools.matchers.DocTestMatches(
                    expected_message, flags=doctest.ELLIPSIS))

    def test_calls_sys_exit_if_check_call_returns_nonzero(self):
        """ Should call `sys.exit` if `subprocess.check_call` fails. """
        self.subprocess_double.set_subprocess_check_call_scenario('failure')
        with testtools.ExpectedException(FakeSystemExit):
            dput.methods.local.upload(**self.test_args)
        expected_output = textwrap.dedent("""\
                Error while uploading.
                """)
        self.assertIn(expected_output, sys.stdout.getvalue())
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)


class ftp_upload_TestCase(upload_TestCase):
    """ Test cases for `methods.ftp.upload` function. """

    scenarios = NotImplemented

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()

        self.set_ftp_client()
        self.patch_ftplib_ftp()

        patch_getpass_getpass(self)
        self.fake_password = self.getUniqueString()
        getpass.getpass.return_value = self.fake_password
        if not hasattr(self, 'expected_password'):
            self.expected_password = self.fake_password

    def set_test_args(self):
        """ Set the arguments for the test call to the function. """
        if not hasattr(self, 'progress_type'):
            self.progress_type = 0
        self.test_args = dict(
                fqdn=make_fake_fqdn(self),
                login=self.login,
                incoming=self.incoming_path,
                files_to_upload=self.paths_to_upload,
                debug=False,
                ftp_mode=self.ftp_mode,
                progress=self.progress_type,
                port=object(),
                )

    def set_ftp_client(self):
        """ Set the FTP client double. """
        self.ftp_client = unittest.mock.MagicMock(name="FTP")

    def patch_ftplib_ftp(self):
        """ Patch `ftplib.FTP` class for this test case. """
        patcher = unittest.mock.patch.object(
                ftplib, "FTP", autospec=True)
        patcher.start()
        self.addCleanup(patcher.stop)

        ftplib.FTP.return_value = self.ftp_client


class ftp_upload_NormalFilesTestCase(ftp_upload_TestCase):
    """ Test cases for `methods.ftp.upload` function, upload normal files. """

    login_scenarios = [
            ('anonymous', {
                'login': "anonymous",
                'expected_password': "dput@packages.debian.org",
                }),
            ('username', {
                'login': "lorem",
                }),
            ]

    ftp_client_scenarios = [
            ('default', {
                'ftp_mode': False,
                }),
            ('passive-mode', {
                'ftp_mode': True,
                }),
            ]

    scenarios = testscenarios.multiply_scenarios(
            upload_TestCase.incoming_scenarios,
            upload_TestCase.files_scenarios,
            login_scenarios, ftp_client_scenarios)

    def test_emits_debug_message_for_connect(self):
        """ Should emit debug message for successful connect. """
        self.test_args['debug'] = True
        dput.methods.ftp.upload(**self.test_args)
        expected_fqdn = self.test_args['fqdn']
        expected_output = textwrap.dedent("""\
                D: FTP-Connection to host: {fqdn}
                """).format(fqdn=expected_fqdn)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_emits_no_debug_message_when_debug_false(self):
        """ Should emit no debug messages when `debug` is false. """
        self.test_args['debug'] = False
        dput.methods.ftp.upload(**self.test_args)
        debug_message_lines = [
                line for line in sys.stdout.getvalue().split()
                if line.startswith("D: ")]
        self.assertEqual([], debug_message_lines)

    def test_calls_ftp_connect_with_expected_args(self):
        """ Should call `FTP.connect` with expected args. """
        dput.methods.ftp.upload(**self.test_args)
        expected_args = (
                self.test_args['fqdn'],
                self.test_args['port'],
                )
        self.ftp_client.connect.assert_called_with(*expected_args)

    def test_emits_error_message_when_ftp_connect_error(self):
        """ Should emit error message when `FTP.connect` raises error. """
        self.ftp_client.connect.side_effect = ftplib.error_temp
        try:
            dput.methods.ftp.upload(**self.test_args)
        except FakeSystemExit:
            pass
        expected_output = "Connection failed, aborting"
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_calls_sys_exit_when_ftp_connect_permission_error(self):
        """ Should call `sys.exit` when `FTP.connect` raises error. """
        self.ftp_client.connect.side_effect = ftplib.error_temp
        with testtools.ExpectedException(FakeSystemExit):
            dput.methods.ftp.upload(**self.test_args)
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)

    def test_calls_ftp_login_with_expected_args(self):
        """ Should call `FTP.login` with expected args. """
        dput.methods.ftp.upload(**self.test_args)
        expected_args = (
                self.test_args['login'],
                self.expected_password,
                )
        self.ftp_client.login.assert_called_with(*expected_args)

    def test_emits_error_message_when_ftp_login_permission_error(self):
        """ Should emit error message when `FTP.login` permission error. """
        self.ftp_client.login.side_effect = ftplib.error_perm
        try:
            dput.methods.ftp.upload(**self.test_args)
        except FakeSystemExit:
            pass
        expected_output = "Wrong Password"
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_calls_sys_exit_when_ftp_login_permission_error(self):
        """ Should call `sys.exit` when `FTP.login` permission error. """
        self.ftp_client.login.side_effect = ftplib.error_perm
        with testtools.ExpectedException(FakeSystemExit):
            dput.methods.ftp.upload(**self.test_args)
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)

    def test_emits_error_message_when_ftp_login_eof_error(self):
        """ Should emit error message when `FTP.login` EOF error. """
        self.ftp_client.login.side_effect = EOFError
        try:
            dput.methods.ftp.upload(**self.test_args)
        except FakeSystemExit:
            pass
        expected_output = "Server closed the connection"
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_calls_sys_exit_when_ftp_login_eof_error(self):
        """ Should call `sys.exit` when `FTP.login` EOF error. """
        self.ftp_client.login.side_effect = EOFError
        with testtools.ExpectedException(FakeSystemExit):
            dput.methods.ftp.upload(**self.test_args)
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)

    def test_calls_ftp_set_pasv_with_expected_args(self):
        """ Should call `FTP.set_pasv` with expected args. """
        dput.methods.ftp.upload(**self.test_args)
        expected_mode = bool(self.test_args['ftp_mode'])
        expected_args = (expected_mode,)
        self.ftp_client.set_pasv.assert_called_with(*expected_args)

    def test_calls_ftp_cwd_with_expected_args(self):
        """ Should call `FTP.cwd` with expected args. """
        dput.methods.ftp.upload(**self.test_args)
        expected_path = self.incoming_path
        expected_args = (expected_path,)
        self.ftp_client.cwd.assert_called_with(*expected_args)

    def test_emits_debug_message_for_cwd(self):
        """ Should emit debug message for successful `FTP.cwd`. """
        self.test_args['debug'] = True
        dput.methods.ftp.upload(**self.test_args)
        expected_output = textwrap.dedent("""\
                D: Directory to upload to: {path}
                """).format(path=self.incoming_path)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_emits_error_message_when_destination_directory_not_found(self):
        """ Should emit error message when destination directory not found. """
        error = ftplib.error_perm("550 Not Found")
        self.ftp_client.cwd.side_effect = error
        try:
            dput.methods.ftp.upload(**self.test_args)
        except FakeSystemExit:
            pass
        expected_output = "Directory to upload to does not exist."
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_calls_sys_exit_when_ftp_cwd_permission_error(self):
        """ Should call `sys.exit` when `FTP.cwd` permission error. """
        error = ftplib.error_perm("550 Not Found")
        self.ftp_client.cwd.side_effect = error
        with testtools.ExpectedException(FakeSystemExit):
            dput.methods.ftp.upload(**self.test_args)
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)

    def test_propagates_exception_when_ftp_cwd_permission_error(self):
        """ Should call `sys.exit` when `FTP.cwd` permission error. """
        error = ftplib.error_perm("500 Bad Stuff Happened")
        self.ftp_client.cwd.side_effect = error
        with testtools.ExpectedException(error.__class__):
            dput.methods.ftp.upload(**self.test_args)

    def test_propagates_exception_when_ftp_cwd_eof_error(self):
        """ Should call `sys.exit` when `FTP.cwd` EOF error. """
        error = EOFError()
        self.ftp_client.cwd.side_effect = error
        with testtools.ExpectedException(error.__class__):
            dput.methods.ftp.upload(**self.test_args)

    def test_emits_debug_message_for_each_file(self):
        """ Should emit debug message for each file to upload. """
        self.test_args['debug'] = True
        dput.methods.ftp.upload(**self.test_args)
        expected_output = "".join(textwrap.dedent("""\
                D: Uploading File: {path}
                  Uploading {filename}: done.
                """).format(path=path, filename=os.path.basename(path))
                for path in self.paths_to_upload)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_calls_ftp_storbinary_for_each_file(self):
        """ Should call `FTP.storbinary` for each file to upload. """
        dput.methods.ftp.upload(**self.test_args)
        registry = FileDouble.get_registry_for_testcase(self)
        expected_blocksize = 1024
        expected_calls = [
                unittest.mock.call(
                    "STOR {filename}".format(filename=os.path.basename(path)),
                    registry[path].fake_file, expected_blocksize)
                for path in self.paths_to_upload]
        self.ftp_client.storbinary.assert_has_calls(
                expected_calls, any_order=True)

    def test_calls_close_for_each_file(self):
        """ Should call `file.close` for each file to upload. """
        dput.methods.ftp.upload(**self.test_args)
        registry = FileDouble.get_registry_for_testcase(self)
        for path in self.paths_to_upload:
            fake_file = registry[path].fake_file
            fake_file.close.assert_called_with()


class ftp_upload_ErrorTestCase(ftp_upload_TestCase):
    """ Test cases for `methods.ftp.upload` function, error conditions. """

    login_scenarios = [
            ('login-anonymous', {
                'login': "anonymous",
                'expected_password': "dput@packages.debian.org",
                }),
            ]

    ftp_client_scenarios = [
            ('client-default', {
                'ftp_mode': False,
                }),
            ]

    progress_scenarios = [
            ('progress-type-0', {
                'progress_type': 0,
                }),
            ('progress-type-1', {
                'progress_type': 1,
                }),
            ('progress-type-2', {
                'progress_type': 2,
                }),
            ]

    files_scenarios = list(
            (scenario_name, scenario) for (scenario_name, scenario)
            in upload_TestCase.files_scenarios
            if scenario['paths_to_upload'])

    scenarios = testscenarios.multiply_scenarios(
            upload_TestCase.incoming_scenarios,
            files_scenarios,
            login_scenarios, ftp_client_scenarios, progress_scenarios)

    def test_emits_no_debug_message_when_debug_false(self):
        """ Should emit no debug messages when `debug` is false. """
        self.test_args['debug'] = False
        error = ftplib.error_perm("553 Exists")
        self.ftp_client.storbinary.side_effect = error
        dput.methods.ftp.upload(**self.test_args)
        debug_message_lines = [
                line for line in sys.stdout.getvalue().split()
                if line.startswith("D: ")]
        self.assertEqual([], debug_message_lines)

    def test_emits_warning_when_remote_file_exists(self):
        """ Should emit a warning message when remote file exists. """
        error = ftplib.error_perm("553 Exists")
        self.ftp_client.storbinary.side_effect = error
        dput.methods.ftp.upload(**self.test_args)
        for path in self.paths_to_upload:
            expected_output = textwrap.dedent("""\
                    Leaving existing {path} on the server and continuing
                    """).format(path=os.path.basename(path))
            self.expectThat(
                    sys.stdout.getvalue(),
                    testtools.matchers.Contains(expected_output))

    def test_omits_sys_exit_when_remote_file_exists(self):
        """ Should omit call to `sys.exit` when remote file exists. """
        error = ftplib.error_perm("553 Exists")
        self.ftp_client.storbinary.side_effect = error
        dput.methods.ftp.upload(**self.test_args)
        self.assertFalse(sys.exit.called)

    def test_emits_error_message_when_storbinary_failure(self):
        """ Should emit an error message when `FTP.storbinary` failure. """
        error = ftplib.error_perm("504 Weird Stuff Happened")
        self.ftp_client.storbinary.side_effect = error
        try:
            dput.methods.ftp.upload(**self.test_args)
        except FakeSystemExit:
            pass
        for path in self.paths_to_upload[:1]:
            expected_output = (
                    "Note: This error might indicate a problem with"
                    " your passive_ftp setting.\n")
            self.expectThat(
                    sys.stdout.getvalue(),
                    testtools.matchers.Contains(expected_output))

    def test_calls_sys_exit_when_storbinary_failure(self):
        """ Should call `sys.exit` when `FTP.storbinary` failure. """
        error = ftplib.error_perm("504 Weird Stuff Happened")
        self.ftp_client.storbinary.side_effect = error
        with testtools.ExpectedException(FakeSystemExit):
            dput.methods.ftp.upload(**self.test_args)
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)

    def test_emits_debug_message_when_open_failure(self):
        """ Should emit a debug message when `builtins.open` failure. """
        self.test_args['debug'] = True
        registry = FileDouble.get_registry_for_testcase(self)
        for path in self.paths_to_upload:
            double = registry[path]
            double.set_open_scenario('nonexist')
        try:
            dput.methods.ftp.upload(**self.test_args)
        except EnvironmentError:
            pass
        expected_output = (
                "D: Should exit silently now, but"
                " will throw exception for debug.")
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_propagates_error_from_storbinary_for_debug(self):
        """ Should propagate error from `FTP.storbinary` when debug. """
        self.test_args['debug'] = True
        error = ftplib.error_perm("504 Weird Stuff Happened")
        self.ftp_client.storbinary.side_effect = error
        with testtools.ExpectedException(error.__class__):
            dput.methods.ftp.upload(**self.test_args)

    def test_propagates_error_from_quit_for_debug(self):
        """ Should propagate error from `FTP.quit` when debug. """
        self.test_args['debug'] = True
        error = ftplib.error_perm("504 Weird Stuff Happened")
        self.ftp_client.quit.side_effect = error
        with testtools.ExpectedException(error.__class__):
            dput.methods.ftp.upload(**self.test_args)

    def test_emits_debug_message_from_quit_when_debug_true(self):
        """ Should emit text of error from `FTP.quit`. """
        self.test_args['debug'] = True
        error = ftplib.error_perm("504 Weird Stuff Happened")
        self.ftp_client.quit.side_effect = error
        with testtools.ExpectedException(error.__class__):
            dput.methods.ftp.upload(**self.test_args)
        expected_output = str(error)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_emits_no_debug_message_from_quit_when_debug_false(self):
        """ Should not raise nor emit any error from `FTP.quit`. """
        self.test_args['debug'] = False
        error = ftplib.error_perm("504 Weird Stuff Happened")
        self.ftp_client.quit.side_effect = error
        dput.methods.ftp.upload(**self.test_args)
        unwanted_output = str(error)
        self.assertNotIn(unwanted_output, sys.stdout.getvalue())


def make_expected_filewithprogress_attributes_by_path(testcase, attrs):
    """ Make a mapping from path to expected FileWithProgress attribs. """
    expected_attributes_by_path = {}
    registry = FileDouble.get_registry_for_testcase(testcase)
    for path in testcase.paths_to_upload:
        file_double = registry[path]
        expected_attributes = {
                'f': file_double.fake_file,
                'size': file_double.stat_result.st_size,
                }
        expected_attributes.update(attrs)
        expected_attributes_by_path[path] = expected_attributes

    return expected_attributes_by_path


class ftp_upload_ProgressTestCase(ftp_upload_TestCase):
    """ Test cases for `methods.ftp.upload` function, with progress meter. """

    login_scenarios = [
            ('anonymous', {
                'login': "anonymous",
                'expected_password': "dput@packages.debian.org",
                }),
            ]

    ftp_client_scenarios = [
            ('default', {
                'ftp_mode': False,
                }),
            ]

    progress_scenarios = [
            ('progress-type-1', {
                'progress_type': 1,
                }),
            ('progress-type-2', {
                'progress_type': 2,
                }),
            ]

    scenarios = testscenarios.multiply_scenarios(
            upload_TestCase.incoming_scenarios,
            upload_TestCase.files_scenarios,
            login_scenarios, ftp_client_scenarios, progress_scenarios)

    def test_calls_storbinary_with_filewithprogress(self):
        """ Should use a `FileWithProgress` to call `FTP.storbinary`. """
        dput.methods.ftp.upload(**self.test_args)
        expected_calls = [
                unittest.mock.call(
                    unittest.mock.ANY, self.fake_filewithprogress,
                    unittest.mock.ANY)
                for path in self.paths_to_upload]
        self.ftp_client.storbinary.assert_has_calls(
                expected_calls, any_order=True)

    def test_filewithprogress_has_expected_attributes(self):
        """ Should have expected attributes on the `FileWithProgress`. """
        expected_attributes_by_path = (
                make_expected_filewithprogress_attributes_by_path(
                    self, {'ptype': self.progress_type}))
        dput.methods.ftp.upload(**self.test_args)
        for call in self.ftp_client.storbinary.mock_calls:
            (__, call_args, call_kwargs) = call
            (__, stor_file, __) = call_args
            path = stor_file.f.name
            expected_attributes = expected_attributes_by_path[path]
            stor_file_attributes = {
                    name: getattr(stor_file, name)
                    for name in expected_attributes}
            self.expectThat(
                    expected_attributes,
                    testtools.matchers.Equals(stor_file_attributes))

    def test_filewithprogress_has_sentinel_size_when_stat_failure(self):
        """ Should have sentinel `size` value when `os.stat` failure. """
        expected_attributes_by_path = (
                make_expected_filewithprogress_attributes_by_path(
                    self, {'size': -1}))
        registry = FileDouble.get_registry_for_testcase(self)
        for path in self.paths_to_upload:
            double = registry[path]
            double.set_os_stat_scenario('notfound_error')
        dput.methods.ftp.upload(**self.test_args)
        for call in self.ftp_client.storbinary.mock_calls:
            (__, call_args, call_kwargs) = call
            (__, stor_file, __) = call_args
            path = stor_file.f.name
            expected_attributes = expected_attributes_by_path[path]
            stor_file_attributes = {
                    name: getattr(stor_file, name)
                    for name in expected_attributes}
            self.expectThat(
                    expected_attributes,
                    testtools.matchers.Equals(stor_file_attributes))

    def test_emits_debug_message_when_stat_failure(self):
        """ Should have sentinel `size` value when `os.stat` failure. """
        self.test_args['debug'] = True
        registry = FileDouble.get_registry_for_testcase(self)
        for path in self.paths_to_upload:
            double = registry[path]
            double.set_os_stat_scenario('notfound_error')
        dput.methods.ftp.upload(**self.test_args)
        for path in self.paths_to_upload:
            expected_output = textwrap.dedent("""\
                    D: Determining size of file '{path}' failed
                    """).format(path=path)
            self.expectThat(
                    sys.stdout.getvalue(),
                    testtools.matchers.Contains(expected_output))


def make_mock_httprequest(
        *,
        method="GET",
        url=None,
        header_fields=None,
        body=None):
    """ Make an instrumented mock for `urllib.request.Request`. """
    request = unittest.mock.Mock(spec=urllib.request.Request)
    request.url = url
    request.headers = header_fields
    if body is None:
        body = ""
    body_data = body.encode(dput.methods.http.MESSAGE_BODY_ENCODING)
    request.data = body_data

    return request


reason_by_http_status = {
    http.client.OK: "Okay",
    http.client.NON_AUTHORITATIVE_INFORMATION: "Non-Authoritative Information",
    http.client.INTERNAL_SERVER_ERROR: "Internal Server Error",
    http.client.UNAUTHORIZED: "Unauthorized",
}


def make_mock_httpresponse(
        *,
        version="HTTP/1.1",
        status=http.client.OK,
        header_fields=None,
        body=None):
    """ Make an instrumented mock for `http.client.HTTPResponse`. """
    response = unittest.mock.Mock(spec=http.client.HTTPResponse)
    response.version = version
    response.status = status
    response.reason = reason_by_http_status[status]

    if header_fields is None:
        header_fields = {}
    response.headers = {name: value for (name, value) in header_fields.items()}
    if body is None:
        body = ""
    body_data = body.encode(dput.methods.http.MESSAGE_BODY_ENCODING)
    response.msg = body_data
    response.read.return_value = body_data
    response.getheader.side_effect = (lambda n: header_fields[n])
    response.getheaders.return_value = list(header_fields.items())

    return response


class http_upload_TestCase(upload_TestCase):
    """ Base for test cases for `methods.http.upload` function. """

    scenarios = NotImplemented

    protocol_scenarios = [
            ('http', {
                'function_to_test': dput.methods.http.upload,
                'protocol': "http",
                'protocol_version': "HTTP/1.0",
                }),
            ('https', {
                'function_to_test': dput.methods.https.upload,
                'protocol': "https",
                'protocol_version': "HTTP/1.0",
                }),
            ]

    login_scenarios = [
            ('username', {
                'login': "lorem",
                }),
            ]

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()

        self.set_response_header_fields()
        self.patch_connection()

        patch_getpass_getpass(self)
        self.fake_password = self.getUniqueString()
        getpass.getpass.return_value = self.fake_password
        if not hasattr(self, 'expected_password'):
            self.expected_password = self.fake_password

    def set_test_args(self):
        """ Set the arguments for the test call to the function. """
        if not hasattr(self, 'progress_type'):
            self.progress_type = 0
        self.test_args = dict(
                fqdn=make_fake_fqdn(self),
                login=self.login,
                incoming=self.incoming_path,
                files_to_upload=self.paths_to_upload,
                debug=False,
                dummy=object(),
                progress=self.progress_type,
                )
        if self.function_to_test is dput.methods.http.upload:
            self.test_args['protocol'] = self.protocol

    def make_upload_uri(self, file_name):
        """ Make the URI for a file for upload. """
        uri = urllib.parse.urlunsplit([
                self.protocol, self.test_args['fqdn'],
                os.path.join(os.path.sep, self.incoming_path, file_name),
                None, None])
        return uri

    def set_response_header_fields(self):
        """ Set the header fields for the HTTP response. """
        if not hasattr(self, 'response_header_fields'):
            self.response_header_fields = {}

    def patch_connection(self):
        """ Patch the connection instance. """
        mock_connection = unittest.mock.Mock(spec=http.client.HTTPConnection)
        mock_connection.getresponse.side_effect = itertools.chain(
                self.responses,
                itertools.repeat(self.responses[-1]))
        def putrequest(method, url, *, skip_accept_encoding=True):
            request = make_mock_httprequest(
                method=method,
                header_fields={},
                url=url)
            mock_connection.latest_request = request
        mock_connection.putrequest = unittest.mock.Mock(
            spec=http.client.HTTPConnection.putrequest,
            wraps=putrequest)
        def putheader(header, *values):
            values = list(values)
            mock_connection.latest_request.headers[header] = "\r\n".join(values)
        mock_connection.putheader = unittest.mock.Mock(
            spec=http.client.HTTPConnection.putheader,
            wraps=putheader)
        def send(data):
            mock_connection.latest_request.data = data
        mock_connection.send = unittest.mock.Mock(
            spec=http.client.HTTPConnection.send,
            wraps=send)
        self.mock_connection = mock_connection
        self.mock_connection_class = unittest.mock.Mock(
                spec=http.client.HTTPConnection,
                return_value=self.mock_connection)
        self.test_args['connection_class'] = self.mock_connection_class


class http_upload_SuccessTestCase(http_upload_TestCase):
    """ Success test cases for `methods.http.upload` function. """

    response_scenarios = [
            ('okay', {
                'responses': [
                    make_mock_httpresponse(
                        status=http.client.OK,
                        body=textwrap.dedent("""\
                            Lorem ipsum, dolor sit amet.
                            """),
                        ),
                    ],
                }),
            ('chatter', {
                'responses': [
                    make_mock_httpresponse(
                        status=http.client.NON_AUTHORITATIVE_INFORMATION,
                        body=textwrap.dedent("""\
                            Lorem ipsum, dolor sit amet.
                            """),
                        ),
                    ],
                }),
            ]

    size_scenarios = [
            ('size-empty', {
                'fake_file': io.BytesIO(),
                }),
            ('size-1k', {
                'fake_file': io.BytesIO(
                    b"Lorem ipsum, dolor sit amet.___\n" * 32),
                }),
            ('size-100k', {
                'fake_file': io.BytesIO(
                    b"Lorem ipsum, dolor sit amet.___\n" * 3200),
                }),
            ]

    incoming_scenarios = list(upload_TestCase.incoming_scenarios)
    for (scenario_name, scenario) in incoming_scenarios:
        scenario['expected_url_path_prefix'] = os.path.join(
                os.path.sep, scenario['incoming_path'])
    del scenario_name, scenario

    scenarios = testscenarios.multiply_scenarios(
            upload_TestCase.files_scenarios,
            size_scenarios,
            upload_TestCase.incoming_scenarios,
            http_upload_TestCase.protocol_scenarios,
            http_upload_TestCase.login_scenarios,
            response_scenarios)

    def test_emits_debug_message_for_upload(self):
        """ Should emit debug message for upload. """
        self.test_args['debug'] = True
        self.function_to_test(**self.test_args)
        for path in self.paths_to_upload:
            expected_uri = self.make_upload_uri(os.path.basename(path))
            expected_output = textwrap.dedent("""\
                    D: HTTP-PUT to URL: {uri}
                    """).format(uri=expected_uri)
            self.expectThat(
                    sys.stdout.getvalue(),
                    testtools.matchers.Contains(expected_output))

    def test_request_has_expected_fields(self):
        """ Should send request with expected fields in header. """
        if not self.paths_to_upload:
            self.skipTest("No files to upload")
        self.function_to_test(**self.test_args)
        registry = FileDouble.get_registry_for_testcase(self)
        path = self.paths_to_upload[-1]
        double = registry[path]
        request = self.mock_connection.latest_request
        expected_fields = {
                'User-Agent': "dput",
                'Connection': "close",
                'Content-Length': "{size:d}".format(
                    size=len(double.fake_file.getvalue())),
                }
        for (name, value) in expected_fields.items():
            self.expectThat(
                    request.headers.get(name),
                    testtools.matchers.Equals(value))


class http_upload_ProgressTestCase(http_upload_TestCase):
    """ Test cases for `methods.http.upload` function, with progress meter. """

    files_scenarios = list(
            (scenario_name, scenario) for (scenario_name, scenario)
            in upload_TestCase.files_scenarios
            if scenario['paths_to_upload'])

    response_scenarios = [
            ('okay', {
                'responses': [
                    make_mock_httpresponse(
                        status=http.client.OK,
                        body=textwrap.dedent("""\
                            Lorem ipsum, dolor sit amet.
                            """),
                        ),
                    ],
                }),
            ]

    progress_scenarios = [
            ('progress-type-1', {
                'progress_type': 1,
                }),
            ('progress-type-2', {
                'progress_type': 2,
                }),
            ]

    scenarios = testscenarios.multiply_scenarios(
            files_scenarios,
            progress_scenarios,
            upload_TestCase.incoming_scenarios,
            http_upload_TestCase.protocol_scenarios,
            http_upload_TestCase.login_scenarios,
            response_scenarios)

    def test_filewithprogress_has_expected_attributes(self):
        """ Should have expected attributes on the `FileWithProgress`. """
        expected_attributes_by_path = (
                make_expected_filewithprogress_attributes_by_path(
                    self, {'ptype': self.progress_type}))
        self.function_to_test(**self.test_args)
        path = self.paths_to_upload[-1]
        expected_attributes = expected_attributes_by_path[path]
        fake_file_attributes = {
                name: getattr(self.fake_filewithprogress, name)
                for name in expected_attributes}
        self.expectThat(
                expected_attributes,
                testtools.matchers.Equals(fake_file_attributes))


class http_upload_UnknownProtocolTestCase(http_upload_TestCase):
    """ Test cases for `methods.http.upload` function, unknown protocol. """

    files_scenarios = list(
            (scenario_name, scenario) for (scenario_name, scenario)
            in upload_TestCase.files_scenarios
            if scenario['paths_to_upload'])

    protocol_scenarios = [
            ('protocol-bogus', {
                'function_to_test': dput.methods.http.upload,
                'protocol': "b0gUs",
                'protocol_version': "b0gUs",
                'expected_exit_status': EXIT_STATUS_FAILURE,
                }),
            ]

    response_scenarios = [
            (scenario_name, scenario) for (scenario_name, scenario)
            in http_upload_SuccessTestCase.response_scenarios]

    scenarios = testscenarios.multiply_scenarios(
            files_scenarios,
            upload_TestCase.incoming_scenarios,
            protocol_scenarios,
            http_upload_TestCase.login_scenarios,
            response_scenarios)

    def test_emits_error_message_when_unknown_protocol(self):
        """ Should emit error message when unknown protocol. """
        try:
            self.function_to_test(**self.test_args)
        except FakeSystemExit:
            pass
        expected_output = "Wrong protocol for upload "
        self.assertIn(expected_output, sys.stderr.getvalue())

    def test_calls_sys_exit_when_unknown_protocol(self):
        """ Should call `sys.exit` when unknown protocol. """
        with testtools.ExpectedException(FakeSystemExit):
            self.function_to_test(**self.test_args)
        sys.exit.assert_called_with(self.expected_exit_status)


class http_upload_FileStatFailureTestCase(http_upload_TestCase):
    """ Test cases for `methods.http.upload` function, `os.stat` failure. """

    files_scenarios = list(
            (scenario_name, scenario) for (scenario_name, scenario)
            in upload_TestCase.files_scenarios
            if scenario['paths_to_upload'])

    os_stat_scenarios = [
            ('os-stat-notfound', {
                'os_stat_scenario_name': "notfound_error",
                'expected_exit_status': EXIT_STATUS_FAILURE,
                }),
            ('os-stat-denied', {
                'os_stat_scenario_name': "denied_error",
                'expected_exit_status': EXIT_STATUS_FAILURE,
                }),
            ]

    response_scenarios = list(
            (scenario_name, scenario) for (scenario_name, scenario)
            in http_upload_SuccessTestCase.response_scenarios)

    scenarios = testscenarios.multiply_scenarios(
            files_scenarios,
            os_stat_scenarios,
            upload_TestCase.incoming_scenarios,
            http_upload_TestCase.protocol_scenarios,
            http_upload_TestCase.login_scenarios,
            response_scenarios)

    def test_emits_error_message(self):
        """ Should emit error message when `os.stat` failure. """
        try:
            self.function_to_test(**self.test_args)
        except FakeSystemExit:
            pass
        expected_output = textwrap.dedent("""\
                Determining size of file '{path}' failed
                """).format(path=self.paths_to_upload[0])
        self.assertIn(expected_output, sys.stderr.getvalue())

    def test_calls_sys_exit_with_expected_exit_status(self):
        """ Should call `sys.exit` with expected exit status. """
        with testtools.ExpectedException(FakeSystemExit):
            self.function_to_test(**self.test_args)
        sys.exit.assert_called_with(self.expected_exit_status)


class http_upload_ResponseErrorTestCase(http_upload_TestCase):
    """ Error test cases for `methods.http.upload` function. """

    files_scenarios = list(
            (scenario_name, scenario) for (scenario_name, scenario)
            in upload_TestCase.files_scenarios
            if scenario['paths_to_upload'])

    response_scenarios = [
            ('server-error body-text', {
                'responses': [
                    make_mock_httpresponse(
                        status=http.client.INTERNAL_SERVER_ERROR,
                        body=textwrap.dedent("""\
                            Lorem ipsum, dolor sit amet.
                            """),
                        ),
                    ],
                'expected_final_status': (
                    http.client.INTERNAL_SERVER_ERROR,
                    "Internal Server Error"),
                'expected_debug_output': textwrap.dedent("""\
                    Lorem ipsum, dolor sit amet.
                    """),
                'expected_exit_status': EXIT_STATUS_FAILURE,
                }),
            ('server-error body-empty', {
                'responses': [
                    make_mock_httpresponse(
                        status=http.client.INTERNAL_SERVER_ERROR,
                        body=""),
                    ],
                'expected_final_status': (
                    http.client.INTERNAL_SERVER_ERROR,
                    "Internal Server Error"),
                'expected_exit_status': EXIT_STATUS_FAILURE,
                }),
            ('authorization-rejected', {
                'responses': [
                    make_mock_httpresponse(
                        status=http.client.UNAUTHORIZED,
                        header_fields={
                            'WWW-Authenticate': "Basic realm=\"pellentesque\"",
                            },
                        body=textwrap.dedent("""\
                            Lorem ipsum, dolor sit amet.
                            """),
                        ),
                    make_mock_httpresponse(
                        status=http.client.UNAUTHORIZED,
                        header_fields={
                            'WWW-Authenticate': "Basic realm=\"pellentesque\"",
                            },
                        body=textwrap.dedent("""\
                            Lorem ipsum, dolor sit amet.
                            """),
                        ),
                    ],
                'expected_final_status': (
                    http.client.UNAUTHORIZED, "Unauthorized"),
                'expected_debug_output': textwrap.dedent("""\
                    Lorem ipsum, dolor sit amet.
                    """),
                'expected_exit_status': EXIT_STATUS_FAILURE,
                }),
            ]

    scenarios = testscenarios.multiply_scenarios(
            files_scenarios,
            upload_TestCase.incoming_scenarios,
            http_upload_TestCase.protocol_scenarios,
            http_upload_TestCase.login_scenarios,
            response_scenarios)

    def test_emits_error_message_when_response_status_error(self):
        """ Should emit debug message when response status is error. """
        if self.expected_final_status[0] == http.client.UNAUTHORIZED:
            self.skipTest("FIXME: can't see how this ever worked?")
        try:
            self.function_to_test(**self.test_args)
        except FakeSystemExit:
            pass
        (code, reason) = self.expected_final_status
        expected_output = textwrap.dedent("""\
                Upload failed: {status} {reason}
                """).format(status=code, reason=reason)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_emits_error_response_body_text_when_debug_true(self):
        """ Should emit error response body text when debug is true. """
        self.test_args['debug'] = True
        if not hasattr(self, 'expected_debug_output'):
            self.skipTest("no response body expected")
        if self.expected_final_status[0] == http.client.UNAUTHORIZED:
            self.skipTest("FIXME: can't see how this ever worked?")
        try:
            self.function_to_test(**self.test_args)
        except FakeSystemExit:
            pass
        expected_output = self.expected_debug_output
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_emits_no_response_body_text_when_debug_false(self):
        """ Should emit no response body text when ‘debug’ is false. """
        self.test_args['debug'] = False
        if not hasattr(self, 'expected_debug_output'):
            self.skipTest("no response body expected")
        if self.expected_final_status[0] == http.client.UNAUTHORIZED:
            self.skipTest("FIXME: can't see how this ever worked?")
        try:
            self.function_to_test(**self.test_args)
        except FakeSystemExit:
            pass
        unwanted_output = self.expected_debug_output
        self.assertNotIn(unwanted_output, sys.stdout.getvalue())

    def test_calls_sys_exit_when_response_status_error(self):
        """ Should call `sys.exit` when response status is error. """
        if self.expected_final_status[0] == http.client.UNAUTHORIZED:
            self.skipTest("FIXME: can't see how this ever worked?")
        with testtools.ExpectedException(FakeSystemExit):
            self.function_to_test(**self.test_args)
        sys.exit.assert_called_with(self.expected_exit_status)


class http_upload_ResponseUnauthorizedTestCase(http_upload_TestCase):
    """ Unauthorized test cases for `methods.http.upload` function. """

    files_scenarios = list(
            (scenario_name, scenario) for (scenario_name, scenario)
            in upload_TestCase.files_scenarios
            if scenario['paths_to_upload'])

    response_scenarios = [
            ('authorization-accepted', {
                'responses': [
                    make_mock_httpresponse(
                        status=http.client.UNAUTHORIZED,
                        header_fields={
                            'WWW-Authenticate': "Basic realm=\"pellentesque\"",
                            },
                        body=textwrap.dedent("""\
                            Lorem ipsum, dolor sit amet.
                            """),
                        ),
                    make_mock_httpresponse(
                        status=http.client.OK,
                        body=textwrap.dedent("""\
                            Lorem ipsum, dolor sit amet.
                            """),
                        ),
                    ],
                'expected_final_status': (http.client.OK, "Okay"),
                'expected_exit_status': EXIT_STATUS_SUCCESS,
                }),
            ]

    scenarios = testscenarios.multiply_scenarios(
            files_scenarios,
            upload_TestCase.incoming_scenarios,
            http_upload_TestCase.protocol_scenarios,
            http_upload_TestCase.login_scenarios,
            response_scenarios)

    def test_calls_getpass(self):
        """ Should call `getpass.getpass` when status is unauthorized. """
        self.skipTest("FIXME: can't see how this ever worked?")
        self.function_to_test(**self.test_args)
        getpass.getpass.assert_called_with()


def make_host_spec(username, host):
    """ Make an SSH host specification. """
    host_spec = host
    if username != "*":
        host_spec = "{user}@{fqdn}".format(user=username, fqdn=host)
    return host_spec


def make_remote_spec(username, host, dir_path):
    """ Make an SCP remote specification. """
    host_spec = make_host_spec(username, host)
    remote_spec = "{host}:{dir}".format(host=host_spec, dir=dir_path)
    return remote_spec


class ssh_channel_upload_TestCase(upload_TestCase):
    """ Base for test cases for upload over SSH channel. """

    function_to_test = NotImplemented

    scenarios = NotImplemented

    login_scenarios = [
            ('login-username', {
                'login': "lorem",
                }),
            ('login-wildcard', {
                'login': "*",
                }),
            ]

    stat_mode_scenarios = [
            ('stat-mode-default', {}),
            ('stat-mode-0620', {
                'stat_mode': 0o0620,
                'expected_ssh_chmod': True,
                }),
            ('stat-mode-0640', {
                'stat_mode': 0o0644,
                'expected_ssh_chmod': False,
                }),
            ]

    def set_upload_file_modes(self):
        """ Set filesystem modes for upload files. """
        registry = FileDouble.get_registry_for_testcase(self)
        if hasattr(self, 'stat_mode'):
            for path in self.paths_to_upload:
                file_double = registry[path]
                file_double.stat_result = file_double.stat_result._replace(
                        st_mode=self.stat_mode)

    def set_ssh_chmod_subprocess_double(self):
        """ Set the ‘ssh … chmod’ test double for the subprocess. """
        command_file_path = "/usr/bin/ssh"
        argv = [os.path.basename(command_file_path)]
        argv.extend(self.expected_ssh_options)
        argv.append(make_host_spec(
                username=self.login, host=self.test_args['fqdn']))
        argv.extend(["chmod", "0644"])
        argv.extend(
                os.path.join(self.incoming_path, os.path.basename(path))
                for path in self.paths_to_upload)
        double = SubprocessDouble(command_file_path, argv=argv)
        double.register_for_testcase(self)
        check_call_scenario_name = getattr(
                self, 'ssh_chmod_check_call_scenario_name', "success")
        double.set_subprocess_check_call_scenario(check_call_scenario_name)
        self.ssh_chmod_subprocess_double = double


class scp_upload_TestCase(ssh_channel_upload_TestCase):
    """ Test cases for `methods.scp.upload` function. """

    function_to_test = staticmethod(dput.methods.scp.upload)

    scenarios = NotImplemented

    ssh_config_scenarios = [
            ('ssh-opts-none', {
                'ssh_config_options': [],
                'expected_ssh_options': [],
                }),
            ('ssh-opts-one', {
                'ssh_config_options': ["foo"],
                'expected_ssh_options': ["-o", "foo"],
                }),
            ('ssh-opts-three', {
                'ssh_config_options': ["foo", "bar", "baz"],
                'expected_ssh_options': [
                    "-o", "foo", "-o", "bar", "-o", "baz"],
                }),
            ]

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()

        patch_os_lstat(self)
        self.set_upload_file_modes()

        self.set_scp_subprocess_double()
        self.set_ssh_chmod_subprocess_double()

    def set_test_args(self):
        """ Set the arguments for the test call to the function. """
        self.test_args = dict(
                fqdn=make_fake_fqdn(self),
                login=self.login,
                incoming=self.incoming_path,
                files_to_upload=self.paths_to_upload,
                debug=None,
                compress=self.compress,
                ssh_config_options=self.ssh_config_options,
                progress=object(),
                )

    def set_scp_subprocess_double(self):
        """ Set the ‘scp’ test double for the subprocess. """
        command_file_path = "/usr/bin/scp"
        argv = [os.path.basename(command_file_path), "-p"]
        argv.extend(self.scp_compress_options)
        argv.extend(self.expected_ssh_options)
        argv.extend(self.paths_to_upload)
        argv.append(make_remote_spec(
                username=self.login, host=self.test_args['fqdn'],
                dir_path=self.incoming_path))
        double = SubprocessDouble(command_file_path, argv=argv)
        double.register_for_testcase(self)
        check_call_scenario_name = getattr(
                self, 'scp_subprocess_check_call_scenario_name', "success")
        double.set_subprocess_check_call_scenario(check_call_scenario_name)
        self.scp_subprocess_double = double


class scp_upload_ScpTestCase(scp_upload_TestCase):
    """ Test cases for `methods.scp.upload` function, with ‘scp’ command. """

    compress_scenarios = [
            ('compress-false', {
                'compress': False,
                'scp_compress_options': [],
                }),
            ('compress-true', {
                'compress': True,
                'scp_compress_options': ["-C"],
                }),
            ]

    scenarios = testscenarios.multiply_scenarios(
            upload_TestCase.files_scenarios,
            upload_TestCase.incoming_scenarios,
            ssh_channel_upload_TestCase.login_scenarios,
            ssh_channel_upload_TestCase.stat_mode_scenarios,
            compress_scenarios,
            scp_upload_TestCase.ssh_config_scenarios)

    def test_emits_debug_message_for_upload(self):
        """ Should emit debug message for files upload. """
        self.test_args['debug'] = True
        self.function_to_test(**self.test_args)
        expected_output = textwrap.dedent("""\
                D: Uploading with scp to {host}:{incoming}
                """).format(
                    host=make_host_spec(
                        username=self.login, host=self.test_args['fqdn']),
                    incoming=self.incoming_path)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_calls_check_call_with_expected_scp_command(self):
        """ Should call `subprocess.check_call` with ‘scp’ command. """
        self.function_to_test(**self.test_args)
        expected_call = unittest.mock.call(self.scp_subprocess_double.argv)
        self.assertIn(expected_call, subprocess.check_call.mock_calls)

    def test_emits_error_message_when_scp_failure(self):
        """ Should emit error message when ‘scp’ command fails. """
        double = self.scp_subprocess_double
        double.set_subprocess_check_call_scenario("failure")
        try:
            self.function_to_test(**self.test_args)
        except FakeSystemExit:
            pass
        expected_output = "Error while uploading."
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_calls_sys_exit_when_scp_failure(self):
        """ Should call `sys.exit` when ‘scp’ command fails. """
        double = self.scp_subprocess_double
        double.set_subprocess_check_call_scenario("failure")
        with testtools.ExpectedException(FakeSystemExit):
            self.function_to_test(**self.test_args)
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)


class scp_upload_ChmodTestCase(scp_upload_TestCase):
    """ Test cases for `methods.scp.upload` function, with ‘ssh … chmod’. """

    files_scenarios = list(
            (scenario_name, scenario) for (scenario_name, scenario)
            in upload_TestCase.files_scenarios
            if scenario['paths_to_upload'])

    stat_mode_scenarios = list(
            (scenario_name, scenario) for (scenario_name, scenario)
            in ssh_channel_upload_TestCase.stat_mode_scenarios
            if scenario.get('expected_ssh_chmod', False))

    compress_scenarios = [
            ('compress-false', {
                'compress': False,
                'scp_compress_options': [],
                }),
            ]

    scenarios = testscenarios.multiply_scenarios(
            files_scenarios,
            upload_TestCase.incoming_scenarios,
            ssh_channel_upload_TestCase.login_scenarios,
            stat_mode_scenarios,
            compress_scenarios,
            scp_upload_TestCase.ssh_config_scenarios)

    def test_emits_debug_message_for_fixing_permissions(self):
        """ Should emit debug message for fixing file permissions . """
        self.test_args['debug'] = True
        self.function_to_test(**self.test_args)
        expected_output = "D: Fixing some permissions"
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_calls_check_call_with_expected_ssh_chmod_command(self):
        """ Should call `subprocess.check_call` with ‘ssh … chmod’ command. """
        self.function_to_test(**self.test_args)
        expected_call = unittest.mock.call(
                self.ssh_chmod_subprocess_double.argv)
        self.assertIn(expected_call, subprocess.check_call.mock_calls)

    def test_emits_error_message_when_ssh_chmod_failure(self):
        """ Should emit error message when ‘ssh … chmod’ command fails. """
        double = self.ssh_chmod_subprocess_double
        double.set_subprocess_check_call_scenario("failure")
        try:
            self.function_to_test(**self.test_args)
        except FakeSystemExit:
            pass
        expected_output = "Error while fixing permissions."
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_calls_sys_exit_when_ssh_chmod_failure(self):
        """ Should call `sys.exit` when ‘ssh … chmod’ command fails. """
        double = self.ssh_chmod_subprocess_double
        double.set_subprocess_check_call_scenario("failure")
        with testtools.ExpectedException(FakeSystemExit):
            self.function_to_test(**self.test_args)
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)


class rsync_upload_TestCase(ssh_channel_upload_TestCase):
    """ Test cases for `methods.rsync.upload` function. """

    function_to_test = staticmethod(dput.methods.rsync.upload)

    scenarios = testscenarios.multiply_scenarios(
            upload_TestCase.files_scenarios,
            upload_TestCase.incoming_scenarios,
            ssh_channel_upload_TestCase.login_scenarios,
            ssh_channel_upload_TestCase.stat_mode_scenarios)

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()

        self.expected_rsync_options = dput.methods.rsync.rsync_options
        self.set_rsync_subprocess_double()

        self.expected_ssh_options = []
        self.set_ssh_chmod_subprocess_double()

    def set_test_args(self):
        """ Set the arguments for the test call to the function. """
        self.test_args = dict(
                fqdn=make_fake_fqdn(self),
                login=self.login,
                incoming=self.incoming_path,
                files_to_upload=self.paths_to_upload,
                debug=False,
                dummy=object(),
                progress=object(),
                )

    def set_rsync_subprocess_double(self):
        """ Set the ‘rsync’ test double for the subprocess. """
        command_file_path = "/usr/bin/rsync"
        argv = [os.path.basename(command_file_path)]
        argv.extend(self.paths_to_upload)
        argv.extend(self.expected_rsync_options)
        argv.append(make_remote_spec(
                username=self.login, host=self.test_args['fqdn'],
                dir_path=self.incoming_path))
        double = SubprocessDouble(command_file_path, argv=argv)
        double.register_for_testcase(self)
        check_call_scenario_name = getattr(
                self, 'rsync_check_call_scenario_name', "success")
        double.set_subprocess_check_call_scenario(check_call_scenario_name)
        self.rsync_subprocess_double = double

    def test_emits_debug_message_for_upload(self):
        """ Should emit debug message for files upload. """
        self.test_args['debug'] = True
        self.function_to_test(**self.test_args)
        expected_output = textwrap.dedent("""\
                D: Uploading with rsync to {host}:{incoming}
                """).format(
                    host=make_host_spec(
                        username=self.login, host=self.test_args['fqdn']),
                    incoming=self.incoming_path)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_calls_check_call_with_expected_rsync_command(self):
        """ Should call `subprocess.check_call` with ‘rsync’ command. """
        self.function_to_test(**self.test_args)
        expected_call = unittest.mock.call(self.rsync_subprocess_double.argv)
        self.assertIn(expected_call, subprocess.check_call.mock_calls)

    def test_emits_error_message_when_rsync_failure(self):
        """ Should emit error message when ‘rsync’ command fails. """
        double = self.rsync_subprocess_double
        double.set_subprocess_check_call_scenario("failure")
        try:
            self.function_to_test(**self.test_args)
        except FakeSystemExit:
            pass
        expected_output = "Error while uploading."
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_calls_sys_exit_when_rsync_failure(self):
        """ Should call `sys.exit` when ‘rsync’ command fails. """
        double = self.rsync_subprocess_double
        double.set_subprocess_check_call_scenario("failure")
        with testtools.ExpectedException(FakeSystemExit):
            self.function_to_test(**self.test_args)
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)

    def test_emits_debug_message_for_fixing_permissions(self):
        """ Should emit debug message for fixing file permissions . """
        self.test_args['debug'] = True
        self.function_to_test(**self.test_args)
        expected_output = textwrap.dedent("""\
                D: Fixing file permissions with {host}
                """).format(
                    host=make_host_spec(
                        username=self.login, host=self.test_args['fqdn']))
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_calls_check_call_with_expected_ssh_chmod_command(self):
        """ Should call `subprocess.check_call` with ‘ssh … chmod’ command. """
        self.function_to_test(**self.test_args)
        expected_call = unittest.mock.call(
                list(self.ssh_chmod_subprocess_double.argv))
        self.assertIn(expected_call, subprocess.check_call.mock_calls)

    def test_emits_error_message_when_ssh_chmod_failure(self):
        """ Should emit error message when ‘ssh … chmod’ command fails. """
        double = self.ssh_chmod_subprocess_double
        double.set_subprocess_check_call_scenario("failure")
        try:
            self.function_to_test(**self.test_args)
        except FakeSystemExit:
            pass
        expected_output = "Error while fixing permission."
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_calls_sys_exit_when_ssh_chmod_failure(self):
        """ Should call `sys.exit` when ‘ssh … chmod’ command fails. """
        double = self.ssh_chmod_subprocess_double
        double.set_subprocess_check_call_scenario("failure")
        with testtools.ExpectedException(FakeSystemExit):
            self.function_to_test(**self.test_args)
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)


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
