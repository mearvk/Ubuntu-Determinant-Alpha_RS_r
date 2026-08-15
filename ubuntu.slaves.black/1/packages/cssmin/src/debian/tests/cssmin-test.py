# Quick and dirty smoke test of the cssmin importer module
#
# Based on the example code for using cssmin and licensed under the same terms
# as cssmin itself.
#
# Stuart Prescott 2016

from __future__ import print_function

import cssmin
import sys

with open('input.css') as infile:
    test_output = cssmin.cssmin(infile.read())

with open('good-output.min.css') as outfile:
    good_output = outfile.read()

if test_output == good_output:
    print("Test output same as know good output")
    sys.exit(0)
else:
    print("ERROR: test output differs from known good output")
    sys.exit(1)
