#!/usr/bin/perl -T

#
# This hideous hack is just a quick way to update the en_US templates
# from the amavisd binary.  Call it with stdin pointing to amavisd,
# and it will generate the files in the current directory
#

use strict;


my $line;
my @knowntemplates = (
	[ 'DELIVERY STATUS NOTIFICATIONS',		'template-dsn.txt' ],
	[ 'VIRUS.*SENDER NOTIFICATIONS', 		'template-virus-sender.txt' ],
	[ 'non-spam.*ADMINISTRATOR NOTIFICATIONS', 	'template-virus-admin.txt' ],
	[ 'VIRUS.*RECIPIENTS NOTIFICATIONS', 		'template-virus-recipient.txt' ],
	[ 'spam SENDER NOTIFICATIONS', 			'template-spam-sender.txt' ],
	[ 'spam ADMINISTRATOR NOTIFICATIONS', 		'template-spam-admin.txt' ],
    [ 'RELEASE FROM A QUARANTINE',  'template-release-quarantine.txt' ],
    [ 'problem/feedback report', 'template-problem-feedback.txt' ],
    [ 'text part of an auto response', 'template-auto-response.txt' ],
);

local($/) = "__DATA__\n";
while ($line = <STDIN>) {
	chomp $line;
	if ( $line =~ /This is a template for/ ) {
		my $i = $#knowntemplates;
		while ( $i >= 0 ) {
			if ($line =~ $knowntemplates[$i][0]) {
				print "Generating $knowntemplates[$i][1] ...\n";
				open(DATAOUT, ">$knowntemplates[$i][1]");
				print DATAOUT $line;
				close(DATAOUT);
				last;
			} else {
                #print "Unknown template $line\n";
            }
			$i--;
		}
	}
}
