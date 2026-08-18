use Data::Dumper;
use IO::File;
use utf8;
use Path::Tiny;
use strict;
use warnings;

my $conf_file_name = "copyright";
my $conf_dir       = 'debian';

my @tests = (
    { # t0
        log4perl_load_warnings => [[ User => warn => qr/Missing/, (warn => qr/deprecated/) x 3 ]],
        load_check => 'skip',
        check => {
            'Files:"*" License full_license' => "[PSF LICENSE TEXT]",
            'Files:"*" Copyright' => "2008, John Doe <john.doe\@example.com>\n2007, Jane Smith <jane.smith\@example.com>",
            'Files:"*" License short_name' => "PsF",
            '"Xtest"'                     => "yada yada\n\nyada",
            '"Upstream-Name"'              => "xyz",
            '"Upstream-Contact:0"' => "Jane Smith <jane.smith\@example.com>",
        },
    },

    { #t1
        log4perl_load_warnings => [[ User => (warn => qr/deprecated/) x 3 ]],

        check => {
            'License:"MPL-1.1" text'     => "[MPL-1.1 LICENSE TEXT]",
            'License:"GPL-2+" text'    => "[GPL-2 LICENSE TEXT]",
            'License:"LGPL-2.1+" text' => "[LGPL-2.1 plus LICENSE TEXT]",
            'Files:"src/js/editline/*" License short_name' =>
              "MPL-1.1 or GPL-2+ or LGPL-2.1+"
        },

    },
    { # t2
        log4perl_load_warnings => [[ User => warn => qr/deprecated/ ]],

        check => {
            'License:MPL-1.1 text' => "[MPL-1.1 LICENSE TEXT]",
            'Files:"*" License short_name' => "MPL-1.1",
            'Files:"src/js/fdlibm/*" License short_name'   => "MPL-1.1",
        },
        file_contents_like => {
            'debian/copyright' => qr/Format: http/ ,
        }
    },

    # the empty license will default to 'other'
    { # t3
        check => {
            'Comment' => "\nHeader comment 1/2\nHeader comment 2/2",
            'Files:"*" Comment' => "\n Files * comment 1/2\nFiles * comment 2/2",
            'Files:"planet/vendor/compat_logging/*" Comment' 
                => "\nFiles logging * comment 1/2\n Files logging * comment 2/2",
            'Files:"planet/vendor/compat_logging/*" License short_name' => "MIT",
        },
    },
    { # t4
        log4perl_load_warnings => [[ User => warn => qr/deprecated/ ]],

        check => {
            'Source'                       => "http:/some.where.com",
            'Files:"*" License short_name' => "GPL-2+ with OpenSSL exception",
            'Files:"*" License full_license' =>
              "This program is free software; you can redistribute it\n"
              . " and/or modify it under the terms of the [snip]",
        },
    },
    { #t5

        log4perl_load_warnings => [[ User => (warn => qr/deprecated/) x 3 ]],
        check => {
            'Files:"*" License short_name' => "LGPL-2+",
            'Source' => 'http://search.cpan.org/dist/Config-Model-CursesUI/',
            'License:"LGPL-2+" text' =>
"   [snip]either version 2.1 of\n   the License, or (at your option) any later version.\n"
              . "   [snip again]",
        },
    },
    { # t6

        log4perl_load_warnings => [[ User => (warn => qr/deprecated/) x 3 ]],

        check => {
            'Upstream-Contact:0' => 'Ignace Mouzannar <mouzannar at gmail.com>',
            'Files:"Embedded_Display/remoteview.cpp Embedded_Display/remoteview.h" License short_name'
              => "GPL-2",
        },
    },
    { # t7
        # example from CANDIDATE DEP-5 spec (nb 7)
        log4perl_load_warnings => [[
            'User',
            map { ( warn => $_ ) } qr/Adding/, qr/insecure/, qr/Format does not match/, qr/trailing slash/
        ]],
        load_check => 'skip',
        apply_fix => 1,
        check => { 
            Format => "https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/", 
            'Files:"*" Copyright' => 'Copyright 1998 John Doe <jdoe@example.com>',
            'Files:"debian/*" License short_name' => 'other',
            'Files-Excluded' => '*.jar 3rdparty/libtommath 3rdparty/stuff',
        },
    },
    {
        # test nb 8
        apply_fix => 1,
        check => {
            Format => "https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/", 
            'Files:"*" Copyright' => "2008, John Doe <jdoe\@example.com>\n2007, Jane Smith <jsmith\@example.org>\n2007, Joe Average <joe\@example.org>\n2007, J. Random User <jr\@users.example.com>",
        },
    },
    {   # t9
        log4perl_load_warnings => [[
            'User',
            map { ( warn => $_ ) } qr/insecure/, qr/Format does not match/ ,qr/should not match/
        ]],
        apply_fix => 1,
        load => 'Files~"*/share/web/static/[css|js|images]/yui/*"',
        check => {
            'Files:"*" Copyright' => 'foo',
            'Files:"*" License short_name' => 'BSD',
            'Files:"*" License full_license' => ' foo bar',
        },
    },
    { # t10
        log4perl_load_warnings => [[ User => (warn => qr/UK spelling/) x 4, (warn => qr/deprecated/) x 2 ]],

        check => { 
            Format => "https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/", 
            # something's wrong with utf8 string checks
            #'Debianized-By' => 'Picca Frédéric-Emmanuel <picca@synchrotron-soleil.fr>',
            Source => 'http://tango-controls.org/download',
            #'Files:"*" Copyright:0' => '© 2010, The Tango team <tango@esrf.fr>',
            'Files:"debian/*" License short_name' => 'GPL-3+',
        },
    },

    { # t11 Debian bug #610231
        # i.e. how to handle a file with missing info
        apply_fix => 1,
        dump_errors =>  [ 
            qr/mandatory/ => 'Files:"*" Copyright="(c) foobar"',
            qr/mandatory/ => ' License:FOO text="foo bar" ! Files:"*" License short_name="FOO" '
        ],
    },

    { # t12
        load_check => 'no',
        dump_errors =>  [ 
            qr/not declared/ => 'License:Expat text="Expat license foobar"',
        ],
    },

    { # t13 Debian bug #624305 (parsing DEP5 copyright with a comma in the License field)
        log4perl_load_warnings => [[ User => warn =>  qr/insecure/, warn => qr/Format does not match/ ]],
        apply_fix => 1,
    },

    { # t14 Debian bug #633847
        # need to change License model from Hash of leaves to hash of nodes 
        log4perl_load_warnings => [[
            'User',
            map { ( warn => $_ ) } (qr/comma/) x 4 , qr/insecure/, qr/Format does not match/ ]],
        apply_fix => 1,
        check => { 
            'Comment' => "On Debian systems, copies of the GNU General Public License version 1
and Lesser General Public License version 2.1 can be found respectively in
‘/usr/share/common-licenses/GPL-1’ and ‘/usr/share/common-licenses/LGPL-2.1’.",
            'License:Perl Comment',"On Debian systems, the complete text of the Artistic License can be
found in ‘/usr/share/common-licenses/Artistic’, and the complete text of
the latest version of the GNU General Public License version 1 can be found
in ‘/usr/share/common-licenses/GPL-1’.",
            'Files:"lib/Bio/Graphics/Glyph/rndrect.pm
      lib/Bio/Graphics/Glyph/splice_site.pm
        lib/Bio/Graphics/Glyph/extending_arrow.pm" License short_name' => 'Perl',
            'Files:"lib/Bio/Graphics/FeatureDir.pm lib/Bio/Graphics/Glyph/pairplot.pm lib/Bio/Graphics/Glyph/generic.pm" License short_name' => "GPL-1+ or Artistic-2.0",
            'Files:lib/Bio/Graphics/Layout.pm License short_name' => "LGPL-2.1+ or Artistic-2.0",
        } ,
    },

    {
        name => 'libpadre-plugin-perltidy-perl',
        log4perl_load_warnings => [[ User => ( warn => qr/deprecated/) x 4  ]],
        check => {
            'Files:"*" License short_name' => "Artistic or GPL-1+" ,
            'Files:"*" License-Alias' => { qw/check no value Perl/}, # deprecated but not yet removed
        },
        wr_check => {
            'Files:"*" License short_name' => "Artistic or GPL-1+" ,
            'Files:"*" License-Alias' => { check => 'no' },
        },
    },

    {
        name => 'migrate-license-alias',
        load_check => 'skip', # missing Files: * in 2nd section
        log4perl_load_warnings => [[ User => warn => qr/Missing/, ( warn => qr/deprecated/) x 4  ]],
        check => {
            'Files:"*" License short_name' => "Artistic or GPL-1+" ,
            'Files:"*" License-Alias' => { qw/check no value Perl/},
        },
        wr_check => {
            'Files:"*" License short_name' => "Artistic or GPL-1+" ,
            'Files:"*" License-Alias' => { check => 'no' },
        },
    },
    {
        name => 'oar',
        log4perl_load_warnings => [[ User => warn => qr/insecure/, warn =>  qr/use Expat/ ]],
        apply_fix => 1,

        check => {
            Format => "https://www.debian.org/doc/packaging-manuals/copyright-format/1.0/",
            'Files:"sources/extra/orpheus/modules/lua-signal/lsignal.c" License short_name' => 'Expat'
        }
    },
    {
        # Debian bug #721832
        name => 'white-space' ,
        log4perl_load_warnings => [[ User => warn => qr/deprecated/ ]],

        check => {
            'License:MPL-1.1 text' => "[MPL-1.1 LICENSE TEXT]",
            'Files:"*" License short_name' => "MPL-1.1",
            'Files:"src/js/fdlibm/*" License short_name'   => "MPL-1.1",
        },
        file_contents_like => {
            'debian/copyright' => qr/Copyright:\n/ ,
        },
        file_contents_unlike => {
            'debian/copyright' =>  [ qr/Copyright:\s+\n/ , qr/\n\n$/, qr/Copyright:\s*\nLicense/ ],
        }
    },
    {
        # Debian bug #721670
        name => 'double-copyright' ,

        check => {
            'Files:"*" Copyright' => "(c) 2000-2001 Andrew Ho\n"
            . "(c) 2004 David Coppit\n"
            . "The original code (written before April 20, 2001) was written [...]",
        },
    },
    {
        # Debian bug #721672
        name => 'file-instead-of-files' ,

        # warning brought by fix of Debian #789568
        log4perl_load_warnings => [[
            User => warn => qr/section 'File' is converted in 'Files'/,
            warn => qr/double entry/,
        ]],

        check => {
            "Files:debian/patches/half_code_pod_errors.patch Copyright" =>
            '2010, Frank Wiegand <fwie@cpan.org>',
        },
    },
    {
        # Debian bug #xxx
        name => 'owncloud-client' ,

        check => {
#            "Files:debian/patches/half_code_pod_errors.patch Copyright" =>
#            '2010, Frank Wiegand <fwie@cpan.org>',
        },
    },

    {
        name => 'update-from-scratch',
        update => { in => path('t/scanner/examples/pan.in') , quiet => 1 },
        check => {
            "License:GPL-2 text" => {value => undef, mode => 'custom'},
            "License:GPL-2 text" => qr/GNU/,
        },
        wr_check => {
            "License:GPL-2 text" => {value => undef, mode => 'custom'},
            "License:GPL-2 text" => qr/GNU/,
        }
    },

    {
        name => 'moarvm-from-scratch',
        update => { in => path('t/scanner/examples/moarvm.in'), quiet => 1 },
        check => {
            'License:ISC text' => qr/Please fill/,
            'License:BSD-2-clause text' => qr/Please fill/,
            'License:"Artistic-2.0" text' => [
                qr/The Artistic License 2.0/,
                {mode => 'custom', value => undef},
            ],
            'Files:"3rdparty/libuv/samples/*" License short_name' => "BSD-3-clause and/or Expat",
        },
        wr_check => {
            qq!Files:"3rdparty/dyncall/*" License full_license! => undef,
            'License:"Artistic-2.0" text' => [
                qr/The Artistic License 2.0/,
                {mode => 'custom', value => undef},
            ],
        },
        has_not_key => [ License => qr!and/or! ],
        file_contents_unlike => {
            'debian/copyright' => qr/\n\nLicense: ISC\n\n/,
            'debian/copyright' => qr/\n\nLicense: BSD-2-clause\n\n/,
        },
    },

    { # Debian bug  #797321
        name => 'warn-MIT',
        log4perl_load_warnings => [[ User => (warn => qr/many versions of the MIT license/) x 2 ]],
        apply_fix => 1,
        check => {
            "License:Expat text" => 'yada',
            "License:MITA text" => 'yada',
            'Files:"*" License short_name' => 'Expat',
            'Files:"a/*" License short_name' => 'MITA',
        }
    },

    { # Debian bug  #797322
        name => 'warn-BSD',
        log4perl_load_warnings => [[ User => (warn => qr/Please use BSD-x-clause/) x 3 ]],
        apply_fix => 1,
        check => {
          'Files:"*" License short_name' => 'BSD-2-clause',
          'Files:"a/*" License short_name' => 'BSD-like',
          'Files:"b/*" License short_name' => 'BSD-3-clause',
          'Files:"c/*" License short_name' => 'BSD-3-clause',
          'Files:"d/*" License short_name' => 'my-BSD-3',
          'License:BSD-2-clause text' => 'yada',
          'License:BSD-3-clause text' => 'yada',
          'License:BSD-like text' => 'yada',
        }
    },

    {
        name => 'unused-license',
        # the unused license
        check_before_fix => {
            'License:"MPL-1.1" text'     => "[MPL-1.1 LICENSE TEXT]",
        },

        apply_fix => 1, # clean up unused license

        # check that unused license was removed
        has_not_key => [ 'License' => 'MPL-1.1' ],
        check => {
            'License:"GPL-2+" text'    => "[GPL-2 LICENSE TEXT]",
            'License:"LGPL-2.1+" text' => "[LGPL-2.1 plus LICENSE TEXT]",
            'Files:"src/js/editline/*" License short_name' =>
              "GPL-2+ or LGPL-2.1+"
        },

    },

    {
        name => 'by-dh-make',
        load_check => 'skip',
    },

    {
        name => 'new-perl-module',
        update => { in => path('t/scanner/examples/libtk-fontdialog.in') , quiet => 1 },
        check => {
            'Files:"*" Copyright' => qr/Slaven/,
            # check that Perl license is replaced by Artistic or GPL-1+
            'Files:"*" License short_name' => 'Artistic or GPL-1+',
        },
    },

    {
        # in this case, the copyright file produced by dh-make-perl is
        # not valid: the License short_name for File:"*" is empty.
        name => 'by-dh-make-perl',
        update => { in => path('t/scanner/examples/by-dh-make-perl.in') , quiet => 1 },
    },

    {
        name => 'node-gulp-from-scratch',
        update => { in => path('t/scanner/examples/node-gulp.in') , quiet => 1 },
        check => {
            'Files:"make-iterator/*" Copyright' =>
                [ qr/moutjs team/, qr/Schlinkert/ ],
            'Files:"make-iterator/*" License short_name' => 'Expat',
        }
    },

    {
        name => 'node-gulp',
        update => { in => path('t/scanner/examples/node-gulp.in') , quiet => 1 },
        check => {
            # merged info from LICENSE and README file
            'Files:"make-iterator/*" Copyright' =>
                [ qr/moutjs team/, qr/Schlinkert/ ],
            'Files:"make-iterator/*" License short_name' => 'Expat', # merged info
        }
    },
);

return {
    conf_file_name => $conf_file_name,
    conf_dir => $conf_dir,
    tests => \@tests,
};
