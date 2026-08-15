## -*- perl -*-
## ----------------------------------------------------------------------
## DebianDoc_SGML/Format/Texinfo: Texinfo output format generator
## ----------------------------------------------------------------------
## Copyright (C) 1998-2004 Ardo van Rangelrooij
##
## This is free software; see the GNU General Public Licence
## version 2 or later for copying conditions.  There is NO warranty.
## ----------------------------------------------------------------------

## ----------------------------------------------------------------------
## package interface definition
package DebianDoc_SGML::Format::Texinfo;
use strict;
use vars qw( @ISA @EXPORT );
use Exporter;
@ISA = ( 'Exporter' );
@EXPORT = qw ();

## ----------------------------------------------------------------------
## import packages
use SGMLS::Output;

## ----------------------------------------------------------------------
my %locale = %DebianDoc_SGML::Format::Driver::locale;
my %sdata = %DebianDoc_SGML::Format::Driver::sdata;

## ----------------------------------------------------------------------
## layout definitions
$DebianDoc_SGML::Format::Driver::indent_level = 1;

## ----------------------------------------------------------------------
## global variables
use vars qw( %nodes @main_menu %detailed_menu %sub_menus %current $node );

use vars qw( $title );
use vars qw( @author @translator );
use vars qw( $version );
use vars qw( $abstract );
use vars qw( $copyright );
use vars qw( @copyrightsummaries );

## ----------------------------------------------------------------------
## book output subroutines
## ----------------------------------------------------------------------
sub _output_start_book
{
    output( "\\input texinfo \@c -*- texinfo -*-\n" );
}
sub _output_end_book
{
    output( "\n" );
    output( "\@shortcontents\n" );
    output( "\n" );
    output( "\@contents\n" );
    output( "\n" );
    output( "\@bye\n");
    output( "\n" );
}

## ----------------------------------------------------------------------
## title page output subroutines
## ----------------------------------------------------------------------
sub _output_titlepag
{
    output( "\n" );
    output( "\@c %**start of header\n" );
    output( "\@c \@setfilename \n" );
    output( "\@settitle $title\n" );
    output( "\@c %**add dircategory and direntry here\n" );
    output( "\@setchapternewpage on\n" );
    output( "\@paragraphindent 0\n" );
    output( "\@c %**end of header\n" );
    output( "\n" );
    output( "\@ifinfo\n" );
    if ( length ( $abstract ) )
    {
	output( $abstract );
    }
    if ( length ( $copyright ) )
    {
	output( "\n" );
	output( $copyright );
    }
    output( "\n" );
    output( "\@end ifinfo\n" );
    output( "\n" );
    output( "\@titlepage\n" );
    output( "\n" );
    output( "\@title $title\n" );
    output( "\n" );
    output( "\@subtitle $version\n" );
    output( "\n" );
    foreach ( @author )
    {
	output( "\@author $_\n" );
    }
    output( "\n" );
    foreach ( @translator )
    {
	output( "\@author $_\n" );
    }
    output( "\n" );
    output( "\@page\n" );
    if ( length ( $copyright ) )
    {
	output( "\n" );
	output( "\@vskip 0pt plus 1filll\n" );
	output( $copyright );
    }
    output( "\n" );
    output( "\@end titlepage\n" );
}

## ----------------------------------------------------------------------
## title output subroutines
## ----------------------------------------------------------------------
sub _output_title
{
    $title = $_[0];
}

## ----------------------------------------------------------------------
## author output subroutines
## ----------------------------------------------------------------------
sub _output_author
{
    push( @author, $_[0] );
}

## ----------------------------------------------------------------------
## translator output subroutines
## ----------------------------------------------------------------------
sub _output_translator
{
    push( @translator, $_[0] );
}

## ----------------------------------------------------------------------
## name output subroutines
## ----------------------------------------------------------------------
sub _output_name
{
    output( $_[0] );
}

## ----------------------------------------------------------------------
## version output subroutines
## ----------------------------------------------------------------------
sub _output_version
{
    $version = $_[0];
}

## ----------------------------------------------------------------------
## abstract output subroutines
## ----------------------------------------------------------------------
sub _output_abstract
{
    $abstract = $_[0];
}

## ----------------------------------------------------------------------
## copyright output subroutines
## ----------------------------------------------------------------------
sub _output_copyright
{
    push_output( 'string' );
    output( join( " \@*\n", @copyrightsummaries ), "\n" );
    output( $_[0] );
    $copyright = pop_output;
}
sub _output_copyrightsummary
{
    push( @copyrightsummaries, $_[0] );
}

## ----------------------------------------------------------------------
## table of contents output subroutines
## ----------------------------------------------------------------------
my %section_name = (
		    '-2' => 'appendix',
		    '-1' => 'chapter',
		    '0' => 'section',
		    '1' => 'subsection',
		    '2' => 'subsubsection',
		    '3' => 'paragraph',
		    '4' => 'subparagraph',
		    );
sub _output_toc
{
    output( "\n" );
    output( "\@ifinfo\n" );
    output( "\n" );
    output( "\@node Top\n" );
    output( "\@top $title\n" );
    if ( length( $abstract ) )
    {
	output( $abstract );
    }
    output( "\n" );
    output( "\@end ifinfo\n" );
    output( "\n" );
    output( "\@menu\n" );
    output( "\n" );
    foreach ( @main_menu)
    {
	my ( $name, $number ) = split( / /, $_, 2 );
	output( "* " );
	output( $locale{ $name }( $number ) );
	output( "\:\:\t\t$nodes{$_}\n" );
    }
    if ( keys %detailed_menu > 0 )
    {
	output( "\n" );
	output( "\@detailmenu\n" );
	output( "\n" );
	output( " --- $locale{'detailed'} ---\n" );
	foreach my $main ( @main_menu)
	{
	    next if $#{$detailed_menu{ $main }} < 0;
	    output( "\n" );
	    output( "$nodes{ $main }\n" );
	    output( "\n" );
	    foreach ( @{$detailed_menu{ $main }} )
	    {
		my $space = "";
		$space .= "\t" if m/section/;
		$space = " " . $space if m/^section/;
		my ( $name, $number ) = split( / /, $_, 2 );
		output( "* " );
		output( $locale{ $name }( $number ) );
		output( "\:\:$space$nodes{$_}\n" );
	    }
	}
	output( "\n" );
	output( "\@end detailmenu\n" );
    }
    output( "\n" );
    output( "\@end menu\n" );
}
sub _output_tocentry
{
    if ( $_[1] == -1 )
    {
	$current{$_[1]} = ( $_[2] =~ m/^[A-Z]/ ? "appendix" : "chapter" )
	    . " $_[2]";
	push( @main_menu, $current{$_[1]} );
    }
    else
    {
	$current{$_[1]} = "$section_name{$_[1]} $_[2]";
	push( @{$detailed_menu{ $current{'-1'} }}, $current{$_[1]} );
	push( @{$sub_menus{ $current{$_[1]-1}}}, $current{$_[1]} ) if $_[1] < 3;
    }
    $nodes{ $current{$_[1]} } = $_[0];
}

## ----------------------------------------------------------------------
## section output subroutines
## ----------------------------------------------------------------------
my %section_markup = (
		      '-2' => "\@appendix",
		      '-1' => "\@chapter",
		      '0' => "\@section",
		      '1' => "\@subsection",
		      '2' => "\@subsubsection",
		      '3' => "\@unnumberedsubsubsec",
		      '4' => "\@subheading",
		      );
sub _output_chapter
{
    output( $_[0] );
}
sub _output_appendix
{
    output( $_[0] );
}
sub _output_sect
{
}
sub _output_sect1
{
}
sub _output_sect2
{
}
sub _output_sect3
{
}
sub _output_sect4
{
}
sub _output_heading
{
    if ( $#{$sub_menus{$node}} > -1 )
    {
	output( "\n" );
	output( "\@menu\n" );
	foreach ( @{$sub_menus{$node}} )
	{
	    my ( $name, $number ) = split( / /, $_, 2 );
	    output( "* " );
	    output( $locale{ $name }( $number ) );
	    output( "\:\: $nodes{$_}\n" );
	}
	output( "\@end menu\n" );
    }
    if ( $section_name{$_[1]} !~ m/graph/ )
    {
	$node = "$section_name{$_[1]} $_[2]";
	output( "\n" );
	output( "\@node " );
	output( $locale{ $section_name{ $_[1] } }( $_[2] ) );
	output( "\n" );
    }
    output( "$section_markup{$_[1]} $_[0]\n" );
}

## ----------------------------------------------------------------------
## paragraph output subroutines
## ----------------------------------------------------------------------
sub _output_p
{
    if ( length( $_[0] ) )
    {
	output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
	$_[0] =~ s/^\s+//gm;
	$_[0] =~ s/\n\n+/\n/g;
	output( "$_[0]\n" );
    }
    else
    {
	output( "\n" )
	    if ( $DebianDoc_SGML::Format::Driver::is_special
		 && ! $DebianDoc_SGML::Format::Driver::is_compact
		 && $DebianDoc_SGML::Format::Driver::will_be_compact );
    }
}

## ----------------------------------------------------------------------
## example output subroutines
## ----------------------------------------------------------------------
sub _output_example
{
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    output( "\@example\n" );
    output( $_[0] );
    output( "\@end example\n" );
}

## ----------------------------------------------------------------------
## footnote output subroutines
## ----------------------------------------------------------------------
sub _output_footnote
{
    output( "\@footnote{$_[0]}" );
}

## ----------------------------------------------------------------------
## comment output subroutines
## ----------------------------------------------------------------------
sub _output_comment
{
}

## ----------------------------------------------------------------------
## list output subroutines
## ----------------------------------------------------------------------
sub _output_list
{
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    output( "\@itemize \@bullet\n" );
    output( $_[0] );
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    output( "\@end itemize\n" );
}
sub _output_enumlist
{
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    output( "\@enumerate $DebianDoc_SGML::Format::Driver::item_counter\n" );
    output( $_[0] );
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    output( "\@end enumerate\n" );
}
sub _output_taglist
{
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    output( "\@table \@asis\n" );
    output( $_[0] );
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    output( "\@end table\n" );
}
sub _output_list_tag
{
}
sub _output_enumlist_tag
{
}
sub _output_taglist_tag
{
}
sub _output_list_item
{
    $_[0] =~ s/^\n//;
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    output( "\@item\n" );
    output( $_[0] );
}
sub _output_enumlist_item
{
    $_[0] =~ s/^\n//;
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    output( "\@item\n" );
    output( $_[0] );
}
sub _output_taglist_item
{
    $_[0] =~ s/^\n//;
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    output( "\@item " . shift( @{$_[1]} ) . "\n" );
    foreach ( @{$_[1]} )
    {
        output( "\@itemx $_\n" );
    }
    output( $_[0] );
}

## ----------------------------------------------------------------------
## emph output subroutines
## ----------------------------------------------------------------------
sub _output_em
{
    output( "\@emph{$_[0]}" );
}
sub _output_strong
{
    output( "\@strong{$_[0]}" );
}
sub _output_var
{
    output( "\@var{$_[0]}" );
}
sub _output_package
{
    output( "\@code{$_[0]}" );
}
sub _output_prgn
{
    output( "\@code{$_[0]}" );
}
sub _output_file
{
    output( "\@file{$_[0]}" );
}
sub _output_tt
{
    output( "\@samp{$_[0]}" );
}
sub _output_qref
{
    output( $_[0] );
}

## ----------------------------------------------------------------------
## xref output subroutines
## ----------------------------------------------------------------------
sub _output_ref
{
    my ( $name, $number ) = split( / /, $_[1], 2 );
    output( "\@ref{" );
    output( $locale{$name}( $number ) );
    output( ", `$_[0]'" );
    output( "}" );
}
sub _output_manref
{
    output( "\@code{$_[0]($_[1])}" );
}
sub _output_email
{
    output( " " )
	if (    $DebianDoc_SGML::Format::Driver::in_author
	     || $DebianDoc_SGML::Format::Driver::in_translator );
    output( "\@email{$_[0]}" );
}
sub _output_ftpsite
{
    output( "\@url{$_[0]}" );
}
sub _output_ftppath
{
    output( "\@file{$_[1]}" );
}
sub _output_httpsite
{
    output( "\@url{$_[0]}" );
}
sub _output_httppath
{
    output( "\@file{$_[1]}" );
}
sub _output_url
{
    _cdata( $_[1] ) if $_[1] ne "";
    output( " (" ) if $_[1] ne "";
    output( "\@url{" );
    _cdata( $_[0] );
    output( "}" );
    output( ")" ) if $_[1] ne "";
}

## ----------------------------------------------------------------------
## data output subroutines
## ----------------------------------------------------------------------
sub _cdata
{
    ( $_ ) = @_;

    # escape command characters
    s/\@/\@\@/g;
    s/{/\@{/g;
    s/}/\@}/g;

    # in examples no further replacement
    if ( ! ( $DebianDoc_SGML::Format::Driver::is_example
	     || $DebianDoc_SGML::Format::Driver::is_argument ) )
    {

	# hyphens
	s/--/---/g;

	# special symbols
	s/\.\.\./\@dots{} /g;

    }

    # SDATA
    s/\\\|(\[\w+\s*\])\\\|/$sdata{ $1 }/g;

    output( $_ );
}
sub _sdata
{
    output( $sdata{ $_[0] } );
}

## ----------------------------------------------------------------------
## don't forget this
1;

## ----------------------------------------------------------------------
