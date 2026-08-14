:Version: 21.4b2
:Date: 2021-10-10
:Copyright: 2018 Łukasz Langa
:Title: black
:Subtitle: uncompromising Python code formatter
:Manual group: uncompromising Python code formatter
:Manual section: "1"

Summary
#######

``black`` is the uncompromising Python code formatter. By using it,
you  agree to cede control over minutiae of hand-formatting. In return,
Black gives you speed, determinism, and freedom from pycodestyle
nagging about formatting. You will save time and mental energy for
more important matters.

Usage
#####

black [OPTIONS] [SRC]...

Common Options
##############

Options:
  -c, --code TEXT                 Format the code passed in as a string.
  -l, --line-length INTEGER       How many characters per line to allow.
                                  [default: 88]

  -t, --target-version [py27|py33|py34|py35|py36|py37|py38|py39]
                                  Python versions that should be supported by
                                  Black's output. [default: per-file auto-
                                  detection]

  --pyi                           Format all input files like typing stubs
                                  regardless of file extension (useful when
                                  piping source on standard input).

  -S, --skip-string-normalization
                                  Don't normalize string quotes or prefixes.
  -C, --skip-magic-trailing-comma
                                  Don't use trailing commas as a reason to
                                  split lines.

  --check                         Don't write the files back, just return the
                                  status.  Return code 0 means nothing would
                                  change.  Return code 1 means some files
                                  would be reformatted.  Return code 123 means
                                  there was an internal error.

  --diff                          Don't write the files back, just output a
                                  diff for each file on stdout.

  --color / --no-color            Show colored diff. Only applies when
                                  `--diff` is given.

  --fast / --safe                 If --fast given, skip temporary sanity
                                  checks. [default: --safe]

  --include TEXT                  A regular expression that matches files and
                                  directories that should be included on
                                  recursive searches.  An empty value means
                                  all files are included regardless of the
                                  name.  Use forward slashes for directories
                                  on all platforms (Windows, too).  Exclusions
                                  are calculated first, inclusions later.
                                  [default: \.pyi?$]

  --exclude TEXT                  A regular expression that matches files and
                                  directories that should be excluded on
                                  recursive searches.  An empty value means no
                                  paths are excluded. Use forward slashes for
                                  directories on all platforms (Windows, too).
                                  Exclusions are calculated first, inclusions
                                  later.  [default: /(\.git|\.hg|\.mypy_cache|
                                  \.tox|\.venv|_build|buck-out|build|dist)/]

  --extend-exclude TEXT           Like --exclude, but adds additional files
                                  and directories on top of the excluded ones.
                                  (Useful if you simply want to add to the
                                  default)

  --force-exclude TEXT            Like --exclude, but files and directories
                                  matching this regex will be excluded even
                                  when they are passed explicitly as
                                  arguments.

  --stdin-filename TEXT           The name of the file when passing it through
                                  stdin. Useful to make sure Black will
                                  respect --force-exclude option on some
                                  editors that rely on using stdin.

  -q, --quiet                     Don't emit non-error messages to stderr.
                                  Errors are still emitted, silence those with
                                  2>/dev/null.

  -v, --verbose                   Also emit messages to stderr about files
                                  that were not changed or were ignored due to
                                  --exclude=.

  --version                       Show the version and exit.

  --config FILE                   Read configuration from PATH.

  -h, --help                      Show this message and exit.
