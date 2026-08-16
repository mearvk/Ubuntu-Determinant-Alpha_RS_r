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

package Dpkg::Source::Package::V3::Gitarchive::Pristine;

use v5.28;
use warnings;

use Cwd qw(abs_path);
use Dpkg::IPC qw(spawn);

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

sub checkout {
    my ($self, $file) = @_;
    my @exec = ('pristine-lfs', 'checkout', '-o', abs_path('.'), $file);
    $self->_spawn(exec => \@exec);
}

sub commit {
    my ($self, $file) = @_;
    my @exec = ('pristine-lfs', 'commit', abs_path($file));
    $self->_spawn(exec => \@exec);
}

sub ls {
    my ($self, $pipe) = @_;
    my @exec = ('pristine-lfs', 'list');
    $self->_spawn(exec => \@exec, to_pipe => $pipe);
}

1;
