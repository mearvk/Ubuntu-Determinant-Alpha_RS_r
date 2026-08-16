#!/usr/bin/python3
# vim:fileencoding=utf-8:et:ts=4:sw=4:sts=4
#
# Copyright (C) 2015 Intel Corporation <markus.lehtonen@linux.intel.com>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, please see
# <http://www.gnu.org/licenses/>
#
"""Script for managing test package repositories and unittest data"""

import argparse
import configparser
import json
import logging
import os
import shutil
import subprocess
import tempfile
from collections import defaultdict
from fnmatch import fnmatch
from glob import glob


logging.basicConfig(level=logging.INFO, format='%(levelname)s: %(message)s')
LOG = logging.getLogger()


class GitError(Exception):
    """Exception for git errors"""
    pass


def run_cmd(cmd, opts=None, capture_stdout=False, capture_stderr=False,
            input_data=None, extra_env=None):
    """Run command"""
    args = [cmd] + opts if opts else [cmd]
    stdin = subprocess.PIPE if input_data else None
    stdout = subprocess.PIPE if capture_stdout else None
    stderr = subprocess.PIPE if capture_stderr else None
    env = None
    if extra_env:
        env = dict(os.environ)
        env.update(extra_env)
    LOG.debug("Running command: '%s'", ' '.join(args))
    popen = subprocess.Popen(args, stdin=stdin, stdout=stdout, stderr=stderr,
                             env=env)
    stdout, stderr = popen.communicate(input_data.encode() if input_data else None)
    ret_out = stdout.decode().splitlines() if stdout else stdout
    ret_err = stderr.decode().splitlines() if stderr else stderr
    return (popen.returncode, ret_out, ret_err)


def git_cmd(cmd, opts=None, capture_stdout=False, input_data=None,
            extra_env=None):
    """Run git command"""
    git_opts = [cmd] + opts if opts else [cmd]
    ret, stdout, stderr = run_cmd('git', git_opts, capture_stdout, True,
                                  input_data, extra_env)
    if ret:
        raise GitError("Git cmd ('%s') failed: %s" %
                       ('git ' + ' '.join(git_opts), '\n'.join(stderr)))
    return stdout


def git_cat_file(treeish):
    """Get object content"""
    info = {}
    output = git_cmd('cat-file', ['-p', treeish], True)
    for num, line in enumerate(output):
        if not line:
            break
        key, val = line.split(' ', 1)
        if key == 'parent':
            if 'parents' in info:
                info['parents'].append(val)
            else:
                info['parents'] = [val]
        else:
            info[key] = val
    info['message'] = output[num + 1:]
    return info


def git_write_patch(treeish, outfile):
    """Write patch with user-defined filename"""
    cmd = ['git', 'format-patch', '-1', '--stdout', '--no-stat',
           '--no-signature', treeish]
    LOG.debug("Running command: '%s'", ' '.join(cmd))
    with open(outfile, 'w') as fobj:
        # Skip the first line of the patch that contains the commit sha1
        popen = subprocess.Popen(['tail', '-n', '+2'], stdout=fobj,
                                 stdin=subprocess.PIPE)
        popen2 = subprocess.Popen(cmd, stdout=popen.stdin,
                                  stderr=subprocess.PIPE)
    _, stderr = popen2.communicate()
    popen.communicate()
    if popen.returncode:
        raise GitError("Git format-patch failed: %s" % stderr)


def parse_args(argv=None):
    """Argument parser"""
    main_parser = argparse.ArgumentParser()
    main_parser.add_argument('--verbose', '-v', action='store_true',
                             help="Verbose output")

    subparsers = main_parser.add_subparsers()
    # Build command
    parser = subparsers.add_parser('build', help='Build binary files')
    parser.set_defaults(func=cmd_build)
    parser.add_argument('--overwrite', '-O', action='store_true',
                        help="Overwrite existing files")
    parser.add_argument('--output-dir', '-o', default='.',
                        help="Target directory for built artefacts")
    parser.add_argument('--silent-build', '-s', action='store_true',
                        help="Silent build, i.e. no rpmbuild output shown")
    parser.add_argument('reponame', nargs='*',
                        help="Name of package repository to build")
    # Import command
    parser = subparsers.add_parser('import-repo',
                                   help="Create test package repositories")
    parser.set_defaults(func=cmd_import_repos)
    parser.add_argument('--force', '-f', action='store_true',
                        help="Overwrite existing repositories")
    parser.add_argument('--output-dir', '-o', default='.',
                        help="Target directory for the imported repo(s)")
    parser.add_argument('reponame', nargs='?',
                        help="Name of package repository to import")
    parser.add_argument('repodir', nargs='?',
                        help="Directory name (under output directory) where "
                             "new repository is created")
    # Export command
    parser = subparsers.add_parser('export-repo',
                                   help='Serialize test package repositories')
    parser.set_defaults(func=cmd_export_repos)
    parser.add_argument('--output-dir', '-o', default='.',
                        help="Target directory for the exported repo(s)")
    parser.add_argument('reponame', nargs='?',
                        help="Name of package repository to export")
    parser.add_argument('datadir', nargs='?',
                        help="Directory name (under output directory) where "
                             "data is exported")
    return main_parser.parse_args(argv)


def cond_copy(src, dst, overwrite=False):
    """Copy if file does not exists, unless overwrite is enabled"""
    if os.path.isdir(dst):
        dst = os.path.join(dst, os.path.basename(src))
    src = os.path.abspath(src)
    dst = os.path.abspath(dst)
    if not os.path.exists(dst) or overwrite:
        LOG.debug('Copying %s -> %s', src, dst)
        shutil.copy(src, dst)
    else:
        LOG.debug('Skipping %s', src)


def do_build(tag, builddir, silent_build=False):
    """Run git-buildpackage-rpm"""
    gbp_opts = ['buildpackage-rpm', '--git-ignore-new',
                '--git-export=%s' % tag, '--git-export-dir=%s' % builddir,
                '--git-ignore-branch']
    rpmbuild_opts = ['-ba', '--target=noarch']
    ret, out, _ = run_cmd('gbp', gbp_opts + rpmbuild_opts,
                          True, silent_build)
    if ret:
        for line in out:
            print(line)
        raise Exception('Building %s failed! Builddata can be found '
                        'in %s' % (tag, builddir))


def build_repo(repodir, outdir, silent_build=False, overwrite=False):
    """Build the test package and extract unit test data"""
    repodir = os.path.abspath(repodir)
    outdir = os.path.abspath(outdir)
    if not os.path.isdir(repodir):
        raise Exception("Repodir %s does not exist" % repodir)
    if not os.path.isdir(outdir):
        os.mkdir(outdir)

    tag_pattern = '*/release/*'
    orig_cwd = os.getcwd()
    os.chdir(repodir)
    try:
        tags = git_cmd('tag', ['-l', tag_pattern], True)
        for ind, tag in enumerate(tags):
            prefix = 'build-%s-%s_' % (os.path.basename(repodir), ind)
            builddir = tempfile.mkdtemp(dir=orig_cwd, prefix=prefix)
            LOG.info("Building tag '%s'", tag)
            do_build(tag, builddir, silent_build)

            # Create subdirs
            orig_dir = '%s/%s' % (outdir, 'orig')
            rpm_dir = '%s/%s' % (outdir, 'rpm')
            for path in (orig_dir, rpm_dir):
                if not os.path.isdir(path):
                    os.mkdir(path)

            for fname in glob('%s/SRPMS/*rpm' % builddir):
                cond_copy(fname, outdir, overwrite)
            for fname in glob('%s/RPMS/*/*rpm' % builddir):
                cond_copy(fname, rpm_dir, overwrite)
            for fname in os.listdir('%s/SOURCES' % builddir):
                if (fnmatch(fname, 'gbp*tar.gz') or
                        fnmatch(fname, 'gbp*tar.bz2') or
                        fnmatch(fname, 'gbp*zip')):

                    cond_copy('%s/SOURCES/%s' % (builddir, fname), orig_dir,
                              overwrite)
            shutil.rmtree(builddir)
    finally:
        os.chdir(orig_cwd)


def cmd_build(args):
    """Subcommand building binary test data"""
    if args.reponame:
        repos = []
        for repo in args.reponame:
            if os.path.exists(repo):
                repos.append(repo)
            else:
                repos.append(repo + '.repo')
    else:
        repos = glob('*.repo')
    if not repos:
        raise Exception("No repositories found, run 'import' in order to "
                        "initialize test package repositories for building")
    # Read build config
    config = configparser.RawConfigParser()
    config.read('build.conf')

    for repodir in repos:
        LOG.info("Building repository '%s'", repodir)
        build_repo(repodir, args.output_dir, args.silent_build, args.overwrite)


def write_repo_data(outfile, **kwargs):
    """Write repository metadata into JSON file"""
    #data = {'refs': refs, 'tags': tags, 'commits': commits}
    data = kwargs
    with open(outfile, 'w') as fobj:
        json.dump(data, fobj, indent=4, sort_keys=True)


def split_git_author(author):
    """Split author/committer string into separate fields"""
    name_email, date = author.rsplit('>', 1)
    name, email = name_email.split('<', 1)
    return name, email, date


def commit_tree(commit):
    """Create a tag object"""
    name, email, date = split_git_author(commit['committer'])
    env = {'GIT_COMMITTER_NAME': name,
           'GIT_COMMITTER_EMAIL': email,
           'GIT_COMMITTER_DATE': date}
    name, email, date = split_git_author(commit['author'])
    env.update({'GIT_AUTHOR_NAME': name,
                'GIT_AUTHOR_EMAIL': email,
                'GIT_AUTHOR_DATE': date})
    git_opts = []
    git_opts.append(commit['tree'])
    if 'parents' in commit:
        for parent in commit['parents']:
            git_opts += ['-p', parent]
    return git_cmd('commit-tree', git_opts, True, commit['message'] + '\n',
                   env)[0]


def commit_patch(commit, patchfile):
    """Apply and commit one patch"""
    name, email, date = split_git_author(commit['committer'])
    env = {'GIT_COMMITTER_NAME': name,
           'GIT_COMMITTER_EMAIL': email,
           'GIT_COMMITTER_DATE': date}
    name, email, date = split_git_author(commit['author'])
    env.update({'GIT_AUTHOR_NAME': name,
                'GIT_AUTHOR_EMAIL': email,
                'GIT_AUTHOR_DATE': date})
    # Empty patch for empty commits -> would not apply
    if os.stat(patchfile).st_size:
        git_cmd('apply', ['--index', patchfile], True, None, env)
        tree = git_cmd('write-tree', None, True, None, env)[0]
        assert tree == commit['tree']
    sha1 = commit_tree(commit)
    git_cmd('checkout', [sha1], True)
    return sha1


def import_commit(commit, patchdir):
    """Import one commit"""
    patchfile = os.path.join(patchdir, commit['patchfile'])
    # Repository state sanity check
    if git_cmd('status', ['--porcelain'], True):
        raise Exception("Refusing to import, git repository not clean at %s" %
                        os.getcwd())
    if 'parents' not in commit:
        # Start new history
        git_cmd('checkout', ['--orphan', '__tmp__'], True)
        if git_cmd('status', ['--porcelain'], True):
            # Clean working tree and index
            git_cmd('rm', ['-rf', '.'], True)
        sha1 = commit_patch(commit, patchfile)
    elif len(commit['parents']) == 1:
        git_cmd('checkout', [commit['parents'][0]], True)
        sha1 = commit_patch(commit, patchfile)
    else:
        raise Exception("Merge commits (%s) not supported!" % commit['sha1'])
    # Sanity check for commit
    assert sha1 == commit['sha1'], (
        "SHA-1 of the created commit is wrong (%s != %s)" %
        (sha1, commit['sha1']))


def import_repo(datadir, repodir, force):
    """De-serialize test package repodata into a Git repository"""
    datadir = os.path.abspath(datadir)
    repodir = os.path.abspath(repodir)
    if not os.path.isdir(datadir):
        raise Exception("Datadir %s does not exist" % datadir)
    if os.path.isdir(repodir):
        if not force:
            raise Exception("Repository %s already exists! "
                            "Use --force to replace." % repodir)
        else:
            LOG.info('Removing existing repodir %s', repodir)
            shutil.rmtree(repodir)
    os.makedirs(repodir)
    with open(os.path.join(datadir, 'manifest.json')) as fobj:
        manifest = json.load(fobj)

    orig_cwd = os.getcwd()
    os.chdir(repodir)
    try:
        git_cmd('init', None, True)

        # Create child mapping of commit history
        commits = defaultdict(list)
        for sha1, info in manifest['commits'].items():
            if 'parents' not in info:
                commits['root'].append(sha1)
            else:
                for parent in info['parents']:
                    commits[parent].append(sha1)

        # Re-create all commits
        def import_commit_history(start):
            """Import chain of commits"""
            for sha1 in commits[start]:
                import_commit(manifest['commits'][sha1], datadir)
                import_commit_history(sha1)
        import_commit_history('root')

        # Re-create tags
        for sha1, tag in manifest['tags'].items():
            signature_data = "object %s\ntype %s\ntag %s\ntagger %s\n\n%s\n" % (
                tag['object'], tag['type'], tag['tag'], tag['tagger'],
                tag['message'])
            new_sha1 = git_cmd('mktag', None, True, signature_data)[0]
            assert new_sha1 == sha1, \
                "SHA-1 of the re-created tag is wrong (%s != %s)" % \
                (new_sha1, sha1)

        # Re-create refs
        for ref, sha1 in manifest['refs'].items():
            git_cmd('update-ref', [ref, sha1], True)

        # Forcefully set HEAD
        with open(os.path.join('.git', 'HEAD'), 'w') as fobj:
            fobj.write(manifest['HEAD'])
        git_cmd('reset', ['--hard'], True)
    finally:
        os.chdir(orig_cwd)


def cmd_import_repos(args):
    """Subcommand for creating test pkg Git repositories"""
    if args.reponame:
        repos = [args.reponame] if os.path.exists(args.reponame) else \
                [args.reponame + '.data']
    else:
        repos = glob('*.data')

    for datadir in repos:
        basename = os.path.basename(os.path.abspath(datadir))
        base, ext = os.path.splitext(basename)
        if args.repodir:
            repodir = args.repodir
        else:
            repodir = base + '.repo' if ext == '.data' else basename + '.repo'
        repodir = os.path.join(args.output_dir, repodir)
        LOG.info("Importing repodata from '%s' into '%s'", datadir, repodir)
        import_repo(datadir, repodir, args.force)


def export_repo(repodir, datadir):
    """Serialize one repository"""
    repodir = os.path.abspath(repodir)
    datadir = os.path.abspath(datadir)
    if not os.path.isdir(repodir):
        raise Exception("Repository %s does not exist" % repodir)
    if os.path.isdir(datadir):
        LOG.debug('Removing existing datadir %s', datadir)
        shutil.rmtree(datadir)
    os.makedirs(datadir)

    ref_metadata = {}
    tag_metadata = {}
    commits_metadata = {}
    orig_cwd = os.getcwd()
    os.chdir(repodir)
    try:
        # Get refs
        refs = [line.split() for line in
                git_cmd('show-ref', ['--tags', '--heads'], True)]
        for sha1, ref in refs:
            ref_metadata[ref] = sha1
        # Serialize tag objects
        tags = git_cmd('tag', None, True)
        for tag in tags:
            obj_type = git_cmd('cat-file', ['-t', tag], True)[0]
            if obj_type != 'tag':
                continue
            sha1 = git_cmd('rev-parse', [tag], True)[0]
            tag_info = git_cat_file(tag)
            tag_metadata[sha1] = {'type': tag_info['type'],
                                  'tag': tag_info['tag'],
                                  'object': tag_info['object'],
                                  'tagger': tag_info['tagger'],
                                  'message': '\n'.join(tag_info['message'])}
        # Serialize commits objects
        refs = [ref for _, ref in refs]
        revisions = git_cmd('rev-list', ['--reverse'] + refs + ['--'],
                            True)
        series = defaultdict(int)
        for sha1 in revisions:
            fn_base = git_cmd('show', ['--format=format:%f', '-s', sha1],
                              True)[0][:54]
            # In case of overlapping filenames, add a numerical suffix
            series[fn_base] += 1
            if series[fn_base] > 1:
                fn_base += '-%d' % series[fn_base]
            patch_fn = fn_base + '.patch'
            # Create patch file
            git_write_patch(sha1, os.path.join(datadir, patch_fn))
            commit_info = git_cat_file(sha1)
            meta = {'sha1': sha1,
                    'tree': commit_info['tree'],
                    'author': commit_info['author'],
                    'committer': commit_info['committer'],
                    'message': '\n'.join(commit_info['message']),
                    'patchfile': patch_fn}

            if 'parents' in commit_info:
                meta['parents'] = commit_info['parents']
            commits_metadata[sha1] = meta

        # Special handling for HEAD
        with open(os.path.join('.git', 'HEAD')) as fobj:
            head = fobj.read()

        # Write all metadata into file
        write_repo_data(os.path.join(datadir, 'manifest.json'),
                        refs=ref_metadata, tags=tag_metadata,
                        commits=commits_metadata, HEAD=head)
    finally:
        os.chdir(orig_cwd)


def cmd_export_repos(args):
    """Subcommand for updating test pkg repo data"""
    if args.reponame:
        repos = [args.reponame] if os.path.exists(args.reponame) else \
                [args.reponame + '.repo']
    else:
        repos = glob('*.repo')

    for repodir in repos:
        basename = os.path.basename(os.path.abspath(repodir))
        base, ext = os.path.splitext(basename)
        if args.datadir:
            datadir = args.datadir
        else:
            datadir = base + '.data' if ext == '.repo' else basename + '.data'
        datadir = os.path.join(args.output_dir, datadir)
        LOG.info("Exporting repodata from '%s' into '%s'", repodir, datadir)
        export_repo(repodir, datadir)


def main(argv=None):
    """The main routine"""
    args = parse_args(argv)
    if args.verbose:
        LOG.setLevel(logging.DEBUG)

    args.func(args)
    return 0


if __name__ == '__main__':
    main()
