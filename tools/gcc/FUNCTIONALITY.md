# GCC Functionality Review

## Purpose

`tools/gcc` is the repository's pinned GNU Compiler Collection (GCC) source and acquisition area. It is distinct from `tools/xgcc`, which contains the repository's separate XGCC userspace/kernel-interpreter implementation.

The current GCC integration pins **GCC 16.2.0**, released 2026-08-07. The repository records that identity in `SOURCE-VERSION` and uses `gcc-16.2.0.tar.xz` as the source archive. fileciteturn3file0

## Current functionality

### 1. Source acquisition

`download-gcc.sh` downloads the pinned official GCC source archive from the GNU GCC release server. It supports `curl` and `wget`, refuses to overwrite an existing extracted source directory, and fails if neither download utility is available. fileciteturn4file0

### 2. Integrity verification

The download path calculates SHA-256 for the archive, retrieves the GCC release checksum file, locates the checksum for the exact archive, compares the expected and actual digests, and records the verified digest in `gcc-16.2.0.sha256`. Extraction is not performed after a failed checksum comparison. fileciteturn4file0

### 3. Controlled extraction

`extract-gcc.sh` provides a separate extraction path for an archive that is already present. When the repository has a recorded local SHA-256 file, the script verifies the archive before extraction. It also refuses to overwrite an existing `gcc-16.2.0` directory. fileciteturn5file0

### 4. Out-of-tree build convention

The existing README correctly directs builds away from the GCC source tree and gives a separate `tools/gcc-build` example. This keeps generated build artifacts separate from the source archive and is the appropriate structure for repeatable GCC builds. fileciteturn2file0

### 5. Source provenance

The current documentation identifies the source as the official GNU Compiler Collection release and links to the GCC release information and release announcement. The repository therefore has a clear distinction between upstream GCC source and repository-owned integration scripts. fileciteturn2file0

## Functional boundary

At the repository level, `tools/gcc` currently provides **source acquisition, provenance, checksum verification, extraction, and build guidance**. It does not itself provide a custom GCC compiler frontend, backend, or code-generation modification in the files reviewed here.

The actual GCC compiler functionality remains the functionality supplied by the pinned upstream GCC 16.2.0 source. A production compiler build still requires selecting an appropriate host/target configuration and configure options; the repository's README intentionally does not claim a universal production configuration. fileciteturn2file0

## Relationship to XGCC

Do not treat `tools/xgcc` as the GCC source tree. `tools/xgcc/xgcc.c` is a separate command-line program that reads C/C++ source, enforces a 4 MiB input limit, opens `/dev/xgcc`, submits the source to the kernel-resident XGCC implementation, and can report `/proc/xgcc/status`. Its documented options include model selection, verbose execution, and status reporting. fileciteturn6file0

This distinction should remain explicit in future documentation and build scripts:

- **GCC:** upstream GNU compiler source and conventional compiler build.
- **XGCC:** repository-specific userspace/kernel source interpreter and execution pipeline.

## Review findings

The GCC acquisition layer is reasonably well structured for a pinned source dependency. The strongest existing properties are:

1. explicit version pinning;
2. official upstream source URL;
3. SHA-256 verification before normal extraction;
4. refusal to overwrite an existing extraction;
5. separate-source/build guidance;
6. explicit provenance documentation.

The main remaining engineering work is not basic download functionality. It is to define and test a reproducible **build contract** for each supported host/target, including configure flags, prerequisites, installation prefix, compiler bootstrap requirements, build/test commands, and artifact validation.

## Recommended next pass

Before calling the GCC integration production-ready, add a documented build/test procedure that records:

- supported host operating systems and architectures;
- supported target triples;
- exact configure invocation;
- required bootstrap compiler and system dependencies;
- deterministic build environment variables where appropriate;
- `make`/test-suite commands and expected results;
- installation layout;
- compiler version and target verification commands;
- generated artifact checksums;
- failure handling and cleanup behavior.

No claim of successful compilation or test-suite execution should be made until those commands have actually been run in a supported environment.
