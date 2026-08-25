# Minimal NATIVE_THEN_JAVA ASYSMA Example

```text
format = ASYSMA
version = 1
architecture = x86-64
entry_type = NATIVE_THEN_JAVA
native_bootstrap = present
native_architecture = x86-64
native_entry = native/bootstrap
java_runtime = SecureJDK-28
java_entry = application.Main
host_profile = required
icon_family = CMD
icon_revision = four-trimmed-transparent-v2
```

Conceptual package:

```text
header
manifest
integrity
native/x86_64-linux.elf
native/x86_64-windows.exe
native/x86_64-macos
classes/application/Main.class
resources
```

The native component establishes the Direct/host-profile boundary and then explicitly hands off to SecureJDK 28.
