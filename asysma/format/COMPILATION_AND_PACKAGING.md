# Java Compilation and ASYSMA Packaging

## Current model

The Java compiler and ASYSMA packager have separate responsibilities.

```text
Java source
   |
   v
 javac
   |
   v
 .class
   |
   +------------------------------+
                                  |
 native components + manifest ----+
                                  |
                                  v
                           ASYSMA packager
                                  |
                                  v
                              .asysma
```

## Output targets

A build may produce either:

```text
.class
```

for ordinary JVM distribution, or:

```text
.asysma
```

for the MEARVK ASYSMA application/container model.

An `.asysma` package may contain Java only, native code only, or an explicit native-then-Java sequence.

## Future integration

SecureJDK 28 may eventually expose a build convenience command that combines compilation and packaging. Such a command should preserve the standard Java compiler semantics and should not imply that Java source is directly assembled into x86-64 machine code by `javac`.

## Reproducibility

The packager should record:

- ASYSMA format version
- Direct interface version
- native bootstrap version
- SecureJDK version
- architecture
- entry type
- hashes of packaged components

This keeps `.asysma` builds auditable and reproducible.
