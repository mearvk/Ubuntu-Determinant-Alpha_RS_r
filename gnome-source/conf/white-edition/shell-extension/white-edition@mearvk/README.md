# Ubuntu White Edition Panel

An additive GNOME Shell extension for the Ubuntu White Edition desktop. It adds a
Start button that stays fixed at the bottom-left of the panel and a Start menu
popup whose horizontal alignment is configurable.

This is the supported Shell extension/customization layer that the White Edition
GNOME configuration README calls for. It is additive and reversible: it does not
edit any vendored upstream GNOME source.

## Behavior

- The Start button is always placed at the bottom-left of the panel and never
  moves. It is inserted into the panel left box at position 0 unconditionally.
- Only the Start menu popup's horizontal anchoring changes, driven by the
  `start-menu-alignment` GSettings key:
  - `left` (default): popup opens near the button at the left edge.
  - `center`: popup opens over the center of the primary monitor work area.
  - `right`: popup opens against the right edge.
- The button glyph is selectable from three bundled Ubuntu-themed logos via the
  `start-button-logo` key: `circle-of-friends`, `mono-accent`, `focus-ring`.

Both settings are exposed through `prefs.js` so they appear in GNOME Extensions
and Control Center, and the extension connects to `changed::` signals to apply
changes live where the running Shell allows it.

## Target

- GNOME Shell version: 46 (also declared compatible with 47 in `metadata.json`).
- Modern GJS ESM: imports from `gi://` and `resource:///org/gnome/shell/...`.
- Preferences use `ExtensionPreferences` with Adwaita and GTK 4.

## Files

```text
white-edition@mearvk/
├── metadata.json
├── extension.js
├── prefs.js
├── stylesheet.css
├── install.sh
├── README.md
├── schemas/
│   └── org.gnome.shell.extensions.white-edition.gschema.xml
└── logos/
    ├── circle-of-friends.svg
    ├── mono-accent.svg
    └── focus-ring.svg
```

## Install

```sh
./install.sh /path/to/iso/target/root
```

The installer requires an explicit absolute target root that contains `/etc`,
rejects symbolic links and special files in the source, copies the extension
into `usr/share/gnome-shell/extensions/white-edition@mearvk/`, and compiles the
GSettings schema in place with `glib-compile-schemas`. The compiled schema cache
is generated at install time and is never committed to the repository.
