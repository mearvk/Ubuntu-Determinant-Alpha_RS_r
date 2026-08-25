# XMC Local Testing Inputs

This directory contains clean inputs for manually exercising the XMC compiler and ASYSMA composition process.

## Java

```bash
cd tools/xmc
./xmc-build --verbose ../../testing-inputs/java/XmcDesktopProbe.java
./xmc-build --verbose ../../testing-inputs/java/XmcControlFlowProbe.java
```

Expected localized artifacts are written beside each input:

- `.xclass`
- `.asysma`
- `.asysma-launcher.desktop`

The generated ASYSMA package contains the application identity and composed XMC icon metadata.

## C

```bash
cc -std=c11 -Wall -Wextra -Werror -O2 \
  -o /tmp/xmc_native_probe testing-inputs/native/xmc_native_probe.c
/tmp/xmc_native_probe
```

Expected output:

```text
xmc-native-c=22
```

## C++

```bash
c++ -std=c++17 -Wall -Wextra -Werror -O2 \
  -o /tmp/xmc_native_probe_cpp testing-inputs/native/xmc_native_probe.cpp
/tmp/xmc_native_probe_cpp
```

Expected output:

```text
xmc-native-cpp=27
```

## Purpose

These files are deliberately small and deterministic. They are inputs, not generated build artifacts, so they remain available for repeated compiler and package-composition tests.
