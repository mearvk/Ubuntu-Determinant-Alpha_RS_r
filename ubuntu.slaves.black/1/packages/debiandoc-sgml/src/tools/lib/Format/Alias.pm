## -*- perl -*-
## ----------------------------------------------------------------------
## DebianDoc_SGML/Format/Alias.pm: output format generator alias map
## ----------------------------------------------------------------------
## Copyright (C) 1998-2004 Ardo van Rangelrooij
##
## This is free software; see the GNU General Public Licence
## version 2 or later for copying conditions.  There is NO warranty.
## ----------------------------------------------------------------------

## ----------------------------------------------------------------------
## package interface definition
package DebianDoc_SGML::Format::Alias;
use strict;
use vars qw( @ISA @EXPORT );
use Exporter;
@ISA = qw( Exporter );
@EXPORT = qw( %format_aliases );

## ----------------------------------------------------------------------
## format alias definitions
use vars qw( %format_aliases );
%format_aliases = (
		   'html'	=> 'HTML',
		   'latex'	=> 'LaTeX',
		   'texinfo'	=> 'Texinfo',
		   'text'	=> 'Text',
		   'wiki'	=> 'Wiki',
		   'textov'	=> 'TextOV',
		   'dbk'	=> 'XML',
		   );

## ----------------------------------------------------------------------
## don't forget this
1;

## ----------------------------------------------------------------------
