# -*- cperl -*-

use 5.10.0;
use warnings;
use strict;

use ExtUtils::testlib;
use Test::More ;
use Test::Differences;
use Config::Model::Backend::Dpkg::Control ;
use Log::Log4perl qw(:easy) ;


my @list = ('a' .. 'z');
my @expect = (qw/a d c b/, 'e' .. 'z');
my @move_after = (
    c => 'd',
    b => 'c',
    t => 't', # test no-op
);

Config::Model::Backend::Dpkg::Control::_re_order(\@list, \@move_after);

eq_or_diff(\@list, \@expect," test re-ordered list") ;


done_testing();
