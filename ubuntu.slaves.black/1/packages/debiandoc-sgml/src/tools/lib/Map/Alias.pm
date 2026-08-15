## -*- perl -*-
## ----------------------------------------------------------------------
## DebianDoc_SGML/Map/Alias.pm: output format data map alias map
## ----------------------------------------------------------------------
## Copyright (C) 2000-2004 Ardo van Rangelrooij
##
## This is free software; see the GNU General Public Licence
## version 2 or later for copying conditions.  There is NO warranty.
## ----------------------------------------------------------------------

## ----------------------------------------------------------------------
## package interface definition
package DebianDoc_SGML::Map::Alias;
use strict;
use vars qw( @ISA @EXPORT );
use Exporter;
@ISA = qw( Exporter );
@EXPORT = qw( %map_aliases );

## ----------------------------------------------------------------------
## map alias definitions
use vars qw( %map_aliases );
%map_aliases = (
		'html'    => 'HTML',
		'latex'   => 'LaTeX',
		'texinfo' => 'Texinfo',
		'text'    => 'Text',
		'wiki'    => 'Wiki',
		'textov'  => 'TextOV',
		'dbk'	=> 'XML',
		);

## ----------------------------------------------------------------------
## don't forget this
1;

## ----------------------------------------------------------------------
