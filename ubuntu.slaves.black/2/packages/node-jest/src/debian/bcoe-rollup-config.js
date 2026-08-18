import babel from '@rollup/plugin-babel';
import ts from '@rollup/plugin-typescript';
import commonjs from '@rollup/plugin-commonjs';
import multiInput from 'rollup-plugin-multi-input';

export default {
  input: ['../bcoe-v8-coverage/src/lib/*.ts'],
  output: {
    dir: '../bcoe-v8-coverage/dist/lib',
    format: 'cjs',
  },
  plugins: [
    multiInput(),
    babel({ babelHelpers: 'bundled' }),
    ts({
      //declaration: true,
      skipLibCheck: true,
      exclude:["node_modules","debian","test","gulpfile.ts"],
      allowSyntheticDefaultImports: true,
      downlevelIteration: true,
      //declarationDir:'../bcoe-v8-coverage/dist/lib',
      //dir:'../bcoe-v8-coverage/dist/lib',
    }),
    commonjs(),
  ]
};
