'use strict';

var skipLines = require('../').skipLines;

var expect = require('chai').expect;

describe('skip lines', function() {

  it('an empty string', function(done) {
    expect(skipLines('', 0)).to.equal('');
    expect(skipLines('', 1)).to.equal('');
    expect(skipLines('', 2)).to.equal('');
    done();
  });

  it('an string which has single line', function(done) {
    expect(skipLines('single line', 0)).to.equal('single line');
    expect(skipLines('single line', 1)).to.equal('');
    expect(skipLines('single line', 2)).to.equal('');
    done();
  });

  it('an string which has multiple lines', function(done) {
    expect(skipLines('foo\nbar\nbaz', 0)).to.equal('foo\nbar\nbaz');
    expect(skipLines('foo\nbar\nbaz', 1)).to.equal('bar\nbaz');
    expect(skipLines('foo\nbar\nbaz', 2)).to.equal('baz');
    done();
  });

});
