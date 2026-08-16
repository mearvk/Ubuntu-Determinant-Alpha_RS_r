"""Testing helpers."""

# Copyright (C) 2012 Canonical Ltd.
#
# Germinate is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; either version 2, or (at your option) any
# later version.
#
# Germinate is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Germinate; see the file COPYING.  If not, write to the Free
# Software Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
# 02110-1301, USA.

from __future__ import print_function

import errno
import io
import os
import shutil
import tempfile

from fixtures import FakeLogger
import testtools

from germinate.seeds import SeedStructure


class TestCase(testtools.TestCase):
    def __init__(self, *args, **kwargs):
        super(TestCase, self).__init__(*args, **kwargs)
        self.temp_dir = None
        self.archive_dir = None
        self.seeds_dir = None
        self.logger = self.useFixture(FakeLogger("germinate"))

    def useTempDir(self):
        if self.temp_dir is not None:
            return

        self.temp_dir = tempfile.mkdtemp(prefix="germinate")
        self.addCleanup(shutil.rmtree, self.temp_dir)
        cwd = os.open(".", os.O_RDONLY | os.O_DIRECTORY)
        self.addCleanup(os.close, cwd)
        os.chdir(self.temp_dir)
        self.addCleanup(os.fchdir, cwd)

    def setUpDirs(self):
        if self.archive_dir is not None:
            return

        self.useTempDir()
        self.archive_dir = os.path.join(self.temp_dir, "archive")
        os.makedirs(self.archive_dir)
        self.seeds_dir = os.path.join(self.temp_dir, "seeds")
        os.makedirs(self.seeds_dir)

    def ensureDir(self, path):
        try:
            os.makedirs(path)
        except OSError as e:
            if e.errno != errno.EEXIST:
                raise

    def ensureParentDir(self, path):
        self.ensureDir(os.path.dirname(path))

    def addSource(self, dist, component, src, ver, bins, fields={}):
        self.setUpDirs()
        compdir = os.path.join(self.archive_dir, "dists", dist, component)
        sources_path = os.path.join(compdir, "source", "Sources")

        self.ensureParentDir(sources_path)
        with open(sources_path, "a") as sources:
            print("Package: %s" % src, file=sources)
            print("Version: %s" % ver, file=sources)
            print("Binary: %s" % ", ".join(bins), file=sources)
            for key, value in fields.items():
                print("%s: %s" % (key, value), file=sources)
            print(file=sources)

    def addPackage(self, dist, component, arch, pkg, ver, udeb=False,
                   fields={}):
        self.setUpDirs()
        compdir = os.path.join(self.archive_dir, "dists", dist, component)
        if udeb:
            packages_path = os.path.join(compdir, "debian-installer",
                                         "binary-%s" % arch, "Packages")
        else:
            packages_path = os.path.join(compdir, "binary-%s" % arch,
                                         "Packages")

        self.ensureParentDir(packages_path)
        with open(packages_path, "a") as packages:
            print("Package: %s" % pkg, file=packages)
            print("Version: %s" % ver, file=packages)
            for key, value in fields.items():
                print("%s: %s" % (key, value), file=packages)
            print(file=packages)

    def addStructureLine(self, seed_dist, line):
        self.setUpDirs()
        structure_path = os.path.join(self.seeds_dir, seed_dist, "STRUCTURE")
        self.ensureParentDir(structure_path)
        with open(structure_path, "a") as structure:
            print(line, file=structure)

    def addSeed(self, seed_dist, name, parents=[]):
        self.addStructureLine(seed_dist, "%s: %s" % (name, " ".join(parents)))

    def addSeedPackage(self, seed_dist, seed_name, pkg):
        self.setUpDirs()
        seed_path = os.path.join(self.seeds_dir, seed_dist, seed_name)
        self.ensureParentDir(seed_path)
        with io.open(seed_path, "a", encoding="UTF-8") as seed:
            print(u" * %s" % pkg, file=seed)

    def addSeedSnap(self, seed_dist, seed_name, pkg):
        self.setUpDirs()
        seed_path = os.path.join(self.seeds_dir, seed_dist, seed_name)
        self.ensureParentDir(seed_path)
        with io.open(seed_path, "a", encoding="UTF-8") as seed:
            print(u" * snap:%s" % pkg, file=seed)

    def openSeedStructure(self, branch):
        return SeedStructure(branch, seed_bases=["file://%s" % self.seeds_dir])
