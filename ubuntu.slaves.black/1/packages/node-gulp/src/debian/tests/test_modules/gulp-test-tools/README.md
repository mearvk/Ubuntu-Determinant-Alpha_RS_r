gulp-test-tools [![Build Status][travis-img]][travis-url] [![Build Status][appveyor-img]][appveyor-url]
===============

Testing tools for gulp

[![NPM][npm-img]][npm-url]

Usage
-----

### gulpRunner

```js
(example.js)
var runner = require('gulp-test-tools').gulpRunner;

runner({ verbose: true })
  .basedir(__dirname)
  .chdir('test')
  .gulp('build', '--gulpfile fixtures/gulpfile.js')
  .run(cb);
  
function cb(err, stdout, stderr) {
  ...
}
```

```sh
$ node example.js
---- command
cd /home/sttk/project;
cd test; 
node /usr/local/lib/node_modules/gulp-cli/bin/gulp.js build --gulpfile fixtures/gulpfile.js
---- error
null
---- stdout
[20:11:53] Working directory changed to ~/project/test/fixtures
[22:11:53] Using gulpfile ~/project/test/fixtures/gulpfile.js
[20:11:53] Starting 'build'...
[20:11:53] Finished 'build' after 5.11 ms

---- stderr

----.
```

### eraseTime

```js
(example.js)
var eraseTime = require('gulp-test-tools').eraseTime;

var gulpOutput = 
  "[20:11:53] Starting 'default'...\n" +
  "[20:11:53] Finished 'default' after 5.11 ms\n";

console.log(eraseTime(gulpOutput));
```

```sh
$ node example.js
Starting 'default'...
Finished 'default' after 5.11 ms

```

### eraseLapse

```js
(example.js)
var eraseLapse = require('gulp-test-tools').eraseLapse;

var gulpOutput = 
  "[20:11:53] Starting 'default'...\n" +
  "[20:11:53] Finished 'default' after 5.11 ms\n";

console.log(eraseLapse(gulpOutput));
```

```sh
$ node example.js
[20:11:53] Starting 'default'...
[20:11:53] Finished 'default' after ?
```

### skipLines

```js
(example.js)
var skipLines = require('gulp-test-tools').skipLines;

var gulpOutput = 
  "[20:11:53] Using gulpfile ~/project/gulpfile-2.js\n" +
  "[20:11:53] Starting 'default'...\n" +
  "[20:11:53] Finished 'default' after 5.11 ms\n";

console.log(skipLines(gulpOutput, 1));
```

```sh
$ node example.js
[20:11:53] Starting 'default'...
[20:11:53] Finished 'default' after 5.11 ms

```


### headLines

```js
(example.js)
var headLines = require('gulp-test-tools').headLines;

var gulpOutput = 
  "[20:11:53] Using gulpfile ~/project/gulpfile-2.js\n" +
  "[20:11:53] Starting 'default'...\n" +
  "Hello, world!\n" +
  "[20:11:53] Finished 'default' after 5.11 ms\n";

console.log(headLines(gulpOutput, 1, 2));
```

```sh
$ node example.js
Hello, world!

```

### How to use gulpRunner with istanbul

Though **gulpRunner** executes a command on a child process, it can get coverage about the command with **istanbul**. The way to get coverage is as follows:

```sh
$ istanbul cover example.js
```

If there are multiple test scripts, you can get their total coverage by following way:

```sh
$ istanbul cover example.js example2.js --print none && istanbul report lcov text-summary
```

If you run test scripts in the directory `./test` with **istanbul** + **mocha**, you should execute the following command:

```sh
$ istanbul cover _mocha --print none && istanbul report lcov text-summary
```

API
---

### <u>gulpRunner([opts])</u>

Creates a gulp runner which generates a command string and runs it.

##### Arguments:

* **opts** [object] : options for a runner. This object has following properties:

  - **verbose** [boolean] : if `true`, prints command, err, stdout, stderr

##### Methods:

* **basedir(path)**

  Sets base directory path.
  This base directory is remained after running gulp.

  **Arguments:**
  
  - **path** [string] : a base directory path.

* **chdir(path [, path ...])**

  Sets directory paths to be changed.

  **Arguments:**

  - **path** [string] : a sequence of directory paths.

* **gulp(arg [, arg ...])**

  Sets gulp command with its arguments.

  **Arguments:**
  
  - **arg** [string] : a sequence of command line arguments.

* **run(cb)**

  Runs gulp command.

  **Arguments:**

  - **cb** [function] : a call back function which is passed result of execution.

### <u>eraseTime(text)</u>

Returns a text which is erased timestamp of each line.

##### Arguments:

* **text** [string] : stdout text of gulp.

### <u>eraseLapse(text)</u>

Returns a text which is erased lapse time of ease line.

##### Arguments:

* **text** [string] : stdout text of gulp.

### <u>skipLines(text, nSkip)</u>

Returns a text which is skipped the specified number of lines.

##### Arguments:

* **text** [string] : stdout text of gulp.
* **nSkip** [number] : line number to be skipped.

### <u>headLines(text, nLine, nSkip)</u>

Returns a first `nLine` lines of a text. If second argument `nSkip` is specified, first `nSkip` lines are skipped.

##### Arguments:

* **text** [string] : stdout text of gulp.
* **nLine** [number] : line number to be output.
* **nSkip** [number] : line number to be skipped. (optional)

License
-------

MIT

[travis-img]: https://travis-ci.org/sttk/gulp-test-tools.svg?branch=master
[travis-url]: https://travis-ci.org/sttk/gulp-test-tools
[appveyor-img]: https://ci.appveyor.com/api/projects/status/github/sttk/gulp-test-tools?branch=master&svn=true
[appveyor-url]: https://ci.appveyor.com/project/sttk/gulp-test-tools
[npm-img]: https://nodei.co/npm/gulp-test-tools.png
[npm-url]: https://nodei.co/npm/gulp-test-tools/
