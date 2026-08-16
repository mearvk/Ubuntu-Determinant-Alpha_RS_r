#! /usr/bin/env python

import os

from distutils.command.clean import clean
from setuptools import setup, find_packages


with open('germinate/version.txt') as version_file:
    germinate_version = version_file.read().strip()


class clean_extra(clean):
    def run(self):
        clean.run(self)

        for path, dirs, files in os.walk('.'):
            for i in reversed(range(len(dirs))):
                if dirs[i].startswith('.') or dirs[i] == 'debian':
                    del dirs[i]
                elif dirs[i] == '__pycache__' or dirs[i].endswith('.egg-info'):
                    self.spawn(['rm', '-r', os.path.join(path, dirs[i])])
                    del dirs[i]

            for f in files:
                f = os.path.join(path, f)
                if f.endswith('.pyc'):
                    self.spawn(['rm', f])


tests_require = [
    'fixtures',
    'flake8',
    'testtools',
    ]


setup(
    name='germinate',
    version=germinate_version,
    description='Expand dependencies in a list of seed packages',
    author='Scott James Remnant',
    author_email='scott@ubuntu.com',
    maintainer='Colin Watson',
    maintainer_email='cjwatson@ubuntu.com',
    url='https://wiki.ubuntu.com/Germinate',
    license='GNU GPL',
    packages=find_packages(),
    install_requires=['six'],
    tests_require=tests_require,
    extras_require={'test': tests_require},
    scripts=[
        'bin/germinate',
        'bin/germinate-pkg-diff',
        'bin/germinate-update-metapackage',
        ],
    include_package_data=True,
    data_files=[
        ('share/man/man1', [
            'man/germinate.1',
            'man/germinate-pkg-diff.1',
            'man/germinate-update-metapackage.1',
            ])],
    cmdclass={
        'clean': clean_extra,
        },
    test_suite='germinate.tests',
    # python-apt doesn't build an egg, so we can't use this.
    # install_requires=['apt>=0.7.93'],
    # tests_require=['apt>=0.7.93'],
    )
