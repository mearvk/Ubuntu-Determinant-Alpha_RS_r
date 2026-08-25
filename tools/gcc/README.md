# GNU GCC source archive

This directory reserves a local source-archive location for the GNU Compiler Collection (GCC) used by the repository's toolchain work.

## Source release

The selected release is **GCC 16.2.0**, released August 7, 2026. GCC identifies its release downloads as source releases. urlGCC release informationhttps://gcc.gnu.org/releases.html

## One-command download and extraction

Run:

```sh
cd tools/gcc
./download-gcc.sh
```

The script downloads the official GCC 16.2.0 source archive, obtains the official release checksum, verifies SHA-256, records the verified digest in `gcc-16.2.0.sha256`, and extracts:

```text
tools/gcc/gcc-16.2.0/
```

The script refuses to overwrite an existing extracted source tree.

## Manual download

The equivalent archive is:

```text
gcc-16.2.0.tar.xz
```

from the official GCC release directory. urlGCC 16.2 release announcementhttps://gcc.gnu.org/pipermail/gcc/2026-August/248711.html

## Build convention

Do not configure GCC by writing build output into the source directory. GCC's build documentation recommends a separate build directory. Use, for example:

```sh
mkdir -p tools/gcc-build
cd tools/gcc-build
../gcc/gcc-16.2.0/configure --prefix="$PWD/install"
make -j"$(nproc)"
```

The exact configure options should be selected for the host and intended target before a production build.

## Repository policy

The archive and extracted source are intentionally left for the repository owner to download, verify, extract, review, and push. This avoids silently importing a very large third-party source tree through ordinary source-file commits.

See `SOURCE-VERSION` for the pinned source release identity.
