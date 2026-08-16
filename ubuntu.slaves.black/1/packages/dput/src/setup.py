# setup.py
# Part of ‘dput’, a Debian package upload toolkit.
#
# This is free software, and you are welcome to redistribute it under
# certain conditions; see the end of this file for copyright
# information, grant of license, and disclaimer of warranty.

""" Distribution setup for ‘dput’ library. """

import email.utils
import os
import os.path
import pydoc
import re
import unittest

import debian.changelog
import debian.copyright
import debian.deb822
from setuptools import (
        find_packages,
        setup,
        )


def make_pep440_compliant(version: str) -> str:
    """Convert the version into a PEP440 compliant version."""
    public_version_re = re.compile(
        r"^([0-9][0-9.]*(?:(?:a|b|rc|.post|.dev)[0-9]+)*)\+?"
    )
    _, public, local = public_version_re.split(version, maxsplit=1)
    if not local:
        return version
    sanitized_local = re.sub("[+~]+", ".", local).strip(".")
    pep440_version = f"{public}+{sanitized_local}"
    assert re.match(
        "^[a-zA-Z0-9.]+$", sanitized_local
    ), f"'{pep440_version}' not PEP440 compliant"
    return pep440_version


setup_dir = os.path.dirname(__file__)

readme_file_path = os.path.join(setup_dir, "README")
with open(readme_file_path) as readme_file:
    (synopsis, long_description) = pydoc.splitdoc(readme_file.read())

changelog_file_path = os.path.join(setup_dir, "debian", "changelog")
with open(changelog_file_path) as changelog_file:
    changelog = debian.changelog.Changelog(changelog_file, max_blocks=1)
(author_name, author_email) = email.utils.parseaddr(changelog.author)

control_file_path = os.path.join(setup_dir, "debian", "control")
with open(control_file_path) as control_file:
    control_structure = debian.deb822.Deb822(control_file)
(maintainer_name, maintainer_email) = email.utils.parseaddr(
        control_structure['maintainer'])

copyright_file_path = os.path.join(setup_dir, "debian", "copyright")
with open(copyright_file_path) as copyright_file:
    copyright_structure = debian.copyright.Copyright(copyright_file)
general_files_paragraph = copyright_structure.find_files_paragraph("*")
license = general_files_paragraph.license


def test_suite():
    """ Make the test suite for this code base. """
    loader = unittest.TestLoader()
    suite = loader.discover(os.path.curdir, pattern='test_*.py')
    return suite


setup_kwargs = dict(
        name=changelog.package,
        version=make_pep440_compliant(str(changelog.version)),
        packages=find_packages(exclude=["test"]),

        # Setuptools metadata.
        maintainer=maintainer_name,
        maintainer_email=maintainer_email,
        zip_safe=False,
        setup_requires=[
            "python-debian",
            ],
        test_suite="setup.test_suite",
        tests_require=[
            "testtools",
            "testscenarios >=0.4",
            # The ‘pkg_resources’ library is not yet distributed separately,
            # see <URL:https://github.com/PyPA/setuptools/issues/863>.
            # "pkg_resources",
            "python-debian",
            "gpg",
            ],
        install_requires=[
            # The ‘pkg_resources’ library is not yet distributed separately,
            # see <URL:https://github.com/PyPA/setuptools/issues/863>.
            # "pkg_resources",
            "python-debian",
            "gpg",
            ],
        entry_points={
            'console_scripts': [
                "execute-dput = dput.dput:main",
                "execute-dcut = dput.dcut:dcut",
                ],
            },

        # PyPI metadata.
        author=author_name,
        author_email=author_email,
        description=synopsis,
        license=license.synopsis,
        keywords="debian package upload test".split(),
        url=control_structure['homepage'],
        long_description=long_description,
        classifiers=[
            # Reference: <URL:https://pypi.org/classifiers/>
            "Development Status :: 5 - Production/Stable",
            "License :: OSI Approved :: GNU General Public License",
            "Operating System :: POSIX",
            "Programming Language :: Python :: 3",
            "Intended Audience :: Developers",
            "Topic :: Software Development :: Build Tools",
            ],
        )


if __name__ == '__main__':
    setup(**setup_kwargs)


# Copyright © 2008–2021 Ben Finney <ben+python@benfinney.id.au>
#
# This is free software: you may copy, modify, and/or distribute this work
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; version 3 of that license or any later version.
# No warranty expressed or implied. See the file ‘LICENSE.GPL-3’ for details.


# Local variables:
# coding: utf-8
# mode: python
# End:
# vim: fileencoding=utf-8 filetype=python :
