#!/usr/bin/python
# Copyright (C) 2012 Canonical
#
# Authors:
#  Didier Roche <didrocks@ubuntu.com>
#
# This program is free software: you can redistribute it and/or modify it
# under the terms of the GNU Lesser General Public License as published
# by the Free Software Foundation;  either version 3 of the License,
# or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranties of
# MERCHANTABILITY, SATISFACTORY QUALITY, or FITNESS FOR A PARTICULAR
# PURPOSE.  See the GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program.  If not, see <http://www.gnu.org/licenses/>.

import configparser
import json
import os
import re
import shutil
import stat
import subprocess
import tempfile
import time
import unittest


class MigrationTests(unittest.TestCase):

    def setUp(self):
        self.config = configparser.RawConfigParser()
        self.tmpdir = None
        self.output_files = None
        self.maxDiff = None
        self.setup_env()

    def tearDown(self):
        self.clean_env()

    def clean_env(self):
        '''Clean setup files if present'''
        if self.tmpdir:
            try:
                shutil.rmtree(self.tmpdir)
            except OSError:
                pass
            self.tmpdir = None
        if self.output_files:
            for output_file in self.output_files:
                try:
                    os.remove(output_file)
                except OSError:
                    pass
            self.output_files = None

    def setup_env(self, test_name='main', systemtemp=False):
        '''Setup the env for a particular test domain'''
        # if we already called setup_env, clean it first
        self.clean_env()
        self.tmpdir = tempfile.mkdtemp()
        os.environ['DESKTOP_SESSION'] = 'migtestsession'
        home_migration_dir = os.path.join(self.tmpdir, 'home')
        self.migration_home_file = os.path.join(home_migration_dir, 'session_migration-migtestsession')
        os.environ['XDG_DATA_HOME'] = home_migration_dir
        if systemtemp:
            system_data_path = os.path.join(self.tmpdir, 'system')
            os.environ['XDG_DATA_DIRS'] = system_data_path
        else:
            system_data_path = os.path.abspath(os.path.join('tests', 'data', test_name))
            os.environ['XDG_DATA_DIRS'] = system_data_path
            # loading the expected result
            with open(os.path.join(system_data_path, 'output_files')) as f:
                self.output_files = json.load(f)
        self.script_path = os.path.join(system_data_path, 'session-migration', 'scripts')

    def run_migration(self, command=None, verbose=True, additional_params=None):
        '''helper to run migration tool'''
        if not command:
            command = ['./src/session-migration']
        if verbose:
            command.append('--verbose')
        if additional_params:
            command.extend(additional_params)
        p = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE)
        stdout, stderr = p.communicate()
        return (stdout.decode('UTF-8'), stderr.decode('UTF-8'))

    def test_no_output_default(self):
        '''Test that by default, there is no output'''
        self.setup_env(systemtemp=True)
        (stdout, stderr) = self.run_migration(verbose=False)
        self.assertEqual(stdout, '')
        self.assertEqual(stderr, '')
        # nothing should be created
        self.assertFalse(os.path.isfile(self.migration_home_file))

    def test_detect_dirs_doesn_t_exist(self):
        '''Test that some system dirs doesn't exist and nothing is done (but that multiple directories are detected)'''
        self.setup_env(systemtemp=True)
        os.environ['XDG_DATA_DIRS'] = '{}:{}'.format(os.environ['XDG_DATA_DIRS'], os.path.join(self.tmpdir, 'system2'))
        self.home_migration_dir = '/tmp/migrationstests'
        (stdout, stderr) = self.run_migration()
        self.assertEqual(stdout, "Directory '{}' does not exist, nothing to do\nDirectory '{}' does not exist, nothing to do\n".format(
                                 os.path.join(self.tmpdir, 'system', 'session-migration/scripts'), os.path.join(self.tmpdir, 'system2', 'session-migration/scripts')))
        self.assertEqual(stderr, '')
        # nothing should be created
        self.assertFalse(os.path.isfile(self.migration_home_file))

    def test_migration(self):
        '''Test that the migration happens as expected'''
        before_run_timestamp = int(time.time())
        time.sleep(1)  # for the timing test
        (stdout, stderr) = (self.run_migration())

        # ensure scripts are executed in the right order
        self.assertEqual(stdout, "Using '{}' directory\nExecuting: {}\nExecuting: {}\nExecuting: {}\nExecuting: {}\n".format(
                                 self.script_path, os.path.join(self.script_path, '01_test.sh'), os.path.join(self.script_path, '02_test.sh'),
                                 os.path.join(self.script_path, '08_test.sh'), os.path.join(self.script_path, '10_test.sh')))

        # ensure scripts 8 is not successfully working
        self.assertEqual(stderr, 'Failed to execute child process “{}” (Permission denied)\nstdout: (null)\nstderr: (null)\n'.format(os.path.join(self.script_path, '08_test.sh')))

        # ensure that the script are indeed have been run/not run and created the expected touched file
        for output_file in self.output_files:
            if self.output_files[output_file]:
                self.assertTrue(os.path.isfile(output_file))
            else:
                self.assertFalse(os.path.isfile(output_file))

        # ensure that the scripts are marked as done and exit under right session name (encoded in migration_home_file)
        self.config.read(self.migration_home_file)
        time.sleep(1)  # for the timing test

        # check the timestamp
        after_run_timestamp = int(time.time())
        self.assertTrue(self.config.getint('State', 'timestamp') < after_run_timestamp)
        self.assertTrue(self.config.getint('State', 'timestamp') > before_run_timestamp)

        # ensure that the scripts are stamped as migrated
        self.assertEqual([elem for elem in sorted(self.config.get('State', 'migrated').split(';')) if elem], ['01_test.sh', '02_test.sh', '10_test.sh'])

    def test_migration_with_dry_run(self):
        '''Test that the migration claimed to happen as expected in dry run mode'''
        (stdout, stderr) = (self.run_migration(additional_params=["--dry-run"]))

        # ensure scripts are executed in the right order
        self.assertEqual(stdout, "Using '{}' directory\nExecuting: {}\nExecuting: {}\nExecuting: {}\nExecuting: {}\n".format(
                                 self.script_path, os.path.join(self.script_path, '01_test.sh'), os.path.join(self.script_path, '02_test.sh'),
                                 os.path.join(self.script_path, '08_test.sh'), os.path.join(self.script_path, '10_test.sh')))

        # ensure scripts 8 is not executed (and so no failure)
        self.assertEqual(stderr, '')

        # ensure that the script have indeed not be run
        for output_file in self.output_files:
            self.assertFalse(os.path.isfile(output_file))

        # ensure that the scripts are not marked as done
        self.assertFalse(os.path.isfile(self.migration_home_file))

    def test_subsequent_runs_no_effect(self):
        '''Test that subsequent runs doesn't have any effect'''
        (stdout, stderr) = (self.run_migration())
        self.assertNotEqual(stdout, '')
        self.assertNotEqual(stderr, '')
        self.assertTrue(os.path.isfile(self.migration_home_file))
        with open(self.migration_home_file) as f:
            home_file = f.read()
        (stdout, stderr) = (self.run_migration())
        self.assertEqual(stdout, "Directory '{}' all uptodate, nothing to do\n".format(self.script_path))
        self.assertEqual(stderr, '')
        with open(self.migration_home_file) as f:
            second_home_file = f.read()
        self.assertEqual(home_file, second_home_file)

    def test_subsequent_runs_with_new_script(self):
        '''Test subsequent runs with a new script'''
        (stdout, stderr) = (self.run_migration())

        # remove all migration content (to ensure later that scripts are not reexecuted)
        for output_file in self.output_files:
            if self.output_files[output_file]:
                os.remove(output_file)

        # add a script to be runned in the same directory
        time.sleep(1)  # ensure that the directory is touched after the first run
        new_script = os.path.join(self.script_path, '08_testexecute.sh')
        shutil.copy(os.path.join(self.script_path, '08_test.sh'), new_script)
        os.chmod(new_script, stat.S_IREAD + stat.S_IEXEC)

        before_second_run = int(time.time())
        time.sleep(1)  # for the timing test
        (stdout, stderr) = (self.run_migration())
        time.sleep(1)  # for the timing test
        after_second_run = int(time.time())
        self.config.read(self.migration_home_file)

        # remove the script
        os.remove(new_script)

        # check the debug output
        self.assertTrue(re.match("Using '{}' directory\nFile '{files}_test.sh already migrated, skipping\nFile '{files}_test.sh already migrated, skipping\n"
                                 "File '{files}_test.sh already migrated, skipping\nExecuting: {}\nExecuting: {}\n".format(self.script_path, os.path.join(self.script_path, '08_test.sh'),
                                                                                                                      os.path.join(self.script_path, '08_testexecute.sh'),
                                                                                                                      files='(01|02|10)'),
                        stdout))
        self.assertEqual(stderr, 'Failed to execute child process “{}” (Permission denied)\nstdout: (null)\nstderr: (null)\n'.format(os.path.join(self.script_path, '08_test.sh')))

        # inverse the condition to ensure only the latest copied script has been executed
        for output_file in self.output_files:
            if not self.output_files[output_file]:
                self.assertTrue(os.path.isfile(output_file))
            else:
                self.assertFalse(os.path.isfile(output_file))

        # check that the timestamp is from the second run
        self.assertTrue(self.config.getint('State', 'timestamp') < after_second_run)
        self.assertTrue(self.config.getint('State', 'timestamp') > before_second_run)

        # ensure that the new script is stamped as migrated
        self.assertEqual([elem for elem in sorted(self.config.get('State', 'migrated').split(';')) if elem], ['01_test.sh', '02_test.sh', '08_testexecute.sh', '10_test.sh'])

    def test_run_only_one_script(self):
        '''Test that you can run one script only'''
        (stdout, stderr) = self.run_migration(additional_params=["--file={}".format(os.path.join(self.script_path, '10_test.sh'))])

        # check the output that only this file was ran
        self.assertEqual(stdout, "Executing: {}\n".format(os.path.join(self.script_path, '10_test.sh')))
        self.assertEqual(stderr, '')

        # check that only this touched file has been created
        for output_file in self.output_files:
            if '10' in output_file:
                self.assertTrue(os.path.isfile(output_file))
            else:
                self.assertFalse(os.path.isfile(output_file))

        # nothing should be logged
        self.assertFalse(os.path.isfile(self.migration_home_file))

if __name__ == '__main__':
    unittest.main()
