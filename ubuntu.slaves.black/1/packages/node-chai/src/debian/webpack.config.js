module.exports = {
    mode: 'production',
    entry: {
	'chai.js' : './index.js',
	'chai.min.js' : './index.js'
    },
    devtool: "source-map",
    output: {
        library: "chai",
	libraryTarget: "umd",
	filename: "[name]"
    },
    resolve: {
        modules: process.env.NODE_PATH.split(':')
    },
    resolveLoader: {
        modules: process.env.NODE_PATH.split(':')
    }
}
