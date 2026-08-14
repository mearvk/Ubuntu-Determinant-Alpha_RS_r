#!/usr/bin/env python3

# Copies (installs) file(s) into a new location.
#
# Usage:
#   install-file.py SOURCE... DESTINATION
#
# Copy SOURCE file as DESTINATION file if DESTINATION ends with
# a filename extension, or copy SOURCE file(s) into DESTINATION
# directory.
#
# All leading components of DESTINATION path are created if they
# don't exist. Paths can contain environment variables. If SOURCE
# is a symlink, a new symlink in created instead of installing
# the file the link points to.

import sys
import os
import shutil

source = sys.argv[1:-1]
dest = os.path.expandvars(sys.argv[-1])

if not os.path.splitext(dest)[1]:
  dest_dir = dest
else:
  if len(source) == 1:
    dest_dir = os.path.dirname(dest)
  else:
    raise Exception("Too many source files") 

os.makedirs(dest_dir, exist_ok=True)

for src in source:
  try:
    shutil.copy(src, dest, follow_symlinks=False)
  except FileExistsError:
    if os.path.islink(dest):
      os.remove(dest)
      shutil.copy(src, dest, follow_symlinks=False)
