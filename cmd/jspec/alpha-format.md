# `.alpha` — JSpec Native Executable Format

`.alpha` is the JSpec Professional native executable name. On Linux v1, an `.alpha` file is an ordinary **ELF executable whose filename uses the `.alpha` extension**. This preserves the OS executable contract: the kernel sees ELF, while JSpec and the `/cmd` icon/link system see the `.alpha` identity first.

## Goals

- minimal launch overhead
- deterministic identity and handoff
- direct OS execution rather than shell interpretation
- one executable representation understood by JSpec preflight and desktop linking
- preservation of argv, environment, working directory, stdio, and exit status
- no resident runtime unless explicitly requested

## Runtime model

`cmd icon/link -> JSpec pre-runner -> .alpha ELF -> OS loader -> target`

An `.alpha` may itself be a JSpec launcher, or it may be a native program carrying an embedded JSpec identity marker. The first implementation uses the simpler launcher form: the binary is ELF and delegates directly to the configured target.

## Identification

JSpec recognizes `.alpha` by filename/desktop metadata and verifies the Linux binary header as ELF before execution. The extension is descriptive; the kernel's executable format remains authoritative.

## Weight and congruency

The format deliberately adds no custom binary container around ELF in v1. This avoids a second loader, duplicate headers, and unnecessary resident code. The `.alpha` contract is therefore lightweight: native ELF + JSpec launch metadata + direct OS handoff.

## Windows direction

The same public identity can later be represented by a PE/COFF binary named `.alpha` or by an `.alpha` launcher that resolves a PE `.exe`. The JSpec contract remains stable while the native loader changes.
