use strict;
use warnings;

my @tests = (
    {
        name => 'debian-748502' ,
        # required to skip the bad patch (non dep-3)
        load_check => 'no',
        log4perl_load_warnings => [[ User => warn => qr/Ignoring patch/ ]],
        check => {
            'patches:tweak-defaults Synopsis' => 'Tweak defaults values for Debian'
        },
        load => 'patches:~mail-like-patch',
        # bad patch is skipped by config-model but is not removed from patch set
        # hence the 2nd instance must also skip the bad patch
        load_check2 => 'no',
    }
);

return {
    conf_dir => 'debian/patches',
    tests => \@tests,
};
