# -*- coding: utf-8 -*-

# Copyright (C) 2004, 2005, 2006, 2007, 2008, 2009, 2011, 2012 Canonical Ltd.
# Copyright (C) 2006 Gustavo Franco
#
# This file is part of Germinate.
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

# TODO:
# - Exclude essential packages from dependencies

from __future__ import print_function

from collections import defaultdict
import logging
import optparse
import os
import re
import subprocess
import sys

try:
    from configparser import NoOptionError, NoSectionError
    from configparser import ConfigParser as SafeConfigParser
except ImportError:
    from ConfigParser import NoOptionError, NoSectionError, SafeConfigParser

import germinate.archive
from germinate.germinator import Germinator
from germinate.log import germinate_logging
from germinate.seeds import SeedError, SeedStructure, SeedVcs
import germinate.version


def error_exit(message):
    print("%s: %s" % (sys.argv[0], message), file=sys.stderr)
    sys.exit(1)


def parse_options(argv):
    description = '''\
Update metapackage lists for distribution 'dist' as defined in
update.cfg.'''

    parser = optparse.OptionParser(
        prog='germinate-update-metapackage',
        usage='%prog [options] [dist]',
        version='%prog ' + germinate.version.VERSION,
        description=description)
    parser.add_option('-o', '--output-directory', dest='outdir',
                      default='.', metavar='DIR',
                      help='output in specific directory')
    parser.add_option('--nodch', dest='nodch', action='store_true',
                      default=False,
                      help="don't modify debian/changelog")
    parser.add_option('--vcs', dest='vcs',
                      action='store_const', const=SeedVcs.AUTO,
                      help='fetch seeds using a version control system')
    parser.add_option('--bzr', dest='vcs', action='store_true',
                      help='fetch seeds using bzr (requires bzr to be '
                           'installed; use --vcs instead)')
    return parser.parse_args(argv[1:])


def main(argv):
    options, args = parse_options(argv)

    if not os.path.exists('debian/control'):
        error_exit('must be run from the top level of a source package')
    this_source = None
    with open('debian/control') as control:
        for line in control:
            if line.startswith('Source:'):
                this_source = line[7:].strip()
                break
            elif line == '':
                break
    if this_source is None:
        error_exit('cannot find Source: in debian/control')
    if not this_source.endswith('-meta'):
        error_exit('source package name must be *-meta')
    metapackage = this_source[:-5]

    print("[info] Initialising %s-* package lists update..." % metapackage)

    config = SafeConfigParser()
    with open('update.cfg') as config_file:
        try:
            # >= 3.2
            config.read_file(config_file)
        except AttributeError:
            # < 3.2
            config.readfp(config_file)

    if len(args) > 0:
        dist = args[0]
    else:
        dist = config.get('DEFAULT', 'dist')

    seeds = config.get(dist, 'seeds').split()
    try:
        output_seeds = config.get(dist, 'output_seeds').split()
    except NoOptionError:
        output_seeds = list(seeds)
    architectures = config.get(dist, 'architectures').split()
    try:
        archive_base_default = config.get(dist, 'archive_base/default')
        archive_base_default = re.split(r'[, ]+', archive_base_default)
    except (NoSectionError, NoOptionError):
        archive_base_default = None

    archive_base = {}
    for arch in architectures:
        try:
            archive_base[arch] = config.get(dist, 'archive_base/%s' % arch)
            archive_base[arch] = re.split(r'[, ]+', archive_base[arch])
        except (NoSectionError, NoOptionError):
            if archive_base_default is not None:
                archive_base[arch] = archive_base_default
            else:
                error_exit('no archive_base configured for %s' % arch)

    if options.vcs and config.has_option("%s/vcs" % dist, 'seed_base'):
        seed_base = config.get("%s/vcs" % dist, 'seed_base')
    elif options.vcs and config.has_option("%s/bzr" % dist, 'seed_base'):
        # Backward compatibility.
        seed_base = config.get("%s/bzr" % dist, 'seed_base')
    else:
        seed_base = config.get(dist, 'seed_base')
    seed_base = re.split(r'[, ]+', seed_base)
    if options.vcs and config.has_option("%s/vcs" % dist, 'seed_dist'):
        seed_dist = config.get("%s/vcs" % dist, 'seed_dist')
    elif options.vcs and config.has_option("%s/bzr" % dist, 'seed_dist'):
        # Backward compatibility.
        seed_dist = config.get("%s/bzr" % dist, 'seed_dist')
    elif config.has_option(dist, 'seed_dist'):
        seed_dist = config.get(dist, 'seed_dist')
    else:
        seed_dist = dist
    if config.has_option(dist, 'dists'):
        dists = config.get(dist, 'dists').split()
    else:
        dists = [dist]
    components = config.get(dist, 'components').split()

    def seed_packages(germinator_method, structure, seed_name):
        if config.has_option(dist, "seed_map/%s" % seed_name):
            mapped_seeds = config.get(dist, "seed_map/%s" % seed_name).split()
        else:
            mapped_seeds = []
            task_seeds_re = re.compile(r'^Task-Seeds:\s*(.*)', re.I)
            with structure[seed_name] as seed:
                for line in seed:
                    task_seeds_match = task_seeds_re.match(line)
                    if task_seeds_match is not None:
                        mapped_seeds = task_seeds_match.group(1).split()
                        break
            if seed_name not in mapped_seeds:
                mapped_seeds.append(seed_name)
        packages = []
        for mapped_seed in mapped_seeds:
            packages.extend(germinator_method(structure, mapped_seed))
        return packages

    def metapackage_name(structure, seed_name):
        if config.has_option(dist, "metapackage_map/%s" % seed_name):
            return config.get(dist, "metapackage_map/%s" % seed_name)
        else:
            task_meta_re = re.compile(r'^Task-Metapackage:\s*(.*)', re.I)
            with structure[seed_name] as seed:
                for line in seed:
                    task_meta_match = task_meta_re.match(line)
                    if task_meta_match is not None:
                        return task_meta_match.group(1)
            return "%s-%s" % (metapackage, seed_name)

    debootstrap_version_file = 'debootstrap-version'

    def get_debootstrap_version():
        version_cmd = subprocess.Popen(
            ['dpkg-query', '-W', '--showformat', '${Version}', 'debootstrap'],
            stdout=subprocess.PIPE, universal_newlines=True)
        version, _ = version_cmd.communicate()
        if not version:
            error_exit('debootstrap does not appear to be installed')

        return version

    def debootstrap_packages(arch):
        env = dict(os.environ)
        if 'PATH' in env:
            env['PATH'] = '/usr/sbin:/sbin:%s' % env['PATH']
        else:
            env['PATH'] = '/usr/sbin:/sbin:/usr/bin:/bin'
        debootstrap = subprocess.Popen(
            ['debootstrap', '--arch', arch,
             '--components', ','.join(components),
             '--print-debs', dist, 'debootstrap-dir', archive_base[arch][0]],
            stdout=subprocess.PIPE, env=env, stderr=subprocess.PIPE,
            universal_newlines=True)
        (debootstrap_stdout, debootstrap_stderr) = debootstrap.communicate()
        if debootstrap.returncode != 0:
            error_exit('Unable to retrieve package list from debootstrap; '
                       'stdout: %s\nstderr: %s' %
                       (debootstrap_stdout, debootstrap_stderr))

        # sometimes debootstrap gives empty packages / multiple separators
        packages = [pkg for pkg in debootstrap_stdout.split() if pkg]

        return sorted(packages)

    def check_debootstrap_version():
        if os.path.exists(debootstrap_version_file):
            with open(debootstrap_version_file) as debootstrap:
                old_debootstrap_version = debootstrap.read().strip()
            debootstrap_version = get_debootstrap_version()
            failed = subprocess.call(
                ['dpkg', '--compare-versions',
                 debootstrap_version, 'ge', old_debootstrap_version])
            if failed:
                error_exit('Installed debootstrap is older than in the '
                           'previous version! (%s < %s)' %
                           (debootstrap_version, old_debootstrap_version))

    def update_debootstrap_version():
        with open(debootstrap_version_file, 'w') as debootstrap:
            debootstrap.write(get_debootstrap_version() + '\n')

    def format_changes(items):
        by_arch = defaultdict(set)
        for pkg, arch in items:
            by_arch[pkg].add(arch)
        all_pkgs = sorted(by_arch)
        chunks = []
        for pkg in all_pkgs:
            arches = by_arch[pkg]
            if set(architectures) - arches:
                # only some architectures
                chunks.append('%s [%s]' % (pkg, ' '.join(sorted(arches))))
            else:
                # all architectures
                chunks.append(pkg)
        return ', '.join(chunks)

    germinate_logging(logging.DEBUG)

    check_debootstrap_version()

    additions = defaultdict(list)
    removals = defaultdict(list)
    moves = defaultdict(list)
    metapackage_map = {}
    for architecture in architectures:
        print("[%s] Downloading available package lists..." % architecture)
        germinator = Germinator(architecture)
        archive = germinate.archive.TagFile(
            dists, components, architecture,
            archive_base[architecture], source_mirrors=archive_base_default,
            cleanup=True)
        germinator.parse_archive(archive)
        debootstrap_base = set(debootstrap_packages(architecture))

        print("[%s] Loading seed lists..." % architecture)
        try:
            structure = SeedStructure(seed_dist, seed_base, options.vcs)
            germinator.plant_seeds(structure, seeds=seeds)
        except SeedError:
            sys.exit(1)

        print("[%s] Merging seeds with available package lists..." %
              architecture)
        for seed_name in output_seeds:
            meta_name = metapackage_name(structure, seed_name)
            metapackage_map[seed_name] = meta_name

            output_filename = os.path.join(
                options.outdir, '%s-%s' % (seed_name, architecture))
            old_list = None
            if os.path.exists(output_filename):
                with open(output_filename) as output:
                    old_list = set(map(str.strip, output.readlines()))
                os.rename(output_filename, output_filename + '.old')

            # work on the depends
            new_list = set()
            packages = seed_packages(germinator.get_seed_entries,
                                     structure, seed_name)
            for package in packages:
                if package == meta_name:
                    print("%s/%s: Skipping package %s (metapackage)" %
                          (seed_name, architecture, package))
                elif (seed_name == 'minimal' and
                      package not in debootstrap_base):
                    print("%s/%s: Skipping package %s (package not in "
                          "debootstrap)" % (seed_name, architecture, package))
                elif germinator.is_essential(package):
                    print("%s/%s: Skipping package %s (essential)" %
                          (seed_name, architecture, package))
                else:
                    new_list.add(package)

            with open(output_filename, 'w') as output:
                for package in sorted(new_list):
                    output.write(package)
                    output.write('\n')

            # work on the recommends
            old_recommends_list = None
            new_recommends_list = set()
            packages = seed_packages(germinator.get_seed_recommends_entries,
                                     structure, seed_name)
            for package in packages:
                if package == meta_name:
                    print("%s/%s: Skipping package %s (metapackage)" %
                          (seed_name, architecture, package))
                    continue
                if seed_name == 'minimal' and package not in debootstrap_base:
                    print("%s/%s: Skipping package %s (package not in "
                          "debootstrap)" % (seed_name, architecture, package))
                else:
                    new_recommends_list.add(package)

            seed_name_recommends = '%s-recommends' % seed_name
            output_recommends_filename = os.path.join(
                options.outdir, '%s-%s' % (seed_name_recommends, architecture))
            if os.path.exists(output_recommends_filename):
                with open(output_recommends_filename) as output:
                    old_recommends_list = set(
                        map(str.strip, output.readlines()))
                os.rename(
                    output_recommends_filename,
                    output_recommends_filename + '.old')

            with open(output_recommends_filename, 'w') as output:
                for package in sorted(new_recommends_list):
                    output.write(package)
                    output.write('\n')

            # Calculate deltas
            merged = defaultdict(int)
            recommends_merged = defaultdict(int)
            if old_list is not None:
                for package in new_list:
                    merged[package] += 1
                for package in old_list:
                    merged[package] -= 1
            if old_recommends_list is not None:
                for package in new_recommends_list:
                    recommends_merged[package] += 1
                for package in old_recommends_list:
                    recommends_merged[package] -= 1

            mergeditems = sorted(merged.items())
            for package, value in mergeditems:
                if value == 1:
                    if recommends_merged.get(package, 0) == -1:
                        moves[package].append([seed_name, architecture])
                        recommends_merged[package] += 1
                    else:
                        additions[package].append([seed_name, architecture])
                elif value == -1:
                    if recommends_merged.get(package, 0) == 1:
                        moves[package].append([seed_name_recommends,
                                               architecture])
                        recommends_merged[package] -= 1
                    else:
                        removals[package].append([seed_name, architecture])

            mergedrecitems = sorted(recommends_merged.items())
            for package, value in mergedrecitems:
                if value == 1:
                    additions[package].append([seed_name_recommends,
                                               architecture])
                elif value == -1:
                    removals[package].append([seed_name_recommends,
                                              architecture])

    with open('metapackage-map', 'w') as metapackage_map_file:
        for seed_name in output_seeds:
            print(seed_name, metapackage_map[seed_name],
                  file=metapackage_map_file)

    if not options.nodch and (additions or removals or moves):
        dch_help = subprocess.Popen(['dch', '--help'], stdout=subprocess.PIPE,
                                    universal_newlines=True)
        try:
            have_U = '-U' in dch_help.stdout.read()
        finally:
            if dch_help.stdout:
                dch_help.stdout.close()
            dch_help.wait()
        if have_U:
            subprocess.check_call(['dch', '-iU', 'Refreshed dependencies'])
        else:
            subprocess.check_call(['dch', '-i', 'Refreshed dependencies'])
        changes = []
        for package in sorted(additions):
            changes.append('Added %s to %s' %
                           (package, format_changes(additions[package])))
        for package in sorted(removals):
            changes.append('Removed %s from %s' %
                           (package, format_changes(removals[package])))
        for package in sorted(moves):
            # TODO: We should really list where it moved from as well, but
            # that gets wordy very quickly, and at the moment this is only
            # implemented for depends->recommends or vice versa. In future,
            # using this for moves between seeds might also be useful.
            changes.append('Moved %s to %s' %
                           (package, format_changes(moves[package])))
        for change in changes:
            print(change)
            subprocess.check_call(['dch', '-a', change])
        update_debootstrap_version()
    else:
        if not options.nodch:
            print("No changes found")

    return 0
