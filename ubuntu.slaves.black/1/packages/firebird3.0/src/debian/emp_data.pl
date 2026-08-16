#!/usr/bin/perl

# Copyright (C) 2017 Damyan Ivanov <dmn@debian.org>
# Permission is granted to use this work, with or without modifications,
# provided that this notice is retained. If we meet some day, and you think
# this stuff is worth it, you can buy me a beer in return.

# transform blob data into SQL statements

use strict;
use warnings;
use utf8;

use Getopt::Long;

my ( $opt_table, $opt_keys, $opt_blob_col );

GetOptions(
    'table=s'   => \$opt_table,
    'key=s'     => \$opt_keys,
    'blob-col=s' => \$opt_blob_col,
) or exit 1;

my @key_cols = split( /,/, $opt_keys );

my $state = 'await-ids';

my ( @keys, @data );
while( defined(my $line = <>) ) {
    chomp($line);
    $line =~ s/\r$//;

    if ( $state eq 'await-ids' ) {
        $line =~ s/^\s+//;
        @keys = split(/\s+/, $line);
        $state = 'collect-data';
        next;
    }

    if ( $state eq 'collect-data' ) {
        if ($line eq '' ) {
            my @where;
            for my $i (0..$#key_cols) {
                push @where, "$key_cols[$i] = '$keys[$i]'";
            }
            s/'/''/g for @data;
            printf "UPDATE %s\nSET %s = '%s'\nWHERE %s;\n\n", $opt_table,
                $opt_blob_col, join( "\n", @data ), join( "\n  AND ", @where );

            $state = 'await-ids';
            undef(@keys);
            undef(@data);
            next;
        }

        push @data, $line;
        next;
    }

    die "Unexpected state '$state'";
}
