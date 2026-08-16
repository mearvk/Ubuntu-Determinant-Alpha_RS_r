'use strict';

/* eslint max-statements: "off" */

var exec = require('child_process').exec;
var path = require('path');
var os = require('os');

var fs = require('fs-extra');
var semver = require('semver');
var fined = require('fined');

var cmdsep = '; ';
var escapeBs = path.join;
var needRedirect = false;

if (os.platform() === 'win32') {
  cmdsep = ' & ';

  escapeBs = function() {
    var pth = path.join.apply(path, arguments);
    return pth.replace(/\\/g, '\\\\');
  };

  needRedirect = semver.lt(process.version, '0.12.0');
}


var regexpInsEol = new RegExp(cmdsep, 'g');

function insertEol(cmd) {
  return cmd.replace(regexpInsEol, cmdsep + '\n');
}


var gulpPath = findGulpPath();
var basePath = process.cwd();

var isIstanbul = process.env.running_under_istanbul;
var rootPath = findPackagePath();
var coveragePath = path.resolve(rootPath, 'coverage');

module.exports = function(opt) {
  opt = opt || {};
  var inst = {};
  inst.basedir = basedirFn;
  inst.chdir = chdirFn;
  inst.gulp = gulpFn;
  inst._command = '';
  inst._verbose = !!opt.verbose;
  inst._basedir = basePath;
  return inst;

  function basedirFn(dir) {
    inst._basedir = dir;
    return {
      chdir: chdirFn,
      gulp: gulpFn,
    };
  }

  function chdirFn(/*...dir*/) {
    inst._command = 'cd ' + escapeBs(path.join.apply(path, arguments));
    return { gulp: gulpFn };
  }

  function gulpFn(/*...args*/) {
    if (inst._command) {
      inst._command += cmdsep;
    }

    if (isIstanbul) {
      inst._command += escapeBs(findIstanbulPath()) +
        ' cover --root ' + escapeBs(rootPath) +
        ' ' + escapeBs(gulpPath) +
        ' --no-color',
        ' --dir ' + escapeBs(createTempdir(coveragePath)) +
        ' --print none' +
        ' --';
    } else {
      inst._command += 'node ' + escapeBs(gulpPath) + ' --no-color';
    }

    for (var i = 0, n = arguments.length; i < n; i++) {
      inst._command += ' ' + arguments[i];
    }

    return { run: runFn };
  }

  function runFn(cb) {
    var redirectDir,
        redirectStdout,
        redirectStderr;

    if (needRedirect) {
      redirectDir = createTempdir();
      redirectStdout = path.join(redirectDir, 'result.out');
      redirectStderr = path.join(redirectDir, 'result.err');
    }

    var cmd = '';
    if (inst._basedir) {
      cmd += 'cd ' + escapeBs(path.resolve(inst._basedir)) + cmdsep;
    }
    cmd += inst._command;

    if (needRedirect) {
      cmd += ' > ' + redirectStdout + ' 2> ' + redirectStderr;
    }

    var child;
    if (!inst._verbose) {
      if (needRedirect) {
        child = exec(cmd, function(err, stdout, stderr) {
          stdout = fs.readFileSync(redirectStdout, 'utf8');
          stderr = fs.readFileSync(redirectStderr, 'utf8');
          fs.remove(redirectDir);
          cb(err, stdout, stderr);
        });
      } else {
        child = exec(cmd, cb);
      }
      inst._command = '';
      return child;
    }

    console.log('---- command');
    console.log(insertEol(cmd));

    child = exec(cmd, function(err, stdout, stderr) {
      if (needRedirect) {
        stdout = fs.readFileSync(redirectStdout, 'utf8');
        stderr = fs.readFileSync(redirectStderr, 'utf8');
        fs.remove(redirectDir);
      }

      console.log('---- error');
      console.log(err);
      console.log('---- stdout');
      console.log(stdout);
      console.log('---- stderr');
      console.log(stderr);
      console.log('----.');
      cb(err, stdout, stderr);
      inst._command = '';
    });
    return child;
  }
};

function createTempdir(dir) {
  dir = dir || os.tmpdir();
  var prefix = 'gulp-test-';

  if (fs.mkdtempSync) {
    return fs.mkdtempSync(path.join(dir, prefix));
  }

  var trial = 10;
  while (trial > 0) {
    var tmpPath = prefix;
    tmpPath += new Date().getTime();
    tmpPath += Math.floor(Math.random() * 1000);

    tmpPath = path.resolve(dir, tmpPath);
    try {
      fs.statSync(tmpPath);
    } catch (e) {
      fs.mkdirSync(tmpPath);
      return tmpPath;
    }
  }

  throw new Error('Cannot create a temporary directory.');
}

function findGulpPath() {
  try {
    return path.join(require.resolve('gulp-cli'), '../bin/gulp.js');
  } catch (e) {
    // When main package is gulp-cli
    var found = fined({ path: 'bin/gulp', extensions: '.js', findUp: true });
    if (found) {
      return found.path;
    }

    throw e;
  }
}

function findIstanbulPath() {
  try {
    return path.join(require.resolve('istanbul'), '../../.bin/istanbul');
  } catch (e) {
    throw e;
  }
}

function findPackagePath() {
  var found = fined({ path: 'package', extensions: '.json', findUp: true });
  if (found) {
    return path.join(found.path, '..');
  }

  return path.resolve('.');
}
