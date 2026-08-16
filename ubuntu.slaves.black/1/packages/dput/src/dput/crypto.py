# dput/crypto.py
# Part of ‘dput’, a Debian package upload toolkit.
#
# This is free software, and you are welcome to redistribute it under
# certain conditions; see the end of this file for copyright
# information, grant of license, and disclaimer of warranty.

""" Cryptographic and hashing functionality. """

import sys

import gpg
import gpg.results


class SignatureVerifyError(RuntimeError):
    """ Exception raised when the signature verification returns an error. """


def characterise_signature(signature):
    """ Make a phrase characterising a GnuPG signature.

        :param signature: A `gpg.results.Signature` instance.
        :return: A simple text phrase characterising the `signature`.

        * If the signature is valid, the result is "valid".
        * If the signature is not valid, but is good, the result is
          "good".
        * If the signature is not good, the result is "bad".

        """
    if (signature.summary & gpg.constants.SIGSUM_VALID):
        text = "valid"
    elif (signature.summary & gpg.constants.SIGSUM_RED):
        text = "bad"
    elif (signature.summary & gpg.constants.SIGSUM_GREEN):
        text = "good"
    else:
        raise SignatureVerifyError(signature.summary)

    return text


def describe_signature(signature):
    """ Make a message describing a GnuPG signature.

        :param signature: A `gpg.result.Signature` instance.
        :return: A text description of the salient points of the
            `signature`.

        The description includes the signature's character (whether it
        is valid, good, or bad); and the key ID used to create the
        signature.

        """
    fpr_length = 16

    character = "UNKNOWN"

    error = None
    try:
        character = characterise_signature(signature)
    except SignatureVerifyError as exc:
        error = exc
        text_template = (
            "Error checking signature from {fpr}:"
            " {error.__class__.__name__}: {error}")
    else:
        text_template = "{character} signature from {fpr}"

    text = text_template.format(
            error=error,
            character=character.title(),
            fpr=signature.fpr[-fpr_length:])

    return text


def check_file_signature(infile):
    """ Verify the GnuPG signature on a file.

        :param infile: The file containing a signed message.
        :return: ``None``.
        :raise gpg.errors.GPGMEError: When the signature verification fails.

        The `infile` is a file-like object, open for reading, that
        contains a message signed with OpenPGP (e.g. GnuPG).

        """
    context = gpg.Context()
    try:
        with infile:
            (_, verify_result) = context.verify(infile)
    except gpg.errors.GPGMEError as exc:
        sys.stderr.write("gpg: {path}: error {code}: {message}\n".format(
                path=infile.name, code=exc.getcode(), message=exc.message))
        raise

    for signature in verify_result.signatures:
        description = describe_signature(signature)
        sys.stderr.write(
                "gpg: {path}: {description}\n".format(
                    path=infile.name, sig=signature, description=description))


# Copyright © 2016–2021 Ben Finney <bignose@debian.org>
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


# Local variables:
# coding: utf-8
# mode: python
# End:
# vim: fileencoding=utf-8 filetype=python :
