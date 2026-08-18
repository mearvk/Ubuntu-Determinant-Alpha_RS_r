package Debian::Javahelper::Java;

=head1 NAME

Debian::Javahelper::Java - Javahelper core library.

=cut

use strict;
use warnings;
use autodie;

use Cwd 'abs_path';
use Exporter qw(import);
use File::Spec;

use Debian::Javahelper::Manifest();

our @EXPORT_OK = qw(scan_javadoc
                    find_package_for_existing_files
                    write_manifest_fd
                    parse_manifest_fd
);

=head1 SYNOPSIS

 use Debian::Javahelper::Java;
 
 my @paths = scan_javadoc("/usr/share/doc/libfreemarker-doc/api/");
 print "Freemarker is linked to the following APIs: \n - ",
       join("\n - ", @paths), "\n";
 my @packnames = find_package_for_existing_files("/bin/ls",
                 "/bin/bash");
 print "/bin/ls and /bin/bash are installed via: ",
       join(", ", @packnames), "\n";

=head1 DESCRIPTION

This module is used by various javahelpers to share common code.

Please note this API is not stable and backwards compatibility is not
guaranteed at the current time. Please contact the maintainers if you
are interested in a stable API.

=head2 Methods

=over 4

=item scan_javadoc($path)

Scans the javadoc at B<$path> and returns a list of javadocs it is
linked to on the system.

Currently it ignores all javadocs linked via other locations than
I</usr/share/doc> and it also makes an assumption that the linked
javadoc is in /usr/share/doc/<package>/<dir-or-symlink>. Of course,
all Java Policy compliant packages provide their javadoc from there.

If /usr/share/doc/<package>/<dir-or-symlink> appears to be a symlink,
then it is followed (except for default-jdk-doc).

=item find_package_for_existing_files(@files)

Consults L<dpkg(1)> to see which packages provides B<@files> and
returns this list. All entries in B<@files> must exists (but is
not required to be files) and should not be used on a directory.

Furthermore all entries must be given with absolute path.

=item parse_manifest_fd($fd, $filename)

Parses a manifest from B<$fd>, which must be a readable filehandle,
and returns a
L<Debian::Javahelper::Manifest|Debian::Javahelper::Manifest>.

B<$filename> is only used to report parsing errors and should be
something that identifies the source of B<$fd>.

=item write_manifest_fd($manifest, $fd, $filename)

Writes B<$manifest> to the writable filehandle B<$fd>. B<$manifest>
must be a
L<Debian::Javahelper::Manifest|Debian::Javahelper::Manifest>.

B<$filename> is only used to report errors and should be something
that identifies B<$fd>.

=item write_manifest_section_fd($section, $fd, $filename)

Writes B<$section> to the writable filehandle B<$fd>. B<$section>
must be a
L<Debian::Javahelper::ManifestSection|Debian::Javahelper::ManifestSection>.

B<$filename> is only used to report errors and should be something
that identifies B<$fd>.

NB: Helper - Not exported.

=item slurp_file($file)

Reads all lines in B<$file> and returns them as a list.

NB: Helper - Not exported.

=back

=cut

sub scan_javadoc{
    my $docloc = shift;
    my %phash;
    my @packages = slurp_file("$docloc/package-list");
    # For each package in package-list (replacing "." with "/")
    foreach my $pack ( map { s@\.@/@go; $_; } @packages) {
        if ('unnamed package' eq $pack) {
            next;
        }
        opendir(my $dir, "$docloc/$pack");
        # For each html file in $dir
        foreach my $file ( grep { m/\.html$/iox } readdir($dir)){
            open(my $htfile, '<', "$docloc/$pack/$file");
            while( my $line = <$htfile> ){
                my $target;
                my $packname;
                my $apif;
                next unless($line =~ m@ href=" (/usr/share/doc/[^.]++\.html) @oxi);
                $target = $1;
                $target =~ m@/usr/share/doc/([^/]++)/([^/]++)/@o;
                $packname = $1;
                $apif = $2;
                if(!defined($packname)){
                    print STDERR "Ignoring weird URL target ($target).\n";
                    next;
                }
                $phash{"/usr/share/doc/$packname/$apif"} = 1;
            }
            close($htfile);
        }
        closedir($dir);
    }
    return keys(%phash);
}

sub slurp_file{
    my $file = shift;
    my @data;
    open(my $handle, '<', $file);
    while(my $line = <$handle> ){
        chomp($line);
        $line =~ s/\r$//o;
        push(@data, $line);
    }
    close($handle);
    return @data;
}

sub find_package_for_existing_files{
    my %pkgs;
    my %files;
    foreach my $file (@_){
        die("$file must be given with absolute path.") unless( $file =~ m@^/@o );
        die("$file does not exist") unless( -e $file );
        $file =~ s@/{2,}@/@og;
        $file =~ s@[/]+$@@og;
        $files{$file} = 1;
    }
    open(my $dpkg, '-|', 'dpkg', '-S',  @_);
    while( my $line = <$dpkg> ){
        my ($pkg, $file) = split(/:\s++/ox, $line);
        chomp($file);
        $pkgs{$pkg} = 1 if(exists($files{$file}));
    }
    close($dpkg);
    return keys(%pkgs);
}

sub parse_manifest_fd{
    my $fd = shift;
    my $name = shift;
    my $manifest = Debian::Javahelper::Manifest->new();
    my $sec = $manifest->get_section(Debian::Javahelper::Manifest::MAIN_SECTION, 1);
    my $atname = '';
    my $atval = '';
    while( my $line = <$fd> ){
        $line =~ s/[\r]?[\n]$//og;
        if($line =~ m/^ /o){
            # extension to a value.
            die("Unexpected \"extension line\" in $name,") unless($atname);
            $atval .= substr($line, 1);
            next;
        }
        if($line ne ''){
            if($atname){
                if(!defined($sec)){
                    $sec = $manifest->get_section($atval, 1);
                } else {
                    $sec->set_value($atname, $atval);
                }
            }
            ($atname, $atval) = split(/ :\s /ox, $line, 2);
            if(!$atval){
                die("Expected <attr>: <val> pair in $name,")
                    unless($line =~ m/ :\s /ox);
                $atval = '';
            }
            if(!defined($sec)){
                die("A section must start with the Name attribute in $name,")
                    unless(lc($atname) eq 'name');
            }
            next;
        }
        if($atname) {
            if(!defined($sec)){
                $sec = $manifest->get_section($atval, 1);
            } else {
                $sec->set_value($atname, $atval);
            }
        }
        $atname = '';
        $sec = undef;
    }

    $sec->set_value($atname, $atval) if($atname);
    return $manifest;
}

sub write_manifest_section_fd{
    my $sec = shift;
    my $fd = shift;
    my $name = shift;
    # return manifest-version and name first
    foreach my $entry ($sec->get_values()) {
        my $line = join(': ', @$entry);
        # Extend long lines.  Technically this is incorrect since the
        # rules says "bytes" and not "characters".
        #
        # (for future reference this is: Insert '\n ' after every 72
        # chars, but only if there is a 73rd character following them)
        #
        # If you change this, remember to change jh_build as well,
        # which also have this.
        $line =~ s/(.{72})(?=.)/$1\n /go;
        print {$fd} $line, "\n";
    }
    print $fd "\n";
    1;
}

sub write_manifest_fd{
    my $manifest = shift;
    my $fd = shift;
    my $name = shift;
    # returns main section first.
    foreach my $sec ($manifest->get_sections()){
        write_manifest_section_fd($sec, $fd, $name);
    }
    # must end with two empty lines.
    print $fd "\n";
    1;
}

# For length
# s/(.{$len})/$1\n /g; s/^ \n(\w)/$1/g

1;
__END__

=head1 SEE ALSO

L<Debian::Javahelper::Manifest(3)>
L<Debian::Javahelper::ManifestSection(3)>

=head1 AUTHOR

Niels Thykier <niels@thykier.net>

=head1 COPYRIGHT AND LICENSE

Copyright 2010 by Niels Thykier

This module is free software; you may redistribute it and/or modify
it under the terms of GNU GPL 2.

=cut
