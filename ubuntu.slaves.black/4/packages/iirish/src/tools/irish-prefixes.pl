#!/usr/bin/perl

# Preprocessor for ispell capitalization

# (C) Alastair McKinstry, 1997 <alastair@ilo.dec.com>
# 
# $Id: irish-prefixes.pl,v 1.1.1.1 2000/03/06 19:36:19 alastairmck Exp $


# Irish has an interesting capitalisation rule: eclipsis does not change the capitalisation
# of a noun. This causes problems with ispells assumptions of English-like capitalisation.
# e.g.
# 
# So this perl script acts as a preprocessor, converting
#    Eireann/n
# to two entries,
#    Eireann
#    hEireann
# It strips out the eclipsing flag, leaving the rest intact.

# Eclipsis rules in Irish
&flag_adds_prefix('E','[Pp]','b'); # p -> bp
&flag_adds_prefix('E','[Tt]','d'); # t -> dt
&flag_adds_prefix('E','[Cc]','g');
&flag_adds_prefix('E','[Ff]','bh');
&flag_adds_prefix('E','[DdGg]','n');
&flag_adds_prefix('E','[Bb]','m');
&flag_adds_prefix('T','aeiou·ÈÌÛ˙','t-'); # hypen before vowel, eg. an t-ar'an
&flag_adds_prefix('T','[AEIOU¡…Õ”⁄]','t');  #  but not when capitalized, eg. an tEarrach
&flag_adds_prefix('T','[sS]','t');	     # eg. an tsagart 
&flag_adds_prefix('H','[AEIOU¡…Õ”⁄aeiou·ÈÌÛ˙]','h');

while (<>) {
    chop( $line = $_);
    &process_line($line);
}


exit 0;

sub flag_adds_prefix {
    # Adds a new prefix to the list that this flag adds.
    
    local($flag,$prepend,$prefix) = @_;
    $flags{$flag} .= $prepend . ' ';
    $prefixes{$flag,$prepend} = $prefix;
}



sub process_line {
    # Process a line, looking for flags.
    local($line)=@_;    
    local($word,$flags) = split(/\//,$line);

    if ($flags eq "") {
	print "$word\n";
	return;
    }
    &process_flags($word,"",$flags);
}

sub print_line {
    local($word,$flags) = @_;

    if ($flags eq "") {
	print "$word\n";
    } else {	
	print "$word/$flags\n";
    }
}

sub process_flags {
    local($word,$flags_done,$flags_left) = @_;

    if ($flags_left eq "") {
	&print_line($word,$flags_done);
	return;
    }
    foreach $flag (keys %flags) {
	if ($flags_left =~ /.*$flag.*/) {
	    &process_flag($word,$flag, &remove_flag($flag,$flags_done),&remove_flag($flag,$flags_left));
	}
    }   
}


sub process_flag {
    local($word,$flag,$flags_done,$other_flags)=@_;

    local(@prepends)    = split(/ /,$flags{$flag});
    $other_flags = &prevent_both($flag,$other_flags);
    while (@prepends) {
	$prepend = shift(@prepends);
	if ($word =~ /^$prepend.*/) {
	    &process_flags("$prefixes{$flag,$prepend}$word",$flags_done,$other_flags);
	    if (&islower($word)) {
	    	    $upperword = &toupper($word);
		    &process_flags("$prefixes{$flag,$prepend}$upperword",$flags_done,$other_flags);
		}
	    return;
	}
    }
    &process_flags($word,"$flags_done$flag",$other_flags);
}

    
sub remove_flag {
    # remove flag from a list of flags
    
    local($flag,$flags) = @_;
    local($before, $after) = split(/$flag/,$flags);
    return (join("",$before,$after));
}

sub prevent_both {
    # nasty hack to prevent Eclipsis and Aspiration at the same time
    # (i.e. Don't apply 'E' and 'H' flags simultaneously.)

    local ($flag,$other_flags) = @_;
    if ($flag eq "E") {
	$other_flags = &remove_flag("H",$other_flags);
    }
    if ($flag eq "H") {
	$other_flags = &remove_flag("E",$other_flags);
    }
    return ($other_flags);
}
    
sub toupper {
    # Takes a word, returns it with the first letter uppercase
    # (if it wasn't already)
    
    local($word)= @_;
    
    ($first,$rest) = $word =~ /(.)(.*)/;
    $first =~ tr/[a-z]·ÈÌÛ˙/[A-Z]¡…Õ”⁄]/;
    return (join("",$first,$rest));
}

sub islower {
    # Returns true if the first character is not uppercase
    # Note gratuitous hack needed to deal with non 8-bit aware regexps    

    local($word)=@_;
    ($first,$rest) = $word =~ /(.)(.*)/;
    if ($first =~ /[a-z]/) {
	return ("1");
    } else {
	if ( ($first eq "·") || ($first eq "È") || ($first eq "Ì")
	    || ($first eq "Û") || ($first eq "˙")) {
	    return ("1");
	}
	else {
	    return ("0");
	}
    }
}
