package Debian::Javahelper::Eclipse;

=head1 NAME

Debian::Javahelper::Eclipse - Eclipse Helper Library.

=cut

use strict;
use warnings;
use autodie;

use Exporter qw(import);
use Debian::Debhelper::Dh_Lib qw(doit error rm_files make_symlink_raw_target install_dir);

our %EXPORT_TAGS = (
    'constants' => [qw(EOB_SYM_NAME EOB_BUNDLE_VERSION EOB_SYS_JAR)],
);
our @EXPORT_OK = (@{ $EXPORT_TAGS{'constants'} }, qw(install_zipped_feature));

=head1 SYNOPSIS

 use Debian::Javahelper::Eclipse;

 my @orbitdeps = ();
 push(@orbitdeps, {
     EOB_SYM_NAME => 'org.apache.commons.net',
     EOB_SYS_JAR  => '/usr/share/java/commons-net2.jar'});
 #...
 # Install the feature to "$dropins/$name"
 install_zipped_feature($zip, "$dropins/$name");
 #  and symlink the following orbitdeps.
 install_zipped_feature($zip, "$dropins/$name", @orbitdeps);

=head1 DESCRIPTION

This module is used by the eclipse related javahelpers to share
common code.

Please note this API is not stable and backwards compatibility is not
guaranteed at the current time. Please contact the maintainers if you
are interested in a stable API.

=head2 Definitions

A bundle refers to a jar file. An orbit dependency (a.k.a orbitdep)
is a bundle, which is used by eclipse or one of its features
without being a part of eclipse or said feature.

This module keeps track of bundles via hashes; see the EOB_*
constants for relevant keys (and their expected values).

=head2 Constants

=over 4

=item EOB_SYM_NAME

Key for hashes to fetch the symbolic name of a bundle.

=item EOB_BUNDLE_VERSION

Key for hashes to fetch the version of a bundle.

=item EOB_SYS_JAR

Key for hashes to fetch the path to the system installed jar file.

Only valid for an orbit dependency and cannot be used with manifests.

=back

=head2 Methods

=over 4

=item install_zipped_feature($fzip, $loc[, $orbitdeps[, $package, $needs]])

Unpacks the zipped feature C<$fzip> into C<$loc>, which should be a
subfolder of a dropins folder 
(e.g. /usr/share/eclipse/dropins/emf). This can also be used to
install the feature into a "build environment". In this case
it should be installed into the same folder as the SDK is
(this folder is usually called "SDK").

If C<$orbitdeps> is present, it should be an ARRAY ref containing orbit
dependencies, which will be symlinked after unpacking. This sub only
needs the EOB_SYM_NAME and EOB_SYS_JAR to be set and valid. Orbit
dependencies not present in the installed folder will be ignored, so it
is safe to have unrelated orbit dependencies in the ARRAY ref.

If C<$package> and C<$needs> are present, the former should be the name
of a debian package and the latter a hashref. The sub will populate the
C<$needs> hashref with which orbit dependencies are used by the package.
The C<$needs> hashref can be re-used in multiple calls to this sub.

Keys in C<$needs> will be the path to the orbit jar's real location
(EOB_SYS_JAR) and the value a new hashref. This hashref has as keys the
names of packages and as values 1. The C<$needs> is used by
jh_installeclipse to populate the ${orbit:Depends} variables for packages. 

=back

=cut

use constant {
    EOB_SYM_NAME => 'Bundle-SymbolicName',
    EOB_BUNDLE_VERSION => 'Bundle-Version',
    EOB_SYS_JAR => '!!EOB_SYS_JAR',
};

sub install_zipped_feature{
    my $fzip = shift;
    my $loc = shift;
    my $orbitdeps = shift//[];
    my $package = shift;
    my $needs = shift;
    install_dir($loc);
    doit('unzip', '-qq', '-n', '-d', $loc, $fzip);
    foreach my $orbitdep (@$orbitdeps){
        my $symname = $orbitdep->{${\EOB_SYM_NAME}};
        my $sysjar = $orbitdep->{${\EOB_SYS_JAR}};
        my @matches = glob("$loc/eclipse/plugins/${symname}_*.jar");
        if(scalar(@matches) > 1){
            error("${symname}_*.jar unexpected matched more than one jar; ".
                  'please assert whether this is intended and report a bug '.
                  'against javahelper.');
        }
        foreach my $match (@matches){
            rm_files($match);
            make_symlink_raw_target($sysjar, $match);
            if(defined($needs) && $sysjar =~ m@^/usr/share/java/@o){
                $needs->{$sysjar} = {} unless(exists($needs->{$sysjar}));
                $needs->{$sysjar}{$package} = 1;
            }
        }
    }
    1;
}

1;

=head1 AUTHOR

Niels Thykier <niels@thykier.net>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Niels Thykier

This module is free software; you may redistribute it and/or modify
it under the terms of GNU GPL 2.

=cut
