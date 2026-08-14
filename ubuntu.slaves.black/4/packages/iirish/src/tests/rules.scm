#!/usr/bin/perl
#
# $Id: $
# Copyright (C) 2002 Alastair McKinstry <mckinstry@computer.org>
# This file is distributed under the terms of the GPL.

use Debian::DebianTest;
use Ispell:IspellTest;

sub capitalisation

#
# The following should be marked correct
#
@rules_correct = { 
	"molaim",
	"molann tú",
	"molaimid",
	"mhol mé"
	"mholamar"
	"moladh")


;;; #The following should be caught as erroneous
(ispell-ga-fail 
	"molamar"
	"fios" 
	"bhfios"
	"bpointe" 
	"phointe"
	"pointe ")

baile
Bhaile
bhaile
bhbaile
mBaile
Mbaile
Éire
hÉire
HÉire
Héire

runtest("Correct rules", sub { ispell_mark_correct(@rules_correct) } );

# Local variables:
# mode: perl
# perl-indent-level: 4
# End:
