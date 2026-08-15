## ----------------------------------------------------------------------
## Makefile: makefile for debiandoc-sgml
## ----------------------------------------------------------------------

## ----------------------------------------------------------------------
## General directory definitions
prefix		:= /usr/local
bin_dir		:= $(DESTDIR)$(prefix)/bin
share_dir	:= $(DESTDIR)$(prefix)/share
ifeq ($(prefix),/usr/local)
man_dir		:= $(prefix)/man
else
man_dir		:= $(share_dir)/man
endif
ifeq ($(prefix),/usr/local)
perl_version	:= 5.8.2
perl_dir	:= $(share_dir)/perl/$(perl_version)
else
perl_dir	:= $(share_dir)/perl5
endif
sgml_dir	:= $(share_dir)/sgml

## ----------------------------------------------------------------------
## Manual pages directory definitions
man1		:= 1
man1_dir	:= $(man_dir)/man$(man1)

## ----------------------------------------------------------------------
## Package definitions
dtd_name	:= debiandoc
dtd_type	:= sgml
dtd_version	:= 1.0

## ----------------------------------------------------------------------
## Package SGML directory definitions
pkg_dtd_dir	:= $(sgml_dir)/$(dtd_name)/dtd/$(dtd_type)/$(dtd_version)
pkg_ent_dir	:= $(sgml_dir)/$(dtd_name)/entities

## ----------------------------------------------------------------------
## Package SGML file definitions
DTDS		:= catalog $(dtd_name).dtd $(dtd_name).dcl
ENTITIES	:= catalog $(dtd_name)-lat1 $(dtd_name)-lat2

## ----------------------------------------------------------------------
## Package tools directory definitions
pkg_perl_dir	:= $(perl_dir)/DebianDoc_SGML
pkg_format_dir	:= $(pkg_perl_dir)/Format
pkg_locale_dir	:= $(pkg_perl_dir)/Locale
pkg_map_dir	:= $(pkg_perl_dir)/Map
pkg_name 	:= $(dtd_name)-$(dtd_type)
pkg_bin_dir	:= $(share_dir)/$(pkg_name)

## ----------------------------------------------------------------------
## Package tools file definitions
FORMATS		:= HTML LaTeX Texinfo Text TextOV
XFORMATS	:= XML Wiki
SPECS		:= html latex texinfo text textov info latexdvi latexps latexpdf dbk wiki
PSPECS		:= dvi ps pdf
EXTS		:= html tex texinfo txt tov dbk wiki
BCONVS		:= $(foreach spec,$(SPECS),$(dtd_name)2$(spec))
PCONVS		:= $(foreach spec,$(PSPECS),$(dtd_name)2$(spec))
TOOLS		:= $(BCONVS) $(PCONVS)
MAN1S		:= $(pkg_name)
HELPERS		:= saspconvert fixlatex

## ----------------------------------------------------------------------
## General (un)install definitions
SHELL		:= bash
INSTALL		:= /usr/bin/install
INSTALL_DIR	:= $(INSTALL) -d -m 755
INSTALL_SCRIPT	:= $(INSTALL) -p -m 755
INSTALL_FILE	:= $(INSTALL) -p -m 644
LN		:= /bin/ln -sf
RM		:= /bin/rm -f
RMDIR		:= /bin/rmdir -p --ignore-fail-on-non-empty
DIFF		:= /usr/bin/diff -w -u

## ----------------------------------------------------------------------
## Targets
all:		bin

bin:		$(foreach bconv,$(BCONVS),tools/bin/$(bconv))

$(foreach bconv,$(BCONVS),tools/bin/$(bconv)): \
		tools/bin/template tools/bin/mkconversions

		set -e; \
		cd tools/bin; \
		./mkconversions $(pkg_format_dir) $(pkg_bin_dir); \
		cd -

install:	all

		set -e; \
		$(INSTALL_DIR) $(pkg_dtd_dir); \
		for f in $(DTDS); \
		do \
			$(INSTALL_FILE) sgml/dtd/$$f $(pkg_dtd_dir); \
		done

		set -e; \
		$(INSTALL_DIR) $(pkg_ent_dir); \
		for f in $(ENTITIES); \
		do \
			$(INSTALL_FILE) sgml/entities/$$f $(pkg_ent_dir); \
		done

		set -e; \
		$(INSTALL_DIR) $(pkg_format_dir); \
		for f in `ls tools/lib/Format/*.pm`; \
		do \
			$(INSTALL_FILE) $$f $(pkg_format_dir); \
		done

		set -e; \
		$(INSTALL_DIR) $(pkg_locale_dir); \
		for f in `ls tools/lib/Locale/*.pm`; \
		do \
			$(INSTALL_FILE) $$f $(pkg_locale_dir); \
		done
		for d in `ls -d tools/lib/Locale/*_*`; \
		do \
			$(INSTALL_DIR) $(pkg_locale_dir)/`basename $$d`; \
			for f in $(FORMATS); \
			do \
				$(INSTALL_FILE) $$d/$$f $(pkg_locale_dir)/`basename $$d`; \
			done; \
		done
		for d in `ls -d tools/lib/Locale/*_*`; \
		do \
			$(INSTALL_DIR) $(pkg_locale_dir)/`basename $$d`; \
			for f in $(XFORMATS); \
			do \
				$(INSTALL_FILE) tools/lib/Locale/$$f $(pkg_locale_dir)/`basename $$d`; \
			done; \
		done

		set -e; \
		$(INSTALL_DIR) $(pkg_map_dir); \
		for f in `ls tools/lib/Map/*.pm`; \
		do \
			$(INSTALL_FILE) $$f $(pkg_map_dir); \
		done

		set -e; \
		$(INSTALL_DIR) $(pkg_bin_dir); \
		for f in $(HELPERS); \
		do \
			$(INSTALL_SCRIPT) tools/bin/$$f $(pkg_bin_dir); \
		done

		set -e; \
		$(INSTALL_DIR) $(bin_dir); \
		for f in $(BCONVS); \
		do \
			$(INSTALL_SCRIPT) tools/bin/$$f $(bin_dir); \
		done
		for f in $(PSPECS); \
		do \
			$(LN) $(dtd_name)2latex$$f $(bin_dir)/$(dtd_name)2$$f; \
		done

		set -e; \
		$(INSTALL_DIR) $(man1_dir); \
		for f in $(MAN1S); \
		do \
			$(INSTALL_FILE) tools/man/$$f.$(man1) $(man1_dir)/$$f.$(man1); \
		done; \
		for f in $(TOOLS); \
		do \
			$(LN) $(firstword $(MAN1S)).$(man1) $(man1_dir)/$$f.$(man1); \
		done

uninstall:

		set -e; \
		for f in $(TOOLS); \
		do \
			$(RM) $(man1_dir)/$$f.$(man1); \
		done; \
		for f in $(MAN1S); \
		do \
			$(RM) $(man1_dir)/$$f.$(man1); \
		done

		set -e; \
		for f in $(TOOLS); \
		do \
			$(RM) $(bin_dir)/$$f; \
		done

		set -e; \
		for f in $(HELPERS); \
		do \
			$(RM) $(pkg_bin_dir)/$$f; \
		done; \
		$(RMDIR) $(pkg_bin_dir)

		set -e; \
		for f in `ls $(pkg_map_dir)/*.pm`; \
		do \
			$(RM) $$f; \
		done; \
		$(RMDIR) $(pkg_map_dir)

		set -e; \
		for d in `ls -d $(pkg_locale_dir)/*_*`; \
		do \
			d=`basename $$d`; \
			for f in $(FORMATS); \
			do \
				$(RM) $(pkg_locale_dir)/$$d/$$f; \
			done; \
			$(RMDIR) $(pkg_locale_dir)/$$d; \
		done; \
		for d in `ls -d $(pkg_locale_dir)/*_*`; \
		do \
			d=`basename $$d`; \
			for f in $(XFORMATS); \
			do \
				$(RM) $(pkg_locale_dir)/$$d/$$f; \
			done; \
			$(RMDIR) $(pkg_locale_dir)/$$d; \
		done; \
		for f in `ls $(pkg_locale_dir)/*.pm`; \
		do \
			$(RM) $$f; \
		done; \
		$(RMDIR) $(pkg_locale_dir)

		set -e; \
		for f in `ls $(pkg_format_dir)/*.pm`; \
		do \
			$(RM) $$f; \
		done; \
		$(RMDIR) $(pkg_format_dir)

		set -e; \
		for f in $(ENTITIES); \
		do \
			$(RM) $(pkg_ent_dir)/$$f; \
		done; \
		$(RMDIR) $(pkg_ent_dir)

		set -e; \
		for f in $(DTDS); \
		do \
			$(RM) $(pkg_dtd_dir)/$$f; \
		done; \
		$(RMDIR) $(pkg_dtd_dir)


# chack script changes against installled version if exists
# assunming this will be packaged vrsion of script in /usr
diff:		
	        $(MAKE) scripts.diff prefix=/usr

# chack script changes against installled version if exists
scripts.diff:	bin

		:> scripts.diff
		for f in $(BCONVS); \
		do \
			g=/usr/bin/$$f ;\
			if [ -e "$$g" ] ; then \
			$(DIFF) $$g tools/bin/$$f >> scripts.diff || true ;\
			fi ;\
		done

test:
		debian/test-debiandoc-sgml >XXXXX-sgml.log
		echo "#########################################################" > BUGS
		echo "### Known problems for building source with this tool ###" >> BUGS
		echo "#########################################################" >> BUGS
		grep -e '^FAIL: ' -e '^FAIR: ' XXXXX-sgml.log  >> BUGS

test1:
		: >XXXXX-sgml.log
		debian/test-debiandoc-sgml gl_ES.ISO8859-1 >>XXXXX-sgml.log
		debian/test-debiandoc-sgml gl_ES.ISO8859-15 >>XXXXX-sgml.log
		debian/test-debiandoc-sgml gl_ES.UTF-8 >>XXXXX-sgml.log
		debian/test-debiandoc-sgml ja_JP.UTF-8 >>XXXXX-sgml.log
		debian/test-debiandoc-sgml ja_JP.eucJP >>XXXXX-sgml.log
		debian/test-debiandoc-sgml ko_KR.UTF-8 >>XXXXX-sgml.log
		debian/test-debiandoc-sgml ko_KR.eucKR >>XXXXX-sgml.log
		#debian/test-debiandoc-sgml ru_RU.KOI8-R >>XXXXX-sgml.log
		debian/test-debiandoc-sgml sk_SK.ISO8859-2 >>XXXXX-sgml.log
		debian/test-debiandoc-sgml sk_SK.UTF-8 >>XXXXX-sgml.log
		debian/test-debiandoc-sgml zh_CN.GB2312 >>XXXXX-sgml.log
		debian/test-debiandoc-sgml zh_CN.UTF-8 >>XXXXX-sgml.log
		debian/test-debiandoc-sgml zh_TW.Big5  >>XXXXX-sgml.log
		debian/test-debiandoc-sgml zh_TW.UTF-8  >>XXXXX-sgml.log
		echo "#########################################################" > BUGS1
		echo "### Known problems for building source with this tool ###" >> BUGS1
		echo "#########################################################" >> BUGS1
		grep -e '^FAIL: ' -e '^FAIR: ' XXXXX-sgml.log  >> BUGS1

# target to check packages using this package is "usedby".
Sources:
	wget http://ftp.us.debian.org/debian/dists/sid/main/source/Sources.gz
	gunzip Sources.gz

usedby: Sources
	-F Build-Depends 'debiandoc-sgml' -o -F Build-Depends-Indep 'debiandoc-sgml' -s Package Sources

clean:
		$(RM) $(foreach bconv,$(BCONVS),tools/bin/$(bconv))
		rm -f scripts.diff ls-lr
		rm -f *.ps *.tmp *.pdf *.tex *.tpt *.sgml *aux *.txt
		rm -f *.toc *.dvi *.log *.out *.texinfo *.sasp *.info
		rm -rf *.sasp-wiki *.wiki BUGS*
		rm -rf *.html
		rm -f Sources

## ----------------------------------------------------------------------
# Use this target on devel branch source
package:
	debmake -t -y -zx -b':doc' -i pdebuild
