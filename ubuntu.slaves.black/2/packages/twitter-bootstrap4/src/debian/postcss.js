const postcss = require('postcss');
const autoprefixer = require('autoprefixer');

const pify = require('util').promisify;
const fs = {
	readFile: pify(require('fs').readFile),
	writeFile: pify(require('fs').writeFile)
};

var fn = function(inputs, output, options) {
	if (inputs.length == 0) return Promise.resolve();
	return Promise.all(inputs.map(function(input) {
		return fs.readFile(input);
	})).then(function(files) {
		const root = postcss.root();
		files.forEach(function(file, i) {
			var cur = postcss.parse(file, {
				from: inputs[i],
				map: {
					inline: false
				}
			});
			root.append(cur);
		});

		const plugins = [
			autoprefixer({
				browsers: options.browsers || [ "> 1%" ]
			})
		];
		return postcss(plugins).process(root, {
			from: output,
			to: output,
			map: {
				inline: false
			}
		});
	}).then(function(result) {
		const list = [fs.writeFile(output, result.css)];
		if (result.map) list.push(fs.writeFile(`${output}.map`, result.map));
		return Promise.all(list);
	});
};

function postcssRebase(asset) {
	if (!asset.pathname) return;
	return asset.relativePath;
}

fn(['dist/tmp/bootstrap.css'],'dist/css/bootstrap.css',{});
fn(['dist/tmp/bootstrap-grid.css'],'dist/css/bootstrap-grid.css',{});
fn(['dist/tmp/bootstrap-reboot.css'],'dist/css/bootstrap-reboot.css',{});
