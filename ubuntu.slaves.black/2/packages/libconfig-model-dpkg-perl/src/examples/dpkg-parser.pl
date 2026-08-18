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
use YAML::XS;

# load control file
my $file = path('dpkg-test');

# create your parser
my $parser = MyParser->new() ;

# convert control file data in a Perl data structure
# documented in Config::Model::Backend::DpkgSyntax
my $data = $parser->parse_dpkg_file($file, 'yes', 1);

# print this data in YAML format
print Dump $data;

