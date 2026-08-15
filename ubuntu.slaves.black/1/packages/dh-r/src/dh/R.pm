# A debhelper build system for R

package Debian::Debhelper::Buildsystem::R;

use feature say;
use strict;
use Cwd;
use Dpkg::Control;
use Dpkg::Control::Info;
use Dpkg::Control::Tests;
use Dpkg::Changelog::Parse;
use Debian::Debhelper::Dh_Lib;
use Dpkg::Deps qw(deps_concat deps_parse);
use base 'Debian::Debhelper::Buildsystem';
# use LWP::Simple;
use File::Which;

sub DESCRIPTION {
    "R buildsystem"
}

sub new {
    my $class=shift;
    my $this=$class->SUPER::new(@_);
    $this->enforce_in_source_building();
    return $this;
}

sub check_auto_buildable {
    # R packages are auto-buildable if they contain ./DESCRIPTION in the
    # source package

    my $this=shift;
    return -e $this->get_sourcepath("DESCRIPTION") ? 1 : 0;
}

sub parse_description {
    my $this=shift;
    my $desc = Dpkg::Control->new(type => Dpkg::Control::CTRL_UNKNOWN);
    $desc->load($this->get_sourcepath("DESCRIPTION"));
    return $desc;
}

sub parse_depends {
    # try and convert R package dependencies in DESCRIPTION into a
    # list of debian package dependencies

    my $field = shift;
    my $rawtext = shift;
    my %apthash = %{shift()};
    my @rdeps = deps_parse($rawtext)->get_deps();
    my @deps;

    # r namespaces included in r-base-core which we shouldn't try and
    # generate dependencies for
    my %builtins;
    @builtins{qw/base compiler datasets grDevices graphics grid methods
                 parallel splines stats stats4 tcltk tools translations utils/} = ();

    foreach my $d (@rdeps) {
        if (exists $builtins{$d->{package}}) {
            # ignore dependencies on built-in namespaces
            next;
        }

        my $pkg = lc $d->{package};
        my $vers = "";
        if (length $d->{version}) {
            $vers = " ($d->{relation} $d->{version})";
        }
        if ($pkg eq "r") {
            # TODO: check if the available version of R satisfies this
            # for now, discard it, since we generate R (>= curver)
            say "W: Ignoring specified R dependency: $d";
            next;
        }

        # check if r-cran-pkg, r-bioc-pkg or r-other-pkg exists, and add it as a
        # dependency (or recommend/suggest)
        if (exists $apthash{"r-cran-$pkg\n"}) {
            say "I: Using r-cran-$pkg for $field:$d";
            push (@deps, "r-cran-$pkg$vers");
        } elsif (exists $apthash{"r-bioc-$pkg\n"}) {
            say "I: Using r-bioc-$pkg for $field:$d";
            push (@deps, "r-bioc-$pkg$vers");
        } elsif (exists $apthash{"r-other-$pkg\n"}) {
            say "I: Using r-other-$pkg for $field:$d";
            push (@deps, "r-other-$pkg$vers");
        } else {
            if ( $d !~ /libgdal-dev/ ) { # libgdal-dev is a packaged lib
              if ( $field =~ /Suggests/ ) {
                say "W: Cannot find a debian package for $field:$d";
              } else {
                $d =~ s/ +.*// ; # delete version if specified
# for some reason even in pbuilder www.cran.org can be reached by this test
#                my $cranurl = "http://www.cran.org";
#                if (! head($cranurl)) {
                if ( which('wnpp-check') ) {
                  say "W: Trying to create a package template for missing debian package for $field:$d.  This may take some time.";
                  print `prepare_missing_cran_package $d`;
                } else {
#                  say "W: Can not reach $cranurl this no attempt to create debian package for $field:$d.  Try rebuilding when beeing online.";
                  say "W: Please install devscripts to enable an attempt to create debian package for $field:$d.";
                }
              }
            }
        }
     }
    return @deps;
}

sub install {
    my $this = shift;
    my $destdir = shift;

    my $desc = $this->parse_description(); # key-value hash for the DESCRIPTION file
    my $srcctrl = Dpkg::Control::Info->new()->get_source();
    my $sourcepackage = $this->sourcepackage();

    my $testdepends = "";
    my @testdeps;
    if (-e "debian/tests/control") {
        my $tests = Dpkg::Control::Tests->new();
        $tests->load("debian/tests/control");
        foreach my $test ($tests->get()) {
            next unless $test->{Depends};

            $testdepends = deps_parse($test->{Depends}, use_arch => 0, tests_dep => 1);
        }
        foreach my $td (split(',', $testdepends)) {
            $td =~ s/^\s+|\s+$//g ;
            if ( $td =~ /^[a-z]/) {
                $td =~ s/^\s+|\s+$//g ;
                $td =~ s/r-cran-//g;
                $td  =~ s/r-bioc-//g;
                push @testdeps, $td ;
            }
        }
        $testdepends = join(", ", @testdeps);
        say "I: R packages needed for DEP8: $testdepends";
    }

    say "I: R Package: $desc->{Package} Version: $desc->{Version}";

    # Priority: Recommended should go in /library instead of /site-library
    my $libdir = "usr/lib/R/site-library";
    if (lc($desc->{Priority}) eq "recommended") {
        $libdir = "usr/lib/R/library";
        say "I: R package with Priority: $desc->{Priority}, installing in $libdir";
    }

    chomp(my $rbase_version = qx/dpkg-query -W -f='\${Version}' r-base-dev/);
    say "I: Building using R version $rbase_version";

    chomp(my $rapi_version = qx/dpkg-query -W -f='\${Provides}' r-base-core | grep -o 'r-api[^, ]*'/);
    say "I: R API version: $rapi_version";

    my $changelog_time = Dpkg::Changelog::Parse::changelog_parse()->{Date};
    say "I: Using built-time from d/changelog: $changelog_time";

    $this->doit_in_sourcedir("mkdir", "-p", "$destdir/$libdir");

    my @instargs;

    # Sometimes a package needs a running X server.  If xvfb is installed
    # use this to enable X11 displays.
    if ( -x "/usr/bin/xvfb-run" ) {
      ## xvfb-run with GL extension and default resolution
      my $xvfbSrvArgs="-screen 0 1024x768x24 -ac +extension GLX +render -noreset";
      push (@instargs, "xvfb-run", "--auto-servernum", "--server-num=20", "-s", $xvfbSrvArgs, "R", "CMD", "INSTALL", "-l", "$destdir/$libdir", "--clean");
    } else {
      push (@instargs, "R", "CMD", "INSTALL", "-l", "$destdir/$libdir", "--clean");
    }
    if (defined $ENV{RExtraInstallFlags}) {
        say "I: Using extra install flags: $ENV{RExtraInstallFlags}";
        push (@instargs, $ENV{RExtraInstallFlags});
    }
    push (@instargs, ".");
    push (@instargs, "--built-timestamp='$changelog_time'");

    $this->doit_in_sourcedir(@instargs);

    my @toremove = ("R.css", "COPYING", "COPYING.txt", "LICENSE", "LICENSE.txt");
    foreach my $rmf (@toremove) {
        if (-e "$destdir/$libdir/$desc->{Package}/$rmf") {
            $this->doit_in_sourcedir("rm", "-f", "$destdir/$libdir/$desc->{Package}/$rmf");
        }
    }

    # get all available r-* packages from which we can guess dependencies
    my @aptavail = qx/grep-aptavail -P -s Package -n -e ^r-/;
    my %apthash;
    @apthash{@aptavail} = ();

    my $recommendsinput = $desc->{Recommends};
    # Add DEP8 test dependencies to Recommends to enable running test suite once the package is installed
    if ( $testdepends ) {
       # remove $testdepends from $rsuggests
       my $newsuggests = "";
       foreach my $rs (split(',', $desc->{Suggests})) {
         $rs =~ s/^\s+|\s+$//g ;
         $rs =~ s/\n */ /g ;
         my $rsname = $rs ;
         $rsname =~ s/[\s(].*// ;
         if ( grep(/^$rsname$/i, @testdeps) ) {
           if ( $rs ne $rsname ) { # seems that is a versioned depends that needs to be propagated to Recommends
             $testdepends =~ s/$rsname */$rs/ ;
           }
         } else {
           $newsuggests = $newsuggests . ', ' . $rs ;
         }
       }
       $newsuggests =~ s/^, // ;
       $desc->{Suggests} = $newsuggests ;
       $recommendsinput = $recommendsinput . ', ' .  $testdepends ;
    }
    if ( ! $desc->{Depends} ) { $desc->{Depends} = ""; }
    if ( ! $desc->{Recommends} ) { $desc->{Recommends} = ""; }
    if ( ! $desc->{Suggests} ) { $desc->{Suggests} = ""; }
    if ( ! $desc->{Imports} ) { $desc->{Imports} = ""; }
    if ( ! $desc->{LinkingTo} ) { $desc->{LinkingTo} = ""; }
    my $rdepends = deps_concat(parse_depends("Depends", $desc->{Depends}, \%apthash));
    my $rrecommends = deps_concat(parse_depends("Recommends", $recommendsinput, \%apthash));
    my $rsuggests = deps_concat(parse_depends("Suggests", $desc->{Suggests}, \%apthash));
    my $rimports = deps_concat(parse_depends("Imports", $desc->{Imports}, \%apthash));
    my $rlinkingto = deps_concat(parse_depends("LinkingTo", $desc->{LinkingTo}, \%apthash));

    # For Bioconductor packages only, add a dependendy to a virtual r-api-bioc package
    #   to ensure that all installed bioconductor packages come from the same Bioconductor release.
    my $rprovides = "";
    my $rapibioc_version = "";
    if (length $desc->{biocViews}) {
        if (length $desc->{git_branch}) {

            my $bioc_version = $desc->{git_branch};

            if ($bioc_version eq "master") {
                say "W: The 'git_branch' field contains only 'master'";
                say "W: It is not possible to generate the r-api-bioc dependency";
            } else {
                $bioc_version =~ s/RELEASE_//;
                $bioc_version =~ s/_/./;
                $rapibioc_version = join "", "r-api-bioc-", $bioc_version;
                say "I: BioConductor API version: $rapibioc_version";

                # BiocGenerics (r-bioc-biocgenerics) is the main BioConductor package, it will provide the virtual r-api-bioc-xxx.
                # Whereas the other BioC packages will have a dependency to r-api-bioc-xxx.
                if ($desc->{Package} eq "BiocGenerics") {
                    $rprovides = $rapibioc_version;
                }
            }
        } else {
            say "W: Impossible to determine BioConductor release from DESCRIPTION file! Is there a 'git_branch' field?";
        }
    }

    my $depends = deps_concat("r-base-core (>= $rbase_version)", $rapi_version, $rapibioc_version, $rdepends, $rimports, $rlinkingto);

    my @allpackages = getpackages();
    my @all_r_packages = grep { /^r-(cran|bioc|other)-/ } @allpackages;
    my $first_r_package = @all_r_packages[0];
    say "I: Use $first_r_package as Debian binary package for variables substitution";

    open(my $svs, ">>", "debian/".$first_r_package.".substvars");
    say $svs "R:Depends=$depends";
    say $svs "R:Recommends=$rrecommends";
    say $svs "R:Suggests=$rsuggests";
    say $svs "R:Provides=$rprovides";
    close $svs;

}

1
