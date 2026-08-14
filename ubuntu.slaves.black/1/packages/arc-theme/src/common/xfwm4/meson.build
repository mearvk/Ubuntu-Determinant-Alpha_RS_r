xfwm_asset_names = run_command(
  'cat', 'assets.txt',
  check : true
).stdout().split()

if 'light' in get_option('variants') or 'lighter' in get_option('variants')
  subdir('light')
endif

if 'dark' in get_option('variants') or 'darker' in get_option('variants')
  subdir('dark')
endif

foreach variant : get_option('variants')
  if variant == 'light' or variant == 'lighter'
    themerc = 'light/themerc'
    assets = xfwm_light_assets
    asset_files = xfwm_light_asset_files
  elif variant == 'dark' or variant == 'darker'
    themerc = 'dark/themerc'
    assets = xfwm_dark_assets
    asset_files = xfwm_dark_asset_files
  endif

  install_data(
    themerc,
    install_dir : prefix / install_dir.get(variant) / common_dirs.get('xfwm')
  )

  full_path_assets = []
  foreach asset : assets
    full_path_assets += asset.full_path()
  endforeach

  meson.add_install_script(
    install_file,
    full_path_assets,
    asset_files,
    '$MESON_INSTALL_DESTDIR_PREFIX' / install_dir.get(variant) / common_dirs.get('xfwm')
  )
endforeach
