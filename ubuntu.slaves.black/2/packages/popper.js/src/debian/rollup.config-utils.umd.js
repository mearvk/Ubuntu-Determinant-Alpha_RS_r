module.exports = {
  input: "./packages/popper/src/utils/index.js",
  plugins: [require("rollup-plugin-buble")({
      objectAssign: 'Object.assign'
  })],
  output: {
    name: 'PopperUtils',
    exports: 'named',
    format: 'umd',
    file: './packages/popper/dist/umd/popper-utils.js'
  }
};
