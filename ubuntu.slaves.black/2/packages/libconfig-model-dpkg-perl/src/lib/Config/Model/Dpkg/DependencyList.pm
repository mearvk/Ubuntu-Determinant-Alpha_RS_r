package Config::Model::Dpkg::DependencyList;

use strict;
use warnings;
use Mouse;

extends qw/Config::Model::ListId/ ;

sub sort_algorithm {
    return sub {
        (substr($_[0],0,1) eq '$' xor substr($_[1],0,1) eq '$') ? $_[1]->fetch cmp $_[0]->fetch
            : $_[0]->fetch cmp $_[1]->fetch;
    };
}

1;
