#!/usr/bin/python3

from distutils.core import setup
from DistUtilsExtra.command import (build_extra, build_i18n)
import glob

setup(
    name='command-not-found',
    version='0.3',
    packages=['CommandNotFound', 'CommandNotFound.db'],
    scripts=['command-not-found', 'cnf-update-db'],
    cmdclass={"build": build_extra.build_extra,
                "build_i18n": build_i18n.build_i18n,
                },
    data_files=[
        ('share/command-not-found/', glob.glob("data/*.db")),
        ('../etc', ['bash_command_not_found', 'zsh_command_not_found']),
        ('../etc/apt/apt.conf.d', ['data/50command-not-found']),
    ])
