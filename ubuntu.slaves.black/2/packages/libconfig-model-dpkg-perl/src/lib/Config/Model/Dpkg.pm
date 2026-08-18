package Config::Model::Dpkg;

use strict;
use warnings;

1;

=pod

=head1 NAME

Config::Model::Dpkg - Edit and validate Dpkg source files

=head1 SYNOPSIS

=head2 invoke editor

The following command must be run in a package source
directory. When run, L<cme> will load most files from C<debian>
directory and launch a graphical editor:

 cme edit dpkg

You can choose to edit only C<debian/control> or C<debian/copyright>:

 cme edit dpkg-control
 cme edit dpkg-copyright

Or edit debian patches headers, all at once:

 cme edit dpkg-patches # note patches with 'es'

Or one patch at a time:

 cme edit dpkg-patch debian/patches/foo

Patch can be specified using the patch name:

 cme edit dpkg-patch foo

=head2 Just check dpkg files

You can also use L<cme> to run sanity checks on the source files:

 cme check dpkg

=head2 Fix warnings

When run, cme may issue several warnings regarding the content of your file.
You can choose to  fix (most of) these warnings with the command:

 cme fix dpkg

=head2 check and arbitrary file

You can specify another file to check:

  cme check dpkg-copyright foobar

This applies only to C<dpkg-control>, C<dpkg-copyright> or C<dpkg-patch>.

=head2 programmatic

This code snippet will change the maintainer address in control file:

 use Config::Model ;
 use Log::Log4perl qw(:easy) ;
 my $model = Config::Model -> new ( ) ;
 my $inst = $model->instance (root_class_name => 'Dpkg');
 $inst -> config_root ->load("control source Maintainer=foo@bedian.arg") ;
 $inst->write_back() ;

=head1 DESCRIPTION

This module provides a configuration editor (and models) for the
files of a Debian source package. (i.e. most of the files contained in the
C<debian> directory of a source package).

This module can also be used to modify safely the
content of these files from a Perl programs.

=head1 user interfaces

As mentioned in L<cme>, several user interfaces are available:

=over

=item *

A graphical interface is proposed by default if L<Config::Model::TkUI> is installed.

=item *

A L<Fuse> virtual file system with option C<< cme fusefs dpkg -fuse_dir <mountpoint> >>
if L<Fuse> is installed (Linux only)

=back

=head2 package dependency checks

Package dependencies are checked on several points:

=over

=item *

Whether the package is available in Debian (from sid to old-stable)

=item *

If the package is a known virtual package. Known means listed in Debian packaging manual or known by the
author. Feel free to log a bug against libconfig-model-dpkg-perl if a virtual package is missing. But please
don't log a bug if the virtual package is used only during a transition.

=item *

If a package older that the required version are available in Debian (from sid to old-stable). If not, L<cme>
will offer you the possibility to clean up the versioned dependency with C<cme fix dpkg> command.

=item *

The syntax of the dependency (including version requirement and arch specification).

=item *

Consistency of alternate dependency for Perl libraries

=back

These checks only generate warnings. Most of these checks can be fixed with C<cme fix dpkg> command.


=head1 Examples

=head2 Migrate old package file

Most of old syntax can be automatically migrated to newer parameters with

  cme migrate dpkg

This migration can be limited to C<control> or C<copyright> files:

  cme migrate dpkg-control
  cme migrate dpkg-copyright

Restore GPL summary to default value:

  cme modify dpkg-copyright ~~ 'License:GPL text~'

Dump copyright file content in a format usable with C<cme modify>:

  $ cme dump dpkg-copyright
  Comment="Native package. This package is a spin-off from
  libconfig-model-perl. Upstream (who is also the debian packager)
  decided to create a Debian native package for the Debian specific
  parts of Config::Model"
  Files:"*"
    Copyright="2005-2013, Dominique Dumont <dod@debian.org>"
    License
      short_name=LGPL-2.1+ - -
  License:LGPL-2.1+
    text="   This program is free software; you can redistribute it and/or modify
     it under the terms of the GNU Lesser General Public License as
     published by the Free Software Foundation; either version 2.1 of the
     License, or (at your option) any later version.
     On Debian GNU/Linux systems, the complete text of version 2.1 of the GNU
     Lesser General Public License can be found in `/usr/share/common-licenses/LGPL-2.1'" - -

=head2 modify a value with the command line:

 cme modify dpkg-copyright ~~ 'Comment="Modified with cme"'

Or apply more systematic changes. This example updates copyright years for all
C<Files> entries in C<debian/copyright>:

 cme modify dpkg-copyright ~~ 'Files:~/./ Copyright=~"s/2013/2014/"'

=head2 remove an uploader from control files

 cme modify dpkg control source Uploaders:-~/johndoe/

or

 cme modify dpkg-control ~~ source Uploaders:-~/dod/

If you want to remove a guy named Ian, you'll have to be a little more specific to avoid removing
all debian developers:

 cme modify dpkg-control ~~ source Uploaders:-="Ian Smith<iansmith@debian.org>"

=head2 add a new uploader

The quotes are required otherwise bash will complain. These 2 commands give the same results:

 cme modify dpkg-control ~~ 'source Uploaders:<"John Doe<johndoe@foo.com>"'
 cme modify dpkg-control ~~ 'source Uploaders:.push("John Doe<johndoe@foo.com>")'

Add an uploader to a sorted list of Uploaders (yes, insort, with a 'o', not "insert" with a 'e'):

 cme modify dpkg-control ~~ 'source Uploaders:.insort("John Doe<johndoe@foo.com>")'

The above command make sense only if the list is sorted. Let's sort the list of uploaders:

 cme modify dpkg-control ~~ 'source Uploaders:@'
 cme modify dpkg-control ~~ 'source Uploaders:.sort'

The 2 commands can be combined:

 cme modify dpkg-control ~~ 'source Uploaders:.sort Uploaders:.insort("John Doe<johndoe@foo.com>")'

The C<modify> command of L<cme> uses the syntax defined by L<Config::Model::Loader>.
See L<Config::Model::Loader/"load string syntax">

=head1 BUGS

Config::Model design does not really cope well with some details of
L<Debian patch header specification|http://dep.debian.net/deps/dep3/> (aka DEP-3).

Description and subject are both authorized, but only B<one> of them is
required and using the 2 is forbidden. So, both fields are accepted,
but subject is stored as description in the configuration tree.
C<cme fix> or C<cme edit> will write back a description field.

=head1 CONTRIBUTORS

In alphabetical order:

 Andrej Shadura
 Axel Beckert
 Bas Couwenberg
 Cyrille Bollu
 Gregor Herrmann
 Guillem Jover
 Josh Triplett
 Paul Wise
 Ross Vandegrift
 Salvatore Bonaccorso
 Walter Lozano
 Xavier Guimard

Thanks all.

=head1 AUTHOR

Dominique Dumont, (dod at debian dot org)

=head1 SEE ALSO

=over

=item *

L<cme>

=item *

L<Config::Model>

=item *

http://github.com/dod38fr/config-model/wiki/Using-config-model

=back

