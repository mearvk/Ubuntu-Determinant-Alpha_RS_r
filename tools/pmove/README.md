# pmove — Parallel Move

`pmove` is the move-mode entry point for the parallel copy/move tool in this repository.

The implementation is intentionally shared with `tools/pcopy`: the executable detects whether it was invoked as `pcopy` or `pmove` and selects copy or move semantics accordingly. The move path enables `PCOPY_F_MOVE` and cross-device handling.

## Installation

Build and install from `tools/pcopy`:

```bash
cd tools/pcopy
make
sudo make install
```

The Makefile installs `pcopy` and creates the `pmove` command as a symlink to the same executable.

## Usage

```bash
pmove [options] <source...> <destination>
pmove -p old/ new/
pmove -j 8 -p source/ /mnt/backup/
pmove --status
```

Supported options are the same as `pcopy`, including `-j`, `-c`, `-s`, `-p`, `-f`, `-v`, `-n`, and `--status`.

## Repository status

`pmove` was previously documented and implemented through `tools/pcopy`, but there was no separate `tools/pmove` directory on `main`. This directory makes the move operation explicitly selectable under `/tools` without duplicating the implementation.

Copyright (C) 2026 MEARVK LLC
