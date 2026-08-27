# Ubuntu White Isolation Desktop

A lightweight developer preview of the Ubuntu White desktop idiom.

## Purpose

Isolation Desktop is a **desktop application preview**, not an ISO builder and not a virtual machine. It lets GUI developers compile and launch the desktop shell locally so they can iterate on look-and-feel without rebooting or installing the operating system.

## Developer workflow

```text
source → compile → desktop preview → edit → compile → preview
```

The eventual Ubuntu White OS installer may consume the same GUI assets and source, but the preview remains independently runnable.

## Isolation principles

- No bootloader changes.
- No disk repartitioning.
- No ISO creation required.
- No filesystem installation required.
- Preview state remains separate from the host OS.
- Production packaging is a separate build target.

## Planned entry points

`compile-desktop` — compile the desktop preview.

`launch-desktop` — launch the compiled preview.

`Makefile` — convenient developer build/run interface.

The implementation should use the GUI toolkit selected by the Ubuntu White desktop source; JavaFX remains the project's preferred GUI technology where applicable.
