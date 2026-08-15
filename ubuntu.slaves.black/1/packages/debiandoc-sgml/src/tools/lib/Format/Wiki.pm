## -*- perl -*-
## ----------------------------------------------------------------------
## DebianDoc_SGML/Format/Wiki: plain text format output generator
## ----------------------------------------------------------------------
## Copyright (C) 1998-2004 Ardo van Rangelrooij
## Copyright (C) 1996 Ian Jackson
##
## This is free software; see the GNU General Public Licence
## version 2 or later for copying conditions.  There is NO warranty.
## ----------------------------------------------------------------------

## ----------------------------------------------------------------------
## package interface definition
package DebianDoc_SGML::Format::Wiki;
use strict;
use vars qw( @ISA @EXPORT );
use Exporter;
@ISA = ( 'Exporter' );
@EXPORT = qw ();

## ----------------------------------------------------------------------
## import packages
use Roman;
use SGMLS::Output;
use Text::Format;

## ----------------------------------------------------------------------
my %locale = %DebianDoc_SGML::Format::Driver::locale;
my %sdata = %DebianDoc_SGML::Format::Driver::sdata;

## ----------------------------------------------------------------------
## layout definitions
my $perindent = 0;
my $linewidth = 79;
my $textwidth = 75;
my $unbreakbackoff = 20;
$DebianDoc_SGML::Format::Driver::indent_level = 1;
my $text = new Text::Format;
$text->columns( $linewidth );
$text->leftMargin( $perindent - 1 );
$text->rightMargin( $perindent - 1 );
$text->extraSpace( 1 );
$text->firstIndent( 0 );

## ----------------------------------------------------------------------
## global variables
use vars qw( $blanklinedone $paralhindents $paralhtag @stylestack @b @u );
use vars qw( @footnotes @comments @comment_editors );

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
}
sub _output_end_book
{
    _output_footnotes() if ( @footnotes );
    _output_comments() if ( @comments );
    output( "\n" );
    output( "\n" );
    output( ( "-" x $linewidth ) . "\n" );
    output( "\n" );
    output( "\n" );
    _para_new();
    output( $title );
    _para_end( 1 );
    output( "\n" );
    foreach ( @author )
    {
	_para_new();
	output( $_ );
	_para_end( 1 );
    }
    output( "\n" );
    foreach ( @translator )
    {
	_para_new();
	output( $_ );
	_para_end( 1 );
    }
    output( "\n" );
    _para_new();
    output( $version ) if length( $version );
    _para_end( 1 );
    output( "\n" );
}

## ----------------------------------------------------------------------
## title page output subroutines
## ----------------------------------------------------------------------
sub _output_titlepag
{
    output( "\n" );
    _para_new();
    output( "== ".$title." ==" );
    _para_end( 0, 'centre-underdash' );
    foreach ( @author )
    {
	output( "\n" );
	_para_new();
	output( $_ );
	_para_end( 0, 'centre' );
    }
    foreach ( @translator )
    {
	output( "\n" );
	_para_new();
	output( $_ );
	_para_end( 0, 'centre' );
    }
    if ( length( $version ) )
    {
	output( "\n" );
	_para_new();
	output( $version );
	_para_end( 0, 'centre' );
    }
    output( "\n" );
    output( "\n" );
##    output( ( "-" x $linewidth ) . "\n" );
    if ( length( $abstract ) )
    {
	_output_heading( $locale{ 'abstract' } );
	output( $abstract );
    }
    if ( length ( $copyright ) )
    {
	_output_heading( $locale{ 'copyright notice' } );
	output( $copyright );
    }
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
    output( "\n" );
    foreach ( @copyrightsummaries )
    {
	_para_new();
	output( $_ );
	_para_end( $DebianDoc_SGML::Format::Driver::indent_level );
    }
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
sub _output_toc
{
    _output_heading( $locale{ 'contents' }, -1 );
    output( $_[0] );
}
sub _output_tocentry
{
    return if $_[1] > $DebianDoc_SGML::Format::Driver::toc_detail;
    output( "\n" ) if $_[1] == -1;
    _para_lhtag( "$_[2]." );
    _para_lhtag( '' );
    _para_lhtag( '' ) if $_[1] > 0;
    _para_new();
    output( $_[0] );
    _para_end( $_[1] > 0 ? 4 : 3 );
}

## ----------------------------------------------------------------------
## section output subroutines
## ----------------------------------------------------------------------
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
    _output_footnotes() if ( @footnotes );
    _output_comments() if ( @comments );
    output( "\n" );
    if ( $_[1] < 0 )
    {
	output( "\n" );
	output( ( "-" x $linewidth ) . "\n" );
	output( "\n" );
    }
    output( "\n" ) if $_[1] <= 0;
    _para_new();
#    output( "$_[2]. " ) if length( $_[2] );
    output( "== $_[0] ==" );
    _para_end( 0, 'underdash' );
}

## ----------------------------------------------------------------------
## paragraph output subroutines
## ----------------------------------------------------------------------
sub _output_p
{
    if ( length( $_[0] ) )
    {
	_insert_blankline();
	$blanklinedone = 0;
	my $indent = 0;
	if ( ( length( $paralhtag ) )
	     && ( ! $DebianDoc_SGML::Format::Driver::is_footnote ) )
	{
##	    output( ' '
##		    x ( $perindent
##			* ( $DebianDoc_SGML::Format::Driver::indent_level
##			    - $paralhindents ) ) );
	    output( _emph_string( $paralhtag ) );
	    $indent = ( $DebianDoc_SGML::Format::Driver::indent_level )
		* $perindent;
	    $paralhtag = '';
	    $paralhindents = 0;
	}
	my $para_indent = $DebianDoc_SGML::Format::Driver::indent_level;
	$para_indent = 2 if ( $DebianDoc_SGML::Format::Driver::in_footnote
			      && $DebianDoc_SGML::Format::Driver::list_type );
	$para_indent = 1 if $DebianDoc_SGML::Format::Driver::is_footnote;
	$text->leftMargin( $para_indent * $perindent );
	my $para = $text->format( $_[0] );
	output( substr( $para, $indent ) );
    }
    else
    {
	output( "\n" )
	    if ( $DebianDoc_SGML::Format::Driver::is_special
		 && ! $DebianDoc_SGML::Format::Driver::is_compact
		 && $DebianDoc_SGML::Format::Driver::will_be_compact );
    }
}
sub _insert_blankline
{
    if ( ! $DebianDoc_SGML::Format::Driver::is_compact
	 && ! $DebianDoc_SGML::Format::Driver::was_compact
	 && ! $blanklinedone )
    {
	output( "\n" );
	$blanklinedone = 1;
    }
}
sub _para_lhtag
{
    $paralhindents++;
    $paralhtag .= $_[0];
##    $paralhtag .= ' ' x ( $paralhindents * $perindent - length( $paralhtag ) );
}
sub _para_new
{
    @stylestack = ();
    push_output( 'string' );
}
sub _para_end
{
    my ( $inum, $fmt, $lhtagdefer ) = @_;
    # fmt is one of undef,'centre','centre-underdash','underdash'
    # lhtagdefer is 1 if we can safely defer a paralhtag til later
    my $pd = pop_output();
    @b = @u = ( 0 );
    my ( $here, $maxwidth, $evstr, $pis, $pil, $npis, $av, $ls_pis, $ls_pil );
    my ( $nobreak, $code, $reducedwidth, $indentdone, $lhs );
    my $centre = ( $fmt eq 'centre' || $fmt eq 'centre-underdash' );
    my $udash = ( $fmt eq 'underdash' || $fmt eq 'centre-underdash' );
    $maxwidth = 0;
    return if $pd !~ m/\S/ && ( $lhtagdefer || ! length( $paralhtag ) );
    if ( length( $paralhtag ) )
    {
##        output( " " x ( $perindent * ( $inum - $paralhindents ) ) );
        output( _emph_string( $paralhtag ) );
        $reducedwidth = length( $paralhtag ) - ( $perindent * $paralhindents );
        $reducedwidth = 0 if $reducedwidth < 0;
        $paralhtag = '';
	$indentdone = 1;
	$paralhindents = 0;
    }
  outer:
    while ( length( $pd ) )
    {
        next if ! $nobreak && $pd =~ s/^\s+//;
        $pil = 0;
	$av = $textwidth - $perindent * $inum - $reducedwidth;
        $pis = 0;
	$reducedwidth = 0;
	$ls_pis = -1;
        while ( $pis < length( $pd ) && ( $nobreak || $pil <= $av ) )
	{
            $here = substr( $pd, $pis, 1 );
            if ( $here eq "\0" )
	    {
                $code = substr( $pd, $pis + 1, 2 );
                if ( $code eq '=o' )
		{
                    last if $pis;
                    $nobreak = 1;
		    $lhs = 0;
                }
		elsif ( $code eq '=l' )
		{
                    last if $pis || $indentdone;
                    $nobreak = 1;
		    $lhs = 1;
                }
		elsif ( $code eq '=c' )
		{
                    last if $pis;
                    $nobreak = 0;
		    $lhs = 0;
                }
		elsif ( $code eq '=n' )
		{
                    $pis += 4;
		    last;
                }
		else
		{
                    $pis += 4;
		    next;
                }
                $pd = substr( $pd, 4 );
		next outer;
            }
            if ( ! $nobreak && $here =~ m/^\s$/ )
	    {
                $here = substr( $pd, $pis );
		$here =~ s/^\s+/ /;
                $pd = substr( $pd, 0, $pis ) . $here;
                $ls_pis = $pis;
		$ls_pil = $pil;
            }
            if ( $ls_pis < 0 && $pil >= $av - $unbreakbackoff )
	    {
                $ls_pis = $pis;
		$ls_pil = $pil;
            }
            $pis++;
	    $pil++;
        }
        if ( ! $nobreak && $pil > $av )
	{
	    $pis = $ls_pis;
	    $ls_pil = $pil;
	}
        $maxwidth = $pil if $pil > $maxwidth;
#        output( ' ' x ( ( $centre ? ( $textwidth - $pil ) / 2 : 0 )
#			+ ( $lhs ? 0 : ( $inum + $nobreak ) * $perindent ) ) )
#            if ! $indentdone;
        output( _emph_string( substr( $pd, 0, $pis ) ) );
        output( "\n" );
	$indentdone = 0;
        $pd = substr( $pd, $pis );
    }
    if ( $udash )
    {
##        output( ' ' x ( ( $centre ? ( $textwidth - $maxwidth ) / 2 : 0 )
##			+ ( $inum * $perindent ) ) );
##        output( ( $b[0] ? "--" : "-" ) x $maxwidth . "\n" );
    }
    $blanklinedone = 0;
}
sub _emph_string
{
    my ( $string ) = @_;
    my ( $i, $here, $ar, $sv, $es );
    for ( $i = 0; $i < length( $string ); $i++ )
    {
        $here = substr( $string, $i, 1 );
        if ( $here eq "\0" )
	{
            $ar = substr( $string, $i + 1, 1 );
	    $sv = substr( $string, $i + 2, 1 );
            if ( $sv eq '-' )
	    {
                $es = "shift(\@$ar);1;";
		eval $es || die "$@ / $es";
            }
	    elsif ( $sv ne '=' )
	    {
                $es = "unshift(\@$ar,\$sv);1;";
		eval $es || die "$@ / $es";
            }
            $i += 3;
	    next;
        }
        if ( $b[0] )
	{
	    output( "$here" );
	}
        elsif ( $u[0] )
	{
	    output( "_" );
	}
        output( $here );
    }
    return;
}

## ----------------------------------------------------------------------
## example output subroutines
## ----------------------------------------------------------------------
sub _output_example
{
    $_[0] =~ s/[ \t]+\n/\n/g;
    $_[0] =~ s/^\n+//;
    $_[0] = "{{{\n".$_[0]."}}}\n";
    my @el = split( /\n/, $_[0] );
    my @ec = @el;
    grep( s/\0..\0//g, @ec );
    my @toolong = grep( length( $_ )
			+ ( $perindent
			    * ( $DebianDoc_SGML::Format::Driver::indent_level
				+ 1 ) )
			> $linewidth, @ec );
    _insert_blankline();
    push_output( 'string' );
    output( @toolong ? "\0=l\0" : "\0=o\0" );
    output( join( "\0=n\0", @el ) );
    output( "\0=c\0" );
    _para_new();
    output( pop_output() );
    _para_end( $DebianDoc_SGML::Format::Driver::indent_level );
}

## ----------------------------------------------------------------------
## footnote output subroutines
## ----------------------------------------------------------------------
sub _output_footnotes
{
    my $footnoteref = 1;
    foreach my $footnote ( @footnotes )
    {
	_insert_blankline();
	output( "[$footnoteref]" );
#	output( ' ' x ( $perindent - length( "[$footnoteref]" ) ) );
	output( $footnote );
	$blanklinedone = 0;
	$footnoteref++;
    }
    @footnotes = ();
}
sub _output_footnote
{
    push( @footnotes, $_[0] );
    output( "[" . scalar( @footnotes ) . "]" );
}

## ----------------------------------------------------------------------
## comment output subroutines
## ----------------------------------------------------------------------
sub _output_comments
{
    my $commentref = 1;
    foreach my $comment ( @comments )
    {
	_insert_blankline();
	_para_lhtag( "[c$commentref]" );
	my $editor = $comment_editors[$commentref - 1];
	_para_lhtag( "($editor) " ) if length( $editor);
	_para_new();
	output( $comment );
	_para_end( 1 );
	$blanklinedone = 0;
	$commentref++;
    }
    @comments = ();
    @comment_editors = ();
}
sub _output_comment
{
    push( @comments, $_[0] );
    push( @comment_editors, $_[1] );
    output( "[c" . scalar( @comments ) . "]" );
}

## ----------------------------------------------------------------------
## list output subroutines
## ----------------------------------------------------------------------
sub _output_list
{
    output( $_[0] );
}
sub _output_enumlist
{
    output( $_[0] );
}
sub _output_taglist
{
    output( $_[0] );
}
sub _output_list_tag
{
    _para_lhtag( ' * ' );
#    _para_lhtag( ( ' ' x ( $perindent - 2 ) ) . '*' );
}
sub _output_enumlist_tag
{
    my $item_counter = $DebianDoc_SGML::Format::Driver::item_counter;
    if ( $_[1] eq 'UPPERROMAN' )
    {
	$item_counter = Roman( $item_counter );
    }
    elsif ( $_[1] eq 'LOWERROMAN' )
    {
	$item_counter = roman( $item_counter );
    }
    _para_lhtag( $item_counter . '.' );
}
sub _output_taglist_tag
{
}
sub _output_list_item
{
    output( $_[0] );
}
sub _output_enumlist_item
{
    output( $_[0] );
}
sub _output_taglist_item
{
    $_[0] =~ s/^\n+//;
    _insert_blankline();
    foreach ( @{$_[1]} )
    {
	_para_new();
	output( $_ );
	_para_end( $DebianDoc_SGML::Format::Driver::indent_level - 1 );
    }
    output( $_[0] );
}

## ----------------------------------------------------------------------
## emph output subroutines
## ----------------------------------------------------------------------
sub _output_em
{
    output( "''$_[0]''" );
}
sub _output_strong
{
    output( "'''$_[0]'''" );
}
sub _output_var
{
    output( "''$_[0]''" );
}
sub _output_package
{
    output( "{{{$_[0]}}}" );
}
sub _output_prgn
{
    output( "{{{$_[0]}}}" );
}
sub _output_file
{
    output( "{{{$_[0]}}}" );
}
sub _output_tt
{
    output( "{{{$_[0]}}}" );
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
    output( $locale{ $name }( $number ) );
    output( ", {{{$_[0]}}}" );
}
sub _output_manref
{
    output( "{{{$_[0]}}}($_[1])" );
}
sub _output_email
{
#    output( ' ' )
#	if (    $DebianDoc_SGML::Format::Driver::in_author
#	     || $DebianDoc_SGML::Format::Driver::in_translator );
    output( "<$_[0]>" );
}
sub _output_ftpsite
{
    output( $_[0] );
}
sub _output_ftppath
{
    output( $_[1] );
}
sub _output_httpsite
{
    output( $_[0] );
}
sub _output_httppath
{
    output( $_[1] );
}
sub _output_url
{
    _cdata( $_[1] ) if $_[1] ne '';
    output( ' (' ) if $_[1] ne '';
    _cdata( $_[0] );
    output( ')' ) if $_[1] ne '';
}

## ----------------------------------------------------------------------
## data output subroutines
## ----------------------------------------------------------------------
sub _cdata
{
    ( $_ ) = @_;

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
