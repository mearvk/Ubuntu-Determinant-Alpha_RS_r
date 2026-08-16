# -*- coding: utf-8 -*-
"""Unit tests for germinate.archive."""

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

import bz2
import gzip
import os
import subprocess
import textwrap

from germinate.archive import IndexType, TagFile
from germinate.tests.helpers import TestCase


class TestTagFile(TestCase):
    def test_init_lists(self):
        """TagFile may be constructed with list parameters."""
        tagfile = TagFile(
            ["dist"], ["component"], "arch", ["mirror"],
            source_mirrors=["source_mirror"])
        self.assertEqual(["dist"], tagfile._dists)
        self.assertEqual(["component"], tagfile._components)
        self.assertEqual(["mirror"], tagfile._mirrors)
        self.assertEqual(["source_mirror"], tagfile._source_mirrors)

    def test_init_strings(self):
        """TagFile may be constructed with string parameters."""
        tagfile = TagFile(
            "dist", "component", "arch", "mirror",
            source_mirrors="source_mirror")
        self.assertEqual(["dist"], tagfile._dists)
        self.assertEqual(["component"], tagfile._components)
        self.assertEqual(["mirror"], tagfile._mirrors)
        self.assertEqual(["source_mirror"], tagfile._source_mirrors)

    def test_sections_gzip(self):
        """Test fetching sections from a basic TagFile archive using gzip."""
        self.useTempDir()
        main_dir = os.path.join("mirror", "dists", "unstable", "main")
        binary_dir = os.path.join(main_dir, "binary-i386")
        source_dir = os.path.join(main_dir, "source")
        os.makedirs(binary_dir)
        os.makedirs(source_dir)
        with gzip.GzipFile(
                os.path.join(binary_dir, "Packages.gz"), "wb") as packages:
            packages.write(textwrap.dedent(u"""\
                Package: test
                Version: 1.0
                Architecture: i386
                Maintainer: úḃúñŧů đəvẽłõṗèŗṡ

                """).encode("UTF-8"))
        with gzip.GzipFile(
                os.path.join(source_dir, "Sources.gz"), "wb") as sources:
            sources.write(textwrap.dedent("""\
                Source: test
                Version: 1.0

                """).encode("UTF-8"))

        tagfile = TagFile(
            "unstable", "main", "i386", "file://%s/mirror" % self.temp_dir)
        sections = list(tagfile.sections())
        self.assertEqual(IndexType.PACKAGES, sections[0][0])
        self.assertEqual("test", sections[0][1]["Package"])
        self.assertEqual("1.0", sections[0][1]["Version"])
        self.assertEqual("i386", sections[0][1]["Architecture"])
        self.assertEqual(IndexType.SOURCES, sections[1][0])
        self.assertEqual("test", sections[1][1]["Source"])
        self.assertEqual("1.0", sections[1][1]["Version"])

    def test_sections_bzip2(self):
        """Test fetching sections from a basic TagFile archive using bzip2."""
        self.useTempDir()
        main_dir = os.path.join("mirror", "dists", "unstable", "main")
        binary_dir = os.path.join(main_dir, "binary-i386")
        source_dir = os.path.join(main_dir, "source")
        os.makedirs(binary_dir)
        os.makedirs(source_dir)
        with bz2.BZ2File(
                os.path.join(binary_dir, "Packages.bz2"), "wb") as packages:
            packages.write(textwrap.dedent(u"""\
                Package: test
                Version: 1.0
                Architecture: i386
                Maintainer: úḃúñŧů đəvẽłõṗèŗṡ

                """).encode("UTF-8"))
        with bz2.BZ2File(
                os.path.join(source_dir, "Sources.bz2"), "wb") as sources:
            sources.write(textwrap.dedent("""\
                Source: test
                Version: 1.0

                """).encode("UTF-8"))

        tagfile = TagFile(
            "unstable", "main", "i386", "file://%s/mirror" % self.temp_dir)
        sections = list(tagfile.sections())
        self.assertEqual(IndexType.PACKAGES, sections[0][0])
        self.assertEqual("test", sections[0][1]["Package"])
        self.assertEqual("1.0", sections[0][1]["Version"])
        self.assertEqual("i386", sections[0][1]["Architecture"])
        self.assertEqual(IndexType.SOURCES, sections[1][0])
        self.assertEqual("test", sections[1][1]["Source"])
        self.assertEqual("1.0", sections[1][1]["Version"])

    def test_sections_xz(self):
        """Test fetching sections from a basic TagFile archive using xz."""
        self.useTempDir()
        main_dir = os.path.join("mirror", "dists", "unstable", "main")
        binary_dir = os.path.join(main_dir, "binary-i386")
        source_dir = os.path.join(main_dir, "source")
        os.makedirs(binary_dir)
        os.makedirs(source_dir)
        with open(os.path.join(binary_dir, "Packages"), "wb") as packages:
            packages.write(textwrap.dedent(u"""\
                Package: test
                Version: 1.0
                Architecture: i386
                Maintainer: úḃúñŧů đəvẽłõṗèŗṡ

                """).encode("UTF-8"))
        subprocess.check_call(["xz", os.path.join(binary_dir, "Packages")])
        with open(os.path.join(source_dir, "Sources"), "wb") as sources:
            sources.write(textwrap.dedent("""\
                Source: test
                Version: 1.0

                """).encode("UTF-8"))
        subprocess.check_call(["xz", os.path.join(source_dir, "Sources")])

        tagfile = TagFile(
            "unstable", "main", "i386", "file://%s/mirror" % self.temp_dir)
        sections = list(tagfile.sections())
        self.assertEqual(IndexType.PACKAGES, sections[0][0])
        self.assertEqual("test", sections[0][1]["Package"])
        self.assertEqual("1.0", sections[0][1]["Version"])
        self.assertEqual("i386", sections[0][1]["Architecture"])
        self.assertEqual(IndexType.SOURCES, sections[1][0])
        self.assertEqual("test", sections[1][1]["Source"])
        self.assertEqual("1.0", sections[1][1]["Version"])
