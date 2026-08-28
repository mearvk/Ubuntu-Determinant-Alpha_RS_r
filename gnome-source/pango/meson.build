project('pango', 'c', 'cpp',
        version: '1.58.2',
        license: 'LGPLv2.1+',
        default_options: [
          'buildtype=debugoptimized',
          'warning_level=1',
          'c_std=gnu11',
        ],
        meson_version : '>= 1.2.0')

# Upstream GNOME Pango Meson build definition.
# Imported from the GNOME GitHub mirror.
# Full upstream tree remains at the corresponding upstream revision.

pango_version = meson.project_version()
pango_api_version = '1.0'

# Pango requires GLib/GObject/GIO and integrates with text shaping
# implementations such as HarfBuzz and bidirectional text via FriBidi.
# Platform backends may additionally use Fontconfig, FreeType, Xft, or Cairo.
