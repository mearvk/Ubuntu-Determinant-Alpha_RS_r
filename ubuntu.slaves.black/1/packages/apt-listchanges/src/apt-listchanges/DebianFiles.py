# vim:set fileencoding=utf-8 et ts=4 sts=4 sw=4:
#
#   apt-listchanges - Show changelog entries between the installed versions
#                     of a set of packages and the versions contained in
#                     corresponding .deb files
#
#   Copyright (C) 2000-2006  Matt Zimmerman  <mdz@debian.org>
#   Copyright (C) 2006       Pierre Habouzit <madcoder@debian.org>
#   Copyright (C) 2016-2019  Robert Luberda  <robert@debian.org>
#
#   This program is free software; you can redistribute it and/or modify
#   it under the terms of the GNU General Public License as published by
#   the Free Software Foundation; either version 2 of the License, or
#   (at your option) any later version.
#
#   This program is distributed in the hope that it will be useful,
#   but WITHOUT ANY WARRANTY; without even the implied warranty of
#   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#   GNU General Public License for more details.
#
#   You should have received a copy of the GNU General Public License
#   along with this program; if not, write to the Free Software
#   Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA 02110-1301, USA.
#

import re
import os
import tempfile
import gzip
import errno
import glob
import shutil
import shlex
import signal
import subprocess

import apt_pkg
import ALCLog
from ALChacks import _
from functools import reduce

# TODO:
# indexed lookups by package at least, maybe by arbitrary field

def _numeric_urgency(u):
    urgency_map = { 'critical'  : 1,
                    'emergency' : 1,
                    'high'      : 2,
                    'medium'    : 3,
                    'low'       : 4 }

    return urgency_map.get(u.lower(), 99)


class ControlStanza:
    source_version_re = re.compile(r'^\S+ \((?P<version>.*)\).*')
    fields_to_read = [ 'Package', 'Source', 'Version', 'Architecture', 'Status' ]

    def __init__(self, s):
        field = None

        for line in s.split('\n'):
            if not line:
                break
            if line[0] in (' ', '\t'):
                if field:
                    setattr(self, field, getattr(self, field) + '\n' + line)
            else:
                field, value = line.split(':', 1)
                if field in self.fields_to_read:
                    setattr(self, field, value.lstrip())
                else:
                    field = None


    def source(self):
        return getattr(self, 'Source', self.Package).split(' ')[0]

    def installed(self):
        return hasattr(self, 'Status') and self.Status.split(' ')[2] == 'installed'

    def version(self):
        """
        This function returns the version of the package. One would like it to
        be the "binary" version, though we have the tough case of source
        package whose binary packages versioning scheme is different from the
        source one (see OOo, linux-source, ...).

        This code does the following, if the Source field is set with a
        specified version, then we use the binary version if and only if the
        source version is a prefix. We must do that because of binNMUs.
        """
        v = self.Version
        if hasattr(self, 'Source'):
            match = self.source_version_re.match(self.Source)
            if match:
                sv = match.group('version')
                if not v.startswith(sv):
                    return sv
        return v


class ControlParser:
    def __init__(self):
        self.stanzas = []
        self.index = {}

    def makeindex(self, field):
        self.index[field] = {}
        for stanza in self.stanzas:
            self.index[field][getattr(stanza, field)] = stanza

    def readfile(self, file):
        try:
            with open(file, encoding='utf-8', errors='replace') as f:
                self.stanzas += [ControlStanza(x) for x in f.read().split('\n\n') if x]
        except Exception as ex:
            raise RuntimeError(_("Error processing '%(what)s': %(errmsg)s") %
                                {'what': file, 'errmsg': str(ex)}) from ex

    def readdeb(self, deb):
        try:
            command = ['dpkg-deb', '-f', deb] + ControlStanza.fields_to_read
            output = subprocess.check_output(command)
            self.stanzas.append(ControlStanza(output.decode('utf-8', 'replace')))
        except Exception as ex:
            raise RuntimeError(_("Error processing '%(what)s': %(errmsg)s") %
                                {'what': deb, 'errmsg': str(ex)}) from ex

    def find(self, field, value):
        if field in self.index:
            if value in self.index[field]:
                return self.index[field][value]
            else:
                return None
        else:
            for stanza in self.stanzas:
                if hasattr(stanza, field) and getattr(stanza, field) == value:
                    return stanza
        return None

class ChangelogEntry:
    def __init__(self, header, version, urgency, binnmu = False):
        self._header = header.strip()
        self._version = version
        self._numeric_urgency = _numeric_urgency(urgency)
        self._trailer = ''
        self._content = ''
        self._binnmu = binnmu

    def set_trailer(self, trailer):
        self._trailer = trailer.rstrip()

    def add_content(self, content):
        if self._content:
            self._content += content
        elif not content.isspace():
            self._content = content

    @property
    def version(self):
        return self._version

    @property
    def numeric_urgency(self):
        return self._numeric_urgency

    @property
    def binnmu(self):
        return self._binnmu

    @property
    def header(self):
        return self._header

    @property
    def trailer(self):
        return self._trailer

    @property
    def content(self):
        return self._content.rstrip()

    def __str__(self):
        result = self.header + '\n\n' + self.content + '\n\n' + self.trailer
        if self.header and self.trailer:
            return result
        return result.strip()
    __repr__ = __str__

class Changes:
    def __init__(self, package):
        self._package = package
        self._entries = []
        self._binnmus = []
        self._numeric_urgency = _numeric_urgency('low')

    @property
    def package(self):
        return self._package

    @property
    def numeric_urgency(self):
        return self._numeric_urgency

    @property
    def entries(self):
        return self._entries

    @property
    def binnmus(self):
        return self._binnmus

    @property
    def changes(self): # for backward compatibility
        if self._entries:
            return '\n\n'.join(map(str, self._entries)) + '\n\n'
        return ''

    def save_entry(self, entry):
        if entry.binnmu:
            self._binnmus.append(entry)
        else:
            self._entries.append(entry)
            self._numeric_urgency = min(self._numeric_urgency, entry.numeric_urgency)

    def reverse(self):
        self._entries.reverse()
        self._binnmus.reverse()

class ChangelogParser:
    _changelog_header = re.compile(r'^\S+ \((?P<version>.*)\) .*;.*urgency=(?P<urgency>\w+).*')
    _changelog_header_ancient = re.compile(r'^(\S+ \(?\d.*\)|Old Changelog:|Changes|ChangeLog begins|Mon|Tue|Wed|Thu|Fri|Sat|Sun).*')
    _changelog_header_emacs = re.compile(r'(;;\s*)?Local\s+variables.*', re.IGNORECASE)
    _changelog_trailer = re.compile(r'^\s--\s.*<.*@.*>.*$')
    _binnmu_marker = 'binary-only=yes'

    def __init__(self, changes):
        self._changes = changes

    def parse(self, fd, since_version, latest):
        '''Parse changelog or news from the given file descriptor.
        If since_version is specified, only save entries later
        than the specified version.
        If latest is specified, only the latest N versions.'''
        ancient = False
        entry = None
        is_debian_changelog = False
        latest = int(latest) if latest else None

        for line in fd.readlines():
            line = line.decode('utf-8', 'replace')

            if line.startswith('#'):
                continue

            if entry is not None and (line.startswith(' ') or line == '\n'):
                if not ancient and self._changelog_trailer.match(line):
                    entry.set_trailer(line)
                else:
                    entry.add_content(line)

            else:
                match = self._changelog_header.match(line) if not ancient else None
                if match:
                    is_debian_changelog = True
                    version = match.group('version')
                    if since_version and apt_pkg.version_compare(version,
                                                                 since_version) <= 0:
                        break
                    self._save_entry(entry)
                    if latest is not None and latest <= len(self._changes.entries):
                        entry = None
                        break
                    entry = ChangelogEntry(line, version, match.group('urgency'),
                                           self._binnmu_marker in line)

                elif self._changelog_header_ancient.match(line):
                    if not is_debian_changelog: # probably upstream changelog in GNU format
                        break
                    ancient = True
                    self._save_entry(entry)
                    entry = ChangelogEntry(line, '', 'low', False)

                elif self._changelog_header_emacs.match(line):
                    break

                elif entry is not None:
                    entry.add_content(line)

                else:
                    break

        self._save_entry(entry)

        return is_debian_changelog

    def _save_entry(self, entry):
        if entry is not None:
            self._changes.save_entry(entry)

class ChangelogsReader:
    def __init__(self, source_pkg_name, rootdir, since_version, latest, reverse):
        self._source_pkg_name = source_pkg_name
        self._rootdir = rootdir
        self._since_version = since_version
        self._latest = latest
        self._reverse = reverse

    def read_changelogs(self, filenames, binnmus_filenames):
        changes = Changes(self._source_pkg_name)

        find_first = lambda acc, fname: acc or self._read_changelog(
                        os.path.join(self._rootdir, fname), changes)

        result = reduce(find_first, filenames, False)
        if binnmus_filenames:
            result = reduce(find_first, binnmus_filenames, False) or result

        if not result:
            return None # none of the files was a valid Debian changelog file

        if self._reverse:
            changes.reverse()

        return changes

    def _read_changelog(self, filename, changes):
        fd = self._open_changelog_file(filename)
        if not fd:
            return False

        with fd:
            return ChangelogParser(changes).parse(fd, self._since_version, self._latest)

    def _open_changelog_file(self, filename):
        filenames = glob.glob(filename)

        for filename in filenames:
            try:
                if os.path.isdir(filename):
                    ALCLog.error(_("Ignoring `%s' (seems to be a directory!)") % filename)
                elif filename.endswith('.gz'):
                    return gzip.GzipFile(filename)
                else:
                    return open(filename, 'rb')
                break
            except IOError as e:
                if e.errno != errno.ENOENT and e.errno != errno.ELOOP:
                    raise
        return None

class Package:
    def __init__(self, path):
        self.path = path

        parser = ControlParser()
        parser.readdeb(self.path)
        pkgdata = parser.stanzas[0]

        self.binary  = pkgdata.Package
        self.source  = pkgdata.source()
        self.Version = pkgdata.version()
        self.arch = pkgdata.Architecture

    def extract_changes(self, which, since_version, latest, reverse):
        '''Extract changelog and binnmu entries, news or both from the package.

        Unpacks changelog or news files from the binary package, and parses them.
        If since_version is specified, only return entries later than the specified version.
        If latest is specified, only the latest N versions.
        Returns a tuple of sequences of Changes objects.'''

        news_filenames = self._changelog_variations('NEWS.Debian')
        changelog_filenames = self._changelog_variations('changelog.Debian')
        changelog_filenames_binnmu = self._changelog_variations('changelog.Debian.' + self.arch)
        changelog_filenames_native = self._changelog_variations('changelog')

        filenames = []
        if which == 'both' or which == 'news':
            filenames.extend(news_filenames)
        if which == 'both' or which == 'changelogs':
            filenames.extend(changelog_filenames)
            filenames.extend(changelog_filenames_binnmu)
            filenames.extend(changelog_filenames_native)

        tempdir = self._extract_contents(filenames)
        try:
            reader = ChangelogsReader(self.source, tempdir, since_version, latest, reverse)

            news = reader.read_changelogs(news_filenames, None)

            changelog = reader.read_changelogs(changelog_filenames + changelog_filenames_native,
                                             changelog_filenames_binnmu)

        finally:
            shutil.rmtree(tempdir, 1)

        return (news, changelog)

    def extract_changes_via_apt(self, since_version, latest, reverse):
        '''Run apt-get changelog and parse the downloaded changelog.

        Retrieve changelog using the "apt-get changelog" command, and parse it.
        If since_version is specified, only return entries later than the specified version.
        If latest is specified, only the latest N versions.
        Returns a single sequence of Changes objects or None on downloading or parsing failure.'''

        # Retrieve changelog file and save it in a temporary directory
        tempdir = tempfile.mkdtemp(prefix='apt-listchanges')
        changelog_file = os.path.join(tempdir, self.binary + '.changelog')
        changelog_fd = open(changelog_file, 'w')

        try:

            command = ['apt-get', '-qq', 'changelog', '%s=%s' % (self.binary, self.Version)]
            ALCLog.debug(_("Calling %(cmd)s to retrieve changelog") % {'cmd': str(command)})
            subprocess.run(command, stdout=changelog_fd, stderr=subprocess.PIPE, timeout=120, check=True)

        except subprocess.CalledProcessError as ex:
            ALCLog.error(_('Unable to retrieve changelog for package %(pkg)s; '
                           + "'apt-get changelog' failed with: %(errmsg)s")
                           % {'pkg': self.binary,
                              'errmsg': ex.stderr.decode('utf-8', 'replace') if ex.stderr else str(ex)})

        except Exception as ex:
            ALCLog.error(_('Unable to retrieve changelog for package %(pkg)s; '
                          + "could not run 'apt-get changelog': %(errmsg)s")
                           % {'pkg': self.binary,
                              'errmsg': str(ex)})

        else:
            return ChangelogsReader(self.source, '', since_version, latest,
                                    reverse).read_changelogs([changelog_file], None)

        finally:
            changelog_fd.close()
            shutil.rmtree(tempdir, 1)

        return None


    def _extract_contents(self, filenames):
        tempdir = tempfile.mkdtemp(prefix='apt-listchanges')

        extract_command = 'dpkg-deb --fsys-tarfile %s | tar xf - --wildcards -C %s %s 2>/dev/null' % (
            shlex.quote(self.path), shlex.quote(tempdir),
            ' '.join([shlex.quote(x) for x in filenames])
        )

        # tar exits unsuccessfully if _any_ of the files we wanted
        # were not available, so we can't do much with its status
        status = os.system(extract_command)

        if os.WIFSIGNALED(status) and os.WTERMSIG(status) == signal.SIGINT:
            shutil.rmtree(tempdir, 1)
            raise KeyboardInterrupt

        return tempdir


    def _changelog_variations(self, filename):
        formats = ['./usr/share/doc/*/%s.gz',
                   './usr/share/doc/*/%s']
        return [x % filename for x in formats]


__all__ = [ 'ControlParser', 'Package' ]
