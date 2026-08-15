#!/usr/bin/python3
# Copyright (C) 2011  Lars Wirzenius <liw@liw.fi>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License along
# with this program; if not, write to the Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

from distutils.core import setup, Extension
from distutils.cmd import Command
from distutils.command.build import build
from distutils.command.clean import clean
import glob
import os
import shutil
import subprocess

import cmdtestlib
import yarnlib

try:
    import markdown
except ImportError:
    markdown_version = None
else:
    if (hasattr(markdown, 'extensions') and
        hasattr(markdown.extensions, 'Extension')):
        markdown_version = True
    else:
        markdown_version = False


class GenerateManpage(build):

    def run(self):
        build.run(self)
        print('building manpages')
        cmds = ['cmdtest']
        if markdown_version:
            cmds.append('yarn')
        for x in cmds:
            with open('%s.1' % x, 'w') as f:
                subprocess.check_call(['python3', x,
                                       '--generate-manpage=%s.1.in' % x,
                                       '--output=%s.1' % x], stdout=f)


class CleanMore(clean):

    def run(self):
        clean.run(self)
        for x in ['.coverage', 'cmdtest.1'] + glob.glob('*.pyc'):
            if os.path.exists(x):
                os.remove(x)


class Check(Command):

    user_options = []

    def initialize_options(self):
        pass

    def finalize_options(self):
        pass

    def run(self):
        if markdown_version:
            subprocess.check_call(
                ['python3', '-m', 'CoverageTestRunner',
                 '--ignore-missing-from', 'without-tests'])
            if os.path.exists('.coverage'):
                os.remove('.coverage')

        subprocess.check_call(['./cmdtest', 'echo-tests'])
        subprocess.check_call(['./cmdtest', 'sort-tests'])

        try:
            subprocess.check_call(['./cmdtest', 'fail-tests'])
        except subprocess.CalledProcessError:
            pass
        else:
            raise Exception('fail-tests did not fail, which is a surprise')

        if markdown_version:
            subprocess.check_call(['./cmdtest', 'yarn.tests'])


setup(name='cmdtest',
      version=yarnlib.__version__,
      description='blackbox testing of Unix command line tools',
      author='Lars Wirzenius',
      author_email='liw@liw.fi',
      url='http://liw.fi/cmdtest/',
      scripts=['cmdtest', 'yarn'],
      py_modules=['cmdtestlib'],
      packages=['yarnlib', 'yarnutils'],
      data_files=[('share/man/man1', glob.glob('*.1'))],
      cmdclass={
        'build': GenerateManpage,
        'check': Check,
        'clean': CleanMore,
      },
      classifiers=[
        'Development Status :: 4 - Beta',
        'Environment :: Console',
        'Intended Audience :: Developers',
        'License :: OSI Approved :: GNU General Public License v3 or later (GPLv3+)',
        'Operating System :: Unix',
        'Programming Language :: Python :: 2',
        'Programming Language :: Python :: 3',
        'Topic :: Utilities',
      ],
     )
