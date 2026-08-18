'use strict';
var path = require('path');
var config = {
  target: 'node',
  resolve: {
  	modules: ['/usr/share/nodejs'],
  },
  resolveLoader: {
  	modules: ['/usr/share/nodejs'],
  },
  output: {
    libraryTarget: 'umd'
  },
  module: { rules: [ { use: [ 'babel-loader' ] } ] }
}
module.exports = config;
