assets_svg = 'assets.svg'

gtk3_assets = []
gtk3_hidpi_assets = []

gtk3_asset_files = []
gtk3_hidpi_asset_files = []

foreach asset : gtk3_asset_names

  asset_filename = asset + '.png'

  if fs.exists(asset_filename)
    gtk3_asset_files += meson.current_source_dir() / asset_filename
  else
    if not inkscape.found()
      error('Program \'inkscape\' not found')
    endif

    gtk3_assets += custom_target(
      'gtk3-' + asset,
      input : assets_svg,
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

  hidpi_asset_filename = asset + '@2.png'

  if fs.exists(hidpi_asset_filename)
    gtk3_hidpi_asset_files += meson.current_source_dir() / hidpi_asset_filename
  else
    if not inkscape.found()
      error('Program \'inkscape\' not found')
    endif

    gtk3_hidpi_assets += custom_target(
      'gtk3-' + asset + '-hidpi',
      input : assets_svg,
      output : hidpi_asset_filename,
      command : [
        inkscape,
        '--export-id-only',
        inkscape_ver.version_compare('>=1.0') ? '--export-filename=@OUTPUT@' : '--export-png=@OUTPUT@',
        '--export-id=' + asset,
        '--export-dpi=192',
        '@INPUT@'
      ],
      build_by_default : true
    )
  endif
endforeach
