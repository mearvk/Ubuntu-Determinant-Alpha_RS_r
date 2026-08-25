# Lessons Learned: Building a New Executable

## Purpose

This record captures the implementation lessons from adding XMC and the self-contained ASYSMA executable path. It is intended to be reused whenever a new native executable, file type, launcher, or compiler-produced application is added.

## 1. Define the executable contract first

An executable is more than a compiled binary. Define, before implementation:

- target operating systems and architectures;
- native executable format or bootstrap strategy;
- input and output file formats;
- embedded metadata and version identity;
- icon and application identity;
- installation locations;
- file-type and application associations;
- permissions and launch requirements;
- upgrade and backward-compatibility behavior.

## 2. Keep the native OS boundary explicit

Linux, Windows, and macOS do not establish launchability in the same way.

- Linux uses executable permissions plus MIME/application registration and `.desktop` integration.
- Windows uses native executable formats plus per-user or system file associations and registry metadata.
- macOS uses executable application bundles, `Info.plist`, document-type declarations, icons, and Launch Services.

A portable C interface can provide one XMC registration API, but each platform implementation must use its native mechanism.

## 3. File association is separate from executability

An icon does not make a file executable. A MIME type does not make a file executable. A desktop entry does not replace a native executable format.

A complete application may therefore require:

```text
native executable/bootstrap
        +
OS launch permissions/mechanism
        +
file-type association
        +
application registration
        +
icon registration
        +
launcher/desktop integration
```

## 4. Registration belongs in the product lifecycle

If a compiler produces an application file, integration with the user's OS should be part of the compiler's packaging contract rather than an undocumented manual step.

XMC therefore treats successful ASYSMA composition and OS registration as related build stages. Registration failures must be visible and must not be represented as successful integration.

Registration should normally be user-scoped and should not silently request administrator/root privileges.

## 5. Use stable installed resources

Generated launchers must not depend on source-tree or build-tree paths such as `tools/xmc/xmc-icon.svg`.

Installed applications should reference stable installed resources, for example:

```text
xmc-asysma
xmc-asysma.svg
application/x-asysma
```

This prevents an application from losing its icon or association when the compiler source directory moves or is removed.

## 6. Make the build strict

New C components should compile under the repository warning contract:

```text
-Wall -Wextra -Werror -O2 -std=c11
```

Warnings such as `misleading-indentation` should be fixed in the source rather than suppressed. Small ambiguous statements such as:

```c
if (condition) return -1; value = 0;
```

should be written as separate, clearly scoped statements.

## 7. Put every required component in the Make build

Adding a source file to the repository is not sufficient. The Makefile must:

1. list the source/header dependency;
2. compile the component;
3. link it into the appropriate executable;
4. install required runtime resources;
5. clean generated artifacts;
6. provide a test path.

For XMC, the OS registration helper is therefore linked into the public `xmc` executable rather than remaining a disconnected utility.

## 8. Test the whole user path

A successful compiler invocation is not enough. Test:

```text
source input
  -> compilation
  -> packaging
  -> executable/ASYSMA creation
  -> OS registration
  -> icon resolution
  -> desktop/file-manager visibility
  -> launch
  -> native loader
  -> application execution
```

Test on each supported OS because registration behavior is platform-specific.

## 9. Preserve failure boundaries

Do not hide missing dependencies or silently substitute an external runtime when the product contract says the artifact is self-contained.

If an ASYSMA artifact does not contain the required native execution payload, the bootstrap should report that fact explicitly instead of claiming standalone execution.

## 10. Keep metadata authoritative

Executable metadata should have one authoritative representation where practical. Edition, version, company, creation/build date, fiduciary or provenance fields, target platform, and payload information should be generated consistently rather than manually duplicated across unrelated files.

## 11. Installation must match compilation

If compilation generates a resource that depends on an installed component, the installer must provide that component. Conversely, a self-contained artifact must not require the user to visit a website or install an unrelated runtime merely to open the artifact.

## 12. Version every meaningful change

XMC uses the project's versioning contract. Major changes increment the major component; minor compiler/code improvements increment the minor component. Changes to the executable container, metadata, OS registration, or launch contract should be recorded so users and build systems can identify the resulting artifact generation.

## 13. Record the lesson in source documentation

Every new executable should have an appropriate README and, where required by the repository's 1-2-3-4 documentation system, corresponding specification/provenance records. Implementation decisions that affect execution, installation, security, or compatibility should be documented at the same time as the source change.

## Completion checklist

- [ ] Native execution format defined.
- [ ] Target OS/architecture defined.
- [ ] Metadata contract defined.
- [ ] Icon resource installed at a stable path.
- [ ] File association implemented per OS.
- [ ] Application registration implemented per OS.
- [ ] Permissions/launch mechanism implemented per OS.
- [ ] Registration linked into the normal compiler build.
- [ ] Build passes `-Wall -Wextra -Werror`.
- [ ] Clean build tested.
- [ ] Installer updated.
- [ ] User launch path tested.
- [ ] README and 1-2-3-4 records updated.
- [ ] Version/provenance recorded.
