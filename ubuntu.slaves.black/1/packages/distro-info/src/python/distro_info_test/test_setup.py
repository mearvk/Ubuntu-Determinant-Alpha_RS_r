# Copyright (C) 2022, Benjamin Drung <bdrung@debian.org>
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH
# REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY
# AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT,
# INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM
# LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.

"""Test functions in setup.py."""

import unittest
import unittest.mock

from setup import make_pep440_compliant


class SetupTestCase(unittest.TestCase):
    """Test functions in setup.py."""

    def test_make_pep440_compliant_unchanged(self) -> None:
        """Test make_pep440_compliant() with already correct version."""
        self.assertEqual(make_pep440_compliant("1.2"), "1.2")

    def test_make_pep440_compliant_debian_backport(self) -> None:
        """Test make_pep440_compliant() with Debian backport version."""
        self.assertEqual(make_pep440_compliant("0.21~bpo9+1"), "0.21+bpo9.1")

    def test_make_pep440_compliant_debian_stable(self) -> None:
        """Test make_pep440_compliant() with Debian stable update."""
        self.assertEqual(make_pep440_compliant("2.21.3+deb11u1"), "2.21.3+deb11u1")

    def test_make_pep440_compliant_debian_stable_backport(self) -> None:
        """Test make_pep440_compliant() with Debian stable backport."""
        self.assertEqual(make_pep440_compliant("2.21.3+deb11u1~bpo10+1"), "2.21.3+deb11u1.bpo10.1")

    def test_make_pep440_compliant_tilde(self) -> None:
        """Test make_pep440_compliant() with tilde in Debian version."""
        self.assertEqual(make_pep440_compliant("0.175~18.04.3"), "0.175+18.04.3")

    def test_make_pep440_compliant_ubuntu(self) -> None:
        """Test make_pep440_compliant() with Ubuntu version."""
        self.assertEqual(make_pep440_compliant("1.1ubuntu1"), "1.1+ubuntu1")

    def test_make_pep440_compliant_ubuntu_backport(self) -> None:
        """Test make_pep440_compliant() with Ubuntu backport version."""
        self.assertEqual(
            make_pep440_compliant("2.22.1ubuntu1~bpo20.04.1"), "2.22.1+ubuntu1.bpo20.04.1"
        )

    def test_make_pep440_compliant_ubuntu_security(self) -> None:
        """Test make_pep440_compliant() with Ubuntu security update."""
        self.assertEqual(make_pep440_compliant("2.17.12ubuntu1.1"), "2.17.12+ubuntu1.1")
