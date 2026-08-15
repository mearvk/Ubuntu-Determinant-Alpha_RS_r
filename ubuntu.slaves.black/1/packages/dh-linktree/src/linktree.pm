use warnings;
use strict;

use Debian::Debhelper::Dh_Lib;

insert_after("dh_link", "dh_linktree");

1;
