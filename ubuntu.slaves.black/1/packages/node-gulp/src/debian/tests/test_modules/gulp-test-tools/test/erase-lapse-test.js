'use strict';

var eraseLapse = require('../').eraseLapse;
var expect = require('chai').expect;

describe('erase lapse', function() {

  it('an empty string', function(done) {
    expect(eraseLapse('')).to.equals('');
    done();
  });

  it('a string with no lapse', function(done) {
    expect(eraseLapse(' foo \n bar \n baz ')).to.equals(' foo \n bar \n baz ');
    done();
  });

  it('a string with lapse', function(done) {
    expect(eraseLapse(
      '[10:20:30] Finished \'foo\' after 2 min\n' +
      '[10:20:30] Finished \'bar\' after 50 min\n' +
      '[10:20:30] Finished \'baz\' after 809 μs'
    )).to.equals(
      '[10:20:30] Finished \'foo\' after ?\n' +
      '[10:20:30] Finished \'bar\' after ?\n' +
      '[10:20:30] Finished \'baz\' after ?'
    );
    done();
  });

  it('a string with time and various eol', function(done) {
    expect(eraseLapse(
      '[10:20:30] \'foo\' after 2 s\r\n' +
      '[10:20:30] \'bar\' after 124 ms\r' +
      '[10:20:30] \'baz\' after 534 μs\n' +
      '[10:20:30] \'errorFunction\' errored after 534 μs\n' +
      '[10:20:30] \'qux\' after 534 s'
    )).to.equals(
      '[10:20:30] \'foo\' after ?\n' +
      '[10:20:30] \'bar\' after ?\n' +
      '[10:20:30] \'baz\' after ?\n' +
      '[10:20:30] \'errorFunction\' errored after ?\n' +
      '[10:20:30] \'qux\' after ?'
    );
    done();
  });
});
