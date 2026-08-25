# GNU GCC source archive

This directory reserves a local source-archive location for the GNU Compiler Collection (GCC) used by the repository's toolchain work.

## Source release

The selected release is **GCC 16.2.0**, released August 7, 2026. GCC identifies its release downloads as source releases. urlGCC release informationhttps://gcc.gnu.org/releases.html

Download the official complete source archive from the GCC release mirror:

`gcc-16.2.0.tar.xz`

The official GCC release announcement confirms GCC 16.2 and points to the release download directory. urlGCC 16.2 release announcementhttps://gcc.gnu.org/pipermail/gcc/2026-August/248711.html

## Local download

From the repository root:

```sh
mkdir -p tools/gcc
cd tools/gcc
curl -LO https://gcc.gnu.org/pub/gcc/releases/gcc-16.2.0/gcc-16.2.0.tar.xz
```

If your mirror redirects the download, use the corresponding official GCC mirror listed by the GCC project.

## Verify

After downloading, verify that the archive is the expected GCC 16.2.0 release before extraction. Keep the archive in `tools/gcc/` if you intend to commit it yourself.

## Extract

```sh
tar -xJf gcc-16.2.0.tar.xz
```

This should create:

```text
tools/gcc/gcc-16.2.0/
```

containing the actual GCC source tree.

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

The archive and extracted source are intentionally left for the repository owner to download, verify, extract, and push. This avoids silently importing a very large third-party source tree through ordinary source-file commits.

See `SOURCE-VERSION` for the pinned source release identity.
