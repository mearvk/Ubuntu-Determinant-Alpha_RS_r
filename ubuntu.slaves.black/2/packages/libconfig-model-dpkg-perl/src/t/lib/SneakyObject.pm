package SneakyObject;

use strict;
use warnings;
use Test::More;
use 5.10.1;

# class used with some fill.copyright.blanks.yml to check that object
# cannot be created from YAML files

sub DESTROY {
    fail "SneakyObject was loaded from YAML data\n";
}

1;

