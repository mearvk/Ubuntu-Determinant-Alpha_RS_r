# Copyright (C) 2012, Benjamin Drung <bdrung@debian.org>
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

"""Common parsing and utility functions"""

import argparse
import datetime
import os
import sys


def convert_date(string):
    """Convert a date string in ISO 8601 into a datetime object."""
    if not string:
        date = None
    else:
        parts = [int(x) for x in string.split("-")]
        if len(parts) == 3:
            (year, month, day) = parts
            date = datetime.date(year, month, day)
        else:
            raise ValueError("Date not in ISO 8601 format.")
    return date


def main(validation_function):
    """Main function with command line parameter parsing."""
    script_name = os.path.basename(sys.argv[0])
    usage = "%s [-h] -d|-u csv-file" % (script_name)
    parser = argparse.ArgumentParser(usage=usage)

    parser.add_argument(
        "-d",
        "--debian",
        dest="debian",
        action="store_true",
        default=False,
        help="validate a Debian CSV file",
    )
    parser.add_argument(
        "-u",
        "--ubuntu",
        dest="ubuntu",
        action="store_true",
        default=False,
        help="validate an Ubuntu CSV file",
    )
    parser.add_argument("csv_file", metavar="csv-file", help="CSV file to validate")

    args = parser.parse_args()
    if len([x for x in [args.debian, args.ubuntu] if x]) != 1:
        parser.error("You have to select exactly one of --debian, --ubuntu.")

    if args.debian:
        distro = "debian"
    else:
        distro = "ubuntu"

    return int(not validation_function(args.csv_file, distro))
