# Ubuntu White Edition GNOME Configuration

This is the human-readable distribution configuration layer for the Ubuntu White Edition GNOME desktop.

## Canonical configuration model

GNOME uses GSettings schemas with a settings backend such as dconf. System-wide defaults are expressed as dconf profiles and keyfiles and are compiled into dconf databases with `dconf update`.

This directory contains source configuration only. The ISO build installs it into the target filesystem and compiles the dconf database there.

## Layout

```text
gnome-source/conf/white-edition/
├── README.md
├── profile/
│   └── user
├── db/
│   └── local.d/
│       └── 00-white-edition
└── install-config.sh
```

## Policy

- Prefer the light GNOME color scheme.
- Select `Ubuntu-White` as the icon-theme contract when the icon theme is installed.
- Keep settings user-overridable unless a specific lock is deliberately added.
- Do not copy compiled dconf databases into the repository.
- Keep module-specific policy in GSettings schemas and use this layer for distribution defaults.
- Do not place credentials, private databases, or machine-specific state here.

## Configuration ownership

Mutter owns compositor/window-management settings; GNOME Shell owns shell behavior and extensions; GTK/GDK owns toolkit presentation; GLib/GSettings supplies the settings API and schemas; GVfs owns virtual filesystem backends; Control Center presents settings; GNOME Software and Terminal own their application settings; Orca owns accessibility preferences; glib-networking supplies networking/TLS integration. Cairo and GDK-Pixbuf are rendering/image libraries, Vala is build-time tooling, and Gala remains a separate optional compositor project.

## Build requirement

The build host should have `dconf` installed. After installing or changing keyfiles, the target root's dconf databases must be regenerated with `dconf update`.
