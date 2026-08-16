#!/usr/bin/perl
# Copyright (C) 2011-2019, Stefano Rivera <stefanor@debian.org>
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

use strict;
use warnings;

use Test::Simple tests => 35;

use lib '.';
use Debian::DistroInfo;

sub unique {
    my ($needles, $haystack) = @_;
    my $unique = 0;

    my %hash = ();
    @hash{@$haystack}=();
    for my $needle (@$needles) {
        $unique++ if not exists($hash{$needle});
    }
    return $unique;
}

sub symmetric_difference {
    my ($a, $b) = @_;
    return unique($a, $b) + unique($b, $a);
}

my @all = ();
my @returned = ();

# Test our helpers:
@all = ('a', 'b', 'c');
@returned = ('a', 'b', 'c');
ok(unique(\@all, \@returned) == 0, 'unique: Matching lists');
ok(symmetric_difference(\@all, \@returned) == 0,
   'symmetric_difference: Matching lists');
@returned = ('a', 'b');
ok(unique(\@all, \@returned) == 1, 'unique: 1 Unique Item');
ok(unique(\@returned, \@all) == 0, 'unique: 1 Unique Item in the haystack');
ok(symmetric_difference(\@all, \@returned) == 1,
   'symmetric_difference: 1 Unique Item');

# Test DistroInfo:
my @expected = ();
my $date1 = Debian::DistroInfo::convert_date('2011-01-10');
my $date2 = Debian::DistroInfo::convert_date('2016-02-28');
my $date3 = Debian::DistroInfo::convert_date('2020-06-29');

my $deb = DebianDistroInfo->new();
@all = ('buzz', 'rex', 'bo', 'hamm', 'slink', 'potato', 'woody', 'sarge',
           'etch', 'lenny', 'squeeze', 'sid', 'experimental');
@returned = $deb->all($date1);
ok(unique(\@all, \@returned) == 0, 'Debian all');

ok($deb->devel($date1) eq 'sid', 'Debian devel');
ok($deb->old($date1) eq 'etch', 'Debian oldstable');
ok($deb->stable($date1) eq 'lenny', 'Debian stable');
ok($deb->testing($date1) eq 'squeeze', 'Debian testing');
ok($deb->valid('sid'), 'Debian valid');
ok($deb->valid('stable'), 'Debian valid');
ok(!$deb->valid('foobar'), 'Debian invalid');

@expected = ('lenny', 'squeeze', 'sid', 'experimental');
@returned = $deb->supported($date1);
ok(symmetric_difference(\@expected, \@returned) == 0,
   'Debian supported');

@expected = ('squeeze');
@returned = $deb->supported_lts($date2);
ok(symmetric_difference(\@expected, \@returned) == 0,
   'Debian LTS');

@expected = ('wheezy');
@returned = $deb->supported_elts($date3);
ok(symmetric_difference(\@expected, \@returned) == 0,
   'Debian ELTS');

@expected = ('buzz', 'rex', 'bo', 'hamm', 'slink', 'potato', 'woody', 'sarge',
             'etch');
@returned = $deb->unsupported($date1);
ok(symmetric_difference(\@expected, \@returned) == 0,
   'Debian unsupported');

ok(!defined($deb->codename('foo')), 'Debian codename, invalid');
ok($deb->codename('testing', $date1) eq $deb->testing($date1),
   'Debian codename');

ok(!defined($deb->version('foo')), 'Debian version, invalid');
ok($deb->version('lenny') eq '5.0', 'Debian version');

my $ubu = UbuntuDistroInfo->new();
@all = ('warty', 'hoary', 'breezy', 'dapper', 'edgy', 'feisty', 'gutsy',
        'hardy', 'intrepid', 'jaunty', 'karmic', 'lucid', 'maverick', 'natty');
@returned = $ubu->all($date1);
ok(unique(\@all, \@returned) == 0, 'Ubuntu all');

ok($ubu->version('Maverick Meerkat') eq '10.10', 'Ubuntu version');
ok($ubu->version('lucid') eq '10.04 LTS', 'Ubuntu LTS version');

ok($ubu->devel($date1) eq 'natty', 'Ubuntu devel');
ok($ubu->lts($date1) eq 'lucid', 'Ubuntu LTS');
ok($ubu->stable($date1) eq 'maverick', 'Ubuntu stable');
ok($ubu->valid('lucid'), 'Ubuntu valid');
ok(!$ubu->valid(42), 'Ubuntu invalid');
ok($ubu->is_lts('lucid'), 'Ubuntu is_lts');
ok(!$ubu->is_lts(42), 'Ubuntu !is_lts');
ok(!$ubu->is_lts('warty'), 'Ubuntu !is_lts');

@expected = ('dapper', 'hardy', 'karmic', 'lucid', 'maverick', 'natty');
@returned = $ubu->supported($date1);
ok(symmetric_difference(\@expected, \@returned) == 0,
   'Ubuntu supported');

@expected = ('precise', 'trusty', 'xenial');
@returned = $ubu->supported_esm($date2);
ok(symmetric_difference(\@expected, \@returned) == 0,
   'Ubuntu ESM');

@expected = ('warty', 'hoary', 'breezy', 'edgy', 'feisty', 'gutsy', 'intrepid',
             'jaunty');
@returned = $ubu->unsupported($date1);
ok(symmetric_difference(\@expected, \@returned) == 0,
   'Ubuntu unsupported');

# vi: set et sta sw=4 ts=4:
