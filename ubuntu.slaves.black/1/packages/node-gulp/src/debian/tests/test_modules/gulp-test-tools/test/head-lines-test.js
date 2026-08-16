'use strict';

/* eslint max-statements: "off" */

var headLines = require('../').headLines;

var expect = require('chai').expect;

describe('head lines', function() {

  describe('without skip', function() {

    it('an empty string', function(done) {
      expect(headLines('', 0)).to.equal('');
      expect(headLines('', 1)).to.equal('');
      expect(headLines('', 2)).to.equal('');
      done();
    });

    it('an string which has single line', function(done) {
      expect(headLines('single line', 0)).to.equal('');
      expect(headLines('single line', 1)).to.equal('single line');
      expect(headLines('single line', 2)).to.equal('single line');
      done();
    });

    it('an string which has multiple lines', function(done) {
      expect(headLines('foo\nbar\nbaz', 0)).to.equal('');
      expect(headLines('foo\nbar\nbaz', 1)).to.equal('foo');
      expect(headLines('foo\nbar\nbaz', 2)).to.equal('foo\nbar');
      expect(headLines('foo\nbar\nbaz', 3)).to.equal('foo\nbar\nbaz');
      expect(headLines('foo\nbar\nbaz', 4)).to.equal('foo\nbar\nbaz');
      done();
    });
  });

  describe('with skip', function() {

    it('an empty string', function(done) {
      expect(headLines('', 0, 0)).to.equal('');
      expect(headLines('', 1, 0)).to.equal('');
      expect(headLines('', 2, 0)).to.equal('');

      expect(headLines('', 0, 1)).to.equal('');
      expect(headLines('', 1, 1)).to.equal('');
      expect(headLines('', 2, 1)).to.equal('');

      expect(headLines('', 0, 2)).to.equal('');
      expect(headLines('', 1, 2)).to.equal('');
      expect(headLines('', 2, 2)).to.equal('');
      done();
    });

    it('an string which has single line', function(done) {
      expect(headLines('single line', 0, 0)).to.equal('');
      expect(headLines('single line', 1, 0)).to.equal('single line');
      expect(headLines('single line', 2, 0)).to.equal('single line');

      expect(headLines('single line', 0, 1)).to.equal('');
      expect(headLines('single line', 1, 1)).to.equal('');
      expect(headLines('single line', 2, 1)).to.equal('');

      expect(headLines('single line', 0, 2)).to.equal('');
      expect(headLines('single line', 1, 2)).to.equal('');
      expect(headLines('single line', 2, 2)).to.equal('');
      done();
    });

    it('an string which has multiple lines', function(done) {
      expect(headLines('foo\nbar\nbaz', 0, 0)).to.equal('');
      expect(headLines('foo\nbar\nbaz', 1, 0)).to.equal('foo');
      expect(headLines('foo\nbar\nbaz', 2, 0)).to.equal('foo\nbar');
      expect(headLines('foo\nbar\nbaz', 3, 0)).to.equal('foo\nbar\nbaz');
      expect(headLines('foo\nbar\nbaz', 4, 0)).to.equal('foo\nbar\nbaz');

      expect(headLines('foo\nbar\nbaz', 0, 1)).to.equal('');
      expect(headLines('foo\nbar\nbaz', 1, 1)).to.equal('bar');
      expect(headLines('foo\nbar\nbaz', 2, 1)).to.equal('bar\nbaz');
      expect(headLines('foo\nbar\nbaz', 3, 1)).to.equal('bar\nbaz');
      expect(headLines('foo\nbar\nbaz', 4, 1)).to.equal('bar\nbaz');

      expect(headLines('foo\nbar\nbaz', 0, 2)).to.equal('');
      expect(headLines('foo\nbar\nbaz', 1, 2)).to.equal('baz');
      expect(headLines('foo\nbar\nbaz', 2, 2)).to.equal('baz');
      expect(headLines('foo\nbar\nbaz', 3, 2)).to.equal('baz');
      expect(headLines('foo\nbar\nbaz', 4, 2)).to.equal('baz');

      expect(headLines('foo\nbar\nbaz', 0, 3)).to.equal('');
      expect(headLines('foo\nbar\nbaz', 1, 3)).to.equal('');
      expect(headLines('foo\nbar\nbaz', 2, 3)).to.equal('');
      expect(headLines('foo\nbar\nbaz', 3, 3)).to.equal('');
      expect(headLines('foo\nbar\nbaz', 4, 3)).to.equal('');

      expect(headLines('foo\nbar\nbaz', 0, 4)).to.equal('');
      expect(headLines('foo\nbar\nbaz', 1, 4)).to.equal('');
      expect(headLines('foo\nbar\nbaz', 2, 4)).to.equal('');
      expect(headLines('foo\nbar\nbaz', 3, 4)).to.equal('');
      expect(headLines('foo\nbar\nbaz', 4, 4)).to.equal('');
      done();
    });
  });
});
