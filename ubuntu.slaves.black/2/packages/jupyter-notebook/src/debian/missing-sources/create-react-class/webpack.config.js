/**
 * Copyright (c) 2013-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 *
 * @emails react-core
 */

'use strict';

const webpack = require('webpack');

let __DEV__;
switch (process.env.NODE_ENV) {
  case 'development':
    __DEV__ = true;
    break;
  case 'production':
    __DEV__ = false;
    break;
  default:
    throw new Error('Unknown environment.');
}

module.exports = {
  mode: process.env.NODE_ENV,
  entry: './index',
  resolve: {
    modules: ["/usr/lib/nodejs", "/usr/share/nodejs"]
  },
  output: {
    library: 'createReactClass',
    libraryTarget: 'umd',
    filename: __DEV__ ? 'create-react-class.js' : 'create-react-class.min.js'
  },
  externals: {
    react: {
      root: 'React',
      commonjs2: 'react',
      commonjs: 'react',
      amd: 'react'
    }
  },
  plugins: []
};
