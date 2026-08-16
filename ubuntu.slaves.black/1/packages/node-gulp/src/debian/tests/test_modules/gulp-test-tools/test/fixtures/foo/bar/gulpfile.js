'use strict';

var gulp = require('gulp');

function a(cb) {
  return cb();
}

function b(cb) {
  return cb();
}

gulp.task('default', gulp.series(a, b));
