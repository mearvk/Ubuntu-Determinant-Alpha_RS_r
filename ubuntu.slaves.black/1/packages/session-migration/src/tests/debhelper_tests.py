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

import logging
import os
import shutil
import subprocess
import tempfile
import unittest

log = logging.getLogger(__name__)

class DebhelperTests(unittest.TestCase):

    def setUp(self):
        self.srcdir = os.path.abspath(os.path.join('tests', 'data', 'melticecream'))
        self.workdir = tempfile.mkdtemp()
        self.pkgdir = os.path.join(self.workdir, 'melticecream')
        shutil.copytree(self.srcdir, self.pkgdir)

        env = os.environ.copy()

        # do not depend on host induced build options
        del env['DEB_BUILD_OPTIONS']
        del env['DH_INTERNAL_OPTIONS']

        # point to local debhelper sequencer
        d = os.path.join(self.workdir, 'Debian', 'Debhelper', 'Sequence')
        os.makedirs(d)
        shutil.copy('debhelper/migrations.pm', d)
        env['PERLLIB'] = '%s:%s' % (self.workdir, env.get('PERLLIB', ''))

        # make dh_migrations available in $PATH
        shutil.copy('debhelper/dh_migrations',
                    os.path.join(self.workdir, 'dh_migrations'))
        env['PATH'] = self.workdir + ':' + env.get('PATH', '')
        self.env = env

    def tearDown(self):
        shutil.rmtree(self.workdir)

    def buildpackage(self, env):
        '''helper to build a package'''
        build = subprocess.Popen(['dpkg-buildpackage', '-us', '-uc', '-b'],
        stdout=subprocess.PIPE, stderr=subprocess.STDOUT,
        cwd=self.pkgdir, env=env)
        return build.communicate()[0].decode()

    def test_build_with_migrations(self):
        '''build the package with migration argument'''

        log.debug(self.env)

        stdout = self.buildpackage(self.env)
        self.assertTrue("dh_migrations" in stdout)

        # check the scripts are installed and executable
        scripts_path = os.path.join(self.pkgdir, 'debian/vanilla/usr/share/session-migration/scripts')
        self.assertTrue(os.path.isdir(scripts_path))
        self.assertTrue(os.path.isfile(os.path.join(scripts_path, "script1.sh")))
        self.assertTrue(os.path.isfile(os.path.join(scripts_path, "script2.sh")))
        self.assertTrue(os.access(os.path.join(scripts_path, "script1.sh"), os.X_OK))
        self.assertTrue(os.access(os.path.join(scripts_path, "script2.sh"), os.X_OK))

        # check the dep was added:
        with open(os.path.join(self.pkgdir, 'debian/vanilla/DEBIAN/control')) as f:
            self.assertEquals(f.read().count("session-migration"), 1)

    def test_build_with_missing_script(self):
        '''ensure assert when there is a typo in the script path or doesn't exist'''
        os.remove(os.path.join(self.pkgdir, "script1.sh"))
        stdout = self.buildpackage(self.env)
        self.assertTrue("dh_migrations: error: install -p -m755 script1.sh debian/vanilla/usr/share/session-migration/scripts returned exit code 1" in stdout)


if __name__ == '__main__':
    unittest.main()
