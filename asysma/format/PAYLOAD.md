# ASYSMA Payload v1

An ASYSMA package may carry multiple native representations and a managed application payload.

Initial conceptual layout:

```text
payload/
  x86_64-linux.elf
  x86_64-windows.exe
  x86_64-macos
  java/
  resources/
```

The actual container stores byte ranges rather than requiring these directory names to appear literally.

## Native payload

The native payload is the smallest practical bootstrap. It establishes the Direct handoff and host-profile boundary; it should not contain ordinary application logic.

## Managed payload

The Java payload is started only after the ASYSMA policy and integrity gates succeed. SecureJDK 28 is the reference runtime for the initial profile.

## Platform rule

A native OS loader still receives its native executable representation. The ASYSMA container is a higher-level package and does not replace ELF, PE/COFF, or Mach-O.
