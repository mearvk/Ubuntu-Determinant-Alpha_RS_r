# Ubuntu White Edition — GRUB boot menu theme

The first thing shown by the OS itself (after firmware) is the GRUB menu. This
directory makes that menu white-skinned and makes "Ubuntu White Edition" the
default entry.

## Files

```text
grub/
├── README.md            ← this file
├── 05_white_edition     ← /etc/default/grub.d drop-in (theme + graphics + default entry)
└── theme/
    └── theme.txt        ← GRUB theme definition (colors, layout, fonts)
```

## What it does

- Paints the GRUB desktop white (`#ffffff`) with dark-gray (`#303030`) entries.
- Highlights the selected entry in Ubuntu red (`#e95420`).
- Sets `GRUB_DEFAULT=0` so the White Edition entry boots by default.
- Sets `GRUB_GFXMODE=auto` + `GRUB_GFXPAYLOAD_LINUX=keep` so the graphical theme
  renders and the framebuffer carries into the Plymouth splash without a flicker
  to a text console.
- Uses `quiet splash` so early boot goes straight into the White Edition Plymouth
  theme.

## Install (done by ../install-boot-presentation.sh)

1. Copy `theme/` to `<root>/boot/grub/themes/white-edition/`.
2. Copy `05_white_edition` to `<root>/etc/default/grub.d/05_white_edition`.
3. Generate the theme's 9-slice pixmaps (white row, red selected row, red
   progress) from the token colors if they are not already present.
4. Inside the target root: run `update-grub`.

## Colors

Match `../../theme/white-edition.css`:

| Element | Color |
|---|---|
| menu background | `#ffffff` |
| entry text | `#303030` |
| selected entry text | `#ffffff` on `#e95420` |
| title | `#303030` |
| subtitle / footer | `#666666` |
| progress track | `#dddddd` |
| progress fill | `#e95420` |

## Notes

- Fonts must be `.pf2`; the installer converts a system TTF with `grub-mkfont` at
  build time. If a face other than DejaVu Sans is used, update the font names in
  `theme.txt` to match the converted font's internal name.
- This is an overlay. It does not modify the main `/etc/default/grub`; it only
  drops a file into the supported `grub.d` directory, so it is independently
  removable.
