package MyParser ;

use strict;
use warnings;

use 5.20.1;

# DpkgSyntax uses Log4perl, so we must initialise this module
use Log::Log4perl qw(:easy);
Log::Log4perl->easy_init($WARN);

# load role
use Mouse ;
with 'Config::Model::Backend::DpkgSyntax';

package main ;
use Path::Tiny;

my $data = [
    [
        '# section comment', qw/Name Foo/,
        '# data comment', qw/Version 1.2/
    ],
    [
        qw/Name Bar Version 1.3/ ,
        Files => [qw/file1/, [ 'file2' , '# inline comment'] ] ,
        Description => "A very\n\nlong description"
    ]
];

my $parser = MyParser->new() ;

# print control file content
say $parser->write_dpkg_file($data) ;
