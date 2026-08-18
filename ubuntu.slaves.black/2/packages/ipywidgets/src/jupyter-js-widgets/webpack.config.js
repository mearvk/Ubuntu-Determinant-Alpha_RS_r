// Copyright (c) Jupyter Development Team.
// Distributed under the terms of the Modified BSD License.

var version = require('./package.json').version;

module.exports = {
    entry: './lib-embed/embed-webpack.js',
    output: {
        filename: 'embed.js',
        publicPath: 'https://unpkg.com/jupyter-js-widgets@' + version + '/dist/'
    },
    resolve: {
        modules: [ 'node_modules', '/usr/share/nodejs' ]
    },
    devtool: 'source-map',
    module: {
        rules: [
            { test: /\.css$/, use: [ "style-loader", "css-loader" ] },
            // jquery-ui loads some images
            { test: /\.(jpg|png|gif)$/, use: [ "file-loader" ] },
            // required to load font-awesome
            { test: /\.woff2(\?v=\d+\.\d+\.\d+)?$/, use: [ { loader: "url-loader", options: { limit: 10000, mimetype: "font/woff" } } ] },
            { test: /\.woff(\?v=\d+\.\d+\.\d+)?$/, use: [ { loader: "url-loader", options: { limit: 10000, mimetype: "font/woff" } } ] },
            { test: /\.ttf(\?v=\d+\.\d+\.\d+)?$/, use: [ { loader: "url-loader", options: { limit: 10000, mimetype: "application/octet-stream" } } ] },
            { test: /\.eot(\?v=\d+\.\d+\.\d+)?$/, use: [ "file-loader" ] },
            { test: /\.svg(\?v=\d+\.\d+\.\d+)?$/, use: [ { loader: "url-loader", options: { limit: 10000, mimetype: "image/svg+xml" } } ] }
        ]
    }
};
