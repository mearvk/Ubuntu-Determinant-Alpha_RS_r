# Source handling

## Building a Debian source package from git

No patches are stored inside the repository, but are built on request.
A `3.0 (quilt)` format source package for upload to Debian is created with the following comamnd:

```
make -f debian/rules git-source
```

## Building a orig tar from git

The orig tars are maintained by pristine-lfs and generated from upstream release tags.
New ones are generated with the following command:

```
dch -v 2.2.45-1
make -f debian/rules git-orig
```
