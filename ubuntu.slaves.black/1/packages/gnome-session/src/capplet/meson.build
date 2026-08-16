
cflags = [
	'-DLOCALE_DIR="@0@"'.format(session_localedir),
	'-DGTKBUILDER_DIR="@0@"'.format(session_pkgdatadir)
]

deps = [
	gio_dep,
	glib_dep,
	gtk_dep
]

sources = files(
	'main.c',
	'gsm-properties-dialog.c',
	'gsm-app-dialog.c',
	'gsp-app.c',
	'gsp-app-manager.c',
	'gsp-keyfile.c',
)

includes = [
	top_inc,
	include_directories('../gnome-session')
]

executable(
	'gnome-session-properties',
	sources,
	include_directories: includes,
	dependencies: deps,
	c_args: cflags,
	link_with: libgsmutil,
	install: true,
	install_dir: session_bindir
)
