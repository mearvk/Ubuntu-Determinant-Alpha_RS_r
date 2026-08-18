ACLOCAL_AMFLAGS = -I m4
SUBDIRS = include lib doc src
EXTRA_DIST = mhash.spec.in mhash.spec
USE_MHASH_CONFIG = yes

ChangeLog:
	cvs2cl --utc --fsf -t -S --prune

if ENABLE_PKGCONFIG
mhash.pc:
	echo 'prefix=$(prefix)'			>  $@
	echo 'exec_prefix=$(exec_prefix)'	>> $@
	echo 'includedir=$(includedir)'		>> $@
	echo 'libdir=$(libdir)'			>> $@
	echo					>> $@
	echo 'Name: $(PACKAGE_TARNAME)'		>> $@
	echo 'Description: $(PACKAGE_NAME)'	>> $@
	echo 'URL: $(PACKAGE_URL)'		>> $@
	echo 'Version: $(PACKAGE_VERSION)'	>> $@
	echo 'Cflags: -I$(includedir)'		>> $@
	echo 'Libs: -L$(libdir) -lmhash'	>> $@
	echo 'Libs.private: $(LDFLAGS) $(LIBS)'	>> $@

pkgconfig_DATA = mhash.pc
endif

MOSTLYCLEAN = $(pkgconfig_DATA)
