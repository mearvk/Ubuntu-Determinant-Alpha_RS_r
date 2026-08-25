# Minimal JAVA ASYSMA Example

```text
format = ASYSMA
version = 1
architecture = x86-64
entry_type = JAVA
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
classes/application/Main.class
resources
```

The Java compiler produces the `.class` file; the ASYSMA packager produces the final `.asysma` container.
