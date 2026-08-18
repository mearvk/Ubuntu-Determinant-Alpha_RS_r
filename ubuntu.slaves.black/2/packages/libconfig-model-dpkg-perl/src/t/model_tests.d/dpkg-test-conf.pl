use strict;
use warnings;

use Data::Dumper;
use Path::Tiny;
use Carp;
use Carp::Assert;
use Carp::Assert::More;
use utf8;
use Config::Model::BackendMgr ;
use Config::Model::Dpkg::Dependency;

my $conf_file_name = "";
my $conf_dir       = '';
my $model_to_test  = "Dpkg";

eval { require AptPkg::Config; };
my $skip = ( $@ or not -r '/etc/debian_version' ) ? 1 : 0;

my $home_for_test = '/home/joe' ;
Config::Model::BackendMgr::_set_test_home($home_for_test) ;

my $str = `/usr/bin/dpkg -l debhelper`;
my ($current_compat) = ($str =~ /ii\s+debhelper\s+(\d+)/);

# required to set value that enable creation of dummy changelog:
# changelog is computed from my_config email and name which are also
# computed from environment variable. If any of these var is undef,
# the my_config value are undef, and the changelog is also undef. In
# this case, the changelog file is not written and the tests that
# expect a new changelog file also fail.. Kind of domino effect
$ENV{DEBFULLNAME} ||= "John Doe";
$ENV{DEBEMAIL} ||= 'johndoe@naibed.gro';

# File::HomeDir->my_config is broken.
my %tweak_map = (
    'home' => "$home_for_test/.dpkg-meta.yml",
    '-home' => "$home_for_test/.dpkg-meta.yml",
    config => "$home_for_test/.config/config-model/dpkg-meta.yml",
    log => '/debian/changelog',
    rules => '/debian/rules',
    '-compat' => '/debian/compat',
);

# returns a sub used to tweak list of debian files
# very specific to this test. Cannot go in a t/lib file
sub tweak {
    # @to_tweak is a closure used in inner sub
    my @to_tweak = @_;
    my @to_add = grep { ! /^-/ } @to_tweak;
    my @to_rm = grep { /^-/ } @to_tweak;
    return sub {
        push @{$_[0]}, map {
            $tweak_map{$_} || croak "bad dir to tweak $_";
        } @to_add;
        foreach my $rm_name ( @to_rm ) {
            my $dir_to_rm = $tweak_map{$rm_name} || croak "bad dir to tweak $rm_name";
            for (my $i = 0; $i < @{$_[0]}; $i++ ) {
                splice @{$_[0]}, $i, 1 if $_[0][$i] eq $dir_to_rm;
            }
        }
    };
};

{
    # sanity check for the tweak function above
    my @tweak_test = ('foo','bar', $tweak_map{'-home'});
    my $add = tweak('log', '-home');
    $add->(\@tweak_test);
    assert_in( 'foo', \@tweak_test , "found foo"  );
    assert_in( $tweak_map{log}, \@tweak_test , "found added log");

    affirm {
        ! grep {$_ eq $tweak_map{'-home'}} @tweak_test ;
    } "old home dir is gone";
}

my @tests = (
    {   name => 't0',
        check => {
            'control source Build-Depends-Indep:3' => 'libtest-pod-perl',
            # there's no apply_fix in this test, that's why compat and debhelper stay at 8
            'control source Build-Depends:0' => 'debhelper (>= 8)',
            'compat' => 8,
            'package-scripts:. postinst' => qr/dummy postinst/,
            'package-scripts:t0 prerm' => qr/dummy prerm/,
            'package-scripts:t0/amd64 postrm' => qr/dummy postrm script for amd64/,
            'package-scripts:./amd64 preinst' => qr/dummy preinst script for amd64/,
            'examples:t0 content:0' => 'examples/'
        },
        log4perl_load_warnings => [[
            User =>  map {(warn => $_)} qr/source Standards-Version/, qr/compat/, (qr/debhelper/) x 2 , qr/Dual dependency/
        ]],
    },

    {   name => 't1',
        log4perl_load_warnings => [[
            User => map {(warn => $_)} qr/standard/, qr/compat/, (qr/debhelper/) x 2 , qr/canonical/, qr/invalid/
        ]],
        apply_fix => 1 ,
        load => qq!patches:fix-spelling Description="more spelling details"!
            . qq( ! patches:glib-single-include Synopsis="mega patchchoid")
            ,
        check => {
            'patches:fix-spelling Synopsis', 'fix man page spelling',
            # test synopsis generated from patch name
            'patches:fix-man-page-spelling Synopsis', 'Fix man page spelling',
            'patches:use-standard-dzil-test Synopsis', "use standard dzil test suite",
            'patches:glib-single-include Synopsis', "mega patchchoid",
            'patches:use-standard-dzil-test Description',
              "Test is modified in order not to load the Test:Dzil module\nprovided in t/lib",
            'control source Build-Depends:0' => "debhelper-compat (= $current_compat)" ,
        },
        file_check_sub => tweak(qw!-compat!),
        warnings => [ (qr/deprecated/) x 3 ],
    },

    {
        name => 'autopkgtest',
        check => {
            'tests control:0 Tests:0' => 'fred',
            'tests control:0 Tests:2' => 'bongo',
            'tests control:0 Depends' => "pkg1, pkg2 [amd64] | pkg3 (>= 3)",
            'tests control:0 Restrictions' => "breaks-testbed,needs-root",
        },
    },

    {
        name => 'libversion' ,
        apply_fix => 1 ,
        check => {
            'control source Build-Depends-Indep:0' => 'perl',
            'control source Build-Depends-Indep:1' => 'libversion-perl',
            # check that duplicated dependency is removed
            'control source Build-Depends-Indep:2' => 'libdist-zilla-perl',
            'bugfiles:libversion bug-script' => qr/dummy script/,
            'bugfiles:libversion bug-control report-with' => 'libreoffice-core',
            'bugfiles:libversion bug-control package-status' => 'udev dracut initramfs-tools',
        },
        file_check_sub => tweak(qw!-compat!),
    },
    {
        name => 'pan-copyright-from-scratch',
        update => { in => path('t/scanner/examples/pan.in'), quiet => 1, no_warnings => 0 },
        check => {
            "copyright License:GPL-2 text" => {value => undef, mode => 'custom'},
            "copyright Upstream-Name" => 'pan',
            "copyright License:GPL-2 text" => qr/GNU/,

            # copyright from files or existing debian/copyright are now normalised
            'copyright Files:pan/general/sorted-vector.h Copyright' => '2002, Martin Holzherr (holzherr@infobrain.com).',

            # no space after comma because data comes from fix.scanned.copyright
            'copyright Files:pan/general/map-vector.h Copyright' => "2001,Andrei Alexandrescu",
            'copyright Files:pan/general/map-vector.h License short_name' => 'MIT',
            'copyright Files:pan/general/map-vector.h License full_license' => undef,
            'copyright Files:pan/general/sorted-vector.h Copyright' =>
            '2002, Martin Holzherr (holzherr@infobrain.com).'
        },
        wr_check => {
            "copyright License:GPL-2 text" => {value => undef, mode => 'custom'},
            "copyright License:GPL-2 text" => qr/GNU/,
        },
        file_check_sub => tweak(qw/log/),
    },
    {
        # should that be pan-copyright-upgrate ? :-p
        name => 'pan-copyright-upgrade-update',
        update => { in => path('t/scanner/examples/pan.in'), quiet => 1 },

        check => {
            "copyright License:GPL-2 text" => {value => undef, mode => 'custom'},
            "copyright License:GPL-2 text" => qr/GNU/,
            'copyright Files:pan/general/map-vector.h Copyright' => qr"2001, Andrei Alexandrescu",
            'copyright Files:pan/general/map-vector.h License short_name' => 'NTP',
            'copyright Files:pan/general/map-vector.h License full_license'
            => 'yada yada show-copyright stuff',
            'copyright Files:pan/general/sorted-vector.h Copyright'
            => '2002, Martin Holzherr (holzherr@infobrain.com).',
            'copyright Files:pan/general/sorted-vector.h License short_name' => 'public-domain',
            # entry "uulib/fptools.c\n uulib/fptools.h"is packed by update
            qq'copyright Files:"*" Copyright' => '1994-2001, Frank Pilhofer.',
            'copyright Files:pan/gui/xface.c Copyright' => qr/^James/,
        },
        wr_check => {
            "copyright License:GPL-2 text" => {value => undef, mode => 'custom'},
            "copyright License:GPL-2 text" => qr/GNU/,
        },
        file_check_sub => tweak(qw/log/),
    },
    {
        # emulate removed and added file, updated copyright years
        # the difference with above test is in debian/copyright file to be updated
        name => 'pan-copyright-upgrade-update-more',
        update => { in => path('t/scanner/examples/pan.in'), quiet => 1 },

        check => {
            "copyright License:GPL-2 text" => {value => undef, mode => 'custom'},
            "copyright License:GPL-2 text" => qr/GNU/,
            'copyright Files:pan/general/map-vector.h Copyright' => qr"2001, Andrei Alexandrescu",
            'copyright Files:pan/general/map-vector.h License short_name' => 'NTP',
            'copyright Files:pan/general/map-vector.h License full_license'
            => 'yada yada show-copyright stuff',
            'copyright Files:pan/general/sorted-vector.h Copyright'
            => '2002, Martin Holzherr (holzherr@infobrain.com).',
            'copyright Files:pan/general/sorted-vector.h License short_name' => 'public-domain',
            qq'copyright Files:"*" Copyright' => '1994-2001, Frank Pilhofer.',
        },
        has_key => {
            'copyright Files' => ['*'],
        },
        has_not_key => {
            'copyright Files' => ['pan/data/*','uulib/*'],
        },
        wr_check => {
            "copyright License:GPL-2 text" => {value => undef, mode => 'custom'},
            "copyright License:GPL-2 text" => qr/GNU/,
        },
        file_check_sub => tweak(qw/log/),
    },

    {
        # Debian bug #795195
        name => 'open-nebula-from-scratch',
        update => { in => path('t/scanner/examples/open-nebula.in'), quiet => 1 },
        load => 'copyright License:"MPL-2.0" text="mpl 2.0 blah-blah € «»" '
            . '! copyright Files:"src/sunstone/public/css/novnc-custom.css" License full_license~',
        file_contents_like => {
            'debian/copyright' => [
                qr!Files: src/im_mad/remotes/az.d/\*!, '€ «»'
            ]
        },
        file_check_sub => tweak(qw/rules log/),
        file_contents_unlike => {
            'debian/copyright' => [
                qr!Files: src/im_mad/\*!,
                qr!Files: share/vendor/ruby/gems/rbvmomi/lib/rbvmomi/vim/\*!,
                qr!Files: NOTICE!,
                qr!Files: debian!,
            ],
        },
        file_contents_like => {
            # rules files must finish with a newline
            'debian/rules' => qr!\n$!,
        },

    },

    {
        # Debian bug #795195
        name => 'open-nebula',
        update => {
            in => path('t/scanner/examples/open-nebula.in'),
            quiet => 1,
            # fill.copyright.blanks tests #863052. Unfortunately, the
            # only symptom is a warning showing up during upgrade,
            # hence this update_warnings which works only from
            # Config::Model::Tester 2.061 (ignored otherwise)
            update_warnings => []
        },
        file_contents_like => {
            'debian/copyright' => [
                qr!Files: src/im_mad/remotes/az.d/\*!
            ]
        },
        file_check_sub => tweak(qw/rules log/),
        # check that some entries were fixed by update
        check => {
            'copyright Files:"share/vendor/*" Copyright' => '2010-2012, VMware, Inc.',
            'copyright Files:"src/sunstone/public/css/novnc-custom.css" Copyright' => qr/Mannehed/,
            'copyright Files:"src/cloud/ec2/lib/net_ssh_replacement.rb" Copyright' => qr/Jamis/,
            'copyright Files:"share/pkgs/openSUSE/systemd/onedsetup" Copyright' => '2015, Marcel Mézigue',
            'copyright Files:"share/pkgs/openSUSE/systemd/onedsetup" License short_name' => 'GPL-3+ or Apache-2.0, and unicode'

        },
        file_contents_unlike => {
            'debian/copyright' => [
                qr!Files: src/[hit]m_mad/\*!,
            ],
        },

    },

    {
        name => 'rakudo-star',
        update => { in => path('t/scanner/examples/rakudo-star.in'), quiet => 1 },
        check => {
            'copyright Files:"modules/Perl6-MIME-Base64/*" Copyright' => 'Adrian White',
            'copyright Files:"modules/DBIish/*" Comment' => qr/should be preserved by cme update/,
            'install:rakudo-star content:0' => 'usr/bin/*',
            'install:rakudo-star content:1' => 'usr/share/*',
            'install:rakudo-star/dummy content:0' => 'usr/share/dummy/*',
        },
        has_not_key => [
               'copyright Files' => qr/gone/,
           ],
        file_check_sub => tweak(qw/log/),
    },

    {
        name => 'batmon-app',
        update => { in => path('t/scanner/examples/batmon.app.in'), quiet => 1 },
        # test rename and read of debian/install file
        check => {
            'install:"." content:0' => 'debian/batmon.desktop usr/share/applications',
            'install:"." content:1' => 'batmon.xpm usr/share/pixmaps',
            'install:./arm content:0' => '# dummy install for arm',
            'install:batmon.app content:0' => '# dummy batmon.app.install',
            'install:batmon.app/amd64 content:0' => '# dummy batmon.app.install for amd64',
            'install:batmon.app content:1' => 'debian/batmon.desktop usr/share/applications',
            'install:batmon.app content:2' => 'usr/plop/batmon.xpm usr/share/pixmaps',
        },
        apply_fix => 1,
        file_check_sub => tweak(qw/-compat/),
        load => 'install:"." content:.push("plop.txt usr/share/doc/batmon.app")',
        # this entry is merged in debian/* *if* the Copyright coming from file is normalised
        # Also closes #862368
        has_not_key => [
            'copyright Files' => 'GNUmakefile',
        ],
        file_contents_unlike => {
            'debian/copyright' => [
                qr!Files: GNUmakefile!,
            ],
        },
        file_contents_like => {
            'debian/install' => [qr!batmon.desktop!, qr/plop/],
        },
        wr_check => {
            'install:"." content:0' => 'debian/batmon.desktop usr/share/applications',
            'install:"." content:1' => 'batmon.xpm usr/share/pixmaps',
        },
    },

    {
        name => 'my_config_update',
        check => {
            'my_config email' => 'joe@foo.com',
        },
        # my_config file is moved from legacy location to new location
        file_check_sub => tweak('-home','config'),
        file_contents_like => {
            $tweak_map{config} => qw/joe@foo\.com/,
        }
    },

    {
        name => 'my_config_regular',
        check => {
            'my_config email' => 'joe@foo.com',
        },
        file_contents_like => {
            $tweak_map{config} => qw/joe@foo\.com/,
        }
    },

    {
        name => 'lintian-overrides',
        apply_fix => 1,
        check => {
            'lintian-overrides:libburn4' => [
                # check that tag was renamed from shlib-calls-exit
                qr/exit-in-shared-library/,
                # check that comment is present
                qr/decide whether/, qr/busy drives\.\n/,
            ],
            'lintian-overrides:.' => [
                # check that plain overrides file is handled
                qr/exit-in-shared-library/,
            ],
            'source lintian-overrides' => [
                # check that source overrides file is handled
                qr/libburn source: source-is-missing/,
            ],
        },
        full_dump => {
            log4perl_dump_warnings => [
                [User => warn => qr/dummy-tag/],
            ],
        },
    }
);

my $cache_file = path('t/model_tests.d/dependency-cache.txt');

$Config::Model::Dpkg::Dependency::use_test_cache = 1;
untie %Config::Model::Dpkg::Dependency::cache;
%Config::Model::Dpkg::Dependency::cache = ();

foreach my $line ( $cache_file->lines ) {
    chomp $line;
    next unless $line;
    my ( $k, $v ) = split m/ => /, $line;
    $Config::Model::Dpkg::Dependency::cache{$k} = time . ' '. $v;
}

END {
    return if $::DebianDependencyCacheWritten;
    my %h = %Config::Model::Dpkg::Dependency::cache;
    do { s/^\d+ //;} for (values %h) ; # remove time stamp
    my $str = join( "\n", map { "$_ => $h{$_}"; } sort keys %h );

    print "writing back cache file\n";
    $cache_file->spew($str);
    $::DebianDependencyCacheWritten = 1;
}

return {
    conf_file_name => $conf_file_name,
    conf_dir => $conf_dir,
    home_for_test => $home_for_test,
    tests => \@tests,
};
