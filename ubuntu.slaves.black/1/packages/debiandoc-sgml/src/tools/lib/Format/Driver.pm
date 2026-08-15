## -*- perl -*-
## ----------------------------------------------------------------------
## DebianDoc_SGML/Format/Driver: output format generator driver
## ----------------------------------------------------------------------
## Copyright (C) 1998-2004 Ardo van Rangelrooij
##
## This is free software; see the GNU General Public Licence
## version 2 or later for copying conditions.  There is NO warranty.
## ----------------------------------------------------------------------

## ----------------------------------------------------------------------
## package interface definition
package DebianDoc_SGML::Format::Driver;
use strict;
no strict 'refs';
no strict 'subs';
use vars qw( @ISA @EXPORT );
use Exporter;
@ISA = qw( Exporter );
@EXPORT = qw ();

## ----------------------------------------------------------------------
## get command line options
use vars qw( $opt_L $opt_P $opt_b $opt_c $opt_C $opt_e $opt_f $opt_l $opt_m $opt_t $opt_1 $opt_x $opt_X $opt_S);
getopts( 'LPb:cCe:f:l:mt:1xX:S' );

## ----------------------------------------------------------------------
## import packages
use DebianDoc_SGML::Format::Alias;
if ( length( $opt_X ) )
{
# if "-X dir" is defined, use dir as the Locale format data source.
    require "$opt_X/Alias.pm";
    DebianDoc_SGML::Locale::Alias->import();
}
else
{
    use DebianDoc_SGML::Locale::Alias;
}
use Getopt::Std;
use POSIX qw( locale_h );
use SGMLS::Output;

## ----------------------------------------------------------------------
## get format, map and locale
use vars qw( $format $Format $Map );
use vars qw( $locale $Locale %locale );
{
    $format = $opt_f;
    if ( ! length( $format ) )
    {
	die "Error: format not specified\n";
    }
    elsif ( ! defined( $format_aliases{$format} ) )
    {
	die "Error: format $format not supported\n";
    }
    my $format_alias = $format_aliases{$format};
    $locale = $opt_l;
    if ( ! defined( $locale_aliases{$locale} ) )
    {
	my $dflt_locale = 'en';
	warn "Warning: locale '$locale' not supported, using $dflt_locale\n"
	    if length( $locale );
	$locale = $dflt_locale;
    }
    my $locale_alias = $locale_aliases{$locale};
    $Locale = "DebianDoc_SGML/Locale/$locale_alias/$format_alias";
    if ( length( $opt_X ) )
    {
    # if "-X dir" is defined, use dir as the Locale format data source.
    	require "$opt_X/$locale_alias/$format_alias";
    }
    else
    {
    	require $Locale;
    }
    $Locale =~ s|/|::|g;
    $Map = "DebianDoc_SGML/Map/$format_alias";
    require "$Map.pm";
    $Map =~ s|/|::|g;
    $Format = "DebianDoc_SGML/Format/$format_alias";
    require "$Format.pm";
    $Format =~ s|/|::|g;
}

## ----------------------------------------------------------------------
## tag processing
## ----------------------------------------------------------------------

## ----------------------------------------------------------------------
use vars qw( @element $element $event %unknown_warn_done );
use vars qw( @p_length );
use vars qw( $in_author $in_translator );
use vars qw( $heading_level $toc_detail );
use vars qw( @indent_level $indent_level );
use vars qw( @list_type $list_type );
use vars qw( @tags @tag );
use vars qw( @prev_enum_type @enum_type $enum_type );
use vars qw( @prev_item_counter @item_counter $item_counter );
use vars qw( $ftpsite $ftppath $httpsite $httppath );
use vars qw( $will_be_compact );
use vars qw( @is_compact $is_compact );
use vars qw( @was_compact $was_compact );
use vars qw( $is_example $is_special );
use vars qw( $is_argument );
use vars qw( @is_footnote $is_footnote );
use vars qw( @in_footnote $in_footnote );

## ----------------------------------------------------------------------
sub start
{
}
sub end
{
}

## ----------------------------------------------------------------------
sub start_element
{
    ( $element, $event ) = @_;
    my $name = $element->name;
    my $file = $event->file;
    my $line = $event->line;
    warn "unknown start element $name at $file:$line\n"
	unless $unknown_warn_done{$name}++;
}
sub end_element
{
    ( $element, $event ) = @_;
    my $name = $element->name;
    my $file = $event->file;
    my $line = $event->line;
    warn "unknown end element $name at $file:$line\n"
	unless $unknown_warn_done{ $name }++;
}

## ----------------------------------------------------------------------
sub start_debiandoc
{
}
sub end_debiandoc
{
}

## ----------------------------------------------------------------------
sub start_book
{
    &{$Format."::"._output_start_book}();
}
sub end_book
{
    &{$Format."::"._output_end_book}();
}

## ----------------------------------------------------------------------
sub start_titlepag
{
}
sub end_titlepag
{
    &{$Format."::"._output_titlepag}();
    $heading_level = 0;
}

## ----------------------------------------------------------------------
sub start_title
{
    push_output( 'string' );
}
sub end_title
{
    &{$Format."::"._output_title}( _normalize( pop_output ) );
}

## ----------------------------------------------------------------------
sub start_author
{
    $in_author = 1;
    push_output( 'string' );
}
sub end_author
{
    &{$Format."::"._output_author}( pop_output );
    $in_author = 0;
}

## ----------------------------------------------------------------------
sub start_translator
{
    $in_translator = 1;
    push_output( 'string' );
}
sub end_translator
{
    &{$Format."::"._output_translator}( pop_output );
    $in_translator = 0;
}

## ----------------------------------------------------------------------
sub start_name
{
    push_output( 'string' );
}
sub end_name
{
    &{$Format."::"._output_name}( _normalize( pop_output ) );
}

## ----------------------------------------------------------------------
sub start_version
{
    push_output( 'string' );
}
sub end_version
{
    &{$Format."::"._output_version}( _normalize( pop_output . '' ) );
}

## ----------------------------------------------------------------------
sub start_date
{
    if(exists $ENV{DEBIANDOC_DATE} && defined $ENV{DEBIANDOC_DATE}) {
        $_ = $ENV{DEBIANDOC_DATE};
        &{$Format."::"._cdata}( $_ );
    } else {
        @_ = gmtime();
        my $current_locale = setlocale( LC_TIME );
        setlocale( LC_TIME, $locale );
        $_ = POSIX::strftime( "%d %B %Y", 0, 0, 0, $_[3], $_[4], $_[5] );
        setlocale( LC_TIME, $current_locale );
        s/^0//;
        &{$Format."::"._cdata}( $_ );
    }
}
sub end_date
{
}

## ----------------------------------------------------------------------
sub start_abstract
{
    push_output( 'string' ); 
}
sub end_abstract
{
    &{$Format."::"._output_abstract}( pop_output );
}

## ----------------------------------------------------------------------
sub start_copyright
{
    push_output( 'string' );
}
sub end_copyright
{
    &{$Format."::"._output_copyright}( pop_output );
}

## ----------------------------------------------------------------------
sub start_copyrightsummary
{
    push_output( 'string' );
}
sub end_copyrightsummary
{
    &{$Format."::"._output_copyrightsummary}( _normalize( pop_output ) );
}

## ----------------------------------------------------------------------
sub start_toc
{
    ( $element, $event ) = @_;
    $toc_detail = _num_level( _a( 'DETAIL' ) );
    push_output( 'string' );
}
sub end_toc
{
    &{$Format."::"._output_toc}( pop_output );
}

## ----------------------------------------------------------------------
sub start_tocentry
{
    ( $element, $event ) = @_;
    push( @element, $element );
    push_output( 'string' );
}
sub end_tocentry
{
    $element = pop( @element );
    &{$Format."::"._output_tocentry}( _normalize( pop_output ),
				      _num_level( _a( 'LEVEL' ) ),
				      _a( 'CHAPT' ) . _a( 'SECT' ),
				      _a( 'SRID' ) );
}

## ----------------------------------------------------------------------
sub start_chapt
{
    ( $element, $event ) = @_;
    $heading_level = -1;
    push_output( 'string' );
}
sub end_chapt
{
    &{$Format."::"._output_chapter}( pop_output );
    undef $ftpsite;
    undef $httpsite;
}

## ----------------------------------------------------------------------
sub start_appendix
{
    ( $element, $event ) = @_;
    $heading_level = -2;
    push_output( 'string' );
}
sub end_appendix
{
    &{$Format."::"._output_appendix}( pop_output );
    undef $ftpsite;
    undef $httpsite;
}

## ----------------------------------------------------------------------
sub start_sect
{
    ( $element, $event ) = @_;
    $heading_level = 0;
}
sub end_sect
{
    &{$Format."::"._output_sect}();
}

## ----------------------------------------------------------------------
sub start_sect1
{
    ( $element, $event ) = @_;
    $heading_level = 1;
}
sub end_sect1
{
    &{$Format."::"._output_sect1}();
}

## ----------------------------------------------------------------------
sub start_sect2
{
    ( $element, $event ) = @_;
    $heading_level = 2;
}
sub end_sect2
{
    &{$Format."::"._output_sect2}();
}

## ----------------------------------------------------------------------
sub start_sect3
{
    ( $element, $event ) = @_;
    $heading_level = 3;
}
sub end_sect3
{
    &{$Format."::"._output_sect3}();
}

## ----------------------------------------------------------------------
sub start_sect4
{
    ( $element, $event ) = @_;
    $heading_level = 4;
}
sub end_sect4
{
    &{$Format."::"._output_sect4}();
}

## ----------------------------------------------------------------------
sub start_heading
{
    ( $element, $event ) = @_;
    push( @element, $element );
    push_output( 'string' );
}
sub end_heading
{
    $element = pop( @element );
    $indent_level = 1 if $indent_level;
    &{$Format."::"._output_heading}( _normalize( pop_output ), $heading_level,
				     _a( 'CHAPT' ) . _a( 'SECT' ),
				     _a( 'SRID' ) );
}

## ----------------------------------------------------------------------
sub start_p
{
    push_output( 'string' );
}
sub end_p
{
    &{$Format."::"._output_p}( _trim( pop_output ) );
    $was_compact = 0 if ( ! $is_compact && $was_compact );
}

## ----------------------------------------------------------------------
sub start_example
{
    ( $element, $event ) = @_;
    $is_example = 1;
    $is_special = 1;
    $will_be_compact = $element-> attribute( 'COMPACT' )->type eq 'TOKEN';
    my $paragraph = pop_output;
    $paragraph =~ s/^\s+//;
    $paragraph =~ s/\s+$//;
    &{$Format."::"._output_p}( $paragraph );
    push( @p_length, length( $paragraph ) );
    push( @is_compact, $is_compact );
    $is_compact = $is_compact || $will_be_compact;
    push_output( 'string' );
}
sub end_example
{
    my $example = pop_output;
    $example =~ s/\s+$//;
    &{$Format."::"._output_example}( "$example\n", pop( @p_length ) );
    $was_compact = $is_compact;
    $is_compact = pop( @is_compact );
    $is_special = 0;
    $is_example = 0;
    push_output( 'string' );
}

## ----------------------------------------------------------------------
sub start_include
{
    ( $element, $event ) = @_;
    $is_example = 1;
    $is_special = 1;
    $will_be_compact = $element-> attribute( 'COMPACT' )->type eq 'TOKEN';
    my $paragraph = pop_output;
    $paragraph =~ s/^\s+//;
    $paragraph =~ s/\s+$//;
    &{$Format."::"._output_p}( $paragraph );
    push( @p_length, length( $paragraph ) );
    push( @is_compact, $is_compact );
    $is_compact = $is_compact || $will_be_compact;
    my $source = _a( 'SOURCE' );
    if ( -r $source )
    {
	push_output( 'string' );
	open SOURCE, $source;
	while ( <SOURCE> )
	{
	    output( $_ );
	}
	close SOURCE;
	my $example = pop_output;
	$example =~ s/\s+$//;
	&{$Format."::"._output_example}( "$example\n", pop( @p_length ) );
    }
    else
    {
	warn "Warning: include file $source not found\n";
    }
    $was_compact = $is_compact;
    $is_compact = pop( @is_compact );
    $is_special = 0;
    $is_example = 0;
    push_output( 'string' );
}
sub end_include
{
}

## ----------------------------------------------------------------------
sub start_footnote
{
    push( @is_compact, $is_compact );
    $is_compact = 0;
    push( @was_compact, $was_compact );
    $was_compact = 0;
    push( @is_footnote, $is_footnote );
    $is_footnote = 1;
    push( @in_footnote, $in_footnote );
    $in_footnote = 1;
    push_output( 'string' );
}
sub end_footnote
{
    $_ = _trim( pop_output );
    &{$Format."::"._output_footnote}( "$_\n" ) if length( $_ );
    $in_footnote = pop( @in_footnote );
    $is_footnote = pop( @is_footnote );
    $is_compact = pop( @is_compact );
    $was_compact = pop( @was_compact );
}

## ----------------------------------------------------------------------
sub start_comment
{
    ( $element, $event ) = @_;
    push( @is_compact, $is_compact );
    $is_compact = 0;
    push( @was_compact, $was_compact );
    $was_compact = 0;
    push( @is_footnote, $is_footnote );
    $is_footnote = 1;
    push( @in_footnote, $in_footnote );
    $in_footnote = 1;
    push( @element, $element );
    push_output( 'string' );
}
sub end_comment
{
    $_ = _trim( pop_output );
    $element = pop( @element );
    &{$Format."::"._output_comment}( "$_\n", _a( 'EDITOR' ) )
	if length( $_ ) && $DebianDoc_SGML::Format::Driver::opt_m;
    $in_footnote = pop( @in_footnote );
    $is_footnote = pop( @is_footnote );
    $is_compact = pop( @is_compact );
    $was_compact = pop( @was_compact );
}

## ----------------------------------------------------------------------
sub start_list
{
    ( $element, $event ) = @_;
    $is_special = 1;
    $will_be_compact = $element-> attribute( 'COMPACT' )->type eq 'TOKEN';
    my $paragraph = pop_output;
    $paragraph =~ s/^\s+//;
    $paragraph =~ s/\s+$//;
    &{$Format."::"._output_p}( $paragraph );
    push( @p_length, length( $paragraph ) );
    push( @is_compact, $is_compact );
    $is_compact = $is_compact || $will_be_compact;
    push( @is_footnote, $is_footnote );
    $is_footnote = 0;
    push( @list_type, $list_type );
    $list_type = "list";
    push( @tags, @tag );
    @tag = ();
    $indent_level++ if $indent_level;
    push_output( 'string' );
}
sub end_list
{
    my $list = pop_output;
    $list =~ s/\s+$//;
    &{$Format."::"._output_list}( "$list\n", pop( @p_length ) );
    $indent_level-- if $indent_level > 1;
    @tag = pop( @tags );
    $is_footnote = pop( @is_footnote );
    $list_type = pop( @list_type );
    $was_compact = $is_compact;
    $is_compact = pop( @is_compact );
    $is_special = 0;
    push_output( 'string' );
}

## ----------------------------------------------------------------------
sub start_enumlist
{
    ( $element, $event ) = @_;
    $is_special = 1;
    $will_be_compact = $element-> attribute( 'COMPACT' )->type eq 'TOKEN';
    my $continue = $element-> attribute( 'CONTINUE' )->type eq 'TOKEN';
    push( @enum_type, $enum_type );
    if ( $continue )
    {
	$enum_type = pop( @prev_enum_type );
	$enum_type = _a( 'NUMERATION' ) if $enum_type eq '';
    }
    else
    {
	$enum_type = _a( 'NUMERATION' );
    }
    my $paragraph = pop_output;
    $paragraph =~ s/^\s+//;
    $paragraph =~ s/\s+$//;
    &{$Format."::"._output_p}( $paragraph );
    push( @p_length, length( $paragraph ) );
    push( @is_compact, $is_compact );
    $is_compact = $is_compact || $will_be_compact;
    push( @is_footnote, $is_footnote );
    $is_footnote = 0;
    push( @list_type, $list_type );
    $list_type = 'enumlist';
    push( @tags, @tag );
    @tag = ();
    push( @item_counter, $item_counter );
    $item_counter = pop( @prev_item_counter );
    if ( $format ne 'html' && $enum_type eq 'UPPERALPHA' )
    {
	if ( length( $item_counter) == 0 )
	{
	    $item_counter = 'A';
	}
	else
	{
	    $item_counter = $continue ? $item_counter : 'A';
	}
    }
    elsif ( $format ne 'html' && $enum_type eq 'LOWERALPHA' )
    {
	if ( length( $item_counter) == 0 )
	{
	    $item_counter = 'a';
	}
	else
	{
	    $item_counter = $continue ? $item_counter : 'a';
	}
    }
    else
    {
	if ( length( $item_counter) == 0 )
	{
	    $item_counter = 1;
	}
	else
	{
	    $item_counter = $continue ? $item_counter : 1;
	}
    }
    push( @item_counter, $item_counter );
    $indent_level++ if $indent_level;
    push_output( 'string' );
}
sub end_enumlist
{
    my $enumlist = pop_output;
    $enumlist =~ s/\s+$//;
    push( @prev_enum_type, $enum_type );
    push( @prev_item_counter, $item_counter );
    $item_counter = pop( @item_counter );
    &{$Format."::"._output_enumlist}( "$enumlist\n",
				      pop( @p_length ),
				      $enum_type );
    $indent_level-- if $indent_level > 1;
    $enum_type = pop( @enum_type );
    $item_counter = pop( @item_counter );
    @tag = pop( @tags );
    $is_footnote = pop( @is_footnote );
    $list_type = pop( @list_type );
    $was_compact = $is_compact;
    $is_compact = pop( @is_compact );
    $is_special = 0;
    push_output( 'string' );
}

## ----------------------------------------------------------------------
sub start_taglist
{
    ( $element, $event ) = @_;
    $is_special = 1;
    $will_be_compact = $element-> attribute( 'COMPACT' )->type eq 'TOKEN';
    my $paragraph = pop_output;
    $paragraph =~ s/^\s+//;
    $paragraph =~ s/\s+$//;
    &{$Format."::"._output_p}( $paragraph );
    push( @p_length, length( $paragraph ) );
    push( @is_compact, $is_compact );
    $is_compact = $is_compact || $will_be_compact;
    push( @is_footnote, $is_footnote );
    $is_footnote = 0;
    push( @list_type, $list_type );
    $list_type = "taglist";
    push( @tags, [ @tag ] );
    @tag = ();
    $indent_level++ if $indent_level;
    push_output( 'string' );
}
sub end_taglist
{
    my $taglist = pop_output;
    $taglist =~ s/\s+$//;
    &{$Format."::"._output_taglist}( "$taglist\n", pop( @p_length ) );
    $indent_level-- if $indent_level > 1;
    @tag = @{ pop( @tags ) };
    $is_footnote = pop( @is_footnote );
    $list_type = pop( @list_type );
    $was_compact = $is_compact;
    $is_compact = pop( @is_compact );
    $is_special = 0;
    push_output( 'string' );
}

## ----------------------------------------------------------------------
sub start_tag
{
    push_output( 'string' );
}
sub end_tag
{
    if ( $list_type eq 'taglist' )
    {
	push( @tag, _normalize( pop_output ) );
    }
    else
    {
	my $_output_tag = "_output_" . $list_type . "_tag";
	&{$Format."::".$_output_tag}( _normalize( pop_output ), $enum_type );
    }
}

## ----------------------------------------------------------------------
sub start_item
{
    push_output( 'string' );
}
sub end_item
{
    $_ = pop_output;
    my $_output_item = "_output_" . $list_type . "_item";
    &{$Format."::".$_output_item}( $_, \@tag, $enum_type ) if length( $_ );
    $item_counter++ if $list_type eq 'enumlist';
    @tag = ();
}

## ----------------------------------------------------------------------
sub start_em
{
    push_output( 'string' );
}
sub end_em
{
    $_ = _trim( pop_output );
    &{$Format."::"._output_em}( $_ ) if length( $_ );
}

## ----------------------------------------------------------------------
sub start_strong
{
    push_output( 'string' );
}
sub end_strong
{
    $_ = _trim( pop_output );
    &{$Format."::"._output_strong}( $_ ) if length( $_ );
}

## ----------------------------------------------------------------------
sub start_var
{
    push_output( 'string' );
}
sub end_var
{
    $_ = _trim( pop_output );
    &{$Format."::"._output_var}( $_ ) if length( $_ );
}

## ----------------------------------------------------------------------
sub start_package
{
    $is_example = 1;
    push_output( 'string' );
}
sub end_package
{
    $_ = _trim( pop_output );
    &{$Format."::"._output_package}( $_ ) if length( $_ );
    $is_example = 0;
}

## ----------------------------------------------------------------------
sub start_prgn
{
    $is_example = 1;
    push_output( 'string' );
}
sub end_prgn
{
    $_ = _trim( pop_output );
    &{$Format."::"._output_prgn}( $_ ) if length( $_ );
    $is_example = 0;
}

## ----------------------------------------------------------------------
sub start_file
{
    $is_example = 1;
    push_output( 'string' );
}
sub end_file
{
    $_ = _trim( pop_output );
    &{$Format."::"._output_file}( $_ ) if length( $_ );
    $is_example = 0;
}

## ----------------------------------------------------------------------
sub start_tt
{
    $is_example = 1;
    push_output( 'string' );
}
sub end_tt
{
    $_ = _trim( pop_output );
    &{$Format."::"._output_tt}( $_ ) if length( $_ );
    $is_example = 0;
}

## ----------------------------------------------------------------------
sub start_qref
{
    ( $element, $event ) = @_;
    push( @element, $element );
    push_output( 'string' );
}
sub end_qref
{
    $_ = _trim( pop_output );
    $element = pop( @element );
    &{$Format."::"._output_qref}( $_, _a('CSRID'), _a('SRID') )
	if length( $_ );
}

## ----------------------------------------------------------------------
sub start_ref
{
    ( $element, $event ) = @_;
    push( @element, $element );
    push_output( 'string' );
}
sub end_ref
{
    $_ = _trim( pop_output );
    $element = pop( @element );
    &{$Format."::"._output_ref}( $_, _a('HNAME'), _a('CSRID'), _a('SRID') )
	if length( $_ );
}

## ----------------------------------------------------------------------
sub start_manref
{
    ( $element, $event ) = @_;
    &{$Format."::"._output_manref}( _trim( _a( 'NAME' ) ),
				    _trim( _a( 'SECTION' ) ) );
}
sub end_manref
{
}

## ----------------------------------------------------------------------
sub start_email
{
    $is_argument = 1;
    push_output( 'string' );
}
sub end_email
{
    $_ = _trim( pop_output );
    &{$Format."::"._output_email}( $_ ) if length( $_ );
    $is_argument = 0;
}

## ----------------------------------------------------------------------
sub start_ftpsite
{
    $is_argument = 1;
    push_output( 'string' );
}
sub end_ftpsite
{
    $ftpsite = _normalize( pop_output );
    &{$Format."::"._output_ftpsite}( $ftpsite ) if length( $ftpsite );
    $is_argument = 0;
}

## ----------------------------------------------------------------------
sub start_ftppath
{
    $is_argument = 1;
    push_output( 'string' );
}
sub end_ftppath
{
    $_ = _normalize( pop_output );
    defined( $ftpsite ) ||
        print( STDERR
	       "Warning: FTPPATH \`$_' without preceding FTPSITE\n" );
    &{$Format."::"._output_ftppath}( $ftpsite, $_ ) if length( $_ );
    $is_argument = 0;
}

## ----------------------------------------------------------------------
sub start_httpsite
{
    $is_argument = 1;
    push_output( 'string' );
}
sub end_httpsite
{
    $httpsite = _normalize( pop_output );
    &{$Format."::"._output_httpsite}( $httpsite ) if length( $httpsite );
    $is_argument = 0;
}

## ----------------------------------------------------------------------
sub start_httppath
{
    $is_argument = 1;
    push_output( 'string' );
}
sub end_httppath
{
    $_ = _normalize( pop_output );
    defined( $httpsite ) ||
        print( STDERR
	       "Warning: HTTPPATH \`$_' without preceding HTTPSITE\n" );
    &{$Format."::"._output_httppath}( $httpsite, $_ ) if length( $_ );
    $is_argument = 0;
}

## ----------------------------------------------------------------------
sub start_url
{
    ( $element, $event ) = @_;
    my $id = _trim( _a( 'ID' ) );
    my $name =  _a( 'NAME' );
    $name = "" if ( $name eq '\|\|' ) || ( $name eq '\|urlname\|' )
	|| ( $name eq $id );
    &{$Format."::"._output_url}( $id, $name ) if length( $id );
}
sub end_url
{
}

## ----------------------------------------------------------------------
sub cdata
{
    &{$Format."::"._cdata};
}
sub sdata
{
    &{$Format."::"._sdata};
}

## ----------------------------------------------------------------------
## helper definitions
## ----------------------------------------------------------------------

## ----------------------------------------------------------------------
sub _num_level
{
    return -1 if $_[0] =~ m/^CHAPT|APPENDIX/;
    return $1+0 if $_[0] =~ m/^SECT(\d*)$/;
    warn "unknown toc detail token \`$_[0]'\n";
}

## ----------------------------------------------------------------------
sub _a
{
    my $el = $element->attribute( $_[0] );
    return defined( $el ) ? $el->value : undef;
}

## ----------------------------------------------------------------------
sub _trim
{
    ( $_ ) = @_;
    s/^\s+//;
    s/\s+$//;
    return $_;
}
sub _normalize
{
    ( $_ ) = @_;
    s/^\s+//;
    s/\s+$//;
    s/\s+/ /g;
    return $_;
}

## ----------------------------------------------------------------------
## SGML definitions
## ----------------------------------------------------------------------

## ----------------------------------------------------------------------
::sgml( 'start', \&start );
::sgml( 'end', \&end );

## ----------------------------------------------------------------------
::sgml( 'start_element', \&start_element );
::sgml( 'end_element', \&end_element );

## ----------------------------------------------------------------------
::sgml( '<DEBIANDOC>', \&start_debiandoc );
::sgml( '</DEBIANDOC>', \&end_debiandoc );

## ----------------------------------------------------------------------
::sgml( '<BOOK>', \&start_book );
::sgml( '</BOOK>', \&end_book );

## ----------------------------------------------------------------------
::sgml( '<TITLEPAG>', \&start_titlepag );
::sgml( '</TITLEPAG>', \&end_titlepag );

## ----------------------------------------------------------------------
::sgml( '<TITLE>', \&start_title );
::sgml( '</TITLE>', \&end_title );

## ----------------------------------------------------------------------
::sgml( '<AUTHOR>', \&start_author );
::sgml( '</AUTHOR>', \&end_author );

## ----------------------------------------------------------------------
::sgml( '<TRANSLATOR>', \&start_translator );
::sgml( '</TRANSLATOR>', \&end_translator );

## ----------------------------------------------------------------------
::sgml( '<NAME>', \&start_name );
::sgml( '</NAME>', \&end_name );

## ----------------------------------------------------------------------
::sgml( '<VERSION>', \&start_version );
::sgml( '</VERSION>', \&end_version );

## ----------------------------------------------------------------------
::sgml( '<DATE>', \&start_date );
::sgml( '</DATE>', \&end_date );

## ----------------------------------------------------------------------
::sgml( '<ABSTRACT>', \&start_abstract );
::sgml( '</ABSTRACT>', \&end_abstract );

## ----------------------------------------------------------------------
::sgml( '<COPYRIGHT>', \&start_copyright );
::sgml( '</COPYRIGHT>', \&end_copyright );

## ----------------------------------------------------------------------
::sgml( '<COPYRIGHTSUMMARY>', \&start_copyrightsummary );
::sgml( '</COPYRIGHTSUMMARY>', \&end_copyrightsummary );

## ----------------------------------------------------------------------
::sgml( '<TOC>', \&start_toc );
::sgml( '</TOC>', \&end_toc );

## ----------------------------------------------------------------------
::sgml( '<TOCENTRY>', \&start_tocentry );
::sgml( '</TOCENTRY>', \&end_tocentry );

## ----------------------------------------------------------------------
::sgml( '<CHAPT>', \&start_chapt );
::sgml( '</CHAPT>', \&end_chapt );

## ----------------------------------------------------------------------
::sgml( '<APPENDIX>', \&start_appendix );
::sgml( '</APPENDIX>', \&end_appendix );

## ----------------------------------------------------------------------
::sgml( '<SECT>', \&start_sect );
::sgml( '</SECT>', \&end_sect );

## ----------------------------------------------------------------------
::sgml( '<SECT1>', \&start_sect1 );
::sgml( '</SECT1>', \&end_sect1 );

## ----------------------------------------------------------------------
::sgml( '<SECT2>', \&start_sect2 );
::sgml( '</SECT2>', \&end_sect2 );

## ----------------------------------------------------------------------
::sgml( '<SECT3>', \&start_sect3 );
::sgml( '</SECT3>', \&end_sect3 );

## ----------------------------------------------------------------------
::sgml( '<SECT4>', \&start_sect4 );
::sgml( '</SECT4>', \&end_sect4 );

## ----------------------------------------------------------------------
::sgml( '<HEADING>', \&start_heading );
::sgml( '</HEADING>', \&end_heading );

## ----------------------------------------------------------------------
::sgml( '<P>' , \&start_p );
::sgml( '</P>', \&end_p );

## ----------------------------------------------------------------------
::sgml( '<EXAMPLE>', \&start_example );
::sgml( '</EXAMPLE>', \&end_example );

## ----------------------------------------------------------------------
::sgml( '<INCLUDE>', \&start_include );
::sgml( '</INCLUDE>', \&end_include );

## ----------------------------------------------------------------------
::sgml( '<FOOTNOTE>', \&start_footnote );
::sgml( '</FOOTNOTE>', \&end_footnote );

## ----------------------------------------------------------------------
::sgml( '<COMMENT>', \&start_comment );
::sgml( '</COMMENT>', \&end_comment );

## ----------------------------------------------------------------------
::sgml( '<LIST>', \&start_list );
::sgml( '</LIST>', \&end_list );

## ----------------------------------------------------------------------
::sgml( '<ENUMLIST>', \&start_enumlist );
::sgml( '</ENUMLIST>', \&end_enumlist );

## ----------------------------------------------------------------------
::sgml( '<TAGLIST>', \&start_taglist );
::sgml( '</TAGLIST>', \&end_taglist );

## ----------------------------------------------------------------------
::sgml( '<TAG>', \&start_tag );
::sgml( '</TAG>', \&end_tag );

## ----------------------------------------------------------------------
::sgml( '<ITEM>', \&start_item );
::sgml( '</ITEM>', \&end_item );

## ----------------------------------------------------------------------
::sgml( '<EM>',\&start_em );
::sgml( '</EM>', \&end_em );

## ----------------------------------------------------------------------
::sgml( '<STRONG>', \&start_strong );
::sgml( '</STRONG>', \&end_strong );

## ----------------------------------------------------------------------
::sgml( '<VAR>', \&start_var );
::sgml( '</VAR>', \&end_var );

## ----------------------------------------------------------------------
::sgml( '<PACKAGE>', \&start_package );
::sgml( '</PACKAGE>', \&end_package );

## ----------------------------------------------------------------------
::sgml( '<PRGN>', \&start_prgn );
::sgml( '</PRGN>', \&end_prgn );

## ----------------------------------------------------------------------
::sgml( '<FILE>', \&start_file );
::sgml( '</FILE>', \&end_file );

## ----------------------------------------------------------------------
::sgml( '<TT>', \&start_tt );
::sgml( '</TT>', \&end_tt );

## ----------------------------------------------------------------------
::sgml( '<QREF>', \&start_qref );
::sgml( '</QREF>', \&end_qref );

## ----------------------------------------------------------------------
::sgml( '<REF>', \&start_ref );
::sgml( '</REF>', \&end_ref );

## ----------------------------------------------------------------------
::sgml( '<MANREF>', \&start_manref );
::sgml( '</MANREF>', \&end_manref );

## ----------------------------------------------------------------------
::sgml( '<EMAIL>', \&start_email );
::sgml( '</EMAIL>', \&end_email );

## ----------------------------------------------------------------------
::sgml( '<FTPSITE>', \&start_ftpsite );
::sgml( '</FTPSITE>', \&end_ftpsite );

## ----------------------------------------------------------------------
::sgml( '<FTPPATH>', \&start_ftppath );
::sgml( '</FTPPATH>', \&end_ftppath );

## ----------------------------------------------------------------------
::sgml( '<HTTPSITE>', \&start_httpsite );
::sgml( '</HTTPSITE>', \&end_httpsite );

## ----------------------------------------------------------------------
::sgml( '<HTTPPATH>', \&start_httppath );
::sgml( '</HTTPPATH>', \&end_httppath );

## ----------------------------------------------------------------------
::sgml( '<URL>', \&start_url );
::sgml( '</URL>', \&end_url );

## ----------------------------------------------------------------------
::sgml( 'cdata', \&cdata );
::sgml( 'sdata', \&sdata );

## ----------------------------------------------------------------------
## don't forget this
1;

## ----------------------------------------------------------------------
