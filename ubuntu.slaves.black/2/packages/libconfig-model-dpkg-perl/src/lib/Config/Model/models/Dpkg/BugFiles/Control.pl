use strict;
use warnings;

return [
  {
    'element' => [
      'report-with',
      {
        'description' => 'Often programs are distributed across several different packages, for
example an upstream package \'foo\' may be packaged in Debian as foo, libfoo,
foo-common and foo-data.  In such cases it can be useful to include related
package information in bugreports, to minimise the need for \'moreinfo\' requests
to the submitter :) This is done by adding a "report-with" header to the
control file::

        report-with: foo libfoo foo-common foo-data

Package information will be added to the bug report for each extra package
listed.

See L<README.developers|https://anonscm.debian.org/cgit/reportbug/reportbug.git/tree/doc/README.developers> for details.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'package-status',
      {
        'description' => 'request that the status information for other packages
(that are not dependencies or recommendations) be included with the
report.

See L<README.developers|https://anonscm.debian.org/cgit/reportbug/reportbug.git/tree/doc/README.developers> for details.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'Submit-As',
      {
        'description' => 'The package maintainer can control to which packages bug reports are
submitted, by setting the Package: field of the bug report.  This will
be mainly used to redirect bugs in packages coming from a single
source to where the maintainer likes to have them. See L<README.developers|https://anonscm.debian.org/cgit/reportbug/reportbug.git/tree/doc/README.developers> for details.',
        'type' => 'leaf',
        'value_type' => 'uniline'
      },
      'Send-To',
      {
        'description' => 'Packages not distributed by Debian can take advantage of reportbug utility too with this parameter. For instance:

        Send-To: bugs.myproject.com

``reportbug`` will add ``submit@` ``quiet@`` or ``maintonly@`` to form the address the
bug report mail is send to.

(Note: you probably should use dpkg\'s support for Origin and Bugs tags
in lieu of this support.)

See L<README.developers|https://anonscm.debian.org/cgit/reportbug/reportbug.git/tree/doc/README.developers> for details.
',
        'type' => 'leaf',
        'value_type' => 'uniline'
      }
    ],
    'name' => 'Dpkg::BugFiles::Control',
    'rw_config' => {
      'assign_char' => ':',
      'assign_with' => ': ',
      'auto_create' => '1',
      'auto_delete' => '1',
      'backend' => 'IniFile',
      'config_dir' => 'debian',
      'file' => '&index(-).bug-control'
    }
  }
]
;

