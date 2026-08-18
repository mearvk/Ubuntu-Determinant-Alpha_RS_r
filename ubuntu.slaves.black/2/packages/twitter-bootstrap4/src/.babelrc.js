module.exports = {
  presets: [
    [
      '@babel/preset-env',
      {
        loose: true,
        bugfixes: true,
        modules: false,
        ignoreBrowserslistConfig: true
      }
    ]
  ],
  env: {
    test: {
      plugins: [ 'istanbul' ]
    }
  }
};
