package Config::Model::Dpkg::Dependency ;

use 5.10.1;

use Config::Model 2.066; # for show_message

use Mouse;
use URI::Escape;

use feature qw/postderef signatures/;
no warnings qw/experimental::postderef experimental::signatures/;

# Debian only module
use lib '/usr/share/lintian/lib' ;
use Lintian::Relation ;

use DB_File ;
use Log::Log4perl qw(get_logger :levels);
use Module::CoreList;
use JSON;
use Path::Tiny;
use version ;

use Parse::RecDescent ;

# available only in debian. Black magic snatched from
# /usr/share/doc/libapt-pkg-perl/examples/apt-version
use AptPkg::Config '$_config';
use AptPkg::System '$_system';
use AptPkg::Version;
use AptPkg::Cache ;
use LWP::Simple ;

my $madison_host = 'api.ftp-master.debian.org';
my $madison_endpoint = "https://$madison_host/madison";

# list of virtual packages
# See https://www.debian.org/doc/packaging-manuals/virtual-package-names-list.yaml
# Last update: 2021-08-19
# wget -q -O- https://www.debian.org/doc/packaging-manuals/virtual-package-names-list.yaml | \
# perl -MYAML -e 'BEGIN {local $/=undef; $y = <>;} $yaml=Load($y); printf (" %s\n", $_->{name}) foreach @{$yaml->{virtualPackages}};' | \
# sort -u
my @virtual_list = qw/
 adventure
 audio-mixer
 awk
 boom-engine
 boom-wad
 c-compiler
 c-shell
 cron-daemon
 dbus-session-bus
 debconf-2.0
 default-dbus-session-bus
 default-logind
 dhcp-client
 dict-client
 dict-server
 dictd-dictionary
 doom-engine
 doom-wad
 dotfile-module
 emacsen
 flexmem
 fonts-japanese-gothic
 fonts-japanese-mincho
 foomatic-data
 fortran77-compiler
 ftp-server
 httpd
 httpd-cgi
 httpd-wsgi
 httpd-wsgi3
 ident-server
 imap-client
 imap-server
 inet-superserver
 info-browser
 ispell-dictionary
 java5-runtime
 java5-runtime-headless
 java6-runtime
 java6-runtime-headless
 java7-runtime
 java7-runtime-headless
 java8-runtime
 java8-runtime-headless
 java9-runtime
 java9-runtime-headless
 kernel-headers
 kernel-image
 kernel-source
 lambdamoo-core
 lambdamoo-server
 libc-dev
 linux-kernel-log-daemon
 logind
 lzh-archiver
 mail-reader
 mail-transport-agent
 mailx
 man-browser
 mpd-client
 myspell-dictionary
 news-reader
 news-transport-system
 pdf-preview
 pdf-viewer
 pgp
 pop3-server
 postscript-preview
 postscript-viewer
 radius-server
 rsh-client
 rsh-server
 scheme-ieee-11878-1900
 scheme-r4rs
 scheme-r5rs
 scheme-srfi-0
 scheme-srfi-55
 scheme-srfi-7
 stardict
 stardict-dictdata
 stardict-dictionary
 system-log-daemon
 tclsh
 telnet-client
 telnet-server
 time-daemon
 ups-monitor
 virtual-mysql-client
 virtual-mysql-client-core
 virtual-mysql-server
 virtual-mysql-server-core
 virtual-mysql-testsuite
 wish
 wordlist
 www-browser
 x-audio-mixer
 x-display-manager
 x-session-manager
 x-terminal-emulator
 x-window-manager
 xserver
/;

# other less official virtual packages
push @virtual_list, qw/
 debhelper-compat
 libkvm-dev
 libgl-dev
 libqt5opengl5-desktop-dev
 libtiff-dev
 libuv-dev
 ruby-interpreter
 perl-xs-dev
 ssh-client
 ssh-server
/;

my %virtual_hash = map {( $_ => 1); } @virtual_list;

sub _is_virtual ($pkg) {
    return 1 if $virtual_hash{$pkg};
    return 1 if $pkg =~ /^dh-sequence-[a-z0-9-]+$/;
    return 0;
}

my %debian_map;
my $version = \%Module::CoreList::version;

foreach my $v (values %$version) {
    foreach my $pm ( keys %$v ) {
        next unless defined $pm;
        my $k = lc($pm);
        $k =~ s/::/-/g;
        $debian_map{"lib$k-perl"} = $pm;
    }
}

my $logger = get_logger("Tree::Element::Value::Dependency") ;

# initialise the global config object with the default values
$_config->init;

# determine the appropriate system type
$_system = $_config->system;

# fetch a versioning system
my $vs = $_system->versioning;

my $apt_cache = AptPkg::Cache->new ;

# end of AptPkg black magic

extends qw/Config::Model::Value/ ;

my $grammar = << 'EOG' ;

{
    my @dep_errors ;
    my $add_error = sub {
        my ($err, $txt) = @_ ;
        push @dep_errors, "$err: '$txt'" ;
        return ; # to ensure production error
    } ;
    my $arch_list = qr/(any |alpha|amd64
         |arm(64|eb|el|hf)?
         |avr32 |hppa |i386 |ia64 |lpia |m32r |m68k
         |mips(el|64el|64)?
         |powerpc(el|spe)?
         |ppc64\b |ppc64el |s390x?
         |sh3\b |sh3eb |sh4\b |sh4eb |sparc\b |sparc64 |x32 )/x;
}

# comment this out when modifying the grammar
<nocheck>

dependency: { @dep_errors = (); } <reject>

dependency: depend(s /\|/) eofile {
    $return = [ 1 , @{$item[1]} ] ;
  }
  # accept anything that contain a variable, see #911756 and #702792
  | /.*\$\{[\w:\-]+\}.*/ { $return = [1, $item[1] ] ;}
  |  {
    push( @dep_errors, "Cannot parse: '$text'" ) unless @dep_errors ;
    $return =  [ 0, @dep_errors ];
  }

depend: pkg_name arch_qualifier(?) dep_version(?) arch_restriction(?) profile_restriction(s?) {
    my %ret = ( name => $item{pkg_name} );
    $ret{arch_qualifier}   = $item[2][0] if @{$item[2]};
    $ret{dep}              = $item[3][0] if @{$item[3]};
    $ret{arch_restriction} = $item[4][0] if @{$item[4]};
    $ret{profile}          = $item[5]    if @{$item[5]};
    $return = \%ret ;
}

# see https://wiki.debian.org/BuildProfileSpec
profile_restriction: '<' profile(s) '>' { $return = $item[2]; }

profile: not(?) profile_name profile_extention(?) {
  $return = join('', @{$item[1]}, $item{profile_name}, @{$item[3]});
}

profile_extention: '.' /[\w\-]+/ '.' /[\w-]+/ {
    $return = join('', @item[1..4]) ;
}

profile_name: 'cross' | 'pkg' | 'stage1'| 'stage2' |
   'nobiarch' | 'nocheck' | 'nodoc' | 'nogolang' | 'nojava' | 'noperl' | 'nopython' | 'noudeb' |
{
    my @a = ('cross', 'pkg', 'stage1', 'stage2',
            'nobiarch', 'nocheck', 'nodoc', 'nogolang', 'nojava', 'noperl', 'nopython', 'noudeb');
    my ($bad) = split / /, $text;
    $add_error->("Unknown build profile name '$bad'","Expected one of @a") ;
}

# see #911756
arch_qualifier: ':' arch_qualifier_name  { $return = $item[2]; }

arch_qualifier_name: 'native' | /$arch_list/x |
   /\S+/ { $add_error->("bad architecture qualifier", $item[1]) ;}

arch_restriction: '[' osarch(s) ']'
    {
        my $mismatch = 0;
        my $ref = $item[2] ;
        for (my $i = 0; $i < $#$ref -1 ; $i++ ) {
            $mismatch ||= ($ref->[$i][0] xor $ref->[$i+1][0]) ;
        }
        my @a = map { ($_->[0] || '') . ($_->[1] || '') . $_->[2] } @$ref ;
        if ($mismatch) {
            $add_error->("some names are prepended with '!' while others aren't.", "@a") ;
        }
        else {
            $return = \@a ;
        }
    }

dep_version: '(' oper version ')' { $return = [ $item{oper}, $item{version} ] ;}

pkg_name: /[a-z0-9][a-z0-9\+\-\.]+(?=[\s:([|]|\Z)/
    | /\S+/ { $add_error->("bad package name", $item[1]) ;}

oper: '<<' | '<=' | '=' | '>=' | '>>'
    | /\S+/ { $add_error->("bad dependency version operator", $item[1]) ;}

version: /[\w\.\-~:+]+(?=\s|\)|\Z)/
    | /\S+/ { $add_error->("bad dependency version", $item[1]) ;}

# valid arch are listed by dpkg-architecture -L
osarch: not(?) os(?) arch_restrict
    {
        $return =  [ $item[1][0], $item[2][0], $item[3] ];
    }

not: '!'

os: /(any|uclibc-linux|linux|kfreebsd|knetbsd|kopensolaris|hurd|darwin|freebsd|netbsd|openbsd|solaris|uclinux)
   -/x
   | /\w+/ '-' { $add_error->("bad os in architecture restriction", $item[1]) ;}

arch_restrict: / $arch_list
        (?=(\]| |$))
      /x
      | /\w+/ { $add_error->("bad arch in architecture restriction", $item[1]) ;}


eofile: /^\Z/

EOG

# extract installed version of debhelper
my $str = `/usr/bin/dpkg -l debhelper`;
my ($current_compat_value) = ($str =~ /ii\s+debhelper\s+(\d+)/);

if (not $current_compat_value) {
    die "debhelper package is not installed";
}

my $parser ;

after 'store' => sub {
    my $self = shift;
    my $data = $self->_fetch_no_check;
    if ( $data =~ /^debhelper-compat\s*\(\s*=\s*(\d+)\s*\)/ ) {
        $self->parent->fetch_element(accept_hidden => 1, name => "debhelper-version")->store($1);
    }
};

sub dep_parser {
    $parser ||= Parse::RecDescent->new($grammar) ;
    return $parser ;
}

# this method may recurse bad:
# check_dep -> meta filter -> control maintainer -> create control class
# autoread started -> read all fileds -> read dependency -> check_dep ...

around check_value => sub($orig, $self, @args) {
    my %args = @_ > 1 ? @args : (value => $args[0]) ;

    $args{fix} //= 0;
	# when fixing, $orig->() may modify $args{value} before calling back
    my ($ok, $value) = $orig->($self, %args) ;
    return $self->check_dependency(%args, value => $value, ok => $ok) ;
};

sub check_dependency ($self, %args){
    my ($value, $check, $silent, $notify_change, $ok, $apply_fix)
        = @args{qw/value check silent notify_change ok fix/} ;

    return ($ok, $value) if defined $check and $check eq 'no';

    # value is one dependency, something like "perl ( >= 1.508 )"
    # or exim | mail-transport-agent or gnumach-dev [hurd-i386]

    # see http://www.debian.org/doc/debian-policy/ch-relationships.html

    # to get package list in json format ( 'f' option)
    # wget -q -O - 'https://api.ftp-master.debian.org/madison?package=perl-doc&f'
    # mojo get 'https://api.ftp-master.debian.org/madison?package=perl-doc&f'

    my @dep_chain ;
    if (defined $value) {
        $logger->debug("calling check_depend with Parse::RecDescent with '$value' fix is $apply_fix");
        my $ret = dep_parser->dependency ( $value ) ;
        my $ok = shift @$ret ;
        if ($ok) {
            @dep_chain = @$ret ;
        }
        else {
            $self->add_error(@$ret) ;
        }
    }

    my $old = $value ;
    my @msgs;

    foreach my $dep (@dep_chain) {
        next unless ref($dep) ; # no need to check debhelper variables
        $self->check_or_fix_pkg_name($apply_fix, $dep, $old, \@msgs) ;
        $self->check_or_fix_too_old_pkg($apply_fix, $dep, $old, \@msgs) ;
		$self->check_or_fix_essential_package($apply_fix, $dep, \@msgs) ;
		$self->check_or_fix_dep($apply_fix, $dep, $old, \@msgs) ;
    }


	$self->check_depend_chain($apply_fix, \@dep_chain, $old, \@msgs) ;

    # "ideal" dependency is always computed, but it does not always change
    my $new = $self->struct_to_dep(@dep_chain);

    if ( $logger->is_debug ) {
        my $new_str = $new // '<undef>';
        no warnings 'uninitialized'; ## no critic (ProhibitNoWarnings)
        $logger->debug( "'$old' done" . ( $apply_fix ? " changed to '$new_str'" : '' ) );
    }

    {
        no warnings 'uninitialized'; ## no critic (ProhibitNoWarnings)
        my $msg = join('; ', @msgs);
        $self->_store_fix( $old, $new, $msg ) if $apply_fix and @msgs and $new ne $old;
    }
    return ($ok, $new) ;
}

sub check_debhelper_compat_version {
    my ($self, $apply_fix, $dep_info, $msgs) = @_ ;
    my ($oper, $dep_v) = @{ $dep_info->{dep} || []};

    if ( $self->check_compat_object() ) {
        $self->check_compat_object_value($apply_fix, $msgs);
    }

    # use the compat value mentioned in debhelper-compat dependency
    my $compat_value = defined $dep_v ? ($dep_v =~ s/~$//r) : undef;

    if (not defined $compat_value or $compat_value < $current_compat_value ) {
        if ($apply_fix) {
            $dep_info->{dep} = [ '=' , $current_compat_value ];
            my $msg = "changed debhelper-compat version dependency to $current_compat_value";
            $logger->info($msg);
            push $msgs->@*, $msg;
        }
        else {
            $self->{nb_of_fixes}++ ;
            my $str = defined $compat_value ? "too old ($compat_value)" : 'undefined';
            my $msg = "debhelper-compat dependency version is $str. It should be $current_compat_value";
            $self->add_warning( $msg );
            $logger->info("will warn: $msg (fix++)");
        }
    }
    return;
}

sub check_debhelper_version {
    my ($self, $apply_fix, $dep_info, $msgs) = @_ ;
    my ($oper, $dep_v) = @{ $dep_info->{dep} || []};

    return unless $self->check_compat_object();

    $self->check_compat_object_value($apply_fix, $msgs);

    # use the compat value mentioned in debhelper dependency
    my $original_compat_value = defined $dep_v ? ($dep_v =~ s/~$//r) : undef;

    # check if this value is current
    my $compat_value = $self->check_compat_value( $original_compat_value, $apply_fix, $msgs );

    # transform to new debhelper-compat dependency. We need to check
    # if it's necessary because this method is called by apply_fixes
    # until no fix can be applied.
    if ($dep_info->{name} eq 'debhelper') {
        if ($apply_fix) {
            $dep_info->{name} = 'debhelper-compat';
            $dep_info->{dep} = [ '=' , $compat_value ];
            my $msg = "changed debhelper dependency to debhelper dependency";
            $logger->info($msg);
            push $msgs->@*, $msg;
        }
        else {
            $self->{nb_of_fixes}++ ;
            my $msg = "debhelper dependency is deprecated. It should be a dependency for debhelper-compat package";
            $self->add_warning( $msg );
            $logger->info("will warn: $msg (fix++)");
        }
    }
    return;
}

sub check_compat_object ($self) {
    # try to create compat_obj, but do not try twice (hence the exists test)
    # compat_obj is undef when running with 'cme edit dpkg-control'
    if (not exists $self->{_compat_obj} ) {
        # using mode loose because debian-control model can be used alone
        # and compat is outside of debian-control
        my $c = $self->{_compat_obj} = $self->grab(mode => 'loose', step => "!Dpkg compat") ;
        $c->register_dependency($self) if defined $c;
    }
    return $self->{_compat_obj} ;
}

sub check_compat_object_value ($self, $apply_fix, $msgs) {
    my $compat_value = $self->{_compat_obj}->fetch;

    if (defined $compat_value) {
        if ($apply_fix) {
            $self->{_compat_obj}->clear;
            $logger->info("Cleared deprecated compat value");
            push $msgs->@*, "Cleared deprecated compat value";
        }
        else {
            $self->{nb_of_fixes}++ ;
            my $msg = "compat parameter is deprecated. "
                . "Please use debhelper-compat dependency. See debhelper(7) for details.";
            $self->add_warning( $msg );
            $logger->info("will warn: $msg (fix++)");
        }
    }
    return;
}

sub check_compat_value ($self, $compat_value, $apply_fix, $msgs) {

    if (not defined $compat_value or $compat_value < $current_compat_value - 1 ) {
        if ($apply_fix) {
            my $msg = "Set debhelper dependency version to $current_compat_value~";
            $logger->info($msg);
            push $msgs->@*, $msg;
            $compat_value = $current_compat_value;
        }
        else {
            $self->{nb_of_fixes}++ ;
            my $str = defined $compat_value ? "too old ($compat_value)" : 'undefined';
            my $msg = "debhelper dependency version is $str. It should be $current_compat_value";
            $self->add_warning( $msg );
            $logger->info("will warn: $msg (fix++)");
        }
    }
    return $compat_value;
}

sub struct_to_dep ($self, @input) {
    my @alternatives ;
    foreach my $d (@input) {
        my $line = '';

        # empty name is skipped
        if (ref $d) {
            my ($name, $dep,$arch, $prof) = @{$d}{qw/name dep arch profile/} ;
            if ($name) {
                $line .= $name;

                $line .= " (@$dep)" if defined $dep->[1];

                $line .= " [@$arch]" if $arch;

                if ($prof) {
                    foreach my $prof_or (@$prof) {
                        $line .= ' <'.join(' ',@$prof_or).'>';
                    }
                }
            }
        }
        else {
            $line .= $d;
        }
        push @alternatives, $line if $line ;
    }

    my $actual_dep = @alternatives ? join (' | ',@alternatives) : undef ;

    return $actual_dep ;
}

# @input contains the alternates dependencies (without '|') of one dependency values
# a bit like @input = split /|/, $dependency

# will modify @input (array of ref) when applying fix
sub check_depend_chain {
    my ($self, $apply_fix, $input, $old, $msgs) = @_ ;

    my $actual_dep = $self->struct_to_dep (@$input);
    my $ret = 1 ;

    return 1 unless defined $actual_dep; # may have been cleaned during fix
    $logger->debug("called with $actual_dep with apply_fix $apply_fix");

    foreach my $depend (@$input) {
        if (ref ($depend)) {
            # is a dependency (not a variable a la ${perl-Depends})
            my $dep_name = $depend->{name};
            my ($oper, $dep_v) = @{ $depend->{dep} || []};
            $logger->debug("scanning dependency $dep_name"
                .(defined $dep_v ? " $dep_v" : ''));
            if ($dep_name =~ /lib[\w+\-]+-perl/) {
                $ret &&= $self->check_perl_lib_dep ($apply_fix, $actual_dep, $depend, $input, $msgs);
                last;
            }
        }
    }

    if ($logger->is_debug and $apply_fix) {
        my $str = $self->struct_to_dep(@$input) ;
        $str //= '<undef>' ;
        $logger->debug("new dependency is $str");
    }

    return $ret ;
}


# called through check_depend_chain
# does modify $input when applying fix
sub check_perl_lib_dep {
    my ($self, $apply_fix, $actual_dep, $depend, $input, $msgs) = @_;
    my $dep_name = $depend->{name};
    my ($oper, $dep_v) = @{ $depend->{dep} || []};

    $logger->debug("called for $dep_name with $actual_dep with apply_fix $apply_fix");

    my @perl_dep = grep { $_->{name} =~ /^perl(?:-modules)?$/ } @$input;

    # The dependency of module shipped with perl core used to be in the form:
    # "perl (>= 5.10.1) | libtest-simple-perl (>= 0.88)".
    # This is no longer needed and simple dependency (possibly versioned) on the library
    # is enough.
    # See this thread: https://lists.debian.org/debian-perl/2019/01/msg00000.html

    # return if the dependency does not looks like an alternate perl module dependency
    return 1 unless @perl_dep;

    my @ideal_dep =  grep { $_->{name} !~ /^perl(?:-modules)?$/ } $input->@*;

    # $depend contains only the libmodule part of the alternate dependency
	my $ideal_dep = $self->struct_to_dep( @ideal_dep );

    die "Internal error: undefined ideal dep. Please report bug with the dependencies that triggered the bug"
        unless defined $ideal_dep;

	if ( $actual_dep ne $ideal_dep ) {
        my $msg = "Dual dependency on perl module should be removed. I.e it should be '$ideal_dep' not '$actual_dep'";
		if ($apply_fix) {
			@$input = @ideal_dep; # notify_change called in check_value
            if ($logger->is_info) {
                $logger->info("fixed dependency with: '$ideal_dep', was '$actual_dep'");
            }
            push $msgs->@*, $msg;
		}
		else {
			$self->{nb_of_fixes}++;
			$self->add_warning ($msg);
			$logger->info("will warn: $msg (fix++)");
		}
		return 0;
	}

    return 1 ;
}

sub check_versioned_dep {
    my ($self ,$dep_info) = @_ ;
    my $pkg = $dep_info->{name};
    my ($oper, $vers) = @{ $dep_info->{dep} || []};
    $logger->debug("called with '" . $self->struct_to_dep($dep_info) ."'") if $logger->is_debug;

    # special case to keep lintian happy
    return (1) if $pkg eq 'debhelper' ;

    # check if Debian has version older than required version
    my @dist_version = $self->get_available_version( $pkg) ;

	if ( @dist_version  # no older for unknow packages
		 and defined $oper
		 and $vers !~ /^\$/  # a dpkg variable
	 ) {
		return ($self->has_older_version_than ($pkg, $vers, \@dist_version ));
	}
	else {
		return (1) ;
	}
}

sub has_older_version_than {
    my ($self, $pkg, $vers, $dist_version ) = @_;

    my @list ;
    my $has_older = 0;
    while (@$dist_version) {
        my ($d,$v) = splice @$dist_version,0,2 ;

        push @list, "$d -> $v;" ;
        if ($d !~ /oldold/ and $vs->compare($vers,$v) > 0 ) {
            $has_older = 1 ;
        }
    }

    $logger->debug("$pkg $vers has_older is $has_older (@list)");

    return 1 if $has_older ;
    return (0,@list) ;
}

#
# New subroutine "check_essential_package" extracted - Thu Aug 30 14:14:32 2012.
#
sub check_or_fix_essential_package {
    my ( $self, $apply_fix, $dep_info, $msgs ) = @_;
    my $pkg = $dep_info->{name};
    my ($oper, $vers) = @{ $dep_info->{dep} || []};
    $logger->debug("called with '", scalar $self->struct_to_dep($dep_info), "' and fix $apply_fix") if $logger->is_debug;

    # Remove unversioned dependency on essential package (Debian bug 684208)
    # see /usr/share/doc/libapt-pkg-perl/examples/apt-cache

    my $cache_item = $apt_cache->get($pkg);
    my $is_essential = 0;
    $is_essential++ if (defined $cache_item and $cache_item->get('Flags') =~ /essential/i);

    if ($is_essential and not defined $oper) {
        $logger->debug( "found unversioned dependency on essential package: $pkg");
        my $msg = "unnecessary unversioned dependency on essential package: $pkg";
        if ($apply_fix) {
            %$dep_info = ();
            $logger->info("fix: removed unversioned essential dependency on $pkg");
            push $msgs->@*, $msg;
        }
        else {
            $self->add_warning($msg);
            $self->{nb_of_fixes}++;
            $logger->info("will warn: $msg (fix++)");
        }
    }
    return;
}


my %pkg_replace = (
    'perl-module' => 'perl' ,
) ;

sub check_or_fix_pkg_name {
    my ( $self, $apply_fix, $dep_info, $old, $msgs ) = @_;
    my $pkg = $dep_info->{name};

    $logger->debug("called with '", scalar $self->struct_to_dep($dep_info), "' and fix $apply_fix")
        if $logger->is_debug;

    my $new = $pkg_replace{$pkg} ;
    if ( $new ) {
        my $msg = "dubious package name: $pkg. Preferred package is $new";
        if ($apply_fix) {
            $logger->info("fix: changed package name from $pkg to $new");
            $dep_info->[0] = $pkg = $new;
            push $msgs->@*, $msg;
        }
        else {
            $self-> add_warning ($msg);
            $self->{nb_of_fixes}++;
            $logger->info("will warn: $msg (fix++)");
        }
    }

    # check if this package is defined in current control file
    if ($self->grab(step => "- - binary:$pkg", qw/mode loose autoadd 0/)) {
        $logger->debug("dependency $pkg provided in control file") ;
    }
    else {
        my @res = $self->get_available_version(  $pkg );
		if ( @res == 0 and not _is_virtual($pkg)) {
			# no version found for $pkg
			# don't know how to distinguish virtual package from source package
			$logger->debug("unknown package $pkg");
			$self->add_warning(
				"package $pkg is unknown. Check for typos if not a virtual package.");
		}
    }
    return;
}

sub check_or_fix_too_old_pkg ( $self, $apply_fix, $dep_info, $old, $msgs ) {
    my $pkg = $dep_info->{name};

    $logger->debug("called with '", scalar $self->struct_to_dep($dep_info), "' and fix $apply_fix")
        if $logger->is_debug;

    if (not defined $pkg) {
        # pkg may be cleaned up during fix
        return;
    }

    my @dist_version = $self->get_available_version( $pkg ) ;

    my $is_too_old = scalar @dist_version ? 1 : 0;
    while (@dist_version) {
        my ($d,$v) = splice @dist_version,0,2 ;
        $is_too_old = 0 unless $d =~ /oldold/;
    }

    if ($is_too_old) {
        $logger->debug("Found dependency on too old package: $pkg");
        my $msg = "applied on too old package: $pkg";
        if ($apply_fix) {
            %$dep_info = ();
            $logger->info("fix: removed relation with too old $pkg package");
            push $msgs->@*, $msg;
        }
        else {
            $self->add_warning($msg);
            $self->{nb_of_fixes}++;
            $logger->info("will warn: $msg (fix++)");
        }
    }
    return $is_too_old;
}

sub check_or_fix_dep {
    my ( $self, $apply_fix, $dep_info, $old, $msgs ) = @_;
    my $pkg = $dep_info->{name};

    $logger->debug("called with '", scalar $self->struct_to_dep($dep_info), "' and fix $apply_fix")
        if $logger->is_debug;

    if (not defined $pkg) {
        # pkg may be cleaned up during fix
        return;
    }

    # mess with debhelper compat only in Build dependencies
    if ( $self->element_name ne 'Depends' ) {
        if ($pkg eq 'debhelper' ) {
            return $self->check_debhelper_version( $apply_fix, $dep_info, $msgs );
        }

        if ( $pkg eq 'debhelper-compat' ) {
            return $self->check_debhelper_compat_version( $apply_fix, $dep_info, $msgs );
        }
    }

    my ( $vers_dep_ok, @list ) =  $self->check_versioned_dep( $dep_info );
    return if $vers_dep_ok;

    my ($warn_str, $log_str, $fix_sub);
    if ($dep_info->{dep}[0] =~ /</) {
        $warn_str = "unnecessary older-than versioned dependency: ". $self-> struct_to_dep($dep_info)
            . ". Debian has @list";
        $log_str = "removed dependency $dep_info->{name}";
        # the fix removes the whole dependency
        $fix_sub =  sub{ $_[0]->%* = () };
    }
    else {
        $warn_str = "unnecessary greater-than versioned dependency: ". $self-> struct_to_dep($dep_info)
            . ". Debian has @list";
        $log_str = "removed greater-than versioned dependency from $dep_info->{name}";
        # the fix removes greater-than versioned dep, notify_change is called in check_value
        $fix_sub = sub { delete $_[0]->{dep} };
    }
    $self->warn_or_fix_dep_info ($fix_sub, $apply_fix, $dep_info, $msgs, $warn_str, $log_str) ;
    return;
}


sub warn_or_fix_dep_info {
    my ( $self, $fix_sub, $apply_fix, $dep_info, $msgs, $warn_msg, $log_str ) = @_;

    if ($apply_fix) {
        $fix_sub->($dep_info);
        $logger->info("fix: $log_str");
        push $msgs->@*, $warn_msg;
    }
    else {
        $self->{nb_of_fixes}++;
        $self->add_warning( $warn_msg );
        $logger->info("will warn: $warn_msg (fix++)");
    }
    return;
}

use vars qw/%cache $use_test_cache/ ;

# Set up persistence
my $xdg_cache_dir = path($ENV{XDG_CACHE_HOME} || '~/.cache');

my $cache_file = $xdg_cache_dir->child('cme_dpkg_dependency') ;

# this condition is used during tests
if (not $use_test_cache) {
    # remove old cache file, this line can be removed in 2020
    path($ENV{HOME}.'/.config_model_depend_cache')->remove;

    tie %cache => 'DB_File', $cache_file->stringify,
}

# required to write data back to DB_File
END {
    untie %cache unless $use_test_cache;
}

my $cache_expire_date = time - 24 * 60 * 60 * 7 ;
sub get_available_version {
    my ($self, $pkg_name) = @_ ;

    # Store list of packages whose info could not be retrieved from madison
    # to avoid repeating error messages
    state %tried ;

    $logger->debug("called on $pkg_name");

    # don't query info for known or calculated virtual package
    if (_is_virtual($pkg_name)) {
        $logger->debug("$pkg_name is a known virtual package");
        return ();
    }

    # needed to test unknown package without network
    if (exists $cache{$pkg_name} and not defined $cache{$pkg_name}) {
        $logger->debug("$pkg_name is an unknown package (for test only)");
        return ();
    }

    my ($time,@res) = split / /, ($cache{$pkg_name} || '');
    if (defined $time and $time =~ /^\d+$/ and $time > $cache_expire_date ) {
        $logger->debug("using cached info for $pkg_name");
        return @res;
    }

    return () if $tried{$pkg_name};

    if ($0 =~ /\.t$/ and not $ENV{CME_UPDATE_TEST_CACHE}) {
        die "Cannot query madison during tests. Please ",
            "run this test with CME_UPDATE_TEST_CACHE set to 1 to update the package cache\n";
    }

    my $url = "$madison_endpoint?package=".uri_escape($pkg_name).'&f&b=deb' ;
    $self->instance->show_message("Connecting to $madison_host to check $pkg_name versions. Please wait...") ;
	my $body = get($url); # returns a json list
    my $res = [];
	if (defined $body) {
        my $ref = extract_madison_info($body);
        my $msg = $ref->{$pkg_name} ? 'info' : 'no info';
        $self->instance->show_message("got $msg for $pkg_name") ;
        $res = $ref->{$pkg_name} || [];
        $logger->debug("pkg info is @$res");
        # unknown package return an empty body, let's not retry twice the same unknown package.
        $tried{$pkg_name} = 1;
    }
    else {
        # HTTP error
        warn "cannot get data for package $pkg_name from $madison_endpoint.\n" unless defined $body ;
    }

	return $res->@*;
}


# this function queries *once* madison for package info not found in cache.
# it should be called once when parsing control file
sub cache_info_from_madison {
    my ($instance,@pkg_names) = @_ ;

    $logger->debug("called on @pkg_names");

    my $necessary = 0;
    my @needed;

    foreach my $pkg_name (@pkg_names) {
        next if _is_virtual($pkg_name) ; # skip known or calculated virtual package
        my ($time,@res) = split / /, ($cache{$pkg_name} || '');
        if (defined $time and $time =~ /^\d+$/ and $time > $cache_expire_date) {
            $logger->debug("using cached info for $pkg_name");
        }
        else {
            push @needed, $pkg_name;
            $necessary++;
        }
    }

    if (not $necessary) {
        return;
    }

    if ($0 =~ /\.t$/ and not $ENV{CME_UPDATE_TEST_CACHE}) {
        die "Cannot query madison during tests. Please ",
            "run this test with CME_UPDATE_TEST_CACHE set to 1 to update the package cache\n";
    }

    my $url = "$madison_endpoint?package=".uri_escape(join(' ',@needed)).'&f&b=deb' ;
    $instance->show_message(
        "Connecting to $madison_host to check ", scalar @needed, " package versions. Please wait..."
    );
	my $body = get($url);

	if (defined $body) {
        my $res = extract_madison_info($body);
        $instance->show_message( "Got info from $madison_host for ", scalar keys %$res, " packages.") ;
    }
    else {
        warn "cannot get data from madison. Check your proxy ?\n";
    }
    return;
}

# See https://ftp-master.debian.org/epydoc/dakweb.queries.madison-module.html
sub extract_madison_info ($json) {
	my %ref ;
    my $json_data = decode_json($json);
    my $data = $json_data->[0] ;

	foreach my $name ( keys $data->%* ) {
        my %avail;
        foreach my $dist (keys $data->{$name}->%*) {
            foreach my $available_v (keys $data->{$name}{$dist}->%*) {
                my $arches = $data->{$name}{$dist}{$available_v}{architectures};
                # see #841667: relevant pkg version is found in arch all or arch amd64
                my @keep = grep { $_ eq 'all' or $_ eq 'amd64'} $arches->@*;

                # except when a package is not delivered at all on amd64. See #875955
                if (not @keep) {
                    @keep = grep { $_ ne 'source' } $arches->@*;
                }

                # the same version may be available in several
                # distributions (testing and unstable are more likely
                # to have the same version for a package)
                $avail{$available_v} //= [];
                push $avail{$available_v}->@*, $dist, $available_v if @keep;
            }
        }

        # @res contains something like 'oldstable 5.10.1-17 stable 5.14.2-21 testing 5.18.1-3 unstable 5.18.1-4'
        my @res = map { $avail{$_}->@* ; } sort { $vs->compare($a,$b) } keys %avail ;

        if (not @res) {
            warn "ERROR: Could not extract useful info from madison for package $name. ",
                "Please report this issue using 'reportbug libconfig-model-dpkg-perl'\n";
            next;
        }

        $ref{$name} = \@res ;
        $cache{$name} = join(' ',time, @res) ;
	}

    return \%ref;
}

__PACKAGE__->meta->make_immutable;

1;

=head1 NAME

Config::Model::Dpkg::Dependency - Checks Debian dependency declarations

=head1 SYNOPSIS

 use Config::Model ;
 use Log::Log4perl qw(:easy) ;
 use Data::Dumper ;

 Log::Log4perl->easy_init($WARN);

 # define configuration tree object
 my $model = Config::Model->new ;
 $model ->create_config_class (
    name => "MyClass",
    element => [
        Depends => {
            'type'       => 'leaf',
            'value_type' => 'uniline',
            class => 'Config::Model::Dpkg::Dependency',
        },
    ],
 ) ;

 my $inst = $model->instance(root_class_name => 'MyClass' );

 my $root = $inst->config_root ;

 $root->load( 'Depends="libc6 ( >= 1.0 )"') ;
 # Connecting to qa.debian.org to check libc6 versions. Please wait ...
 # Warning in 'Depends' value 'libc6 ( >= 1.0 )': unnecessary
 # versioned dependency: >= 1.0. Debian has lenny-security ->
 # 2.7-18lenny6; lenny -> 2.7-18lenny7; squeeze-security ->
 # 2.11.2-6+squeeze1; squeeze -> 2.11.2-10; wheezy -> 2.11.2-10; sid
 # -> 2.11.2-10; sid -> 2.11.2-11;

=head1 DESCRIPTION

This class is derived from L<Config::Model::Value>. Its purpose is to
check the value of a Debian package dependency for the following:

=over

=item *

syntax as described in http://www.debian.org/doc/debian-policy/ch-relationships.html

=item *

Whether the version specified with C<< > >> or C<< >= >> is necessary.
This module checks with Debian server whether older versions can be
found in Debian old-stable or not. If no older version can be found, a
warning is issued (unless the package is known or calculated to be virtual)

=item *

Whether a Perl library is dual life. In this case the dependency is checked according to
L<Debian Perl policy|http://pkg-perl.alioth.debian.org/policy.html#debian_control_handling>.
Because Debian auto-build systems (buildd) will use the first available alternative,
the dependency should be in the form :

=over

=item *

C<< perl (>= 5.10.1) | libtest-simple-perl (>= 0.88) >> when
the required perl version is available in sid. ".

=item *

C<< libcpan-meta-perl | perl (>= 5.13.10) >> when the Perl version is not available in sid

=back

=back

=head1 Cache

Queries to Debian server are cached in C<~/.config_model_depend_cache>
for about one month.

=head1 BUGS

=over

=item *

Dependencies containing variables (e.g. C<${foo}>) are accepted
as-is. No check are performed.

=item *

Virtual package names are found scanning local apt cache. Hence an unknown package
on your system may be a virtual package on another system.

=item *

More advanced checks can probably be implemented. The author is open to
new ideas. He's even more open to patches (with tests).

=back

=head1 AUTHOR

Dominique Dumont, ddumont [AT] cpan [DOT] org

=head1 SEE ALSO

L<Config::Model>,
L<Config::Model::Value>,
L<Memoize>,
L<Memoize::Expire>
