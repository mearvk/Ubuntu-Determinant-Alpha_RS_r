# Create XML entities like the ones gtk-doc.make provides
ent_conf = configuration_data()
ent_conf.set('PACKAGE', 'Clutter')
ent_conf.set('PACKAGE_BUGREPORT', 'https://gitlab.gnome.org/GNOME/@0@/issues'.format(meson.project_name()))
ent_conf.set('PACKAGE_NAME', meson.project_name())
ent_conf.set('PACKAGE_STRING', meson.project_name())
ent_conf.set('PACKAGE_TARNAME', '@0@-@1@'.format(meson.project_name(), meson.project_version()))
ent_conf.set('PACKAGE_URL', '')
ent_conf.set('PACKAGE_VERSION', meson.project_version())
ent_conf.set('PACKAGE_API_VERSION', clutter_api_version)
configure_file(
  input: 'gtkdocentities.ent.in',
  output: 'gtkdocentities.ent',
  configuration: ent_conf,
)
