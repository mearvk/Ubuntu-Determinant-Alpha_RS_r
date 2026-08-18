use Data::Dumper;
use Path::Tiny;
use Config::Model::Dpkg::Dependency;
use Carp;

use strict;
use warnings;

my $conf_file_name = "control";
my $conf_dir       = 'debian';

# lintian 2.105.0, #968000
chomp( my $std_ver = qx| /usr/share/lintian/private/latest-policy-version | );
$std_ver =~ s|^(\d+\.\d+\.\d+)(?:\.\d+)?$|$1|;
croak "Failed to get last Standards-Version" unless defined $std_ver;

my $t3_description = "This is an extension of Dist::Zilla::Plugin::InlineFiles, 
providing the following file:

 - xt/release/pod-spell.t - a standard Test::Spelling test" ;

my $jellyfish_annotation = << 'EON';
Package: python3-dna-jellyfish
Architecture: any
Section: python
Depends: ${python3:Depends},
         ${misc:Depends},
         ${shlibs:Depends}
Description: count k-mers in DNA sequences (Python bindings of jellyfish)
 JELLYFISH is a tool for fast, memory-efficient counting of k-mers in
 DNA. A k-mer is a substring of length k, and counting the occurrences
 of all such substrings is a central step in many analyses of DNA
 sequence. JELLYFISH can count k-mers using an order of magnitude less
 memory and an order of magnitude faster than other k-mer counting
 packages by using an efficient encoding of a hash table and by
 exploiting the "compare-and-swap" CPU instruction to increase
 parallelism.
 .
 JELLYFISH is a command-line program that reads FASTA and multi-FASTA
 files containing DNA sequences. It outputs its k-mer counts in an
 binary format, which can be translated into a human-readable text
 format using the "jellyfish dump" command.
 .
 This package contains the Python bindings of jellyfish.
EON
    ;

chomp $jellyfish_annotation;

my @tests = (
    {

        # t0
        check => {
            'source Source',          "libdist-zilla-plugins-cjm-perl",
            'source Standards-Version' => $std_ver,
            'source Build-Depends:0', "debhelper (>= 7)",
            'source Build-Depends-Indep:0', "libcpan-meta-perl",     # fixed
            'source Build-Depends-Indep:1', "libdist-zilla-perl",    # fixed
            'source Build-Depends-Indep:5', "libpath-class-perl",
            'source Build-Depends-Indep:6', "libmodule-build-perl (>= 0.360000)", # fixed
            'source Build-Depends-Indep:7', "udev [linux-any] | makedev [linux-any]",
            'source X-Comment' => qr/Debian #810023/,
            'source Priority' => 'optional',
            'binary:libdist-zilla-plugins-cjm-perl X-Comment' => qr/Debian #810023/,

            'binary:libdist-zilla-plugins-cjm-perl Depends:0' => '${misc:Depends}',
            'binary:libdist-zilla-plugins-cjm-perl Conflicts:0' => undef, # removed by apply-fix
            'source Vcs-Browser' ,'https://salsa.debian.org/perl-team/modules/packages/libdist-zilla-plugins-cjm-perl',
            'source Vcs-Git', 'https://salsa.debian.org/perl-team/modules/packages/libdist-zilla-plugins-cjm-perl.git',
        },
        log4perl_load_warnings => [ [ User => map { (warn => $_ ) } (
            qr/standards version/,
            qr/dependency/,
            (qr/unnecessary/) x 3, qr/Dual dependency/, (qr/dependency/) x 2,
            qr/unnecessary/,
            qr/applied on too old package/, # warning about Conflicts field
        ) ] ],
        apply_fix => 1,
        file_contents_like => {
            'debian/control' => [
                # check that write order is tweaked for Standards-Version
                qr!Standards-Version: [\d.]+\nVcs-Browser!
            ]
        },
        file_contents_unlike => {
            'debian/control' => [
                # check that libuv0.10-dev conflicts was removed
                qr!libuv0.10-dev!
            ]
        },
    },
    {

        # t1
        check => { 'binary:seaview Recommends:0', 'clustalw', },
        apply_fix => 1,
        load => 'binary:seaview Synopsis="multiplatform interface for sequence alignment"',
    },
    {

        # t2
        check => {
            'binary:xserver-xorg-video-all Architecture' => 'any',
            'binary:xserver-xorg-video-all Depends:0'    => '${F:XServer-Xorg-Video-Depends}',
            'binary:xserver-xorg-video-all Depends:1'    => '${misc:Depends}',
            'binary:xserver-xorg-video-all Replaces:0'   => 'xserver-xorg-driver-all',
            'binary:xserver-xorg-video-all Conflicts:0'  => 'xserver-xorg-driver-all',
        },
        apply_fix => 1,
    },
    {

        # t3
        check => {
            # no longer mess up synopsis with lcfirst
            'binary:libdist-zilla-plugin-podspellingtests-perl Synopsis' =>
              "Release tests for POD spelling",
            'binary:libdist-zilla-plugin-podspellingtests-perl Description' => $t3_description ,
        },
        load => 'binary:libdist-zilla-plugin-podspellingtests-perl '
            . 'Description="'.$t3_description.'"',
        apply_fix => 1,
    },
    {

        # t4, also checks XS-Python-Version deprecation
        check => {
            'source Priority' => 'extra',
            'source X-Python-Version' => ">= 2.3, << 2.5",
            'source Standards-Version', "3.9.8",
        },
        log4perl_load_warnings => [ [
            User =>
            warn => qr/Standards-Version/,
            warn => qr/deprecated/
        ] ],
    },
    {

        # t5
        check => { 'source X-Python-Version' => ">= 2.3, << 2.6" },
        log4perl_load_warnings => [[ User => warn => qr/deprecated/ ]],
    },
    {

        # t6
        check => { 'source X-Python-Version' => ">= 2.3" },
        log4perl_load_warnings => [[ User => warn => qr/deprecated/ ]],
    },
    {
        name => 'sdlperl',
        load => 'source Uploaders:2="Sam Hocevar (Debian packages) <sam@zoy.org>"',
        load_check => 'skip',
        check => {
            'binary:libsdl-perl Depends:2' => '${misc:Depends}',
            'binary:libsdl-perl Conflicts:2' => undef,
        },
        apply_fix => 1,
    },
    {
        name => 'libpango-perl',
        verify_annotation => {
            'source Build-Depends' => " do NOT add libgtk2-perl to build-deps (see bug #554704)",
            'source Maintainer'    => " what a fine\n team this one is",
        },
        apply_fix => 1,
    },
    {
        name => 'libwx-scintilla-perl',
        apply_fix => 1,
    },
    {
        # test for #683861 -- dependency version check and epochs
        name => 'libmodule-metadata-perl',
        apply_fix => 1,
    },
    {
        # test for #682730 (reduces libclass-isa-perl | perl (<< 5.10.1-13) to perl)
        name => 'libclass-meta-perl',
        check => { 'source Build-Depends-Indep:1' => 'libclass-isa-perl' },
        apply_fix => 1,
    },
    {
        # test for #692849, must not warn about missing libfoo dependency
        name => 'dbg-dep',
    },
    {
        # test for #696768, Built-Using field
        name => 'built-using',
        apply_fix => 1,
    },
    {
        # test for #719753, XS-Autobuild field
        name => 'non-free',
        check => {
            'source Section' => 'non-free/libs',
            'source XS-Autobuild' => 'yes',
        },
    },
    {
        # test for #713053,  XS-Ruby-Versions and XB-Ruby-Versions fields
        name => 'ruby',
        apply_fix => 1, # to fix pkg-testsuite param
        check => {
            'source XS-Ruby-Versions' => 'all',
            'binary:libfast-xs-ruby XB-Ruby-Versions' => '${ruby:Versions}',
        },
    },
    {
        # test for #903905,  XS-Ruby-Versions in a package not maintained
        # by ruby team
        name => 'ruby-in-med-team',
        check => {
            'source XS-Ruby-Versions' => 'all',
            'binary:ruby-rgfa XB-Ruby-Versions' => '${ruby:Versions}',
        },
    },
    {
        # test for XS-Testsuite field
        name => 'xs-testsuite',
        log4perl_load_warnings => [ [
            User => warn => qr/source Standards-Version/,
            warn => qr/deprecated/
        ] ],
        apply_fix => 1,
        check => {
            'source Testsuite' => 'autopkgtest-pkg-ruby',
        },
    },
    {
        name => 'gnu-r-stuff',
        # last warning is about line too long.
        log4perl_load_warnings => [[
            User => map { (warn => $_)} qr/standards version/ , (qr/Vcs/) x 2 , qr/Description/
        ]],
        apply_fix => 1,
        check => [
            'source Section' => 'gnu-r',
            'binary:gnu-r-view Section' => 'gnu-r',
        ]
    },
    {
        name => 'build-profiles',
        apply_fix => 1,
        check => {
            'binary:pkg-config Build-Profiles' => '<!stage1>',
            'binary:pkg-config-stage1 Build-Profiles' => '<stage1>',
            'source Build-Depends:3' => 'libglib2.0-dev <!stage1>'
        },
    },

    {
        name => 'comments-in-dep-list',
        file_contents_like => {
            "debian/control" => qr/# Python/,
        }
    },

    {
        name => 'tricky-comment',
        verify_annotation => {
            'binary:libmoosex-types-iso8601-perl Synopsis' => " not yet packaged\n Recommends",
        }
    },

    {
        name => 'med-team',
        log4perl_load_warnings => [ [
            User => warn => qr/source Standards-Version/,
            ( warn => qr/canonical/) x 2
        ]],
        apply_fix => 1,
        check => {
            'source Vcs-Git' => 'https://salsa.debian.org/med-team/abacas.git',
            'source Vcs-Browser' => 'https://salsa.debian.org/med-team/abacas',
        },
    },
    {
        name => 'neurodebian-team',
        apply_fix => 1,
        check => {
            'source Vcs-Git' => 'https://salsa.debian.org/neurodebian-team/caret-data.git',
            'source Vcs-Browser' => 'https://salsa.debian.org/neurodebian-team/caret-data',
        },
    },
    {
        name => 'bcftools',
        apply_fix => 1,
        verify_annotation => {
            'binary:bcftools Suggests:0' => " These are needed for plot-vcfstats"
        },
        check => {
            'binary:bcftools Suggests:0' => "python"
        },
    },
    {
        name => 'rules-requires-root-non-ascii',
        log4perl_load_warnings => [[
            User => map {(warn => $_)} (qr/Current standards version/, qr/Invalid value/)
        ]],
        load => 'source Rules-Requires-Root="foo/bar"',
        check => {
            'source Rules-Requires-Root' => qr/no|binary-targets|([^\P{PosixGraph}\/]{2,}\/\p{PosixGraph}{2,}\s*)+/,
        },
    },
    {
        name => 'rules-requires-root-too-short',
        log4perl_load_warnings => [[
            User => map {(warn => $_)} (qr/Current standards version/,qr/Invalid value/)
        ]],
        load => 'source Rules-Requires-Root="no"',
        check => {
            'source Rules-Requires-Root' => qr/no|binary-targets|([^\P{PosixGraph}\/]{2,}\/\p{PosixGraph}{2,}\s*)+/,
        },
    },
    {
        name => 'rules-requires-root-invalid-item',
        log4perl_load_warnings => [[
            User => map {(warn => $_)} (qr/Current standards version/,qr/Invalid value/)
        ]],
        load => 'source Rules-Requires-Root="binary-targets"',
        check => {
            'source Rules-Requires-Root' => qr/no|binary-targets|([^\P{PosixGraph}\/]{2,}\/\p{PosixGraph}{2,}\s*)+/,
        },
    },
    {
        name => 'rules-requires-root-several-keywords',
        log4perl_load_warnings => [[
            User => map {(warn => $_)} (qr/Current standards version/,qr/Invalid value/)
        ]],
        load => 'source Rules-Requires-Root="abc/acme xyz/debian"',
        check => {
            'source Rules-Requires-Root' => qr/no|binary-targets|([^\P{PosixGraph}\/]{2,}\/\p{PosixGraph}{2,}\s*)+/,
        },
    },
    {
        name => 'init-system-helpers',
        check => {
            'source Build-Depends:1' => 'perl:any',
        }
    },
    {
        name => 'npm2deb_package',
        check => {
            'source Build-Depends:0' => 'debhelper (>= 11~)',
            'source Build-Depends:1' => 'nodejs',
        }
    },
    {
        # Debian
        name => 'jellyfish',
        verify_annotation => {
            'binary:libjellyfish-perl' => $jellyfish_annotation,
            'source Source' => " Dummy source comment\n that should be preserved when writing file backend",
        }
    },
    {
        name => 'libburn-with-autoreconf',
        check_before_fix => {
            log4perl_dump_warnings => [ ],
        },
        apply_fix => 1,
        check => {
            'source Build-Depends:0' => undef,
            'source Build-Depends:1' => 'pkg-config',
            'source Build-Depends:2' => 'debhelper-compat (= 13)',
            'source Build-Depends:3' => qr/libcam-dev/,
        }
    }
);

my $cache_file = path('t/model_tests.d/dependency-cache.txt');

$Config::Model::Dpkg::Dependency::use_test_cache = 1;
untie %Config::Model::Dpkg::Dependency::cache;
%Config::Model::Dpkg::Dependency::cache = ();

foreach my $line ($cache_file->lines) {
    chomp $line;
    next unless $line;
    my ($k,$v) = split m/ => /, $line ;
    $Config::Model::Dpkg::Dependency::cache{$k} = time . ' '. $v ;
}

END {
    return if $::DebianDependencyCacheWritten ;
    my %h = %Config::Model::Dpkg::Dependency::cache ;
    do { s/^\d+ //;} for values %h ; # remove time stamp
    my $str = join ("\n", map { "$_ => $h{$_}" ;} sort keys %h) ;

    my $fh = new IO::File "> $cache_file";
    print "writing back cache file\n";
    if ( defined $fh ) {
        # not a big deal if cache cannot be written back
        $fh->print($str);
        $fh->close;
        $::DebianDependencyCacheWritten=1;
    }
}

return {
    conf_file_name => $conf_file_name,
    conf_dir => $conf_dir,
    tests => \@tests,
};
