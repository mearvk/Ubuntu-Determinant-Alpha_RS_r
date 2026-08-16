'use strict';

var skipLines = require('./skip-lines');

module.exports = function(text, nline, nskip) {
  text = skipLines(text, nskip);
  var index = -1;
  for (var i = 0; i < nline; i++) {
    if ((index = text.indexOf('\n', index + 1)) < 0) {
      return text;
    }
  }
  return text.slice(0, Math.max(index, 0));
};
