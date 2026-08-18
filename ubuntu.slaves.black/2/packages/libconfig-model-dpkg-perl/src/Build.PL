#    Copyright (c) 2005-2013 Dominique Dumont.
#
#    This file is part of Config-Model-Dpkg.
#
#    Config-Model-Dpkg is free software; you can redistribute it and/or
#    modify it under the terms of the GNU Lesser Public License as
#    published by the Free Software Foundation; either version 2.1 of
#    the License, or (at your option) any later version.
#
#    Config-Model-Dpkg is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
#    Lesser Public License for more details.
#
#    You should have received a copy of the GNU Lesser Public License
#    along with Config-Model; if not, write to the Free Software
#    Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
#    02110-1301 USA

use Module::Build;

use warnings FATAL => qw(all);
use strict;

require 5.010001 ;

my $code = << 'EOC';
sub ACTION_build {
    my $self = shift;
    # below requires Config::Model 2.026, and need to use local library
    system ($^X, '-MConfig::Model::Utils::GenClassPod', '-e','gen_class_pod();') == 0
                    or die "gen-class-pod failed: $?";
    $self->SUPER::ACTION_build;
};
EOC

my $class = Module::Build->subclass(
	class => "Module::Build::Custom",
	code => $code,
);

# see Module::Build::Cookbook
my %appli_files = map { ( $_, $_ ) } glob("lib/Config/Model/*.d/*");
my %cme_scripts = map { ( $_, $_ ) } grep { not /~$/ } glob("lib/Config/Model/scripts/*");

my $build = $class->new(
    module_name => 'Config::Model::Dpkg',
    license       => 'lgpl',
    appli_files   => \%appli_files,
    cme_script_files   => \%cme_scripts,
    dist_abstract => 'Edit and validate dpkg source files with cme',
    dist_author   => 'Dominique Dumont (dod at debian dot org)',

    'build_requires' => {
        'Config::Model::Tester' => '2.043', # need specific bug fix
        'Module::Build' => '0.34',
        'Test::Differences' => '0',
        'Test::Exception' => '0',
        'Test::Memory::Cycle' => '0',
        'Test::More' => '0',
        'Test::Warn' => '0.11'
    },
    'requires' => {
        'Config::Model' => '2.055',
        'LWP::Simple' => '0',
        'DB_File' => '0',
        'File::Path' => '2.07',
        'IO::File' => '0',
        'Log::Log4perl' => '1.11',
        'Mouse' => '0',
        'Parse::RecDescent' => 'v1.90.0',
        'Software::License' => 0,
    },

    meta_merge => {
        resources => {
            homepage => 'https://github.com/dod38fr/config-model/wiki',
            MailingList =>
            'https://lists.sourceforge.net/lists/listinfo/config-model-users',
            repository =>
            'git://anonscm.debian.org/pkg-perl/packages/libconfig-model-dpkg-perl.git',
        },
    },

    recursive_test_files => 1,

    # cleanup required by t/auto_read.t
    add_to_cleanup => [ qw/wr_root r_root/ ],
);

$build->add_build_element('pl');
$build->add_build_element('appli');
$build->add_build_element('cme_script');

$build->create_build_script;
