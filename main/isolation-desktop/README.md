# Ubuntu White Isolation Desktop

A lightweight developer preview of the Ubuntu White desktop idiom.

## Purpose

Isolation Desktop is a **desktop application preview**, not an ISO builder and not a virtual machine. It lets GUI developers compile and launch the desktop shell locally so they can iterate on look-and-feel without rebooting or installing the operating system.

The current interactive reference implementation is `org.ubuntu.white.desktop.DesktopSynthesizer`. See [`DESKTOP_SYNTHESIZER.md`](DESKTOP_SYNTHESIZER.md) for its support specification.

## Desktop Synthesizer

The Desktop Synthesizer provides the current proposed full-window desktop look and feel:

- Fullscreen JavaFX presentation.
- Previously established Ubuntu White wallpaper, scaled proportionally to fill the desktop.
- Twelve reference icons from `images/desktop-icons/set-001/`.
- Uniform 64 px icon rendering with preserved source aspect ratios.
- Mouse drag-and-drop for desktop icons.
- Deterministic grid snapping on icon release.
- Host-file drag-and-drop onto the desktop surface.
- Simple top and bottom desktop chrome for the visual preview.

The icon reference is documented in `ubuntu-white/IconGreeting2.md`.

## Developer workflow

```text
source → compile → desktop preview → edit → compile → preview
```

Run the current synthesizer with:

```text
gradle -b desktop-synthesizer.gradle run
```

or:

```text
./launch-synthesizer
```

The dedicated Gradle configuration targets Java 21 and JavaFX 21.0.8.

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

`launch-synthesizer` — launch the current Gradle Desktop Synthesizer.

The implementation uses JavaFX as the current Ubuntu White GUI technology.

## Next support work

- Persist desktop icon positions.
- Add double-click/open behavior.
- Add selection states and context menus.
- Package wallpaper and icons as application resources for distribution.
- Integrate the synthesizer with the boot-to-Desktop startup path.
- Add JavaFX build/smoke checks to CI.
