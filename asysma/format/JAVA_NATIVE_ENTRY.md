# ASYSMA Java / Native Entry Model

ASYSMA v1 supports three explicit execution modes:

```text
JAVA
NATIVE
NATIVE_THEN_JAVA
```

## JAVA

```text
.asysma
  -> integrity/policy
  -> SecureJDK 28
  -> Java entry
```

The ordinary Java compiler remains responsible for producing JVM class files:

```text
Java source -> javac -> .class
```

An ASYSMA packer can then package those class files into an `.asysma` container.

## NATIVE

```text
.asysma
  -> native OS representation
  -> native bootstrap
  -> Direct / host profile
  -> policy
  -> native entry
```

Native execution is an explicit package capability and is not inferred merely from the presence of Java classes.

## NATIVE_THEN_JAVA

```text
.asysma
  -> native bootstrap
  -> Direct / host profile
  -> integrity
  -> ASYSMA policy
  -> SecureJDK 28
  -> Java entry
```

The native stage may establish the host context and then hand off to Java. The handoff is explicit in the manifest.

## Security boundary

Native payloads require architecture declaration, bounds validation, integrity verification, and policy approval. OS permissions and process authority remain under the operating system.

## Future toolchain

A future SecureJDK/MEARVK tool may offer a convenience operation equivalent to:

```text
javac source.java
asysma-pack classes/ native/ manifest -> application.asysma
```

This is a packaging integration, not a requirement that `javac` itself emit machine-code executables.
