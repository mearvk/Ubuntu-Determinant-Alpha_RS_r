package Dpkg::Copyright::Scanner ;

use strict;
use warnings;

use 5.20.0;
use Exporter::Lite;
use Array::IntSpan;
use Path::Tiny;
use Time::localtime;
use Carp;
use TOML::Tiny qw/from_toml/;
use YAML::XS qw/LoadFile/;
use JSON;

$YAML::XS::LoadBlessed = 0;

use feature qw/postderef signatures/;
no warnings qw/experimental::postderef experimental::signatures/;

binmode STDOUT, ':encoding(utf8)';

our @EXPORT_OK = qw(scan_files print_copyright
                    __create_tree_leaf_from_paths
                    __from_copyright_structure __pack_files
                    __pack_copyright __squash_tree_of_copyright_ids
                    __to_copyright_structure);

my $whitespace_list_delimiter = $ENV{'whitespace_list_delimiter'} || "\n ";

# license and copyright sanitisation pilfered from Jonas's
# licensecheck2dep5 Originally GPL-2+, permission to license this
# derivative work to LGPL-2.1+ was given by Jonas.
# see https://lists.alioth.debian.org/pipermail/pkg-perl-maintainers/2015-March/084900.html

# Copyright 2014-2020 Dominique Dumont <dod@debian.org>
# Copyright © 2005-2012 Jonas Smedegaard <dr@jones.dk>
# Description: Reformat licencecheck output to copyright file format
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2, or (at
# your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

sub print_copyright ( %args ) {
    my ($files, $copyrights_by_id) = scan_files(%args);

    # split file path and fill recursive hash, leaf is id
    my $split_files = {};
    foreach my $path (sort keys %$files) {
        __create_tree_leaf_from_paths ($split_files,$path,$files->{$path});
    }

    # regroup %files hash: all leaves have same id -> wild card
    if (!exists $args{long} || $args{long} != 1) {
        __squash_tree_of_copyright_ids($split_files, $copyrights_by_id);
    }

    # pack files by copyright id
    my @packed = __pack_files($split_files);

    my @out ;

    foreach my $p (@packed) {
        my ($id, @paths) = $p->@*;
        my ($c,$l) = __from_copyright_structure($copyrights_by_id->[$id]);

        next if $id == 0;

        # don't print directory info covered by same info in directory above
        next if $paths[0] =~ /\.$/;

        $c = "UNKNOWN" unless $c;
        push @out,
            "Files: ", join($whitespace_list_delimiter, @paths )."\n",
            "Copyright: $c\n",
            "License: $l\n", "\n";
    }

    if ($args{out}) {
        $args{out}->spew_utf8( @out);
    }
    else {
        binmode(STDOUT, ":encoding(UTF-8)");
        print @out;
    }
    return;
}

my $quiet;

sub _warn ($msg) {
    warn $msg unless $quiet;
    return;
}

my %default ;
# from licensecheck.pl
$default{ignore}= << 'EOR';
# Ignore general backup files
~$|
# Ignore emacs recovery files
(^|/)\.#|
# Ignore vi swap files
\.swp$|
# Ignore baz-style junk files or directories
(^|/),,.*(?:$|/.*$)|
# File-names that should be ignored (never directories)
(^|/)(DEADJOE|\.cvsignore|\.arch-inventory|\.bzrignore|\.gitignore)$|
# File or directory names that should be ignored
(^|/)(CVS|RCS|\.pc|\.deps|\{arch\}|\.arch-ids|\.svn|\.hg|_darcs|\.git|
\.shelf|_MTN|\.bzr(?:\.backup|tags)?)(?:$|/.*$)|
# skip debian files that are too confusing or too short
(?:^|/)debian/((fix.scanned.)?copyright|changelog|NEWS|compat|.*yml|docs|source|patches/series)|
# skip some binary files
(png|jpg|pdf|ico|bmp|jpe?g)$
EOR

# also from licensecheck
$default{check} = << 'EOR2' ;
    (^|/)\w+$                 # scripts, AUTHORS files
    |^README                   # README.* files
    |META\d?.json                # Perl or Raku meta file
    |\.(                          # search for file suffix
        c(c|pp|xx)?              # c and c++
       |h(h|pp|xx)?              # header files for c and c++
       |S
       |css|less                 # HTML css and similar
       |f(77|90)?
       |go
       |groovy
       |in|am                    # file to pre-process
       |m4
       |\d                       # man pages
       |lisp
       |scala
       |clj
       |p(l|m)?6?|t|xs|pod6?     # perl5 or perl6
       |sh
       |php
       |py(|x)
       |rs                       # rust
       |rb
       |rs
       |java
       |js(on)?
       |vala
       |el
       |sc(i|e)
       |cs
       |pas
       |inc
       |dtd|xsl
       |mod
       |m
       |md|markdown
       |toml
       |tex
       |mli?
       |(c|l)?hs
     )
    $
EOR2

# cleanup the regexp
for (values %default) { s/#.*\n//g;  s/[\s\n]+//g; };

sub _get_data_from_files  ( %args ) {
    my $current_dir = $args{from_dir} || path('.');

    my %regexps = %default; # default is needed during tests
    my @lines ;
    if ($args{in}) {
        @lines = $args{in}->lines_utf8; # for tests
    }
    else {
        my $scan_data = {};
        my $debian = $current_dir->child('debian');
        my $scan_patterns = $debian->child("copyright-scan-patterns.yml");

        if ($debian->is_dir and $scan_patterns->is_file) {
            $scan_data = LoadFile($scan_patterns->stringify);
        }

        # licensecheck --check is broken ( #842368 ), so --skipped option is useless.
        # let's scan everything and skip later
        foreach my $what (qw/check ignore/) {
            my $data = $scan_data->{$what} || {};
            my $reg = join(
                '|' ,
                (map { '\.'.$_.'$'} @{$data->{suffixes} || []}),
                @{ $data->{pattern} || []},
                $default{$what}
            );
            $regexps{$what} = $reg;
        }

        my $lic_cmd = 'licensecheck --encoding utf8 --copyright --machine --shortname-scheme=debian,spdx --recursive '
            . "'--ignore=%s' %s";
        my $cmd = sprintf($lic_cmd, $regexps{ignore}, $current_dir);
        open(my $pipe, "-|", $cmd) or die "Can't open '$cmd' : $!\n";;
        binmode($pipe, ":encoding(UTF-8)");
        my $length = length($current_dir->stringify) + 1;
        @lines = map { substr $_,$length } $pipe->getlines;
        $pipe->close or die $! ? "Error closing licensecheck pipe: $!\n"
                               : "Exit status ".$?." $cmd\n";
    }
    return _trim_lines (\@lines, \%regexps);
}

sub _trim_lines ($lines, $regexps) {
    my @kept_lines;
    my @skipped;
    foreach my $line (sort $lines->@*) {
        chomp $line;
        my ($f,$l,$c) = split /\t/, $line;
        $f =~ s!\./!!;

        # filter out files user does not want checked
        if ( $f !~ $regexps->{check} ) {
            # the ignore test should not be usefull as the files are ignored by licensecheck
            push @skipped, $f unless $f =~ $regexps->{ignore};
        }
        else {
            push @kept_lines, [ $f, $l, $c ];
        }
    }

    if (@skipped) {
        my $msg= "The following files were skipped:\n";
        map {
             $msg .= "- $_\n";
         } @skipped;
        $msg .= "You may want to add a line in debian/copyright-scan-patterns.yml\n"
            ."or ask the author to add more default patterns to scan\n\n";
        _warn $msg;
    }

    return @kept_lines;
}

sub __skip_line ($f, $c, $l, $files, $fill_blank_data) {
    # say "found: $line";
    return 1 if $files->{$f};       # file already parsed

    # skip copyright because there's no need to have recursive copyrights
    # skip changelog because it often contains log entries beginning with copyright
    # and it's a collective work by nature.
    return 1 if $f =~  m!debian/(copyright|changelog)!;

    # skip copyright infos extracted from license files when they
    # come from the author of the license and not from the project
    # author
    if ($f =~  m/^COPYING|LICENSE$/) {
        if ($c =~ /Free Software Foundation/) {
            return 1;
        }
        if ($c =~ /Perl Foundation/) {
            return 1;
        }
    }

    # skip license files without copyright information (usually plain license)
    return 1 if $f =~  m/^COPYING|LICENSE$/ && $c =~ /No copyright/;

    # this data overrides what's found in current files. This is done before
    # the code that merge and coalesce entries
    my $fill_blank = __get_fill_blank($fill_blank_data, $f);

    return 1 if $fill_blank->{skip};
    return 0;
}

my $__extract_rust_info = sub ($file, $c, $l, $current_dir) {
    my $cargotoml = $current_dir->child($file);

    if ($cargotoml->is_file) {
        my $toml = $cargotoml->slurp_utf8;
        my $data = from_toml($toml);
        my $license = $data->{'package'}{'license'};
        my $authors = $data->{'package'}{'authors'} // [];
        if (defined $license) {
            # Cargo.toml spells AND and OR in capitals
            # and allows / as a synonym to OR
            $license =~ s! AND ! and !g;
            $license =~ s! OR ! or !g;
            $license =~ s!/! or !g;
        }
        return (join("\n ", @$authors) || $c, $license || $l);
    }
    return ($c, $l);
};

my $__extract_nodejs_info = sub ($c_key, $l_key, $file, $c, $l, $current_dir) {
    my $json_file = $current_dir->child($file);

    if ($json_file->is_file) {
        my $data = from_json($json_file->slurp_utf8);

        my @c_data;
        if  (ref $data->{$c_key}) {
            if (ref $data->{$c_key} eq 'HASH') {
                if (exists($data->{$c_key}->{name})) {
                    @c_data = ($data->{$c_key}->{name});
                }
            }
            else {
                @c_data = ($data->{$c_key}->@*);
            }
        } else {
            @c_data = ($data->{$c_key});
        }

        my @l_data
           = ref $data->{$l_key} eq 'ARRAY' ? $data->{$l_key}->@*
           :                                  $data->{$l_key};
        return (join("\n ", @c_data) || $c, join(" or ",@l_data) || $l);
    }
    return ($c, $l);
};

my $__extract_json_info = sub ($c_key, $l_key, $file, $c, $l, $current_dir) {
    my $json_file = $current_dir->child($file);

    if ($json_file->is_file) {
        my $data = from_json($json_file->slurp_utf8);
        my @c_data = ref $data->{$c_key} ? $data->{$c_key}->@* : $data->{$c_key};
        my @l_data = ref $data->{$l_key} ? $data->{$l_key}->@* : $data->{$l_key};
        return (join("\n ", @c_data) || $c, join(" or ",@l_data) || $l);
    }
    return ($c, $l);
};

my %override = (
    'Cargo.toml' => $__extract_rust_info,
    'package.json' => sub {$__extract_nodejs_info->('author','license',@_)},
    'META.json' => sub {$__extract_json_info->('author','license',@_)},
    'META6.json' => sub {$__extract_json_info->('authors','license',@_)},
);

sub __refine_line ($f, $c, $l, $current_dir, $files, $fill_blank_data) {
    # override license information by scanning for TOML data
    if ($override{$f}) {
        ($c, $l) = $override{$f}->($f, $c, $l, $current_dir);
        $l =~ s/MIT/Expat/g;
    }

    $c = __clean_copyright($c);

    $c = __pack_copyright($c);

    # Found in LICENSE files generated by Dist::Zilla
    $l =~ s/(l?gpl)_(\d)/uc($1)."-$2"/e;
    $l =~ s/_/./;
    $l =~ s!GPL-1\+ and/or GPL-1!GPL-1+!;

    my $fill_blank = __get_fill_blank($fill_blank_data, $f);
    ($c, $l) = __apply_fill_blank($fill_blank, $f, $l, $c);
    return ($f, $c, $l);
}

sub __store_line_info($f, $c, $l, $id, $files, $copyrights, $no_info_list) {
    my @no_info_found;
    if ( $c =~ /no-info-found/ ) {
        push @no_info_found, 'copyright';
    }
    if ( $l =~/unknown/i ) {
        push @no_info_found, 'license';
    }

    push $no_info_list->@* , [$f , @no_info_found ] if @no_info_found;

    my $has_info = @no_info_found < 2 ? 1 : 0;
    $files->{$f} = $copyrights->{$c}{$l} //= ($has_info ? $id++ : 0);
    # say "Storing '$f' : '$c' '$l' has_info: $has_info id ".$files->{$f};
    return $id;
}

# option to skip UNKNOWN ?
# load a file to override some entries ?
sub scan_files ( %args ) {
    $quiet = $args{quiet} // 0;

    my @line_refs = _get_data_from_files( %args );
    my $current_dir = $args{from_dir} || path('.');

    my $fill_blank_data = __load_fill_blank_data($current_dir);

    my %copyrights ;
    my $files = {};
    my $id = 1;
    my @no_info_list;

    foreach my $ref (@line_refs) {
        # say "found: $line";
        my ($f,$l,$c) = $ref->@*;

        next if __skip_line ($f, $c, $l, $files, $fill_blank_data);

        ($f, $c, $l) = __refine_line ($f, $c, $l, $current_dir, $files, $fill_blank_data);

        $id = __store_line_info($f, $c, $l, $id, $files, \%copyrights, \@no_info_list) ;
    }

    my @copyrights_by_id ;
    foreach my $c (sort keys %copyrights) {
        foreach my $l (sort keys $copyrights{$c}->%* ) {
            my $id = $copyrights{$c}{$l};
            $copyrights_by_id[$id] = __to_copyright_structure( $c, $l ) ;
        }
    }

    _warn_user_about_problems ($files, $fill_blank_data, @no_info_list);

    my $merged_c_info = __squash_copyrights_years (\@copyrights_by_id) ;

    # replace the old ids with news ids
    __swap_merged_ids($files, $merged_c_info);

    # stop here for update ...
    return ($files, \@copyrights_by_id) ;
}

sub _warn_user_about_problems ($files, $fill_blank_data, @no_info_list) {
    if (@no_info_list) {
        my $msg= "The following paths are missing information:\n";
        map {my ($p,@i) = $_->@*;
             $msg .= "- $p: missing ".join(' and ', @i)."\n";
         } @no_info_list;
        $msg .= "You may want to add a line in debian/fill.copyright.blanks.yml\n\n";
        _warn $msg;
    }

    my @notused = grep { not $fill_blank_data->{$_}{used} and $_; } sort keys %$fill_blank_data ;
    if (@notused) {
        _warn "Warning: the following entries from fill.copyright.blanks.yml were not used\n- '"
            .join("'\n- '",@notused)."'\n";
    }

    warn "No copyright information found" unless keys %$files;

    return;
}

sub __to_copyright_structure ($c, $l) {
    return {
        Copyright => $c,
        License => { short_name => $l},
    };
}

sub __from_copyright_structure ($s) {
    return ($s->{Copyright}, $s->{License}{short_name});
}

sub __split_copyright ($c) {
    my ($years,$owner) = $c =~ /^(\d\d[\s,\d-]+)(.*)/;
    # say "undef year in $c" unless defined $years;
    return unless defined $years;
    my @data = split /(?<=\d)[,\s]+/, $years;
    return unless defined $owner;
    $owner =~ s/^[\s.,-]+|[\s,*-]+$//g;
    return ($owner,@data);
}

sub __create_tree_leaf_from_paths ($h,$path,$value) {
    # explode path in subpaths
    my @subpaths = split '/', $path;
    my $last = pop @subpaths;
    map { $h = $h->{$_} ||= {} } @subpaths ;
    $h->{$last} = $value;
    return;
}

sub __clean_copyright ($c) {
    $c =~ s/'//g;
    $c =~ s/^&copy;\s*//g;
    $c =~ s/\(c\)\s*//g;
    $c =~ s/(?<=\b\d{4})\s*-\s*\d{4}(?=\s*-\s*(\d{4})\b)//g;
    $c =~ s/(\d+)\s*-\s*(\d+)/$1-$2/g;
    $c =~ s/\b(\d{4}),?\s+([\S^\d])/$1, $2/g;
    $c =~ s/\s+by\s+//g;
    $c =~ s/(\\n)*all\s+rights?\s+reserved\.?(\\n)*\s*//gi; # yes there are literal \n
    $c = 'no-info-found' if $c =~ /^\*No/;
    $c =~ s/\(r\)//g;
    $c =~ s!^[\s,/*]|[\s,#/*-]+$!!g;
    $c =~ s/--/-/g;
    $c =~ s!\s+\*/\s+! !;
    # libuv1 has copyright like "2000, -present"
    $c =~ s![,\s]*-present!'-'.(localtime->year() + 1900)!e;
    $c =~ s![\x00-\x1f].*!!; # cut off everything after and including the first non-printable
    # cleanup markdown copyright
    $c =~ s/\[([\w\s]+)\]\(mailto:([\w@.+-]+)\)/$1 <$2>/;
    return $c;
}

sub __pack_copyright ($r) {

    return $r if $r eq 'no-info-found';
    my %cop;
    $r =~ /^[\s\W]+|[\s\W]+$/g;
    # split licensecheck output or debfmt data
    foreach my $c ( split( m!(?:\s+/\s+)|(?:\s*\n\s*)!, $r) ) {
        my ($owner, @data) = __split_copyright($c);
        return $r unless defined $owner;
        $cop{$owner} ||= [] ;
        push $cop{$owner}->@*, @data ;
    }
    my @res ;
    foreach my $owner (sort keys %cop) {
        my $span = Array::IntSpan->new();
        my $data = $cop{$owner};
        foreach my $year ($data->@*) {
            return $r if $year =~ /[^\d-]/; # bail-out
            # take care of ranges written like 2002-3
            $year =~ s/^(\d\d\d)(\d)-(\d)$/$1$2-$1$3/;
            # take care of ranges written like 2014-15
            $year =~ s/^(\d\d)(\d\d)-(\d\d)$/$1$2-$1$3/;
            eval {
                $span->set_range_as_string($year, $owner);
            };
            if ($@) {
                warn "Invalid year range in copyright: $r";
                return $r;
            }
        }
        $span->consolidate();
        push @res, $span->get_range_list. ($owner ? ', '. $owner : '');
    }
    return join("\n ",reverse sort @res);
}

#in each directory, pack files that have the same copyright/license information
# traverse recursively %h (whose structure matches the scanned directory)
# @path keeps track of the recursion depth to provide the file path
sub __pack_files ($h) {

    my @res ;
    __pack_dir($h,\@res) ;

    # sort by first path listed in there
    my $sort_path = sub {
        $a->[1] cmp $b->[1];
    };

    return (sort $sort_path @res) ;
}

sub __pack_dir ($h, $pack, @path) {
    my %pack_by_id;
    foreach my $file (sort keys %$h) {
        my $id = $h->{$file};
        if (ref($id)) {
            __pack_dir($id, $pack, @path, $file) ;
        }
        elsif (defined $pack_by_id{$id} ) {
            push $pack_by_id{$id}->@*, join('/',@path,$file);
        }
        else {
            $pack_by_id{$id} = [ join('/',@path,$file) ] ;
        }
    }

    push $pack->@*, map { [ $_, $pack_by_id{$_}->@* ];  } keys %pack_by_id ;
    return;
}

# find ids that can be merged together
# I.e. merge entries with same license and same set of owners. In this
# case the years are merged together.
sub __squash_copyrights_years ($copyrights_by_id) {

    my %id_year_by_same_owner_license;
    for (my $id = 1; $id < $copyrights_by_id->@* ; $id++ ) {
        my ($c, $l) = __from_copyright_structure($copyrights_by_id->[$id]);
        #say "id $id: c $c l $l";
        my @owners ;
        my @years ;
        foreach my $line (split(/\n\s+/,$c)) {
            my ($owner, @year) = __split_copyright($line);
            next unless defined $owner;
            push @owners, $owner;
            push @years, join(',',@year);
        }
        my $k = join('|', $l, @owners);
        $id_year_by_same_owner_license{$k} //= [];
        push $id_year_by_same_owner_license{$k}->@*, [ $id, @years ];
    }

    my @merged_c_info;
    # now detect where %id_year_by_same_owner_license references more
    # than one id this means that several entries can be merged in a
    # *new* id (new id to avoid cloberring data of other directories)
    foreach my $owner_license (sort keys %id_year_by_same_owner_license) {
        my @entries =  $id_year_by_same_owner_license{$owner_license}->@* ;
        next unless @entries > 1;

        my ($l,@owners) = split /\|/, $owner_license;

        # create new copyright info with coalesced years
        my @squashed_c = __coalesce_copyright_years(\@entries,\@owners) ;
        next unless @squashed_c ; # give up this entry when problem

        # store (c) info with coalesced years in new item of $copyrights_by_id
        my $new_id = $copyrights_by_id->@* ;
        my $new_cop = join("\n ",@squashed_c) ;
        $copyrights_by_id->[$new_id] = __to_copyright_structure( $new_cop , $l );
        #say "created id $new_id with c $new_cop l $l";
        # fill the swap table entry-id -> coaslesces entry-id
        foreach my $id ( map { $_->[0]} @entries) {
            $merged_c_info[$id] = $new_id;
        }
    }

    return \@merged_c_info;
}

sub __swap_merged_ids ($files, $merged_c_info) {
    foreach my $name (sort keys %$files) {
        my $item = $files->{$name};
        if (ref($item)) {
            __swap_merged_ids($item,$merged_c_info);
        }
        elsif (my $new_id = $merged_c_info->[$item]) {
            $files->{$name} = "$new_id"  ;
        }
    }
    return;
}

sub __coalesce_copyright_years($entries, $owners) {
    my @ranges_of_years ;
    # $entries and $owners always have the same size

    foreach my $entry (@$entries) {
        my ($id, @years) = $entry->@* ;

        for (my $i = 0; $i < @years; $i++) {
            return () unless $years[$i] =~ /^[0-9,\s-]+$/; # detect empty year range
            my $span = $ranges_of_years[$i] //= Array::IntSpan->new();
            return () unless $span; # bail out in case of problems
            eval {
                $span->set_range_as_string($years[$i], 1);
            };
            if ($@) {
                warn "Invalid year range: ",$years[$i];
                return ();
            }
        }
    }

    my @squashed_c;
    for (my $i=0; $i < @$owners ; $i++) {
        $ranges_of_years[$i]->consolidate();
        $squashed_c[$i] = $ranges_of_years[$i]->get_range_list.', '.$owners->[$i];
    }

    return @squashed_c;
}

sub __find_main_license_info ($tree_of_ids) {
    my %main_info;
    foreach my $name (sort keys %$tree_of_ids) {
        if ($override{$name}) {
            my $id = $tree_of_ids->{$name};
            next unless $id; # skip files without info
            delete $tree_of_ids->{$name};
            $main_info{$id} = 1;
        };
    }
    foreach my $info_name (qw/README LICENSE LICENCE COPYING/) {
        my $re = qr!^$info_name[.\w]*$!;
        foreach my $name (sort keys %$tree_of_ids) {
            if ($name =~ $re) {
                my $id = $tree_of_ids->{$name};
                delete $tree_of_ids->{$name} if $info_name ne 'README';
                next unless $id; # skip files without info
                $main_info{$id} = 1;
            };
        }
    }
    return \%main_info;
}

sub __find_main_license_id ($copyrights_by_id, $main_info) {
    my $main_license_id;
    my @main_info_keys = sort keys %$main_info;
    if (@main_info_keys == 1) {
        $main_license_id = $main_info_keys[0];
    }
    elsif (@main_info_keys > 1) {
        # create a new copyright id containing a sum of all info found
        # in README LICENSE (...) files (if they are different and
        # have actual info)
        my %licenses;
        my %copyrights;
        foreach my $info_id (@main_info_keys) {
            my ($cop, $lic) = __from_copyright_structure($copyrights_by_id->[$info_id]);
            $licenses{$lic} = 1 unless $lic =~ /unknown/i;
            $copyrights{$cop} = 1 unless $cop =~ /unknown|no-info-found/i;;
        }
        push $copyrights_by_id->@*,
            __to_copyright_structure (
                join("\n", sort keys %copyrights),
                join(" or ", sort keys %licenses)
            );
        $main_license_id = $#$copyrights_by_id;
    }
    return $main_license_id;
}

sub __update_main_license_from_files ($main_license_id, $tree_of_ids, $copyrights_by_id, $path) {
    my %count ;
    # count the number of times each (c) info is used in this directory.
    # (including the main (c) info of each subdirectory)
    foreach my $name (sort keys %$tree_of_ids) {
        my $item = $tree_of_ids->{$name};
        if (ref($item)) {
            # squash may return a plain id, or a hash with '*' => id ,
            # or a non squashable hash
            $tree_of_ids->{$name} = __squash_tree_of_copyright_ids($item, $copyrights_by_id, $path.'/'.$name);
        }
        my $id = (ref($item) and defined $item->{'*'}) ? $item->{'*'} : $item ;

        # do not count non squashable hashes (i.e. there's no main (c) info)
        # do not count ids containing no information (id 0)
        if (not ref ($id) and $id != 0) {
            $count{$id}//=0;
            $count{$id} ++;
        }
    }

    # find the most used (c) info in this directory
    # unless info was already found in LICENSE or README content
    my $max = 0;
    if (not defined $main_license_id) {
        foreach my $id (sort keys %count) {
            if ($count{$id} > $max) {
                $max = $count{$id};
                $main_license_id = $id ;
            }
        }
    }
    return $main_license_id;
}

sub __prune_files_represented_by_main_license ($main_license_id, $tree_of_ids) {
    # all files associated to the most used (c) info are deleted to
    # be represented by '*' entry
    if (defined $main_license_id) {
        foreach my $name (sort keys %$tree_of_ids) {
            my $item = $tree_of_ids->{$name};
            if (ref($item) and defined $item->{'*'} and $item->{'*'} == $main_license_id) {
                # rename item/* to item/. when covered by ./*
                # this is a "weak" directory info which is handled specially
                $item->{'.'} = delete $item->{'*'};
            }
            if (not ref ($item)) {
                # delete file that is represented by '*' entry
                delete $tree_of_ids->{$name} if $item == $main_license_id;
            }
        }

        # here's the '*' file representing the most used (c) info
        $tree_of_ids->{'*'} //= $main_license_id;
    }
    return;
}

# $tree_of_ids is a tree of hash matching the directory structure. Each leaf is a
# copyright id. Each key is a file name in a directory (not the full path)
sub __squash_tree_of_copyright_ids ($tree_of_ids, $copyrights_by_id, $path = '') {
    # find main license info found in LICENSE or COPYING or README
    #  file. LICENSE and COPYING are removed from the file list as
    #  they specify the license author as copyright owner
    my $main_info = __find_main_license_info($tree_of_ids);

    my $main_license_id = __find_main_license_id($copyrights_by_id, $main_info);

    $main_license_id = __update_main_license_from_files ($main_license_id, $tree_of_ids, $copyrights_by_id, $path);

    __prune_files_represented_by_main_license ($main_license_id, $tree_of_ids);

    return $tree_of_ids;
}

sub __load_fill_blank_data ($current_dir) {
    my %fill_blanks ;
    my $debian = $current_dir->child('debian'); # may be missing in test environment

    if ($debian->is_dir) {
        my @fills = $debian->children(qr/fill\.copyright\.blanks\.yml$/);

        warn "Note: loading @fills fixes" if @fills and not $quiet;
        foreach my $file ( @fills) {
            my $data = LoadFile($file->stringify);
            foreach my $path (sort keys %$data) {
                if ($fill_blanks{$path}) {
                    warn "Warning: skipping duplicated fill blank path $path from file $file";
                }
                else {
                    $fill_blanks{$path} = $data->{$path};
                }

                foreach my $k (keys $fill_blanks{$path}->%*) {
                    die "Error in file $file: Unexpected key '$k' in path '$path'\n"
                        unless $k =~/^(comment|skip|(override-)?(license|copyright))$/;
                }
            }
        }
    }

    return \%fill_blanks;
}

sub __get_fill_blank ($fbd,$file) {

    foreach my $path (reverse sort keys %$fbd) {
        if ($file =~ m(^$path)) {
            $fbd->{$path}{used} = 1;
            return $fbd->{$path};
        }
    }
    return {};
}

sub __apply_fill_blank($fill_blank, $f, $l, $c) {
    if ( $c =~ /no-info-found/ and $fill_blank->{copyright} ) {
        $c = $fill_blank->{copyright};
    }
    if ($fill_blank->{'override-copyright'}) {
        _warn "Overriding path $f copyright info\n";
        $c = $fill_blank->{'override-copyright'};
    }
    if ( $l =~/unknown/i and $fill_blank->{license} ) {
        $l = $fill_blank->{license};
    }
    if ($fill_blank->{'override-license'}) {
        _warn "Overriding path $f license info\n";
        $l = $fill_blank->{'override-license'};
    }
    return ($c, $l);
}
1;

__END__

=encoding utf8

=head1 NAME

 Dpkg::Copyright::Scanner - Scan files to provide copyright data

=head1 SYNOPSIS

 use Dpkg::Copyright::Scanner qw/print_copyright scan_files/;

 # print copyright data on STDOUT
 print_copyright;

 # return a data structure containing copyright information
 my @copyright_data = scan_files();


=head1 DESCRIPTION

This modules scans current package directory to extract copyright and
license information. Information are packed in a way to ease review and
maintenance. Files information is grouped with wildcards ('*') to reduce
the list of files.

=head2 About LICENSE and README files

Projects often store global copyright information, i.e. information
that apply to all files of a project (unless specified otherwise in
some files) in README or LICENSE or COPYING file.

The information contained in these files id merged and applied to the
directory entry that contain them.

I.e files like:

 foo_comp/README: (c) 2018 Joe, GPL-2
 foo_comp/LICENSE: (c) 2017 Max, GPL-3

yield the following copyright entries:

 foo_comp/*:
 Copyright: 2018 Joe
   2019 Max
 License: GPL-2 or GPL-3

 README:
 Copyright: 2018 Joe
 License: GPL-2

=head1 Selecting or ignoring files to scan

By default, scanner scans source files with known suffixes (like .c
.pl ...), README, scripts and skip backup files.

If needed, this behavior can tuned with
C<debian/copyright-scan-patterns.yml> file. This YAML file contains a
list of suffixes or patterns to scan or to ignore that are added to
the default list. Any file that is not scanned or ignored will be
shown as "skipped".

This file must have the following structure (all fields are optional
and order does not matter):

 ---
 check :
   suffixes :
     - PL       # check .PL$
     - asm
   pattern:
     - /README$
 ignore :
   suffixes :
     - yml
   pattern :
     - /t/
     - /models/
     - /debian/
     - /Changes

Do not specify the dot with the suffixes. This will be added by the scanner.

Note that a file that match both "check" and "ignore" pattern is ignored.

=head1 Filling the blanks

Sometimes, upstream coders are not perfect: some source files cannot
be parsed correctly or some legal information is missing.

All scanned files, even without copyright or license will be used. A
warning will be shown for each file with missing information.

Instead of patching upstream source files to fill the blank, you can
specify the missing information in a special file. This file is
C<debian/fill.copyright.blanks.yml>. It should contain a "mapping"
YAML structure (i.e. a hash), where the key is a Perl pattern used to
match a path. 

If the source of the package contains a lot of files without legal
information, you may need to specify there information for a whole
directory (See the C</src> dir in the example below).

For instance:

 ---
 debian:
   copyright: 2015, Marcel
   license: Expat
 src/:
   copyright: 2016. Joe
   license: Expat
 share/pkgs/openSUSE/systemd/onedsetup:
   copyright: 2015, Marcel
 share/vendor/ruby/gems/rbvmomi/lib/rbvmomi.*\.rb:
   license: Expat
 .*/NOTICE:
   skip: 1
 share/websockify/:
   license: LGPL-2
 src/sunstone/:
   license: Apache-2.0
 src/garbled/:
   'override-copyright': 2016 Marcel Mézigue

Patterns are matched from the beginning a
path. I.e. C<share/websockify/> pattern will match
C<share/websockify/foo.rb> but will not match
C<web/share/websockify/foo.rb>.

Patterns are tried in reversed sorted order. I.e. the data attached to
more specific path (e.g. C<3rdparty/foo/blah.c>) are applied before
more generic patterns (e.g. C<3rdparty/foo/>

The C<license> key must contain a license short name as returned by
C<license_check>.

When C<skip> is true, the file is skipped like a file without any
information.

The C<override-copyright> and C<override-license> keys can be used to
ignore the copyright information coming from the source and provide
the correct information. Use this as last resort for instance when the
encoding of the owner is not ascii or utf-8 or when the license data
is corrupted. Note that a warning will be shown each time an override
key is used.

=head1 METHODS

=head2 print_copyright

Print copyright information on STDOUT like L<scan-copyrights>.

=head2 scan_files ( %args )

Return a data structure with copyright and license information.

The structure is a list of list:

 [
   [
     [ path1 ,path2, ...],
     copyright,
     license_short_name
   ],
   ...
 ]

Example:

 [
  [
    [ '*' ],
    '1994-2001, by Frank Pilhofer.',
    'GPL-2+'
  ],
  [
    [ 'pan/*' ],
    '2002-2006, Charles Kerr <charles@rebelbase.com>',
    'GPL-2'
  ],
  [
    [
      'pan/data/parts.cc',
      'pan/data/parts.h'
    ],
    '2002-2007, Charles Kerr <charles@rebelbase.com>',
    'GPL-2'
  ],
 ]

Parameters in C<%args>:

=over

=item quiet

set to 1 to suppress progress messages. Should be used only in tests.

=item long

set to 1 to avoid squashing copyright ids. Useful to avoid output with wild cards.

=back


=head1 Encoding

The output of L<licensecheck> is expected to be utf-8. Which means
that the source files scanned by L<licensecheck> should also be
encoded in utf-8. This program will abort if invalid utf-8 characters
are found.

=head1 BUGS

Extracting license and copyright data from unstructured comments is not reliable.
User must check manually the files when no copyright info is found or when the
license is unknown.

Source files are assumed to be utf8 (or ascii). Using files with invalid characters
will break C<cme>. In this case, you can:

=over

=item *

Patch source files to use utf-8 encoding.

=item *

Use the "fill copyright blank" mechanism described above with
C<copyright-override> to provide an owner name with the correct
encoding.

=item *

File a bug against licensecheck package to find a better solution.

=back

=head1 SEE ALSO

L<licensecheck>, C<licensecheck2dep5> from C<cdbs> package

=head1 AUTHOR

Dominique Dumont <dod@debian.org>

=cut

