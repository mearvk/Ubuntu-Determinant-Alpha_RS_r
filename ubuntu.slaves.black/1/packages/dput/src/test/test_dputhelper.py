# test/test_dputhelper.py
# Part of ‘dput’, a Debian package upload toolkit.
#
# This is free software, and you are welcome to redistribute it under
# certain conditions; see the end of this file for copyright
# information, grant of license, and disclaimer of warranty.

""" Unit tests for ‘dput.helper.dputhelper’ module. """

import collections
import doctest
import io
import itertools
import locale
import os
import subprocess
import sys
import textwrap
import unittest.mock

import pkg_resources
import testscenarios
import testtools
import testtools.matchers

from dput.helper import dputhelper

from .helper import (
        EXIT_STATUS_COMMAND_NOT_FOUND,
        EXIT_STATUS_FAILURE,
        EXIT_STATUS_SUCCESS,
        SubprocessDouble,
        patch_subprocess_check_call,
        patch_sys_argv,
        patch_system_interfaces,
        patch_time_time,
        )


class check_call_TestCase(
        testscenarios.WithScenarios,
        testtools.TestCase):
    """ Test cases for `check_call` function. """

    default_args = collections.OrderedDict([
            ('args', ["arg-{}".format(n) for n in range(5)]),
            ])

    scenarios = [
            ('success', {
                'test_args': default_args.copy(),
                'subprocess_check_call_scenario_name': 'success',
                'expected_exit_status': EXIT_STATUS_SUCCESS,
                }),
            ('failure', {
                'test_args': default_args.copy(),
                'subprocess_check_call_scenario_name': 'failure',
                'expected_exit_status': EXIT_STATUS_FAILURE,
                'expected_output': textwrap.dedent("""\
                    Warning: The execution of '...' as
                      '...'
                      returned a nonzero exit code.
                    """)
                }),
            ('not-found', {
                'test_args': default_args.copy(),
                'subprocess_check_call_scenario_name': 'not_found',
                'expected_exit_status': EXIT_STATUS_COMMAND_NOT_FOUND,
                'expected_output': textwrap.dedent("""\
                    Error: Failed to execute '...'.
                           The file may not exist or not be executable.
                    """)
                }),
            ]

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()
        patch_system_interfaces(self)

        patch_subprocess_check_call(self)

        self.set_subprocess_double()

    def set_subprocess_double(self):
        """ Set the test double for the subprocess. """
        command_file_path = self.test_args['args'][0]
        command_argv = self.test_args['args']
        double = SubprocessDouble(command_file_path, command_argv)
        double.register_for_testcase(self)
        double.set_subprocess_check_call_scenario(
                self.subprocess_check_call_scenario_name)
        self.subprocess_double = double

    def test_calls_os_spawnv_with_specified_args(self):
        """ Should call `subprocess.check_call` with specified arguments. """
        dputhelper.check_call(*self.test_args.values())
        subprocess.check_call.assert_called_with(*self.test_args.values())

    def test_returns_expected_exit_status(self):
        """ Should return expected exit status for subprocess. """
        exit_status = dputhelper.check_call(*self.test_args.values())
        self.assertEqual(self.expected_exit_status, exit_status)

    def test_emits_expected_output(self):
        """ Should emit the expected output messages. """
        if not hasattr(self, 'expected_output'):
            self.expected_output = ""
        dputhelper.check_call(*self.test_args.values())
        self.assertThat(
                sys.stderr.getvalue(),
                testtools.matchers.DocTestMatches(
                    self.expected_output, flags=doctest.ELLIPSIS))


class FileWithProgress_TestCase(
        testscenarios.WithScenarios,
        testtools.TestCase):
    """ Base for test cases for the `FileWithProgress` class. """

    default_args = {
            'ptype': 0,
            'progressf': sys.__stdout__,
            'size': -1,
            'step': 1024,
            }

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()
        patch_system_interfaces(self)

        self.test_file = io.StringIO(
                getattr(self, 'content', ""))

        self.set_test_args()
        self.make_instance()

    def set_test_args(self):
        """ Set the arguments for the test instance constructor. """
        self.test_args = dict(
                f=self.test_file,
                )
        if hasattr(self, 'test_ptype'):
            self.test_args['ptype'] = self.test_ptype
        if hasattr(self, 'test_progressf'):
            self.test_args['progressf'] = self.test_progressf
        if hasattr(self, 'test_size'):
            self.test_args['size'] = self.test_size
        if hasattr(self, 'test_step'):
            self.test_args['step'] = self.test_step

    def make_instance(self):
        """ Make the test instance of the class. """
        self.instance = dputhelper.FileWithProgress(**self.test_args)


class FileWithProgress_ArgsTestCase(FileWithProgress_TestCase):
    """ Test cases for constructor arguments for `FileWithProgress` class. """

    scenarios = [
            ('simple', {}),
            ('all args', {
                'test_ptype': 1,
                'test_progressf': io.StringIO(),
                'test_size': 10,
                'test_step': 2,
                }),
            ]

    def test_has_specified_file(self):
        """ Should have specified file object as `f` attribute. """
        self.assertIs(self.test_file, self.instance.f)

    def test_has_specified_ptype(self):
        """ Should have specified progress type value as `ptype` attribute. """
        expected_ptype = getattr(
                self, 'test_ptype', self.default_args['ptype'])
        self.assertEqual(expected_ptype, self.instance.ptype)

    def test_has_specified_progressf(self):
        """ Should have specified progress file as `progressf` attribute. """
        expected_progressf = getattr(
                self, 'test_progressf', self.default_args['progressf'])
        self.assertEqual(expected_progressf, self.instance.progressf)

    def test_has_specified_size(self):
        """ Should have specified size value as `size` attribute. """
        expected_size = getattr(
                self, 'test_size', self.default_args['size'])
        self.assertEqual(expected_size, self.instance.size)

    def test_has_specified_step(self):
        """ Should have specified step value as `step` attribute. """
        expected_step = getattr(
                self, 'test_step', self.default_args['step'])
        self.assertEqual(expected_step, self.instance.step)

    def test_has_attributes_from_component_file(self):
        """ Should have attributes directly from component file. """
        attr_names = [
                'b0gUs',
                'mode', 'name', 'encoding',
                'readable', 'seekable', 'writable',
                'seek', 'tell', 'write',
                ]
        for attr_name in attr_names:
            expected_attr_value = getattr(self.test_file, attr_name, None)
            self.expectThat(
                    getattr(self.instance, attr_name, None),
                    testtools.matchers.Equals(expected_attr_value))


class FileWithProgress_OutputTestCase(FileWithProgress_TestCase):
    """ Test cases for progress output for `FileWithProgress` class. """

    content_scenarios = [
            ('empty', {
                'content': "",
                }),
            ('10 000 chars', {
                'content': "0123456789\n" * 1000,
                }),
            ('10 000 000 chars', {
                'content': "0123456789\n" * 1000000,
                }),
            ]

    ptype_scenarios = [
            ('ptype default', {}),
            ('ptype 0', {'test_ptype': 0}),
            ('ptype 1', {'test_ptype': 1}),
            ('ptype 2', {'test_ptype': 2}),
            ]

    size_scenarios = [
            ('size default', {}),
            ('size 0', {
                'test_size': 0,
                }),
            ('size specified', {
                'specify_file_size': True,
                }),
            ]

    step_scenarios = [
            ('step default', {}),
            ('step 5', {'test_step': 5}),
            ('step 500', {'test_step': 500}),
            ('step 50 000', {'test_step': 50000}),
            ]

    scenarios = testscenarios.multiply_scenarios(
            content_scenarios, ptype_scenarios,
            size_scenarios, step_scenarios)

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()

        self.test_file = io.StringIO(self.content)
        self.test_progressf = io.StringIO()
        self.set_test_args()
        self.make_instance()

        if getattr(self, 'specify_file_size', False):
            self.test_size = len(self.content)
        self.set_expected_output()

    def set_expected_output(self):
        """ Set the expected output for this test case. """
        ptype = getattr(self, 'test_ptype', self.default_args['ptype'])
        if ptype == 1:
            self.expected_output = "/"
        elif ptype == 2:
            step = getattr(self, 'test_step', 1024)
            total_bytes = len(self.content)
            total_hunks = int(total_bytes / step)
            total_hunks_text = "{size:d}k".format(size=total_hunks)
            file_size = getattr(self, 'test_size', self.default_args['size'])
            total_steps = int(
                    (total_bytes + step - 1) / step)
            if not file_size:
                total_steps = 0
            total_steps_text = "{size:d}k".format(size=total_steps)
            progress_text = "{hunks}/{steps}".format(
                    hunks=total_hunks_text, steps=total_steps_text)
            if file_size < 0 or getattr(self, 'specify_file_size', False):
                progress_text = total_hunks_text
            self.expected_output = progress_text
        else:
            # `ptype == 0` specifies no progress output.
            self.expected_output = ""

        if not self.content:
            # No progress output for an empty file.
            self.expected_output = ""

    def test_emits_expected_output_for_content(self):
        """ Should emit expected output for file content. """
        self.instance.read()
        output_stream_content = self.test_progressf.getvalue()
        self.assertEqual(
                self.expected_output, output_stream_content)

    def test_clears_output_on_close(self):
        """ Should clear progress output when closed. """
        self.instance.read()
        self.instance.close()
        expected_output = (
                self.expected_output
                + len(self.expected_output) * "\b"
                + len(self.expected_output) * " "
                + len(self.expected_output) * "\b"
                )
        output_stream_content = self.test_progressf.getvalue()
        self.assertEqual(expected_output, output_stream_content)


def patch_filewithprogress(testcase):
    """ Patch the `FileWithProgress` class for the test case. """
    if not hasattr(testcase, 'fake_filewithprogress'):
        testcase.fake_filewithprogress = unittest.mock.MagicMock(
                spec=dputhelper.FileWithProgress, name="FileWithProgress")

    def fake_filewithprogress_factory(
            f, ptype=0, progressf=sys.stdout, size=-1, step=1024):
        result = testcase.fake_filewithprogress
        result.f = f
        result.ptype = ptype
        result.progressf = progressf
        result.size = size
        result.step = step
        return result

    func_patcher = unittest.mock.patch.object(
            dputhelper, "FileWithProgress", autospec=True,
            side_effect=fake_filewithprogress_factory)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


class make_text_stream_TestCase(
        testscenarios.WithScenarios,
        testtools.TestCase):
    """ Test cases for `make_text_stream` function. """

    fake_preferred_encoding = str("johab")

    scenarios = [
            ('text-stream-no-encoding', {
                'fake_file_params': {
                    'type': io.StringIO,
                    'content': u"Lorem ipsum",
                    'encoding': None,
                    },
                'expected_encoding': None,
                'expected_content': u"Lorem ipsum",
                }),
            ('text-stream', {
                'fake_file_params': {
                    'type': io.TextIOWrapper,
                    'content': u"Lorem ipsum",
                    'encoding': str("utf-8"),
                    },
                'expected_encoding': "utf-8",
                'expected_content': u"Lorem ipsum",
                }),
            ('byte-stream', {
                'fake_file_params': {
                    'type': io.BytesIO,
                    'content': u"Lorem ipsum".encode(fake_preferred_encoding),
                    },
                'expected_encoding': fake_preferred_encoding,
                'expected_content': u"Lorem ipsum",
                }),
            ]

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()

        self.patch_locale_getpreferredencoding()

        self.set_fake_file()

        self.set_test_args()

    def set_test_args(self):
        """ Set the arguments for the test call to the function. """
        self.test_args = dict(
                stream=self.fake_file,
                )

    def patch_locale_getpreferredencoding(self):
        """ Patch the `locale.getpreferredencoding` function. """
        func_patcher = unittest.mock.patch.object(
                locale, "getpreferredencoding", autospec=True,
                return_value=self.fake_preferred_encoding)
        func_patcher.start()
        self.addCleanup(func_patcher.stop)

    def set_fake_file(self):
        """ Set the fake file for this test case. """
        file_params = self.fake_file_params
        file_type = file_params['type']

        content = file_params['content']
        if file_params.get('encoding', None) is not None:
            content_bytestream = io.BytesIO(
                    content.encode(file_params['encoding']))
        elif isinstance(content, bytes):
            content_bytestream = io.BytesIO(content)
        else:
            content_bytestream = None

        if isinstance(file_type, type):
            if issubclass(file_type, io.TextIOWrapper):
                fake_file = file_type(
                        content_bytestream, encoding=file_params['encoding'])
            else:
                fake_file = file_type(content)
        else:
            # Not actually a type, but a factory function.
            fake_file = file_type()
            fake_file.write(file_params['content'])
            fake_file.seek(0)

        self.fake_file = fake_file

    def test_result_is_specified_stream_if_has_encoding(self):
        """ Result should be the same stream if it has an encoding. """
        if not isinstance(self.fake_file, io.TextIOBase):
            self.skipTest("Specified stream is not text")
        result = dputhelper.make_text_stream(**self.test_args)
        self.assertIs(self.fake_file, result)

    def test_result_has_expected_encoding(self):
        """ Result should have the expected `encoding` attribute. """
        result = dputhelper.make_text_stream(**self.test_args)
        self.assertEqual(self.expected_encoding, result.encoding)

    def test_result_emits_expected_content(self):
        """ Result should emit the expected content. """
        result = dputhelper.make_text_stream(**self.test_args)
        if isinstance(result, io.BufferedRandom):
            with io.open(
                    result.name, mode='r',
                    encoding=self.fake_file.encoding) as infile:
                content = infile.read()
        else:
            content = result.read()
        self.assertEqual(self.expected_content, content)


GetoptResult = collections.namedtuple('GetoptResult', ['optlist', 'args'])


class getopt_SuccessTestCase(
        testscenarios.WithScenarios,
        testtools.TestCase):
    """ Success test cases for `getopt` function. """

    scenarios = [
            ('empty', {
                'test_argv': [object()],
                'expected_result': GetoptResult(
                    optlist=[], args=[]),
                }),
            ('no opts', {
                'test_argv': [object(), "foo", "bar", "baz"],
                'expected_result': GetoptResult(
                    optlist=[], args=["foo", "bar", "baz"]),
                }),
            ('only short opts', {
                'test_argv': [object(), "-a", "-b", "-c"],
                'test_shortopts': "axbycz",
                'expected_result': GetoptResult(
                    optlist=[
                        ('-a', ""),
                        ('-b', ""),
                        ('-c', ""),
                        ],
                    args=[]),
                }),
            ('only long opts', {
                'test_argv': [object(), "--alpha", "--beta", "--gamma"],
                'test_longopts': [
                    "wibble", "alpha", "wobble",
                    "beta", "wubble", "gamma",
                    ],
                'expected_result': GetoptResult(
                    optlist=[
                        ('--alpha', ""),
                        ('--beta', ""),
                        ('--gamma', ""),
                        ],
                    args=[]),
                }),
            ('long opt prefix', {
                'test_argv': [object(), "--al", "--be", "--ga"],
                'test_longopts': [
                    "wibble", "alpha", "wobble",
                    "beta", "wubble", "gamma",
                    ],
                'expected_result': GetoptResult(
                    optlist=[
                        ('--alpha', ""),
                        ('--beta', ""),
                        ('--gamma', ""),
                        ],
                    args=[]),
                }),
            ('short opt cluster', {
                'test_argv': [object(), "-abc"],
                'test_shortopts': "abc",
                'expected_result': GetoptResult(
                    optlist=[
                        ('-a', ""),
                        ('-b', ""),
                        ('-c', ""),
                        ],
                    args=[]),
                }),
            ('short with args', {
                'test_argv': [object(), "-a", "-b", "eggs", "-cbeans"],
                'test_shortopts': "ab:c:",
                'expected_result': GetoptResult(
                    optlist=[
                        ('-a', ""),
                        ('-b', "eggs"),
                        ('-c', "beans"),
                        ],
                    args=[]),
                }),
            ('long with args', {
                'test_argv': [
                    object(),
                    "--alpha",
                    "--beta=eggs",
                    "--gamma", "beans"],
                'test_longopts': [
                    "wibble", "alpha", "wobble",
                    "beta=", "wubble", "gamma=",
                    ],
                'expected_result': GetoptResult(
                    optlist=[
                        ('--alpha', ""),
                        ('--beta', "eggs"),
                        ('--gamma', "beans"),
                        ],
                    args=[]),
                }),
            ('long with optional args', {
                'test_argv': [
                    object(),
                    "--alpha",
                    "--beta=eggs",
                    "--gamma"],
                'test_longopts': [
                    "wibble", "alpha", "wobble",
                    "beta==", "wubble", "gamma==",
                    ],
                'expected_result': GetoptResult(
                    optlist=[
                        ('--alpha', ""),
                        ('--beta', "eggs"),
                        ('--gamma', ""),
                        ],
                    args=[]),
                }),
            ('single hyphen arg', {
                'test_argv': [object(), "-a", "-b", "-c", "-"],
                'test_shortopts': "axbycz",
                'expected_result': GetoptResult(
                    optlist=[
                        ('-a', ""),
                        ('-b', ""),
                        ('-c', ""),
                        ],
                    args=["-"]),
                }),
            ('explicit end of opts', {
                'test_argv': [
                    object(),
                    "--alpha",
                    "--beta",
                    "--",
                    "--spam"],
                'test_longopts': [
                    "wibble", "alpha", "wobble",
                    "beta", "wubble", "gamma",
                    ],
                'expected_result': GetoptResult(
                    optlist=[
                        ('--alpha', ""),
                        ('--beta', ""),
                        ],
                    args=["--spam"]),
                }),
            ]

    def test_returns_expected_result_for_argv(self):
        """ Should return expected result for specified argv. """
        shortopts = getattr(self, 'test_shortopts', "")
        longopts = getattr(self, 'test_longopts', "")
        result = dputhelper.getopt(
                self.test_argv[1:], shortopts, longopts)
        self.assertEqual(self.expected_result, result)


class getopt_ErrorTestCase(
        testscenarios.WithScenarios,
        testtools.TestCase):
    """ Error test cases for `getopt` function. """

    scenarios = [
            ('short opt unknown', {
                'test_argv': [object(), "-a", "-b", "-z", "-c"],
                'test_shortopts': "abc",
                'expected_error': dputhelper.DputException,
                }),
            ('short missing arg', {
                'test_argv': [object(), "-a", "-b", "-c"],
                'test_shortopts': "abc:",
                'expected_error': dputhelper.DputException,
                }),
            ('long opt unknown', {
                'test_argv': [
                    object(), "--alpha", "--beta", "--zeta", "--gamma"],
                'test_longopts': [
                    "alpha", "beta", "gamma"],
                'expected_error': dputhelper.DputException,
                }),
            ('long ambiguous prefix', {
                'test_argv': [
                    object(), "--alpha", "--be", "--gamma"],
                'test_longopts': [
                    "alpha", "beta", "bettong", "bertha", "gamma"],
                'expected_error': dputhelper.DputException,
                }),
            ('long missing arg', {
                'test_argv': [object(), "--alpha", "--beta", "--gamma"],
                'test_longopts': [
                    "alpha", "beta", "gamma="],
                'expected_error': dputhelper.DputException,
                }),
            ('long unexpected arg', {
                'test_argv': [
                    object(), "--alpha", "--beta=beans", "--gamma"],
                'test_longopts': [
                    "alpha", "beta", "gamma"],
                'expected_error': dputhelper.DputException,
                }),
            ]

    def test_raises_expected_error_for_argv(self):
        """ Should raise expected error for specified argv. """
        shortopts = getattr(self, 'test_shortopts', "")
        longopts = getattr(self, 'test_longopts', "")
        with testtools.ExpectedException(self.expected_error):
            dputhelper.getopt(
                    self.test_argv[1:], shortopts, longopts)


def patch_getopt(testcase):
    """ Patch the `getopt` function for the specified test case. """
    def fake_getopt(args, shortopts, longopts):
        result = (testcase.getopt_opts, testcase.getopt_args)
        return result

    func_patcher = unittest.mock.patch.object(
            dputhelper, "getopt", autospec=True,
            side_effect=fake_getopt)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


class get_progname_TestCase(
        testscenarios.WithScenarios,
        testtools.TestCase):
    """ Test cases for `get_progname` function. """

    command_name_scenarios = [
            ('command-simple', {
                'argv_zero': "amet",
                'expected_progname': "amet",
                }),
            ('command-relative', {
                'argv_zero': "lorem/ipsum/dolor/sit/amet",
                'expected_progname': "amet",
                }),
            ('command-absolute', {
                'argv_zero': "/lorem/ipsum/dolor/sit/amet",
                'expected_progname': "amet",
                }),
            ]

    subsequent_args_scenarios = [
            ('args-empty', {
                'argv_remain': [],
                }),
            ('args-one-word', {
                'argv_remain': ["spam"],
                }),
            ('args-three-words', {
                'argv_remain': ["spam", "beans", "eggs"],
                }),
            ('args-one-option', {
                'argv_remain': ["--spam"],
                }),
            ]

    scenarios = testscenarios.multiply_scenarios(
            command_name_scenarios, subsequent_args_scenarios)

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()

        self.test_argv = [self.argv_zero] + self.argv_remain

    def test_returns_expected_progname(self):
        """ Should return expected progname value for command line. """
        result = dputhelper.get_progname(self.test_argv)
        self.assertEqual(self.expected_progname, result)

    def test_queries_sys_argv_if_argv_unspecified(self):
        """ Should query `sys.argv` if no `argv` specified. """
        self.sys_argv = self.test_argv
        patch_sys_argv(self)
        result = dputhelper.get_progname()
        self.assertEqual(self.expected_progname, result)


def patch_pkg_resources_get_distribution(testcase):
    """ Patch `pkg_resources.get_distribution` for the test case. """
    if not hasattr(testcase, 'fake_distribution'):
        testcase.fake_distribution = unittest.mock.MagicMock(
                pkg_resources.Distribution)
    func_patcher = unittest.mock.patch.object(
            pkg_resources, "get_distribution", autospec=True,
            return_value=testcase.fake_distribution)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


class get_distribution_version_TestCase(
        testscenarios.WithScenarios,
        testtools.TestCase):
    """ Test cases for `get_distribution_version` function. """

    scenarios = [
            ('simple', {
                'fake_distribution': unittest.mock.MagicMock(
                    project_name="lorem", version="42.23"),
                }),
            ]

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()

        patch_pkg_resources_get_distribution(self)

    def test_returns_expected_result(self):
        """ Should return expected version for the distribution. """
        result = dputhelper.get_distribution_version()
        expected_version = self.fake_distribution.version
        self.assertEqual(expected_version, result)


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
