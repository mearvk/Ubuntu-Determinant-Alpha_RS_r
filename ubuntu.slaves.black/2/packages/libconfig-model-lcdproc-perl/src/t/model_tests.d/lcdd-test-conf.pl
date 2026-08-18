#
# This file is part of Config-Model-LcdProc
#
# This software is Copyright (c) 2013-2021 by Dominique Dumont.
#
# This is free software, licensed under:
#
#   The GNU Lesser General Public License, Version 2.1, February 1999
#
use strict;
use warnings;

my @fix_warnings ;
my $triplet = `dpkg-architecture -qDEB_HOST_MULTIARCH`;
chomp $triplet;
my $std_path = "/usr/lib/$triplet/lcdproc/" ;
my $path = $std_path;

if (! -d $std_path) {
   $path = "/tmp/" ;
   push @fix_warnings,
    (
        #load_warnings => [ qr/code check returned false/ ],
        load => "server DriverPath=$path" , # just a work-around
    )
}

my @tests = (
    {
        # t0
        check => [
            'server Hello:0',           qq!  Bienvenue! ,
            'server Hello:1',           qq(   LCDproc et Config::Model!) ,
            'server Driver', 'curses',
            'server DriverPath', { mode => 'standard', value => $std_path },
            'server DriverPath', $path ,
            'curses Size', '20x2',
            'server AutoRotate', 'off',
        ],
        @fix_warnings ,
        apply_fix => 1,
        load_warnings => [ qr/missing DriverPath dir/],
        errors => [
            # qr/value 2 > max limit 0/ => 'fs:"/var/chroot/lenny-i386/dev" fs_passno=0' ,
        ],
        file_contents_like => {
            "/etc/LCDd.conf" => qr!"  Bienvenue"!
        }
    },
    {
        # test upgrade from raw lcdproc 0.5.5
        name => 'LDCd-0.5.5',
        load_warnings => [ qr/missing DriverPath dir/],
        @fix_warnings ,
        apply_fix => 1,
        load_check => 'skip'
    },
    {
        # likewise for lcdproc 0.5.6
        name => 'LDCd-0.5.6',
        load_warnings => [ qr/missing DriverPath dir/],
        @fix_warnings ,
        apply_fix => 1,
        load_check => 'skip'
    },
    {
        name => 'with-2-drivers',
        load_warnings => [ qr/missing DriverPath dir/],
        check => {
            'server Hello:0',           qq!  Bienvenue! ,
            'server Hello:1',           qq(   LCDproc et Config::Model!) ,
            'server Driver', 'curses,lirc',
            'curses Size', '20x2',
            'server AutoRotate', 'off',
            'lirc prog','lcdd',
        },
        @fix_warnings ,
        apply_fix => 1,
    },
);

return {
    model_to_test => "LCDd" ,
    conf_file_name => "LCDd.conf" ,
    conf_dir => "etc" ,
    tests => \@tests
};


