# -*- coding: utf-8 -*-
"""Expand dependencies in a list of seed packages."""

# Copyright (C) 2004, 2005, 2006, 2007, 2008, 2009, 2010, 2011, 2012
#               Canonical Ltd.
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

import copy
import logging
import optparse
import os
import shutil
import sys

import germinate.archive
import germinate.defaults
from germinate.germinator import Germinator
from germinate.log import germinate_logging
from germinate.seeds import Seed, SeedError, SeedStructure, SeedVcs
import germinate.version


def check_seed_vcs(option, opt, value):
    if value == "none":  # or just omit the option
        return None
    elif value == "auto":
        return SeedVcs.AUTO
    elif value == "bzr":
        return SeedVcs.BZR
    elif value == "git":
        return SeedVcs.GIT
    else:
        raise optparse.OptionValueError(
            "option %s: unrecognised VCS value: %s" % (opt, value))


class GerminateOption(optparse.Option):
    """A custom option type for use with optparse."""

    TYPES = optparse.Option.TYPES + ("vcs",)
    TYPE_CHECKER = copy.copy(optparse.Option.TYPE_CHECKER)
    TYPE_CHECKER["vcs"] = check_seed_vcs


def parse_options(argv):
    parser = optparse.OptionParser(
        prog='germinate',
        version='%prog ' + germinate.version.VERSION,
        option_class=GerminateOption)
    parser.add_option('-v', '--verbose', dest='verbose', action='store_true',
                      default=False,
                      help='be more verbose when processing seeds')
    parser.add_option('-S', '--seed-source', dest='seeds', metavar='SOURCE',
                      help='fetch seeds from SOURCE (default: %s)' %
                           germinate.defaults.seeds)
    parser.add_option('-s', '--seed-dist', dest='release', metavar='DIST',
                      default=germinate.defaults.release,
                      help='fetch seeds for distribution DIST '
                           '(default: %default)')
    parser.add_option('-m', '--mirror', dest='mirrors', action='append',
                      metavar='MIRROR',
                      help='get package lists from MIRROR (default: %s)' %
                           germinate.defaults.mirror)
    parser.add_option('--source-mirror', dest='source_mirrors',
                      action='append', metavar='MIRROR',
                      help='get source package lists from mirror '
                           '(default: value of --mirror)')
    parser.add_option('-d', '--dist', dest='dist',
                      default=germinate.defaults.dist,
                      help='operate on distribution DIST (default: %default)')
    parser.add_option('-a', '--arch', dest='arch',
                      default=germinate.defaults.arch,
                      help='operate on architecture ARCH (default: %default)')
    parser.add_option('-c', '--components', dest='components',
                      default='main,restricted', metavar='COMPS',
                      help='operate on components COMPS (default: %default)')
    parser.add_option('--vcs', dest='vcs', action='store', type='vcs',
                      help='version control system to use '
                           '(auto, bzr, git; defaults to none)')
    parser.add_option('--bzr', dest='vcs',
                      action='store_const', const=SeedVcs.BZR,
                      help='fetch seeds using bzr (requires bzr to be '
                           'installed; use --vcs=bzr instead)')
    parser.add_option('--cleanup', dest='cleanup', action='store_true',
                      default=False,
                      help="don't cache Packages or Sources files")
    parser.add_option('--no-rdepends', dest='want_rdepends',
                      action='store_false', default=True,
                      help='disable reverse-dependency calculations')
    parser.add_option('--no-installer', dest='installer', action='store_false',
                      default=True,
                      help='do not consider debian-installer udeb packages')
    parser.add_option('--seed-packages', dest='seed_packages',
                      metavar='PARENT/PKG,PARENT/PKG,...',
                      help='treat each PKG as a seed by itself, inheriting '
                           'from PARENT')
    parser.add_option('--always-follow-build-depends',
                      dest='always_follow_build_depends', action='store_true',
                      default=False,
                      help='always follow Build-Depends, regardless of seed '
                           'feature flags')
    options, _ = parser.parse_args(argv[1:])

    if options.seeds is None:
        if options.vcs is None:
            options.seeds = germinate.defaults.seeds
        elif options.vcs == SeedVcs.GIT:
            options.seeds = germinate.defaults.seeds_git
        else:
            options.seeds = germinate.defaults.seeds_bzr
    options.seeds = options.seeds.split(',')

    if options.mirrors is None:
        options.mirrors = [germinate.defaults.mirror]

    options.dist = options.dist.split(',')
    options.components = options.components.split(',')
    if options.seed_packages is None:
        options.seed_packages = []
    else:
        options.seed_packages = options.seed_packages.split(',')

    return options


def main(argv):
    options = parse_options(argv)

    if options.verbose:
        germinate_logging(logging.DEBUG)
    else:
        germinate_logging(logging.INFO)

    g = Germinator(options.arch)
    g._always_follow_build_depends = options.always_follow_build_depends

    archive = germinate.archive.TagFile(
        options.dist, options.components, options.arch,
        options.mirrors, source_mirrors=options.source_mirrors,
        installer_packages=options.installer, cleanup=options.cleanup)
    g.parse_archive(archive)

    if os.path.isfile("hints"):
        with open("hints") as hints:
            g.parse_hints(hints)

    try:
        structure = SeedStructure(options.release, options.seeds, options.vcs)
        for seed_package in options.seed_packages:
            parent, pkg = seed_package.split('/')
            structure.add(pkg, [" * " + pkg], parent)
        g.plant_seeds(structure)
    except SeedError:
        sys.exit(1)

    try:
        with Seed(options.seeds, options.release, "blacklist",
                  options.vcs) as blacklist:
            g.parse_blacklist(structure, blacklist)
    except SeedError:
        pass

    g.grow(structure)
    g.add_extras(structure)
    if options.want_rdepends:
        g.reverse_depends(structure)

    for seedname in structure.names + ["extra"]:
        g.write_full_list(structure, seedname, seedname)
        g.write_seed_list(structure, seedname + ".seed", seedname)
        g.write_seed_recommends_list(structure,
                                     seedname + ".seed-recommends", seedname)
        g.write_depends_list(structure, seedname + ".depends", seedname)
        g.write_build_depends_list(structure,
                                   seedname + ".build-depends", seedname)
        g.write_snap_list(structure, seedname + ".snaps", seedname)

        if seedname != "extra" and seedname in structure:
            structure.write_seed_text(seedname + ".seedtext", seedname)
            g.write_sources_list(structure, seedname + ".sources", seedname)
        g.write_build_sources_list(structure,
                                   seedname + ".build-sources", seedname)

    g.write_all_list(structure, "all")
    g.write_all_source_list(structure, "all.sources")
    g.write_all_snap_list(structure, "all.snaps")

    g.write_supported_list(structure, "%s+build-depends" % structure.supported)
    g.write_supported_source_list(
        structure, "%s+build-depends.sources" % structure.supported)

    g.write_all_extra_list(structure, "all+extra")
    g.write_all_extra_source_list(structure, "all+extra.sources")

    g.write_provides_list(structure, "provides")

    structure.write("structure")
    structure.write_dot("structure.dot")

    if os.path.exists("rdepends"):
        shutil.rmtree("rdepends")
    if options.want_rdepends:
        os.mkdir("rdepends")
        os.mkdir(os.path.join("rdepends", "ALL"))
        for pkg in g.get_all(structure):
            dirname = os.path.join("rdepends", g.get_source(pkg))
            if not os.path.exists(dirname):
                os.mkdir(dirname)

            g.write_rdepend_list(structure, os.path.join(dirname, pkg), pkg)
            os.symlink(os.path.join("..", g.get_source(pkg), pkg),
                       os.path.join("rdepends", "ALL", pkg))

    g.write_blacklisted(structure, "blacklisted")

    return 0
