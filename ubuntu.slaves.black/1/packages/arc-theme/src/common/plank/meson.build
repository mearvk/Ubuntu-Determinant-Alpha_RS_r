foreach variant : get_option('variants')
  install_data(
    variant != 'lighter' ? 'dock.theme' : 'dock-lighter.theme',
    rename: 'dock.theme',
    install_dir : prefix / install_dir.get(variant) / common_dirs.get('plank')
  )
endforeach
