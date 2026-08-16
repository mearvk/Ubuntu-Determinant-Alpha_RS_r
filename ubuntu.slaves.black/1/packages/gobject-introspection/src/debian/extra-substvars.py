#!/usr/bin/python3
# Copyright 2021 Simon McVittie
# SPDX-License-Identifier: MIT

'''
Inspect libffi-dev:$DEB_HOST_ARCH and print the corresponding library ABI
name, e.g. "gobjectintrospection:libffiN=libffi8".
'''

import os
import subprocess

import debian.deb822

if __name__ == '__main__':
    deb_host_arch = os.environ['DEB_HOST_ARCH']

    result = subprocess.run(
        ['dpkg-query', '-s', 'libffi-dev:' + deb_host_arch],
        stdout=subprocess.PIPE,
        check=True,
    )
    stanza = result.stdout.decode('utf-8')      # type: ignore
    fields = debian.deb822.Packages(stanza)

    libffiN = ''

    for dependency in fields.relations['depends']:
        for alternative in dependency:
            if (
                alternative['name'].startswith('libffi')
                and alternative['name'][6].isdigit()
            ):
                if libffiN != '':
                    raise AssertionError(
                        'More than one libffiN dependency in libffi-dev'
                    )

                libffiN = alternative['name']

    if not libffiN:
        raise AssertionError(
            'No libffiN dependency in libffi-dev'
        )

    print('gobjectintrospection:libffiN=' + libffiN)
