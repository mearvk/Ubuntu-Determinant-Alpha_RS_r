## -*- perl -*-
## ----------------------------------------------------------------------
## DebianDoc_SGML/Format/HTML: HTML output format generator
## ----------------------------------------------------------------------
## Copyright (C) 1998-2004 Ardo van Rangelrooij
## Copyright (C) 1996 Ian Jackson
##
## This is free software; see the GNU General Public Licence
## version 2 or later for copying conditions.  There is NO warranty.
## ----------------------------------------------------------------------

## ----------------------------------------------------------------------
## package interface definition
package DebianDoc_SGML::Format::HTML;
use strict;
use vars qw( @ISA @EXPORT );
use Exporter;
@ISA = ( 'Exporter' );
@EXPORT = qw ();

## ----------------------------------------------------------------------
## import packages
use File::Basename;
use File::Spec;
use I18N::LangTags qw( locale2language_tag );
use SGMLS::Output;
use Text::Format;
use URI;

## ----------------------------------------------------------------------
my %locale = %DebianDoc_SGML::Format::Driver::locale;
my %cdata = %DebianDoc_SGML::Format::Driver::cdata;
my %sdata = %DebianDoc_SGML::Format::Driver::sdata;

## ----------------------------------------------------------------------
## file name definitions
my $content = '';
if ( $DebianDoc_SGML::Format::Driver::opt_c )
{
    my $locale = $DebianDoc_SGML::Format::Driver::locale;
    $locale =~ s/[\.@].*//;
    my $language_tag = lc( locale2language_tag( $DebianDoc_SGML::Format::Driver::opt_l ) );
    $language_tag = 'en' if $language_tag eq undef;
    my $charset = ".$locale{ 'charset' }"
	if length( $locale{ 'charset' } )
	    && $DebianDoc_SGML::Format::Driver::locale =~ m/\./;
    $content = ".$language_tag$charset";
}
if ( $DebianDoc_SGML::Format::Driver::opt_C )
{
    my $language_tag = lc( locale2language_tag( $DebianDoc_SGML::Format::Driver::opt_l ) );
    $language_tag = 'en' if $language_tag eq undef;
    $content = ".$language_tag";
}
my $basename = $DebianDoc_SGML::Format::Driver::opt_b;
my $prefix = '';
if ( $DebianDoc_SGML::Format::Driver::opt_b =~ m,/, )
{
    $basename = dirname( $DebianDoc_SGML::Format::Driver::opt_b );
    $prefix = basename( $DebianDoc_SGML::Format::Driver::opt_b ) . '-';
}
my $topname = length( $DebianDoc_SGML::Format::Driver::opt_t )
    ? $DebianDoc_SGML::Format::Driver::opt_t : 'index';
my $extension = length( $DebianDoc_SGML::Format::Driver::opt_e )
    ? ".$DebianDoc_SGML::Format::Driver::opt_e" : '.html';
my $single = $DebianDoc_SGML::Format::Driver::opt_1;

## ----------------------------------------------------------------------
## directory definition and creation
my $directory = "$basename$extension";
-d "$directory" || mkdir( "$directory", 0777 )
    || die "cannot make directory \`$directory': $!\n";

## ----------------------------------------------------------------------
## layout definition
$DebianDoc_SGML::Format::Driver::indent_level = 1;
my $text = new Text::Format;
$text->columns( 79 );
$text->firstIndent( 0 );
$text->extraSpace( 1 );

## ----------------------------------------------------------------------
## global variables
use vars qw( %next %previous );

use vars qw( $titlepag $toc );
use vars qw( $title );
use vars qw( @author @translator );
use vars qw( $version );
use vars qw( $abstract );
use vars qw( $copyright );
use vars qw( @copyrightsummary );

use vars qw( @toc_entry_id %toc_entry_chapter_id );
use vars qw( %toc_entry_name %toc_entry_level %toc_entry_fragment );

use vars qw( $chapter_id @chapter_id );
use vars qw( $chapter_type %chapter_type );
use vars qw( $chapter_num %chapter_num );
use vars qw( $chapter_title %chapter_title );
use vars qw( %chapter );

use vars qw( $section_id @section_id );
use vars qw( $section_num %section_num );
use vars qw( $section_title %section_title );
use vars qw( $section_chapter_id %section_chapter_id );

use vars qw( $subsection_id @subsection_id );
use vars qw( $subsection_num %subsection_num );
use vars qw( $subsection_title %subsection_title );
use vars qw( $subsection_chapter_id %subsection_chapter_id );

use vars qw( $footnote @footnote @footnote_chapter_id );
use vars qw( $comment @comment @comment_editor @comment_chapter_id );

use vars qw( $need_hr );

## ----------------------------------------------------------------------
## book output subroutines
## ----------------------------------------------------------------------
sub _output_start_book
{
}
sub _output_end_book
{
    _output_footnotes() if ( @footnote );
    _output_comments() if ( @comment );
    my $next = $chapter_id[ $#chapter_id ];
    my $previous = $chapter_id[ $#chapter_id ];
    foreach $chapter_id ( "$topname", @chapter_id )
    {
	$previous{ $chapter_id } = $previous;
	$previous = $chapter_id;
	$next{ $next } = $chapter_id;
	$next = $chapter_id;
    }
    if ( $DebianDoc_SGML::Format::Driver::opt_1 )
    {
	$chapter_id = $topname;
	my $file = "$prefix$chapter_id$content$extension";
	push_output( 'file', File::Spec->catfile( "$directory", "$file" ) );
	_html_head();
    }
    {
	$chapter_id = $topname;
	if ( ! $DebianDoc_SGML::Format::Driver::opt_1 )
	{
	    my $file = "$prefix$chapter_id$content$extension";
	    push_output( 'file',
			 File::Spec->catfile( "$directory", "$file" ) );
	    _html_head();
	}
	_navigation( $chapter_id );
	output( $titlepag ) if length( $titlepag );
	output( $toc ) if length( $toc );
	if ( ! $DebianDoc_SGML::Format::Driver::opt_1 )
	{
	    _navigation();
	    _html_tail();
	    pop_output();
	}
    }
    foreach $chapter_id ( @chapter_id )
    {
	if ( ! $DebianDoc_SGML::Format::Driver::opt_1 )
	{
	    my $file = "$prefix$chapter_id$content$extension";
	    push_output( 'file',
			 File::Spec->catfile( "$directory", "$file" ) );
	    _html_head( $chapter_title{ $chapter_id } );
	}
	_navigation( $chapter_id );
	output( $chapter{ $chapter_id } );
	if ( ! $DebianDoc_SGML::Format::Driver::opt_1 )
	{
	    _navigation();
	    _html_tail();
	    pop_output();
	}
    }
    if ( length( $footnote ) )
    {
	$chapter_id = 'footnotes';
	if ( ! $DebianDoc_SGML::Format::Driver::opt_1 )
	{
	    my $file = "$prefix$chapter_id$content$extension";
	    push_output( 'file',
			 File::Spec->catfile( "$directory", "$file" ) );
	    _html_head( $locale{ $chapter_id } );
	}
	output( $footnote );
	if ( ! $DebianDoc_SGML::Format::Driver::opt_1 )
	{
	    _html_tail();
	    pop_output();
	}
    }
    if ( length( $comment ) )
    {
	$chapter_id = 'comments';
	if ( ! $DebianDoc_SGML::Format::Driver::opt_1 )
	{
	    my $file = "$prefix$chapter_id$content$extension";
	    push_output( 'file',
			 File::Spec->catfile( "$directory", "$file" ) );
	    _html_head( $locale{ $chapter_id } );
	}
	output( $comment );
	if ( ! $DebianDoc_SGML::Format::Driver::opt_1 )
	{
	    _html_tail();
	    pop_output();
	}
    }
    if ( $DebianDoc_SGML::Format::Driver::opt_1 )
    {
	$chapter_id = $topname;
	_navigation();
	_html_tail();
	pop_output();
    }
}
sub _html_head
{
    my ( $pagetitle ) = @_;
    if ( length( $pagetitle ) )
    { 
	$pagetitle = "$title - $pagetitle";
    }
    else
    {
	$pagetitle = $title;
    }
    $pagetitle =~ s/\<[^<>]*\>//g; ### WRONG !!!
    output( "<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0//EN\">\n" );
    output( "\n" );
    output( "<html>\n" );
    output( "\n" );
    output( "<head>\n" );
    output( "\n" );
    output( "<meta http-equiv=\"content-type\" content=\"text/html; "
	    . "charset=$locale{ 'charset' }\">\n" )
	if length( $locale{ 'charset' } );
    output( "\n" );
    output( "<title>$pagetitle</title>\n" );
    if ( ! $DebianDoc_SGML::Format::Driver::opt_L )
    {
	output( "\n" );
	{
	    my $path = $DebianDoc_SGML::Format::Driver::opt_1
		? "#$topname" : "$prefix$topname$content$extension";
	    output( "<link href=\"$path\" rel=\"start\">\n" );
	    if ( ! $DebianDoc_SGML::Format::Driver::opt_1 )
	    {
		$path = "$prefix$previous{ $chapter_id }$content$extension";
		output( "<link href=\"$path\" rel=\"prev\">\n" );
		$path = "$prefix$next{ $chapter_id }$content$extension";
		output( "<link href=\"$path\" rel=\"next\">\n" );
	    }
	    $path = $DebianDoc_SGML::Format::Driver::opt_1
		? '' : "$prefix$topname$content$extension";
	    output( "<link href=\"$path#contents\" rel=\"contents\">\n" );
	    $path = $DebianDoc_SGML::Format::Driver::opt_1
		? '' : "$prefix$topname$content$extension";
	    output( "<link href=\"$path#copyright\" rel=\"copyright\">\n" );
	}
	foreach my $id ( @chapter_id )
	{
	    my $path = $DebianDoc_SGML::Format::Driver::opt_1
		? "#$id" : "$prefix$id$content$extension";
	    my $title = "$chapter_num{ $id } $chapter_title{ $id }";
	    $title =~ s/<[^>]*>//g;
	    output( "<link"
		    . " href=\"$path\""
		    . ( $chapter_type{ $id } eq 'chapter'
			? " rel=\"chapter\""
			: " rel=\"appendix\"" )
		    . " title=\"$title\""
		    . ">\n" );
	}
	foreach my $id ( @section_id )
	{
	    my $path = "$prefix$section_chapter_id{ $id }$content$extension"
		if ! $DebianDoc_SGML::Format::Driver::opt_1;
	    my $title = "$section_num{ $id } $section_title{ $id }";
	    $title =~ s/<[^>]*>//g;
	    output( "<link"
		    . " href=\"$path#$id\""
		    . " rel=\"section\""
		    . " title=\"$title\""
		    . ">\n" );
	}
	foreach my $id ( @subsection_id )
	{
	    my $path = "$prefix$subsection_chapter_id{ $id }$content$extension"
		if ! $DebianDoc_SGML::Format::Driver::opt_1;
	    my $title = "$subsection_num{ $id } $subsection_title{ $id }";
	    $title =~ s/<[^>]*>//g;
	    output( "<link"
		    . " href=\"$path#$id\""
		    . " rel=\"subsection\""
		    . " title=\"$title\""
		    . ">\n" );
	}
    }
    output( "\n" );
    output( "</head>\n" );
    output( "\n" );
    output( "<body>\n" );
}
sub _navigation
{
    output( "\n" );
    output( "<p><a name=\"$_[0]\"></a></p>\n" ) if length( $_[0] );
    output( "<hr>\n" );
    output( "\n" );
    output( "<p>\n" );
    output( "[ " );
    _output_ref( $locale{ 'previous' }, '',
		 $previous{ $chapter_id }, $previous{ $chapter_id } );
    output( " ]\n" );
    output( "[ " );
    _output_ref( $locale{ 'contents' }, '', $topname, 'contents' );
    output( " ]\n" );
    foreach my $id ( @chapter_id )
    {
	$chapter_num = $chapter_num{ $id };
	if ( length( $chapter_num ) )
	{
	    output( "[ " );
	    if ( $id eq $chapter_id )
	    {
		output( $chapter_num );
	    }
	    else
	    {
		_output_ref( $chapter_num, '', $id, $id );
	    }
	    output( " ]\n" );
	}
    }
    output( "[ " );
    _output_ref( $locale{ 'next' }, '',
		 $next{ $chapter_id }, $next{ $chapter_id } );
    output( " ]\n" );
    output( "</p>\n" );
}

sub _html_tail
{
    output( "\n" );
    output( "<hr>\n" );
    output( "\n" );
    output( "<p>\n" );
    output( "$title\n" );
    output( "</p>\n" );
    output( "\n" );
    output( "<address>\n" );
    if ( length( $version ) )
    {
	output( "$version<br>\n" );
	output( "<br>\n" );
    }
    if ( $#author >= 0 )
    {
	foreach ( @author )
	{
	    output( "$_<br>\n" );
	}
	output( "<br>\n" );
    }
    if ( $#translator >= 0 )
    {
	foreach ( @translator )
	{
	    output( "$_<br>\n" );
	}
	output( "<br>\n" );
    }
    output( "</address>\n" );
    output( "<hr>\n" );
    output( "\n" );
    output( "</body>\n" );
    output( "\n" );
    output( "</html>\n" );
    output( "\n" );
}

## ----------------------------------------------------------------------
## title page output subroutines
## ----------------------------------------------------------------------
sub _output_titlepag
{
    push_output( 'string' );
    _output_heading( '', -3, '', $topname );
    if ( length( $abstract ) )
    {
	_output_heading( $locale{ 'abstract' }, 0, '', 'abstract' );
	output( $abstract );
    }
    if ( length( $copyright ) )
    {
	_output_heading( $locale{ 'copyright notice' }, 0, '', 'copyright' );
	output( $copyright );
    }
    $titlepag = pop_output;
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
    output( "<p>\n" );
    output( join( "<br>\n", @copyrightsummary ), "\n" );
    output( "</p>\n" );
    output( $_[0] );
    $copyright = pop_output;
}
sub _output_copyrightsummary
{
    push( @copyrightsummary, $_[0] );
}

## ----------------------------------------------------------------------
## table of contents output subroutines
## ----------------------------------------------------------------------
sub _output_toc
{
    $chapter_id = '';
    push_output( 'string' );
    _output_heading( $locale{ 'contents' }, 0, '', 'contents' );
    my $toc_level = -1;
    output( "\n" );
    output( "<ul>\n" );
    foreach my $toc_entry_id ( @toc_entry_id )
    {
	my $toc_entry_level = $toc_entry_level{ $toc_entry_id };
	if ( $toc_level > $toc_entry_level )
	{
            output( "\n" );
	    while ( $toc_level > $toc_entry_level )
	    {
		output( "  " x ( $toc_level + 1 ) );
		output( "</ul></li>\n" );
	        $toc_level += -1 ;
	    }
	}
	elsif ( $toc_level < $toc_entry_level )
	{
            output( "\n" );
	    output( "  " x ( $toc_entry_level + 1 ) );
	    output( "<ul>\n" x ( $toc_entry_level - $toc_level ) );
	}
	elsif ( $toc_level > -1 )
	{
	    output( "</li>\n" );
	}
	output( "  " x ( $toc_entry_level + 1 ) );
	output( "<li>" );
	_output_ref( "$toc_entry_id $toc_entry_name{ $toc_entry_id }", '',
		     $toc_entry_chapter_id{ $toc_entry_id },
		     $toc_entry_fragment{ $toc_entry_id } );
	$toc_level = $toc_entry_level;
    }
    output( "</li>\n" );
    while ( $toc_level > -1 )
    {
	output( "  " x ( $toc_level + 1 ) );
	output( "</ul></li>\n" );
        $toc_level += -1 ;
    }
    output( "</ul>\n" );
    $toc = pop_output;
}
sub _output_tocentry
{
    $chapter_id = $_[3] if $_[1] == -1;
    if ( $_[1] == 0 )
    {
	$section_id = $_[3];
	$section_num{ $section_id } = $_[2];
	$section_title{ $section_id } = $_[0];
	$section_chapter_id{ $section_id } = $chapter_id;
	push( @section_id, $section_id );
    }
    if ( $_[1] > 0 )
    {
	$subsection_id = $_[3];
	$subsection_num{ $subsection_id } = $_[2];
	$subsection_title{ $subsection_id } = $_[0];
	$subsection_chapter_id{ $subsection_id } = $chapter_id;
	push( @subsection_id, $subsection_id );
    }
    return if $_[1] > $DebianDoc_SGML::Format::Driver::toc_detail;
    push( @toc_entry_id, $_[2] );
    $toc_entry_chapter_id{ $_[2] } = $chapter_id;
    $toc_entry_name{ $_[2] } = $_[0];
    $toc_entry_level{ $_[2] } = $_[1];
    $toc_entry_fragment{ $_[2] } = $_[3];
}

## ----------------------------------------------------------------------
## section output subroutines
## ----------------------------------------------------------------------
sub _output_chapter
{
    $chapter{ $chapter_id } = $_[0];
    $chapter_title{ $chapter_id } = $chapter_title;
    $chapter_num{ $chapter_id } = $chapter_num;
    $chapter_type{ $chapter_id } = $chapter_type;
    push( @chapter_id, $chapter_id );
}
sub _output_appendix
{
    $chapter{ $chapter_id } = $_[0];
    $chapter_title{ $chapter_id } = $chapter_title;
    $chapter_num{ $chapter_id } = $chapter_num;
    $chapter_type{ $chapter_id } = $chapter_type;
    push( @chapter_id, $chapter_id );

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
    if ( $_[1] < 0 )
    {
	if ( length( $_[0] ) )
	{
	    $chapter_id = $_[3];
	    $chapter_type = ( $_[2] =~ m/^[A-Z]$/ ? 'appendix' : 'chapter');
	    $chapter_num = $_[2];
	    $chapter_title = $_[0];
	}
	output( "\n" );
	output( "<hr>\n" );
	output( "\n" );
        output( "<h1>\n" );
	output( "$title\n" );
	output( "<br>" ) if $_[1] > -4;
	output( $locale{ $chapter_type } ) if $_[1] == -3;
	output( $locale{ $chapter_type }( $_[2] ) ) if $_[1] > -3;
	output( " - $_[0]" ) if length( $_[0] );
	output( "\n" ) if $_[1] eq -1;
	output( "</h1>\n" );
	$need_hr = 1;
    }
    else
    {
	output( "\n" );
	output( "<hr>\n" );
	output( "\n" );
	output( "<h" . ( $_[1] + 2 ) . " id=\"$_[3]\">" );
	output( "$_[2] " ) if length( $_[2] );
	output( $_[0] );
        output( "</h" . ( $_[1] + 2 ) . ">\n" );
	$need_hr = 0
    }
}

## ----------------------------------------------------------------------
## paragraph output subroutines
## ----------------------------------------------------------------------
sub _output_p
{
    if ( $need_hr )
    {
	output( "\n" );
	output( "<hr>\n" );
	$need_hr = 0;
    }
    if ( length( $_[0] ) )
    {
	output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
	output( "<p>\n" );
	output( $text->format( "$_[0]\n" ) );
	output( "</p>\n" );
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
    $_[0] = "     " . $_[0];
    $_[0] =~ s/\n/\n     /g;
    $_[0] =~ s/\s+$/\n/;
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    output( "<pre>\n" );
    output( $_[0] );
    output( "</pre>\n" );
}

## ----------------------------------------------------------------------
## footnote output subroutines
## ----------------------------------------------------------------------
sub _output_footnotes
{
    push_output( 'string' );
    $chapter_type = 'footnotes';
    _output_heading( '', -3, '', '' );
    my $footnoteref = 1;
    foreach my $footnote ( @footnote )
    {
	output( "\n" );
	output( "<h2>" );
	_output_ref( $footnoteref, '', $footnote_chapter_id[$footnoteref - 1],
		     "fr$footnoteref", "name=\"f$footnoteref\"" );
	output( "</h2>\n" );
	output( "\n" );
	output( $footnote );
	$footnoteref++;
    }
    $footnote = pop_output;
}
sub _output_footnote
{
    push( @footnote, $_[0] );
    push( @footnote_chapter_id, $chapter_id );
    my $footnoteref = scalar( @footnote );
    _output_ref( $footnoteref, '', 'footnotes', "f$footnoteref",
		 "name=\"fr$footnoteref\"", "]", "[" );
}

## ----------------------------------------------------------------------
## comment output subroutines
## ----------------------------------------------------------------------
sub _output_comments
{
    push_output( 'string' );
    $chapter_type = 'comments';
    _output_heading( '', -3, '', '' );
    my $commentref = 1;
    foreach my $comment ( @comment )
    {
	my $editor = $comment_editor[$commentref - 1];
	$editor = " ($editor)" if length( $editor );
	output( "\n" );
	output( "<h2>" );
	_output_ref( "c$commentref", '', $comment_chapter_id[$commentref - 1],
		     "cr$commentref", "name=\"c$commentref\"", $editor );
	output( "</h2>\n" );
	output( "\n" );
	output( $comment );
	$commentref++;
    }
    $comment = pop_output;
}
sub _output_comment
{
    push( @comment, $_[0] );
    push( @comment_editor, $_[1] );
    push( @comment_chapter_id, $chapter_id );
    my $commentref = scalar( @comment );
    _output_ref( "c$commentref", '', 'comments', "c$commentref",
		 "name=\"cr$commentref\"", "]", "[" );
}

## ----------------------------------------------------------------------
## list output subroutines
## ----------------------------------------------------------------------
sub _output_list
{
    output( "<ul>\n" ) if $DebianDoc_SGML::Format::Driver::is_compact;
    output( $_[0] );
    output( "</ul>\n" ) if $DebianDoc_SGML::Format::Driver::is_compact;
}
sub _output_enumlist
{
    my $type = '1';
    if ( $_[2] eq 'UPPERALPHA' )
    {
	$type = 'A';
    }
    elsif ( $_[2] eq 'LOWERALPHA' )
    {
	$type = 'a';
    }
    elsif ( $_[2] eq 'UPPERROMAN' )
    {
	$type = 'I';
    }
    elsif ( $_[2] eq 'LOWERROMAN' )
    {
	$type = 'i';
    }
    if ( $DebianDoc_SGML::Format::Driver::opt_x )
    {
	output( "<ol>\n" );
    }
    else
    {
        if ( $DebianDoc_SGML::Format::Driver::is_compact )
	{
	    output( "<!-- ol " );
	    output( "type=\"$type\" " );
	    output( "start=\"" . $DebianDoc_SGML::Format::Driver::item_counter . "\" " );
	    output( " -->\n" );
	}
    }
    output( $_[0] );
    if ( $DebianDoc_SGML::Format::Driver::opt_x )
    {
    output( "</ol>\n" );
    }
    else
    {
        if ( $DebianDoc_SGML::Format::Driver::is_compact )
	{
	    output( "</ol>\n" );
	}
    }
}
sub _output_taglist
{
    output( "<dl>\n" ) if $DebianDoc_SGML::Format::Driver::is_compact;
    output( $_[0] );
    output( "</dl>\n" ) if $DebianDoc_SGML::Format::Driver::is_compact;
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
#    $_[0] =~ s/^<p>\n//;
    output( "<ul>\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    output( "<li>\n" );
    output( $_[0] );
    output( "</li>\n" );
    output( "</ul>\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
}
sub _output_enumlist_item
{
    my $type = '1';
    if ( $_[2] eq 'UPPERALPHA' )
    {
	$type = 'A';
    }
    elsif ( $_[2] eq 'LOWERALPHA' )
    {
	$type = 'a';
    }
    elsif ( $_[2] eq 'UPPERROMAN' )
    {
	$type = 'I';
    }
    elsif ( $_[2] eq 'LOWERROMAN' )
    {
	$type = 'i';
    }
    $_[0] =~ s/^\n//;
#    $_[0] =~ s/^<p>\n//;
    if ( ! $DebianDoc_SGML::Format::Driver::opt_x )
    {
	if ( ! $DebianDoc_SGML::Format::Driver::is_compact )
	{
	    output( "<ol " );
	    output( "type=\"$type\" " );
	    output( "start=\"".$DebianDoc_SGML::Format::Driver::item_counter."\" " );
	    output( ">\n" );
	}
    }
    output( "<li>\n" );
    output( $_[0] );
    output( "</li>\n" );
    if ( ! $DebianDoc_SGML::Format::Driver::opt_x )
    {
        if ( ! $DebianDoc_SGML::Format::Driver::is_compact )
	{
	    output( "</ol>\n" );
	}
    }
}
sub _output_taglist_item
{
    $_[0] =~ s/^\n//;
#    $_[0] =~ s/^<p>\n//;
    output( "<dl>\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    foreach ( @{$_[1]} )
    {
        output( "<dt>$_</dt>\n" );
    }
    output( "<dd>\n" );
    output( $_[0] );
    output( "</dd>\n" );
    output( "</dl>\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
}

## ----------------------------------------------------------------------
## emph output subroutines
## ----------------------------------------------------------------------
sub _output_em
{
    output( "<em>$_[0]</em>" );
}
sub _output_strong
{
    output( "<strong>$_[0]</strong>" );
}
sub _output_var
{
    output( "<var>$_[0]</var>" );
}
sub _output_package
{
    output( "<code>$_[0]</code>" );
}
sub _output_prgn
{
    output( "<code>$_[0]</code>" );
}
sub _output_file
{
    output( "<code>$_[0]</code>" );
}
sub _output_tt
{
    output( "<samp>$_[0]</samp>" );
}
sub _output_qref
{
    _output_ref( $_[0], '', $_[1], $_[2] );
}

## ----------------------------------------------------------------------
## xref output subroutines
## ----------------------------------------------------------------------
sub _output_ref
{
    output( "$_[6]" ) if length( $_[6] );
    output( "<a href=\"" );
    output( "$prefix$_[2]$content$extension" ) if ( $_[2] ne $chapter_id )
	&& ( ! $DebianDoc_SGML::Format::Driver::opt_1 );
    output( "#$_[3]" ) if length( $_[3] )
	&& ( ( $_[3] ne $_[2] ) || $DebianDoc_SGML::Format::Driver::opt_1 );
    output( "\"" );
    output( " $_[4]" ) if length( $_[4] );
    output( ">$_[0]" );
    if ( length( $_[1] ) )
    {
	my ( $name, $number ) = split( / /, $_[1], 2 );
	output( ", " );
	output( $locale{ $name }( $number ) );
    }
    output( "</a>" );
    output( "$_[5]" ) if length( $_[5] );
}
sub _output_manref
{
    output( "<code>$_[0]($_[1])</code>" );
}
sub _output_email
{
    output( " " )
	if (    $DebianDoc_SGML::Format::Driver::in_author
	     || $DebianDoc_SGML::Format::Driver::in_translator );
    _output_url( "mailto:$_[0]", $_[0] );
}
sub _output_ftpsite
{
    my $url = URI->new( $_[0] );
    output( "<code>$url</code>" );
}
sub _output_ftppath
{
    _output_url( "ftp://$_[0]$_[1]", $_[1] );
}
sub _output_httpsite
{
    my $url = URI->new( $_[0] );
    output( "<code>$url</code>" );
}
sub _output_httppath
{
    _output_url( "http://$_[0]$_[1]", $_[1] );
}
sub _output_url
{
    my $url = URI->new( _to_cdata( $_[0] ) );
    $_[1] = $_[0] if $_[1] eq "";
    output( "<code><a href=\"$url\">" );
    _cdata( $_[1] );
    output( "</a></code>" );
}

## ----------------------------------------------------------------------
## data output subroutines
## ----------------------------------------------------------------------
sub _to_cdata
{
    ( $_ ) = @_;

    # special characters
    s/([<>&\"])/$cdata{ $1 }/g;

    # SDATA
    s/\\\|(\[\w+\s*\])\\\|/$sdata{ $1 }/g;

    return $_;
}
sub _cdata
{
    output( _to_cdata( $_[0] ) );
}
sub _sdata
{
    output( $sdata{ $_[0] } );
}

## ----------------------------------------------------------------------
## don't forget this
1;

## ----------------------------------------------------------------------
