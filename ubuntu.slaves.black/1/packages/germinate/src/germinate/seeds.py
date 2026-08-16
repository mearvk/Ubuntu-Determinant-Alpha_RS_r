# -*- coding: utf-8 -*-
"""Fetch seeds from a URL collection or from a VCS."""

# Copyright (c) 2004, 2005, 2006, 2008, 2009, 2011, 2012 Canonical Ltd.
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

import atexit
import codecs
import io
import logging
import os
import re
import shutil
import socket
import subprocess
import sys
import tempfile

import six
from six.moves.collections_abc import Mapping
from six.moves.urllib.error import URLError
from six.moves.urllib.parse import urljoin, urlparse
from six.moves.urllib.request import Request, urlopen

import germinate.defaults
from germinate.tsort import topo_sort


__all__ = [
    'Seed',
    'SeedError',
    'SeedStructure',
    'SeedVcs',
]


_logger = logging.getLogger(__name__)


_vcs_cache_dir = None


class AtomicFile(object):
    """Facilitate atomic writing of files.  Forces UTF-8 encoding."""

    def __init__(self, filename):
        self.filename = filename
        if sys.version_info[0] < 3:
            self.fd = codecs.open(
                '%s.new' % self.filename, 'w', 'UTF-8', 'replace')
        else:
            # io.open is available from Python 2.6, but we only use it with
            # Python 3 because it raises exceptions when passed bytes.
            self.fd = io.open(
                '%s.new' % self.filename, mode='w',
                encoding='UTF-8', errors='replace')

    def __enter__(self):
        return self.fd

    def __exit__(self, exc_type, unused_exc_value, unused_exc_tb):
        self.fd.close()
        if exc_type is None:
            os.rename('%s.new' % self.filename, self.filename)


class SeedError(RuntimeError):
    """An error opening or parsing a seed."""

    pass


def _ensure_unicode(s):
    if isinstance(s, six.text_type):
        return s
    else:
        return six.text_type(s, "utf8", "replace")


class SeedVcs(object):
    """Version control system to use for seeds."""

    # Detect from URL.
    AUTO = 1

    # Use Bazaar.
    BZR = 2

    # Use Git.
    GIT = 3


class Seed(six.Iterator):
    """A single seed from a collection."""
    _n_retries = 5  # how many times to try downloading a URL
    _retry_timeout = 10  # timeout between each of the above retries

    def _open_seed_bzr(self, base, branch, name):
        global _vcs_cache_dir
        if _vcs_cache_dir is None:
            _vcs_cache_dir = tempfile.mkdtemp(prefix='germinate-')
            atexit.register(
                shutil.rmtree, _vcs_cache_dir, ignore_errors=True)
        checkout = os.path.join(_vcs_cache_dir, branch)
        if not os.path.isdir(checkout):
            path = os.path.join(base, branch)
            if not path.endswith('/'):
                path += '/'
            command = ['bzr']
            # https://bugs.launchpad.net/bzr/+bug/39542
            if path.startswith('http:'):
                command.append('branch')
                _logger.info("Fetching branch of %s", path)
            else:
                command.extend(['checkout', '--lightweight'])
                _logger.info("Checking out %s", path)
            command.extend([path, checkout])
            status = subprocess.call(command)
            if status != 0:
                raise SeedError("Command failed with exit status %d:\n"
                                "  '%s'" % (status, ' '.join(command)))
        return open(os.path.join(checkout, name))

    def _open_seed_git(self, base, branch, name):
        global _vcs_cache_dir
        if _vcs_cache_dir is None:
            _vcs_cache_dir = tempfile.mkdtemp(prefix='germinate-')
            atexit.register(
                shutil.rmtree, _vcs_cache_dir, ignore_errors=True)
        checkout = os.path.join(_vcs_cache_dir, branch)
        if not os.path.isdir(checkout):
            # This is a very strange way to specify a git branch, but it's
            # hard to do better here without breaking backward-compatibility
            # in at least some of Germinate's own command-line arguments,
            # the public Python API, or "include" lines in seed STRUCTURE
            # files.
            if '.' in branch:
                repository, git_branch = branch.rsplit('.', 1)
            else:
                repository = branch
                git_branch = None
            path = os.path.join(base, repository)
            if not path.endswith('/'):
                path += '/'
            command = ['git', 'clone']
            if git_branch is not None:
                command.extend(['-b', git_branch])
                _logger.info("Cloning branch %s of %s", git_branch, path)
            else:
                _logger.info("Cloning %s", path)
            command.extend([path, checkout])
            status = subprocess.call(command)
            if status != 0:
                raise SeedError("Command failed with exit status %d:\n"
                                "  '%s'" % (status, ' '.join(command)))
        return open(os.path.join(checkout, name))

    def _open_seed_url(self, base, branch, name):
        path = os.path.join(base, branch)
        if not path.endswith('/'):
            path += '/'
        url = urljoin(path, name)
        if not urlparse(url).scheme:
            fullpath = os.path.join(path, name)
            _logger.info("Using %s", fullpath)
            return open(fullpath)
        req = Request(url)
        req.add_header('Cache-Control', 'no-cache')
        req.add_header('Pragma', 'no-cache')
        for n in reversed(range(Seed._n_retries)):  # try 5 times
            try:
                _logger.info("Downloading %s", url)
                return urlopen(req, timeout=Seed._retry_timeout)
            except socket.timeout as e:
                err = e
                if n > 0:
                    _logger.warning("Timed out opening %s, retrying...", url)

        _logger.error("Timed out opening %s, failing.", url)
        raise err

    def _open_seed(self, base, branch, name, vcs=None):
        if vcs is not None:
            if vcs == SeedVcs.AUTO:
                # Slightly dodgy auto-sensing, but if we can't tell then
                # we'll try both.
                if base.startswith('git'):
                    vcs = SeedVcs.GIT
                elif base.startswith('bzr'):
                    vcs = SeedVcs.BZR
            if vcs == SeedVcs.AUTO:
                try:
                    return self._open_seed_git(base, branch, name)
                except SeedError:
                    return self._open_seed_bzr(base, branch, name)
            elif vcs == SeedVcs.GIT:
                return self._open_seed_git(base, branch, name)
            else:
                return self._open_seed_bzr(base, branch, name)
        else:
            return self._open_seed_url(base, branch, name)

    def __init__(self, bases, branches, name, vcs=None):
        """Read a seed from a collection."""
        if isinstance(branches, six.string_types):
            branches = [branches]

        self._name = name
        self._base = None
        self._branch = None
        self._file = None

        fd = None
        ssh_host = None
        for base in bases:
            for branch in branches:
                try:
                    fd = self._open_seed(base, branch, name, vcs=vcs)
                    self._base = base
                    self._branch = branch
                    break
                except SeedError:
                    ssh_match = re.match(
                        r'(?:bzr|git)\+ssh://(?:[^/]*?@)?(.*?)(?:/|$)', base)
                    if ssh_match:
                        ssh_host = ssh_match.group(1)
                except (OSError, IOError, URLError):
                    pass
            if fd is not None:
                break

        if fd is None:
            if vcs is not None:
                _logger.warning("Could not open %s from checkout of (any of):",
                                name)
                for base in bases:
                    for branch in branches:
                        _logger.warning('  %s' % os.path.join(base, branch))

                if ssh_host is not None:
                    _logger.error("Do you need to set your user name on %s?",
                                  ssh_host)
                    _logger.error("Try a section such as this in "
                                  "~/.ssh/config:")
                    _logger.error("")
                    _logger.error("Host %s", ssh_host)
                    _logger.error("        User YOUR_USER_NAME")
            else:
                _logger.warning("Could not open (any of):")
                for base in bases:
                    for branch in branches:
                        path = os.path.join(base, branch)
                        if not path.endswith('/'):
                            path += '/'
                        _logger.warning('  %s' % urljoin(path, name))
            raise SeedError("Could not open %s" % name)

        try:
            self._text = fd.read()
            # In Python 3, we need to decode seed text read from URLs.
            if sys.version_info[0] >= 3 and isinstance(self._text, bytes):
                self._text = self._text.decode(errors="replace")
        finally:
            fd.close()

    def open(self):
        """Open a file object with the text of this seed."""
        if sys.version_info[0] < 3:
            self._file = io.BytesIO(self._text)
        else:
            self._file = io.StringIO(self._text)
        return self._file

    def read(self, *args, **kwargs):
        """Read text from this seed."""
        return self._file.read(*args, **kwargs)

    def readline(self, *args, **kwargs):
        """Read a line from this seed."""
        return self._file.readline(*args, **kwargs)

    def readlines(self, *args, **kwargs):
        """Read a list of lines from this seed."""
        return self._file.readlines(*args, **kwargs)

    def __next__(self):
        """Read the next line from this seed."""
        return next(self._file)

    def close(self):
        """Close the file object for this seed."""
        self._file.close()

    def __enter__(self):
        """Open a seed context, returning a file object."""
        return self.open()

    def __exit__(self, unused_exc_type, unused_exc_value, unused_exc_tb):
        """Close a seed context."""
        self.close()

    @property
    def name(self):
        """The seed's name."""
        return self._name

    @property
    def base(self):
        """The base URL where this seed was found."""
        return self._base

    @property
    def branch(self):
        """The name of the branch containing this seed."""
        return self._branch

    @property
    def text(self):
        """The text of this seed."""
        return self._text

    def __lt__(self, other):
        if not isinstance(other, Seed):
            return NotImplemented
        return self.text < other.text

    def __le__(self, other):
        if not isinstance(other, Seed):
            return NotImplemented
        return self.text <= other.text

    def __eq__(self, other):
        if not isinstance(other, Seed):
            return NotImplemented
        return self.text == other.text

    def __ne__(self, other):
        if not isinstance(other, Seed):
            return NotImplemented
        return self.text != other.text

    def __ge__(self, other):
        if not isinstance(other, Seed):
            return NotImplemented
        return self.text >= other.text

    def __gt__(self, other):
        if not isinstance(other, Seed):
            return NotImplemented
        return self.text > other.text

    __hash__ = None


class CustomSeed(Seed):
    """A seed created from custom input data."""

    def __init__(self, name, entries):
        self._name = name
        self._base = None
        self._branch = None
        self._text = '\n'.join(entries) + '\n'


class SingleSeedStructure(object):
    """A single seed collection structure file.

    The input data is an ordered sequence of lines as follows:

    SEED:[ INHERITED]

    INHERITED is a space-separated list of seeds from which SEED inherits.
    For example, "ship: base desktop" indicates that packages in the "ship"
    seed may depend on packages in the "base" or "desktop" seeds without
    requiring those packages to appear in the "ship" output.  INHERITED may
    be empty.

    The lines should be topologically sorted with respect to inheritance,
    with inherited-from seeds at the start.

    Any line as follows:

    include BRANCH

    causes another seed branch to be included.  Seed names will be resolved
    in included branches if they cannot be found in the current branch.

    This is for internal use; applications should use the SeedStructure
    class instead.

    """

    def __init__(self, branch, f):
        """Parse a single seed structure file."""
        self.seed_order = []
        self.inherit = {}
        self.branches = [branch]
        self.lines = []
        self.features = set()

        for line in f:
            line = line.strip()
            if not line:
                continue
            if line.startswith('#'):
                continue
            words = line.split()
            if words[0].endswith(':'):
                seed = words[0][:-1]
                if '/' in seed:
                    raise SeedError(
                        "seed name '%s' may not contain '/'" % seed)
                self.seed_order.append(seed)
                self.inherit[seed] = list(words[1:])
                self.lines.append(line)
            elif words[0] == 'include':
                self.branches.extend(words[1:])
            elif words[0] == 'feature':
                self.features.update(words[1:])
            else:
                _logger.error("Unparseable seed structure entry: %s", line)


class SeedStructure(Mapping, object):
    """The full structure of a seed collection.

    This deals with acquiring the seed structure files and recursively
    acquiring any seed structure files it includes.

    """

    def __init__(self, branch, seed_bases=None, vcs=None):
        """Open a seed collection and read all the seeds it contains."""
        if seed_bases is None:
            if vcs is None:
                seed_bases = germinate.defaults.seeds
            elif vcs == SeedVcs.GIT:
                seed_bases = germinate.defaults.seeds_git
            else:
                seed_bases = germinate.defaults.seeds_bzr
            seed_bases = seed_bases.split(',')

        self._seed_bases = seed_bases
        self._branch = branch
        self._vcs = vcs
        self._features = set()
        self._seed_order, self._inherit, branches, self._lines = \
            self._parse(self._branch, set())
        self._seeds = {}
        for seed in self._seed_order:
            self._seeds[seed] = self.make_seed(
                seed_bases, branches, seed, vcs=vcs)
        self._expand_inheritance()

    def _parse(self, branch, got_branches):
        all_seed_order = []
        all_inherit = {}
        all_branches = []
        all_structure = []

        # Fetch this one
        with self.make_seed(
                self._seed_bases, branch, "STRUCTURE", self._vcs) as seed:
            structure = SingleSeedStructure(branch, seed)
        got_branches.add(branch)

        # Recursively expand included branches
        for child_branch in structure.branches:
            if child_branch in got_branches:
                continue
            (child_seed_order, child_inherit, child_branches,
             child_structure) = self._parse(child_branch, got_branches)
            all_seed_order.extend(child_seed_order)
            all_inherit.update(child_inherit)
            for grandchild_branch in child_branches:
                if grandchild_branch not in all_branches:
                    all_branches.append(grandchild_branch)
            for child_structure_line in child_structure:
                child_structure_name = child_structure_line.split()[0][:-1]
                for i in range(len(all_structure)):
                    if (all_structure[i].split()[0][:-1] ==
                            child_structure_name):
                        del all_structure[i]
                        break
                all_structure.append(child_structure_line)

        # Attach the main branch's data to the end
        all_seed_order.extend(structure.seed_order)
        all_inherit.update(structure.inherit)
        for child_branch in structure.branches:
            if child_branch not in all_branches:
                all_branches.append(child_branch)
        for structure_line in structure.lines:
            structure_name = structure_line.split()[0][:-1]
            for i in range(len(all_structure)):
                if all_structure[i].split()[0][:-1] == structure_name:
                    del all_structure[i]
                    break
            all_structure.append(structure_line)
        self._features.update(structure.features)

        # We generally want to process branches in reverse order, so that
        # later branches can override seeds from earlier branches
        all_branches.reverse()

        return all_seed_order, all_inherit, all_branches, all_structure

    def make_seed(self, bases, branches, name, vcs=None):
        """Read a seed from this collection.

        This can be overridden by subclasses in order to read seeds in a
        different way.
        """
        return Seed(bases, branches, name, vcs=vcs)

    def _expand_inheritance(self):
        """Expand out incomplete inheritance lists."""
        self._original_inherit = dict(self._inherit)

        self._names = topo_sort(self._inherit)
        for name in self._names:
            seen = set()
            new_inherit = []
            for inheritee in self._inherit[name]:
                for expanded in self._inherit[inheritee]:
                    if expanded not in seen:
                        new_inherit.append(expanded)
                        seen.add(expanded)
                if inheritee not in seen:
                    new_inherit.append(inheritee)
                    seen.add(inheritee)
            self._inherit[name] = new_inherit

    def limit(self, seeds):
        """Restrict the seeds we care about to this list."""
        self._names = []
        for name in seeds:
            for inherit in self._inherit[name]:
                if inherit not in self._names:
                    self._names.append(inherit)
            if name not in self._names:
                self._names.append(name)

    def add(self, name, entries, parent=None):
        """Add a custom seed."""
        self._names.append(name)
        if parent is not None:
            self._inherit[name] = self._inherit[parent] + [parent]
        else:
            self._inherit[name] = [parent]
        self._seeds[name] = CustomSeed(name, entries)

    def inner_seeds(self, seedname):
        """Return this seed and the seeds from which it inherits."""
        innerseeds = list(self._inherit[seedname])
        innerseeds.append(seedname)
        return innerseeds

    def strictly_outer_seeds(self, seedname):
        """Return the seeds that inherit from this seed."""
        outerseeds = []
        for seed in self._names:
            if seedname in self._inherit[seed]:
                outerseeds.append(seed)
        return outerseeds

    def outer_seeds(self, seedname):
        """Return this seed and the seeds that inherit from it."""
        outerseeds = [seedname]
        outerseeds.extend(self.strictly_outer_seeds(seedname))
        return outerseeds

    def __iter__(self):
        """Return an iterator over the seeds in this collection."""
        return iter(self._seeds)

    def __len__(self):
        """Return the number of seeds in this collection."""
        return len(self._seeds)

    def __getitem__(self, seedname):
        """Get a particular seed from this collection."""
        return self._seeds[seedname]

    @property
    def branch(self):
        """The name of this seed collection branch."""
        return self._branch

    @property
    def features(self):
        """The feature flags set for this seed collection."""
        return set(self._features)

    @property
    def supported(self):
        """The name of the "supported" seed (the last one in the structure)."""
        return self._seed_order[-1]

    @property
    def names(self):
        """All the seed names in this collection."""
        return list(self._names)

    def write(self, filename):
        """Write the text of the seed STRUCTURE file."""
        with AtomicFile(filename) as f:
            for line in self._lines:
                print(_ensure_unicode(line), file=f)

    def write_dot(self, filename):
        """Write a dot file representing this structure."""
        with AtomicFile(filename) as dotfile:
            print("digraph structure {", file=dotfile)
            print("    node [color=lightblue2, style=filled];", file=dotfile)

            for seed in self._seed_order:
                if seed not in self._original_inherit:
                    continue
                for inherit in self._original_inherit[seed]:
                    print("    \"%s\" -> \"%s\";" % (inherit, seed),
                          file=dotfile)

            print("}", file=dotfile)

    def write_seed_text(self, filename, seedname):
        """Write the text of a seed in this collection."""
        with AtomicFile(filename) as f:
            with self._seeds[seedname] as seed:
                for line in seed:
                    print(_ensure_unicode(line.rstrip('\n')), file=f)
