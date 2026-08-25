# JDesk ASYSMA Validation Matrix

## Structural

- [ ] Magic and version recognized.
- [ ] Header offsets are bounds checked.
- [ ] Integer arithmetic cannot wrap into a valid-looking range.
- [ ] Manifest entry type is recognized.
- [ ] Native and Java payload declarations agree with the selected entry type.

## Native

- [ ] Linux ELF bootstrap loads on supported x86-64 baseline.
- [ ] Windows PE/COFF bootstrap loads on supported x86-64 baseline.
- [ ] macOS Mach-O bootstrap loads on supported x86-64 baseline.
- [ ] Unsupported CPU feature requirements are rejected.
- [ ] x86-64-v3 payload is not executed on a CPU lacking v3 support.

## Java

- [ ] SecureJDK 28 requirement is resolved.
- [ ] Java entry is present.
- [ ] Native-to-Java handoff is validated.
- [ ] Java startup receives only the documented handoff data.

## Security

- [ ] Integrity is checked before native application execution.
- [ ] Policy is evaluated before application execution.
- [ ] No privilege escalation is performed by the ASYSMA launcher.
- [ ] Normal OS termination remains effective.
- [ ] Failure paths return controlled errors rather than attempting fallback execution.

## Desktop

- [ ] JDesk starts through the Java entry.
- [ ] CMD-origin icon metadata resolves correctly.
- [ ] Existing JDesk native services remain functional.
- [ ] Existing JDesk installation behavior remains compatible.
