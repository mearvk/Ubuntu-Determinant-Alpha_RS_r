#!/usr/bin/perl
# Simple preprocessor to add simple prefix flags to words with vowels;
# eg.
# anam --> anam/V

while (<>) {
    chop ($line = $_);
    if (/$line =~ /[AEIOUÁÉÍÓÚaeiouáéíóú].*/) 
	print "$line/V\n";
    else
	print "$line\n";
}
