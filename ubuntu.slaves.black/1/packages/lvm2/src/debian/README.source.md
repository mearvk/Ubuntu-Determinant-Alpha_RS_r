# Source handling for lvm2

This source uses the `3.0 (gitarchive)` source format in the git repository.

## Building a Debian source package from git

* Install `dpkg-source-gitarchive`.
  This is not a build-dependency, as it is only required to build the source, not binaries.
* Run `dpkg-buildpackage -S -nc` (or `dpkg-source --build .`).
