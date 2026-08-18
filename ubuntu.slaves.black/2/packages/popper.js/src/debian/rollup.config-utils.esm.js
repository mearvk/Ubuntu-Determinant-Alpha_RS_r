module.exports = {
  input: "./packages/popper/src/utils/index.js",
  plugins: [require("rollup-plugin-buble")({
      objectAssign: 'Object.assign'
  })],
  output: {
    format: 'es',
    file: './packages/popper/dist/esm/popper-utils.js'
  }
};
