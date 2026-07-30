# OpenJDK 28 Source (Build 8)

This is the OpenJDK 28 Early Access source tree (tag jdk-28+8).

- Source: https://github.com/openjdk/jdk (tag: jdk-28+8)
- License: GPL-2.0 with Classpath Exception
- Trimmed: test/ directory removed (not needed for build, saves 426MB)
- All files < 50MB (GitHub compatible)

## Build

```bash
cd openjdk-28-src
bash configure --with-boot-jdk=/path/to/jdk-27
make images
```

The built JDK will be in `build/linux-x86_64-server-release/images/jdk/`.

Requires a "boot JDK" (JDK N-1) to compile. JDK 27 or 26 works.
