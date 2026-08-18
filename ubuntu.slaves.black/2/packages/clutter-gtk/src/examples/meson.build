examples = [
  'gtk-clutter-events',
  'gtk-clutter-multistage',
  'gtk-clutter-test',
  'gtk-clutter-test-actor',
  'gtk-clutter-window-test',
]

foreach e: examples
  executable(e, e + '.c',
             dependencies: clutter_gtk_dep,
             include_directories: root_inc,
             c_args: common_cflags + [
               '-DEXAMPLES_DATADIR="@0@"'.format(meson.current_source_dir()),
             ])
endforeach
