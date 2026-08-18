package Debian::Javahelper::Manifest;

=head1 NAME

Debian::Javahelper::Manifest - Javahelper representation of a Jar Manifest

=cut

use strict;
use warnings;
use autodie;

use Exporter qw(import);

use Debian::Javahelper::ManifestSection qw(MAIN_SECTION);

# pass it on to others.
our @EXPORT_OK = qw(MAIN_SECTION);

=head1 SYNOPSIS

 use Debian::Javahelper::Java;
 
 my $manifest = ...;
 my $main_sec = $manifest->get_section(MAIN_SECTION);
 # Create if it does not exist.
 my $file_sec = $manifest->get_section("java/lang/Object.class", 1);

=head1 DESCRIPTION

This module is used to represent a Java Manifest.

=head2 Constants

=over 4

=item MAIN_SECTION

A constant denoting the main section of the manifest.

Exported by default.

=back

=head2 Methods

=over 4

=item Debian::Javahelper::Manifest->new()

Creates a new manifest. It will only contain the main section with the
Manifest-Version attribute.

=item $manifest->get_section($name[, $create])

Returns the section denoted by B<$name>. If this section does not
exist, then it will either return B<undef> or (if B<$create> is a
truth-value) create a new empty section with that name.

Use the MAIN_SECTION constant to access the main section of the
manifest.

=item $manifest->get_sections()

Returns a list of all sections in B<$manifest>. The main section will
always be the first in the list, and the remaining sections will be
sorted in name order.

Modifying the list will not change which sections are present in
B<$manifest>, but modifying a section in this list will also update
the section in the manifest.

=item $manifest->merge($other)

Merge all entries in B<$other> into B<$manifest>. All sections in
B<$other> will be added to B<$manifest> if they are not already
present.

If an attribute in a given section is only present in one of the two
manifests, then that attribute and its value will be in B<$manifest>
after merge returns.

If the attribute in a given section is present in both manifests, then
the value from B<$other> will be used.

This can be used to make a deep copy a manifest:

 my $copy = Debian::Javahelper::Manifest->new();
 $copy->merge($orig);

=back

=cut

sub new {
    my $type = shift;
    my $this = bless({}, $type);
    # create the main section
    $this->get_section(MAIN_SECTION, 1);
    return $this;
}

sub get_section {
    my $this = shift;
    my $sname = shift;
    my $create = shift//0;
    my $sec = $this->{$sname};
    if(!defined($sec) && $create){
        $sec = Debian::Javahelper::ManifestSection->new($sname);
        $this->{$sname} = $sec;
    }
    return $sec;
}

sub get_sections {
    my $this = shift;
    my @sections = ();
    foreach my $name (sort(keys %$this)) {
        next if($name eq MAIN_SECTION);
        push(@sections, $this->{$name});
    }
    # There is always a main section at the front
    unshift(@sections, $this->get_section(MAIN_SECTION, 1));
    return @sections;
}

sub merge {
    my $this = shift;
    my $other = shift;
    while( my ($osname, $osec) = each(%$other) ){
        my $tsec = $this->get_section($osname, 1);
        foreach my $val ($osec->get_values()){
            $tsec->set_value($val->[0], $val->[1]);
        }
    }
    1;
}

1;

=head1 SEE ALSO

L<Debian::Javahelper::Java(3)> - had parse/write methods for manifests.
L<Debian::Javahelper::ManifestSection(3)> - for how sections are handled.

=head1 AUTHOR

Niels Thykier <niels@thykier.net>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Niels Thykier

This module is free software; you may redistribute it and/or modify
it under the terms of GNU GPL 2.

=cut

