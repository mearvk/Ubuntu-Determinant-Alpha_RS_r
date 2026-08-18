# Copyright © 2009 Matthew Johnson <mjj29@debian.org>
# Description: A class to build java packages
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License as
# published by the Free Software Foundation; either version 2, or (at
# your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA
# 02111-1307 USA.

_cdbs_scripts_path ?= /usr/lib/cdbs
_cdbs_rules_path ?= /usr/share/cdbs/1/rules
_cdbs_class_path ?= /usr/share/cdbs/1/class

ifndef _cdbs_class_javahelper
_cdbs_class_javahelper = 1

ifdef _cdbs_class_ant
$(error Must include javahelper.mk before ant.mk in your rules file)
endif

JH_BUILD=jh_build

include $(_cdbs_rules_path)/debhelper.mk$(_cdbs_makefile_suffix)

common-build-indep common-build-arch:: debian/jh_build_stamp
debian/jh_build_stamp:
	jh_linkjars
	$(JH_BUILD) -J $(JH_BUILD_ARGS) $(JH_BUILD_JAR) $(JH_BUILD_SRC)
	touch $@
clean::
	jh_clean
	rm -f debian/jh_build_stamp
	if [ -n "$(JH_BUILD_JAR)" ]; then rm -f $(JH_BUILD_JAR); fi

$(patsubst %,install/%,$(DEB_ALL_PACKAGES)) :: install/%:
	jh_installjavadoc -p$(cdbs_curpkg) $(JH_INSTALLJAVADOC_ARGS)
$(patsubst %,binary-post-install/%,$(DEB_ALL_PACKAGES)) :: binary-post-install/%:
	jh_installlibs -p$(cdbs_curpkg) $(JH_INSTALLLIBS_ARGS)
	jh_classpath -p$(cdbs_curpkg) $(JH_CLASSPATH_ARGS)
	jh_manifest -p$(cdbs_curpkg) $(JH_MANIFEST_ARGS)
	jh_exec -p$(cdbs_curpkg) $(JH_EXEC_ARGS)
	jh_depends -p$(cdbs_curpkg) $(JH_DEPENDS_ARGS)

endif # _cdbs_class_javahelper
