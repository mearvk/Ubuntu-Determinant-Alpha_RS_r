gtk2_light_assets = []
gtk2_light_asset_files = []

foreach asset : gtk2_asset_names

  asset_filename = asset + '.png'

  if fs.exists(asset_filename)
    gtk2_light_asset_files += meson.current_source_dir() / asset_filename
  else
    if not inkscape.found()
      error('Program \'inkscape\' not found')
    endif

    gtk2_light_assets += custom_target(
      'gtk2-light-' + asset,
      input : 'assets.svg',
      output : asset_filename,
      command : [
        inkscape,
        '--export-id-only',
        inkscape_ver.version_compare('>=1.0') ? '--export-filename=@OUTPUT@' : '--export-png=@OUTPUT@',
        '--export-id=' + asset,
        '--export-dpi=96',
        '@INPUT@'
      ],
      build_by_default : true
    )
  endif
endforeach
