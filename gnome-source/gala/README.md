# Gala Source

This directory tracks the Gala compositor/window-manager source boundary for the Ubuntu Determinant desktop work.

Gala is the desktop shell/window manager used by elementary OS, rather than a GNOME core component. We keep it separately identified so the build system can distinguish it from Mutter/GNOME Shell and so it can be evaluated as an optional desktop component.

## Layout

```text
gala/
├── README.md
├── pull-source.sh
└── upstream/
```

`pull-source.sh` acquires the selected public Gala source into `upstream/` without requiring interactive credentials. Future Determinant modifications should be maintained as separate patches/offsets rather than modifying the pristine upstream tree directly.

## Source policy

- Use the public upstream repository.
- Do not store credentials in this repository.
- Keep pristine source under `upstream/`.
- Record the exact checked-out commit.
- Keep customization separate from upstream source.

The script defaults to a shallow clone and permits an explicit branch, tag, or commit through `GALA_SOURCE_REF`.
