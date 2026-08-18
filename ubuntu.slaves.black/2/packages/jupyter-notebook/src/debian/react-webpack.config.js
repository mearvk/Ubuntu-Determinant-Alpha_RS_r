'use strict';

var config = {
    resolve: {
        modules: ['/usr/lib/nodejs', '/usr/share/nodejs']
    },
    target: 'web',
    mode: 'production',
    externals: {
        react: {
            commonjs: 'react',
            commonjs2: 'react',
            amd: 'react',
            root: 'React'
        }
    },
    output: {
        libraryTarget: 'this'
    }
};

module.exports = config;

