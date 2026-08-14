# NAME

autodep8 - DEP-8 test control file generator

# DESCRIPTION

autodep8 will detect well-known types of packages and generate
DEP-8-compliant test control files for them. It can be used by DEP-8
implementations to support implicit test control files.

# USAGE

    $ autodep8                 # assumes source package in current dir
    $ autodep8 /path/to/srcpkg # path to source package

If a known package type is detected, autodep8 exits with 0 and prints the
suggested contents of debian/tests/control to the standard output.

If a known package type is NOT detected, autodep8 exits with 1 and
produces not output.

# AUTOMATIC USAGE BY AUTOPKGTEST

autodep8 can be automatically called by autopkgtest(1). To achieve that, you
must set the *Testsuite:* field in the source package paragraph to
*autopkgtest-pkg-TYPE*, where *TYPE* if one of package types supported by
autodep8. The valid values of *TYPE* are listed below as the headings of the
"EXAMPLES OF PRODUCED TEST CONTROL FILES" section.

See the autopkgtest(1) documentation for more details.

# HOW THE PACKAGE TYPE IS DETECTED

**autodep8** will first look for *Testsuite: autopkgtest-pkg-TYPE* field in
*debian/control*. if *TYPE* is a known package type, then that is used. If not,
each supported package type is tried against a set of heuristics, based on
packages names, build dependencies. specific files under debian/, or a
combination of those.

# PACKAGE-SPECIFIC CONFIGURATION

Packages can provide configuration for **autodep8** in
*debian/tests/autopkgtest-pkg-${PACKAGETYPE}.conf*. The file format is the
following:

```
# comment lines start with # and are ignored.
# note that #'s only mark comments when in the beginning of the line
# empty lines are also ignored

# values are set in this format:
var1=value1

# spaces around the = sign are allowed
var2 = value 2

# backslashes allow one to set values that span multiple lines.
# Note that the newline is removed in the final value, though
# The following is equivalent to "multiline=value1, value2"
variable = value1, \
value2
```

The following configuration variables are supported:

## All package types

**extra_depends**: extra test dependencies to be added to the generated tests.
Will be included as-is in the generated control file.

**extra_restrictions**: extra restrictions to be added to the generated tests.
Will be included as-is in the generated control file.

## octave (debian/tests/autopkgtest-pkg-octave.conf)

**test_env**: value for the DH_OCTAVE_TEST_ENV environment variable
that will be used when invoking dh_octave_check. The default value
of DH_OCTAVE_TEST_ENV is "xvfb -a".

## python (debian/tests/autopkgtest-pkg-python.conf)

**import_name**: name of the module to import, if it cannot be inferred from
the name of the Debian package. For example, `python3-xlib` is used via `import
Xlib`, so `import_name = Xlib` would be appropriate.  This used to be
configured by writing to `debian/tests/pkg-python/import-name`, but that is now
deprecated.

# COMBINING AUTO-GENERATED TESTS WITH MANUALLY SPECIFIED ONES

If `debian/tests/control` exists, autodep8 will prepend the contents of that
file to its own output. In that case, autodep8 will exit with a status of 0
even if no known package type is detected. The same applies for
`debian/tests/control.autodep8`, but the use of that file is deprecated because
the test dependencies defined there aren't processed by dpkg-source.

# EXAMPLES OF PRODUCED TEST CONTROL FILES

See [examples.md](examples.md).

# COPYRIGHT

Copyright (c) 2014 by the contributing authors. See `git log` for details.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.

