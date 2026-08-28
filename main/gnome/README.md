# Ubuntu Determinant Custom GNOME

This directory defines the upstream GNOME sources and the customization boundary for the Ubuntu Determinant desktop.

## Upstream components

The production desktop is based on selected upstream GNOME components rather than treating MATE as the desktop implementation:

- GNOME Shell — desktop shell and core user interface.
- Mutter — compositor, window management, input/focus/workspaces, and display integration.
- Nautilus — GNOME Files file manager and filesystem UI.

Upstream source is maintained by the GNOME Project. This repository keeps the integration and customization work under `main/gnome/` while preserving upstream copyright and licensing notices.

## Customization direction

Ubuntu Determinant will use GNOME as an upstream foundation and develop a custom desktop experience on top of it. The initial boundary is:

```text
X11 / Wayland display stack
        |
     Mutter
        |
   GNOME Shell
        |
 Ubuntu Determinant UI
        |
    Nautilus / Files
```

The implementation should preserve upstream source provenance, COPYING/LICENSE files, SPDX notices, and third-party attribution. GNOME modules use a mixture of GPL, LGPL, and other OSI-approved licenses; each imported module must retain its own license terms.

## Source import policy

Do not copy an arbitrary generated build directory into this tree. Import upstream source at a pinned release/commit, record the upstream URL and commit in `UPSTREAM.md`, and apply Ubuntu Determinant changes as clearly identifiable patches or source changes.

## Current status

The top-level ISO build currently advertises MATE + LightDM as its desktop target. This directory establishes the replacement path for a custom GNOME implementation. The ISO target should be changed only after the GNOME integration builds and starts successfully in the root filesystem.
