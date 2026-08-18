#!/usr/bin/perl
#
#      A Simple Terminal Resizing Example
#      GPL version 2. See the COPYING file
#
# This script is a simple example of how handle terminal
# window resize events (transmitted via the WINCH signal)
# -- Jeff Carr <jcarr@linuxmachines.com>
#

if( ! defined $ARGV[0] ) {
	print "Usage: ssh.pl <host> <username> <password>\n";
	exit;
}

my ($host, $username, $password) = @ARGV;

use Expect;
use IO::Pty;

my $spawn = new Expect;
$spawn->raw_pty(1);  

# This gets the size of your terminal window
$spawn->slave->clone_winsize_from(\*STDIN);

my $PROMPT;

# This function traps WINCH signals and passes them on
sub winch {
	my $signame = shift;
	my $pid = $spawn->pid;
	$shucks++;
	print "count $shucks,pid $pid, SIG$signame\n";
	$spawn->slave->clone_winsize_from(\*STDIN);
	kill WINCH => $spawn->pid if $spawn->pid;
}
$SIG{WINCH} = \&winch;  # best strategy

$spawn=Expect->spawn("ssh $username\@$host");
# log everything if you want
# $spawn->log_file("/tmp/autossh.log.$$");

my $PROMPT  = '[\]\$\>\#]\s$';
my $ret = $spawn->expect(5,
	[ qr/\(yes\/no\)\?\s*$/ => sub { $spawn->send("yes\n"); exp_continue; } ],
	[ qr/assword:\s*$/ 	=> sub { $spawn->send("$password\n"); exp_continue; } ],
	[ qr/ogin:\s*$/		=> sub { $spawn->send("$username\n"); exp_continue; } ],
	[ qr/REMOTE HOST IDEN/ 	=> sub { print "FIX: .ssh/known_hosts\n"; exp_continue; } ],
	[ qr/$PROMPT/ 		=> sub { $spawn->send("echo Now try window resizing\n"); } ],
);

# Hand over control
$spawn->interact();
exit;
#!/usr/bin/perl
#
#      A Simple Terminal Resizing Example
#      GPL version 2. See the COPYING file
#
# This script is a simple example of how handle terminal
# window resize events (transmitted via the WINCH signal)
# -- Jeff Carr <jcarr@linuxmachines.com>
#

if( ! defined $ARGV[0] ) {
	print "Usage: ssh.pl <host> <username> <password>\n";
	exit;
}

my ($host, $username, $password) = @ARGV;

use Expect;
use IO::Pty;

my $spawn = new Expect;
$spawn->raw_pty(1);  

# This gets the size of your terminal window
$spawn->slave->clone_winsize_from(\*STDIN);

my $PROMPT;

# This function traps WINCH signals and passes them on
sub winch {
	my $signame = shift;
	my $pid = $spawn->pid;
	$shucks++;
	print "count $shucks,pid $pid, SIG$signame\n";
	$spawn->slave->clone_winsize_from(\*STDIN);
	kill WINCH => $spawn->pid if $spawn->pid;
}
$SIG{WINCH} = \&winch;  # best strategy

$spawn=Expect->spawn("ssh $username\@$host");
# log everything if you want
# $spawn->log_file("/tmp/autossh.log.$$");

my $PROMPT  = '[\]\$\>\#]\s$';
my $ret = $spawn->expect(5,
	[ qr/\(yes\/no\)\?\s*$/ => sub { $spawn->send("yes\n"); exp_continue; } ],
	[ qr/assword:\s*$/ 	=> sub { $spawn->send("$password\n"); exp_continue; } ],
	[ qr/ogin:\s*$/		=> sub { $spawn->send("$username\n"); exp_continue; } ],
	[ qr/REMOTE HOST IDEN/ 	=> sub { print "FIX: .ssh/known_hosts\n"; exp_continue; } ],
	[ qr/$PROMPT/ 		=> sub { $spawn->send("echo Now try window resizing\n"); } ],
);

# Hand over control
$spawn->interact();
exit;
#!/usr/bin/perl
#
#      A Simple Terminal Resizing Example
#      GPL version 2. See the COPYING file
#
# This script is a simple example of how handle terminal
# window resize events (transmitted via the WINCH signal)
# -- Jeff Carr <jcarr@linuxmachines.com>
#

if( ! defined $ARGV[0] ) {
	print "Usage: ssh.pl <host> <username> <password>\n";
	exit;
}

my ($host, $username, $password) = @ARGV;

use Expect;
use IO::Pty;

my $spawn = new Expect;
$spawn->raw_pty(1);  

# This gets the size of your terminal window
$spawn->slave->clone_winsize_from(\*STDIN);

my $PROMPT;

# This function traps WINCH signals and passes them on
sub winch {
	my $signame = shift;
	my $pid = $spawn->pid;
	$shucks++;
	print "count $shucks,pid $pid, SIG$signame\n";
	$spawn->slave->clone_winsize_from(\*STDIN);
	kill WINCH => $spawn->pid if $spawn->pid;
}
$SIG{WINCH} = \&winch;  # best strategy

$spawn=Expect->spawn("ssh $username\@$host");
# log everything if you want
# $spawn->log_file("/tmp/autossh.log.$$");

my $PROMPT  = '[\]\$\>\#]\s$';
my $ret = $spawn->expect(5,
	[ qr/\(yes\/no\)\?\s*$/ => sub { $spawn->send("yes\n"); exp_continue; } ],
	[ qr/assword:\s*$/ 	=> sub { $spawn->send("$password\n"); exp_continue; } ],
	[ qr/ogin:\s*$/		=> sub { $spawn->send("$username\n"); exp_continue; } ],
	[ qr/REMOTE HOST IDEN/ 	=> sub { print "FIX: .ssh/known_hosts\n"; exp_continue; } ],
	[ qr/$PROMPT/ 		=> sub { $spawn->send("echo Now try window resizing\n"); } ],
);

# Hand over control
$spawn->interact();
exit;
