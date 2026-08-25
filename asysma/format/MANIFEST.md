# ASYSMA Manifest v1

The manifest describes the package without executing its payload.

## Initial fields

```text
format = ASYSMA
version = 1
architecture = x86-64
minimum_direct_revision = 1
native_bootstrap = present
host_profile = required
java_runtime = SecureJDK-28
entry_type = java
icon_family = CMD
icon_revision = four-trimmed-transparent-v2
```

Future fields must be versioned. A parser must ignore explicitly optional unknown fields and reject unknown mandatory fields.

The manifest is not an authority grant. It describes requested capabilities and package structure; ASYSMA policy determines whether execution is permitted.
