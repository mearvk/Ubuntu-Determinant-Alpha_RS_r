'use strict';

var expect = require('chai').expect;
var runner = require('../').gulpRunner;

describe('run gulp', function() {

  it('Should not share properties', function(done) {
    var r1 = runner();
    var r2 = runner();

    r2._verbose = !r1._verbose;
    r2._basedir = __dirname;
    r2._command = 'xxxx';

    expect(r1._verbose).not.to.equal(r2._verbose);
    expect(r1._basedir).not.to.equal(r2._basedir);
    expect(r1._command).not.to.equal(r2._command);
    done();
  });

  it('Should run gulp (verbose)', function(done) {
    runner({ verbose: true })
      .basedir(__dirname)
      .chdir('fixtures')
      .gulp('--tasks-simple')
      .run(cb);

    function cb(err, stdout) {
      expect(stdout).to.equal('task1\ntask2\ndefault\n');
      done();
    }
  });

  it('Should run gulp --cwd (verbose)', function(done) {
    runner({ verbose: true })
      .basedir(__dirname)
      .gulp('--tasks-simple --cwd ./fixtures')
      .run(cb);

    function cb(err, stdout) {
      expect(stdout).to.equal('task1\ntask2\ndefault\n');
      done();
    }
  });

  it('Should run gulp', function(done) {
    runner()
      .basedir(__dirname)
      .chdir('fixtures')
      .gulp('--tasks-simple')
      .run(cb);

    function cb(err, stdout) {
      expect(stdout).to.equal('task1\ntask2\ndefault\n');
      done();
    }
  });

  it('Should run gulp --cwd', function(done) {
    runner()
      .basedir(__dirname)
      .gulp('--tasks-simple --cwd ./fixtures')
      .run(cb);

    function cb(err, stdout) {
      expect(stdout).to.equal('task1\ntask2\ndefault\n');
      done();
    }
  });

  it('Should not clear basedir after running', function(done) {
    var r = runner().basedir(__dirname + '/fixtures');
    r.gulp('--tasks-simple').run(function(err, stdout) {
      expect(stdout).to.equal('task1\ntask2\ndefault\n');
    });
    r.chdir('foo/bar').gulp('--tasks-simple').run(function(err, stdout) {
      expect(stdout).to.equal('a\nb\ndefault\n');
    });
    r.gulp().run(function(err, stdout) {
      expect(stdout).to.equal('task1\ntask2\ndefault\n');
    });
    done();
  });

  it('Should be able to set multiple arguments to `chdir`', function(done) {
    runner({ verbose: true })
      .basedir(__dirname)
      .chdir('fixtures', 'foo', '..', 'foo', 'bar')
      .gulp('--tasks-simple')
      .run(cb);

    function cb(err, stdout) {
      expect(stdout).to.equal('a\nb\ndefault\n');
    }
    done();
  });
});

