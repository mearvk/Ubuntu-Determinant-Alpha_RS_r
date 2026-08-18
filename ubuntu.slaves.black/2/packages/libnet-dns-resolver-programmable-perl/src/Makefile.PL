use 5.006;
use strict;
use warnings FATAL => 'all';
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'Net::DNS::Resolver::Programmable',
    AUTHOR           => q{David Precious <davidp@preshweb.co.uk>},
    VERSION_FROM     => 'lib/Net/DNS/Resolver/Programmable.pm',
    ABSTRACT_FROM    => 'lib/Net/DNS/Resolver/Programmable.pm',
    LICENSE          => 'perl',
    PL_FILES         => {},
    MIN_PERL_VERSION => 5.006,
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => 0,
    },
    BUILD_REQUIRES => {
        'Test::More' => 0,
    },
    PREREQ_PM => {
        'Net::DNS'       => 0.69,
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'Net-DNS-Resolver-Programmable-*' },
    META_MERGE => {
        resources => {
            repository => 'https://github.com/bigpresh/Net-DNS-Resolver-Programmable',
            bugtracker => 'https://github.com/bigpresh/Net-DNS-Resolver-Programmable/issues',
            homepage   => 'https://github.com/bigpresh/Net-DNS-Resolver-Programmable',
        },
    },
);
