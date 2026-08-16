# test/test_changesfile.py
# Part of ‘dput’, a Debian package upload toolkit.
#
# This is free software, and you are welcome to redistribute it under
# certain conditions; see the end of this file for copyright
# information, grant of license, and disclaimer of warranty.

""" Unit tests for Debian upload control (‘*.changes’) files. """

import collections
import doctest
import email.message
import io
import os
import os.path
import sys
import tempfile
import textwrap
import unittest.mock

import testscenarios
import testtools

import dput.dput
from dput.helper import dputhelper

from .helper import (
        EXIT_STATUS_FAILURE,
        FakeSystemExit,
        FileDouble,
        get_file_doubles_from_fake_file_scenarios,
        make_fake_file_scenarios,
        make_unique_slug,
        patch_os_stat,
        patch_system_interfaces,
        setup_file_double_behaviour,
        )
from .test_configfile import (
        patch_runtime_config_options,
        set_config,
        )


class _FieldsMapping:
    """ A mapping to stand in for the `dict` of an `email.message.Message`. """

    def __init__(self, *args, **kwargs):
        try:
            self._message = kwargs.pop('_message')
        except KeyError:
            raise TypeError("no ‘_message’ specified for this mapping")
        super().__init__(*args, **kwargs)

    def __len__(self, *args, **kwargs):
        return self._message.__len__(*args, **kwargs)

    def __contains__(self, *args, **kwargs):
        return self._message.__contains__(*args, **kwargs)

    def __getitem__(self, *args, **kwargs):
        return self._message.__getitem__(*args, **kwargs)

    def __setitem__(self, *args, **kwargs):
        self._message.__setitem__(*args, **kwargs)

    def __delitem__(self, *args, **kwargs):
        self._message.__delitem__(*args, **kwargs)

    def keys(self, *args, **kwargs):
        return self._message.keys(*args, **kwargs)

    def values(self, *args, **kwargs):
        return self._message.values(*args, **kwargs)

    def items(self, *args, **kwargs):
        return self._message.items(*args, **kwargs)

    def get(self, *args, **kwargs):
        return self._message.get(*args, **kwargs)


class FakeMessage(email.message.Message, object):
    """ A fake RFC 2822 message that mocks the obsolete `rfc822.Message`. """

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self.dict = _FieldsMapping(_message=self)


def make_fake_message(fields):
    """ Make a fake message instance. """
    message = FakeMessage()
    for (name, value) in fields.items():
        message.add_header(name, value)
    return message


def make_files_field_value(params_by_name):
    """ Make a value for “Files” field of a changes document. """
    result = "\n".join(
            " ".join(params)
            for (file_name, params) in params_by_name.items())
    return result


def make_upload_files_params(checksums_by_file_name, sizes_by_file_name):
    """ Make a mapping of upload parameters for files. """
    params_by_name = {
            file_name: [
                checksums_by_file_name[file_name],
                str(sizes_by_file_name[file_name]),
                "foo", "bar", file_name]
            for file_name in checksums_by_file_name}
    return params_by_name


def make_changes_document(fields, upload_params_by_name=None):
    """ Make a changes document from field values.

        :param fields: Sequence of (name, value) tuples for fields.
        :param upload_params_by_name: Mapping from filename to upload
            parameters for each file.
        :return: The changes document as an RFC 822 formatted text.

        """
    document_fields = fields.copy()
    if upload_params_by_name is not None:
        files_field_text = make_files_field_value(upload_params_by_name)
        document_fields.update({'files': files_field_text})
    document = make_fake_message(document_fields)

    return document


def make_changes_file_scenarios():
    """ Make fake Debian upload control (‘*.changes’) scenarios. """
    file_path = make_changes_file_path()

    fake_file_empty = io.StringIO()
    fake_file_no_format = io.StringIO(textwrap.dedent("""\
            FOO
            BAR
            Files:
                Lorem ipsum dolor sit amet
            """))
    fake_file_with_signature = io.StringIO(textwrap.dedent("""\
            -----BEGIN PGP SIGNED MESSAGE-----
            Hash: SHA1

            FOO
            BAR
            Files:
                Lorem ipsum dolor sit amet

            -----BEGIN PGP SIGNATURE-----
            Version: 0.0
            Comment: Proin ac massa at orci sagittis fermentum.

            gibberishgibberishgibberishgibberishgibberishgibberish
            gibberishgibberishgibberishgibberishgibberishgibberish
            gibberishgibberishgibberishgibberishgibberishgibberish
            -----END PGP SIGNATURE-----
            """))
    fake_file_with_format = io.StringIO(textwrap.dedent("""\
            Format: FOO
            Files:
                Lorem ipsum dolor sit amet
            """))
    fake_file_invalid = io.StringIO(textwrap.dedent("""\
            Format: FOO
            Files:
                FOO BAR
            """))

    scenarios = [
            ('no-format', {
                'file_double': FileDouble(
                    path=file_path,
                    fake_file=fake_file_no_format),
                'expected_result': make_changes_document({
                    'files': "Lorem ipsum dolor sit amet",
                    }),
                }),
            ('with-pgp-signature', {
                'file_double': FileDouble(
                    path=file_path,
                    fake_file=fake_file_with_signature),
                'expected_result': make_changes_document({
                    'files': "Lorem ipsum dolor sit amet",
                    }),
                }),
            ('with-format', {
                'file_double': FileDouble(
                    path=file_path,
                    fake_file=fake_file_with_format),
                'expected_result': make_changes_document({
                    'files': "Lorem ipsum dolor sit amet",
                    }),
                }),
            ('error empty', {
                'file_double': FileDouble(
                    path=file_path, fake_file=fake_file_empty),
                'expected_error': KeyError,
                }),
            ('error invalid', {
                'file_double': FileDouble(
                    path=file_path,
                    fake_file=fake_file_invalid),
                'expected_error': FakeSystemExit,
                }),
            ]

    for (scenario_name, scenario) in scenarios:
        scenario['changes_file_scenario_name'] = scenario_name

    return scenarios


def set_fake_upload_file_paths(testcase):
    """ Set the fake upload file paths. """
    testcase.fake_upload_file_paths = [
            os.path.join(
                os.path.dirname(testcase.changes_file_double.path),
                os.path.basename(tempfile.mktemp()))
            for __ in range(10)]

    required_suffixes = [".dsc", ".tar.xz"]
    suffixes = required_suffixes + getattr(
            testcase, 'additional_file_suffixes', [])
    file_path_base = testcase.fake_upload_file_paths.pop()
    for suffix in suffixes:
        file_path = file_path_base + suffix
        testcase.fake_upload_file_paths.insert(0, file_path)


def set_file_checksums(testcase):
    """ Set the fake file checksums for the test case. """
    testcase.fake_checksum_by_file = {
            os.path.basename(file_path): make_unique_slug(testcase)
            for file_path in testcase.fake_upload_file_paths}


def set_file_sizes(testcase):
    """ Set the fake file sizes for the test case. """
    testcase.fake_size_by_file = {
            os.path.basename(file_path): testcase.getUniqueInteger()
            for file_path in testcase.fake_upload_file_paths}


def set_file_doubles(testcase):
    """ Set the file doubles for the test case. """
    for file_path in testcase.fake_upload_file_paths:
        file_double = FileDouble(file_path)
        file_double.set_os_stat_scenario('okay')
        file_double.stat_result = file_double.stat_result._replace(
                st_size=testcase.fake_size_by_file[
                    os.path.basename(file_path)],
                )
        file_double.register_for_testcase(testcase)


def setup_upload_file_fixtures(testcase):
    """ Set fixtures for fake files to upload for the test case. """
    set_fake_upload_file_paths(testcase)
    set_file_checksums(testcase)
    set_file_sizes(testcase)
    set_file_doubles(testcase)


def make_changes_file_path(file_dir_path=None):
    """ Make a filesystem path for the changes file. """
    if file_dir_path is None:
        file_dir_path = tempfile.mktemp()
    file_name = os.path.basename(
            "{base}.changes".format(base=tempfile.mktemp()))
    file_path = os.path.join(file_dir_path, file_name)

    return file_path


def setup_changes_file_fixtures(testcase):
    """ Set up fixtures for changes file doubles. """
    file_path = make_changes_file_path()

    scenarios = make_fake_file_scenarios(file_path)
    testcase.changes_file_scenarios = scenarios

    file_doubles = get_file_doubles_from_fake_file_scenarios(
            scenarios.values())
    setup_file_double_behaviour(testcase, file_doubles)


def set_changes_file_scenario(testcase, name):
    """ Set the changes file scenario for this test case. """
    scenario = dict(testcase.changes_file_scenarios)[name]
    testcase.changes_file_scenario = scenario
    testcase.changes_file_double = scenario['file_double']
    testcase.changes_file_double.register_for_testcase(testcase)


class parse_changes_TestCase(
        testscenarios.WithScenarios,
        testtools.TestCase):
    """ Base for test cases for `parse_changes` function. """

    scenarios = NotImplemented

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()
        patch_system_interfaces(self)

        self.test_infile = io.StringIO()


class parse_changes_SuccessTestCase(parse_changes_TestCase):
    """ Success test cases for `parse_changes` function. """

    scenarios = list(
            (name, scenario)
            for (name, scenario) in make_changes_file_scenarios()
            if not name.startswith('error'))

    def test_gives_expected_result_for_infile(self):
        """ Should give the expected result for specified input file. """
        result = dput.dput.parse_changes(self.file_double.fake_file)
        normalised_result_set = set(
                (key.lower(), value.strip())
                for (key, value) in result.items())
        self.assertEqual(
                set(self.expected_result.items()), normalised_result_set)


class parse_changes_ErrorTestCase(parse_changes_TestCase):
    """ Error test cases for `parse_changes` function. """

    scenarios = list(
            (name, scenario)
            for (name, scenario) in make_changes_file_scenarios()
            if name.startswith('error'))

    def test_raises_expected_exception_for_infile(self):
        """ Should raise the expected exception for specified input file. """
        with testtools.ExpectedException(self.expected_error):
            dput.dput.parse_changes(self.file_double.fake_file)


class check_upload_variant_TestCase(
        testscenarios.WithScenarios,
        testtools.TestCase):
    """ Test cases for `check_upload_variant` function. """

    scenarios = [
            ('simple', {
                'fields': {
                    'architecture': "foo bar baz",
                    },
                'expected_result': True,
                }),
            ('arch-missing', {
                'fields': {
                    'spam': "Lorem ipsum dolor sit amet",
                    },
                'expected_result': False,
                }),
            ('source-only', {
                'fields': {
                    'architecture': "source",
                    },
                'expected_result': False,
                }),
            ('source-and-others', {
                'fields': {
                    'architecture': "foo source bar",
                    },
                'expected_result': False,
                }),
            ]

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()
        patch_system_interfaces(self)

        self.set_changes_document(self.fields)
        self.set_test_args()

    def set_changes_document(self, fields):
        """ Set the package changes document based on specified fields. """
        self.test_changes_document = make_changes_document(fields)

    def set_test_args(self):
        """ Set the arguments for the test call to the function. """
        self.test_args = {
                'changes': self.test_changes_document,
                'debug': False,
                }

    def test_returns_expected_result_for_changes_document(self):
        """ Should return expected result for specified changes document. """
        result = dput.dput.check_upload_variant(**self.test_args)
        self.assertEqual(self.expected_result, result)

    def test_emits_debug_message_showing_architecture(self):
        """ Should emit a debug message for the specified architecture. """
        if 'architecture' not in self.fields:
            self.skipTest("Architecture field not in this scenario")
        self.test_args['debug'] = True
        dput.dput.check_upload_variant(**self.test_args)
        expected_output = textwrap.dedent("""\
                D: Architecture: {arch}
                """).format(arch=self.fields['architecture'])
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_emits_debug_message_for_binary_upload(self):
        """ Should emit a debug message for the specified architecture. """
        triggers_binaryonly = bool(self.expected_result)
        if not triggers_binaryonly:
            self.skipTest("Scenario does not trigger binary-only upload")
        self.test_args['debug'] = True
        dput.dput.check_upload_variant(**self.test_args)
        expected_output = textwrap.dedent("""\
                D: Doing a binary upload only.
                """)
        self.assertIn(expected_output, sys.stdout.getvalue())


SourceCheckResult = collections.namedtuple(
        'SourceCheckResult', ['include_orig', 'include_tar'])


class source_check_TestCase(
        testscenarios.WithScenarios,
        testtools.TestCase):
    """ Test cases for `source_check` function. """

    default_expected_result = SourceCheckResult(
            include_orig=False, include_tar=False)

    scenarios = [
            ('no-version', {
                'expected_result': default_expected_result,
                }),
            ('no-epoch native-version', {
                'upstream_version': "1.2",
                'expected_result': SourceCheckResult(
                    include_orig=False, include_tar=True),
                }),
            ('epoch native-version', {
                'epoch': "3",
                'upstream_version': "1.2",
                'expected_result': SourceCheckResult(
                    include_orig=False, include_tar=True),
                }),
            ('no-epoch debian-release', {
                'upstream_version': "1.2",
                'release': "5",
                'expected_result': SourceCheckResult(
                    include_orig=False, include_tar=True),
                }),
            ('epoch debian-release', {
                'epoch': "3",
                'upstream_version': "1.2",
                'release': "5",
                'expected_result': SourceCheckResult(
                    include_orig=False, include_tar=True),
                }),
            ('no-epoch new-upstream-version', {
                'upstream_version': "1.2",
                'release': "1",
                'expected_result': SourceCheckResult(
                    include_orig=True, include_tar=False),
                }),
            ('epoch new_upstream-version', {
                'epoch': "3",
                'upstream_version': "1.2",
                'release': "1",
                'expected_result': SourceCheckResult(
                    include_orig=True, include_tar=False),
                }),
            ('no-epoch nmu', {
                'upstream_version': "1.2",
                'release': "4.5",
                'expected_result': SourceCheckResult(
                    include_orig=False, include_tar=True),
                }),
            ('epoch nmu', {
                'epoch': "3",
                'upstream_version': "1.2",
                'release': "4.5",
                'expected_result': SourceCheckResult(
                    include_orig=False, include_tar=True),
                }),
            ('no-epoch nmu before-first-release', {
                'upstream_version': "1.2",
                'release': "0.1",
                'expected_result': SourceCheckResult(
                    include_orig=True, include_tar=False),
                }),
            ('epoch nmu before-first-release', {
                'epoch': "3",
                'upstream_version': "1.2",
                'release': "0.1",
                'expected_result': SourceCheckResult(
                    include_orig=True, include_tar=False),
                }),
            ('no-epoch nmu after-first-release', {
                'upstream_version': "1.2",
                'release': "1.1",
                'expected_result': SourceCheckResult(
                    include_orig=True, include_tar=False),
                }),
            ('epoch nmu after-first-release', {
                'epoch': "3",
                'upstream_version': "1.2",
                'release': "1.1",
                'expected_result': SourceCheckResult(
                    include_orig=True, include_tar=False),
                }),
            ]

    for (scenario_name, scenario) in scenarios:
        fields = {}
        if 'upstream_version' in scenario:
            version_string = scenario['upstream_version']
            if 'epoch' in scenario:
                version_string = "{epoch}:{version}".format(
                        epoch=scenario['epoch'], version=version_string)
            if 'release' in scenario:
                version_string = "{version}-{release}".format(
                        version=version_string, release=scenario['release'])
            fields.update({'version': version_string})
            scenario['version'] = version_string
        scenario['changes_document'] = make_changes_document(fields)
    del scenario_name, scenario
    del fields, version_string

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()
        patch_system_interfaces(self)

        self.test_args = {
                'changes': self.changes_document,
                'debug': False,
                }

    def test_returns_expected_result_for_changes_document(self):
        """ Should return expected result for specified changes document. """
        result = dput.dput.source_check(**self.test_args)
        self.assertEqual(self.expected_result, result)

    def test_emits_version_string_debug_message_only_if_version(self):
        """ Should emit message for version only if has version. """
        self.test_args['debug'] = True
        version = getattr(self, 'version', None)
        message_lead = "D: Package Version:"
        expected_output = textwrap.dedent("""\
                {lead} {version}
                """).format(
                    lead=message_lead, version=version)
        dput.dput.source_check(**self.test_args)
        if hasattr(self, 'version'):
            self.assertIn(expected_output, sys.stdout.getvalue())
        else:
            self.assertNotIn(message_lead, sys.stdout.getvalue())

    def test_emits_epoch_debug_message_only_if_epoch(self):
        """ Should emit message for epoch only if has an epoch. """
        self.test_args['debug'] = True
        dput.dput.source_check(**self.test_args)
        expected_output = textwrap.dedent("""\
                D: Epoch found
                """)
        dput.dput.source_check(**self.test_args)
        if (hasattr(self, 'epoch') and hasattr(self, 'release')):
            self.assertIn(expected_output, sys.stdout.getvalue())
        else:
            self.assertNotIn(expected_output, sys.stdout.getvalue())

    def test_emits_upstream_version_debug_message_only_if_nonnative(self):
        """ Should emit message for upstream version only if non-native. """
        self.test_args['debug'] = True
        upstream_version = getattr(self, 'upstream_version', None)
        message_lead = "D: Upstream Version:"
        expected_output = textwrap.dedent("""\
                {lead} {version}
                """).format(
                    lead=message_lead, version=upstream_version)
        dput.dput.source_check(**self.test_args)
        if hasattr(self, 'release'):
            self.assertIn(expected_output, sys.stdout.getvalue())
        else:
            self.assertNotIn(message_lead, sys.stdout.getvalue())

    def test_emits_debian_release_debug_message_only_if_nonnative(self):
        """ Should emit message for Debian release only if non-native. """
        self.test_args['debug'] = True
        debian_release = getattr(self, 'release', None)
        message_lead = "D: Debian Version:"
        expected_output = textwrap.dedent("""\
                {lead} {version}
                """).format(
                    lead=message_lead, version=debian_release)
        dput.dput.source_check(**self.test_args)
        if hasattr(self, 'release'):
            self.assertIn(expected_output, sys.stdout.getvalue())
        else:
            self.assertNotIn(message_lead, sys.stdout.getvalue())


class verify_files_TestCase(
        testscenarios.WithScenarios,
        testtools.TestCase):
    """ Test cases for `verify_files` function. """

    default_args = dict(
            host="foo",
            check_only=None,
            check_version=None,
            allow_unsigned_uploads=None,
            debug=None,
            )

    scenarios = [
            ('default', {}),
            ('binary-only', {
                'check_upload_variant_return_value': False,
                }),
            ('include foo.tar.gz', {
                'additional_file_suffixes': [".tar.gz"],
                'source_check_result': SourceCheckResult(
                    include_orig=False, include_tar=True),
                }),
            ('include foo.orig.tar.gz', {
                'additional_file_suffixes': [".orig.tar.gz"],
                'source_check_result': SourceCheckResult(
                    include_orig=True, include_tar=False),
                }),
            ('unexpected foo.tar.gz', {
                'additional_file_suffixes': [".tar.gz"],
                'expected_rejection_message': (
                    "Package includes a .tar.gz file although"),
                }),
            ('unexpected foo.orig.tar.gz', {
                'additional_file_suffixes': [".orig.tar.gz"],
                'expected_rejection_message': (
                    "Package includes an .orig.tar.gz file although"),
                }),
            ('no distribution', {
                'test_distribution': None,
                }),
            ]

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()
        patch_system_interfaces(self)

        self.file_double_by_path = {}
        set_config(self, 'exist-simple')
        patch_runtime_config_options(self)

        self.set_test_args()

        setup_changes_file_fixtures(self)
        set_changes_file_scenario(self, 'exist-minimal')
        self.test_args.update(dict(
                changes_file_directory=os.path.dirname(
                    self.changes_file_double.path),
                changes_file_name=os.path.basename(
                    self.changes_file_double.path),
                ))

        patch_os_stat(self)

        setup_upload_file_fixtures(self)
        self.set_expected_files_to_upload()

        self.patch_checksum_test()
        self.patch_parse_changes()
        self.patch_check_upload_variant()
        self.set_expected_binary_upload()
        self.set_expected_source_control_file_path()
        self.patch_version_check()
        self.patch_verify_signature()
        self.patch_source_check()

    def set_expected_files_to_upload(self):
        """ Set the expected `files_to_upload` result for this test case. """
        self.expected_files_to_upload = set(
                path for path in self.fake_upload_file_paths)
        self.expected_files_to_upload.add(self.changes_file_double.path)

    def patch_checksum_test(self):
        """ Patch `checksum_test` function for this test case. """
        func_patcher = unittest.mock.patch.object(
                dput.dput, "checksum_test", autospec=True)
        mock_func = func_patcher.start()
        self.addCleanup(func_patcher.stop)

        def get_checksum_for_file(path, hash_name):
            return self.fake_checksum_by_file[os.path.basename(path)]
        mock_func.side_effect = get_checksum_for_file

    def set_changes_document(self):
        """ Set the changes document for this test case. """
        self.changes_document = make_changes_document(
                fields={},
                upload_params_by_name=self.upload_params_by_name)
        self.test_distribution = getattr(self, 'test_distribution', "lorem")
        if self.test_distribution is not None:
            self.changes_document.add_header(
                    'distribution', self.test_distribution)
            self.runtime_config_parser.set(
                    self.test_args['host'], 'allowed_distributions',
                    self.test_distribution)

        dput.dput.parse_changes.return_value = self.changes_document

    def set_upload_params(self):
        """ Set the upload parameters for this test case. """
        self.upload_params_by_name = make_upload_files_params(
                self.fake_checksum_by_file,
                self.fake_size_by_file)

    def patch_parse_changes(self):
        """ Patch `parse_changes` function for this test case. """
        func_patcher = unittest.mock.patch.object(
                dput.dput, "parse_changes", autospec=True)
        func_patcher.start()
        self.addCleanup(func_patcher.stop)

        self.set_upload_params()
        self.set_changes_document()

    def patch_check_upload_variant(self):
        """ Patch `check_upload_variant` function for this test case. """
        if not hasattr(self, 'check_upload_variant_return_value'):
            self.check_upload_variant_return_value = True

        func_patcher = unittest.mock.patch.object(
                dput.dput, "check_upload_variant", autospec=True,
                return_value=self.check_upload_variant_return_value)
        func_patcher.start()
        self.addCleanup(func_patcher.stop)

    def patch_version_check(self):
        """ Patch `version_check` function for this test case. """
        func_patcher = unittest.mock.patch.object(
                dput.dput, "version_check", autospec=True)
        func_patcher.start()
        self.addCleanup(func_patcher.stop)

    def patch_verify_signature(self):
        """ Patch `verify_signature` function for this test case. """
        func_patcher = unittest.mock.patch.object(
                dput.dput, "verify_signature", autospec=True)
        func_patcher.start()
        self.addCleanup(func_patcher.stop)

    def patch_source_check(self):
        """ Patch `source_check` function for this test case. """
        func_patcher = unittest.mock.patch.object(
                dput.dput, "source_check", autospec=True)
        mock_func = func_patcher.start()
        self.addCleanup(func_patcher.stop)

        source_check_result = getattr(
                self, 'source_check_result', SourceCheckResult(
                    include_orig=False, include_tar=False))
        mock_func.return_value = source_check_result

    def set_test_args(self):
        """ Set test args for this test case. """
        extra_args = getattr(self, 'extra_args', {})
        self.test_args = self.default_args.copy()
        self.test_args['config'] = self.runtime_config_parser
        self.test_args.update(extra_args)

    def set_expected_binary_upload(self):
        """ Set expected value for `binary_upload` flag. """
        self.expected_binary_upload = self.check_upload_variant_return_value

    def set_expected_source_control_file_path(self):
        """ Set expected value for source control file path. """
        file_name = next(
                os.path.basename(file_path)
                for file_path in self.fake_upload_file_paths
                if file_path.endswith(".dsc"))
        if not self.expected_binary_upload:
            self.expected_source_control_file_path = os.path.join(
                    os.path.dirname(self.changes_file_double.path), file_name)
        else:
            self.expected_source_control_file_path = ""

    def test_emits_changes_file_path_debug_message(self):
        """ Should emit debug message for changes file path. """
        self.test_args['debug'] = True
        dput.dput.verify_files(**self.test_args)
        expected_output = textwrap.dedent("""\
                D: Validating contents of changes file {path}
                """).format(path=self.changes_file_double.path)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_calls_sys_exit_if_input_read_denied(self):
        """ Should call `sys.exit` if input file read access is denied. """
        set_changes_file_scenario(self, 'error-read-denied')
        with testtools.ExpectedException(FakeSystemExit):
            dput.dput.verify_files(**self.test_args)
        expected_output = textwrap.dedent("""\
                Can't open {path}
                """).format(path=self.changes_file_double.path)
        self.assertIn(expected_output, sys.stdout.getvalue())
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)

    def test_calls_parse_changes_with_changes_files(self):
        """ Should call `parse_changes` with changes file. """
        dput.dput.verify_files(**self.test_args)
        dput.dput.parse_changes.assert_called_with(
                self.changes_file_double.fake_file)

    def test_calls_check_upload_variant_with_changes_document(self):
        """ Should call `check_upload_variant` with changes document. """
        dput.dput.verify_files(**self.test_args)
        dput.dput.check_upload_variant.assert_called_with(
                self.changes_document, unittest.mock.ANY)

    def test_emits_upload_dsc_file_debug_message(self):
        """ Should emit debug message for ‘*.dsc’ file. """
        if getattr(self, 'check_upload_variant_return_value', True):
            self.skipTest("Binary package upload for this scenario")
        self.test_args['debug'] = True
        dput.dput.verify_files(**self.test_args)
        dsc_file_path = next(
                os.path.basename(file_path)
                for file_path in self.fake_upload_file_paths
                if file_path.endswith(".dsc"))
        expected_output = textwrap.dedent("""\
                D: dsc-File: {path}
                """).format(path=dsc_file_path)
        self.assertThat(
                sys.stdout.getvalue(),
                testtools.matchers.Contains(expected_output))

    def test_calls_sys_exit_when_source_upload_omits_dsc_file(self):
        """ Should call `sys.exit` when source upload omits ‘*.dsc’ file. """
        if getattr(self, 'check_upload_variant_return_value', True):
            self.skipTest("Binary package upload for this scenario")
        self.fake_checksum_by_file = dict(
                (file_path, checksum)
                for (file_path, checksum)
                in self.fake_checksum_by_file.items()
                if not file_path.endswith(".dsc"))
        self.set_upload_params()
        self.set_changes_document()
        with testtools.ExpectedException(FakeSystemExit):
            dput.dput.verify_files(**self.test_args)
        expected_output = textwrap.dedent("""\
                Error: no dsc file found in sourceful upload
                """)
        self.assertThat(
                sys.stderr.getvalue(),
                testtools.matchers.Contains(expected_output))
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)

    def test_calls_version_check_when_specified_in_config(self):
        """ Should call `version_check` when specified in config. """
        self.runtime_config_parser.set(
                self.test_args['host'], 'check_version', "true")
        dput.dput.verify_files(**self.test_args)
        dput.dput.version_check.assert_called_with(
                os.path.dirname(self.changes_file_double.path),
                self.changes_document,
                self.test_args['debug'])

    def test_calls_version_check_when_specified_in_args(self):
        """ Should call `version_check` when specified in arguments. """
        self.test_args['check_version'] = True
        dput.dput.verify_files(**self.test_args)
        dput.dput.version_check.assert_called_with(
                os.path.dirname(self.changes_file_double.path),
                self.changes_document,
                self.test_args['debug'])

    def test_calls_sys_exit_when_host_section_not_in_config(self):
        """ Should call `sys.exit` when specified host not in config. """
        self.runtime_config_parser.remove_section(self.test_args['host'])
        with testtools.ExpectedException(FakeSystemExit):
            dput.dput.verify_files(**self.test_args)
        expected_output = textwrap.dedent("""\
                Error in config file:
                No section: ...
                """)
        self.assertThat(
                sys.stderr.getvalue(),
                testtools.matchers.DocTestMatches(
                    expected_output, doctest.ELLIPSIS))
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)

    def test_calls_verify_signature_with_expected_args(self):
        """ Should call `verify_signature` with expected args. """
        dput.dput.verify_files(**self.test_args)
        dput.dput.verify_signature.assert_called_with(
                self.test_args['host'],
                self.changes_file_double.path,
                self.expected_source_control_file_path,
                self.runtime_config_parser,
                self.test_args['check_only'],
                self.test_args['allow_unsigned_uploads'],
                unittest.mock.ANY,
                self.test_args['debug'])

    def test_calls_source_check_with_changes_document(self):
        """ Should call `source_check` with changes document. """
        dput.dput.verify_files(**self.test_args)
        dput.dput.source_check.assert_called_with(
                self.changes_document, self.test_args['debug'])

    def test_emits_upload_file_path_debug_message(self):
        """ Should emit debug message for each upload file path. """
        self.test_args['debug'] = True
        dput.dput.verify_files(**self.test_args)
        for file_path in self.fake_upload_file_paths:
            expected_output = textwrap.dedent("""\
                    D: File to upload: {path}
                    """).format(path=file_path)
            self.expectThat(
                    sys.stdout.getvalue(),
                    testtools.matchers.Contains(expected_output))

    def test_calls_checksum_test_with_upload_files(self):
        """ Should call `checksum_test` with each upload file path. """
        dput.dput.verify_files(**self.test_args)
        expected_calls = [
                unittest.mock.call(file_path, unittest.mock.ANY)
                for file_path in self.fake_upload_file_paths]
        dput.dput.checksum_test.assert_has_calls(
                expected_calls, any_order=True)

    def set_bogus_file_checksums(self):
        """ Set bogus file checksums that will not match. """
        self.fake_checksum_by_file = {
                file_name: self.getUniqueString()
                for file_name in self.fake_checksum_by_file}

    def test_emits_checksum_okay_debug_message(self):
        """ Should emit debug message checksum okay for each file. """
        self.test_args['debug'] = True
        dput.dput.verify_files(**self.test_args)
        for file_path in self.fake_upload_file_paths:
            expected_output = textwrap.dedent("""\
                    D: Checksum for {path} is fine
                    """).format(path=file_path)
            self.expectThat(
                    sys.stdout.getvalue(),
                    testtools.matchers.Contains(expected_output))

    def test_emits_checksum_mismatch_debug_message(self):
        """ Should emit debug message when a checksum does not match. """
        self.test_args['debug'] = True
        self.set_bogus_file_checksums()
        with testtools.ExpectedException(FakeSystemExit):
            dput.dput.verify_files(**self.test_args)
        expected_output = textwrap.dedent("""\
                ...
                D: Checksum from .changes: ...
                D: Generated Checksum: ...
                ...
                """)
        self.assertThat(
                sys.stdout.getvalue(),
                testtools.matchers.DocTestMatches(
                    expected_output, doctest.ELLIPSIS))

    def test_calls_sys_exit_when_checksum_mismatch(self):
        """ Should call `sys.exit` when a checksum does not match. """
        specified_checksum_by_file = self.fake_checksum_by_file
        self.set_bogus_file_checksums()
        with testtools.ExpectedException(FakeSystemExit):
            dput.dput.verify_files(**self.test_args)

        expected_output_for_files = [
                textwrap.dedent("""\
                    Checksum doesn't match for {file_name}
                    """).format(
                        file_name=os.path.join(
                            os.path.dirname(self.changes_file_double.path),
                            file_name),
                        specified_hash=specified_hash,
                        computed_hash=self.fake_checksum_by_file[file_name])
                for (file_name, specified_hash)
                in specified_checksum_by_file.items()]
        self.assertThat(
                sys.stdout.getvalue(),
                testtools.matchers.MatchesAny(*[
                    testtools.matchers.Contains(expected_output)
                    for expected_output in expected_output_for_files]))
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)

    def test_calls_os_stat_with_upload_files(self):
        """ Should call `os.stat` with each upload file path. """
        dput.dput.verify_files(**self.test_args)
        expected_calls = [
                unittest.mock.call(file_path)
                for file_path in self.fake_upload_file_paths]
        os.stat.assert_has_calls(expected_calls, any_order=True)

    def set_bogus_file_sizes(self):
        """ Set bogus file sizes that will not match. """
        file_double_registry = FileDouble.get_registry_for_testcase(self)
        for file_name in self.fake_size_by_file:
                bogus_size = self.getUniqueInteger()
                self.fake_size_by_file[file_name] = bogus_size
                file_path = os.path.join(
                        os.path.dirname(self.changes_file_double.path),
                        file_name)
                file_double = file_double_registry[file_path]
                file_double.stat_result = file_double.stat_result._replace(
                        st_size=bogus_size)

    def test_emits_size_mismatch_debug_message(self):
        """ Should emit debug message when a size does not match. """
        self.test_args['debug'] = True
        self.set_bogus_file_sizes()
        dput.dput.verify_files(**self.test_args)
        expected_output = textwrap.dedent("""\
                ...
                D: size from .changes: ...
                D: calculated size: ...
                ...
                """)
        self.assertThat(
                sys.stdout.getvalue(),
                testtools.matchers.DocTestMatches(
                    expected_output, doctest.ELLIPSIS))

    def test_emits_size_mismatch_message_for_each_file(self):
        """ Should emit error message for each file with size mismatch. """
        self.set_bogus_file_sizes()
        dput.dput.verify_files(**self.test_args)
        for file_path in self.fake_upload_file_paths:
            expected_output = textwrap.dedent("""\
                    size doesn't match for {path}
                    """).format(path=file_path)
            self.expectThat(
                    sys.stdout.getvalue(),
                    testtools.matchers.Contains(expected_output))

    def test_emits_rejection_warning_when_unexpected_tarball(self):
        """ Should emit warning of rejection when unexpected tarball. """
        if not hasattr(self, 'expected_rejection_message'):
            self.skipTest("No rejection message expected")
        dput.dput.verify_files(**self.test_args)
        sys.stderr.write("calls: {calls!r}\n".format(
                calls=sys.stdout.write.mock_calls))
        self.assertThat(
                sys.stdout.getvalue(),
                testtools.matchers.Contains(self.expected_rejection_message))

    def test_raises_error_when_distribution_mismatch(self):
        """ Should raise error when distribution mismatch against allowed. """
        if not getattr(self, 'test_distribution', None):
            self.skipTest("No distribution set for this test case")
        self.runtime_config_parser.set(
                self.test_args['host'], 'allowed_distributions',
                "dolor sit amet")
        with testtools.ExpectedException(dputhelper.DputUploadFatalException):
            dput.dput.verify_files(**self.test_args)

    def test_emits_changes_file_upload_debug_message(self):
        """ Should emit debug message for upload of changes file. """
        self.test_args['debug'] = True
        dput.dput.verify_files(**self.test_args)
        expected_output = textwrap.dedent("""\
                D: File to upload: {path}
                """).format(path=self.changes_file_double.path)
        self.assertIn(expected_output, sys.stdout.getvalue())

    def test_returns_expected_files_to_upload_collection(self):
        """ Should return expected `files_to_upload` collection value. """
        result = dput.dput.verify_files(**self.test_args)
        expected_result = self.expected_files_to_upload
        self.assertEqual(expected_result, set(result))


class guess_upload_host_TestCase(
        testscenarios.WithScenarios,
        testtools.TestCase):
    """ Test cases for `guess_upload_host` function. """

    changes_file_scenarios = [
            ('no-distribution', {
                'fake_file': io.StringIO(textwrap.dedent("""\
                    Files:
                        Lorem ipsum dolor sit amet
                    """)),
                }),
            ('distribution-spam', {
                'fake_file': io.StringIO(textwrap.dedent("""\
                    Distribution: spam
                    Files:
                        Lorem ipsum dolor sit amet
                    """)),
                }),
            ('distribution-beans', {
                'fake_file': io.StringIO(textwrap.dedent("""\
                    Distribution: beans
                    Files:
                        Lorem ipsum dolor sit amet
                    """)),
                }),
            ]

    scenarios = [
            ('distribution-found-of-one', {
                'changes_file_scenario_name': "distribution-spam",
                'test_distribution': "spam",
                'config_scenario_name': "exist-distribution-one",
                'expected_host': "foo",
                }),
            ('distribution-notfound-of-one', {
                'changes_file_scenario_name': "distribution-beans",
                'test_distribution': "beans",
                'config_scenario_name': "exist-distribution-one",
                'expected_host': "ftp-master",
                }),
            ('distribution-first-of-three', {
                'changes_file_scenario_name': "distribution-spam",
                'test_distribution': "spam",
                'config_scenario_name': "exist-distribution-three",
                'expected_host': "foo",
                }),
            ('distribution-last-of-three', {
                'changes_file_scenario_name': "distribution-beans",
                'test_distribution': "beans",
                'config_scenario_name': "exist-distribution-three",
                'expected_host': "foo",
                }),
            ('no-configured-distribution', {
                'changes_file_scenario_name': "distribution-beans",
                'config_scenario_name': "exist-distribution-none",
                'expected_host': "ftp-master",
                }),
            ('no-distribution', {
                'changes_file_scenario_name': "no-distribution",
                'config_scenario_name': "exist-simple",
                'expected_host': "ftp-master",
                }),
            ('default-distribution', {
                'config_scenario_name': "exist-default-distribution-only",
                'config_default_default_host_main': "consecteur",
                'expected_host': "consecteur",
                }),
            ]

    def setUp(self):
        """ Set up test fixtures. """
        super().setUp()
        patch_system_interfaces(self)

        set_config(
                self,
                getattr(self, 'config_scenario_name', 'exist-minimal'))
        patch_runtime_config_options(self)

        self.setup_changes_file_fixtures()
        set_changes_file_scenario(
                self,
                getattr(self, 'changes_file_scenario_name', 'no-distribution'))

        self.set_test_args()

    def set_test_args(self):
        """ Set the arguments for the test call to the function. """
        self.test_args = dict(
                changes_file_directory=os.path.dirname(
                    self.changes_file_double.path),
                changes_file_name=os.path.basename(
                    self.changes_file_double.path),
                config=self.runtime_config_parser,
                )

    def setup_changes_file_fixtures(self):
        """ Set up fixtures for fake changes file. """
        file_path = make_changes_file_path()

        scenarios = [s for (__, s) in self.changes_file_scenarios]
        for scenario in scenarios:
            scenario['file_double'] = FileDouble(
                    file_path, scenario['fake_file'])
        setup_file_double_behaviour(
                self,
                get_file_doubles_from_fake_file_scenarios(scenarios))

    def test_calls_sys_exit_if_read_denied(self):
        """ Should call `sys.exit` if read permission denied. """
        self.changes_file_double.set_os_access_scenario('denied')
        self.changes_file_double.set_open_scenario('read_denied')
        with testtools.ExpectedException(FakeSystemExit):
            dput.dput.guess_upload_host(**self.test_args)
        expected_output = textwrap.dedent("""\
                Can't open {path}
                """).format(path=self.changes_file_double.path)
        self.assertIn(expected_output, sys.stdout.getvalue())
        sys.exit.assert_called_with(EXIT_STATUS_FAILURE)

    def test_returns_expected_host(self):
        """ Should return expected host value. """
        result = dput.dput.guess_upload_host(**self.test_args)
        self.assertEqual(self.expected_host, result)

    @unittest.mock.patch.object(dput.dput, 'debug', True)
    def test_emits_debug_message_for_host(self):
        """ Should emit a debug message for the discovered host. """
        config_parser = self.runtime_config_parser
        if not (
                config_parser.has_section(self.expected_host)
                and config_parser.get(self.expected_host, 'distributions')):
            self.skipTest("No distributions specified")
        dput.dput.guess_upload_host(**self.test_args)
        expected_output = textwrap.dedent("""\
                D: guessing host {host} based on distribution {dist}
                """).format(
                    host=self.expected_host, dist=self.test_distribution)
        self.assertIn(expected_output, sys.stdout.getvalue())


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
