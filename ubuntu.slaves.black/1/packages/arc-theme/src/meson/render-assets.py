#!/usr/bin/env python3

# render assets from svg to png for meson dist
# requires meson >=0.54.0, inkscape >=1.0 and oxipng

import os
from pathlib import Path
import subprocess

dist_root = os.environ.get('MESON_DIST_ROOT')
source_root = os.environ.get('MESON_SOURCE_ROOT')

asset_arrays = [
# ['source_file',
#  'asset_list',
#  'output_dir',
#  'dpi',
#  'suffix'],
  ['common/gtk-2.0/assets-dark/assets.svg',
   'common/gtk-2.0/assets.txt',
   'common/gtk-2.0/assets-dark/',
   '96',
   '.png'],
  ['common/gtk-2.0/assets-light/assets.svg',
   'common/gtk-2.0/assets.txt',
   'common/gtk-2.0/assets-light/',
   '96',
   '.png'],
  ['common/gtk-3.0/assets/assets.svg',
   'common/gtk-3.0/assets/assets.txt',
   'common/gtk-3.0/assets/',
   '96',
   '.png'],
  ['common/gtk-3.0/assets/assets.svg',
   'common/gtk-3.0/assets/assets.txt',
   'common/gtk-3.0/assets/',
   '192',
   '@2.png'],
  ['common/gtk-4.0/assets/assets.svg',
   'common/gtk-4.0/assets/assets.txt',
   'common/gtk-4.0/assets/',
   '96',
   '.png'],
  ['common/gtk-4.0/assets/assets.svg',
   'common/gtk-4.0/assets/assets.txt',
   'common/gtk-4.0/assets/',
   '192',
   '@2.png'],
  ['common/xfwm4/dark/assets.svg',
   'common/xfwm4/assets.txt',
   'common/xfwm4/dark/',
   '96',
   '.png'],
  ['common/xfwm4/light/assets.svg',
   'common/xfwm4/assets.txt',
   'common/xfwm4/light/',
   '96',
   '.png']
]

for asset_array in asset_arrays:

  source_file = Path(source_root, asset_array[0])
  asset_list  = Path(source_root, asset_array[1])
  output_dir  = Path(dist_root, asset_array[2])
  dpi         = asset_array[3]
  suffix      = asset_array[4]

  asset_names = asset_list.read_text().splitlines()
  asset_files = []
  inkscape_actions = ['export-id-only', 'export-dpi:' + dpi,]

  for asset in asset_names:
    asset_file = output_dir / (asset + suffix)

    asset_files.append(asset_file)

    inkscape_actions.append('export-id:' + asset)
    inkscape_actions.append('export-filename:' + str(asset_file))
    inkscape_actions.append('export-do')

  subprocess.run([
    'inkscape',
    '--actions=' + '; '.join(inkscape_actions),
    source_file],
    check=True)

  subprocess.run([
    'oxipng',
    '-o', 'max',
    '--strip', 'safe',
    '--libdeflater',
    ] + asset_files,
    check=True)
