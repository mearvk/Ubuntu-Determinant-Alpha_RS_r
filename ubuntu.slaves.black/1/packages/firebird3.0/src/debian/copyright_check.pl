#!/usr/bin/perl

# This program reads debian/copyright and notes all the files/globs mentioned
# there. A check is made that there are no overlaps. Then it walks all
# directories and reports any actual files that aren't covered in
# debian/copyright. It also reports anu files/globs listed in d/copyright that
# don't match any actual files.
#
# The intention is to help you make sure that all present files are mentioned
# in debian/copyright. No checks are made to ensure that the
# licensing/copyright holder/years information is correct
use strict;
use warnings;
use autodie;
use File::Find;
use File::Spec;

my %copyright;

sub add_file {
    my $f = shift;

    if( exists( $copyright{$f} ) ) {
        warn "'$f' [$.] is already present on line ".$copyright{$f}{line}."\n";
        return;
    }

    $copyright{$f} = { line => $. };

    #warn "(adding) $f\n";
}

# collect data from debian/copyright
my $in_files = 0;   # true if we are parsing a "Files: " stanza
open(my $cpr, '<', 'debian/copyright');
while( <$cpr> ) {
    chomp;

    if ( s/^Files:\s*// ) {
        add_file($_) for( split( /\s+/ ) );
        $in_files = 1;
        next;
    }

    if ($in_files) {
        if( s/^\s+// ) {
            add_file($_) for( split( /\s+/ ) );
            next;
        }
        else {
            $in_files = 0;
        }
    }
}
close($cpr);

print "total ".scalar( keys %copyright )." files found in debian/copyright\n";

my @not_covered;

find( {
        wanted => sub {
            return if -d $_;

            s{^\./}{};

            return if m{^\.git/};

            if( exists $copyright{$_} ) {
                $copyright{$_}{matched}++;
                return;
            }

            $File::Find::dir =~ s{^(?:\./)(.*)/?$}{$1};

            if( exists $copyright{"$File::Find::dir/*"} ) {
                $copyright{"$File::Find::dir/*"}{matched}++;
                return;
            }

            if ( my ( $path, $name, $ext ) = m{(.+)/([^/]+)\.([^/.]+)$} ) {
                if ( exists( $copyright{"$path/*.$ext"} ) ) {
                    $copyright{"$path/*.$ext"}{matched}++;
                    return;
                }
            }

            if ( my ( $path, $prefix, $tail ) = m{(.+)/([^/.]+)\.([^/]+)$} ) {
                if ( exists( $copyright{"$path/$prefix.*"} ) ) {
                    $copyright{"$path/$prefix.*"}{matched}++;
                    return;
                }
            }

            my @dirs = File::Spec->splitdir($File::Find::dir);

            pop @dirs;
            while (@dirs) {
                my $d = File::Spec->catdir(@dirs);
                if ( exists( $copyright{"$d/*"} ) ) {
                    $copyright{"$d/*"}{matched}++;
                    return;
                }
                pop @dirs;
            }

            #warn "$_ not covered ($File::Find::dir)\n";
            push @not_covered, $_;
        },
        no_chdir => 1,
    },
    '.',
);

my %missing;
my $covered = 0;
while ( my( $k, $v ) = each %copyright ) {
    if ( exists $v->{matched} ) {
        $covered += $v->{matched};
    }
    else {
        $missing{$k} = 1;
    }
}

my $missing = scalar( keys(%missing) );

print "$covered files covered in debian/copyright\n";
print( ( scalar(@not_covered) || 'no' )." not covered\n" );
print " $_\n" for sort { $a cmp $b } @not_covered;
print "$missing files covered in debian/copyright but don't exist\n";
print " $_\n" for sort { $a cmp $b } keys(%missing);
