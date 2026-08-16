# test/test_crypto.py
# Part of ‘dput’, a Debian package upload toolkit.
#
# This is free software, and you are welcome to redistribute it under
# certain conditions; see the end of this file for copyright
# information, grant of license, and disclaimer of warranty.

""" Unit tests for ‘crypto’ module. """

import doctest
import functools
import operator
import sys
import textwrap
import unittest.mock

import gpg
import gpg.results
import testscenarios
import testtools

import dput.crypto

from .helper import (
        patch_system_interfaces,
        set_fake_file_scenario,
        setup_fake_file_fixtures,
        )


def make_gpg_signature_scenarios():
    """ Make a collection of scenarios for `gpg.result.Signature` instances.

        :return: A sequence of tuples (name, scenario) of scenarios
            for use with `testscenarios` test cases.

        Each scenario is a mapping of attributes to be applied to the
        test case.

        """

    scenarios = [
            ('signature-good validity-unknown', {
                'verify_result': unittest.mock.MagicMock(
                    gpg.results.VerifyResult,
                    file_name=None,
                    signatures=[
                        unittest.mock.MagicMock(
                            gpg.results.Signature,
                            fpr="BADBEEF2FACEDCADF00DBEEFDECAFBAD",
                            status=gpg.errors.NO_ERROR,
                            summary=functools.reduce(
                                operator.ior, [gpg.constants.SIGSUM_GREEN]),
                            validity=gpg.constants.VALIDITY_UNKNOWN,
                            ),
                        ],
                    ),
                'expected_character': "good",
                'expected_description': (
                    "Good signature from F00DBEEFDECAFBAD"),
                }),
            ('signature-good validity-never', {
                'verify_result': unittest.mock.MagicMock(
                    gpg.results.VerifyResult,
                    file_name=None,
                    signatures=[
                        unittest.mock.MagicMock(
                            gpg.results.Signature,
                            fpr="BADBEEF2FACEDCADF00DBEEFDECAFBAD",
                            status=gpg.errors.NO_ERROR,
                            summary=functools.reduce(
                                operator.ior, [gpg.constants.SIGSUM_GREEN]),
                            validity=gpg.constants.VALIDITY_NEVER,
                            ),
                        ],
                    ),
                'expected_character': "good",
                'expected_description': (
                    "Good signature from F00DBEEFDECAFBAD"),
                }),
            ('signature-good validity-full key-expired', {
                'verify_result': unittest.mock.MagicMock(
                    gpg.results.VerifyResult,
                    file_name=None,
                    signatures=[
                        unittest.mock.MagicMock(
                            gpg.results.Signature,
                            fpr="BADBEEF2FACEDCADF00DBEEFDECAFBAD",
                            status=gpg.errors.NO_ERROR,
                            summary=functools.reduce(operator.ior, [
                                gpg.constants.SIGSUM_GREEN,
                                gpg.constants.SIGSUM_KEY_EXPIRED,
                                ]),
                            validity=gpg.constants.VALIDITY_FULL,
                            ),
                        ],
                    ),
                'expected_character': "good",
                'expected_description': (
                    "Good signature from F00DBEEFDECAFBAD"),
                }),
            ('signature-good validity-full', {
                'verify_result': unittest.mock.MagicMock(
                    gpg.results.VerifyResult,
                    file_name=None,
                    signatures=[
                        unittest.mock.MagicMock(
                            gpg.results.Signature,
                            fpr="BADBEEF2FACEDCADF00DBEEFDECAFBAD",
                            status=gpg.errors.NO_ERROR,
                            summary=functools.reduce(operator.ior, [
                                gpg.constants.SIGSUM_VALID,
                                gpg.constants.SIGSUM_GREEN,
                                ]),
                            validity=gpg.constants.VALIDITY_FULL,
                            ),
                        ],
                    ),
                'expected_character': "valid",
                'expected_description': (
                    "Valid signature from F00DBEEFDECAFBAD"),
                }),
            ('signature-bad', {
                'verify_result': unittest.mock.MagicMock(
                    gpg.results.VerifyResult,
                    file_name=None,
                    signatures=[
                        unittest.mock.MagicMock(
                            gpg.results.Signature,
                            fpr="BADBEEF2FACEDCADF00DBEEFDECAFBAD",
                            status=gpg.errors.BAD_SIGNATURE,
                            summary=functools.reduce(
                                operator.ior, [gpg.constants.SIGSUM_RED]),
                            validity=gpg.constants.VALIDITY_FULL,
                            ),
                        ],
                    ),
                'expected_character': "bad",
                'expected_description': (
                    "Bad signature from F00DBEEFDECAFBAD"),
                }),
            ('signature-key-missing', {
                'verify_result': unittest.mock.MagicMock(
                    gpg.results.VerifyResult,
                    file_name=None,
                    signatures=[
                        unittest.mock.MagicMock(
                            gpg.results.Signature,
                            fpr="BADBEEF2FACEDCADF00DBEEFDECAFBAD",
                            status=gpg.errors.NO_PUBKEY,
                            summary=functools.reduce(
                                operator.ior,
                                [gpg.constants.SIGSUM_KEY_MISSING]),
                            validity=gpg.constants.VALIDITY_UNKNOWN,
                            ),
                        ],
                    ),
                'expected_character': dput.crypto.SignatureVerifyError,
                'expected_description': (
                    "Error checking signature from F00DBEEFDECAFBAD:"
                    " SignatureVerifyError: {:d}".format(
                        gpg.constants.SIGSUM_KEY_MISSING)
                    ),
                }),
            ]

    return scenarios


class characterise_signature_TestCase(
        testscenarios.WithScenarios,
        testtools.TestCase):
    """ Test cases for function `characterise_signature`. """

    scenarios = make_gpg_signature_scenarios()

    def test_gives_expected_character(self):
        """ Should give the expected character for signature. """
        test_args = {
            'signature': self.verify_result.signatures[0],
            }
        if (
                isinstance(self.expected_character, type)
                and issubclass(self.expected_character, Exception)
        ):
            self.assertRaises(
                self.expected_character,
                dput.crypto.characterise_signature,
                **test_args)
        else:
            result = dput.crypto.characterise_signature(**test_args)
            self.assertEqual(result, self.expected_character)


class describe_signature_TestCase(
        testscenarios.WithScenarios,
        testtools.TestCase):
    """ Test cases for function `describe_signature`. """

    scenarios = make_gpg_signature_scenarios()

    def test_gives_expected_description(self):
        """ Should return expected description for signature. """
        test_args = {
            'signature': self.verify_result.signatures[0],
            }
        result = dput.crypto.describe_signature(**test_args)
        self.assertEqual(result, self.expected_description)


def make_gpg_verify_scenarios():
    """ Make a collection of scenarios for ‘Context.verify’ method.

        :return: A collection of scenarios for tests.

        The collection is a mapping from scenario name to a dictionary of
        scenario attributes.

        """

    signatures_by_name = {
            name: scenario['verify_result']
            for (name, scenario) in make_gpg_signature_scenarios()}

    scenarios_by_name = {
            'goodsig': {
                'result': [
                    None,
                    signatures_by_name['signature-good validity-unknown'],
                    ],
                },
            'validsig': {
                'result': [
                    None,
                    signatures_by_name['signature-good validity-full'],
                    ],
                },
            'badsig': {
                'exception': gpg.errors.GPGMEError(
                    gpg._gpgme.gpgme_err_make(
                        gpg.errors.SOURCE_GPGME, gpg.errors.BAD_SIGNATURE),
                    "Bad signature"),
                },
            'errsig': {
                'exception': gpg.errors.GPGMEError(
                    gpg._gpgme.gpgme_err_make(
                        gpg.errors.SOURCE_GPGME, gpg.errors.SIG_EXPIRED),
                    "Signature expired"),
                },
            'nodata': {
                'exception': gpg.errors.GPGMEError(
                    gpg._gpgme.gpgme_err_make(
                        gpg.errors.SOURCE_GPGME, gpg.errors.NO_DATA),
                    "No data"),
                },
            'bogus': {
                'exception': ValueError,
                },
            }

    scenarios = {
            'default': scenarios_by_name['goodsig'],
            }
    scenarios.update(
            (name, scenario)
            for (name, scenario) in scenarios_by_name.items())

    return scenarios


def setup_gpg_verify_fixtures(testcase):
    """ Set up fixtures for GPG interaction behaviour. """
    scenarios = make_gpg_verify_scenarios()
    testcase.gpg_verify_scenarios = scenarios


class check_file_signature_TestCase(testtools.TestCase):
    """ Test cases for `check_file_signature` function. """

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()
        patch_system_interfaces(self)

        setup_fake_file_fixtures(self)
        set_fake_file_scenario(self, 'exist-minimal')

        self.set_test_args()

        self.patch_gpg_context()

        setup_gpg_verify_fixtures(self)
        self.set_gpg_verify_scenario('default')

    def set_test_args(self):
        """ Set the arguments for the test call to the function. """
        self.test_args = dict(
                infile=self.file_double.fake_file,
                )

    def patch_gpg_context(self):
        """ Patch the ‘gpg.Context’ class for this test case. """
        class_patcher = unittest.mock.patch.object(gpg, 'Context')
        class_patcher.start()
        self.addCleanup(class_patcher.stop)

    def set_gpg_verify_scenario(self, name):
        """ Set the status scenario for the ‘Context.verify’ call. """
        scenario = self.gpg_verify_scenarios[name]
        mock_class = gpg.Context
        self.mock_gpg_context = mock_class.return_value
        mock_func = self.mock_gpg_context.verify
        if 'exception' in scenario:
            mock_func.side_effect = scenario['exception']
        else:
            mock_func.return_value = scenario['result']

    def assert_stderr_contains_gpg_error(self, code):
        """ Assert the `stderr` content contains the GPG message. """
        expected_output = textwrap.dedent("""\
                gpg: {path}: error {code}: ...
                """).format(
                    path=self.file_double.path, code=code)
        self.assertThat(
                sys.stderr.getvalue(),
                testtools.matchers.DocTestMatches(
                    expected_output, doctest.ELLIPSIS))

    def test_calls_gpg_verify_with_expected_args(self):
        """ Should call `gpg.Context.verify` with expected args. """
        dput.crypto.check_file_signature(**self.test_args)
        gpg.Context.return_value.verify.assert_called_with(
            self.file_double.fake_file)

    def test_calls_sys_exit_if_gnupg_reports_bad_signature(self):
        """ Should call `sys.exit` if GnuPG reports bad signature. """
        self.set_gpg_verify_scenario('badsig')
        with testtools.ExpectedException(gpg.errors.GPGMEError):
            dput.crypto.check_file_signature(**self.test_args)
        self.assert_stderr_contains_gpg_error(gpg.errors.BAD_SIGNATURE)

    def test_calls_sys_exit_if_gnupg_reports_sig_expired(self):
        """ Should call `sys.exit` if GnuPG reports signature expired. """
        self.set_gpg_verify_scenario('errsig')
        with testtools.ExpectedException(gpg.errors.GPGMEError):
            dput.crypto.check_file_signature(**self.test_args)
        self.assert_stderr_contains_gpg_error(gpg.errors.SIG_EXPIRED)

    def test_calls_sys_exit_if_gnupg_reports_nodata(self):
        """ Should call `sys.exit` if GnuPG reports no data. """
        self.set_gpg_verify_scenario('nodata')
        with testtools.ExpectedException(gpg.errors.GPGMEError):
            dput.crypto.check_file_signature(**self.test_args)
        self.assert_stderr_contains_gpg_error(gpg.errors.NO_DATA)

    def test_outputs_message_if_gnupg_reports_goodsig(self):
        """ Should output a message if GnuPG reports a good signature. """
        self.set_gpg_verify_scenario('goodsig')
        dput.crypto.check_file_signature(**self.test_args)
        expected_output = textwrap.dedent("""\
                gpg: {path}: Good signature from ...
                """).format(path=self.file_double.path)
        self.assertThat(
                sys.stderr.getvalue(),
                testtools.matchers.DocTestMatches(
                    expected_output, doctest.ELLIPSIS))

    def test_outputs_message_if_gnupg_reports_validsig(self):
        """ Should output a message if GnuPG reports a valid signature. """
        self.set_gpg_verify_scenario('validsig')
        dput.crypto.check_file_signature(**self.test_args)
        expected_output = textwrap.dedent("""\
                gpg: {path}: Valid signature from ...
                """).format(path=self.file_double.path)
        self.assertThat(
                sys.stderr.getvalue(),
                testtools.matchers.DocTestMatches(
                    expected_output, doctest.ELLIPSIS))


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
