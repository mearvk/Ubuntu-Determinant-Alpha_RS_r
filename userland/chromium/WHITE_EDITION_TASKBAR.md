# Chromium — Ubuntu White Edition Secondary Tasking Bar

## Purpose

Ubuntu White Edition adds a **secondary tasking bar immediately beneath Chromium's URL/omnibox area**. This is a browser-chrome feature, not a web-page toolbar and not an extension injected into page content.

The bar provides a stable second row for task-oriented browser commands while leaving the normal Chromium tab strip and omnibox behavior intact.

## Placement

```text
┌─────────────────────────────────────────────────────────────┐
│ Tabs                                                        │
├─────────────────────────────────────────────────────────────┤
│ Navigation / URL (omnibox)                                  │
├─────────────────────────────────────────────────────────────┤
│ WHITE EDITION SECONDARY TASKING BAR                         │
│ [Back] [Forward] [Reload] [Home] [Tasks] [Downloads] [...] │
├─────────────────────────────────────────────────────────────┤
│ Web content                                                 │
└─────────────────────────────────────────────────────────────┘
```

The tasking bar remains **below the URL input/omnibox row**. It does not replace the omnibox, alter URL entry semantics, or overlay page content.

## Visual contract

The bar follows the White Edition desktop language:

- predominantly white surface;
- dark-gray text and controls;
- neutral gray separators/shadows;
- restrained Ubuntu-red active/focus indication;
- subtle precision lighting consistent with the desktop LAF;
- no excessive gradients that reduce legibility.

## Interaction contract

The tasking bar is a native Chromium UI surface. Controls use Chromium's normal command, focus, accessibility, keyboard-navigation, tooltip, and accelerator systems wherever applicable.

| Control | Function | Initial state |
|---|---|---|
| Back | Navigate backward | Enabled when history permits. |
| Forward | Navigate forward | Enabled when history permits. |
| Reload | Reload current page | Enabled. |
| Home | Navigate to configured home page | Configurable. |
| Tasks | White Edition task surface | Reserved for project integration. |
| Downloads | Open Chromium downloads | Enabled when supported by the build. |
| Overflow | Additional actions | Reserved for future commands. |

The feature does not introduce a parallel browser command model. Existing Chromium commands remain authoritative.

## Source integration boundary

Chromium is fetched into:

```text
userland/chromium/chromium-src/
```

The repository currently stores the Chromium acquisition/build wrapper rather than a permanently vendored Chromium source tree. The customization is therefore maintained outside the upstream source tree and applied during the local build process.

The implementation belongs in Chromium's native browser-view/toolbar hierarchy. A customization script must inspect the fetched Chromium revision before modifying it and refuse to patch an unrecognized source layout.

## Safety requirements

1. Record the Chromium Git revision before customization.
2. Require expected source-layout markers before applying changes.
3. Keep project customization outside the pristine upstream source where practical.
4. Make customization idempotent; a second run must not duplicate the bar.
5. Fail closed when expected Chromium UI classes/files are absent.
6. Preserve a clean path to rebuild Chromium without the White Edition customization.
7. Report customization status separately from ordinary Chromium build success.

## Build relationship

```text
fetch Chromium
      ↓
record revision
      ↓
verify expected UI source layout
      ↓
apply White Edition taskbar customization
      ↓
GN/Ninja build
      ↓
Chromium executable
      ↓
ISO/rootfs packaging
```

This document defines the architectural contract. It does not falsely claim that the native Chromium modification has already been compiled merely because the specification exists.

## Planned customization boundary

```text
userland/chromium/
├── WHITE_EDITION_TASKBAR.md
├── white-edition/
│   ├── README.md
│   └── apply-taskbar.sh
└── chromium-src/
    └── <fetched Chromium source>
```

The `white-edition/` layer remains separate from Chromium upstream so the upstream source can be refreshed without losing the project's desktop customization.
