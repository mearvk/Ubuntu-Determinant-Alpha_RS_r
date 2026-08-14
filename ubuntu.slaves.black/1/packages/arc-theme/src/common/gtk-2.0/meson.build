gtk2_asset_names = run_command(
  'cat', 'assets.txt',
  check : true
).stdout().split()

subdir('assets-light')
if 'dark' in get_option('variants') or 'darker' in get_option('variants')
  subdir('assets-dark')
endif

foreach variant : get_option('variants')
  if variant == 'light' or variant == 'lighter'
    light_menubar_toolbar_assets = [
      'entry-active-toolbar',
      'entry-disabled-toolbar',
      'entry-toolbar',
      'menubar_button',
      'menubar'
    ]
  elif variant == 'dark' or variant == 'darker'
    light_menubar_toolbar_assets = [
      'button-active',
      'button-hover',
      'button-insensitive',
      'button'
    ]

    dark_menubar_toolbar_assets = [
      'entry-active-toolbar',
      'entry-disabled-toolbar',
      'entry-toolbar',
      'menubar_button',
      'menubar'
    ]
  endif

  install_data(
    [variant / 'gtkrc', 'apps.rc', 'main.rc', 'panel.rc', 'xfce-notify.rc'],
    install_dir : prefix / install_dir.get(variant) / common_dirs.get('gtk2')
  )

  install_data(
    variant == 'light' or variant == 'lighter' ? 'menubar-toolbar' / 'menubar-toolbar.rc' : 'menubar-toolbar' / 'menubar-toolbar-dark.rc',
    install_dir : prefix / install_dir.get(variant) / common_dirs.get('gtk2') / 'menubar-toolbar',
  )

  full_path_base_assets = []
  foreach asset : variant == 'dark' ? gtk2_dark_assets : gtk2_light_assets
    full_path_base_assets += asset.full_path()
  endforeach

  meson.add_install_script(
    install_file,
    full_path_base_assets,
    variant == 'dark' ? gtk2_dark_asset_files : gtk2_light_asset_files,
    '$MESON_INSTALL_DESTDIR_PREFIX' / install_dir.get(variant) / common_dirs.get('gtk2') / 'assets'
  )

  full_path_light_menubar_toolbar_assets = []
  foreach asset : light_menubar_toolbar_assets
    if fs.exists(meson.current_source_dir() / 'assets-light' / asset + '.png')
      full_path_light_menubar_toolbar_assets += meson.current_source_dir() / 'assets-light' / asset + '.png'
    else
      full_path_light_menubar_toolbar_assets += meson.current_build_dir() / 'assets-light' / asset + '.png'
    endif
  endforeach

  meson.add_install_script(
    install_file,
    full_path_light_menubar_toolbar_assets,
    '$MESON_INSTALL_DESTDIR_PREFIX' / install_dir.get(variant) / common_dirs.get('gtk2') / 'menubar-toolbar'
  )

  if variant == 'dark' or variant == 'darker'
    foreach asset : dark_menubar_toolbar_assets
      if fs.exists(meson.current_source_dir() / 'assets-dark' / asset + '.png')
        asset_file = meson.current_source_dir() / 'assets-dark' / asset + '.png'
      else
        asset_file = meson.current_build_dir() / 'assets-dark' / asset + '.png'
      endif
      meson.add_install_script(
        install_file,
        asset_file,
        '$MESON_INSTALL_DESTDIR_PREFIX' / install_dir.get(variant) / common_dirs.get('gtk2') / 'menubar-toolbar' / asset + '-dark.png'
      )
    endforeach
  endif

endforeach
