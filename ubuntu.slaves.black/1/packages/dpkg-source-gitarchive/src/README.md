# dpkg source format for git repositories

Defines an additional dpkg source format for use with plain git repositories.
It can be used by specifying the correct value in `debian/source/format`.

## Format: `3.0 (gitarchive)`

This format doesn't represent a real source package format,
but uses a plain git repository as input to create a `3.0 (quilt)` source package that the Debian archive accepts.

### Pre-conditions

* The git tree must not contain `debian/patches`, instead all Debian patches are applied as git commits.
* Original tarballs needs to be managed with `pristine-lfs`.
* Tags for upstream sources called `upstream/$version` need to exist.

### Building

The original tarball is extracted from the git repository using `pristing-lfs`.
The debian tarball is generated from the `debian/` directory of the current head
plus a patch for the changes between the upstram tag and the current head.
A `3.0 (quilt)` source package is produced from this tarballs.

#### Creating orig tar

`--commit`:
Generates the orig tar from the upstream ref and records it with `pristine-lfs`.

#### Build options

No build options exists currently.
