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

package Dpkg::Source::Package::V3::Gitarchive::GitTreeEntry;

use v5.28;
use warnings;

sub new {
    my ($this, $mode, $type, $oid, $name) = @_;
    my $class = ref($this) || $this;
    my $self = {
        name => $name,
        mode => $mode,
        type => $type,
        oid => $oid,
    };
    bless $self, $class;
}

sub from_string {
    my ($this, $string) = @_;
    my ($info, $name) = split /\t/, $string;
    my ($mode, $type, $oid) = split / /, $info;
    return $this->new($mode, $type, $oid, $name);
}

sub to_string {
    my ($self) = @_;

    return "$self->{mode} $self->{type} $self->{oid}\t$self->{name}";
}

1;
