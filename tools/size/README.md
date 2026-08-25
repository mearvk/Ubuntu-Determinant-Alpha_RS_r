# size

`size` is a small native C utility for quickly reporting the recursive logical size of a file, directory, or directory tree.

## Behavior

For a directory, `size` walks all files and nested directories beneath the supplied parent and sums the byte length of regular files. Directory entries themselves are not counted.

It reports both exact bytes and a human-readable binary-unit value:

```text
$ ./size tools/xmc
 tools/xmc: 184320 bytes (180.00 KiB)
```

The utility accepts multiple paths:

```text
size tools/xmc tools/gcc tools/limit
```

Useful options:

```text
size --help
size --version
```

The initial version is **1.00**.

## Platform behavior

The implementation is intended for Linux, Windows, and macOS.

- Linux/macOS use POSIX `lstat` and directory traversal.
- POSIX symbolic links are not followed.
- Windows uses the native file enumeration APIs.
- Windows reparse points are not recursively followed, preventing directory-junction cycles.
- The reported value is **logical file size**, not allocated filesystem blocks.

This distinction matters: filesystem allocation can be larger than the sum of file lengths because of block size, sparse files, compression, metadata, snapshots, or filesystem-specific storage behavior.

## Build

Linux/macOS:

```sh
cc -std=c11 -Wall -Wextra -O2 -o size size.c
```

Windows with MSVC:

```bat
cl /W4 /O2 size.c
```

Windows with MinGW/GCC:

```sh
gcc -std=c11 -Wall -Wextra -O2 -o size.exe size.c
```

## Scope

`size` intentionally remains a read-only measurement utility. It does not modify files, follow arbitrary links, or delete/trim data. It complements `limit`: `limit` describes executable identity and metadata, while `size` measures the logical byte extent of a filesystem tree.
