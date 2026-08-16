"""Integration tests for germinate."""

# Copyright (C) 2011, 2012 Canonical Ltd.
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

from germinate.scripts import germinate_main
from germinate.tests.helpers import TestCase


class TestGerminate(TestCase):
    def runGerminate(self, *args):
        self.useTempDir()
        argv = ["germinate"]
        argv.extend(["-S", "file://%s" % self.seeds_dir])
        argv.extend(["-m", "file://%s" % self.archive_dir])
        argv.extend(args)
        self.assertEqual(0, germinate_main.main(argv))

    def parseOutput(self, output_name):
        output_dict = {}
        with open(output_name) as output:
            output.readline()
            output.readline()
            for line in output:
                if line.startswith("-"):
                    break
                fields = [field.strip() for field in line.split("|")]
                output_dict[fields[0]] = fields[1:]
        return output_dict

    def test_trivial(self):
        self.addSource("warty", "main", "hello", "1.0-1",
                       ["hello", "hello-dependency"])
        self.addPackage("warty", "main", "i386", "hello", "1.0-1",
                        fields={"Depends": "hello-dependency"})
        self.addPackage("warty", "main", "i386", "hello-dependency", "1.0-1",
                        fields={"Source": "hello"})
        self.addSeed("ubuntu.warty", "supported")
        self.addSeedPackage("ubuntu.warty", "supported", "hello")
        self.runGerminate("-s", "ubuntu.warty", "-d", "warty", "-c", "main")

        supported = self.parseOutput("supported")
        self.assertTrue("hello" in supported)
        self.assertTrue("hello-dependency" in supported)

        all_ = self.parseOutput("all")
        self.assertTrue("hello" in all_)
        self.assertTrue("hello-dependency" in all_)

    def test_snap(self):
        # Need Packages
        self.addSource("warty", "main", "hello", "1.0-1",
                       ["hello", "hello-dependency"])
        self.addPackage("warty", "main", "i386", "hello-dependency", "1.0-1",
                        fields={"Source": "hello"})
        self.addSeed("ubuntu.warty", "supported")
        self.addSeedSnap("ubuntu.warty", "supported", "mycoolsnap")
        self.runGerminate("-s", "ubuntu.warty", "-d", "warty", "-c", "main")

        supported = self.parseOutput("supported.snaps")
        self.assertIn("mycoolsnap", supported)

        all_ = self.parseOutput("all.snaps")
        self.assertIn("mycoolsnap", all_)

        debs = self.parseOutput("supported")
        self.assertNotIn("mycoolsnap", debs)

    def test_classic_snap(self):
        # Need Packages
        self.addSource("warty", "main", "hello", "1.0-1",
                       ["hello", "hello-dependency"])
        self.addPackage("warty", "main", "i386", "hello-dependency", "1.0-1",
                        fields={"Source": "hello"})
        self.addSeed("ubuntu.warty", "supported")
        self.addSeedSnap("ubuntu.warty", "supported", "mycoolsnap/classic")
        self.runGerminate("-s", "ubuntu.warty", "-d", "warty", "-c", "main")

        supported = self.parseOutput("supported.snaps")
        self.assertIn("mycoolsnap (classic)", supported)

        all_ = self.parseOutput("all.snaps")
        self.assertIn("mycoolsnap (classic)", all_)

        debs = self.parseOutput("supported")
        self.assertNotIn("mycoolsnap (classic)", debs)
