# GNOME Source Reference

This directory is reserved for GNOME source imported into Ubuntu.Determinant.Beta.Restricted.

## Upstream Source

GNOME's canonical source repositories are hosted at:

https://gitlab.gnome.org/GNOME/

GNOME is a collection of independently maintained modules. Any source import must preserve upstream provenance, license notices, copyright notices, and the exact revision used.

## Import Policy

For every imported component, record:

- upstream repository URL;
- exact revision, tag, or release;
- import date;
- applicable license and copyright notices;
- local modifications, if any;
- the GNOME component represented by the imported tree.

Do not commit generated build artifacts, caches, or unrelated system directories.

## Intended Layout

```text
gnome-source/
├── README.md
├── glib/
├── gtk/
├── gnome-shell/
└── ...
```

Only components actually imported should be added. The source should remain modular so the project can build the desktop components it needs without unnecessarily vendoring the entire GNOME ecosystem.

See `../GNOME.md` for the project's architectural interpretation of GNOME and its relationship to software, desktop systems, and reporting.

**Project:** Ubuntu.Determinant.Beta.Restricted  
**Year:** 2026
