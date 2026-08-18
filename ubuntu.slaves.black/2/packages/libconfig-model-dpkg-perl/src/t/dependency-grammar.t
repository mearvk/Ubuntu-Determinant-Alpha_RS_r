# -*- cperl -*-

use ExtUtils::testlib;
use Test::More ;
use Test::Differences;
use Config::Model::Dpkg::Dependency ;
use Log::Log4perl qw(:easy) ;
use 5.10.0;

use warnings;
use strict;

note('To help debugging, this test can be run with the following arguments:');
note('perl -Ilib t/dependency-grammar.t [ args [ test_kind [ pattern ] ] ]');
note('args is rdh rdt rdth for Parse::RecDescent debug');
note('test_kind: g | e for good tests or error tests');
note('pattern is used to filter according to the content of the tested dependency');


my $arg = shift || '';
my ($log,$show,$one) = (0) x 3 ;

use Log::Log4perl qw(:easy) ;
my $home = $ENV{HOME} || "";
my $log4perl_user_conf_file = "$home/.log4config-model";

if ($log and -e $log4perl_user_conf_file ) {
    Log::Log4perl::init($log4perl_user_conf_file);
}
else {
    Log::Log4perl->easy_init($ERROR);
}

{
    no warnings qw/once/;
    $::RD_HINT  = 1 if $arg =~ /rdt?h/;
    $::RD_TRACE = 1 if $arg =~ /rdh?t/;
}

my $parser = Config::Model::Dpkg::Dependency::dep_parser ;

exit main( @ARGV );

sub main {
    my ($do, $pattern)  = @_;

    test_good($pattern) if not $do or $do eq 'g';
    test_errors($pattern) if not $do or $do eq 'e';

    done_testing;
    return 0;
}


sub test_good {
    # dep, data struct
    my $pat = shift;
    my @tests = (
        [ 'foo' ,  { name => 'foo' }  ],
        [ 'foo | bar ' , { name => 'foo' }, { name => 'bar' } ],
        [ 'vorbis-tools|lame' , { name => 'vorbis-tools' }, { name => 'lame' } ],
        [ 'foo | bar | baz ' , { name => 'foo' }, { name => 'bar'}, { name => 'baz'} ],

        [
            'foo ( >= 1.24 )| bar ' ,
            { name => 'foo' , dep => [ '>=','1.24' ]},
            { name => 'bar'}
        ],

        [ # Debian #911756
            'perl:any',
            { name => 'perl', arch_qualifier => 'any' }
        ],

        [ 'foo:native', { name => 'foo', arch_qualifier => 'native' } ],
        [ # Debian #911756
            'perl:any (>= 5.028)',
            { name => 'perl', dep => [ '>=', '5.028' ], arch_qualifier => 'any' }
        ],
        [
            'foo ( >= 1.24 )| bar ( << 1.3a3)' ,
            { name => 'foo',dep => [ '>=','1.24' ]},
            { name => 'bar', dep => [ '<<', '1.3a3']}
        ],
        [
            'foo(>=1.24)|bar(<<1.3a3)  ' ,
            { name => 'foo', dep => ['>=','1.24' ]},
            { name => 'bar', dep => ['<<', '1.3a3']}
        ],

        [
            'foo ( >= 1.24 )| bar [ linux-any]' ,
            { name => 'foo', dep => ['>=','1.24' ]},
            { name => 'bar', arch_restriction => ['linux-any']},
        ],
        [
            'xserver-xorg-input-evdev [alpha amd64 hurd-arm linux-armeb]' ,
            {
                name => 'xserver-xorg-input-evdev',
                arch_restriction => [ qw/alpha amd64 hurd-arm linux-armeb/ ]
            },
        ],

        [
            'xserver-xorg-input-evdev [!alpha !amd64 !arm !armeb]' ,
            {
                name => 'xserver-xorg-input-evdev',
                arch_restriction => [ qw/!alpha !amd64 !arm !armeb/ ]
            }
        ],

        [
            'hal (>= 0.5.12~git20090406) [kfreebsd-any]',
            {
                name => 'hal',
                dep => [ '>=','0.5.12~git20090406'] ,
                arch_restriction => ['kfreebsd-any']
            }
        ],

        [ ('${foo}') x 2 ],
        # see #702792
        [ ('${foo}.1-2~') x 2 ],

        # see #911756
        [ ('systemd-sysv [linux-any] ${alt:sysvinit}') x 2 ],

        # see #826573 and https://wiki.debian.org/BuildProfileSpec
        [
            'mingw-w64-i686-dev (>= 3.0~svn5915)  [ linux-any] <!stage1>',
            {
                name => 'mingw-w64-i686-dev',
                dep => ['>=', '3.0~svn5915'],
                arch_restriction => ['linux-any'],
                profile => [['!stage1']]

            }
        ],
        [
            'foo (>= 1.0) [i386 arm] <!stage1> <!cross>' ,
            {
                name => 'foo',
                dep => ['>=', '1.0'],
                arch_restriction => ['i386', 'arm'],
                profile => [ ['!stage1'], ['!cross'] ]
            }
        ],
        [
            'foo <stage1 cross>',
            {
                name => 'foo',
                profile => [ ['stage1', 'cross'] ]
            }
        ],
        [
            'foo <stage1 cross> <stage1>',
            {
                name => 'foo',
                profile => [ ['stage1', 'cross'], ['stage1'] ]
            }
        ],
        [
            'foo <stage1 cross> <pkg.foo-src.yada-yada>',
            {
                name => 'foo',
                profile => [ ['stage1', 'cross'], ['pkg.foo-src.yada-yada'] ]
            }
        ],
        [
            'mothur [!s390x]',
            {
                name => 'mothur',
                arch_restriction => ['!s390x'],
            }
        ]
    ) ;

    foreach my $td ( @tests ) {
        my ($dep,@exp) = @$td ;
        next if $pat and $dep !~ /$pat/;
        unshift @exp, 1; # match what's returned when there's no errors
        my $ret = $parser->dependency($dep) ;
        eq_or_diff ($ret, \@exp,"parsed dependency '$dep'");
    }
}

sub test_errors {
    my $pat = shift;
    my @tests = (
        [ 'foo@' , q!bad package name: '%%'! ],
        [ 'foo:bar', q!bad architecture qualifier: 'bar'! ],
        [ 'foo ( >= 3.24' , q!Cannot parse: '%%'! ],
        [ 'foo ( >= 3.!4 )' , q(bad dependency version: '3.!4') ],
        [ 'bar( >= 1.1) | foo ( >= 3.!4 )' , q(bad dependency version: '3.!4') ],
        [ 'bar( >= 1.!1) | foo ( >= 3.14 )' , q{bad dependency version: '1.!1)'} ],
        [ 'foo ( <> 3.24 )' , q!bad dependency version operator: '<>'! ],

        [ 'foo ( >= 1.24 )| bar [ binux-any]' , q!bad os in architecture restriction: 'binux'!,
                                                q!bad arch in architecture restriction: 'binux'! ],
        [ 'foo ( >= 1.24 )| bar [ linux-nany]' , q!bad arch in architecture restriction: 'nany'! ],

        [ 'foo${bar' , q!bad package name: '%%'! ],
        [ 'foo ${bar', q!Cannot parse: '%%'! ],
        [
            'xserver-xorg-input-evdev [alpha !amd64 !arm armeb]'
            => q(some names are prepended with '!' while others aren't.: 'alpha !amd64 !arm armeb')
        ],
        [
            'foo <stage3 cross> <stage1>'
            => q!Unknown build profile name 'stage3': 'Expected one of !
             . q!cross pkg stage1 stage2 nobiarch nocheck nodoc nogolang nojava noperl nopython noudeb'!
        ],

    ) ;

    foreach my $td ( @tests ) {
        my ($dep,@errs) = @$td ;
        next if $pat and $dep !~ /$pat/;
        my $ret = $parser->dependency($dep) ;
        foreach (@errs) { s/%%/$dep/;}
        unshift @errs, 0; # match what's returned when there's an error
        eq_or_diff($ret,\@errs,"test error message for dependency '$dep'") ;
    }
}


