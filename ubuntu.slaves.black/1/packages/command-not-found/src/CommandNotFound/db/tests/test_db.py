#!/usr/bin/python

import os
import shutil
import tempfile
import unittest

import logging
logging.basicConfig(level=logging.DEBUG)

from CommandNotFound.db.creator import DbCreator
from CommandNotFound.db.db import SqliteDatabase

mock_commands_bionic_backports = """suite: bionic-backports
component: main
arch: all

name: bsdutils
version: 99.0
commands: script,wall,new-stuff-only-in-backports
"""

mock_commands_bionic_proposed = """suite: bionic-proposed
component: main
arch: all

name: bsdutils
version: 2.0
commands: script,wall
"""

mock_commands_bionic = """suite: bionic
component: main
arch: all

name: bsdutils
version: 1.0
commands: script,wall,removed-in-version-2.0

name: bzr1
version: 1.0
commands: bzr

name: bzr2
version: 2.7
commands: bzr

name: aaa-openjre-7
version: 7
commands: java

name: default-jre
version: 8
priority-bonus: 5
commands: java

name: python2.7-minimal
visible-pkgname: python2.7
version: 2.7
commands: python2.7

name: foo
version: 3.0
commands: foo-cmd,ignore-me
ignore-commands: ignore-me
"""

mock_commands_bionic_universe = """suite: bionic
component: universe
arch: all


name: bzr-tng
version: 3.0
commands: bzr
"""

class DbTestCase(unittest.TestCase):

    def setUp(self):
        self.tmpdir = tempfile.mkdtemp()

    def tearDown(self):
        shutil.rmtree(self.tmpdir)

    def make_mock_commands_file(self, suite, content):
        path = os.path.join(self.tmpdir, "var", "lib", "apt", "lists", "archive.ubuntu.com_ubuntu_dists_%s_Commands-all" % suite)
        try:
            os.makedirs(os.path.dirname(path))
        except OSError:
            pass
        with open(path, "w") as fp:
            fp.write(content)
        return path
        
    def test_create_trivial_db(self):
        mock_commands_file = self.make_mock_commands_file(
            "bionic_main", mock_commands_bionic)
        cre = DbCreator([mock_commands_file])
        dbpath = os.path.join(self.tmpdir, "test.db")
        cre.create(dbpath)
        # validate content
        db = SqliteDatabase(dbpath)
        self.assertEqual(
            db.lookup("wall"), [("bsdutils", "1.0", "main")])
        self.assertEqual(
            db.lookup("removed-in-version-2.0"), [("bsdutils", "1.0", "main")])

    def test_create_multiple_dbs(self):
        mock_commands_1 = self.make_mock_commands_file(
            "bionic_main", mock_commands_bionic)
        mock_commands_2 = self.make_mock_commands_file(
            "bionic-proposed_main", mock_commands_bionic_proposed)
        cre = DbCreator([mock_commands_1, mock_commands_2])
        dbpath = os.path.join(self.tmpdir, "test.db")
        cre.create(dbpath)
        # validate content
        db = SqliteDatabase(dbpath)
        # newer version 2.0 ovrride older version 1.0
        self.assertEqual(
            db.lookup("wall"), [("bsdutils", "2.0", "main")])
        # binaries from older versions do not linger around
        self.assertEqual(
            db.lookup("removed-in-version-2.0"), [])
        # versions only from a single file are available
        self.assertEqual(
            db.lookup("bzr"), [
                ("bzr1", "1.0", "main"),
                ("bzr2", "2.7", "main"),
            ])

    def test_create_backports_excluded_dbs(self):
        mock_commands_1 = self.make_mock_commands_file(
            "bionic_main", mock_commands_bionic)
        mock_commands_2 = self.make_mock_commands_file(
            "bionic-backports_main", mock_commands_bionic_backports)
        cre = DbCreator([mock_commands_1, mock_commands_2])
        dbpath = os.path.join(self.tmpdir, "test.db")
        cre.create(dbpath)
        # validate content
        db = SqliteDatabase(dbpath)
        self.assertEqual(
            db.lookup("wall"), [("bsdutils", "1.0", "main")])
        self.assertEqual(
            db.lookup("new-stuff-only-in-backports"), [])

    def test_create_no_versions_does_not_crash(self):
        mock_commands = self.make_mock_commands_file(
            "bionic_main", mock_commands_bionic.replace("version: 1.0\n", ""))
        cre = DbCreator([mock_commands])
        dbpath = os.path.join(self.tmpdir, "test.db")
        cre.create(dbpath)
        # validate content
        db = SqliteDatabase(dbpath)
        self.assertEqual(
            db.lookup("wall"), [("bsdutils", "", "main")])
        
    def test_create_priorities_work(self):
        mock_commands_1 = self.make_mock_commands_file(
            "bionic_main", mock_commands_bionic)
        mock_commands_2 = self.make_mock_commands_file(
            "bionic_universe", mock_commands_bionic_universe)
        self.assertNotEqual(mock_commands_1, mock_commands_2)
        cre = DbCreator([mock_commands_1, mock_commands_2])
        dbpath = os.path.join(self.tmpdir, "test.db")
        cre.create(dbpath)
        # validate content
        db = SqliteDatabase(dbpath)
        for i in range(100):
            # ensure that we always sort "main" before universe"
            # and that the same component is sorted alphabetically
            self.assertEqual(
                db.lookup("bzr"), [
                    ("bzr1", "1.0", "main"),
                    ("bzr2", "2.7", "main"),
                    ("bzr-tng", "3.0", "universe"),
                ])

    def test_priorities_bonus_works(self):
        mock_commands_1 = self.make_mock_commands_file(
            "bionic_main", mock_commands_bionic)
        cre = DbCreator([mock_commands_1])
        dbpath = os.path.join(self.tmpdir, "test.db")
        cre.create(dbpath)
        # validate content
        db = SqliteDatabase(dbpath)
        for i in range(100):
            self.assertEqual(
                db.lookup("java"), [
                    ("default-jre", "8", "main"),
                    ("aaa-openjre-7", "7", "main"),
                ])

    def test_visible_pkgname_works(self):
        mock_commands_1 = self.make_mock_commands_file(
            "bionic_main", mock_commands_bionic)
        cre = DbCreator([mock_commands_1])
        dbpath = os.path.join(self.tmpdir, "test.db")
        cre.create(dbpath)
        # validate content
        db = SqliteDatabase(dbpath)
        for i in range(100):
            self.assertEqual(
                db.lookup("python2.7"), [("python2.7", "2.7", "main")])

    def test_create_multiple_no_unneeded_creates(self):
        mock_commands_1 = self.make_mock_commands_file(
            "bionic_main", mock_commands_bionic)
        mock_commands_2 = self.make_mock_commands_file(
            "bionic-proposed_main", mock_commands_bionic_proposed)
        cre = DbCreator([mock_commands_1, mock_commands_2])
        dbpath = os.path.join(self.tmpdir, "test.db")
        cre.create(dbpath)
        # ensure the metadata file was created
        self.assertTrue(os.path.exists(dbpath+".metadata"))
        # ensure the caching works and the db is not created twice
        st = os.stat(dbpath)
        cre.create(dbpath)
        self.assertEqual(st.st_mtime, os.stat(dbpath).st_mtime)

    def test_create_honors_ignore_comamnds(self):
        mock_commands_file = self.make_mock_commands_file(
            "bionic_main", mock_commands_bionic)
        cre = DbCreator([mock_commands_file])
        dbpath = os.path.join(self.tmpdir, "test.db")
        cre.create(dbpath)
        # validate content
        db = SqliteDatabase(dbpath)
        # ignore-commands is correctly handled
        self.assertEqual(
            db.lookup("foo-cmd"), [("foo", "3.0", "main")])
        self.assertEqual(db.lookup("igore-me"), [])
