## -*- perl -*-
## ----------------------------------------------------------------------
## DebianDoc_SGML/Format/LaTeX: LaTeX output format generator
## ----------------------------------------------------------------------
## Copyright (C) 1998-2004 Ardo van Rangelrooij
## Copyright (C) 1997 Christian Leutloff
##
## This is free software; see the GNU General Public Licence
## version 2 or later for copying conditions.  There is NO warranty.
## ----------------------------------------------------------------------

## ----------------------------------------------------------------------
## package interface definition
package DebianDoc_SGML::Format::LaTeX;
use strict;
use vars qw( @ISA @EXPORT );
use Exporter;
@ISA = ( 'Exporter' );
@EXPORT = qw ();

## ----------------------------------------------------------------------
## import packages
use Roman;
use SGMLS::Output;

## ----------------------------------------------------------------------
my %locale = %DebianDoc_SGML::Format::Driver::locale;
my %sdata = %DebianDoc_SGML::Format::Driver::sdata;

## ----------------------------------------------------------------------
## paper size definitions
my @paper = split( /\s/, `2>/dev/null paperconf -N` );
my $pagespec = "A4";
if ( $#paper > -1 )
{
    if ( $paper[0] =~ m/[ABC][0-9]/ )
    {
	$pagespec = $paper[0];
    }
    elsif ( $paper[0] =~ m/[letter|legal|executive]/ )
    {
	$paper[0] =~ tr/A-Z/a-z/;
	$pagespec = "US" . $paper[0];
    }
}

## ----------------------------------------------------------------------
## layout definitions
$DebianDoc_SGML::Format::Driver::indent_level = 1;

## ----------------------------------------------------------------------
## global variables
use vars qw( $set_appendix $set_arabic );
use vars qw( $in_quote );

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
    output( "\\documentclass[10pt" );
    output( ",$locale{ 'babel' }" ) 
    	if (length( $locale{ 'babel' } ));
    output( "]{book}\n" );
    output( "\n" );
    output( "\\usepackage[$locale{ 'inputenc' }]{inputenc}\n\n" )
	if length( $locale{ 'inputenc' } );
    output( "\\usepackage[T1]{fontenc}\n" );
    output( "\n" );
    output( "\\usepackage{ifpdf}\n" );
    output( "\\usepackage{pifont}\n" );
    output( "\\usepackage[force]{textcomp}\n" );
    output( "\\usepackage{wasysym}\n" );
    output( "\n" );
    output( "\\usepackage{babel}\n\n" )
        if length( $locale{ 'babel' } );
    output( "\\usepackage{helvet}\n" );
    output( "\\usepackage{palatino}\n" );
    output( "\n" );
    output( "\\usepackage{vmargin}\n" );
    output( "\\setpapersize{$pagespec}\n" );
    output( "\\setmarginsrb{10mm}{10mm}{10mm}{10mm}{12pt}{5mm}{0pt}{5mm}\n" );
    output( "\n" );
    output( "\\usepackage{fancyhdr}\n" );
    output( "\\pagestyle{fancy}\n" );
    output( "\\renewcommand{\\chaptermark}[1]{%\n" );
    output( "\\markboth{\\chaptername\\ \\thechapter.\\ #1}{}}\n" );
    output( "\\lhead{\\leftmark}\n" );
    output( "\\chead{}\n" );
    output( "\\rhead{\\thepage}\n" );
    output( "\\lfoot{}\n" );
    output( "\\cfoot{}\n" );
    output( "\\rfoot{}\n" );
    output( "\\renewcommand{\\headrulewidth}{0.4pt}\n" );
    output( "\\renewcommand{\\footrulewidth}{0pt}\n" );
    output( "\\fancypagestyle{plain}{%\n" );
    output( "\\lhead{}\n" );
    output( "\\chead{}\n" );
    output( "\\rhead{\\thepage}\n" );
    output( "\\lfoot{}\n" );
    output( "\\cfoot{}\n" );
    output( "\\rfoot{}\n" );
    output( "\\renewcommand{\\headrulewidth}{0.4pt}\n" );
    output( "\\renewcommand{\\footrulewidth}{0pt}}\n" );
    output( "\n" );
    output( "\\usepackage{paralist}\n" );
    output( "\n" );
    output( "\\usepackage{alltt}\n" );
    output( "\n" );
    output( "\\usepackage[multiple]{footmisc}\n" );
    output( "\n" );
    output( "\\usepackage{url}\n" );
    output( "\\newcommand\\email{\\begingroup \\urlstyle{tt}\\Url}\n" );
    output( "\\def\\file#1{\\texttt{\\spaceskip=1sp\\relax#1}}\n" );
    output( "\n" );
    output( "\\usepackage{varioref}\n" );
    output( "\\vrefwarning\n" );
    output( "\n" );
    output( "\\ifpdf\n" );
    output( "\\usepackage[colorlinks=true" );
    output( ",$locale{ 'pdfhyperref' }" )
    	if (length( $locale{ 'pdfhyperref' } ));
    output( "]{hyperref}\n" );
    output( "\\else\n" );
    output( "\\usepackage[hypertex]{hyperref}\n" );
    output( "\\fi\n" );
    output( "\n" );
    output( "\\parindent=0pt\n" );
    output( "\\setlength{\\parskip}{%\n" );
    output( "0.5\\baselineskip plus0.1\\baselineskip minus0.1\\baselineskip}\n" );
    output( "\n" );
    output( "\\usepackage{xspace}\n" );
    output( "\n" );
    output( "\\sloppy\n" );
    output( "\n" );
    output( "$locale{ 'before begin document' }\n" );
    output( "\\begin{document}\n" );
    output( "$locale{ 'after begin document' }\n" );
}
sub _output_end_book
{
    output( "\n" );
    output( "$locale{ 'before end document' }\n" );
    output( "\\end{document}\n");
    output( "\n" );
}

## ----------------------------------------------------------------------
## title page output subroutines
## ----------------------------------------------------------------------
sub _output_titlepag
{
    output( "\n" );
    output( "\\begin{titlepage}\n" );
    output( "\n" );
    output( "\\thispagestyle{empty}\n" );
    output( "\n" );
    output( "\\vspace*{2ex}\n" );
    output( "\\begin{center}\n" );
    output( "{\\Huge $title} \\\\[2ex]\n" );
    output( "\\end{center}\n" ); 
    output( "\n" );
    output( "\\begin{center}\n" );
    foreach ( @author )
    {
	output( "{\\large $_ } \\\\\n" );
    }
    output( "\\end{center}\n" ); 
    output( "\n" );
    output( "\\begin{center}\n" );
    foreach ( @translator )
    {
	output( "{\\large $_ } \\\\\n" );
    }
    output( "\\end{center}\n" ); 
    if ( length( $version ) )
    {
	output( "\n" );
	output( "\\vspace*{1ex}\n" );
	output( "\\begin{center}\n" );
	output( "$version \\\\\n" );
	output( "\\end{center}\n" ); 
    }
    if ( length( $abstract ) )
    {
	output( "\n" );
	output( "\\vspace*{1ex}\n" );
	output( "\\begin{center}\n" );
	output( "\\section*{$locale{ 'abstract' }}\n" );
	output( "\\end{center}\n" ); 
	output( "\n" );
	output( $abstract );
    }
    if ( length( $copyright ) )
    {
	output( "\n" );
	output( "\\newpage\n" );
	output( "\n" );
	output( "\\thispagestyle{empty}\n" );
	output( "\n" );
	output( "\\vspace*{1ex}\n" );
	output( "\\vfill\n" );
	output( "\\section*{$locale{ 'copyright notice' }}\n" );
	output( "\n" );
	output( $copyright );
    }
    output( "\n" );
    output( "\\end{titlepage}\n" ); 
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
    output( join( " \\\\\n", @copyrightsummaries ), "\n" );
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
    output( "\n" );
    output( "\\pagenumbering{roman}\n" );
    output( "\\tableofcontents\n" );
}
sub _output_tocentry
{
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
    if ( $_[1] == -2 && ! $set_appendix )
    {
	$set_appendix = 1;
	output( "\n" );
	output( "\\appendix\n" );
    }
    output( "\n" );
    if ( $_[1] < 0 )
    {
	output( "\\chapter" );
    }
    elsif ( $_[1] == 0 )
    {
	output( "\\section" );
    }
    elsif ( $_[1] == 1 )
    {
	output( "\\subsection" );
    }
    elsif ( $_[1] == 2 )
    {
	output( "\\subsubsection" );
    }
    elsif ( $_[1] == 3 )
    {
	output( "\\paragraph" );
    }
    else
    {
	output( "\\subparagraph" );
    }
    # disable \\NoAutoSpaceBeforeFDP within heading for french. Bug #594846
    if ( $locale{ 'babel' } eq 'french' )
    {
	$_[0] =~ s/\{\\NoAutoSpaceBeforeFDP//g ;
	$_[0] =~ s/\\AutoSpaceBeforeFDP\}//g ;
    }
    output( "{$_[0]}\n" );
    output( "\\label{$_[3]}\n" ) if length( $_[3] );
    if ( ! $set_arabic )
    {
	$set_arabic = 1;
	output( "\\pagenumbering{arabic}\n" );
    }
}

## ----------------------------------------------------------------------
## paragraph output subroutines
## ----------------------------------------------------------------------
sub _output_p
{
    if ( length( $_[0] ) )
    {
	# Before a new paragraph and after a non-compact example
	output( "\n" )
	    if ! $DebianDoc_SGML::Format::Driver::is_compact
		&& ! $DebianDoc_SGML::Format::Driver::was_compact;
	$_[0] =~ s/^\s+//gm;	# remove leading spaces
	$_[0] =~ s/\n\n+/\n/g;	# no blank lines in paragraphs
	output( "$_[0]\n" );
    }
    else
    {
	# This puts a newline between adjacent specials, which doesn't
	# do anything, but more importantly ensures that there is a
	# newline before a paragraph which begins with a compact special
	output( "\n" )
	    if ( $DebianDoc_SGML::Format::Driver::is_special
		 && ! $DebianDoc_SGML::Format::Driver::is_compact
		 && $DebianDoc_SGML::Format::Driver::will_be_compact );
    }
    # The logic here is a bit hairy.  Basically, we only change the
    # \parskip setting if the specified conditions are met:
    #  set to >0 if we're not currently compact and we're just coming out
    #               of a compact state, but we're not about to enter
    #               one again
    if ( ! $DebianDoc_SGML::Format::Driver::is_compact &&
	 $DebianDoc_SGML::Format::Driver::was_compact &&
	 ( ( $DebianDoc_SGML::Format::Driver::is_special &&
	     ! $DebianDoc_SGML::Format::Driver::will_be_compact) ||
	   ! $DebianDoc_SGML::Format::Driver::is_special ) )
    {
	output( "\\setlength{\\parskip}{%\n" );
	output( "0.5\\baselineskip plus0.1\\baselineskip minus0.1\\baselineskip}\n" );
    }
    # and set to 0 if we're about to enter a compact state, but we aren't
    #                 currently compact or leaving a compact state
    if ( $DebianDoc_SGML::Format::Driver::is_special &&
	 $DebianDoc_SGML::Format::Driver::will_be_compact &&
	 ! $DebianDoc_SGML::Format::Driver::is_compact &&
	 ! $DebianDoc_SGML::Format::Driver::was_compact )
    {
	output( "\\setlength{\\parskip}{0ex}\n" );
    }
}

## ----------------------------------------------------------------------
## example output subroutines
## ----------------------------------------------------------------------
sub _output_example
{
    my $space = $DebianDoc_SGML::Format::Driver::indent_level > 0 ?
	"  " x $DebianDoc_SGML::Format::Driver::indent_level : "    ";
    $_[0] = " $space" . $_[0];
    $_[0] =~ s/\n/\n $space/g;
    $_[0] =~ s/\s+$/\n/;
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    output( "\\scriptsize\\begin{alltt}\n" );
    output( $_[0] );
    output( "\\end{alltt}\\normalsize\n" );
}

## ----------------------------------------------------------------------
## footnote output subroutines
## ----------------------------------------------------------------------
sub _output_footnote
{
    output( "\\footnote{$_[0]}" );
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
    output( $DebianDoc_SGML::Format::Driver::is_compact
	    ? "\\begin{compactitem}\n" : "\\begin{itemize}\n" );
    output( $_[0] );
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    output( $DebianDoc_SGML::Format::Driver::is_compact
	    ? "\\end{compactitem}\n" : "\\end{itemize}\n" );
}
sub _output_enumlist
{
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    output( $DebianDoc_SGML::Format::Driver::is_compact
	    ? "\\begin{compactenum}\n" : "\\begin{enumerate}\n" );
    output( $_[0] );
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    output( $DebianDoc_SGML::Format::Driver::is_compact
	    ? "\\end{compactenum}\n" : "\\end{enumerate}\n" );
}
sub _output_taglist
{
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    output( $DebianDoc_SGML::Format::Driver::is_compact
	    ? "\\begin{compactdesc}\n" : "\\begin{description}\n" );
    output( $_[0] );
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    output( $DebianDoc_SGML::Format::Driver::is_compact
	    ? "\\end{compactdesc}\n" : "\\end{description}\n" );
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
    output( "\\item\n" );
    output( $_[0] );
}
sub _output_enumlist_item
{
    $_[0] =~ s/^\n//;
    my $item_counter = $DebianDoc_SGML::Format::Driver::item_counter;
    if ( $_[2] eq 'UPPERROMAN' )
    {
	$item_counter = Roman( $item_counter );
    }
    elsif ( $_[2] eq 'LOWERROMAN' )
    {
	$item_counter = roman( $item_counter );
    }
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    output( "\\item[$item_counter]\n" );
    output( $_[0] );
}
sub _output_taglist_item
{
    $_[0] =~ s/^\n//;
    output( "\n" ) if ! $DebianDoc_SGML::Format::Driver::is_compact;
    foreach ( @{$_[1]} )
    {
        output( "\\item[$_]\n" );
    }
    output( "$_[0]" );
}

## ----------------------------------------------------------------------
## emph output subroutines
## ----------------------------------------------------------------------
sub _output_em
{
    output( "\\textit{$_[0]}" );
}
sub _output_strong
{
    output( "\\textbf{$_[0]}" );
}
sub _output_var
{
    output( "\\textit{$_[0]}" );
}
sub _output_package
{
    $_[0] =~ s/--/---/g;
    output( "{\\NoAutoSpaceBeforeFDP" ) if $locale{ 'babel' } eq 'french';
    output( "\\texttt{$_[0]}" );
    output( "\\AutoSpaceBeforeFDP}" ) if $locale{ 'babel' } eq 'french';
}
sub _output_prgn
{
    $_[0] =~ s/--/---/g;
    output( "{\\NoAutoSpaceBeforeFDP" ) if $locale{ 'babel' } eq 'french';
    output( "\\texttt{$_[0]}" );
    output( "\\AutoSpaceBeforeFDP}" ) if $locale{ 'babel' } eq 'french';
}
sub _output_file
{
    $_[0] =~ s|/| /|g;
    output( "\\file{$_[0]}" );
}
sub _output_tt
{
    $_[0] =~ s/--/---/g;
    output( "{\\NoAutoSpaceBeforeFDP" ) if $locale{ 'babel' } eq 'french';
    output( "\\texttt{$_[0]}" );
    output( "\\AutoSpaceBeforeFDP}" ) if $locale{ 'babel' } eq 'french';
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
    output( "`$_[0]' \\vpageref{$_[3]}" );
}
sub _output_manref
{
    $_[0] =~ s/--/---/g;
    $_[0] =~ s/\\\\/\\/g;
    output( "{\\NoAutoSpaceBeforeFDP" ) if $locale{ 'babel' } eq 'french';
    output( "\\texttt{" );
    _cdata( $_[0] );
    output( "($_[1])}" );
    output( "\\AutoSpaceBeforeFDP}" ) if $locale{ 'babel' } eq 'french';
}
sub _output_email
{
    output( ' ' )
	if (    $DebianDoc_SGML::Format::Driver::in_author 
	     || $DebianDoc_SGML::Format::Driver::in_translator );
    output( "\\email{<$_[0]>}" );
}
sub _output_ftpsite
{
    output( "\\url{$_[0]}" );
}
sub _output_ftppath
{
    output( "\\path|$_[1]|" );
}
sub _output_httpsite
{
    output( "\\url{$_[0]}" );
}
sub _output_httppath
{
    output( "\\path|$_[1]|" );
}
sub _output_url
{
    _cdata( $_[1] ) if $_[1] ne "";
    output( " (" ) if $_[1] ne "";
    output( "\\url{" );
    $DebianDoc_SGML::Format::Driver::is_argument = 1;
    _cdata( $_[0] );
    $DebianDoc_SGML::Format::Driver::is_argument = 0;
    output( "}" );
    output( ")" ) if $_[1] ne "";
}

## ----------------------------------------------------------------------
## data output subroutines
## ----------------------------------------------------------------------
sub _cdata
{
    ( $_ ) = @_;

    # replace backslash character
    s/\\/\\textbackslash/g;

    # escape command characters
    s/{/\\{/g;
    s/}/\\}/g;
    s/\$/\\\$/g;

    # replace backslash character
    s/\\textbackslash/\\textbackslash{}/g;

    # escape command characters
    s/_/\\_/g unless $DebianDoc_SGML::Format::Driver::is_argument;
    s/&/\\&/g;
    s/\#/\\\#/g;
    s/\%/\\\%/g;
    s/\^/\\textasciicircum{}/g;
    s/~/\\textasciitilde{}/g
	unless $DebianDoc_SGML::Format::Driver::is_argument;

    # no further replacement in examples
    if ( ! ( $DebianDoc_SGML::Format::Driver::is_example
	     || $DebianDoc_SGML::Format::Driver::is_argument ) )
    {

	# quotes
	if ( $in_quote && /\"/ )
	{
	    s/\"/\'\'/;
	    $in_quote = 0;
	}
	s/\"(.*?)\"/\`\`$1\'\'/g;
	if ( /\"/ )
	{
	    s/\"/\`\`/;
	    $in_quote = 1;
	}
	
	# dots should be ellipsis "..."
	s/\.\.\./\\dots{}/g;

    }

    # SDATA
    s/\\textbackslash\{}\|(\[\w+\s*\])\\textbackslash\{}\|/$sdata{ $1 }/g;

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
