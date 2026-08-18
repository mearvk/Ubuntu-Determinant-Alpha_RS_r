use strict;
use warnings;

use Test::More;
use Test::Command::Simple;

my $CMD = 'uglifyjs.terser';

# skip test bare command: hangs waiting for input
#run_ok $CMD;
#like stdout, qr/^Usage: $CMD/, 'bare command, stdout';
#cmp_ok stderr, 'eq', '', 'bare command, stderr';

run_ok $CMD, qw(--version);
like stdout, qr/^terser [\d.]+$/, 'version, stdout';
cmp_ok stderr, 'eq', '', 'version, stderr';

run_ok $CMD, qw(--help);
like stdout, qr/^\s*Usage: uglifyjs\S* \[options\] \[files\.\.\.\]\n/, 'help, stdout';
cmp_ok stderr, 'eq', '', 'help, stderr';

done_testing;
