# Copyright (C) 2011, Stefano Rivera <stefanor@debian.org>
#
# Permission to use, copy, modify, and/or distribute this software for any
# purpose with or without fee is hereby granted, provided that the above
# copyright notice and this permission notice appear in all copies.
#
# THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
# WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
# MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
# ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
# WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
# ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
# OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.

package Debian::DistroInfo;

=head1 NAME

Debian::DistroInfo - provides information about Ubuntu's and Debian's distributions

=cut

use strict;
use warnings;

use Exporter;
our @EXPORT_OK = qw(convert_date);

our $VERSION = '0.2.2';

my $outdated_error = "Distribution data outdated. "
    . "Please check for an update for distro-info-data. "
    . "See /usr/share/doc/distro-info-data/README.Debian for details.";

sub convert_date {
    my ($date) = @_;
    my @parts = split(/-/, $date);
    if (scalar(@parts) == 2) {
        $date .= '-01';
    }
    $date = Time::Piece->strptime($date, "%Y-%m-%d");
    if (scalar(@parts) == 2) {
        $date->add_months(1);
        $date -= Time::Piece->ONE_DAY;
    }
    return $date;
}


{
    package DistroInfo;

    use Time::Piece;

    sub _get_data_dir {
        return '/usr/share/distro-info';
    }

    sub new {
        my ($class, $distro) = @_;
        my @rows;
        my $self = {'distro' => $distro,
                    'rows' => \@rows,
                    'date' => Time::Piece->new(),
                   };
        open(my $fh, '<', $class->_get_data_dir . "/$distro.csv")
          or die "Unable to open ${distro}'s data file.";

        my $line = <$fh>;
        chomp($line);
        my @header = split(/,/, $line);

        while (<$fh>) {
            chomp;
            my @raw_row = split (/,/);
            my %row;
            for my $col (@header) {
                $row{$col} = shift(@raw_row) or undef;
            }
            for my $col ('created', 'release', 'eol', 'eol-esm', 'eol-lts',
                         'eol-elts', 'eol-server') {
                if(defined($row{$col})) {
                    $row{$col} = Debian::DistroInfo::convert_date($row{$col});
                }
            }
            push(@rows, \%row);
        }
        close($fh);

        bless($self, $class);
        return $self;
    }

    sub all {
        my ($self) = @_;
        my @all;
        my @rows = @{$self->{'rows'}};
        for my $row (@rows) {
            push(@all, $row->{'series'})
        }
        return @all;
    }

    sub _avail {
        my ($self, $date) = @_;
        my @avail;
        for my $row (@{$self->{'rows'}}) {
            push(@avail, $row) if $date > $row->{'created'}
        }
        return @avail;
    }

    sub codename {
        my ($self, $release, $date, $default) = @_;
        return $release;
    }

    sub version {
        my ($self, $codename, $default) = @_;
        for my $row (@{$self->{'rows'}}) {
            if ($row->{'codename'} eq $codename
                || $row->{'series'} eq $codename) {
                return $row->{'version'};
            }
        }
        return $default;
    }

    sub devel {
        my ($self, $date) = @_;
        $date = $self->{'date'} if (!defined($date));
        my @distros;
        for my $row ($self->_avail($date)) {
            if (!defined($row->{'release'})
                  || ($date < $row->{'release'}
                      && (!defined($row->{'release'})
                          || $date <= $row->{'eol'}))) {
                push(@distros, $row);
            }
        }
        if (scalar(@distros) == 0) {
            warn $outdated_error;
            return 0;
        }
        return $distros[-1]{'series'};
    }

    sub stable {
        my ($self, $date) = @_;
        $date = $self->{'date'} if (!defined($date));
        my @distros;
        for my $row ($self->_avail($date)) {
            if (defined($row->{'release'}) && $date >= $row->{'release'}
                  && (!defined($row->{'eol'}) || $date <= $row->{'eol'})) {
                push(@distros, $row);
            }
        }
        if (scalar(@distros) == 0) {
            warn $outdated_error;
            return 0;
        }
        return $distros[-1]{'series'};
    }

    sub supported {
        die "Not implemented";
    }

    sub valid {
        my ($self, $codename) = @_;
        return !! grep {$_ eq $codename} $self->all;
    }

    sub unsupported {
        my ($self, $date) = @_;
        $date = $self->{'date'} if (!defined($date));
        my @supported = $self->supported($date);
        my @unsupported = ();
        for my $row ($self->_avail($date)) {
            push(@unsupported, $row->{'series'}) if ! grep {$_ eq $row->{'series'}} @supported;
        }
        return @unsupported;
    }
}

{
    package DebianDistroInfo;
    use parent -norequire, 'DistroInfo';

    sub new {
        my ($class) = @_;
        my $self = $class->SUPER::new('debian');
        bless($self, $class);
        return $self;
    }

    sub codename {
        my ($self, $release, $date, $default) = @_;
        $date = $self->{'date'} if (!defined($date));
        return $self->devel($date) if ($release eq 'unstable');
        return $self->testing($date) if ($release eq 'testing');
        return $self->stable($date) if ($release eq 'stable');
        return $self->old($date) if ($release eq 'oldstable');
        return $default;
    }

    sub devel {
        my ($self, $date) = @_;
        $date = $self->{'date'} if (!defined($date));
        my @distros;
        for my $row ($self->_avail($date)) {
            if (!defined($row->{'release'})
                  || ($date < $row->{'release'}
                      && !defined($row->{'eol'}) || $date <= $row->{'eol'})) {
                push(@distros, $row);
            }
        }
        if (scalar(@distros) < 2) {
            warn $outdated_error;
            return 0;
        }
        return $distros[-2]{'series'};
    }

    sub old {
        my ($self, $date) = @_;
        $date = $self->{'date'} if (!defined($date));
        my @distros;
        for my $row ($self->_avail($date)) {
            if (defined($row->{'release'}) && $date >= $row->{'release'}) {
                push(@distros, $row);
            }
        }
        if (scalar(@distros) < 2) {
            warn $outdated_error;
            return 0;
        }
        return $distros[-2]{'series'};
    }

    sub supported {
        my ($self, $date) = @_;
        $date = $self->{'date'} if (!defined($date));
        my @distros;
        for my $row ($self->_avail($date)) {
            if (!defined($row->{'eol'}) || $date <= $row->{'eol'}) {
                push(@distros, $row->{'series'});
            }
        }
        return @distros;
    }

    sub supported_lts {
        my ($self, $date) = @_;
        $date = $self->{'date'} if (!defined($date));
        my @distros;
        for my $row ($self->_avail($date)) {
            if (defined($row->{'eol'}) && $date > $row->{'eol'}
                    && defined($row->{'eol-lts'}) && $date <= $row->{'eol-lts'}) {
                push(@distros, $row->{'series'});
            }
        }
        return @distros;
    }

    sub supported_elts {
        my ($self, $date) = @_;
        $date = $self->{'date'} if (!defined($date));
        my @distros;
        for my $row ($self->_avail($date)) {
            if (defined($row->{'eol-lts'}) && $date > $row->{'eol-lts'}
                    && defined($row->{'eol-elts'}) && $date <= $row->{'eol-elts'}) {
                push(@distros, $row->{'series'});
            }
        }
        return @distros;
    }

    sub testing {
        my ($self, $date) = @_;
        $date = $self->{'date'} if (!defined($date));
        my @distros;
        for my $row ($self->_avail($date)) {
            if ((!defined($row->{'release'}) && $row->{'version'})
                  || (defined($row->{'release'}) && $date < $row->{'release'}
                      && (!defined($row->{'eol'}) || $date <= $row->{'eol'}))) {
                push(@distros, $row);
            }
        }
        if (scalar(@distros) == 0) {
            warn $outdated_error;
            return 0;
        }
        return $distros[-1]{'series'};
    }

    sub valid {
        my ($self, $codename) = @_;
        my %codenames = (
            'unstable' => 1,
            'testing' => 1,
            'stable' => 1,
            'oldstable' => 1,
        );
        return $self->SUPER::valid($codename) || exists($codenames{$codename});
    }
}

{
    package UbuntuDistroInfo;
    use parent -norequire, 'DistroInfo';

    sub new {
        my ($class) = @_;
        my $self = $class->SUPER::new('ubuntu');
        bless($self, $class);
        return $self;
    }

    sub lts {
        my ($self, $date) = @_;
        $date = $self->{'date'} if (!defined($date));
        my @distros;
        for my $row ($self->_avail($date)) {
            if ($row->{'version'} =~ m/LTS/ && $date >= $row->{'release'}
                  && $date <= $row->{'eol'}) {
                push(@distros, $row);
            }
        }
        if (scalar(@distros) == 0) {
            warn $outdated_error;
            return 0;
        }
        return $distros[-1]{'series'};
    }

    sub is_lts {
        my ($self, $codename) = @_;
        for my $row (@{$self->{'rows'}}) {
            if ($row->{'series'} eq $codename) {
                return ($row->{'version'} =~ m/LTS/);
            }
        }
        return 0;
    }

    sub supported {
        my ($self, $date) = @_;
        $date = $self->{'date'} if (!defined($date));
        my @distros;
        for my $row ($self->_avail($date)) {
            if ($date <= $row->{'eol'}
                  || (defined($row->{'eol-server'}) && $date <= $row->{'eol-server'})) {
                push(@distros, $row->{'series'});
            }
        }
        return @distros;
    }

    sub supported_esm {
        my ($self, $date) = @_;
        $date = $self->{'date'} if (!defined($date));
        my @distros;
        for my $row ($self->_avail($date)) {
            if (defined($row->{'eol-esm'}) && $date <= $row->{'eol-esm'}) {
                push(@distros, $row->{'series'});
            }
        }
        return @distros;
    }
}
1;
# vi: set et sta sw=4 ts=4:
