## -*- perl -*-
## ----------------------------------------------------------------------
## DebianDoc_SGML/Format/XML: XML output format generator
## ----------------------------------------------------------------------
## Copyright (C) 2006 Osamu Aoki
## Copyright (C) 1998-2004 Ardo van Rangelrooij
## Copyright (C) 1996 Ian Jackson
##
## This is free software; see the GNU General Public Licence
## version 2 or later for copying conditions.  There is NO warranty.
## ----------------------------------------------------------------------

## ----------------------------------------------------------------------
## package interface definition
package DebianDoc_SGML::Format::XML;
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

# In XML, sections are sect,sect1,sect2,sect3
use vars qw( @toc_items );
@toc_items = (
		   'sect1',
		   'sect2',
		   'sect3'
		   );

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
my $topname = '';
if ( $DebianDoc_SGML::Format::Driver::opt_1 )
{
    $topname = length( $DebianDoc_SGML::Format::Driver::opt_t )
        ? $DebianDoc_SGML::Format::Driver::opt_t : $basename;
}
else
{
    $topname = length( $DebianDoc_SGML::Format::Driver::opt_t )
        ? $DebianDoc_SGML::Format::Driver::opt_t : 'index';
}
my $extension = length( $DebianDoc_SGML::Format::Driver::opt_e )
    ? ".$DebianDoc_SGML::Format::Driver::opt_e" : '.dbk';
my $single = $DebianDoc_SGML::Format::Driver::opt_1;

## ----------------------------------------------------------------------
## directory definition and creation
my $directory = '.';
if ( ! $DebianDoc_SGML::Format::Driver::opt_1 )
{
    $directory = "$basename$extension";
    -d "$directory" || mkdir( "$directory", 0777 )
       || die "cannot make directory \`$directory': $!\n";
}

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


## ----------------------------------------------------------------------
## book output subroutines
## ----------------------------------------------------------------------
sub _output_start_book
{
}
sub _output_end_book
{
    $chapter_id = $topname;
    my $file = "$prefix$chapter_id$content$extension";
    push_output( 'file', File::Spec->catfile( "$directory", "$file" ) );
    _html_head( "$content$extension" );
    if ( ! $DebianDoc_SGML::Format::Driver::opt_1 )
    {
        _html_tail();
        pop_output();
    }
    foreach $chapter_id ( @chapter_id )
    {
	my $idx;
	$idx = $chapter_id;
	$idx =~ s/^ch-//;
	$idx =~ s/^ap-//;
	$idx =~ s/_/-/g;
	$idx =~ s/ /-/g;
	if ( ! $DebianDoc_SGML::Format::Driver::opt_1 )
	{
	    my $file = "$prefix$idx$content$extension";
	    push_output( 'file',
			 File::Spec->catfile( "$directory", "$file" ) );
    	    output( "<?xml version='1.0' encoding='utf-8'?>\n" );
    	    output( "<!-- -*- DocBook -*- -->\n" );
	}
	output( $chapter{ $chapter_id } );
	if ( ! $DebianDoc_SGML::Format::Driver::opt_1 )
	{
	    pop_output();
	}
    }
    if ( $DebianDoc_SGML::Format::Driver::opt_1 )
    {
	$chapter_id = $topname;
	_html_tail();
	pop_output();
    }
}
sub _html_head
{
    output( "<?xml version='1.0' encoding='utf-8'?>\n" );
    output( "<!-- -*- DocBook -*- -->\n" );
    output( "<!DOCTYPE book PUBLIC \"-//OASIS//DTD DocBook XML V4.5//EN\"\n" );
    output( "    \"http://www.oasis-open.org/docbook/xml/4.5/docbookx.dtd\" [\n" );
    output( "<!-- Include entity definition file by uncommenting the following -->\n" );
    output( '<!-- <!ENTITY % versiondata SYSTEM "version.ent"> %versiondata;   -->' );
    output( "\n]>\n" );
    output( "\n" );

    my $locale = $DebianDoc_SGML::Format::Driver::locale;
    $locale =~ s/[\.@].*//;
    my $language_tag = lc( locale2language_tag( $DebianDoc_SGML::Format::Driver::opt_l ) );
    $language_tag = 'en' if $language_tag eq undef;

    output( "<book lang=\"$language_tag\">\n" );
    output( "\n" );
    output( "<title>$title</title>\n" );
    output( "\n" );
    output( "<bookinfo>\n" );
    output( "\n" );
    output( "<authorgroup>\n" );
    if ( $#author >= 0 )
    {
	foreach ( @author )
	{
	    my $personname ;
	    my $emailname ;
	    $personname = $_ ;
	    $emailname = $_ ;
            if ( $emailname =~ m/^.*<email>.*<\/email>.*$/ )
            {
	        $emailname =~ s/^.*<email>(.*)<\/email>.*$/$1/ ;
            }
            else
            {
                $emailname = '';
            }
	    $personname =~ s/<email>.*<\/email>// ;
	    # trim spacies and tabs
	    $personname =~ s/^[ 	]*// ;
	    $personname =~ s/[ 	]*$// ;
	    $emailname =~ s/^[ 	]*// ;
	    $emailname =~ s/[ 	]*$// ;
            if ( $emailname )
            {
	        output( "<author><personname>$personname</personname><email>$emailname</email></author>\n" );
            }
            else
            {
	        output( "<author><personname>$personname</personname></author>\n" );
            }
	}
	output( "\n" );
    }
    if ( $#translator >= 0 )
    {
	foreach ( @translator )
	{
	    my $personname ;
	    my $emailname ;
	    $personname = $_ ;
	    $emailname = $_ ;
            if ( $emailname =~ m/^.*<email>.*<\/email>.*$/ )
            {
	        $emailname =~ s/^.*<email>(.*)<\/email>.*$/$1/ ;
            }
            else
            {
                $emailname = '';
            }
	    $personname =~ s/<email>.*<\/email>// ;
	    # trim spacies and tabs
	    $personname =~ s/^[ 	]*// ;
	    $personname =~ s/[ 	]*$// ;
	    $emailname =~ s/^[ 	]*// ;
	    $emailname =~ s/[ 	]*$// ;
            if ( $emailname )
            {
	        output( "<othercredit role=\"translator\"><personname>$personname</personname><contrib><!-- [[language]] translation --></contrib><email>$emailname</email></othercredit>\n" );
            }
            else
            {
	        output( "<othercredit role=\"translator\"><personname>$personname</personname><contrib><!-- [[language]] translation --></contrib></othercredit>\n" );
            }
	}
	output( "\n" );
    }
    output( "</authorgroup>\n" );
    output( "<releaseinfo>$version</releaseinfo>\n" );
    output( "\n" );
    output( "<pubdate>" );
    output( "<!-- put date -->" );
    output( "</pubdate>\n" );
    output( "\n" );
#    output( $titlepag ) if length( $titlepag );
    if ( length( $abstract ) )
    {
        output( "\n" );
        output( "<abstract>\n" );
	output( $abstract );
        output( "</abstract>\n" );
    }
    if ( length( $copyright ) )
    {
        output( "\n" );
	foreach my $copyline ( @copyrightsummary )
	{
	    my $year;
            $copyline =~ s/copyright//i;
            $copyline =~ s/©//;
	    $year = $copyline;
	    $year =~ s/[A-Za-z<].*$//;
	    $year =~ s/^[	 ]*//;
	    $year =~ s/[	 ]*$//;
            output( "<copyright>" );
            output( "<year>" );
            output( "$year" );
            output( "</year>" );
            output( "<holder>" );
	    $copyline =~ s/^[^A-Za-z<]*([A-Za-z<].*)$/$1/g;
	    $copyline =~ s/<email>// ;
	    $copyline =~ s/<\/email>// ;
	    $copyline =~ s/^[ 	]*// ;
	    $copyline =~ s/[ 	]*$// ;
            output( $copyline );
            output( "</holder>" );
            output( "</copyright>\n" );
	}
        output( "<legalnotice>\n" );
	output( $copyright );
        output( "</legalnotice>\n" );
    }
    output( "\n" );
    output( "</bookinfo>\n" );
    output( "\n" );
    if ( ! $DebianDoc_SGML::Format::Driver::opt_1 )
    {
	output( "<!-- XInclude list start -->\n" );
	foreach my $id ( @chapter_id )
	{
	    my $idx = $id;
	    $idx =~ s/^ch-//;
	    $idx =~ s/^ap-//;
	    $idx =~ s/_/-/g;
	    $idx =~ s/ /-/g;
    	    output( "<xi:include href=\"" . $idx . $_[0] . "\" xmlns:xi=\"http://www.w3.org/2003/XInclude\"/>\n" );
	}
	output( "<!-- XInclude list end -->\n" );
	output( "\n" );
    }
    output( "\n" );
}

sub _html_tail
{
    output( "\n" );
    output( "</book>\n" );
    output( "\n" );
}
## ----------------------------------------------------------------------
## title page output subroutines
## ----------------------------------------------------------------------
sub _output_titlepag
{
#    push_output( 'string' );
#    $titlepag = pop_output;
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
## output_titlepagabstract output subroutines
## ----------------------------------------------------------------------
sub _output_abstract
{
#    # Remove <p> tag to work with debiandoc <abstract>
#    $_[0] =~ s/^<p>//;
#    $_[0] =~ s/<\/p>$//;
#    $_[0] =~ s/^\n//;
#    $_[0] =~ s/\n$//;
    $abstract = $_[0];
}

## ----------------------------------------------------------------------
## copyright output subroutines
## ----------------------------------------------------------------------
sub _output_copyright
{
    push_output( 'string' );
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
}
sub _output_tocentry
{
}

## ----------------------------------------------------------------------
## section output subroutines
## ----------------------------------------------------------------------
sub _output_chapter
{
    $chapter{ $chapter_id } = $_[0] . "</chapter>\n\n";
    $chapter_title{ $chapter_id } = $chapter_title;
    $chapter_num{ $chapter_id } = $chapter_num;
    $chapter_type{ $chapter_id } = $chapter_type;
    push( @chapter_id, $chapter_id );
}
sub _output_appendix
{
    $chapter{ $chapter_id } = $_[0] . "</appendix>\n\n";
    $chapter_title{ $chapter_id } = $chapter_title;
    $chapter_num{ $chapter_id } = $chapter_num;
    $chapter_type{ $chapter_id } = $chapter_type;
    push( @chapter_id, $chapter_id );

}
sub _output_sect
{
	if ( $DebianDoc_SGML::Format::Driver::opt_S )
	{
	    output( "</sect1>\n\n" );
	}
	else
	{
	    output( "</section>\n\n" );
	}
}
sub _output_sect1
{
	if ( $DebianDoc_SGML::Format::Driver::opt_S )
	{
	    output( "</sect2>\n\n" );
	}
	else
	{
	    output( "</section>\n\n" );
	}
}
sub _output_sect2
{
	if ( $DebianDoc_SGML::Format::Driver::opt_S )
	{
	    output( "</sect3>\n\n" );
	}
	else
	{
	    output( "</section>\n\n" );
	}
}
sub _output_sect3
{
	if ( $DebianDoc_SGML::Format::Driver::opt_S )
	{
	    output( "</sect4>\n\n" );
	}
	else
	{
	    output( "</section>\n\n" );
	}
}
sub _output_sect4
{
	if ( $DebianDoc_SGML::Format::Driver::opt_S )
	{
	    output( "</sect5>\n\n" );
	}
	else
	{
	    output( "</section>\n\n" );
	}
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
	my $idx;
	$idx=$_[3];
	$idx =~ s/^ch-//;
	$idx =~ s/^ap-//;
	$idx =~ s/_/-/g;
	$idx =~ s/ /-/g;
	output( "<chapter id=\"$idx\">" ) if $_[1] == -1;
	output( "<appendix id=\"$idx\">" ) if $_[1] == -2;
#	output( "<footnote id=\"$idx\">" ) if $_[1] == -3;
#	output( "<comment id=\"$idx\">" ) if $_[1] == -4;
	output( "<title>" );
	output( "$_[0]" );
	output( "</title>\n" );
    }
    else
    {
	my $xmlsectid = $_[1] + 1;
	my $idx;
	$idx=$_[3];
	$idx =~ s/^s-//;
	$idx =~ s/_/-/g;
	$idx =~ s/ /-/g;
	if ( $DebianDoc_SGML::Format::Driver::opt_S )
	{
	    output( "<sect$xmlsectid id=\"$idx\">" );
	}
	else
	{
	    output( "<section id=\"$idx\">" );
	}
	if ( length( $_[0] ) )
	{
            output( "<title>" );
	    output( $_[0] );
	    output( "</title>\n" );
	}
    }
}

## ----------------------------------------------------------------------
## paragraph output subroutines
## ----------------------------------------------------------------------
sub _output_p
{
    if ( length( $_[0] ) )
    {
	output( "<para>\n" );
	output( $text->format( "$_[0]\n" ) );
	output( "</para>\n" );
    }

}

## ----------------------------------------------------------------------
## example output subroutines
## ----------------------------------------------------------------------
sub _output_example
{
    $_[0] =~ s/\s+$/\n/;
#    $_[0] =~ s/^\W*$//; # remove white space only first line
    output( "<screen>\n" );
    output( $_[0] );
    output( "</screen>" );
    output( "\n" );
}

## ----------------------------------------------------------------------
## footnote output subroutines
## ----------------------------------------------------------------------
sub _output_footnotes
{
}
sub _output_footnote
{
    output( "<footnote>" );
    output( $_[0] );
    output( "</footnote>" );
}

## ----------------------------------------------------------------------
## comment output subroutines
## ----------------------------------------------------------------------
sub _output_comments
{
}
sub _output_comment
{
    output( "<remark editor=\"$_[1]\">" );
    output( $_[0] );
    output( "</remark>" );
}

## ----------------------------------------------------------------------
## list output subroutines
## ----------------------------------------------------------------------
sub _output_list
{
    output( "<itemizedlist>\n" );
    output( $_[0] );
    output( "</itemizedlist>" );
    output( "\n" );
}
sub _output_enumlist
{
    output( "<orderedlist numeration=\"arabic\">\n" );
    output( $_[0] );
    output( "</orderedlist>" );
    output( "\n" );
}
sub _output_taglist
{
    output( "<variablelist>\n" );
    output( $_[0] );
    output( "</variablelist>" );
    output( "\n" );
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
#    $_[0] =~ s/^\n//;
#    $_[0] =~ s/\n$//;
#    $_[0] =~ s/^<p>//;
#    $_[0] =~ s/<\/p>$//;
    output( "<listitem>\n" );
    output( $_[0] );
    output( "</listitem>\n" );
}
sub _output_enumlist_item
{
#    $_[0] =~ s/^\n//;
#    $_[0] =~ s/^<p>\n//;
    output( "<listitem>\n" );
    output( $_[0] );
    output( "</listitem>\n" );
}
sub _output_taglist_item
{
#    $_[0] =~ s/^\n//;
#    $_[0] =~ s/^<p>\n//;
    output( "<varlistentry>\n" );
    foreach ( @{$_[1]} )
    {
        output( "<term>" . $_ . "</term>\n" );
    }
    output( "<listitem>\n" );
    output( $_[0] );
    output( "</listitem>\n" );
    output( "</varlistentry>\n" );
}

## ----------------------------------------------------------------------
## emph output subroutines
## ----------------------------------------------------------------------
sub _output_em
{
    output( "<emphasis>$_[0]</emphasis>" );
}
sub _output_strong
{
    output( "<emphasis role=\"strong\">$_[0]</emphasis>" );
#    output( "<emphasis role=\"bold\">$_[0]</emphasis>" );
}
sub _output_var
{
    output( "<replaceable>$_[0]</replaceable>" );
}
sub _output_package
{
    output( "<systemitem role=\"package\">$_[0]</systemitem>" );
}
sub _output_prgn
{
    output( "<command>$_[0]</command>" );
}
sub _output_file
{
    output( "<filename>$_[0]</filename>" );
    # directory
}
sub _output_tt
{
    output( "<literal>$_[0]</literal>" );
}
sub _output_qref
{
    my $idx = $_[2];
    $idx =~ s/^ch-//;
    $idx =~ s/^ap-//;
    $idx =~ s/^s-//;
    $idx =~ s/_/-/g;
    $idx =~ s/ /-/g;
    output( "<link linkend=\"$idx\">$_[0]</link>" );
}

## ----------------------------------------------------------------------
## xref output subroutines
## ----------------------------------------------------------------------
sub _output_ref
{
    my $idx = $_[3];
    $idx =~ s/^ch-//;
    $idx =~ s/^ap-//;
    $idx =~ s/^s-//;
    $idx =~ s/_/-/g;
    $idx =~ s/ /-/g;
    output( "<xref linkend=\"$idx\"/>" );
}
sub _output_manref
{
    output( "<citerefentry><refentrytitle>$_[0]</refentrytitle><manvolnum>$_[1]</manvolnum></citerefentry>" );
}
sub _output_email
{
    if (    $DebianDoc_SGML::Format::Driver::in_author
	     || $DebianDoc_SGML::Format::Driver::in_translator )
    {
        output( " <email>" );
        output( $_[0] );
        output( "</email>" );
    }
    else
    {
        output( "<email>" );
        output( $_[0] );
        output( "</email>" );
    }
}
sub _output_ftpsite
{
    my $url = URI->new( $_[0] );
    output( "<ulink url=\"ftp://$url\">ftp://$url</ulink>" );
}
sub _output_ftppath
{
    _output_url( "ftp://$_[0]$_[1]", $_[1] );
}
sub _output_httpsite
{
    my $url = URI->new( $_[0] );
    output( "<ulink url=\"http://$url\">http://$url</ulink>" );
}
sub _output_httppath
{
    _output_url( "http://$_[0]$_[1]", $_[1] );
}
sub _output_url
{
    my $url = URI->new( _to_cdata( $_[0] ) );
    $_[1] = $_[0] if $_[1] eq "";
    output( "<ulink url=\"$url\">" );
    _cdata( $_[1] );
    output( "</ulink>" );
}

## ----------------------------------------------------------------------
## data output subroutines
## ----------------------------------------------------------------------
sub _to_cdata
{
    ( $_ ) = @_;

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
