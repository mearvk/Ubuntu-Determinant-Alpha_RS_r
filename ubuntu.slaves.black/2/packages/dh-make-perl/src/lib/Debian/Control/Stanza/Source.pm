=head1 NAME

Debian::Control::Stanza::Source - source stanza of Debian source package control file

=head1 SYNOPSIS

    my $src = Debian::Control::Stanza::Source->new(\%data);
    print $src;                         # auto-stringification
    print $src->Build_Depends;          # Debian::Dependencies object

=head1 DESCRIPTION

Debian::Control::Stanza::Source can be used for representation and manipulation
of C<Source:> stanza of Debian source package control files in an
object-oriented way. Converts itself to a textual representation in string
context.

=head1 FIELDS

The supported fields for source stanzas are listed below. For more information
about each field's meaning, consult the section named C<Source package control
files -- debian/control> of the Debian Policy Manual at
L<https://www.debian.org/doc/debian-policy/>

Note that real control fields may contain dashes in their names. These are
replaced with underscores.

=over

=item Source

=item Section

=item Priority

=item Maintainer

=item Uploaders

=item DM_Upload_Allowed

=item Build_Conflicts

=item Build_Conflicts_Indep

=item Build_Conflicts_Arch

=item Build_Depends

=item Build_Depends_Indep

=item Build_Depends_Arch

=item Standards_Version

=item Vcs_Browser

=item Vcs_Arch

=item Vcs_Bzr

=item Vcs_Cvs

=item Vcs_Darcs

=item Vcs_Git

=item Vcs_Hg

=item Vcs_Mtn

=item Vcs_Svn

=item Homepage

=item Testsuite

=item Rules_Requires_Root

=back

All Build_... fields are converted into objects of L<Debian::Dependencies>
class upon construction.

=cut

package Debian::Control::Stanza::Source;

use strict;
use warnings;

our $VERSION = '0.116';

use base qw(Debian::Control::Stanza);

use constant fields => qw (
    Source Section Priority Maintainer Uploaders DM_Upload_Allowed
    Build_Conflicts Build_Conflicts_Indep Build_Conflicts_Arch Build_Depends
    Build_Depends_Indep Build_Depends_Arch Standards_Version
    Vcs_Browser Vcs_Arch Vcs_Bzr Vcs_Cvs Vcs_Darcs Vcs_Git Vcs_Hg Vcs_Mtn Vcs_Svn
    Homepage Testsuite Rules_Requires_Root
);

=head1 CONSTRUCTOR

=over

=item new

=item new( { field => value, ... } )

Creates a new L<Debian::Control::Stanza::Source> object and optionally
initializes it with the supplied data.

=back

=head1 SEE ALSO

Debian::Control::Stanza::Source inherits most of its functionality from
L<Debian::Control::Stanza>

=head1 COPYRIGHT & LICENSE

Copyright (C) 2009 Damyan Ivanov L<dmn@debian.org>

This program is free software; you can redistribute it and/or modify it under
the terms of the GNU General Public License version 2 as published by the Free
Software Foundation.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.

=cut

1;
