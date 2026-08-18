use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  NAME          => 'Algorithm::Diff',
  VERSION_FROM  => 'lib/Algorithm/Diff.pm', # finds $VERSION

  # Note that EXE_FILES is not provided.  The programs shipped with
  # Algorithm-Diff have traditionally not been installed to the $PATH, and are
  # unlikely to get installed there in the future.

  META_ADD      => {
    license => 'http://dev.perl.org/licenses/',
  },
);
