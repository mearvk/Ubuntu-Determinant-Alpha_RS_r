import nodeResolve from "@rollup/plugin-node-resolve";
import babel from "@rollup/plugin-babel";
import commonjs from '@rollup/plugin-commonjs';
import json from '@rollup/plugin-json';
import nodePolyfills from 'rollup-plugin-node-polyfills';
export default {
	input: "dist/index.js",
	plugins: [
		json({
			preferConst: true,
			include: ['data/**']
		}),
		commonjs({
			include: 'node_modules/**'
		}),
		nodeResolve({
			extensions: [ '.js', '.json' ],
			mainFields: ['module', 'main'],
			preferBuiltins: false,
			moduleDirectories: ['/usr/share/nodejs'],
		}),
		babel(),
		nodePolyfills()
	],
	output: {
		extend: true,
		file: "dist/psl.js",
		format: "iife",
		name: "psl"
	}
}
