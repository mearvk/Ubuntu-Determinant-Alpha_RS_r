# Trillian — Open Chat Source Reference

This directory is a project-local reference area for an open-source chat client selected as a clean, lawful foundation for Trillian-inspired work.

## Selected upstream: Dino

We selected **Dino** because it is a full-featured open-source desktop XMPP client. Its upstream repository describes support for calls, encryption, file transfers, and group chats. It is licensed under GPL-3.0. citeturn0search0

Upstream repository:

https://github.com/dino/dino

## Important distinction

This is **not** the proprietary Cerulean Studios Trillian source code. The `/trillian` directory uses an independently available open-source project as a reference/foundation for a Trillian-inspired chat experience.

Do not represent Dino code, trademarks, assets, or branding as Trillian code or branding. Preserve upstream copyright and license notices when source is incorporated.

## Acquisition

The upstream source should be obtained from the official repository rather than copied into this repository by an undocumented or third-party archive. The repository's current upstream is `dino/dino`.

## Planned project boundary

```text
/trillian/
  README.md
  LICENSES.md
  UPSTREAM.md
  source/        # acquired upstream source, if deliberately vendored
  patches/       # project-specific changes
  docs/          # integration and attribution documentation
```

Before vendoring the complete upstream tree, review its current license files, third-party dependencies, generated files, and attribution requirements.
