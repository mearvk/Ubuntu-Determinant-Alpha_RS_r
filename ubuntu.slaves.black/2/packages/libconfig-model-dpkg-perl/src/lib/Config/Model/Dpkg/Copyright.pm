package Config::Model::Dpkg::Copyright ;

use strict;
use warnings;

use 5.020;
use IO::Pipe;

use feature qw/postderef signatures/;
no warnings qw/experimental::postderef experimental::signatures/;

use base qw/Config::Model::Node/;
use Path::Tiny;
use Data::Dumper;

use Config::Model::DumpAsData;
use Dpkg::Copyright::Scanner qw/scan_files __squash_tree_of_copyright_ids __pack_files __pack_copyright
                                __create_tree_leaf_from_paths __from_copyright_structure/;
use Scalar::Util qw/weaken/;
use Storable qw/dclone/;

my $join_path = "\n "; # used to group Files

sub get_joined_path ($self, $paths) {
    return join ($join_path, sort @$paths);
}

sub split_path ($self,$path) {
    return ( sort ( ref $path ? @$path : split ( /[\s\n]+/ , $path ) ) );
}

sub normalize_path ($self,$path) {
    my @paths = $self->split_path($path);
    return $self->get_joined_path(\@paths);
}

my $dumper = Config::Model::DumpAsData->new;

sub _say ($self,$msg) {
    say $msg unless $self->{quiet};
    return;
}

sub _get_old_data ($old_split_files, $old_split_dirs, $path) {
    my $data = delete $old_split_files->{$path};

    # retrieve data for directories above if the path has no data.
    # This enables to merge information attached to directory by the
    # user to the files. This information may override some unknown
    # entries. Anyway, this duplicated information is coaslesced later
    # on. In other words, this may seem back and forth work, but it's
    # not because manually entered information at directory level is
    # merged into the file data.
    if (not $data) {
        foreach my $dir (reverse sort keys $old_split_dirs->%*) {
            my $re = $dir;
            $re =~ s/\*$//;
            if ($path =~ /^$re/) {
                $data = $old_split_dirs->{$dir}; # do not delete
                last;
            }
        }
    }
    return defined $data ? dclone($data) : {};
}

# $args{in} can contains the output of licensecheck (for tests)
sub update ($self, %args) {

    my $files_obj = $self->grab("Files");
    $self->{quiet} = $args{quiet} // 0;

    # explode existing path data to track deleted paths
    my %old_split_files;
    my %old_split_dirs;
    my %debian_paths;
    foreach my $paths_str ($files_obj->fetch_all_indexes) {
        my $node = $files_obj->fetch_with_id($paths_str) ;
        my $data = $dumper->dump_as_data( node => $node );

        # normalise existing copyright data (mandatory parameter, no need to test)
        $data->{Copyright} = __pack_copyright($data->{Copyright});

        if ($paths_str =~ m!^debian/!) {
            $debian_paths{$paths_str} = $data;
        }
        else {
            foreach my $path ($self->split_path($paths_str)) {
                $old_split_files{$path} = $data ;
                $old_split_dirs{$path} = $data if $path =~ /\*$/;
            }
        }
    }

    my ($files, $copyrights_by_id) = scan_files( %args );

    # explode new data and merge with existing entries
    my %new_split_files;
    my @new_copyrights_by_id = (undef);# id 0 is reserved for entries without info
    my %data_keys;
    foreach my $path ( sort keys $files->%* ) {
        my $id = $files->{$path};
        next if $id == 0 and not defined $copyrights_by_id->[$id];
        my ($c, $l) = __from_copyright_structure($copyrights_by_id->[$id]);

        my $new_data = _get_old_data(\%old_split_files, \%old_split_dirs, $path);
        my $old_cop = $new_data->{Copyright};
        my $old_lic = $new_data->{License}{short_name};
        # $self->_say( "load '$path' with '$c' ('$l') old '$old_cop' ('$old_lic')");
        # clobber old data
        $new_data->{Copyright} = $c if ($c !~ /no-info-found|UNKNOWN/ or not $old_cop);
        $new_data->{License}{short_name} = $l if ($l ne 'UNKNOWN' or not $old_lic);

        # when all fails
        $new_data->{Copyright} ||= 'UNKNOWN';
        $new_data->{License}{short_name} ||= 'UNKNOWN';

        # skip when no info is found in original data
        my $d_key;
        if ( $new_data->{Copyright} =~ /no-info-found|unknown/xi
            and $new_data->{License}{short_name} =~ /unknown/i) {
            $new_copyrights_by_id[0] //= $new_data;
            $d_key = 0;
        }
        else {
            # create an inventory of different file copyright and license data
            # this works like $copyrights_by_id but takes into account data coming
            # from old copyright file like comments
            my $data_dumper = Data::Dumper->new([$new_data])->Sortkeys(1)->Indent(0);
            my $datum_dump = $data_dumper->Dump;
            $d_key = $data_keys{$datum_dump};

            if (not defined $d_key) {
                push @new_copyrights_by_id,$new_data;
                # id 0 is reseved for missing info and is treated
                # differently. It must not be used since entries
                # without info are skipped. Hence @new_copyrights_by_id was
                # initialised with ('');
                $d_key = $data_keys{$datum_dump} = $#new_copyrights_by_id ;
           }
        }
        # explode path in subpaths and store id pointing to copyright data in there
        __create_tree_leaf_from_paths(\%new_split_files, $path, $d_key);
    }

    # at this point:
    # * $copyrights_by_id is not longer used, its data and merged data are in @new_copyrights_by_id
    # * @new_copyrights_by_id contains a list of copyright/license data
    # * %new_split_files contains a tree matching a directory tree where each leaf
    #   is an integer index referencing
    #   an entry in @new_copyrights_by_id to get the correct  copyright/license data
    # * %old_split_files contains paths no longer present. Useful to trace deleted files

    my $current_dir = $args{from_dir} || path('.');

    my %preserved_path;
    # warn about old files (data may be redundant or obsolete though)
    foreach my $old_path (sort keys %old_split_files) {
        # prepare to be able to put back data matching an existing dir
        if ($old_path eq '*' or ($old_path =~ m!(.*)/\*$! and $current_dir->child($1)->is_dir )) {
            $preserved_path{$old_path} = delete $old_split_files{$old_path};
            $self->_say( "Note: preserving '$old_path'" );
        }
        else {
            $self->_say( "Note: '$old_path' was removed (or excluded) from new upstream source" );
        }
    }

    $self->_prune_old_dirs(\%new_split_files, \%old_split_files) ;


    # implode files entries with same data index
    __squash_tree_of_copyright_ids(\%new_split_files, \@new_copyrights_by_id) ;

    # pack files by copyright id
    my @packed = __pack_files(\%new_split_files);

    # delete existing data in config tree. A more subtle solution to track which entry is
    # deleted or altered (when individual files are removed, renamed) is too complex. The track
    # would require to follow split files,
    $files_obj->clear;

    # count license useage to decide whether to add a global license
    # or a single entry. Skip unknown or public-domain licenses
    my %lic_usage_count;
    map { $lic_usage_count{$_}++ if $_ and not /unknown|public/i}
        map {split /\s+or\s+/, $new_copyrights_by_id[$_->[0]]->{License}{short_name} // ''; }
        @packed ;

    # load new data in config tree
    foreach my $pack_data (@packed) {
        my ($id, @paths) = $pack_data->@*;

        next if $id == 0; # skip entries without info

        my $datum = dclone($new_copyrights_by_id[$id]);

        # ditch old data when copyright data directory is found in source files
        if ($paths[0] =~ /[*.]$/) {
            if (@paths > 1) {
                die "Internal error: can't have dir path with file path: @paths";
            }
            my $p = $paths[0];
            $p =~ s/\.$/*/;
            my $old_data = delete $preserved_path{$p};

            my $using_old_data = 0;
            if ($old_data and $old_data->{Copyright} and $old_data->{License}{short_name}) {
                if ($datum->{Copyright} =~ /unknown|no-info-found/xi) {
                    $self->_say( "keeping copyright dir data for $p");
                    $datum->{Copyright} = $old_data->{Copyright};
                    $using_old_data = 1;
                }
                if ($datum->{License}{short_name} =~ /unknown|no-info-found/xi) {
                    $self->_say( "keeping license dir data for $p");
                    $datum->{License}{short_name} = $old_data->{License}{short_name};
                    $datum->{License}{full_license} = $old_data->{License}{full_license};
                    $using_old_data = 1;
                }
                $self->_say( "old dir data for $p overridden by new data") unless $using_old_data;
            }

            if ($paths[0] =~ /\.$/) {
                if ($using_old_data) {
                    # fix path ending with '.' that contain merged info from old copyright file
                    $paths[0] = $p;
                } else {
                    # skip writing data because it duplicates information
                    # found in directory above above (as shown the path ending
                    # with '/.')
                    # $self->_say( "skipping redundant path ".$paths[0] );
                    next;
                }
            }
        };

        my $path_str = $self->normalize_path(\@paths);
        my $l = $datum->{License}{short_name};

        my $norm_path_str = $self->normalize_path(\@paths);

        # if full_license is not provided in datum, check global license(s)
        if (not $datum->{License}{full_license}) {
            my $ok = 0;
            my @sub_licenses = split m![,\s]+ (?:and/or|or|and) [,\s]+!x,$l;
            my $lic_count = 0;
            my @empty_licenses = grep {
                my $text = $self->grab_value(steps => qq!License:"$_" text!, check =>'no') ;
                $ok++ if $text;
                $lic_count += $lic_usage_count{$_} // 0 ;
                not $text; # to get list of empty licenses
            } @sub_licenses;

            if ($ok ne @sub_licenses) {
                my $filler = "Please fill license $l from header of @paths";
                if ($lic_count > 1 ) {
                    $self->_say( "Adding dummy global license text for license $l for path @paths");
                    for my $lic (@empty_licenses) {
                        $self->load(qq!License:"$lic" text="$filler"!)
                    };

                }
                else {
                    $self->_say( "Adding dummy license text for license $l for path @paths");
                    $datum->{License}{full_license} = $filler;
                }
            }

        }

        eval {
            $files_obj
                ->fetch_with_id($path_str)
                ->load_data( data => $datum, check =>'yes' );
            1;
        } or do {
            die "Error: Data extracted from source file is corrupted:\n$@"
                ."This usually mean that cme or licensecheck (or both) "
                ."have a bug. You may work-around this issue by adding an override entry in "
                ."fill.copyright.blanks file. See "
                ."https://github.com/dod38fr/config-model/wiki/Updating-debian-copyright-file-with-cme "
                ."for instructions. Last but not least, please file a bug against libconfig-model-dpkg-perl.\n";
        };
    }

    # delete global license without text
    my $global_lic_obj = $self->fetch_element('License');
    foreach my $l ($global_lic_obj->fetch_all_indexes) {
        $global_lic_obj->delete($l)
            unless $global_lic_obj->fetch_with_id($l)->fetch_element_value('text');
    }

    # put back preserved data
    foreach my $old_path (sort keys %preserved_path) {
        $self->_say( "Note: preserving entry '$old_path'");
        $files_obj->fetch_with_id($old_path)->load_data( $preserved_path{$old_path} );
    }

    # put back debian data if file or dir is still present
    foreach my $deb_path (sort keys %debian_paths) {
        my $target = $deb_path =~ m!(.*)/\*$! ? $1 : $deb_path;
        if ($current_dir->child($target)->exists) {
            $files_obj->fetch_with_id($deb_path)->load_data( $debian_paths{$deb_path} );
        }
        else {
            $self->_say("Note: dropping obsolete entry $deb_path");
        }
    }

    $self->_apply_fix_scan_copyright_file($current_dir) ;

    # normalized again after all the modifications
    $self->load("Files:.sort");

    $self->fetch_element("License")-> prune_unused_licenses;

    $self->instance->clear_changes; # too many changes to show users
    $self->notify_change(note => "updated copyright from source file"); # force a save

    my @msgs = (
        "Please follow the instructions given in ".__PACKAGE__." man page,",
        "section \"Tweak results\" if some license and copyright entries are wrong.",
        "Other information, like license text, can be added directly in debian/copyright file ",
        "and will be merged correctly next time this command is run.",
        "See also https://github.com/dod38fr/config-model/wiki/Updating-debian-copyright-file-with-cme"
    );

    return @msgs;
}

sub _apply_fix_scan_copyright_file ($self, $current_dir) {
    # read a debian/fix.scanned.copyright file to patch scanned data
    my $debian = $current_dir->child('debian'); # may be missing in test environment
    if ($debian->is_dir) {
        my @fixes = $current_dir->child('debian')->children(qr/fix\.scanned\.copyright$/x);
        $self->_say( "Note: loading @fixes fixes from copyright fix files") if @fixes;
        foreach my $fix ( @fixes) {
            my @l = grep { /[^\s]/ } grep { ! m!^(?:#|//)!  } $fix->lines_utf8;
            eval {
                $self->load( steps => join(' ',@l) , caller_is_root => 1 );
                1;
            } or do {
                my $e = $@;
                my $msg = $e->full_message;
                Config::Model::Exception::User->throw(
                    object => $self,
                    message => "Error while applying fix.scanned.copyright file:\n\t".$msg
                );
            }
        }
    }
    return;
}

sub _prune_old_dirs ($self, $h, $old_dirs, $path = [] ) {

    # recurse in the data structure
    foreach my $name (sort keys %$h) {
        my $item = $h->{$name};
        if (ref($item)) {
            $self->_prune_old_dirs($item, $old_dirs, [ $path->@*, $name ]);
        }
    }

    # delete current directory entry
    my $dir_path = join('/', $path->@*,'.');
    if ($old_dirs->{$dir_path}) {
        $self->_say( "Removing old entry $dir_path" );
        delete $old_dirs->{$dir_path};
    }
    return;
}

1;

__END__

=encoding utf8

=head1 NAME

Config::Model::Dpkg::Copyright - Fill the File sections of debian/copyright file

=head1 SYNOPSIS

 # this modules is used by cme when invoked with this command
 $ cme update dpkg-copyright

=head1 DESCRIPTION

This commands helps with the tedious task of maintening
C<debian/copyright> file. When you package a new release of a
software, you can run C<cme update dpkg-copyright> to update the
content of the copyright file.

This command scans current package directory to extract copyright and
license information and store them in the Files sections of
debian/copyright file.

In debian package directory:

* run 'cme update dpkg-copyright' or 'cme update dpkg'
* check the result with your favorite VCS diff tool. (you do use
  a VCS for your package files, do you ?)

Note: this command is experimental.

=head1 Debian copyright data

The C<Files: debian/*> section from C<debian/copyright> is often the
only place containing copyright information for the files created by
Debian maintainer. So all C<Files> entries beginning with C<debian/>
are preserved during update. However, entries not matching an existing
file or directory are removed.


=head1 Tweak results

Results can be tweaked either by:

=over

=item *

Changing the list of files to scan or ignore. (By default, licensecheck will decide
which file to scan or not.)

=item *

Specifying information for individual files

=item *

Tweaking the copyright entries created by grouping and coaslescing
information.

=back

The first 2 ways are described in
L<Dpkg::Copyright::Scanner/"Selecting or ignoring files to scan">
and L<Dpkg::Copyright::Scanner/"Filling the blanks">.

The last way is described below:

=head2 Tweak copyright entries

Since the extraction of copyright information from source file is
based on comments, the result is sometimes lackluster. Your may
specify instruction to alter or set specific copyright entries in
C<debian/fix.scanned.copyright> file
(or C<< debian/<source-package>.fix.scanned.copyright >>).

L<cme> stores the copyright information in a tree. Entries in
C<fix.scanned.copyright> provide instructions for traversing the cme tree
and modifying entries. You can have a view of C<debian/copyright> file
translated in this syntax by running C<cme dump --format cml
dpkg-copyright>.  Each line of this file will be handled by
L<Config::Model::Loader> to modify copyright information; the full
syntax is documented in L<Config::Model::Loader/"load string syntax"> section.

=head2 Example

If the extracted copyright contains:

 Files: *
 Copyright: 2014-2015, Adam Kennedy <adamk@cpan.org> "foobar
 License: Artistic or GPL-1+

You may add this line in C<debian/fix.copyright> file:

 ! Files:'*' Copyright=~s/\s*".*//

This way, the copyright information will be updated from the file
content but the extra C<"foobar> will always be removed during
updates.

Comments are accepted in Perl and C++ style from the beginning of the line.
Lines breaks are ignored.

Here's another more complex example:

 // added a global license, MIT license text is filled by Config::Model
 ! copyright License:MIT

 # don't forget '!' to go back to tree root
 ! copyright Files:"pan/general/map-vector.h" Copyright="2001,Andrei Alexandrescu"
   License short_name=MIT
 # delete license text since short_name points to global  MIT license
   full_license~

 # use a loop there vvvvvv to clean up that vvvvvvvvvvvvvvvvvvvvvvv in all copyrights
 ! copyright   Files:~/.*/     Copyright=~s/all\s*rights\s*reserved//i

 # defeat spammer by replacing all '@' in emails of 3rdparty files
 # the operation :~/^3party/ loops over all Files entries that match ^3rdparty
 # and modify the copyright entry with a Perl substitution
 ! Files:~/^3rdparty/ Copyright=~s/@/(at)/

Sometimes, you might want to find an entry that spans multiple lines.
You can do this by double quoting the whole value:

 ! Files:"uulib/crc32.h
 uulib/uustring.h" Copyright="2019 John Doe"

=head1 Under the hood

This section explains how cme merges the information from the existing
C<debian/copyright> file (the "old" information) with the information
extracted by I<licensecheck> (the "new" information):

=over

=item *

The old and new information are compared in the form of file lists:

=over

=item *

New file entries are kept as is in the new list.

=item *

When a file entry is found in both old and new lists, the new © and
license short names are checked. If they are unknown, the information
from the old list is copied in the new list.

=item *

Old files entries not found in the new list are deleted.

=back

=item *

File entries are coalesced in the new list to reduce redundancies (this mechanism is explained in this L<blog|https://ddumont.wordpress.com/2015/04/05/improving-creation-of-debian-copyright-file>)

=item *

License entries are created, either attached to Files specification or as global licenses. License text is added for known license (actually known by L<Software::License>)

=item *

Directories (path ending with C</*>) from old list then checked:

=over

=item *

Directory is found in the new list: the old information is clobbered by new information.

=item *

Directory not found in new list but exists: the old information is copied in the new list.

=item *

Directory is not found: the old information is discarded

=back

=item *

Files entries are sorted and the new C<debian/copyright> is generated.

=back

=head1 update

Updates data using the output
L<Dpkg::Copyright::Scanner/scan_files">.

Parameters in C<%args>:

=over

=item quiet

set to 1 to suppress progress messages. Should be used only in tests.

=back

Otherwise, C<%args> is passed to C<scan_files>

=head1 AUTHOR

Dominique Dumont <dod@debian.org>

=cut
