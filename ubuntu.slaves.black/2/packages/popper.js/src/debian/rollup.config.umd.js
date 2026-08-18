module.exports = {
  input: "./packages/popper/src/index.js",
  plugins: [require("rollup-plugin-buble")({
      objectAssign: 'Object.assign'
  })],
  output: {
    name: 'Popper',
    format: 'umd',
    file: './packages/popper/dist/umd/popper.js'
  }
};
