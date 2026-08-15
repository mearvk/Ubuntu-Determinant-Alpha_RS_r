## -*- perl -*-
## ----------------------------------------------------------------------
## DebianDoc_SGML/Format/Format: output format generator base class
## ----------------------------------------------------------------------
## Copyright (C) 1998-2004 Ardo van Rangelrooij
##
## This is free software; see the GNU General Public Licence
## version 2 or later for copying conditions.  There is NO warranty.
## ----------------------------------------------------------------------

## ----------------------------------------------------------------------
## package interface definition
package DebianDoc_SGML::Format::Format;
use strict;
use vars qw( @ISA @EXPORT );
use Exporter;
@ISA = ( 'Exporter' );
@EXPORT = qw ();

## ----------------------------------------------------------------------
## book output subroutines
## ----------------------------------------------------------------------
sub output_start_book
{
}
sub output_end_book
{
}

## ----------------------------------------------------------------------
## title page output subroutines
## ----------------------------------------------------------------------
sub output_titlepag
{
}

## ----------------------------------------------------------------------
## title output subroutines
## ----------------------------------------------------------------------
sub _output_title
{
}

## ----------------------------------------------------------------------
## author output subroutines
## ----------------------------------------------------------------------
sub _output_author
{
}

## ----------------------------------------------------------------------
## translator output subroutines
## ----------------------------------------------------------------------
sub _output_translator
{
}

## ----------------------------------------------------------------------
## name output subroutines
## ----------------------------------------------------------------------
sub _output_name
{
}

## ----------------------------------------------------------------------
## version output subroutines
## ----------------------------------------------------------------------
sub _output_version
{
}

## ----------------------------------------------------------------------
## abstract output subroutines
## ----------------------------------------------------------------------
sub _output_abstract
{
}

## ----------------------------------------------------------------------
## copyright output subroutines
## ----------------------------------------------------------------------
sub _output_copyright
{
}
sub _output_copyrightsummary
{
}

## ----------------------------------------------------------------------
## table of contents output subroutines
## ----------------------------------------------------------------------
sub output_toc
{
}
sub output_tocentry
{
}

## ----------------------------------------------------------------------
## section output subroutines
## ----------------------------------------------------------------------
sub output_chapter
{
}
sub output_appendix
{
}
sub output_heading
{
}

## ----------------------------------------------------------------------
## paragraph output subroutines
## ----------------------------------------------------------------------
sub output_p
{
}

## ----------------------------------------------------------------------
## example and include output subroutines
## ----------------------------------------------------------------------
sub output_example
{
}
sub output_include
{
}

## ----------------------------------------------------------------------
## footnote output subroutines
## ----------------------------------------------------------------------
sub output_footnote
{
}

## ----------------------------------------------------------------------
## comment output subroutines
## ----------------------------------------------------------------------
sub output_comment
{
}

## ----------------------------------------------------------------------
## list output subroutines
## ----------------------------------------------------------------------
sub output_list
{
}
sub output_enumlist
{
}
sub output_taglist
{
}
sub output_list_tag
{
}
sub output_enumlist_tag
{
}
sub output_taglist_tag
{
}
sub output_list_item
{
}
sub output_enumlist_item
{
}
sub output_taglist_item
{
}

## ----------------------------------------------------------------------
## emph output subroutines
## ----------------------------------------------------------------------
sub output_em
{
}
sub output_strong
{
}
sub output_var
{
}
sub output_package
{
}
sub output_prgn
{
}
sub output_file
{
}
sub output_tt
{
}
sub output_qref
{
}

## ----------------------------------------------------------------------
## xref output subroutines
## ----------------------------------------------------------------------
sub output_ref
{
}
sub output_manref
{
}
sub output_email
{
}
sub output_ftpsite
{
}
sub output_ftppath
{
}
sub output_httpsite
{
}
sub output_httppath
{
}
sub output_url
{
}

## ----------------------------------------------------------------------
## data output subroutines
## ----------------------------------------------------------------------
sub output_cdata
{
}
sub output_sdata
{
}

## ----------------------------------------------------------------------
## don't forget this
1;

## ----------------------------------------------------------------------
