module.exports = {
  input: "./packages/popper/src/index.js",
  plugins: [require("rollup-plugin-buble")({
      objectAssign: 'Object.assign'
  })],
  output: {
    format: 'es',
    file: './packages/popper/dist/popper.js'
  }
};
