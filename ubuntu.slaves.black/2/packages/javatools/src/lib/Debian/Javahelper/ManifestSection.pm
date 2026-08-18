package Debian::Javahelper::ManifestSection;

=head1 NAME

Debian::Javahelper::ManifestSection - Javahelper representation of a section in a Jar Manifest

=cut


use strict;
use warnings;
use autodie;

use Exporter qw(import);
our @EXPORT_OK = qw(MAIN_SECTION);

use constant {
    MAIN_SECTION => 'MAIN'
};

=head1 SYNOPSIS

 use Debian::Javahelper::Manifest;
 
 my $main_sec = $manifest->get_section(MAIN_SECTION, 1);
 # set the Main-Class attribute
 $main_sec->set_value('Main-Class', 'org.site.app.AppStarter');
 # read the classpath entry - may return undef if the attribute does not exist.
 my $cp = $main_sec->get_value('Class-Path');
 # same as above except $cp will be '' if the attribute does not exist.
 $cp = $main_sec->get_value('Class-Path',  1);
 # returns a list of [$name, $value] pairs - note $name will be in the original
 # case.
 my @att = $main_sec->get_values();

=head1 DESCRIPTION

This module is used to represent a Section in a Java Manifest.

=head2 Constants

=over 4

=item MAIN_SECTION

A constant denoting the main section of the manifest.

Exported by default.

=back

=head2 Methods

=over 4

=item Debian::Javahelper::ManifestSection->new($name)

Creates a new section - if B<$name> is MAIN_SECTION, then it will set
"Manifest-Version" otherwise it will set "Name" to B<$name>.

Generally you should not need to use this directly! The
L<Debian::Javahelper::Manifest|Manifest> will create sections as they
are needed. There is no support for creating a section and then adding
it to a manifest after wards.

=item $section->set_value($attr, $value)

Sets the value of B<$attr> to B<$value>. If B<$attr> did not exist in
this section then it will be created. B<$value> may not contain
newlines.

Note: B<$attr> exists if an attribute matches B<$attr> ignoring the
case of the two. When B<$attr> is created, the original case will be
stored for later (for writing). Later updates to B<$attr> will not
affect the original case.

=item $section->get_value($attr[, $empty])

Returns the value of B<$attr>, long values are merged into a single
line. B<$attr> is looked up case-insensitively.

Returns B<undef> if B<$attr> is not present in the section, unless
B<$empty> is a truth-value. In this case it will return ''.

=item $section->get_values()

Returns all the values in the section in a list of [$attr, $value]
pairs. "Manifest-Version" and "Name" will appear first in this list if
they appear in this section, the remaining attributes appears in any
order and this order may change.

Modifying the list or the pairs will I<not> affect the attributes in
the section.

Note: The B<$attr> part will be the original case of the attribute.

=back

=cut

sub new{
    my $type = shift;
    my $name = shift;
    my $this = bless({}, $type);
    if($name eq MAIN_SECTION){
        $this->set_value('Manifest-Version', '1.0');
    } else {
        $this->set_value('Name', $name);
    }
    return $this;
}

sub set_value {
    my $this = shift;
    my $name = shift;
    my $value = shift;
    die("Value for $name contains new-lines,") if($value =~ m/[\r]|[\n]/o);
    # Store the name with the original case for later.
    $this->{lc($name)} = [$name, $value];
    1;
}

sub get_value {
    my $this = shift;
    my $name = shift;
    my $empty = shift//0;
    my $val = $this->{lc($name)};
    if(defined($val)){
        return $val->[1];
    }
    return '' if($empty);
    return;
}

sub get_values {
    my $this = shift;
    my @values = ();
    # These go first
    foreach my $var (qw(manifest-version name)){
        my $val = $this->{$var};
        push(@values, $val) if(defined($val));
    }
    # any order is okay for the rest.
    for my $name (sort keys(%{$this})) {
        # we already got these
        next if ($name eq 'manifest-version' or $name eq 'name');
        my $val = $this->{$name};
        push(@values, [$val->[0], $val->[1]]);
    }
    return @values;
}

1;

=head1 SEE ALSO

L<Debian::Javahelper::Manifest(3)> - for how to obtain a section.

=head1 AUTHOR

Niels Thykier <niels@thykier.net>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Niels Thykier

This module is free software; you may redistribute it and/or modify
it under the terms of GNU GPL 2.

=cut
