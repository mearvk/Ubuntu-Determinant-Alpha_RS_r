# Windows Ecosystem Support

The project is Linux-first in its native implementation, but Windows is a supported deployment surface where the underlying concept has a Windows equivalent.

## Compatibility rule

The project should preserve its semantic contract while adapting its mechanism to the host operating system. Do not emulate Linux internals merely to claim Windows support.

| Project surface | Linux | Windows |
|---|---|---|
| Executable format | ELF | PE/COFF (`.exe`, DLL) |
| Native libraries | `.so` | `.dll` |
| Service manager | systemd where present | Windows Service Control Manager |
| Scheduled execution | cron/systemd timers | Task Scheduler |
| Process/resource evidence | `/proc`, cgroups, PSI where available | Win32 APIs, performance counters, Job Objects, service APIs |
| Environment | POSIX environment | Windows environment / registry-backed configuration where appropriate |
| Package/install source | apt/dpkg and project adapters | WinGet, MSI, MSIX, project installers, or direct signed artifacts |
| Shell integration | sh/bash | PowerShell / `cmd.exe` |
| Java runtime | JDK/JRE | Windows JDK/JRE distributions |
| Path conventions | `/usr`, `/opt`, etc. | `%ProgramFiles%`, `%LOCALAPPDATA%`, `%ProgramData%` |

## Installer policy

Installers are a first-class consideration, but installation must remain conservative and auditable.

A Windows installer should:

1. identify the artifact and verify SHA-256/signature information;
2. establish architecture and ABI compatibility (normally x64 or ARM64 as applicable);
3. resolve required DLL and runtime dependencies;
4. distinguish per-user from machine-wide installation;
5. propose `PATH` and `JAVA_HOME` changes rather than silently overwriting them;
6. detect Windows services and Task Scheduler opportunities;
7. request elevation only when the selected operation actually requires it;
8. install atomically and preserve rollback information;
9. register uninstall metadata correctly when applicable;
10. retain an installation evidence record.

The prototype Windows adapter is `aptitude/src/aptitude.ps1`. It intentionally defaults to inspection/planning and does not silently create services, scheduled tasks, registry entries, or machine-wide changes.

## Native Windows integration

Future native adapters should use Windows APIs directly rather than assuming `/proc`, `systemctl`, `cron`, POSIX permissions, or Linux filesystem layouts. Appropriate adapters include:

- Service Control Manager for long-running services;
- Task Scheduler for scheduled execution;
- Job Objects for process/resource grouping;
- Windows Event Log for service/application evidence;
- Windows Registry only where registry state is actually the native configuration surface;
- Authenticode and/or other applicable signature mechanisms for executable provenance;
- Win32/NT APIs for process, memory, handle, and system evidence;
- standard Windows DLL loading and search-path rules with explicit dependency validation.

The security model remains the same: **identity → provenance → validation → authorization → action → observation**.

## CI expectation

Windows builds should be exercised in GitHub Actions alongside Linux builds whenever a component has a meaningful Windows implementation. Platform-specific failures should be isolated to platform adapters rather than weakening the common semantic contract.
