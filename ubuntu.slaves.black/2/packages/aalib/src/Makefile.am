#AUTOMAKE_OPTIONS = foreign #include-deps
# Debian mod: don't autorecurse to doc directory; debian/rules runs its
# targets seperatly.
SUBDIRS=src man
EXTRA_DIST = README.OS2 ANNOUNCE aalib.lsm acconfig.h aalib.m4
bin_SCRIPTS = aalib-config
m4datadir = $(datadir)/aclocal
m4data_DATA = aalib.m4
