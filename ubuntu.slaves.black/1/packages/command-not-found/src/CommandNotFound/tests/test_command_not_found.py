#!/usr/bin/python

import json
#import logging
#logging.basicConfig(level=logging.DEBUG)
import os
import shutil
import tempfile
import unittest

import CommandNotFound.CommandNotFound as CommandNotFound_Module
from CommandNotFound.CommandNotFound import (
    CommandNotFound,
    SqliteDatabase,
)
from CommandNotFound.db.creator import DbCreator

test_specs = [
"""
test: single snap advise
snaps: spotify/1.0:x-spotify
with: x-spotify
Command 'x-spotify' not found, but can be installed with:
sudo snap install spotify
""",
"""
test: mixed advise, single snap
debs: aws/1.0:x-aws,other-cmd
snaps: aws-cli/2.0:x-aws
with: x-aws
Command 'x-aws' not found, but can be installed with:
sudo snap install aws-cli  # version 2.0, or
sudo apt  install aws      # version 1.0
See 'snap info aws-cli' for additional versions.
""",
"""
test: mixed advise, multi-snap
debs: aws/1.0:x-aws,other-cmd
snaps: aws-cli/2.0:x-aws;aws-cli-compat/0.1:x-aws
with: x-aws
Command 'x-aws' not found, but can be installed with:
sudo snap install aws-cli         # version 2.0, or
sudo snap install aws-cli-compat  # version 0.1
sudo apt  install aws             # version 1.0
See 'snap info <snapname>' for additional versions.
""",
"""
test: single advise deb
debs: pylint/1.0:x-pylint
with: x-pylint
Command 'x-pylint' not found, but can be installed with:
sudo apt install pylint
""",
"""
test: multi advise debs
debs: vim/1.0:x-vi;neovim/2.0:x-vi
with: x-vi
Command 'x-vi' not found, but can be installed with:
sudo apt install vim     # version 1.0, or
sudo apt install neovim  # version 2.0
""",
"""
test: fuzzy advise debs only
debs: vim/1.0:x-vi;neovim/2.0:x-vi
with: x-via
Command 'x-via' not found, did you mean:
  command 'x-vi' from deb vim (1.0)
  command 'x-vi' from deb neovim (2.0)
Try: sudo apt install <deb name>
""",
"""
test: single advise snaps
snaps: spotify/1.0:x-spotify
with: x-spotify
Command 'x-spotify' not found, but can be installed with:
sudo snap install spotify
""",
"""
test: multi advise snaps
snaps: foo1/1.0:x-foo;foo2/2.0:x-foo
with: x-foo
Command 'x-foo' not found, but can be installed with:
sudo snap install foo1  # version 1.0, or
sudo snap install foo2  # version 2.0
See 'snap info <snapname>' for additional versions.
""",
"""
test: mixed fuzzy advise
debs: aws/1.0:x-aws,other-cmd
snaps: aws-cli/2.0:x-aws
with: x-awsX
Command 'x-awsX' not found, did you mean:
  command 'x-aws' from snap aws-cli (2.0)
  command 'x-aws' from deb aws (1.0)
See 'snap info <snapname>' for additional versions.
""",
"""
test: many mispellings just prints a summary
debs: lsa/1.0:lsa;lsb/1.0:lsb;lsc/1.0:lsc;lsd/1.0:lsd;lsd/1.0:lsd;lse/1.0:lse;lsf/1.0:lsf;lsg/1.0:lsg;lse/1.0:lsh;lse/1.0:lsh;lsi/1.0:lsi;lsj/1.0:lsj;lsk/1.0:lsk;lsl/1.0:lsl;lsm/1.0:lsm;lsn/1.0:lsn;lso/1.0:lso
with: lsx
Command 'lsx' not found, but there are 17 similar ones.
""",
]
        

class MockAptDB:
    def __init__(self):
        self._db = {}
    def lookup(self, command):
        return self._db.get(command, [])

   
class CommandNotFoundOutputTest(unittest.TestCase):

    def setUp(self):
        self.tmpdir = tempfile.mkdtemp()
        self.mock_db()
        self.cnf = CommandNotFound()
        self.cnf.snap_cmd = os.path.join(self.tmpdir, "mock-snap-cmd-%i")
        # FIXME: add this to the test spec to test the outputs for uid=0/1000
        #        and for sudo/no-sudo
        self.cnf.euid = 1000
        self.cnf.user_can_sudo = True

    def tearDown(self):
        shutil.rmtree(self.tmpdir)

    def mock_db(self):
        """Create an empty database and point c-n-f to it."""
        self.tmpdir = tempfile.mkdtemp()
        mock_commands_file = os.path.join(self.tmpdir, "Commands-all")
        with open(mock_commands_file, "w"):
            pass
        col = DbCreator([mock_commands_file])
        col.create(os.path.join(self.tmpdir, "test.db"))
        CommandNotFound_Module.dbpath = os.path.join(self.tmpdir, "test.db")

    def set_mock_snap_cmd_json(self, json):
        with open(self.cnf.snap_cmd, "w") as fp:
            fp.write("""#!/bin/sh
set -e

echo '%s'
""" % json)
        os.chmod(self.cnf.snap_cmd, 0o755)

    def test_from_table(self):
        for i, spec in enumerate(test_specs):
            self._test_spec(spec)
        
    def _test_spec(self, spec):
        # setup
        self.cnf.db = MockAptDB()
        self.set_mock_snap_cmd_json(json.dumps([]))
        self.cnf.output_fd = open(os.path.join(self.tmpdir, "output"), "w")
        # read spec
        lines = spec.split("\n")
        test = "unkown test"
        for i, line in enumerate(lines):
            if line.startswith("debs: "):
                debs = line[len("debs: "):].split(";")
                for deb in debs:
                    l = deb.split(":")
                    name, ver = l[0].split("/")
                    cmds = l[1].split(",")
                    for cmd in cmds:
                        if not cmd in self.cnf.db._db:
                            self.cnf.db._db[cmd] = []
                        self.cnf.db._db[cmd].append( (name, ver, "main") )
            if line.startswith("snaps: "):
                snaps = line[len("snaps: "):].split(";")
                mock_json = []
                for snap in snaps:
                    l = snap.split(":")
                    name, ver = l[0].split("/")
                    cmds = l[1].split(",")
                    for cmd in cmds:
                        mock_json.append({"Snap": name, "Command": cmd, "Version": ver})
                self.set_mock_snap_cmd_json(json.dumps(mock_json))
            if line.startswith("test: "):
                test = line[len("test: "):]
            if line.startswith("with: "):
                cmd = line[len("with: "):]
                break
        expected_output = "\n".join(lines[i+1:])
        # run test
        self.cnf.advise(cmd)
        # validate
        with open(self.cnf.output_fd.name) as fp:
            output = fp.read()
        self.assertEqual(output, expected_output, "test '%s' broken" % test)
        # cleanup
        self.cnf.output_fd.close()
        

class RegressionTestCase(unittest.TestCase):

    def test_lp1130444(self):
        tmpdir = tempfile.mkdtemp()
        self.addCleanup(shutil.rmtree, tmpdir)

        mock_commands_file = os.path.join(tmpdir, "Commands-all")
        with open(mock_commands_file, "w"):
            pass
        col = DbCreator([mock_commands_file])
        col.create(os.path.join(tmpdir, "test.db"))
        db = SqliteDatabase(os.path.join(tmpdir, "test.db"))
        self.assertEqual(db.lookup("foo\udcb6"), [])
