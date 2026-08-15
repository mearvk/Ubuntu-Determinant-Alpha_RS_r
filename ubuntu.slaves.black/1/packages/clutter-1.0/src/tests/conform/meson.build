test_cflags = [
  '-DG_LOG_DOMAIN="Clutter-Conform"',
  '-DCOGL_DISABLE_DEPRECATION_WARNINGS',
]

test_env = [
  'G_ENABLE_DIAGNOSTIC=0',
  'CLUTTER_ENABLE_DIAGNOSTIC=0',
  'CLUTTER_BACKEND=x11',
  'G_TEST_SRCDIR=@0@'.format(meson.current_source_dir()),
  'G_TEST_BUILDDIR=@0@'.format(meson.current_build_dir()),
]

actor_tests = [
  'actor-anchors',
  'actor-destroy',
  'actor-graph',
  'actor-invariants',
  'actor-iter',
  'actor-layout',
  'actor-meta',
  'actor-offscreen-limit-max-size',
  'actor-offscreen-redirect',
  'actor-paint-opacity',
  'actor-pick',
#  'actor-shader-effect', # XXX - Fails on CI
  'actor-size',
]

classes_tests = [
  'text',
]

general_tests = [
  'binding-pool',
  'color',
  'events-touch',
  'interval',
  'model',
  'script-parser',
  'units',
]

deprecated_tests = [
  'animator',
  'behaviours',
  'group',
  'rectangle',
  'texture',
]

conformance_suites = [
  [ 'actor', actor_tests ],
  [ 'classes', classes_tests ],
  [ 'general', general_tests ],
  [ 'deprecated', deprecated_tests ],
]

installed_test_bindir = join_paths(clutter_libexecdir, 'installed-tests', meson.project_name())
installed_test_datadir = join_paths(clutter_datadir, 'installed-tests', meson.project_name())

foreach suite: conformance_suites
  suite_name = suite[0]
  suite_tests = suite[1]

  foreach t: suite_tests
    test_name = t
    test_source = t + '.c'

    test_data_conf = configuration_data()
    test_data_conf.set('test_bin', join_paths(installed_test_bindir, test_name))

    test_data = configure_file(
      input: 'test.data.in',
      output: t + '.test',
      configuration: test_data_conf,
      install: true,
      install_dir: installed_test_datadir,
    )

    test_bin = executable(test_name,
      test_source,
      c_args: test_cflags,
      dependencies: [ libclutter_dep, mathlib_dep ],
      install: true,
      install_dir: installed_test_bindir,
    )

    test(t, test_bin,
      suite: suite_name,
      env: test_env,
    )
  endforeach
endforeach
