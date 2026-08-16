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

package Dpkg::Source::Package::V3::Gitarchive::Git;

use v5.28;
use warnings;

use Dpkg::IPC qw(spawn);
use Dpkg::Source::Package::V3::Gitarchive::GitTreeEntry;

sub new {
    my ($this, $dir) = @_;
    my $class = ref($this) || $this;
    my $self = {
        spawn_opts => {
            chdir => $dir,
            delete_env => [
# Remove env variables that changes how git detects reposity locations
                'GIT_ALTERNATE_OBJECT_DIRECTORIES',
                'GIT_DIR',
                'GIT_INDEX_FILE',
                'GIT_OBJECT_DIRECTORY',
                'GIT_WORK_TREE',
            ],
            timeout => 10,
            wait_child => 1,
        },
    };
    bless $self, $class;
}

sub _spawn {
    my ($self, %opts) = @_;
    my %opts_merged = (%{$self->{spawn_opts}}, %opts);
    spawn(%opts_merged);
}

sub archive {
    my ($self, $oid, $prefix) = @_;
    my $archive;
    my @exec = ('git', 'archive', '--format', 'tar', '--prefix', $prefix, $oid);
    $self->_spawn(exec => \@exec, to_string => \$archive);
    return $archive;
}

sub make_blob {
    my ($self, $content, $name) = @_;
    my $oid;
    my @exec = ('git', 'hash-object', '-w', '--stdin');
    $self->_spawn(exec => \@exec, from_string => \$content, to_string => \$oid);
    chomp $oid;
    return Dpkg::Source::Package::V3::Gitarchive::GitTreeEntry->new('100640', 'blob', $oid, $name);
}

sub make_blob_diff {
    my ($self, $upstream_ref, $name) = @_;
    my $diff;
    my @exec = ('git', 'diff', $upstream_ref, '--', '.', ':!debian');
    $self->_spawn(exec => \@exec, to_string => \$diff);
    return $self->make_blob($diff, $name);
}

sub make_commit {
    my ($self, $tree, $date) = @_;
    my %env = (
        GIT_AUTHOR_NAME => 'dpkg',
        GIT_AUTHOR_EMAIL => 'Debian',
        GIT_AUTHOR_DATE => $date,
        GIT_COMMITTER_NAME => 'dpkg',
        GIT_COMMITTER_EMAIL => 'Debian',
        GIT_COMMITTER_DATE => $date,
    );
    my $oid;
    my @exec = ('git', 'commit-tree', '-m', 'dpkg', $tree);
    $self->_spawn(exec => \@exec, env => \%env, to_string => \$oid);
    chomp $oid;
    return $oid;
}

sub ls_tree {
    my ($self, $oid) = @_;
    my @exec = ('git', 'ls-tree', $oid);
    my $tree_text;
    $self->_spawn(exec => \@exec, to_string => \$tree_text);
    my %tree;
    for (split(/\n/, $tree_text)) {
        my $e = Dpkg::Source::Package::V3::Gitarchive::GitTreeEntry->from_string($_);
        $tree{$e->{name}} = $e;
    }
    return %tree;
}

sub make_tree {
    my ($self, $tree, $name) = @_;
    my $oid;
    my @exec = ('git', 'mktree');
    my $tree_text;
    foreach my $e (values %{$tree}) {
        $tree_text .= $e->to_string . "\n";
    }
    $self->_spawn(exec => \@exec, from_string => \$tree_text, to_string => \$oid);
    chomp $oid;
    return Dpkg::Source::Package::V3::Gitarchive::GitTreeEntry->new('040000', 'tree', $oid, $name);
}

1;
