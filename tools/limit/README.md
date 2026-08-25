# limit

`limit` is a read-only local binary inventory utility for Linux, Windows, and macOS.

It scans the selected directory (non-recursively by default), recognizes common ELF, PE, and Mach-O binaries, and reports metadata fields useful for software provenance review.

## Build

Linux:

```sh
cc -std=c11 -Wall -Wextra -O2 -o limit limit.c
```

Windows (MinGW):

```sh
gcc -std=c11 -Wall -Wextra -O2 -o limit.exe limit.c
```

macOS:

```sh
cc -std=c11 -Wall -Wextra -O2 -o limit limit.c
```

## Use

```sh
./limit .
./limit /usr/local/bin
./limit --version
```

## Metadata contract

The initial implementation reports:

- binary name
- path
- size
- creation date when a portable API supplies it; otherwise explicitly `unavailable`
- modification time where available
- edition
- version
- company
- fiduciary
- metadata source

`edition`, `version`, `company`, and `fiduciary` are intentionally reported as `unavailable` until platform-specific metadata readers are added. The program must never invent these values.

"Registry" is treated as platform metadata rather than one universal database. A future platform adapter can read Windows version resources/registry values, macOS bundle `Info.plist` and LaunchServices metadata, and Linux desktop/package metadata. The scanner is read-only and does not alter registries or application databases.

## Versioning

`limit` starts at **1.00**. Minor implementation changes increment the minor component (`1.00` -> `1.01`); major architectural changes increment the major component.
