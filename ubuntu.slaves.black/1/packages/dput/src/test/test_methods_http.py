# test/test_methods.py
# Part of ‘dput’, a Debian package upload toolkit.
#
# This is free software, and you are welcome to redistribute it under
# certain conditions; see the end of this file for copyright
# information, grant of license, and disclaimer of warranty.

""" Unit tests for HTTP upload method plug-in. """

import copy
import getpass
import http.client
import unittest.mock
import urllib.request

import testscenarios
import testtools

import dput.methods.http


def make_test_passwordmgr(
        test_class=dput.methods.http.PromptingPasswordMgr,
        test_kwargs=None,
):
    """
    Make a password manager of specified `test_class` with `test_kwargs`.
    """
    if test_kwargs is None:
        test_kwargs = {
                'username': "FAKE",
                }
    instance = test_class(**test_kwargs)
    return instance


def setup_passwordmgr(
        testcase,
        passwordmgr_class=None,
        passwordmgr_kwargs=None,
):
    """ Set up a password manager fixture for the `testcase`. """
    if passwordmgr_kwargs is None:
        passwordmgr_kwargs = {
                'username': testcase.getUniqueString()[:40],
                }
    maker_kwargs = {
            'test_kwargs': passwordmgr_kwargs,
            }
    if passwordmgr_class is not None:
        maker_kwargs['test_class'] = passwordmgr_class
    testcase.test_passwordmgr = make_test_passwordmgr(**maker_kwargs)


class PromptingPasswordMgr_TestCase(testtools.TestCase):
    """ Test cases for class `PromptingPasswordMgr`. """

    passwordmgr_class = dput.methods.http.PromptingPasswordMgr

    def setUp(self):
        """ Set up fixtures for this test case. """
        super().setUp()

        self.test_username = self.getUniqueString()[:40]
        self.test_args = {
                'username': self.test_username,
                }
        setup_passwordmgr(
                self,
                passwordmgr_class=self.passwordmgr_class,
                passwordmgr_kwargs=self.test_args)

    def test_instantiate(self):
        """ Should create a new instance of `PromptingPasswordMgr`. """
        self.assertIsInstance(
                self.test_passwordmgr, self.passwordmgr_class)

    def test_is_password_manager(self):
        """ Should create a new instance of `HTTPPasswordMgr`. """
        self.assertIsInstance(
                self.test_passwordmgr, urllib.request.HTTPPasswordMgr)

    def test_has_specified_username(self):
        """ Should have the specified `username` value. """
        self.assertEqual(self.test_passwordmgr.username, self.test_username)


class PromptingPasswordMgr_find_user_password_TestCase(
        testscenarios.WithScenarios,
        testtools.TestCase):
    """ Test cases for method `PromptingPasswordMgr.find_user_password`. """

    table_scenarios = [
            ('normal', {
                'passwd_entries': {
                    "pellentesque": {
                        (
                            ("lorem.example.org:443", "/"),
                            ("ipsum.example.org:443", "/"),
                            ): ("consectetur", "adipiscing"),
                        (
                            ("dolor.example.org:443", "/"),
                            ("sit.example.org:443", "/"),
                            ("amet.example.org:443", "/"),
                            ): ("vehicula", "faucibus"),
                        },
                    "suscipit": {
                        (
                            ("dictum.example.org:443", "/"),
                            ): ("dui", "porta"),
                        },
                    },
                'test_username': "consectetur",
                'test_realm': "pellentesque",
                }),
            ]

    authuri_scenarios = [
            ('authuri-match', {
                'test_authuri': "https://ipsum.example.org/proin",
                'test_realm_uris': (
                    ("lorem.example.org:443", "/"),
                    ("ipsum.example.org:443", "/"),
                    ),
                'expected_username': "consectetur",
                'expected_password': "adipiscing",
                }),
            ]

    getpass_scenarios = [
            ('getpass-normal', {
                'input_password': "efficitur",
                }),
            ]

    scenarios = testscenarios.multiply_scenarios(
            table_scenarios, authuri_scenarios, getpass_scenarios)

    def setUp(self):
        """ Set up fixtures for this test case. """
        super().setUp()

        passwordmgr_kwargs = {
                'username': self.test_username,
                }
        setup_passwordmgr(
                self, passwordmgr_kwargs=passwordmgr_kwargs)

        self.test_passwordmgr.passwd = copy.deepcopy(self.passwd_entries)

        self.test_kwargs = {
                'realm': self.test_realm,
                'authuri': self.test_authuri,
                }

        self.patch_getpass_getpass(test_result=self.input_password)

    def patch_getpass_getpass(self, test_result=None):
        """ Patch the `getpass.getpass` function for this test case. """
        func_patcher = unittest.mock.patch.object(getpass, 'getpass')
        self.mock_getpass = func_patcher.start()
        if test_result is not None:
            self.mock_getpass.return_value = test_result
        self.addCleanup(func_patcher.stop)

    def test_returns_expected_username(self):
        """ Should return expected username value. """
        (username, __) = self.test_passwordmgr.find_user_password(
                **self.test_kwargs)
        self.assertEqual(username, self.expected_username)

    def test_returns_stored_password_when_authuri_match(self):
        """ Should return stored password when `authuri` matches. """
        (__, password) = self.test_passwordmgr.find_user_password(
                **self.test_kwargs)
        (__, expected_password) = self.passwd_entries[
                self.test_realm][self.test_realm_uris]
        self.assertEqual(password, expected_password)

    def test_returns_input_password_when_authuri_not_found(self):
        """ Should return input password when `authuri` not found. """
        del self.test_passwordmgr.passwd[
                self.test_realm][self.test_realm_uris]
        (__, password) = self.test_passwordmgr.find_user_password(
                **self.test_kwargs)
        expected_password = self.input_password
        self.assertEqual(password, expected_password)


def make_test_authrequest(
        test_class=dput.methods.http.AuthHandlerHackAround,
        test_kwargs=None,
):
    """
    Make an authentication request of type `test_class` with `test_kwargs`.
    """
    if test_kwargs is None:
        test_kwargs = {
                'url': "FAKE",
                'resp_headers': object(),
                'pwman': make_test_passwordmgr(),
                }
    instance = test_class(**test_kwargs)
    return instance


def setup_authrequest(
        testcase,
        authrequest_class=None,
        authrequest_kwargs=None,
):
    """ Set up an authnetication handler fixture for the `testcase`. """
    maker_kwargs = {}
    if authrequest_class is not None:
        maker_kwargs['test_class'] = authrequest_class
    if authrequest_kwargs is not None:
        maker_kwargs['test_kwargs'] = authrequest_kwargs
    testcase.test_authrequest = make_test_authrequest(**maker_kwargs)


class AuthHandlerHackAround_TestCase(testtools.TestCase):
    """ Test cases for class `AuthHandlerHackAround`. """

    authrequest_class = dput.methods.http.AuthHandlerHackAround

    def setUp(self):
        """ Set up fixtures for this test case. """
        super().setUp()

        setup_passwordmgr(self)

        self.test_url = self.getUniqueString()
        self.test_response_headers = {
                self.getUniqueString(): self.getUniqueString(),
                self.getUniqueString(): self.getUniqueString(),
                }
        self.test_args = {
                'url': self.test_url,
                'resp_headers': self.test_response_headers,
                'pwman': self.test_passwordmgr,
                }
        setup_authrequest(
                self,
                authrequest_class=self.authrequest_class,
                authrequest_kwargs=self.test_args)

    def test_instantiate(self):
        """ Should create a new instance of `AuthHandlerHackAround`. """
        self.assertIsInstance(
                self.test_authrequest, self.authrequest_class)

    def test_has_specified_url(self):
        """ Should have the specified `url` value. """
        self.assertEqual(self.test_authrequest.url, self.test_url)

    def test_has_specified_response_headers(self):
        """ Should have the specified `resp_headers` value. """
        self.assertEqual(
                self.test_authrequest.resp_headers, self.test_response_headers)

    def test_has_expected_auth_handler_types(self):
        """ Should have expected authentication handler types. """
        expected_types = {
                urllib.request.HTTPBasicAuthHandler,
                urllib.request.HTTPDigestAuthHandler,
                }
        authhandler_types = set(
                handler.__class__
                for handler in self.test_authrequest.authhandlers)
        self.assertEqual(authhandler_types, expected_types)

    def test_has_expected_auth_handler_parents(self):
        """ Should have expected authentication handler parents. """
        expected_parent = self.test_authrequest
        for handler in self.test_authrequest.authhandlers:
            self.assertIs(handler.parent, expected_parent)


class AuthHandlerHackAround_add_header_TestCase(testtools.TestCase):
    """ Test cases for method `AuthHandlerHackAround.add_header`. """

    def test_sets_specified_field_in_headers(self):
        """ Should set specified field in the `headers` mapping. """
        setup_authrequest(self)
        test_field_name = self.getUniqueString()
        test_field_value = self.getUniqueString()
        self.test_args = (test_field_name, test_field_value)
        self.test_authrequest.add_header(*self.test_args)
        self.assertEqual(
                self.test_authrequest.headers[test_field_name],
                test_field_value)


class AuthHandlerHackAround_add_unredirected_header_TestCase(
        testtools.TestCase):
    """
    Test cases for method `AuthHandlerHackAround.add_unredirected_header`.
    """

    def test_sets_specified_field_in_headers(self):
        """ Should set specified field in the `headers` mapping. """
        setup_authrequest(self)
        test_field_name = self.getUniqueString()
        test_field_value = self.getUniqueString()
        self.test_args = (test_field_name, test_field_value)
        self.test_authrequest.add_unredirected_header(*self.test_args)
        self.assertEqual(
                self.test_authrequest.headers[test_field_name],
                test_field_value)


class AuthHandlerHackAround_get_full_url_TestCase(testtools.TestCase):
    """ Test cases for method `AuthHandlerHackAround.get_full_url`. """

    def test_returns_specified_url(self):
        """ Should return the specified `url` value from initialisation. """
        setup_authrequest(self)
        expected_url = self.test_authrequest.url
        result = self.test_authrequest.get_full_url()
        self.assertEqual(result, expected_url)


class AuthHandlerHackAround_open_TestCase(testtools.TestCase):
    """ Test cases for method `AuthHandlerHackAround.open`. """

    def test_accepts_open_args(self):
        """ Should accept the expected `open` arguments. """
        setup_authrequest(self)
        test_kwargs = {
                'fullurl': self.getUniqueString(),
                'data': self.getUniqueString(),
                'timeout': self.getUniqueInteger(),
                }
        self.test_authrequest.open(**test_kwargs)


class AuthHandlerHackAround_get_auth_headers_TestCase(
        testscenarios.WithScenarios,
        testtools.TestCase):
    """ Test cases for method `AuthHandlerHackAround.get_auth_headers`. """

    basicauth_scenarios = [
            ('basicauth-okay', {
                'basicauth_error_effect': None,
                }),
            ('basicauth-error', {
                'basicauth_error_effect': ValueError("lorem ipsum"),
                }),
            ]

    digestauth_scenarios = [
            ('digestauth-okay', {
                'digestauth_error_effect': None,
                }),
            ('digestauth-error', {
                'digestauth_error_effect': ValueError("lorem ipsum"),
                }),
            ]

    header_effect_scenarios = [
            ('no-header-change', {
                'new_header_field': None,
                }),
            ('header-add-field', {
                'new_header_field': ("dolor", "sit amet"),
                }),
            ]

    scenarios = testscenarios.multiply_scenarios(
            basicauth_scenarios, digestauth_scenarios, header_effect_scenarios)

    def setUp(self):
        """ Set up fixtures for this test case. """
        super().setUp()

        setup_authrequest(self)

        self.mock_handler_error_methods = {
                handler_class: self.patch_authhander_error(
                    handler_class=handler_class,
                    error_effect=getattr(self, error_effect_name))
                for (handler_class, error_effect_name) in [
                    (
                        urllib.request.HTTPBasicAuthHandler,
                        'basicauth_error_effect'),
                    (
                        urllib.request.HTTPDigestAuthHandler,
                        'digestauth_error_effect'),
                ]}

    def patch_authhander_error(self, handler_class, error_effect):
        """ Patch the `http_error_401` method of the `handler_class`. """
        def side_effect(*args, **kwargs):
            if self.new_header_field is not None:
                (field_name, field_value) = self.new_header_field
                self.test_authrequest.headers[field_name] = field_value
            if error_effect is not None:
                raise error_effect

        func_patcher = unittest.mock.patch.object(
                handler_class, 'http_error_401',
                side_effect=side_effect,
        )
        mock_method = func_patcher.start()
        self.addCleanup(func_patcher.stop)

        return mock_method

    def test_calls_basicauthhandler_error_with_expected_args(self):
        """
        Should call `HTTPBasicAuthHandler.http_error_401` with expected args.
        """
        self.test_authrequest.get_auth_headers()
        mock_method = self.mock_handler_error_methods[
                urllib.request.HTTPBasicAuthHandler]
        expected_request = self.test_authrequest
        expected_status_code = http.client.UNAUTHORIZED
        expected_response_headers = self.test_authrequest.resp_headers
        mock_method.assert_called_with(
                expected_request,
                unittest.mock.ANY,
                expected_status_code,
                unittest.mock.ANY,
                expected_response_headers,
                )

    def test_calls_basicauthhandler_error_with_expected_args(self):
        """
        Should call `HTTPDigestAuthHandler.http_error_401` with expected args.
        """
        self.test_authrequest.get_auth_headers()
        mock_method = self.mock_handler_error_methods[
                urllib.request.HTTPDigestAuthHandler]
        expected_request = self.test_authrequest
        expected_status_code = http.client.UNAUTHORIZED
        expected_response_headers = self.test_authrequest.resp_headers
        mock_method.assert_called_with(
                expected_request,
                unittest.mock.ANY,
                expected_status_code,
                unittest.mock.ANY,
                expected_response_headers,
                )

    def test_returns_accumulated_header_fields(self):
        """ Should return accumulated header fields. """
        result = self.test_authrequest.get_auth_headers()
        expected_header_fields = self.test_authrequest.headers
        self.assertEqual(result, expected_header_fields)


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
