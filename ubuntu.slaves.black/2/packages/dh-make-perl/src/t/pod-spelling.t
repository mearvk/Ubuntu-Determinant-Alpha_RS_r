use Test::More;
plan skip_all => "This is a release-time test" unless $ENV{RELEASE_TESTING};

eval "use Test::Spelling";
plan skip_all => "Test::Spelling required for testing POD spelling"
    if $@;

eval "use Pod::Wordlist";
plan skip_all => "Pod::Wordlist required for testing POD spelling"
    if $@;

add_stopwords(<DATA>);

all_pod_files_spelling_ok();

__DATA__
Ansgar
Axel
BTS
Bamber
Beckert
Bengen
Betts
Bonaccorso
Brockschmidt
Burchardt
Carn
Carnë
Chantreux
DEBEMAIL
DEBFULLNAME
DPKG
Damyan
DhMakePerl
Dima
Draug
Fermin
Flanigan
Gabeler
Galan
Gashev
Gass
Gergely
Gorwits
Gregor
Herrmann
Hilko
Hoskin
INDEP
ITA
ITP
ITPBUG
Ivanov
Jesper
Joncourt
Juerd
Kees
Kogan
Krogh
Kurz
LOGNAME
Lichtenheld
MODULEs
Maddy
Moerch
Molaro
Morano
Morrott
NB
Niebur
Nijkes
Oberholtzer
PACKAGENAME
PCRE
PL
Paleino
Paolo
Pashley
Pentchev
RFA
RFH
RFP
Retout
Shapira
Sjoegren
Susano
TODO
Testsuite
Uploaders
VCS
WNPP
amd
backporting
bak
basepkgs
bdepends
bdependsi
cfg
conf
debhelper
debian
debianisation
dep
deps
desc
dh
dir
dist
dpkg
dsc
fakeroot
foo
ge
gregor
herrmann
homedir
libfoo
libperl
libversion
min
nocheck
notest
org
packagename
pbuilder
pkg
pm
quotewords
rebuildable
rel
requiredeps
textblock
ttl
ustream
vcs
ver
versioned
