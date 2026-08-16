"""Unit tests for germinate.seeds."""

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

import errno
import io
import os
import random
import socket
import textwrap
import threading

from fixtures import MockPatch

from germinate.seeds import (
    AtomicFile,
    Seed,
    SeedError,
    SingleSeedStructure,
    )
from germinate.tests.helpers import TestCase


class TestAtomicFile(TestCase):
    def test_creates_file(self):
        """AtomicFile creates the named file with the requested contents."""
        self.useTempDir()
        with AtomicFile("foo") as test:
            test.write("string")
        with open("foo") as handle:
            self.assertEqual("string", handle.read())

    def test_removes_dot_new(self):
        """AtomicFile does not leave .new files lying around."""
        self.useTempDir()
        with AtomicFile("foo"):
            pass
        self.assertFalse(os.path.exists("foo.new"))


class TestSeed(TestCase):
    def setUp(self):
        super(TestSeed, self).setUp()
        self.addSeed("collection.dist", "test")
        self.addSeedPackage("collection.dist", "test", "foo")
        self.addSeed("collection.dist", "test2")
        self.addSeedPackage("collection.dist", "test2", "foo")
        self.addSeed("collection.dist", "test3")
        self.addSeedPackage("collection.dist", "test3", "bar")
        self.addSeedSnap("collection.dist", "test3", "quux")

    def test_init_no_vcs(self):
        """__init__ can open a seed from a collection without a VCS."""
        seed = Seed(
            ["file://%s" % self.seeds_dir], ["collection.dist"], "test")
        self.assertEqual("test", seed.name)
        self.assertEqual("file://%s" % self.seeds_dir, seed.base)
        self.assertEqual("collection.dist", seed.branch)
        self.assertEqual(" * foo\n", seed.text)

    def test_init_no_vcs_snap(self):
        """__init__ can open a seed from a collection without a VCS."""
        seed = Seed(
            ["file://%s" % self.seeds_dir], ["collection.dist"], "test3")
        self.assertEqual("test3", seed.name)
        self.assertEqual("file://%s" % self.seeds_dir, seed.base)
        self.assertEqual("collection.dist", seed.branch)
        self.assertEqual(" * bar\n * snap:quux\n", seed.text)

    def test_behaves_as_file(self):
        """A Seed context can be read from as a file object."""
        seed = Seed(
            ["file://%s" % self.seeds_dir], ["collection.dist"], "test")
        with seed as seed_file:
            lines = list(seed_file)
            self.assertTrue(1, len(lines))
            self.assertTrue(" * foo\n", lines[0])

    def test_equal_if_same_contents(self):
        """Two Seed objects with the same text contents are equal."""
        one = Seed(
            ["file://%s" % self.seeds_dir], ["collection.dist"], "test")
        two = Seed(
            ["file://%s" % self.seeds_dir], ["collection.dist"], "test2")
        self.assertEqual(one, two)

    def test_not_equal_if_different_contents(self):
        """Two Seed objects with different text contents are not equal."""
        one = Seed(
            ["file://%s" % self.seeds_dir], ["collection.dist"], "test")
        three = Seed(
            ["file://%s" % self.seeds_dir], ["collection.dist"], "test3")
        self.assertNotEqual(one, three)

    def test_open_without_scheme(self):
        """A Seed can be opened from a relative path on the filesystem."""
        seed = Seed([self.seeds_dir], ["collection.dist"], "test")
        with seed as seed_file:
            lines = list(seed_file)
            self.assertTrue(1, len(lines))
            self.assertTrue(" * foo\n", lines[0])


class TestSeedHTTP(TestCase):
    def setUp(self):
        """ Make a server which reads anything you send it but never responds
        to you, to test timeouts are triggered properly. """
        super(TestSeedHTTP, self).setUp()
        self.n_hits = 0
        self.server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        while True:
            try:
                self.port = random.randint(1025, 65535)
                self.server.bind(("localhost", self.port))
                break
            except OSError as e:
                if e.errno != errno.EADDRINUSE:
                    raise
        self.server.listen(1)

        def accept():
            while self.server is not None:
                try:
                    (client, _) = self.server.accept()
                    self.n_hits += 1
                except (OSError, socket.error) as e:
                    if e.errno in (errno.EBADF, errno.EINVAL):  # closed
                        return
                    raise
                # We'll read the HTTP request, not reply and the caller should
                # eventually timeout
                while True:
                    if not client.recv(1024):
                        break
                client.close()

        self.thread = threading.Thread(target=accept)
        self.thread.start()

    def tearDown(self):
        self.server.shutdown(socket.SHUT_RDWR)
        self.server.close()
        self.server = None
        self.thread.join()
        super(TestSeedHTTP, self).tearDown()

    def test_init_http_timeout(self):
        """ When we connect to a server which doesn't respond, we timeout. """
        fixture = MockPatch("germinate.seeds.Seed._retry_timeout", 0.1)
        with fixture:
            try:
                Seed(
                    ["http://localhost:%s" % self.port],
                    ["collection.dist"],
                    "test")
            except SeedError:
                self.assertEqual(self.n_hits, 5)
                return
            self.assertFalse(True, "SeedError was not raised")


class TestSingleSeedStructure(TestCase):
    def test_basic(self):
        """A SingleSeedStructure object has the correct basic properties."""
        branch = "collection.dist"
        self.addSeed(branch, "base")
        self.addSeed(branch, "desktop", parents=["base"])
        seed = Seed(["file://%s" % self.seeds_dir], branch, "STRUCTURE")
        with seed as seed_file:
            structure = SingleSeedStructure(branch, seed_file)
        self.assertEqual(["base", "desktop"], structure.seed_order)
        self.assertEqual({"base": [], "desktop": ["base"]}, structure.inherit)
        self.assertEqual([branch], structure.branches)
        self.assertEqual(["base:", "desktop: base"], structure.lines)
        self.assertEqual(set(), structure.features)

    def test_include(self):
        """SingleSeedStructure parses the "include" directive correctly."""
        branch = "collection.dist"
        self.addStructureLine(branch, "include other.dist")
        seed = Seed(["file://%s" % self.seeds_dir], branch, "STRUCTURE")
        with seed as seed_file:
            structure = SingleSeedStructure(branch, seed_file)
        self.assertEqual([branch, "other.dist"], structure.branches)

    def test_feature(self):
        """SingleSeedStructure parses the "feature" directive correctly."""
        branch = "collection.dist"
        self.addStructureLine(branch, "feature follow-recommends")
        seed = Seed(["file://%s" % self.seeds_dir], branch, "STRUCTURE")
        with seed as seed_file:
            structure = SingleSeedStructure(branch, seed_file)
        self.assertEqual(set(["follow-recommends"]), structure.features)


class TestSeedStructure(TestCase):
    def test_basic(self):
        """A SeedStructure object has the correct basic properties."""
        branch = "collection.dist"
        self.addSeed(branch, "base")
        self.addSeedPackage(branch, "base", "base-package")
        self.addSeed(branch, "desktop", parents=["base"])
        self.addSeedPackage(branch, "desktop", "desktop-package")
        structure = self.openSeedStructure(branch)
        self.assertEqual(branch, structure.branch)
        self.assertEqual(set(), structure.features)
        self.assertEqual("desktop", structure.supported)
        self.assertEqual(["base", "desktop"], structure.names)
        self.assertEqual({"base": [], "desktop": ["base"]}, structure._inherit)

    def test_dict(self):
        """A SeedStructure can be treated as a dictionary of seeds."""
        branch = "collection.dist"
        self.addSeed(branch, "base")
        self.addSeedPackage(branch, "base", "base-package")
        structure = self.openSeedStructure(branch)
        self.assertEqual(1, len(structure))
        self.assertEqual(["base"], list(structure))
        self.assertEqual("base", structure["base"].name)
        self.assertEqual(" * base-package\n", structure["base"].text)

    def test_multiple(self):
        """SeedStructure follows "include" links to other seed collections."""
        one = "one.dist"
        two = "two.dist"
        self.addSeed(one, "base")
        self.addSeedPackage(one, "base", "base-package")
        self.addStructureLine(two, "include one.dist")
        self.addSeed(two, "desktop")
        self.addSeedPackage(two, "desktop", "desktop-package")
        structure = self.openSeedStructure(two)
        self.assertEqual(two, structure.branch)
        self.assertEqual(one, structure["base"].branch)
        self.assertEqual(" * base-package\n", structure["base"].text)
        self.assertEqual(two, structure["desktop"].branch)
        self.assertEqual(" * desktop-package\n", structure["desktop"].text)

    def test_later_branches_override_earlier_branches(self):
        """Seeds from later branches override seeds from earlier branches."""
        one = "one.dist"
        two = "two.dist"
        self.addSeed(one, "base")
        self.addSeedPackage(one, "base", "base-package")
        self.addSeed(one, "desktop")
        self.addSeedPackage(one, "desktop", "desktop-package-one")
        self.addStructureLine(two, "include one.dist")
        self.addSeed(two, "desktop")
        self.addSeedPackage(two, "desktop", "desktop-package-two")
        structure = self.openSeedStructure(two)
        self.assertEqual(["base", "desktop"], sorted(structure))
        self.assertEqual(" * desktop-package-two\n", structure["desktop"].text)

    def test_limit(self):
        """SeedStructure.limit restricts the set of seed names."""
        branch = "collection.dist"
        self.addSeed(branch, "one")
        self.addSeedPackage(branch, "one", "one")
        self.addSeed(branch, "two", parents=["one"])
        self.addSeedPackage(branch, "two", "two")
        self.addSeed(branch, "three")
        self.addSeedPackage(branch, "three", "three")
        self.addSeed(branch, "four")
        self.addSeedPackage(branch, "four", "four")
        structure = self.openSeedStructure(branch)
        self.assertEqual(
            sorted(["one", "two", "three", "four"]), sorted(structure.names))
        structure.limit(["two", "three"])
        self.assertEqual(
            sorted(["one", "two", "three"]), sorted(structure.names))

    def test_add(self):
        """SeedStructure.add adds a custom seed."""
        branch = "collection.dist"
        self.addSeed(branch, "base")
        self.addSeedPackage(branch, "base", "base")
        structure = self.openSeedStructure(branch)
        structure.add("custom", [" * custom-one", " * custom-two"], "base")
        self.assertIn("custom", structure)
        self.assertIn("custom", structure.names)
        self.assertIn("custom", structure._inherit)
        self.assertEqual(["base"], structure._inherit["custom"])
        self.assertEqual("custom", structure["custom"].name)
        self.assertIsNone(structure["custom"].base)
        self.assertIsNone(structure["custom"].branch)
        self.assertEqual(
            " * custom-one\n * custom-two\n", structure["custom"].text)

    def test_write(self):
        """SeedStructure.write writes the text of STRUCTURE."""
        branch = "collection.dist"
        self.addSeed(branch, "one")
        self.addSeedPackage(branch, "one", "one")
        self.addSeed(branch, "two", parents=["one"])
        self.addSeedPackage(branch, "two", "two")
        structure = self.openSeedStructure(branch)
        structure.write("structure")
        with open("structure") as structure_file:
            self.assertEqual("one:\ntwo: one\n", structure_file.read())

    def test_write_dot(self):
        """SeedStructure.write_dot writes an appropriate dot file."""
        branch = "collection.dist"
        self.addSeed(branch, "one")
        self.addSeedPackage(branch, "one", "one")
        self.addSeed(branch, "two", parents=["one"])
        self.addSeedPackage(branch, "two", "two")
        structure = self.openSeedStructure(branch)
        structure.write_dot("structure.dot")
        with open("structure.dot") as structure_dot_file:
            self.assertEqual(textwrap.dedent("""\
                digraph structure {
                    node [color=lightblue2, style=filled];
                    "one" -> "two";
                }
                """), structure_dot_file.read())

    def test_write_seed_text(self):
        """SeedStructure.write_seed_text writes the text of a seed."""
        branch = "collection.dist"
        self.addSeed(branch, "one")
        self.addSeedPackage(branch, "one", "one-package")
        self.addSeed(branch, "two")
        self.addSeedPackage(branch, "two", "two-package")
        structure = self.openSeedStructure(branch)
        structure.write_seed_text("one.seedtext", "one")
        with open("one.seedtext") as seed_file:
            self.assertEqual(" * one-package\n", seed_file.read())

    def test_write_seed_text_utf8(self):
        """SeedStructure.write_seed_text handles UTF-8 text in seeds."""
        branch = "collection.dist"
        self.addSeed(branch, "base")
        self.addSeedPackage(branch, "base", u"base # \u00e4\u00f6\u00fc")
        structure = self.openSeedStructure(branch)
        structure.write_seed_text("base.seedtext", "base")
        with io.open("base.seedtext", encoding="UTF-8") as seed_file:
            self.assertEqual(
                u" * base # \u00e4\u00f6\u00fc\n", seed_file.read())
