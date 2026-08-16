# test/helper.py
# Part of ‘dput’, a Debian package upload toolkit.
#
# This is free software, and you are welcome to redistribute it under
# certain conditions; see the end of this file for copyright
# information, grant of license, and disclaimer of warranty.

""" Helper functionality for Dput test suite. """

import base64
import builtins
import collections
import collections.abc
import errno
import functools
import io
import itertools
import os
import os.path
import pwd
import shlex
import shutil
import signal
import subprocess
import sys
import tempfile
import time
import unittest.mock
import weakref


try:
    # Python 2 types.
    basestring
    unicode
except NameError:
    # Alias for Python 3 types.
    basestring = str
    unicode = str


def make_unique_slug(testcase):
    """ Make a unique slug for the test case. """
    text = base64.b64encode(
            testcase.getUniqueString().encode('utf-8')
            ).decode('utf-8')
    result = text[-30:]
    return result


def make_fake_fqdn(testcase):
    """ Make a fake Fully-Qualified Domain Name (FQDN). """
    slug = make_unique_slug(testcase)
    fqdn = "{}.example.net".format(slug)
    return fqdn


def patch_stdout(testcase):
    """ Patch `sys.stdout` for the specified test case. """
    patcher = unittest.mock.patch.object(
            sys, "stdout", wraps=io.StringIO())
    patcher.start()
    testcase.addCleanup(patcher.stop)


def patch_stderr(testcase):
    """ Patch `sys.stderr` for the specified test case. """
    patcher = unittest.mock.patch.object(
            sys, "stderr", wraps=io.StringIO())
    patcher.start()
    testcase.addCleanup(patcher.stop)


def patch_signal_signal(testcase):
    """ Patch `signal.signal` for the specified test case. """
    func_patcher = unittest.mock.patch.object(
            signal, "signal", autospec=True)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


class FakeSystemExit(SystemExit):
    """ Fake double for `SystemExit` exception. """


EXIT_STATUS_SUCCESS = os.EX_OK
EXIT_STATUS_FAILURE = 1
EXIT_STATUS_COMMAND_NOT_FOUND = 127


def patch_sys_exit(testcase):
    """ Patch `sys.exit` for the specified test case. """
    func_patcher = unittest.mock.patch.object(
            sys, "exit", autospec=True,
            side_effect=FakeSystemExit())
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


def patch_sys_argv(testcase):
    """ Patch the `sys.argv` sequence for the test case. """
    if not hasattr(testcase, 'progname'):
        testcase.progname = make_unique_slug(testcase)
    if not hasattr(testcase, 'sys_argv'):
        testcase.sys_argv = [testcase.progname]
    patcher = unittest.mock.patch.object(
            sys, "argv",
            new=list(testcase.sys_argv))
    patcher.start()
    testcase.addCleanup(patcher.stop)


def patch_system_interfaces(testcase):
    """ Patch system interfaces that are disruptive to the test runner. """
    patch_stdout(testcase)
    patch_stderr(testcase)
    patch_sys_exit(testcase)
    patch_sys_argv(testcase)


def patch_time_time(testcase, values=None):
    """ Patch the `time.time` function for the specified test case.

        :param testcase: The `TestCase` instance for binding to the patch.
        :param values: An iterable to provide return values.
        :return: None.

        """
    if values is None:
        values = itertools.count()

    def generator_fake_time():
        while True:
            yield next(values)

    func_patcher = unittest.mock.patch.object(time, "time", autospec=True)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)

    time.time.side_effect = generator_fake_time()


def patch_os_environ(testcase):
    """ Patch the `os.environ` mapping. """
    if not hasattr(testcase, 'os_environ'):
        testcase.os_environ = {}
    patcher = unittest.mock.patch.object(
            os, "environ", new=testcase.os_environ)
    patcher.start()
    testcase.addCleanup(patcher.stop)


def patch_os_getpid(testcase):
    """ Patch `os.getpid` for the specified test case. """
    func_patcher = unittest.mock.patch.object(os, "getpid", autospec=True)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


def patch_os_getuid(testcase):
    """ Patch the `os.getuid` function. """
    if not hasattr(testcase, 'os_getuid_return_value'):
        testcase.os_getuid_return_value = testcase.getUniqueInteger()
    func_patcher = unittest.mock.patch.object(
            os, "getuid", autospec=True,
            return_value=testcase.os_getuid_return_value)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


PasswdEntry = collections.namedtuple(
        "PasswdEntry",
        "pw_name pw_passwd pw_uid pw_gid pw_gecos pw_dir pw_shell")


def patch_pwd_getpwuid(testcase):
    """ Patch the `pwd.getpwuid` function. """
    if not hasattr(testcase, 'pwd_getpwuid_return_value'):
        testcase.pwd_getpwuid_return_value = PasswdEntry(
                pw_name=make_unique_slug(testcase),
                pw_passwd=make_unique_slug(testcase),
                pw_uid=testcase.getUniqueInteger(),
                pw_gid=testcase.getUniqueInteger(),
                pw_gecos=testcase.getUniqueString(),
                pw_dir=tempfile.mktemp(),
                pw_shell=tempfile.mktemp())
    if not isinstance(testcase.pwd_getpwuid_return_value, pwd.struct_passwd):
        pwent = pwd.struct_passwd(testcase.pwd_getpwuid_return_value)
    else:
        pwent = testcase.pwd_getpwuid_return_value
    func_patcher = unittest.mock.patch.object(
            pwd, "getpwuid", autospec=True,
            return_value=pwent)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


def patch_os_path_exists(testcase):
    """ Patch `os.path.exists` behaviour for this test case.

        When the patched function is called, the registry of
        `FileDouble` instances for this test case will be used to get
        the instance for the path specified.

        """
    orig_os_path_exists = os.path.exists

    def fake_os_path_exists(path):
        registry = FileDouble.get_registry_for_testcase(testcase)
        if path in registry:
            file_double = registry[path]
            result = file_double.os_path_exists_scenario.call_hook()
        else:
            result = orig_os_path_exists(path)
        return result

    func_patcher = unittest.mock.patch.object(
            os.path, "exists", autospec=True,
            side_effect=fake_os_path_exists)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


def patch_os_access(testcase):
    """ Patch `os.access` behaviour for this test case.

        When the patched function is called, the registry of
        `FileDouble` instances for this test case will be used to get
        the instance for the path specified.

        """
    orig_os_access = os.access

    def fake_os_access(path, mode):
        registry = FileDouble.get_registry_for_testcase(testcase)
        if path in registry:
            file_double = registry[path]
            result = file_double.os_access_scenario.call_hook(mode)
        else:
            result = orig_os_access(path, mode)
        return result

    func_patcher = unittest.mock.patch.object(
            os, "access", autospec=True,
            side_effect=fake_os_access)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


StatResult = collections.namedtuple(
        'StatResult', [
            'st_mode',
            'st_ino', 'st_dev', 'st_nlink',
            'st_uid', 'st_gid',
            'st_size',
            'st_atime', 'st_mtime', 'st_ctime',
            ])


def patch_os_stat(testcase):
    """ Patch `os.stat` behaviour for this test case.

        When the patched function is called, the registry of
        `FileDouble` instances for this test case will be used to get
        the instance for the path specified.

        """
    orig_os_stat = os.stat

    def fake_os_stat(path):
        registry = FileDouble.get_registry_for_testcase(testcase)
        if path in registry:
            file_double = registry[path]
            result = file_double.os_stat_scenario.call_hook()
        else:
            result = orig_os_stat(path)
        return result

    func_patcher = unittest.mock.patch.object(
            os, "stat", autospec=True,
            side_effect=fake_os_stat)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


def patch_os_lstat(testcase):
    """ Patch `os.lstat` behaviour for this test case.

        When the patched function is called, the registry of
        `FileDouble` instances for this test case will be used to get
        the instance for the path specified.

        """
    orig_os_lstat = os.lstat

    def fake_os_lstat(path):
        registry = FileDouble.get_registry_for_testcase(testcase)
        if path in registry:
            file_double = registry[path]
            result = file_double.os_lstat_scenario.call_hook()
        else:
            result = orig_os_lstat(path)
        return result

    func_patcher = unittest.mock.patch.object(
            os, "lstat", autospec=True,
            side_effect=fake_os_lstat)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


def patch_os_unlink(testcase):
    """ Patch `os.unlink` behaviour for this test case.

        When the patched function is called, the registry of
        `FileDouble` instances for this test case will be used to get
        the instance for the path specified.

        """
    orig_os_unlink = os.unlink

    def fake_os_unlink(path):
        registry = FileDouble.get_registry_for_testcase(testcase)
        if path in registry:
            file_double = registry[path]
            result = file_double.os_unlink_scenario.call_hook()
        else:
            result = orig_os_unlink(path)
        return result

    func_patcher = unittest.mock.patch.object(
            os, "unlink", autospec=True,
            side_effect=fake_os_unlink)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


def patch_os_rmdir(testcase):
    """ Patch `os.rmdir` behaviour for this test case.

        When the patched function is called, the registry of
        `FileDouble` instances for this test case will be used to get
        the instance for the path specified.

        """
    orig_os_rmdir = os.rmdir

    def fake_os_rmdir(path):
        registry = FileDouble.get_registry_for_testcase(testcase)
        if path in registry:
            file_double = registry[path]
            result = file_double.os_rmdir_scenario.call_hook()
        else:
            result = orig_os_rmdir(path)
        return result

    func_patcher = unittest.mock.patch.object(
            os, "rmdir", autospec=True,
            side_effect=fake_os_rmdir)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


def patch_shutil_rmtree(testcase):
    """ Patch `shutil.rmtree` behaviour for this test case.

        When the patched function is called, the registry of
        `FileDouble` instances for this test case will be used to get
        the instance for the path specified.

        """
    orig_shutil_rmtree = os.rmdir

    def fake_shutil_rmtree(path, ignore_errors=False, onerror=None):
        registry = FileDouble.get_registry_for_testcase(testcase)
        if path in registry:
            file_double = registry[path]
            result = file_double.shutil_rmtree_scenario.call_hook()
        else:
            result = orig_shutil_rmtree(path)
        return result

    func_patcher = unittest.mock.patch.object(
            shutil, "rmtree", autospec=True,
            side_effect=fake_shutil_rmtree)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


def patch_tempfile_mkdtemp(testcase):
    """ Patch the `tempfile.mkdtemp` function for this test case. """
    if not hasattr(testcase, 'tempfile_mkdtemp_file_double'):
        testcase.tempfile_mkdtemp_file_double = FileDouble(tempfile.mktemp())

    double = testcase.tempfile_mkdtemp_file_double
    double.set_os_unlink_scenario('okay')
    double.set_os_rmdir_scenario('okay')
    double.register_for_testcase(testcase)

    func_patcher = unittest.mock.patch.object(
            tempfile, "mkdtemp", autospec=True)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)

    tempfile.mkdtemp.return_value = testcase.tempfile_mkdtemp_file_double.path


try:
    FileNotFoundError
    FileExistsError
    PermissionError
except NameError:
    # Python 2 uses IOError.
    def _ensure_ioerror_args(init_args, init_kwargs, errno_value):
        result_kwargs = init_kwargs
        result_errno = errno_value
        result_strerror = os.strerror(errno_value)
        result_filename = None
        if len(init_args) >= 3:
            result_errno = init_args[0]
            result_filename = init_args[2]
        if 'errno' in init_kwargs:
            result_errno = init_kwargs['errno']
            del result_kwargs['errno']
        if 'filename' in init_kwargs:
            result_filename = init_kwargs['filename']
            del result_kwargs['filename']
        if len(init_args) >= 2:
            result_strerror = init_args[1]
        if 'strerror' in init_kwargs:
            result_strerror = init_kwargs['strerror']
            del result_kwargs['strerror']
        result_args = (result_errno, result_strerror, result_filename)
        return (result_args, result_kwargs)

    class FileNotFoundError(IOError):
        def __init__(self, *args, **kwargs):
            (args, kwargs) = _ensure_ioerror_args(
                    args, kwargs, errno_value=errno.ENOENT)
            super().__init__(*args, **kwargs)

    class FileExistsError(IOError):
        def __init__(self, *args, **kwargs):
            (args, kwargs) = _ensure_ioerror_args(
                    args, kwargs, errno_value=errno.EEXIST)
            super().__init__(*args, **kwargs)

    class PermissionError(IOError):
        def __init__(self, *args, **kwargs):
            (args, kwargs) = _ensure_ioerror_args(
                    args, kwargs, errno_value=errno.EPERM)
            super().__init__(*args, **kwargs)


def make_fake_file_scenarios(path=None):
    """ Make a collection of scenarios for testing with fake files.

        :path: The filesystem path of the fake file. If not specified,
            a valid random path will be generated.
        :return: A collection of scenarios for tests involving input files.

        The collection is a mapping from scenario name to a dictionary of
        scenario attributes.

        """

    if path is None:
        file_path = tempfile.mktemp()
    else:
        file_path = path

    fake_file_empty = io.StringIO()
    fake_file_minimal = io.StringIO("Lorem ipsum.")
    fake_file_large = io.StringIO("\n".join(
            "ABCDEFGH" * 100
            for __ in range(1000)))

    default_scenario_params = {
            'open_scenario_name': 'okay',
            'file_double_params': dict(
                path=file_path, fake_file=fake_file_minimal),
            }

    scenarios = {
            'default': {},
            'error-not-exist': {
                'open_scenario_name': 'nonexist',
                },
            'error-exist': {
                'open_scenario_name': 'exist_error',
                },
            'error-read-denied': {
                'open_scenario_name': 'read_denied',
                },
            'not-found': {
                'file_double_params': dict(
                    path=file_path, fake_file=fake_file_empty),
                },
            'exist-empty': {
                'file_double_params': dict(
                    path=file_path, fake_file=fake_file_empty),
                },
            'exist-minimal': {
                'file_double_params': dict(
                    path=file_path, fake_file=fake_file_minimal),
                },
            'exist-large': {
                'file_double_params': dict(
                    path=file_path, fake_file=fake_file_large),
                },
            }

    for (name, scenario) in scenarios.items():
        params = default_scenario_params.copy()
        params.update(scenario)
        scenario.update(params)
        scenario['file_double'] = FileDouble(**scenario['file_double_params'])
        scenario['file_double'].set_open_scenario(params['open_scenario_name'])
        scenario['fake_file_scenario_name'] = name

    return scenarios


def get_file_doubles_from_fake_file_scenarios(scenarios):
    """ Get the `FileDouble` instances from fake file scenarios.

        :param scenarios: Collection of fake file scenarios.
        :return: Collection of `FileDouble` instances.

        """
    doubles = set(
            scenario['file_double']
            for scenario in scenarios
            if scenario['file_double'] is not None)

    return doubles


def setup_file_double_behaviour(testcase, doubles=None):
    """ Set up file double instances and behaviour.

        :param testcase: The `TestCase` instance to modify.
        :param doubles: Collection of `FileDouble` instances.
        :return: None.

        If `doubles` is ``None``, a default collection will be made
        from the result of `make_fake_file_scenarios` result.

        """
    if doubles is None:
        scenarios = make_fake_file_scenarios()
        doubles = get_file_doubles_from_fake_file_scenarios(
                scenarios.values())

    for file_double in doubles:
        file_double.register_for_testcase(testcase)

    orig_open = builtins.open

    def fake_open(path, mode='rt', buffering=-1):
        registry = FileDouble.get_registry_for_testcase(testcase)
        if path in registry:
            file_double = registry[path]
            result = file_double.builtins_open_scenario.call_hook(
                    mode, buffering)
        else:
            result = orig_open(path, mode, buffering)
        return result

    mock_open = unittest.mock.mock_open()
    mock_open.side_effect = fake_open

    func_patcher = unittest.mock.patch.object(
            builtins, "open", new=mock_open)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


def setup_fake_file_fixtures(testcase):
    """ Set up fixtures for fake file doubles.

        :param testcase: The `TestCase` instance to modify.
        :return: None.

        """
    scenarios = make_fake_file_scenarios()
    testcase.fake_file_scenarios = scenarios

    file_doubles = get_file_doubles_from_fake_file_scenarios(
            scenarios.values())
    setup_file_double_behaviour(testcase, file_doubles)


def set_fake_file_scenario(testcase, name):
    """ Set the named fake file scenario for the test case. """
    scenario = testcase.fake_file_scenarios[name]
    testcase.fake_file_scenario = scenario
    testcase.file_double = scenario['file_double']
    testcase.file_double.register_for_testcase(testcase)


class TestDoubleFunctionScenario:
    """ Scenario for fake behaviour of a specific function. """

    def __init__(self, scenario_name, double):
        self.scenario_name = scenario_name
        self.double = double

        self.call_hook = getattr(
                self, "_hook_{name}".format(name=self.scenario_name))

    def __repr__(self):
        text = (
                "<{class_name} instance: {id}"
                " name: {name!r},"
                " call_hook name: {hook_name!r}"
                " double: {double!r}"
                ">").format(
                    class_name=self.__class__.__name__, id=id(self),
                    name=self.scenario_name, double=self.double,
                    hook_name=self.call_hook.__name__)
        return text

    def __eq__(self, other):
        result = True
        if not self.scenario_name == other.scenario_name:
            result = False
        if not self.double == other.double:
            result = False
        if not self.call_hook.__name__ == other.call_hook.__name__:
            result = False
        return result

    def __ne__(self, other):
        result = not self.__eq__(other)
        return result


class os_path_exists_scenario(TestDoubleFunctionScenario):
    """ Scenario for `os.path.exists` behaviour. """

    def _hook_exist(self):
        return True

    def _hook_not_exist(self):
        return False


class os_access_scenario(TestDoubleFunctionScenario):
    """ Scenario for `os.access` behaviour. """

    def _hook_okay(self, mode):
        return True

    def _hook_not_exist(self, mode):
        return False

    def _hook_read_only(self, mode):
        if mode & (os.W_OK | os.X_OK):
            result = False
        else:
            result = True
        return result

    def _hook_denied(self, mode):
        if mode & (os.R_OK | os.W_OK | os.X_OK):
            result = False
        else:
            result = True
        return result


class os_stat_scenario(TestDoubleFunctionScenario):
    """ Scenario for `os.stat` behaviour. """

    def _hook_okay(self):
        return self.double.stat_result

    def _hook_notfound_error(self):
        raise FileNotFoundError(
                self.double.path,
                "No such file or directory: {path!r}".format(
                    path=self.double.path))

    def _hook_denied_error(self):
        raise PermissionError(
                self.double.path,
                "Permission denied")


class os_lstat_scenario(os_stat_scenario):
    """ Scenario for `os.lstat` behaviour. """


class os_unlink_scenario(TestDoubleFunctionScenario):
    """ Scenario for `os.unlink` behaviour. """

    def _hook_okay(self):
        return None

    def _hook_nonexist(self):
        error = FileNotFoundError(
                self.double.path,
                "No such file or directory: {path!r}".format(
                    path=self.double.path))
        raise error

    def _hook_denied(self):
        error = PermissionError(
                self.double.path,
                "Permission denied")
        raise error


class os_rmdir_scenario(TestDoubleFunctionScenario):
    """ Scenario for `os.rmdir` behaviour. """

    def _hook_okay(self):
        return None

    def _hook_nonexist(self):
        error = FileNotFoundError(
                self.double.path,
                "No such file or directory: {path!r}".format(
                    path=self.double.path))
        raise error

    def _hook_denied(self):
        error = PermissionError(
                self.double.path,
                "Permission denied")
        raise error


class shutil_rmtree_scenario(TestDoubleFunctionScenario):
    """ Scenario for `shutil.rmtree` behaviour. """

    def _hook_okay(self):
        return None

    def _hook_nonexist(self):
        error = FileNotFoundError(
                self.double.path,
                "No such file or directory: {path!r}".format(
                    path=self.double.path))
        raise error

    def _hook_denied(self):
        error = PermissionError(
                self.double.path,
                "Permission denied")
        raise error


class builtins_open_scenario(TestDoubleFunctionScenario):
    """ Scenario for `builtins.open` behaviour. """

    def _hook_okay(self, mode, buffering):
        result = self.double.fake_file
        return result

    def _hook_nonexist(self, mode, buffering):
        if mode.startswith('r'):
            error = FileNotFoundError(
                    self.double.path,
                    "No such file or directory: {path!r}".format(
                        path=self.double.path))
            raise error
        result = self.double.fake_file
        return result

    def _hook_exist_error(self, mode, buffering):
        if mode.startswith('w') or mode.startswith('a'):
            error = FileExistsError(
                    self.double.path,
                    "File already exists: {path!r}".format(
                        path=self.double.path))
            raise error
        result = self.double.fake_file
        return result

    def _hook_read_denied(self, mode, buffering):
        if mode.startswith('r'):
            error = PermissionError(
                    self.double.path,
                    "Read denied on {path!r}".format(
                        path=self.double.path))
            raise error
        result = self.double.fake_file
        return result

    def _hook_write_denied(self, mode, buffering):
        if mode.startswith('w') or mode.startswith('a'):
            error = PermissionError(
                    self.double.path,
                    "Write denied on {path!r}".format(
                        path=self.double.path))
            raise error
        result = self.double.fake_file
        return result


class TestDoubleWithRegistry:
    """ Abstract base class for a test double with a test case registry. """

    registry_class = NotImplemented
    registries = NotImplemented

    function_scenario_params_by_class = NotImplemented

    def __new__(cls, *args, **kwargs):
        superclass = super()
        if superclass.__new__ is object.__new__:
            # The ‘object’ implementation complains about extra arguments.
            instance = superclass.__new__(cls)
        else:
            instance = superclass.__new__(cls, *args, **kwargs)
        instance.make_set_scenario_methods()

        return instance

    def __init__(self, *args, **kwargs):
        super().__init__(*args, **kwargs)
        self._set_method_per_scenario()

    def _make_set_scenario_method(self, scenario_class, params):
        def method(self, name):
            scenario = scenario_class(name, double=self)
            setattr(self, scenario_class.__name__, scenario)
        method.__doc__ = (
                """ Set the scenario for `{name}` behaviour. """
                ).format(name=scenario_class.__name__)
        method.__name__ = str(params['set_scenario_method_name'])
        return method

    def make_set_scenario_methods(self):
        """ Make `set_<scenario_class_name>` methods on this class. """
        for (function_scenario_class, function_scenario_params) in (
                self.function_scenario_params_by_class.items()):
            method = self._make_set_scenario_method(
                    function_scenario_class, function_scenario_params)
            setattr(self.__class__, method.__name__, method)
            function_scenario_params['set_scenario_method'] = method

    def _set_method_per_scenario(self):
        """ Set the method to be called for each scenario. """
        for function_scenario_params in (
                self.function_scenario_params_by_class.values()):
            function_scenario_params['set_scenario_method'](
                    self, function_scenario_params['default_scenario_name'])

    @classmethod
    def get_registry_for_testcase(cls, testcase):
        """ Get the FileDouble registry for the specified test case. """
        # Key in a dict must be hashable.
        key = (testcase.__class__, id(testcase))
        registry = cls.registries.setdefault(key, cls.registry_class())
        return registry

    def get_registry_key(self):
        """ Get the registry key for this double. """
        raise NotImplementedError

    def register_for_testcase(self, testcase):
        """ Add this instance to registry for the specified testcase. """
        registry = self.get_registry_for_testcase(testcase)
        key = self.get_registry_key()
        registry[key] = self
        unregister_func = functools.partial(
                self.unregister_for_testcase, testcase)
        testcase.addCleanup(unregister_func)

    def unregister_for_testcase(self, testcase):
        """ Remove this instance from registry for the specified testcase. """
        registry = self.get_registry_for_testcase(testcase)
        key = self.get_registry_key()
        if key in registry:
            registry.pop(key)


def copy_fake_file(fake_file):
    """ Make a copy of the `StringIO` instance. """
    fake_file_type = io.StringIO
    content = ""
    if fake_file is not None:
        fake_file_type = type(fake_file)
        content = fake_file.getvalue()
    assert issubclass(fake_file_type, object)
    result = fake_file_type(content)
    if hasattr(fake_file, 'encoding'):
        if not hasattr(result, 'encoding'):
            result.encoding = fake_file.encoding
    return result


class FileDouble(TestDoubleWithRegistry):
    """ A testing double for a file. """

    registry_class = dict
    registries = {}

    function_scenario_params_by_class = {
            os_path_exists_scenario: {
                'default_scenario_name': 'not_exist',
                'set_scenario_method_name': 'set_os_path_exists_scenario',
                },
            os_access_scenario: {
                'default_scenario_name': 'okay',
                'set_scenario_method_name': 'set_os_access_scenario',
                },
            os_stat_scenario: {
                'default_scenario_name': 'okay',
                'set_scenario_method_name': 'set_os_stat_scenario',
                },
            os_lstat_scenario: {
                'default_scenario_name': 'okay',
                'set_scenario_method_name': 'set_os_lstat_scenario',
                },
            builtins_open_scenario: {
                'default_scenario_name': 'okay',
                'set_scenario_method_name': 'set_open_scenario',
                },
            os_unlink_scenario: {
                'default_scenario_name': 'okay',
                'set_scenario_method_name': 'set_os_unlink_scenario',
                },
            os_rmdir_scenario: {
                'default_scenario_name': 'okay',
                'set_scenario_method_name': 'set_os_rmdir_scenario',
                },
            shutil_rmtree_scenario: {
                'default_scenario_name': 'okay',
                'set_scenario_method_name': 'set_shutil_rmtree_scenario',
                },
            }

    def __init__(self, path=None, fake_file=None, *args, **kwargs):
        self.path = path
        self.fake_file = copy_fake_file(fake_file)
        self.fake_file.name = path

        self._set_stat_result()

        super().__init__(*args, **kwargs)

    def _set_stat_result(self):
        """ Set the `os.stat` result for this file. """
        size = len(self.fake_file.getvalue())
        self.stat_result = StatResult(
                st_mode=0,
                st_ino=None, st_dev=None, st_nlink=None,
                st_uid=0, st_gid=0,
                st_size=size,
                st_atime=None, st_mtime=None, st_ctime=None,
                )

    def __repr__(self):
        text = "FileDouble(path={path!r}, fake_file={fake_file!r})".format(
                path=self.path, fake_file=self.fake_file)
        return text

    def get_registry_key(self):
        """ Get the registry key for this double. """
        result = self.path
        return result


class os_popen_scenario(TestDoubleFunctionScenario):
    """ Scenario for `os.popen` behaviour. """

    stream_name_by_mode = {
            'w': 'stdin',
            'r': 'stdout',
            }

    def _hook_success(self, argv, mode, buffering):
        stream_name = self.stream_name_by_mode[mode]
        stream_double = getattr(
                self.double, stream_name + '_double')
        result = stream_double.fake_file
        return result

    def _hook_failure(self, argv, mode, buffering):
        result = io.StringIO()
        return result

    def _hook_not_found(self, argv, mode, buffering):
        result = io.StringIO()
        return result


class os_waitpid_scenario(TestDoubleFunctionScenario):
    """ Scenario for `os.waitpid` behaviour. """

    def _hook_success(self, pid, options):
        result = (pid, EXIT_STATUS_SUCCESS)
        return result

    def _hook_failure(self, pid, options):
        result = (pid, EXIT_STATUS_FAILURE)
        return result

    def _hook_not_found(self, pid, options):
        error = OSError(errno.ECHILD)
        raise error


class os_system_scenario(TestDoubleFunctionScenario):
    """ Scenario for `os.system` behaviour. """

    def _hook_success(self, command):
        result = EXIT_STATUS_SUCCESS
        return result

    def _hook_failure(self, command):
        result = EXIT_STATUS_FAILURE
        return result

    def _hook_not_found(self, command):
        result = EXIT_STATUS_COMMAND_NOT_FOUND
        return result


class os_spawnv_scenario(TestDoubleFunctionScenario):
    """ Scenario for `os.spawnv` behaviour. """

    def _hook_success(self, mode, file, args):
        result = EXIT_STATUS_SUCCESS
        return result

    def _hook_failure(self, mode, file, args):
        result = EXIT_STATUS_FAILURE
        return result

    def _hook_not_found(self, mode, file, args):
        result = EXIT_STATUS_COMMAND_NOT_FOUND
        return result


ARG_ANY = object()
ARG_MORE = object()


class PopenDouble:
    """ A testing double for `subprocess.Popen`. """

    def __init__(self, args, *posargs, **kwargs):
        self.stdin = None
        self.stdout = None
        self.stderr = None
        self.pid = None
        self.returncode = None

        if kwargs.get('shell', False):
            self.argv = shlex.split(args)
        else:
            # The paramter is already a sequence of command-line arguments.
            self.argv = args

    def set_streams(self, subprocess_double, popen_kwargs):
        """ Set the streams on the `PopenDouble`.

            :param subprocess_double: The `SubprocessDouble` from
                which to get existing stream doubles.
            :param popen_kwargs: The keyword arguments to the
                `subprocess.Popen` call.
            :return: ``None``.

            """
        for stream_name in (
                name for name in ['stdin', 'stdout', 'stderr']
                if name in popen_kwargs):
            stream_spec = popen_kwargs[stream_name]
            if stream_spec is subprocess.PIPE:
                stream_double = getattr(
                        subprocess_double,
                        "{name}_double".format(name=stream_name))
                stream_file = stream_double.fake_file
            elif stream_spec is subprocess.STDOUT:
                stream_file = subprocess_double.stdout_double.fake_file
            else:
                stream_file = stream_spec
            setattr(self, stream_name, stream_file)

    def wait(self):
        """ Wait for subprocess to terminate. """
        return self.returncode


class subprocess_popen_scenario(TestDoubleFunctionScenario):
    """ Scenario for `subprocess.Popen` behaviour. """

    def _hook_success(self, testcase, args, *posargs, **kwargs):
        double = self.double.popen_double
        double.set_streams(self.double, kwargs)
        return double


def patch_subprocess_popen(testcase):
    """ Patch `subprocess.Popen` constructor for this test case.

        :param testcase: The `TestCase` instance to modify.
        :return: None.

        When the patched function is called, the registry of
        `SubprocessDouble` instances for this test case will be used
        to get the instance for the program path specified.

        """
    orig_subprocess_popen = subprocess.Popen

    def fake_subprocess_popen(args, *posargs, **kwargs):
        if kwargs.get('shell', False):
            argv = shlex.split(args)
        else:
            argv = args
        registry = SubprocessDouble.get_registry_for_testcase(testcase)
        if argv in registry:
            subprocess_double = registry[argv]
            result = subprocess_double.subprocess_popen_scenario.call_hook(
                    testcase, args, *posargs, **kwargs)
        else:
            result = orig_subprocess_popen(args, *posargs, **kwargs)
        return result

    func_patcher = unittest.mock.patch.object(
            subprocess, "Popen", autospec=True,
            side_effect=fake_subprocess_popen)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


class subprocess_call_scenario(TestDoubleFunctionScenario):
    """ Scenario for `subprocess.call` behaviour. """

    def _hook_success(self, command):
        result = EXIT_STATUS_SUCCESS
        return result

    def _hook_failure(self, command):
        result = EXIT_STATUS_FAILURE
        return result

    def _hook_not_found(self, command):
        result = EXIT_STATUS_COMMAND_NOT_FOUND
        return result


def patch_subprocess_call(testcase):
    """ Patch `subprocess.call` function for this test case.

        :param testcase: The `TestCase` instance to modify.
        :return: None.

        When the patched function is called, the registry of
        `SubprocessDouble` instances for this test case will be used
        to get the instance for the program path specified.

        """
    orig_subprocess_call = subprocess.call

    def fake_subprocess_call(command, *posargs, **kwargs):
        if kwargs.get('shell', False):
            command_argv = shlex.split(command)
        else:
            command_argv = command
        registry = SubprocessDouble.get_registry_for_testcase(testcase)
        if command_argv in registry:
            subprocess_double = registry[command_argv]
            result = subprocess_double.subprocess_call_scenario.call_hook(
                    command)
        else:
            result = orig_subprocess_call(command, *posargs, **kwargs)
        return result

    func_patcher = unittest.mock.patch.object(
            subprocess, "call", autospec=True,
            side_effect=fake_subprocess_call)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


class subprocess_check_call_scenario(TestDoubleFunctionScenario):
    """ Scenario for `subprocess.check_call` behaviour. """

    def _hook_success(self, command):
        return None

    def _hook_failure(self, command):
        result = EXIT_STATUS_FAILURE
        error = subprocess.CalledProcessError(result, command)
        raise error

    def _hook_not_found(self, command):
        result = EXIT_STATUS_COMMAND_NOT_FOUND
        error = subprocess.CalledProcessError(result, command)
        raise error


def patch_subprocess_check_call(testcase):
    """ Patch `subprocess.check_call` function for this test case.

        :param testcase: The `TestCase` instance to modify.
        :return: None.

        When the patched function is called, the registry of
        `SubprocessDouble` instances for this test case will be used
        to get the instance for the program path specified.

        """
    orig_subprocess_check_call = subprocess.check_call

    def fake_subprocess_check_call(command, *posargs, **kwargs):
        if kwargs.get('shell', False):
            command_argv = shlex.split(command)
        else:
            command_argv = command
        registry = SubprocessDouble.get_registry_for_testcase(testcase)
        if command_argv in registry:
            subprocess_double = registry[command_argv]
            scenario = subprocess_double.subprocess_check_call_scenario
            result = scenario.call_hook(command)
        else:
            result = orig_subprocess_check_call(command, *posargs, **kwargs)
        return result

    func_patcher = unittest.mock.patch.object(
            subprocess, "check_call", autospec=True,
            side_effect=fake_subprocess_check_call)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


class SubprocessDoubleRegistry(collections.abc.MutableMapping):
    """ Registry of `SubprocessDouble` instances by `argv`. """

    def __init__(self, *args, **kwargs):
        items = []
        if args:
            if isinstance(args[0], collections.abc.Mapping):
                items = args[0].items()
            if isinstance(args[0], collections.abc.Iterable):
                items = args[0]
        self._mapping = dict(items)

    def __repr__(self):
        text = "<{class_name} object: {mapping}>".format(
                class_name=self.__class__.__name__, mapping=self._mapping)
        return text

    def _match_argv(self, argv):
        """ Match the specified `argv` with our registered keys. """
        match = None
        if not isinstance(argv, collections.abc.Sequence):
            return match
        candidates = iter(self._mapping)
        while match is None:
            try:
                candidate = next(candidates)
            except StopIteration:
                break
            found = None
            if candidate == argv:
                # An exact match.
                found = True
            word_iter = enumerate(candidate)
            while found is None:
                try:
                    (word_index, candidate_word) = next(word_iter)
                except StopIteration:
                    break
                if candidate_word is ARG_MORE:
                    # Candiate matches any remaining words. We have a match.
                    found = True
                elif word_index > len(argv):
                    # Candidate is too long for the specified argv.
                    found = False
                elif candidate_word is ARG_ANY:
                    # Candidate matches any word at this position.
                    continue
                elif candidate_word == argv[word_index]:
                    # Candidate matches the word at this position.
                    continue
                else:
                    # This candidate does not match.
                    found = False
            if found is None:
                # Reached the end of the candidate without a mismatch.
                found = True
            if found:
                match = candidate
        return match

    def __getitem__(self, key):
        match = self._match_argv(key)
        if match is None:
            raise KeyError(key)
        result = self._mapping[match]
        return result

    def __setitem__(self, key, value):
        if key in self:
            del self[key]
        self._mapping[key] = value

    def __delitem__(self, key):
        match = self._match_argv(key)
        if match is not None:
            del self._mapping[match]

    def __iter__(self):
        return self._mapping.__iter__()

    def __len__(self):
        return self._mapping.__len__()


class SubprocessDouble(TestDoubleWithRegistry):
    """ A testing double for a subprocess. """

    registry_class = SubprocessDoubleRegistry
    registries = {}

    double_by_pid = weakref.WeakValueDictionary()

    function_scenario_params_by_class = {
            subprocess_popen_scenario: {
                'default_scenario_name': 'success',
                'set_scenario_method_name': 'set_subprocess_popen_scenario',
                },
            subprocess_call_scenario: {
                'default_scenario_name': 'success',
                'set_scenario_method_name': 'set_subprocess_call_scenario',
                },
            subprocess_check_call_scenario: {
                'default_scenario_name': 'success',
                'set_scenario_method_name':
                    'set_subprocess_check_call_scenario',
                },
            os_popen_scenario: {
                'default_scenario_name': 'success',
                'set_scenario_method_name': 'set_os_popen_scenario',
                },
            os_waitpid_scenario: {
                'default_scenario_name': 'success',
                'set_scenario_method_name': 'set_os_waitpid_scenario',
                },
            os_system_scenario: {
                'default_scenario_name': 'success',
                'set_scenario_method_name': 'set_os_system_scenario',
                },
            os_spawnv_scenario: {
                'default_scenario_name': 'success',
                'set_scenario_method_name': 'set_os_spawnv_scenario',
                },
            }

    def __init__(self, path=None, argv=None, *args, **kwargs):
        if path is None:
            path = tempfile.mktemp()
        self.path = path

        if argv is None:
            command_name = os.path.basename(path)
            argv = [command_name]
        self.argv = argv

        self.pid = self._make_pid()
        self._register_by_pid()

        self.set_popen_double()

        stream_class = SubprocessDouble.stream_class
        for stream_name in ['stdin', 'stdout', 'stderr']:
            fake_file = stream_class()
            file_double = FileDouble(fake_file=fake_file)
            stream_double_name = '{name}_double'.format(name=stream_name)
            setattr(self, stream_double_name, file_double)

        super().__init__(*args, **kwargs)

    def set_popen_double(self):
        """ Set the `PopenDouble` for this instance. """
        double = PopenDouble(self.argv)
        double.pid = self.pid

        self.popen_double = double

    def __repr__(self):
        text = (
                "<SubprocessDouble instance: {id}"
                " path: {path!r},"
                " argv: {argv!r}"
                " stdin_double: {stdin_double!r}"
                " stdout_double: {stdout_double!r}"
                " stderr_double: {stderr_double!r}"
                ">").format(
                    id=id(self),
                    path=self.path, argv=self.argv,
                    stdin_double=self.stdin_double,
                    stdout_double=self.stdout_double,
                    stderr_double=self.stderr_double)
        return text

    @classmethod
    def _make_pid(cls):
        """ Make a unique PID for a subprocess. """
        for pid in itertools.count(1):
            yield pid

    def _register_by_pid(self):
        """ Register this subprocess by its PID. """
        self.__class__.double_by_pid[self.pid] = self

    def get_registry_key(self):
        """ Get the registry key for this double. """
        result = tuple(self.argv)
        return result

    stream_class = io.BytesIO
    stream_encoding = "utf-8"

    def set_stdin_content(self, text, bytes_encoding=stream_encoding):
        """ Set the content of the `stdin` stream for this double. """
        content = text.encode(bytes_encoding)
        fake_file = self.stream_class(content)
        self.stdin_double.fake_file = fake_file

    def set_stdout_content(self, text, bytes_encoding=stream_encoding):
        """ Set the content of the `stdout` stream for this double. """
        content = text.encode(bytes_encoding)
        fake_file = self.stream_class(content)
        self.stdout_double.fake_file = fake_file

    def set_stderr_content(self, text, bytes_encoding=stream_encoding):
        """ Set the content of the `stderr` stream for this double. """
        content = text.encode(bytes_encoding)
        fake_file = self.stream_class(content)
        self.stderr_double.fake_file = fake_file


def make_fake_subprocess_scenarios(path=None):
    """ Make a collection of scenarios for testing with fake files.

        :path: The filesystem path of the fake program. If not specified,
            a valid random path will be generated.
        :return: A collection of scenarios for tests involving subprocesses.

        The collection is a mapping from scenario name to a dictionary of
        scenario attributes.

        """
    if path is None:
        file_path = tempfile.mktemp()
    else:
        file_path = path

    default_scenario_params = {
            'return_value': EXIT_STATUS_SUCCESS,
            'program_path': file_path,
            'argv_after_command_name': [],
            }

    scenarios = {
            'default': {},
            'not-found': {
                'return_value': EXIT_STATUS_COMMAND_NOT_FOUND,
                },
            }

    for (name, scenario) in scenarios.items():
        params = default_scenario_params.copy()
        params.update(scenario)
        scenario.update(params)
        program_path = params['program_path']
        program_name = os.path.basename(params['program_path'])
        argv = [program_name]
        argv.extend(params['argv_after_command_name'])
        subprocess_double_params = dict(
                path=program_path,
                argv=argv,
                )
        subprocess_double = SubprocessDouble(**subprocess_double_params)
        scenario['subprocess_double'] = subprocess_double
        scenario['fake_file_scenario_name'] = name

    return scenarios


def get_subprocess_doubles_from_fake_subprocess_scenarios(scenarios):
    """ Get the `SubprocessDouble` instances from fake subprocess scenarios.

        :param scenarios: Collection of fake subprocess scenarios.
        :return: Collection of `SubprocessDouble` instances.

        """
    doubles = set(
            scenario['subprocess_double']
            for scenario in scenarios
            if scenario['subprocess_double'] is not None)

    return doubles


def setup_subprocess_double_behaviour(testcase, doubles=None):
    """ Set up subprocess double instances and behaviour.

        :param testcase: The `TestCase` instance to modify.
        :param doubles: Collection of `SubprocessDouble` instances.
        :return: None.

        If `doubles` is ``None``, a default collection will be made
        from the return value of `make_fake_subprocess_scenarios`.

        """
    if doubles is None:
        scenarios = make_fake_subprocess_scenarios()
        doubles = get_subprocess_doubles_from_fake_subprocess_scenarios(
                scenarios.values())

    for double in doubles:
        double.register_for_testcase(testcase)


def setup_fake_subprocess_fixtures(testcase):
    """ Set up fixtures for fake subprocess doubles.

        :param testcase: The `TestCase` instance to modify.
        :return: None.

        """
    scenarios = make_fake_subprocess_scenarios()
    testcase.fake_subprocess_scenarios = scenarios

    doubles = get_subprocess_doubles_from_fake_subprocess_scenarios(
            scenarios.values())
    setup_subprocess_double_behaviour(testcase, doubles)


def patch_os_popen(testcase):
    """ Patch `os.popen` behaviour for this test case.

        :param testcase: The `TestCase` instance to modify.
        :return: None.

        When the patched function is called, the registry of
        `SubprocessDouble` instances for this test case will be used
        to get the instance for the program path specified.

        """
    orig_os_popen = os.popen

    def fake_os_popen(cmd, mode='r', buffering=-1):
        registry = SubprocessDouble.get_registry_for_testcase(testcase)
        if isinstance(cmd, basestring):
            command_argv = shlex.split(cmd)
        else:
            command_argv = cmd
        if command_argv in registry:
            subprocess_double = registry[command_argv]
            result = subprocess_double.os_popen_scenario.call_hook(
                    command_argv, mode, buffering)
        else:
            result = orig_os_popen(cmd, mode, buffering)
        return result

    func_patcher = unittest.mock.patch.object(
            os, "popen", autospec=True,
            side_effect=fake_os_popen)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


def patch_os_waitpid(testcase):
    """ Patch `os.waitpid` behaviour for this test case.

        :param testcase: The `TestCase` instance to modify.
        :return: None.

        When the patched function is called, the registry of
        `SubprocessDouble` instances for this test case will be used
        to get the instance for the program path specified.

        """
    orig_os_waitpid = os.waitpid

    def fake_os_waitpid(pid, options):
        registry = SubprocessDouble.double_by_pid
        if pid in registry:
            subprocess_double = registry[pid]
            result = subprocess_double.os_waitpid_scenario.call_hook(
                    pid, options)
        else:
            result = orig_os_waitpid(pid, options)
        return result

    func_patcher = unittest.mock.patch.object(
            os, "waitpid", autospec=True,
            side_effect=fake_os_waitpid)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


def patch_os_system(testcase):
    """ Patch `os.system` behaviour for this test case.

        :param testcase: The `TestCase` instance to modify.
        :return: None.

        When the patched function is called, the registry of
        `SubprocessDouble` instances for this test case will be used
        to get the instance for the program path specified.

        """
    orig_os_system = os.system

    def fake_os_system(command):
        registry = SubprocessDouble.get_registry_for_testcase(testcase)
        command_argv = shlex.split(command)
        if command_argv in registry:
            subprocess_double = registry[command_argv]
            result = subprocess_double.os_system_scenario.call_hook(
                    command)
        else:
            result = orig_os_system(command)
        return result

    func_patcher = unittest.mock.patch.object(
            os, "system", autospec=True,
            side_effect=fake_os_system)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


def patch_os_spawnv(testcase):
    """ Patch `os.spawnv` behaviour for this test case.

        :param testcase: The `TestCase` instance to modify.
        :return: None.

        When the patched function is called, the registry of
        `SubprocessDouble` instances for this test case will be used
        to get the instance for the program path specified.

        """
    orig_os_spawnv = os.spawnv

    def fake_os_spawnv(mode, file, args):
        registry = SubprocessDouble.get_registry_for_testcase(testcase)
        registry_key = tuple(args)
        if registry_key in registry:
            subprocess_double = registry[registry_key]
            result = subprocess_double.os_spawnv_scenario.call_hook(
                    mode, file, args)
        else:
            result = orig_os_spawnv(mode, file, args)
        return result

    func_patcher = unittest.mock.patch.object(
            os, "spawnv", autospec=True,
            side_effect=fake_os_spawnv)
    func_patcher.start()
    testcase.addCleanup(func_patcher.stop)


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
