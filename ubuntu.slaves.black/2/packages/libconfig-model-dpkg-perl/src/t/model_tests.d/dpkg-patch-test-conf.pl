use strict;
use warnings;

my $conf_file_name = "some-patch";

my $conf_dir       = 'debian/patches';
my $model_to_test  = "Dpkg::Patch";

my @tests = (
    {
        name => 'libperl5i' ,
        backend_arg => $conf_file_name,
        log4perl_load_warnings => [[
            'User',
            warn => qr/https protocol should be used instead of http/,
            warn => qr/This field should contain an URL to Debian BTS and not just a bug number/,
            warn => qr/https protocol should be used instead of http/,
            warn => qr/Unknown host or protocol for Debian BTS/,
            warn => qr/This field should contain an URL to Debian BTS and not just a bug number/,
            warn => qr/https protocol should be used instead of http/,
            warn => qr/Unknown host or protocol for Debian BTS/,
        ]],
        load =>'Bug-Debian:.push(" http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=768073")',
        apply_fix => 1 ,
        check => {
            'Subject' => qr/Make one test TODO/,
            'Description' => [ qr/utf8::all/, qr/From 879/, qr/2012/ ],
            'Bug:0' => 'https://github.com/schwern/perl5i/issues/218',
            'Bug:1' => 'https://github.com/schwern/perl5i/issues/219',
            'Origin' => 'https://github.com/doherty/perl5i',
            'Bug-Debian:0' => 'https://bugs.debian.org/655329',
            'Bug-Debian:3' => 'https://bugs.debian.org/768073',
        },
        # file_check_sub => $del_home,
    },
    {
        name => 'moarvm' ,
        backend_arg => $conf_file_name,
        check => {
            'Subject' => qr/Configure.pl/,
        },
        # check that subject stays first field
        file_contents_like => {
            "$conf_dir/$conf_file_name" => [ qr/^Subject/ ] ,
        }
    },
    {
        name => 'by-git',
        backend_arg => $conf_file_name,
        check => {
            Synopsis => "Some patch", # set by apply_fix
            Description => qr/enhance/,
            diff => qr/@@ -7,7/
        },
        apply_fix => 1,
        # check that description is first field
        file_contents_like => {
            "$conf_dir/$conf_file_name" => [ qr/^Description/ ] ,
        }

    },
    {
        name => 'bare-patch',
        backend_arg => $conf_file_name,
        log4perl_load_warnings => [[
        ]],
        apply_fix => 1,
        check => {
            Synopsis => 'Some patch',
        }
    },
    {
        name => 'multi-line-subject',
        backend_arg => $conf_file_name,
        check => {
            # the 2 lines of the Subject are glued together
            Subject => 'pretend this is a long subject that got wrapped by gbp-pq',
        }
    },
    {
        name => 'subject-and-description',
        backend_arg => $conf_file_name,
        check => {
            # the 2 lines of the Subject are glued together
            Subject => 'Ensure the date is represented in UTC when generating PDF files.',
            Description => qr/^Use SOURCE_DATE_EPOCH directly/,
        }
    },
    {
        name => 'subject-and-unstructured-description',
        backend_arg => $conf_file_name,
        check => {
            # the 2 lines of the Subject are glued together
            Subject => 'Ensure the date is represented in UTC when generating PDF files.',
            Description => qr/^Use SOURCE_DATE_EPOCH directly/,
        }
    },
    {
        name => 'from-dep-3',
        backend_arg => $conf_file_name,
        check => {
            # the 2 lines of the Subject are glued together
            Subject => 'Fix regex problems with some multi-bytes characters',
            Description => qr!^\* posix/bug-regex17.c!,
        }
    },
);

return {
    conf_file_name => $conf_file_name,
    conf_dir => $conf_dir,
    tests => \@tests,
};
