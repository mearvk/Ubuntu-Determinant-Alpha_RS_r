# Copyright 2019 Bastian Blank <waldi@debian.org>
#
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <https://www.gnu.org/licenses/>.

package Dpkg::Source::Package::V3::Gitarchive;

use v5.28;
use warnings;

our $VERSION = '0.01';

use Cwd qw(getcwd);

use Dpkg::Changelog::Parse qw(changelog_parse);
use Dpkg::Compression::FileHandle;
use Dpkg::ErrorHandling;
use Dpkg::Gettext;
use Dpkg::IPC;
use Dpkg::Source::Package::V3::Gitarchive::Git;
use Dpkg::Source::Package::V3::Gitarchive::GitTreeEntry;
use Dpkg::Source::Package::V3::Gitarchive::Pristine;

use parent qw(Dpkg::Source::Package);

our $CURRENT_MINOR_VERSION = '0';

sub do_extract {
    error(g_("Format '3.0 (gitArchive)' is only used to create source packages"));
}

sub add_file_debian {
    my ($self, $dir, $changelog) = @_;
    my $file = $self->get_basename(1) . '.debian.tar.xz';
    info('creating %s', $file);

    my $git = Dpkg::Source::Package::V3::Gitarchive::Git->new($dir);

    my $patch_blob = $git->make_blob_diff($self->upstream_ref, 'debian-changes');
    my $series_blob = $git->make_blob("debian-changes\n", 'series');
    my $format_blob = $git->make_blob("3.0 (quilt)\n", 'format');

    my %root_tree_content = $git->ls_tree('HEAD');
    my %debian_tree_content = $git->ls_tree($root_tree_content{'debian'}->{oid});
    my %source_tree_content = $git->ls_tree($debian_tree_content{'source'}->{oid});

    # Add debian/patches
    my %patches_tree_content = (
        'debian-changes' => $patch_blob,
        'series' => $series_blob,
    );
    $debian_tree_content{'patches'} = $git->make_tree(\%patches_tree_content, 'patches');

    # Replace debian/source/format
    $source_tree_content{'format'} = $format_blob;
    $debian_tree_content{'source'} = $git->make_tree(\%source_tree_content, 'source');

    my $debian_tree = $git->make_tree(\%debian_tree_content);
    my $debian_commit = $git->make_commit($debian_tree->{oid}, $changelog->{date});

    my $fh = Dpkg::Compression::FileHandle->new(filename => $file);
    $fh->write($git->archive($debian_commit, 'debian/'));
    close $fh;
    $self->add_file($file);
}

sub add_file_upstream {
    my ($self, $dir) = @_;
    my $file = $self->get_basename . '.orig.tar.xz';
    info('creating %s', $file);
    my $pristine = Dpkg::Source::Package::V3::Gitarchive::Pristine->new($dir);
    $pristine->checkout($file);
    $self->add_file($file);
}

sub upstream_ref {
    my ($self) = @_;
    my $v = Dpkg::Version->new($self->{fields}->{'Version'});
    return 'upstream/' . $v->as_string(omit_epoch => 1, omit_revision => 1);
}

sub can_build {
    my ($self, $dir) = @_;
    my $v = Dpkg::Version->new($self->{fields}->{'Version'});
    return (0, g_('non-native package version does not contain a revision'))
        if $v->is_native();
    return 1;
}

sub do_build {
    my ($self, $dir) = @_;

    my $changelog = changelog_parse(
        file => "$dir/debian/changelog",
    );

    # Update real target format
    $self->{fields}{'Format'} = '3.0 (quilt)';
    # Add all files
    $self->add_file_upstream($dir);
    $self->add_file_debian($dir, $changelog);
}

sub do_commit {
    my ($self, $dir) = @_;

    my $git = Dpkg::Source::Package::V3::Gitarchive::Git->new($dir);
    my $pristine = Dpkg::Source::Package::V3::Gitarchive::Pristine->new($dir);

    my $file = $self->get_basename . '.orig.tar.xz';

    my $list;
    $pristine->ls(\$list);
    while (<$list>) {
        chomp $_;
        return 0 if $file eq $_;
    }

    info('creating %s', $file);

    my $v = Dpkg::Version->new($self->{fields}->{'Version'});
    my $vs = $v->as_string(omit_epoch => 1);

    my $fh = Dpkg::Compression::FileHandle->new(filename => $file);
    $fh->write($git->archive($self->upstream_ref, $self->{fields}->{'Source'} . '_' . $vs . '/'));
    close $fh;

    $pristine->commit($file);
}

1;
