foreach variant : get_option('variants')
  svg_assets = run_command('find', meson.current_source_dir(), '-name', '*.svg', check : true).stdout().split()

  xml_assets = [
    variant == 'light' or variant == 'lighter' ? 'metacity-theme-1.xml' : 'metacity-theme-1-dark.xml',
    variant == 'light' or variant == 'lighter' ? 'metacity-theme-2.xml' : 'metacity-theme-2-dark.xml',
    variant == 'light' or variant == 'lighter' ? 'metacity-theme-3.xml' : 'metacity-theme-3-dark.xml'
  ]

  install_data(
    svg_assets,
    install_dir : prefix / install_dir.get(variant) / common_dirs.get('metacity')
  )

  install_data(
    xml_assets,
    rename : ['metacity-theme-1.xml', 'metacity-theme-2.xml', 'metacity-theme-3.xml'],
    install_dir : prefix / install_dir.get(variant) / common_dirs.get('metacity')
  )

  install_data(
    variant == 'light' or variant == 'lighter' ? 'thumbnail.png' : 'thumbnail-dark.png',
    rename : 'thumbnail.png',
    install_dir : prefix / install_dir.get(variant) / common_dirs.get('metacity')
  )
endforeach
