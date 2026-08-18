# DH Sequence for eclipse helper.

## no critic (Modules::RequireExplicitPackage)

use strict;
use warnings;
use autodie;

use Debian::Debhelper::Dh_Lib;

# Build rules
insert_after('dh_auto_build', 'jh_setupenvironment');
insert_after('jh_setupenvironment', 'jh_generateorbitdir');
insert_after('jh_generateorbitdir', 'jh_compilefeatures');

# Install rules
insert_after('dh_install', 'jh_installeclipse');

# Clean rules
insert_before('dh_clean', 'jh_clean');

1;
